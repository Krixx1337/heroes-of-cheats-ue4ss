--[[
    Core Utility Functions
    Contains helpers for object finding, name retrieval, inheritance checks,
    and safe property modification. Uses UEHelpers for PlayerController access.
--]]
local config = require("config")
local UEHelpers = require("UEHelpers") -- Require the UEHelpers module

local M = {}

-- Cached references - Performance critical. Validity managed externally.
-- UEHelpers internally caches the PlayerController.
---@type ABP_Character_C | nil
local cachedPlayerPawn = nil
---@type ABP_VehicleBase_C | nil
local cachedPossessedVehicle = nil

-- Function to invalidate all relevant caches, called by hooks.
function M.InvalidateCaches()
    -- Invalidate our local pawn and vehicle caches.
    cachedPlayerPawn = nil
    cachedPossessedVehicle = nil
    -- UEHelpers cache for PlayerController has its own lifecycle.
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
-- Relies on external invalidation and downstream checks for validity.
---@return ABP_Character_C | nil
function M.GetPlayerPawn()
    -- Use local cache if the pointer is still valid
    if cachedPlayerPawn and cachedPlayerPawn:IsValid() then
        return cachedPlayerPawn -- Trust the cached object if it's valid
    end

    -- Cache miss or object became invalid, perform lookup
    cachedPlayerPawn = nil -- Ensure cleared before assigning below

    local PlayerController = UEHelpers.GetPlayerController()
    if not PlayerController or not PlayerController:IsValid() then return nil end

    local Pawn = PlayerController.AcknowledgedPawn
    if not Pawn or not Pawn:IsValid() then Pawn = PlayerController.Pawn end
    if not Pawn or not Pawn:IsValid() then return nil end

    -- Perform class check ONLY during lookup
    if M.DoesInheritFrom(Pawn, config.requiredPlayerClassName) then
        cachedPlayerPawn = Pawn ---@cast Pawn ABP_Character_C
        cachedPossessedVehicle = nil -- Clear vehicle cache when pawn found
        return cachedPlayerPawn
    end

    -- Possessed pawn is not the character
    return nil
end

-- Safely gets the pawn's currently active equipable.
---@param pawn APawn | nil The pawn to check.
---@return ABP_EquipableBase_C | nil The equipable object or nil if invalid/not found.
function M.GetActiveEquipable(pawn)
    if not pawn or not pawn:IsValid() then return nil end

    local equipable = nil
    local successGetEquip, eq = pcall(function() return pawn.ActiveEquipable end)
    if successGetEquip and eq and eq:IsValid() then
        equipable = eq ---@cast equipable ABP_EquipableBase_C
    end
    return equipable
end

-- Gets the currently equipped weapon object IF it's a RangedWeaponBase.
-- Relies on GetPlayerPawn cache and GetActiveEquipable helper.
---@return ABP_RangedWeaponBase_C | nil
function M.GetEquippedRangedWeapon()
    local playerPawn = M.GetPlayerPawn() -- Uses cached pawn if available
    -- No need for IsValid check here, GetActiveEquipable handles nil pawn

    -- Use the helper function to get the generic equipable first
    local equipable = M.GetActiveEquipable(playerPawn)

    -- Check if the retrieved equipable is valid and the correct type
    if equipable and M.DoesInheritFrom(equipable, config.requiredWeaponBaseClassName) then
        return equipable ---@cast equipable ABP_RangedWeaponBase_C
    end

    -- Return nil if no equipable, not valid, or not a ranged weapon
    return nil
end

-- Gets the currently equipped item object IF it's a ThrowableBase.
---@return ABP_Throwablebase_C | nil
function M.GetActiveThrowable()
    local playerPawn = M.GetPlayerPawn()
    local equipable = M.GetActiveEquipable(playerPawn) -- Use helper

    -- Check if the retrieved equipable is valid and the correct type
    if equipable and M.DoesInheritFrom(equipable, config.requiredThrowableBaseClassName) then
        return equipable ---@cast equipable ABP_Throwablebase_C
    end

    -- Return nil if no equipable, not valid, or not a throwable
    return nil
end

