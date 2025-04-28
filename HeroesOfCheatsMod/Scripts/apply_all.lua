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
    telekill = require("features.telekill"),
    experimental = require("features.experimental"),
}

local M = {}

-- Calls the Apply() function for all relevant features.
function M.ApplyAllCheats()
    if not utils.GetPlayerPawn() then return end

    for featureName, featureModule in pairs(requiredFeatures) do
        if featureModule and type(featureModule.Apply) == "function" then
            -- Using pcall for safety in case a feature's Apply func errors
            local success, err = pcall(featureModule.Apply)
            if not success then
                print(string.format("[HeroesOfCheatsMod] ERROR executing Apply for feature '%s': %s", featureName, tostring(err)))
            end
        end
    end
end

return M