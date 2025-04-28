--[[ Feature: Experimental Property Tester ]]--
local utils = require("utils")
local state = require("state")
local config = require("config")

local M = {}

-- This function runs in the loop when the Experimental Toggle (F8) is ON
function M.Apply()
    if not state.Get(config.Features.EXPERIMENTAL_TOGGLE) then return end
    local playerPawn = utils.GetPlayerPawn()
    local weapon = utils.GetEquippedRangedWeapon()
    if not playerPawn then return end

    --[[ ============================================================
     ##                 TEST PROPERTIES HERE                   ##
     ##   Uncomment ONE section/property at a time to test!    ##
     ============================================================

    -- Example: Modify Weapon property
    -- if weapon then
    --     utils.ApplyPropertyChange("DirectDamageAmount", 50, 7, true, weapon, "Weapon_Experimental")
    -- end

    -- Example: Modify Player property
    -- utils.ApplyPropertyChange("SomePlayerBoolean", true, false, true, playerPawn, "PlayerPawn_Experimental")

    ]]--
end

return M