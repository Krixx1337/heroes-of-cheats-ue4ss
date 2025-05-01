--[[
    Master Cheat Application
    Fetches relevant game objects periodically, performs validity checks,
    and calls Apply() for active features using the cached references.
--]]
local utils = require("utils")
local state = require("state")
local config = require("config")

-- Map feature state names to their modules.
local featureMap = {
    [config.Features.INF_DAMAGE]       = require("features.damage"),
    [config.Features.BURN_BULLETS]     = require("features.burning_bullets"),
    [config.Features.SUPER_SPEED]      = require("features.speed"),
    [config.Features.PERFECT_ACCURACY] = require("features.perfect_accuracy"),
    [config.Features.RAPID_FIRE]       = require("features.rapid_fire"),
    [config.Features.VEHICLE_GOD_MODE]= require("features.vehicle_god_mode"),
    [config.Features.EXPERIMENTAL_TOGGLE] = require("features.experimental"),
}

local M = {}

-- Variables to store the last known objects and control lookup frequency
local lastPawn = nil           ---@type ABP_Character_C | nil
local lastVehicle = nil        ---@type ABP_VehicleBase_C | nil
local lastWeapon = nil         ---@type ABP_RangedWeaponBase_C | nil
local lastLookupTime = 0.0
-- NOTE: lookupInterval controls how often pawn/vehicle/weapon references are refreshed.
-- Higher values improve performance by reducing calls to utils.Get... functions,
-- which were found to be a bottleneck, especially under load. However, this
-- increases potential delay in cheats reacting to weapon/vehicle changes between
-- hook-triggered cache invalidations. Adjust based on performance testing.
local lookupInterval = 0.5     -- Lookup objects every 1.0 second (Adjust as needed)

function M.ApplyAllCheats()
    local currentTime = os.clock()
    local performLookup = (currentTime - lastLookupTime >= lookupInterval)

    -- Periodically update our knowledge of the controlled pawn/vehicle/weapon
    if performLookup then
        lastLookupTime = currentTime
        lastPawn = utils.GetPlayerPawn()
        lastVehicle = utils.GetCurrentlyPossessedVehicle()
        lastWeapon = nil -- Reset weapon before potential update below
        -- Update weapon reference only if we just looked up and found a valid pawn
        if lastPawn and lastPawn:IsValid() then
            lastWeapon = utils.GetEquippedRangedWeapon()
        end
        -- print("[ApplyAll DEBUG] Performed object lookup.") -- Optional debug
    end

    -- Use the last known references for checks and feature application
    if (not lastPawn or not lastPawn:IsValid()) and (not lastVehicle or not lastVehicle:IsValid()) then
        return
    end

    -- Iterate through mapped features and apply if enabled
    for featureStateName, featureModule in pairs(featureMap) do
        if state.Get(featureStateName) then
            if featureModule and type(featureModule.Apply) == "function" then
                -- Pass the last known objects (potentially stale) to the Apply functions
                local success, err = pcall(featureModule.Apply, lastPawn, lastVehicle, lastWeapon)
                if not success then
                    print(string.format("[HeroesOfCheatsMod] ERROR executing Apply for feature state '%s': %s", featureStateName, tostring(err)))
                end
            end
        end
    end
end

return M