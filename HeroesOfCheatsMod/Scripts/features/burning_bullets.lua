--[[ Feature: Burning Bullets ]]--
local utils = require("utils")
local state = require("state")
local config = require("config")

local M = {}

function M.Apply()
    local playerPawn = utils.GetPlayerPawn()
    if not playerPawn then return end
    utils.ApplyPropertyChange("BurningBulletsEnabled", true, false, state.Get(config.Features.BURN_BULLETS), playerPawn, "PlayerPawn")
end

return M