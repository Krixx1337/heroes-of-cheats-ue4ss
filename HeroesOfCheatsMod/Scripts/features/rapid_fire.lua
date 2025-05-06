--[[ Feature: Rapid Fire (Character & Plane) & Instant Reload (Character) ]]--
local utils = require("utils")
local config = require("config") -- Still needed for default values

local M = {}

-- Apply rapid fire effects to character/equipable or vehicle.
---@param playerPawn ABP_Character_C | nil
---@param possessedVehicle ABP_VehicleBase_C | nil
---@param currentWeapon ABP_RangedWeaponBase_C | nil -- Argument kept for signature consistency.
function M.Apply(playerPawn, possessedVehicle, currentWeapon)

    -- Handle Vehicle Logic (Planes)
    if possessedVehicle and possessedVehicle:IsValid() and utils.DoesInheritFrom(possessedVehicle, config.requiredPlaneBaseClassName) then
        ---@type ABP_PlaneBase_C
        local plane = possessedVehicle
        -- Apply instant bomb reload effect (using hardcoded 0.0 for enabled state)
        utils.ApplyPropertyChange("BombReloadTimer", 0.0, 0.0, true, plane, "Plane_RapidFire") -- Assuming 0.0 is also the default here for simplicity. Adjust if needed.
        utils.ApplyPropertyChange("BombReloading", false, false, true, plane, "Plane_RapidFire") -- Assuming false is also the default. Adjust if needed.
        return -- Exit early if handling vehicle
    end
    -- Note: Tank rapid fire is handled via LMB hook in keybinds.lua

    -- Handle Character & Equipable Logic
    if playerPawn and playerPawn:IsValid() then
        -- Apply character fire rate cooldown reduction (using hardcoded 0.01 for enabled state)
        utils.ApplyPropertyChange("FireRateCDMultiplier", 0.01, config.defaultFireRateCDMult, true, playerPawn, "PlayerPawn_RapidFire")

        -- Check for active Ranged Weapon or Throwable
        local rangedWeapon = utils.GetEquippedRangedWeapon()
        local throwable = utils.GetActiveThrowable()

        if rangedWeapon then
            -- Attempt instant reload if the weapon is currently being used
            local isWeaponInUse = false
            local successReadUsing, usingStatus = pcall(function() return rangedWeapon.Using end)
            if successReadUsing and usingStatus == true then
                isWeaponInUse = true
            end
            if isWeaponInUse then
                pcall(function() rangedWeapon:InstantReload() end) -- Safely attempt reload
            end
        elseif throwable then
            -- Throwable logic commented out due to server kick issue
            -- utils.ApplyPropertyChange("ReloadTime", 0.0, config.defaultThrowableReloadTime, true, throwable, "Throwable_RapidFire")
        end
    end
end

-- Reset properties modified by rapid fire when the feature is toggled OFF.
function M.Reset()
    -- Reset player pawn fire rate multiplier
    local localPlayerPawn = utils.GetPlayerPawn()
    if localPlayerPawn and localPlayerPawn:IsValid() then
        -- Call ApplyPropertyChange with 'false' to apply the default value.
        -- The first parameter (enabledValue) is still needed but isn't used when 'false' is passed.
        utils.ApplyPropertyChange("FireRateCDMultiplier", 0.01, config.defaultFireRateCDMult, false, localPlayerPawn, "PlayerPawn_RapidFire")
    end

    -- Reset Throwable ReloadTimer if currently held
    local throwable = utils.GetActiveThrowable()
    if throwable then
        -- Throwable logic commented out due to server kick issue
        -- utils.ApplyPropertyChange("ReloadTime", 0.0, config.defaultThrowableReloadTime, false, throwable, "Throwable_RapidFire")
    end
    -- Note: Plane properties reset automatically when Apply loop stops forcing them.
    -- Note: Ranged weapon InstantReload simply stops being called; no explicit reset needed.
end

return M