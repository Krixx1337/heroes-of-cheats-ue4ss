--[[ Feature: Rapid Fire (Character & Plane) & Instant Reload (Character) ]]--
local utils = require("utils")
local state = require("state")
local config = require("config")

local M = {}

-- Apply rapid fire effects based on player state (on foot or in vehicle)
---@param playerPawn ABP_Character_C | nil
---@param possessedVehicle ABP_VehicleBase_C | nil
---@param currentWeapon ABP_RangedWeaponBase_C | nil
function M.Apply(playerPawn, possessedVehicle, currentWeapon)
    -- No need to check state here, apply_all already did.
    -- Use passed arguments directly.

    if possessedVehicle and possessedVehicle:IsValid() then -- Check if vehicle is valid
        -- Handle plane rapid fire if possessing a plane
        if utils.DoesInheritFrom(possessedVehicle, config.requiredPlaneBaseClassName) then
            ---@type ABP_PlaneBase_C
            local plane = possessedVehicle
            utils.ApplyPropertyChange("BombReloadTimer", 0.0, 0.0, true, plane, "Plane_RapidFire")
            utils.ApplyPropertyChange("BombReloading", false, false, true, plane, "Plane_RapidFire")
        end
        -- Tank rapid fire is handled separately in keybinds.lua via LMB override
    elseif playerPawn and playerPawn:IsValid() then -- Check if player pawn is valid
        -- Apply character fire rate multiplier
        utils.ApplyPropertyChange("FireRateCDMultiplier", 0.01, config.defaultFireRateCDMult, true, playerPawn, "PlayerPawn_RapidFire")

        -- Apply instant reload to equipped weapon only if its 'Using' flag is true
        ---@type ABP_RangedWeaponBase_C | nil
        local weapon = currentWeapon -- Use the passed argument
        if weapon and weapon:IsValid() then
            local isWeaponInUse = false
            -- Safely check the 'Using' status inherited from ABP_EquipableBase_C
            local successReadUsing, usingStatus = pcall(function() return weapon.Using end)
            if successReadUsing and usingStatus == true then
                isWeaponInUse = true
            end

            if isWeaponInUse then
                pcall(function() weapon:InstantReload() end)
            end
        end
    end
end

-- Reset properties modified by rapid fire when the feature is toggled OFF
-- Note: This still needs to fetch the pawn itself as Apply might not be called when resetting.
function M.Reset()
    ---@type ABP_Character_C | nil
    local localPlayerPawn = utils.GetPlayerPawn() -- Need to fetch here for reset logic
    if localPlayerPawn and localPlayerPawn:IsValid() then
        utils.ApplyPropertyChange("FireRateCDMultiplier", 0.01, config.defaultFireRateCDMult, false, localPlayerPawn, "PlayerPawn_RapidFire")
    end
    -- Plane properties reset automatically when Apply loop stops forcing them.
end

return M