--[[ Feature: Damage Multiplier ]]--
local utils = require("utils")
local state = require("state")
local config = require("config")

local M = {}

function M.Apply()
    ---@type ABP_Character_C | nil
    local playerPawn = utils.GetPlayerPawn()
    if not playerPawn then return end
    utils.ApplyPropertyChange("DamageMultiplier", 3.0, 1.0, state.Get(config.Features.INF_DAMAGE), playerPawn, "PlayerPawn")
end

return M