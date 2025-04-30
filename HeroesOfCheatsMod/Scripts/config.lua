--[[
    Configuration
    Stores constants, class names, default values, and keys used by the mod.
--]]

local M = {}

-- Target Blueprint Class Names
M.requiredPlayerClassName = "BP_Character_C"
M.requiredWeaponBaseClassName = "BP_RangedWeaponBase_C"
M.requiredTankBaseClassName = "BP_TankBase_C"
M.requiredPlaneBaseClassName = "BP_PlaneBase_C"

-- Prefix for persistent state variables
M.sharedVarPrefix = "HoV_"

-- Enforcement loop interval (milliseconds)
M.loopIntervalMs = 50

-- Default Game Values
M.defaultWalkSpeedMult = 0.335
M.defaultRunSpeedMult = 0.500
M.defaultFireRateCDMult = 1.0

-- Recoil Defaults
M.defaultRecoilHip = 0.030 -- From MP40
M.defaultRecoilAim = 0.030 -- From MP40
M.defaultRecoilAnim = 1.0
M.defaultRecoilHandAnim = 0.0
M.defaultEnableSidewaysRecoil = false
M.defaultUseRandomRecoil = false
M.defaultFireCameraShakeAmount = 1.0

-- Feature Internal Names (Used for state management and lookup)
M.Features = {
    INF_DAMAGE = "enableInf",
    BURN_BULLETS = "enableBurn",
    SUPER_SPEED = "enableSpeed",
    PERFECT_ACCURACY = "enableAccuracy",
    RAPID_FIRE = "enableRapid",
    TELEKILL = "enableTelekill",
    EXPERIMENTAL_TOGGLE = "enableExperimental",
}

-- Virtual Key Codes
M.VK_LBUTTON = 0x01 -- Left Mouse Button

return M