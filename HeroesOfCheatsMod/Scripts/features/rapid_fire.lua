--[[ Feature: Rapid Fire (Character & Plane) & Instant Reload (Character) ]]--
local utils = require("utils")
local state = require("state")
local config = require("config")

local M = {}

-- Apply rapid fire effects based on player state (on foot or in vehicle)
function M.Apply()
    local isRapidFireEnabled = state.Get(config.Features.RAPID_FIRE)
    if not isRapidFireEnabled then return end

    ---@type ABP_VehicleBase_C | nil
    local possessedVehicle = utils.GetCurrentlyPossessedVehicle() -- Use updated vehicle check

    if possessedVehicle then
        -- Handle plane rapid fire if possessing a plane
        if utils.DoesInheritFrom(possessedVehicle, config.requiredPlaneBaseClassName) then
            ---@type ABP_PlaneBase_C
            local plane = possessedVehicle
            utils.ApplyPropertyChange("BombReloadTimer", 0.0, 0.0, true, plane, "Plane_RapidFire")
            utils.ApplyPropertyChange("BombReloading", false, false, true, plane, "Plane_RapidFire")
        end
        -- Tank rapid fire is handled separately in keybinds.lua
    else
        -- Assume player is on foot if not possessing a vehicle
        ---@type ABP_Character_C | nil
        local playerPawn = utils.GetPlayerPawn()
        if playerPawn then
            -- Apply character fire rate multiplier
            utils.ApplyPropertyChange("FireRateCDMultiplier", 0.01, config.defaultFireRateCDMult, true, playerPawn, "PlayerPawn_RapidFire")

            -- Apply instant reload to equipped weapon
            ---@type ABP_RangedWeaponBase_C | nil
            local weapon = utils.GetEquippedRangedWeapon()
            if weapon then
                 pcall(function() weapon:InstantReload() end)
            end
        end
    end
end

-- Reset properties modified by rapid fire when the feature is toggled OFF
function M.Reset()
    ---@type ABP_Character_C | nil
    local playerPawn = utils.GetPlayerPawn()
    if playerPawn then
        print("[HeroesOfCheatsMod] Resetting Character Rapid Fire Properties...")
        utils.ApplyPropertyChange("FireRateCDMultiplier", 0.01, config.defaultFireRateCDMult, false, playerPawn, "PlayerPawn_RapidFire")
    end
    -- Plane properties reset automatically when Apply loop stops forcing them.
end

return M