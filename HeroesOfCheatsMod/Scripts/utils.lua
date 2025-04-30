--[[
    Core Utility Functions
    Contains helpers for object finding, name retrieval, inheritance checks,
    and safe property modification.
--]]
local config = require("config")

local M = {}

-- Cached Player Pawn reference
local cachedPlayerPawn = nil

-- Safely gets Class FName and Object Full Name for a UObject.
function M.GetObjectNames(obj)
    local names = { ClassFName = "[Invalid Object]", ObjectFullName = "[Invalid Object]" }
    if not obj or not obj:IsValid() then return names end
    names.ClassFName = "[Error:GetClass]"; names.ObjectFullName = "[Error:GetFullName(Obj)]"
    local successClass, classObj = pcall(function() return obj:GetClass() end)
    if successClass and classObj and classObj:IsValid() then local s, r = pcall(function() return classObj:GetFName():ToString() end); if s then names.ClassFName = r end end
    local s, r = pcall(function() return obj:GetFullName() end); if s then names.ObjectFullName = r end
    return names
end

-- Finds and caches the local player's pawn. Returns the pawn object or nil.
function M.GetPlayerPawn()
    -- Use cache if valid and class matches
    if cachedPlayerPawn and cachedPlayerPawn:IsValid() then
        -- Re-verify class name in case the cached object changed unexpectedly
        local success, classObj = pcall(function() return cachedPlayerPawn:GetClass() end)
        if success and classObj and classObj:IsValid() then
            local s, currentClassName = pcall(function() return classObj:GetFName():ToString() end)
            if s and currentClassName == config.requiredPlayerClassName then
                 return cachedPlayerPawn
            end
        end
        -- Invalidate cache if checks fail
        cachedPlayerPawn = nil
    end

    -- Find pawn via controller if cache is invalid or missing
    cachedPlayerPawn = nil -- Ensure reset before find attempt
    local PlayerController = FindFirstOf("PlayerController")
    if not PlayerController or not PlayerController:IsValid() then return nil end

    -- Try AcknowledgedPawn first, then Pawn
    local Pawn = PlayerController.AcknowledgedPawn
    if not Pawn or not Pawn:IsValid() then Pawn = PlayerController.Pawn end
    if not Pawn or not Pawn:IsValid() then return nil end

    -- Verify the found Pawn's class
    local pawnNames = M.GetObjectNames(Pawn)
    if pawnNames.ClassFName == config.requiredPlayerClassName then
        cachedPlayerPawn = Pawn
        return cachedPlayerPawn
    end

    return nil -- Found pawn was not the correct class
end


-- Gets the currently equipped weapon object, checking inheritance.
function M.GetEquippedRangedWeapon()
    local playerPawn = M.GetPlayerPawn()
    if not playerPawn then return nil end

    -- Safely access ActiveEquipable
    local weapon = nil
    local success, equipped = pcall(function() return playerPawn.ActiveEquipable end)
    if not success or not equipped or not equipped:IsValid() then return nil end
    weapon = equipped

    -- Use DoesInheritFrom for robust type checking
    if M.DoesInheritFrom(weapon, config.requiredWeaponBaseClassName) then
        return weapon
    end

    return nil -- Equipped item is not a recognized Ranged Weapon
end

-- Gets the vehicle the player pawn is currently operating, if any.
function M.GetCurrentVehicle()
    local playerPawn = M.GetPlayerPawn()
    if not playerPawn then return nil end

    -- Access the VehicleRef property safely
    local vehicleRef = nil
    local success, vehicle = pcall(function() return playerPawn.VehicleRef end)

    if success and vehicle and vehicle:IsValid() then
        -- Check if the vehicle itself inherits from a base (optional, could be too generic)
        -- For now, just return the valid reference. Type checks happen in feature logic.
        vehicleRef = vehicle
    end

    return vehicleRef
end

-- Checks if a UObject's class inherits from a specific base class name by walking the super class chain.
function M.DoesInheritFrom(targetObject, baseClassName)
    if not targetObject or not targetObject:IsValid() or not baseClassName then return false end

    local targetClass = nil
    local sClass, tc = pcall(function() return targetObject:GetClass() end)
    if not (sClass and tc and tc:IsValid()) then return false end -- Cannot check type without a valid class object
    targetClass = tc

    local currentClass = targetClass
    local iteration = 0
    local maxIterations = 15 -- Safety limit for deep hierarchies or potential loops

    while currentClass and currentClass:IsValid() and iteration < maxIterations do
        local currentClassName = ""
        local sName, cName = pcall(function() return currentClass:GetFName():ToString() end)
        if sName then currentClassName = cName end

        if currentClassName == baseClassName then return true end -- Found the base class in the hierarchy

        -- Get the parent class
        local sSuper, superClass = pcall(function() return currentClass:GetSuperStruct() end)
        if sSuper and superClass and superClass:IsValid() then
            currentClass = superClass
        else
            currentClass = nil -- End of chain or error
        end
        iteration = iteration + 1
    end

    return false -- Reached end of chain or max iterations without finding the base class
end


-- Generic function to safely apply a property change, optimizing by checking current value.
function M.ApplyPropertyChange(propertyName, enabledValue, disabledValue, isCurrentlyEnabled, targetObject, objectNameForLog)
    objectNameForLog = objectNameForLog or "TargetObject" -- Provide a default log name
    if not targetObject or not targetObject:IsValid() then
        -- Optionally log failure: print(string.format("[HeroesOfCheatsMod Utils WARN] ApplyPropertyChange failed: Invalid target object for %s.%s", objectNameForLog, propertyName))
        return false
    end

    local targetValue = isCurrentlyEnabled and enabledValue or disabledValue
    local shouldSet = true

    -- Check current value to avoid redundant sets
    local successGet, currentValue = pcall(function() return targetObject[propertyName] end)
    if successGet and currentValue ~= nil then
        local tolerance = 0.001 -- Tolerance for floating-point comparisons
        local valuesMatch = false
        if type(targetValue) == "number" and type(currentValue) == "number" then
            valuesMatch = math.abs(targetValue - currentValue) < tolerance
        elseif type(targetValue) == type(currentValue) then
             -- Direct comparison for non-numeric types (bool, string, etc.)
            valuesMatch = (currentValue == targetValue)
        -- else: types differ, always attempt set
        end

        if valuesMatch then
            shouldSet = false -- Don't set if value is already correct
        end
    -- else: failed to get current value, assume we need to set it
    end

    if not shouldSet then return true end -- Return success as the value is already as desired

    -- Attempt to set the property
    local successSet, errorMsg = pcall(function() targetObject[propertyName] = targetValue end)
    if not successSet then
        -- Log error on failure
        local objInfo = M.GetObjectNames(targetObject)
        print(string.format("[HeroesOfCheatsMod Utils ERROR] Failed to set %s.%s on %s (Class: %s). Details: %s",
            objectNameForLog, propertyName, objInfo.ObjectFullName, objInfo.ClassFName, tostring(errorMsg)))
        return false
    end

    return true -- Successfully set the property
end


return M