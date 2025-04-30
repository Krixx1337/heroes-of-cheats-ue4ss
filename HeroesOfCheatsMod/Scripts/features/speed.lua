--[[ Feature: Super Speed ]]--
local utils = require("utils")
local state = require("state")
local config = require("config")

local M = {}

function M.Apply()
    ---@type ABP_Character_C | nil
    local playerPawn = utils.GetPlayerPawn()
    if not playerPawn then return end
    local enabled = state.Get(config.Features.SUPER_SPEED)
    utils.ApplyPropertyChange("WalkSpeedMultiplier", 15.0, config.defaultWalkSpeedMult, enabled, playerPawn, "PlayerPawn")
    utils.ApplyPropertyChange("RunSpeedMultiplier", 15.0, config.defaultRunSpeedMult, enabled, playerPawn, "PlayerPawn")
end

return M