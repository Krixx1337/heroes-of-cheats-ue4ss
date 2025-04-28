--[[
    Core Utility Functions
    Contains helpers for object finding, name retrieval, and safe property modification.
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
    if cachedPlayerPawn and cachedPlayerPawn:IsValid() then
        if M.GetObjectNames(cachedPlayerPawn).ClassFName == config.requiredPlayerClassName then return cachedPlayerPawn
        else cachedPlayerPawn = nil end end -- Invalidate cache if class mismatch
    cachedPlayerPawn = nil
    local PlayerController = FindFirstOf("PlayerController")
    if not PlayerController or not PlayerController:IsValid() then return nil end
    local Pawn = PlayerController.AcknowledgedPawn; if not Pawn or not Pawn:IsValid() then Pawn = PlayerController.Pawn; if not Pawn or not Pawn:IsValid() then return nil end end
    if M.GetObjectNames(Pawn).ClassFName == config.requiredPlayerClassName then cachedPlayerPawn = Pawn; return cachedPlayerPawn end
    return nil
end

-- Gets the currently equipped weapon object, checking inheritance via FName hierarchy walk.
function M.GetEquippedRangedWeapon()
    local playerPawn = M.GetPlayerPawn()
    if not playerPawn then return nil end

    local weapon = nil; local success, equipped = pcall(function() return playerPawn.ActiveEquipable end)
    if not success or not equipped or not equipped:IsValid() then return nil end
    weapon = equipped

    local requiredBaseClassNameStr = config.requiredWeaponBaseClassName
    local currentClass = nil; local sClass, wc = pcall(function() return weapon:GetClass() end)
    if not (sClass and wc and wc:IsValid()) then return nil end -- Cannot check type without class
    currentClass = wc

    local isWeaponType = false; local iteration = 0; local maxIterations = 10
    while currentClass and currentClass:IsValid() and iteration < maxIterations do
        local currentClassName = ""; local sName, cName = pcall(function() return currentClass:GetFName():ToString() end); if sName then currentClassName = cName end
        if currentClassName == requiredBaseClassNameStr then isWeaponType = true; break end
        local sSuper, superClass = pcall(function() return currentClass:GetSuperStruct() end); if sSuper and superClass and superClass:IsValid() then currentClass = superClass else currentClass = nil end
        iteration = iteration + 1
    end

    if isWeaponType then return weapon else return nil end
end

-- Generic function to safely apply a property change with optimization check.
function M.ApplyPropertyChange(propertyName, enabledValue, disabledValue, isCurrentlyEnabled, targetObject, objectNameForLog)
    objectNameForLog = objectNameForLog or "Target Object"
    if not targetObject or not targetObject:IsValid() then return false end
    local targetValue = isCurrentlyEnabled and enabledValue or disabledValue
    local shouldSet = true; local successGet, currentValue = pcall(function() return targetObject[propertyName] end)
    if successGet and currentValue ~= nil then
        local tolerance = 0.001; local valuesMatch = false
        if type(targetValue) == "number" and type(currentValue) == "number" then valuesMatch = math.abs(targetValue - currentValue) < tolerance
        elseif type(targetValue) == type(currentValue) then valuesMatch = (currentValue == targetValue) end
        if valuesMatch then shouldSet = false end end
    if not shouldSet then return true end
    local successSet, errorMsg = pcall(function() targetObject[propertyName] = targetValue end)
    if not successSet then print(string.format("[HeroesOfCheatsMod] ERROR: Failed to set %s.%s on %s! Details: %s", objectNameForLog, propertyName, M.GetObjectNames(targetObject).ObjectFullName, tostring(errorMsg))); return false end
    return true
end

return M