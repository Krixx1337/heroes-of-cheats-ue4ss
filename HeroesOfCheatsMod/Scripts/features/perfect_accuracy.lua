--[[ Feature: Perfect Accuracy (Merged No Spread & No Sway) ]]--
local utils = require("utils")
local state = require("state")
local config = require("config")

local M = {}

function M.Apply()
    local playerPawn = utils.GetPlayerPawn()
    if not playerPawn then return end

    local enabled = state.Get(config.Features.PERFECT_ACCURACY)

    -- No Spread
    utils.ApplyPropertyChange("SpreadMultiplier", 0.0, 1.0, enabled, playerPawn, "PlayerPawn_Accuracy")
    -- No Sway
    utils.ApplyPropertyChange("SwayAmount", 0.0, 1.0, enabled, playerPawn, "PlayerPawn_Accuracy")
    utils.ApplyPropertyChange("UseCameraAimingSway", false, true, enabled, playerPawn, "PlayerPawn_Accuracy")
end

return M