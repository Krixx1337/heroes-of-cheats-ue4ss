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
    -- Toggleable Features
    [config.Features.INF_DAMAGE]       = require("features.damage"),
    [config.Features.BURN_BULLETS]     = require("features.burning_bullets"),
    [config.Features.SUPER_SPEED]      = require("features.speed"),
    [config.Features.PERFECT_ACCURACY] = require("features.perfect_accuracy"),
    [config.Features.RAPID_FIRE]       = require("features.rapid_fire"),
    [config.Features.VEHICLE_GOD_MODE] = require("features.vehicle_god_mode"),
    [config.Features.EXPERIMENTAL_TOGGLE] = require("features.experimental"),

    -- Always-On Features
    -- We use a unique key that won't conflict with config.Features state names
    ["_AlwaysInCombatZone"]            = require("features.always_in_combat_zone"),
}

local M = {}

-- Variables to store the last known objects and control lookup frequency
local lastPawn = nil           ---@type ABP_Character_C | nil
local lastVehicle = nil        ---@type ABP_VehicleBase_C | nil
local lastWeapon = nil         ---@type ABP_RangedWeaponBase_C | nil
local lastLookupTime = 0.0
local lookupInterval = 0.5     -- Lookup objects every 0.5 seconds

function M.ApplyAllCheats()
    local currentTime = os.clock()
    local performLookup = (currentTime - lastLookupTime >= lookupInterval)

    -- Periodically update our knowledge of the controlled pawn/vehicle/weapon
    if performLookup then
        lastLookupTime = currentTime
        lastPawn = utils.GetPlayerPawn()
        lastVehicle = utils.GetCurrentlyPossessedVehicle()
        lastWeapon = nil -- Reset weapon before potential update below
        if lastPawn and lastPawn:IsValid() then
            lastWeapon = utils.GetEquippedRangedWeapon()
        end
    end

    -- Iterate through ALL mapped features (toggleable and always-on)
    for featureKey, featureModule in pairs(featureMap) do
        local runThisFeature = false

        -- Determine if the feature should run
        if featureKey == "_AlwaysInCombatZone" then
            -- Always run this specific feature
            runThisFeature = true
        else
            -- For toggleable features, check the state
            -- The key here IS the featureStateName from config.Features
            if state.Get(featureKey) then
                 -- Also ensure pawn or vehicle is valid for toggleable features that likely need them
                 if (lastPawn and lastPawn:IsValid()) or (lastVehicle and lastVehicle:IsValid()) then
                    runThisFeature = true
                 end
            end
        end

        -- Execute Apply if the feature should run
        if runThisFeature then
            if featureModule and type(featureModule.Apply) == "function" then
                -- Pass the last known objects (potentially stale) to the Apply functions
                -- The Apply function itself handles nil checks if needed.
                local success, err = pcall(featureModule.Apply, lastPawn, lastVehicle, lastWeapon)
                if not success then
                    local featureName = featureKey -- Use the key for logging
                    print(string.format("[HeroesOfCheatsMod] ERROR executing Apply for feature '%s': %s", featureName, tostring(err)))
                end
            end
        end
    end
end

return M