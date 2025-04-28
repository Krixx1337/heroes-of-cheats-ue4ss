--[[
    Configuration
    Stores constants, class names, default values, and keys used by the mod.
--]]

local M = {}

-- Target Blueprint Class Names (Verify for game version)
M.requiredPlayerClassName = "BP_Character_C"
M.requiredWeaponBaseClassName = "BP_RangedWeaponBase_C"

-- Prefix for persistent state variables (prevents conflicts)
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
    INF_DAMAGE = "enableInf",              -- F1
    BURN_BULLETS = "enableBurn",           -- F2
    SUPER_SPEED = "enableSpeed",           -- F3
    PERFECT_ACCURACY = "enableAccuracy",   -- F4
    RAPID_FIRE = "enableRapid",            -- F5
    TELEKILL = "enableTelekill",           -- F7
    EXPERIMENTAL_TOGGLE = "enableExperimental", -- F8
}

return M