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
M.requiredVehicleBaseClassName = "BP_VehicleBase_C"
M.requiredThrowableBaseClassName = "BP_Throwablebase_C"

-- Prefix for persistent state variables
M.sharedVarPrefix = "HoV_"

-- Cheat enforcement loop interval. Default: 50ms (20Hz).
-- Balances update responsiveness (lower values improve single-shot rapid fire rate)
-- against client CPU load (higher values reduce load).
M.loopIntervalMs = 50

-- Default Game Values (captured for potential resets)
M.defaultWalkSpeedMult = 0.335
M.defaultRunSpeedMult = 0.500
M.defaultFireRateCDMult = 1.0
M.defaultThrowableReloadTime = 5.0

-- Recoil Defaults (captured for potential resets)
M.defaultRecoilHip = 0.030
M.defaultRecoilAim = 0.030
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
    VEHICLE_GOD_MODE = "enableVehicleGodMode",
    EXPERIMENTAL_TOGGLE = "enableExperimental",
}

return M