-- Safely gets the CharacterMovement component from a pawn.
---@param pawn APawn | nil The pawn to check.
---@return UCharacterMovementComponent | nil The component object or nil if invalid/not found.
function M.GetCharacterMovementComponent(pawn) -- Renamed for clarity
    if not pawn or not pawn:IsValid() then return nil end

    local movementComponent = nil
    -- Standard UE ACharacter property name is 'CharacterMovement'
    local success, comp = pcall(function() return pawn.CharacterMovement end)
    if success and comp and comp:IsValid() then
        -- Cast might be slightly different depending on exact inheritance,
        -- but UCharacterMovementComponent is usually safe base type.
        movementComponent = comp ---@cast movementComponent UCharacterMovementComponent
    end
    return movementComponent
end

-- Gets the pawn currently possessed by the player *if* it's a vehicle, using caching.
-- Relies on external invalidation and downstream checks for validity.
---@return ABP_VehicleBase_C | nil
function M.GetCurrentlyPossessedVehicle()
    -- Use local cache if the pointer is still valid
    if cachedPossessedVehicle and cachedPossessedVehicle:IsValid() then
       return cachedPossessedVehicle -- Trust the cached object if it's valid
    end

    -- Cache miss or object became invalid, perform lookup
    cachedPossessedVehicle = nil -- Ensure cleared before assigning below

    local PlayerController = UEHelpers.GetPlayerController()
    if not PlayerController or not PlayerController:IsValid() then return nil end

    local CurrentPawn = PlayerController.AcknowledgedPawn
    if not CurrentPawn or not CurrentPawn:IsValid() then CurrentPawn = PlayerController.Pawn end
    if not CurrentPawn or not CurrentPawn:IsValid() then return nil end

    -- Perform class check ONLY during lookup
    if M.DoesInheritFrom(CurrentPawn, config.requiredVehicleBaseClassName) then
        cachedPossessedVehicle = CurrentPawn ---@cast CurrentPawn ABP_VehicleBase_C
        cachedPlayerPawn = nil -- Clear character cache when vehicle found
        return cachedPossessedVehicle
    end

    -- Possessed pawn is not a vehicle
    return nil
end

-- Checks if a UObject's class inherits from a specific base class name by walking the super class chain.
function M.DoesInheritFrom(targetObject, baseClassName)
    if not targetObject or not targetObject:IsValid() or not baseClassName then return false end
    local targetClass = nil
    local sClass, tc = pcall(function() return targetObject:GetClass() end)
    if not (sClass and tc and tc:IsValid()) then return false end
    targetClass = tc
    local currentClass = targetClass
    local iteration = 0
    local maxIterations = 15
    while currentClass and currentClass:IsValid() and iteration < maxIterations do
        local currentClassName = ""
        local sName, cName = pcall(function() return currentClass:GetFName():ToString() end)
        if sName then currentClassName = cName end
        if currentClassName == baseClassName then return true end
        local sSuper, superClass = pcall(function() return currentClass:GetSuperStruct() end)
        if sSuper and superClass and superClass:IsValid() then
            currentClass = superClass
        else
            currentClass = nil
        end
        iteration = iteration + 1
    end
    return false
end

-- Generic function to safely apply a property change, optimizing by checking current value.
function M.ApplyPropertyChange(propertyName, enabledValue, disabledValue, isCurrentlyEnabled, targetObject, objectNameForLog)
    objectNameForLog = objectNameForLog or "TargetObject"
    if not targetObject or not targetObject:IsValid() then
        return false
    end
    local targetValue = isCurrentlyEnabled and enabledValue or disabledValue
    local shouldSet = true
    local successGet, currentValue = pcall(function() return targetObject[propertyName] end)
    if successGet and currentValue ~= nil then
        local tolerance = 0.001
        local valuesMatch = false
        if type(targetValue) == "number" and type(currentValue) == "number" then
            valuesMatch = math.abs(targetValue - currentValue) < tolerance
        elseif type(targetValue) == type(currentValue) then
            valuesMatch = (currentValue == targetValue)
        end
        if valuesMatch then
            shouldSet = false
        end
    end
    if not shouldSet then return true end
    local successSet, errorMsg = pcall(function() targetObject[propertyName] = targetValue end)
    if not successSet then
        local objInfo = M.GetObjectNames(targetObject)
        print(string.format("[HeroesOfCheatsMod Utils ERROR] Failed to set %s.%s on %s (Class: %s). Details: %s",
            objectNameForLog, propertyName, objInfo.ObjectFullName, objInfo.ClassFName, tostring(errorMsg)))
        return false
    end
    return true
end

return M