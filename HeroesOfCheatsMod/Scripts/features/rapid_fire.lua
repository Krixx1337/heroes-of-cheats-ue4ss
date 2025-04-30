--[[ Feature: Rapid Fire (Character & Vehicle) & Instant Reload ]]--
local utils = require("utils")
local state = require("state")
local config = require("config")

local M = {}

-- Apply rapid fire effects based on player state (on foot or in vehicle)
function M.Apply()
    local isRapidFireEnabled = state.Get(config.Features.RAPID_FIRE)
    if not isRapidFireEnabled then return end -- Feature is disabled

    local playerPawn = utils.GetPlayerPawn()
    if not playerPawn then return end

    -- Always apply character fire rate multiplier if feature is ON
    utils.ApplyPropertyChange("FireRateCDMultiplier", 0.01, config.defaultFireRateCDMult, true, playerPawn, "PlayerPawn_RapidFire")

    local vehicleRef = utils.GetCurrentVehicle()

    if not vehicleRef then
        -- Player is on foot: Apply instant reload to equipped weapon
        local weapon = utils.GetEquippedRangedWeapon()
        if weapon then
             pcall(function() weapon:InstantReload() end) -- Safely attempt instant reload
        end
    else
        -- Player is in a vehicle: Apply vehicle-specific rapid fire
        if utils.DoesInheritFrom(vehicleRef, config.requiredTankBaseClassName) then
            -- Apply Tank rapid fire (main gun reload time)
            utils.ApplyPropertyChange("ReloadTime", 0.01, config.defaultTankReloadTime, true, vehicleRef, "Tank_RapidFire")

        elseif utils.DoesInheritFrom(vehicleRef, config.requiredPlaneBaseClassName) then
            -- Apply Plane rapid fire (bomb reload timer and status flag)
            utils.ApplyPropertyChange("BombReloadTimer", 0.0, config.defaultPlaneBombReloadTime, true, vehicleRef, "Plane_RapidFire")
            utils.ApplyPropertyChange("BombReloading", false, false, true, vehicleRef, "Plane_RapidFire") -- Force false while active
        end
    end
end

-- Reset properties modified by rapid fire when the feature is toggled OFF
function M.Reset()
    local playerPawn = utils.GetPlayerPawn()
    if not playerPawn then return end

    print("[HeroesOfCheatsMod] Resetting Rapid Fire...")

    -- Reset character fire rate multiplier to default
    utils.ApplyPropertyChange("FireRateCDMultiplier", 0.01, config.defaultFireRateCDMult, false, playerPawn, "PlayerPawn_RapidFire")

    local vehicleRef = utils.GetCurrentVehicle()
    if vehicleRef then
        -- If player is in a vehicle, reset its specific properties
        local vehicleObjName = utils.GetObjectNames(vehicleRef).ObjectFullName
        print(string.format("[HeroesOfCheatsMod] ...also resetting vehicle '%s'", vehicleObjName))

        if utils.DoesInheritFrom(vehicleRef, config.requiredTankBaseClassName) then
            -- Reset Tank reload time to default
            utils.ApplyPropertyChange("ReloadTime", 0.01, config.defaultTankReloadTime, false, vehicleRef, "Tank_RapidFire")

        elseif utils.DoesInheritFrom(vehicleRef, config.requiredPlaneBaseClassName) then
            -- Reset Plane bomb timer to default.
            utils.ApplyPropertyChange("BombReloadTimer", 0.0, config.defaultPlaneBombReloadTime, false, vehicleRef, "Plane_RapidFire")
            -- Do NOT reset BombReloading here; allow the game's standard logic to control it when the cheat is inactive.
        end
    end
end

return M