--[[ Feature: Damage Multiplier ]]--
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

    -- Apply the change using the passed pawn. Pass 'true' for isCurrentlyEnabled.
    utils.ApplyPropertyChange("DamageMultiplier", 3.0, 1.0, true, playerPawn, "PlayerPawn_Damage")
end

return M