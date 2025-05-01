--[[ Feature: Experimental Property Tester ]]--
local utils = require("utils")
local state = require("state")
local config = require("config")

local M = {}

-- This function runs in the loop when the Experimental Toggle is ON
---@param playerPawn ABP_Character_C | nil
---@param possessedVehicle ABP_VehicleBase_C | nil
---@param currentWeapon ABP_RangedWeaponBase_C | nil
function M.Apply(playerPawn, possessedVehicle, currentWeapon)
    -- No need to check state, apply_all did.
    -- Use passed arguments directly.

    if not playerPawn and not possessedVehicle then return end -- Exit if nothing to experiment on

    --[[ ============================================================
     ##                 TEST PROPERTIES HERE                   ##
     ##   Uncomment ONE section/property at a time to test!    ##
     ============================================================

    -- Example: Modify Weapon property (use 'currentWeapon')
    -- if currentWeapon and currentWeapon:IsValid() then
    --     utils.ApplyPropertyChange("DirectDamageAmount", 50, 7, true, currentWeapon, "Weapon_Experimental")
    -- end

    -- Example: Modify Player property (use 'playerPawn')
    -- if playerPawn and playerPawn:IsValid() then
    --     utils.ApplyPropertyChange("SomePlayerBoolean", true, false, true, playerPawn, "PlayerPawn_Experimental")
    -- end

    -- Example: Modify Vehicle property (use 'possessedVehicle')
    -- if possessedVehicle and possessedVehicle:IsValid() then
    --     utils.ApplyPropertyChange("SomeVehicleFloat", 100.0, 1.0, true, possessedVehicle, "Vehicle_Experimental")
    -- end

    ]]--
end

return M