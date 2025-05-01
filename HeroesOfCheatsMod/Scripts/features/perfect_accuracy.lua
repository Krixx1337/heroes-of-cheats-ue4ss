--[[ Feature: Perfect Accuracy (No Spread + No Sway + No Recoil) ]]--
local utils = require("utils")
local state = require("state")
local config = require("config")

local M = {}

---@param playerPawn ABP_Character_C | nil
---@param possessedVehicle ABP_VehicleBase_C | nil
---@param currentWeapon ABP_RangedWeaponBase_C | nil
function M.Apply(playerPawn, possessedVehicle, currentWeapon)
    -- state is checked by apply_all, so isEnabled is always true here.
    local isEnabled = true

    -- Apply changes to Player Pawn (if valid)
    if playerPawn and playerPawn:IsValid() then
        utils.ApplyPropertyChange("SpreadMultiplier", 0.0, 1.0, isEnabled, playerPawn, "PlayerPawn_Accuracy")
        utils.ApplyPropertyChange("SwayAmount", 0.0, 1.0, isEnabled, playerPawn, "PlayerPawn_Accuracy")
        utils.ApplyPropertyChange("UseCameraAimingSway", false, true, isEnabled, playerPawn, "PlayerPawn_Accuracy")
    end

    -- Apply changes to Weapon (if valid)
    ---@type ABP_RangedWeaponBase_C | nil
    local weapon = currentWeapon -- Use passed argument
    if weapon and weapon:IsValid() then
        utils.ApplyPropertyChange("RecoilAmount(HipFire)", 0.0, config.defaultRecoilHip, isEnabled, weapon, "Weapon_Accuracy")
        utils.ApplyPropertyChange("RecoilAmount(WhileAiming)", 0.0, config.defaultRecoilAim, isEnabled, weapon, "Weapon_Accuracy")
        utils.ApplyPropertyChange("AnimationRecoilAmount", 0.0, config.defaultRecoilAnim, isEnabled, weapon, "Weapon_Accuracy")
        utils.ApplyPropertyChange("AnimationHandRecoilAmount", 0.0, config.defaultRecoilHandAnim, isEnabled, weapon, "Weapon_Accuracy")
        utils.ApplyPropertyChange("FireCameraShakeAmount", 0.0, config.defaultFireCameraShakeAmount, isEnabled, weapon, "Weapon_Accuracy")
        utils.ApplyPropertyChange("EnableSidewaysRecoil", false, config.defaultEnableSidewaysRecoil, isEnabled, weapon, "Weapon_Accuracy")
        utils.ApplyPropertyChange("UseRandomRecoil", false, config.defaultUseRandomRecoil, isEnabled, weapon, "Weapon_Accuracy")
    end
end

-- Need to add a Reset function if properties need resetting when toggled OFF.
-- Currently, ApplyPropertyChange handles resetting if called with isEnabled=false.
-- This requires modifying the toggle handler to call Apply with isEnabled=false on toggle OFF.
-- OR create a dedicated Reset function like rapid_fire has.
-- For simplicity, let's assume ApplyPropertyChange handles the reset for now via toggle.

-- Example (Conceptual - needs handler modification):
-- function M.Reset()
--     local localPlayerPawn = utils.GetPlayerPawn()
--     local localWeapon = utils.GetEquippedRangedWeapon()
--     M.Apply(localPlayerPawn, nil, localWeapon, false) -- Call Apply with isEnabled=false
-- end

return M