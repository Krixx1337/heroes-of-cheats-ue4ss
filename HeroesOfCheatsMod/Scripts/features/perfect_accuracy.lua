--[[ Feature: Perfect Accuracy (No Spread + No Sway + No Recoil) ]]--
local utils = require("utils")
local state = require("state")
local config = require("config")

local M = {}

function M.Apply()
    ---@type ABP_Character_C | nil
    local playerPawn = utils.GetPlayerPawn()
    if not playerPawn then return end

    local isEnabled = state.Get(config.Features.PERFECT_ACCURACY)

    -- Apply No Spread (on Pawn)
    utils.ApplyPropertyChange("SpreadMultiplier", 0.0, 1.0, isEnabled, playerPawn, "PlayerPawn_Accuracy")

    -- Apply No Sway (on Pawn)
    utils.ApplyPropertyChange("SwayAmount", 0.0, 1.0, isEnabled, playerPawn, "PlayerPawn_Accuracy")
    utils.ApplyPropertyChange("UseCameraAimingSway", false, true, isEnabled, playerPawn, "PlayerPawn_Accuracy")

    -- Apply No Recoil (on Weapon)
    ---@type ABP_RangedWeaponBase_C | nil
    local weapon = utils.GetEquippedRangedWeapon()
    if weapon then
        -- Set Recoil Amounts to 0 when enabled, reset to defaults when disabled
        utils.ApplyPropertyChange("RecoilAmount(HipFire)", 0.0, config.defaultRecoilHip, isEnabled, weapon, "Weapon_Accuracy")
        utils.ApplyPropertyChange("RecoilAmount(WhileAiming)", 0.0, config.defaultRecoilAim, isEnabled, weapon, "Weapon_Accuracy")
        utils.ApplyPropertyChange("AnimationRecoilAmount", 0.0, config.defaultRecoilAnim, isEnabled, weapon, "Weapon_Accuracy")
        utils.ApplyPropertyChange("AnimationHandRecoilAmount", 0.0, config.defaultRecoilHandAnim, isEnabled, weapon, "Weapon_Accuracy") -- Stays 0 based on default

        -- Set Camera Shake Amount to 0 when enabled
        utils.ApplyPropertyChange("FireCameraShakeAmount", 0.0, config.defaultFireCameraShakeAmount, isEnabled, weapon, "Weapon_Accuracy")

        -- Optionally force flags off when enabled (and back to default when disabled)
        -- These seemed default false anyway, but doesn't hurt to ensure they are off
        utils.ApplyPropertyChange("EnableSidewaysRecoil", false, config.defaultEnableSidewaysRecoil, isEnabled, weapon, "Weapon_Accuracy")
        utils.ApplyPropertyChange("UseRandomRecoil", false, config.defaultUseRandomRecoil, isEnabled, weapon, "Weapon_Accuracy")
    end
end

-- No separate Reset function needed as Apply handles both ON and OFF states based on GetFeatureState

return M