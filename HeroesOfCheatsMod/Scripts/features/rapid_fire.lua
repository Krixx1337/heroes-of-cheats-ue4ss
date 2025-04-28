--[[ Feature: Rapid Fire & Instant Reload ]]--
local utils = require("utils")
local state = require("state")
local config = require("config")

local M = {}

-- Apply logic runs continuously via loop if enabled
function M.Apply()
    local playerPawn = utils.GetPlayerPawn()
    if not playerPawn then return end

    local isRapidFireEnabled = state.Get(config.Features.RAPID_FIRE)

    -- Apply FireRateCDMultiplier changes based on toggle state
    utils.ApplyPropertyChange("FireRateCDMultiplier", 0.01, config.defaultFireRateCDMult, isRapidFireEnabled, playerPawn, "PlayerPawn")

    -- If Rapid Fire is ON, also attempt Instant Reload on the weapon
    if isRapidFireEnabled then
        local weapon = utils.GetEquippedRangedWeapon()
        if weapon and weapon:IsValid() then
            -- Attempt to call the InstantReload function safely
            pcall(function() weapon:InstantReload() end)
        end
    end
end

-- Reset logic called by handler when toggled OFF
function M.Reset()
    local playerPawn = utils.GetPlayerPawn()
    if not playerPawn then return end
    print("[HeroesOfCheatsMod] Resetting Rapid Fire Multiplier...")
    utils.ApplyPropertyChange("FireRateCDMultiplier", 0.01, config.defaultFireRateCDMult, false, playerPawn, "PlayerPawn")
end

return M