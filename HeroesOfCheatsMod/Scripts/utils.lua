--[[
    Core Utility Functions
    Contains helpers for object finding, name retrieval, inheritance checks,
    and safe property modification. Caches player pawn and possessed vehicle,
    requires external invalidation via hooks for stability.
--]]
local config = require("config")

local M = {}

-- Cached references - Necessary for performance.
---@type ABP_Character_C | nil
local cachedPlayerPawn = nil
---@type ABP_VehicleBase_C | nil
local cachedPossessedVehicle = nil

-- Function to invalidate all relevant caches, called by hooks.
function M.InvalidateCaches()
    -- print("[Utils] Invalidating Caches") -- Optional debug
    cachedPlayerPawn = nil
    cachedPossessedVehicle = nil
end

-- Safely gets Class FName and Object Full Name for a UObject.
function M.GetObjectNames(obj)
    local names = { ClassFName = "[Invalid Object]", ObjectFullName = "[Invalid Object]" }
    if not obj or not obj:IsValid() then return names end
    names.ClassFName = "[Error:GetClass]"; names.ObjectFullName = "[Error:GetFullName(Obj)]"
    local successClass, classObj = pcall(function() return obj:GetClass() end)
    if successClass and classObj and classObj:IsValid() then
        local s, r = pcall(function() return classObj:GetFName():ToString() end); if s then names.ClassFName = r end
    end
    local s, r = pcall(function() return obj:GetFullName() end); if s then names.ObjectFullName = r end
    return names
end

-- Finds and caches the local player's CHARACTER pawn. Returns nil if player is in vehicle.
---@return ABP_Character_C | nil
function M.GetPlayerPawn()
    -- Use cache if valid
    if cachedPlayerPawn and cachedPlayerPawn:IsValid() then
        return cachedPlayerPawn
    end

    -- Cache miss or invalid, perform lookup
    cachedPlayerPawn = nil -- Invalidate before search
    local PlayerController = FindFirstOf("PlayerController")
    if not PlayerController or not PlayerController:IsValid() then return nil end

    local Pawn = PlayerController.AcknowledgedPawn
    if not Pawn or not Pawn:IsValid() then Pawn = PlayerController.Pawn end
    if not Pawn or not Pawn:IsValid() then return nil end

    local pawnNames = M.GetObjectNames(Pawn)
    if pawnNames.ClassFName == config.requiredPlayerClassName then
        cachedPlayerPawn = Pawn ---@cast Pawn ABP_Character_C
        cachedPossessedVehicle = nil -- If we found the character, clear the vehicle cache
        return cachedPlayerPawn
    end

    -- Possessed pawn is not the character
    return nil
end

-- Gets the currently equipped weapon object, checking inheritance. Relies on GetPlayerPawn.
---@return ABP_RangedWeaponBase_C | nil
function M.GetEquippedRangedWeapon()
    local playerPawn = M.GetPlayerPawn()
    if not playerPawn then return nil end

    local weapon = nil
    local success, equipped = pcall(function() return playerPawn.ActiveEquipable end)
    if not success or not equipped or not equipped:IsValid() then return nil end
    weapon = equipped ---@cast weapon ABP_EquipableBase_C

    if M.DoesInheritFrom(weapon, config.requiredWeaponBaseClassName) then
         return weapon ---@cast weapon ABP_RangedWeaponBase_C
    end
    return nil
end

-- Gets the pawn currently possessed by the player *if* it's a vehicle, using caching.
---@return ABP_VehicleBase_C | nil
function M.GetCurrentlyPossessedVehicle()
    -- Use cache if valid
    if cachedPossessedVehicle and cachedPossessedVehicle:IsValid() then
        return cachedPossessedVehicle
    end

    -- Cache miss or invalid, perform lookup
    cachedPossessedVehicle = nil -- Invalidate before search
    local PlayerController = FindFirstOf("PlayerController")
    if not PlayerController or not PlayerController:IsValid() then return nil end

    local CurrentPawn = PlayerController.AcknowledgedPawn
    if not CurrentPawn or not CurrentPawn:IsValid() then CurrentPawn = PlayerController.Pawn end
    if not CurrentPawn or not CurrentPawn:IsValid() then return nil end

    if M.DoesInheritFrom(CurrentPawn, config.requiredVehicleBaseClassName) then
        cachedPossessedVehicle = CurrentPawn ---@cast CurrentPawn ABP_VehicleBase_C
        cachedPlayerPawn = nil -- If we found a vehicle, clear the character cache
        return cachedPossessedVehicle
    end

    -- Possessed pawn is not a vehicle
    return nil
end

-- Checks if a UObject's class inherits from a specific base class name by walking the super class chain.
function M.DoesInheritFrom(targetObject, baseClassName)
    if not targetObject or not targetObject:IsValid() or not baseClassName then return false end

    ---@type UClass | nil
    local targetClass = nil
    local sClass, tc = pcall(function() return targetObject:GetClass() end)
    if not (sClass and tc and tc:IsValid()) then return false end -- Cannot check type without a valid class object
    targetClass = tc

    ---@type UClass | nil
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