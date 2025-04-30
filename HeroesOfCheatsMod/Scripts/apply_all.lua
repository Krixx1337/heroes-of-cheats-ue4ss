--[[
    Master Cheat Application
    Defines the function that applies all active cheat effects.
--]]
local utils = require("utils")

-- Require active feature modules
local requiredFeatures = {
    damage = require("features.damage"),
    burning_bullets = require("features.burning_bullets"),
    speed = require("features.speed"),
    perfect_accuracy = require("features.perfect_accuracy"),
    rapid_fire = require("features.rapid_fire"),
    vehicle_god_mode = require("features.vehicle_god_mode"),
    experimental = require("features.experimental"),
}

local M = {}

-- Calls the Apply() function for all relevant features.
function M.ApplyAllCheats()
    -- Avoid processing if player pawn is not valid
    if not utils.GetPlayerPawn() then return end

    for featureName, featureModule in pairs(requiredFeatures) do
        if featureModule and type(featureModule.Apply) == "function" then
            -- Use pcall for safety; prevents one feature error from crashing the loop.
            local success, err = pcall(featureModule.Apply)
            if not success then
                print(string.format("[HeroesOfCheatsMod] ERROR executing Apply for feature '%s': %s", featureName, tostring(err)))
            end
        end
    end
end

return M