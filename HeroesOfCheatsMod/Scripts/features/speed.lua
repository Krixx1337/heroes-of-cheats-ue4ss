--[[ Feature: Super Speed ]]--
local utils = require("utils")
local state = require("state")
local config = require("config")

local M = {}

---@param playerPawn ABP_Character_C | nil
---@param possessedVehicle ABP_VehicleBase_C | nil
---@param currentWeapon ABP_RangedWeaponBase_C | nil
function M.Apply(playerPawn, possessedVehicle, currentWeapon)
    -- Directly use the passed-in playerPawn
    if not playerPawn or not playerPawn:IsValid() then return end -- Still need valid character pawn

    -- Apply changes using the passed pawn. Pass 'true' for isCurrentlyEnabled.
    utils.ApplyPropertyChange("WalkSpeedMultiplier", 15.0, config.defaultWalkSpeedMult, true, playerPawn, "PlayerPawn_Speed")
    utils.ApplyPropertyChange("RunSpeedMultiplier", 15.0, config.defaultRunSpeedMult, true, playerPawn, "PlayerPawn_Speed")
end

return M