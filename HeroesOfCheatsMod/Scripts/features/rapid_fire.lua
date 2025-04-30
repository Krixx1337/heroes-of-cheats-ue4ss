--[[ Feature: Rapid Fire (Character & Plane) & Instant Reload (Character) ]]--
local utils = require("utils")
local state = require("state")
local config = require("config")

local M = {}

-- Apply rapid fire effects based on player state (on foot or in plane)
-- Tank rapid fire is handled via direct MC_Fire call in keybinds.lua
function M.Apply()
    local isRapidFireEnabled = state.Get(config.Features.RAPID_FIRE)
    if not isRapidFireEnabled then return end

    local playerPawn = utils.GetPlayerPawn()
    if not playerPawn then return end

    -- Apply character fire rate multiplier
    utils.ApplyPropertyChange("FireRateCDMultiplier", 0.01, config.defaultFireRateCDMult, true, playerPawn, "PlayerPawn_RapidFire")

    local vehicleRef = utils.GetCurrentVehicle()

    if not vehicleRef then
        -- Player is on foot: Apply instant reload to equipped weapon
        local weapon = utils.GetEquippedRangedWeapon()
        if weapon then
             pcall(function() weapon:InstantReload() end)
        end
    else
        -- Player is in a vehicle: Apply Plane-specific rapid fire
        if utils.DoesInheritFrom(vehicleRef, config.requiredPlaneBaseClassName) then
            -- Apply Plane rapid fire (bomb reload timer and status flag)
            utils.ApplyPropertyChange("BombReloadTimer", 0.0, 0.0, true, vehicleRef, "Plane_RapidFire") -- Force 0 while active
            utils.ApplyPropertyChange("BombReloading", false, false, true, vehicleRef, "Plane_RapidFire") -- Force false while active
        end
    end
end

-- Reset properties modified by rapid fire when the feature is toggled OFF
function M.Reset()
    local playerPawn = utils.GetPlayerPawn()
    if not playerPawn then return end

    print("[HeroesOfCheatsMod] Resetting Character/Plane Rapid Fire Properties...")

    -- Reset character fire rate multiplier to default
    utils.ApplyPropertyChange("FireRateCDMultiplier", 0.01, config.defaultFireRateCDMult, false, playerPawn, "PlayerPawn_RapidFire")

    -- Plane properties (BombReloadTimer, BombReloading) reset automatically
    -- when the Apply function stops forcing them, as their default/inactive state is 0/false.
    -- No explicit reset needed here.
end

return M