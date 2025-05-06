local utils = require("utils")
local config = require("config")

-- Define the desired "ON" values for the cheat
local CONVENIENT_WalkableFloorZ   = 0.01  -- Walk almost vertical surfaces
local CONVENIENT_MaxStepHeight    = 250.0 -- Step over higher obstacles
local CONVENIENT_MaxAcceleration  = 6000.0 -- Reach top speed much faster
local CONVENIENT_AirControl       = 1.0   -- Greatly improved air control

local M = {}

-- Apply the convenient movement settings
---@param playerPawn ABP_Character_C | nil
---@param possessedVehicle ABP_VehicleBase_C | nil (Unused)
---@param currentWeapon ABP_RangedWeaponBase_C | nil (Unused)
function M.Apply(playerPawn, possessedVehicle, currentWeapon)
     local movementComponent = utils.GetCharacterMovementComponent(playerPawn)
     if not movementComponent then return end

    -- Apply changes using ApplyPropertyChange with isCurrentlyEnabled = true
    utils.ApplyPropertyChange("WalkableFloorZ", CONVENIENT_WalkableFloorZ, config.defaultWalkableFloorZ, true, movementComponent, "MovementComp_Convenience")
    utils.ApplyPropertyChange("MaxStepHeight", CONVENIENT_MaxStepHeight, config.defaultMaxStepHeight, true, movementComponent, "MovementComp_Convenience")
    utils.ApplyPropertyChange("MaxAcceleration", CONVENIENT_MaxAcceleration, config.defaultMaxAcceleration, true, movementComponent, "MovementComp_Convenience")
    utils.ApplyPropertyChange("AirControl", CONVENIENT_AirControl, config.defaultAirControl, true, movementComponent, "MovementComp_Convenience")
end

-- Reset the convenient movement settings to defaults
function M.Reset()
    local playerPawn = utils.GetPlayerPawn()
    local movementComponent = utils.GetCharacterMovementComponent(playerPawn)
    if not movementComponent then return end

    -- Apply changes using ApplyPropertyChange with isCurrentlyEnabled = false to revert
    utils.ApplyPropertyChange("WalkableFloorZ", CONVENIENT_WalkableFloorZ, config.defaultWalkableFloorZ, false, movementComponent, "MovementComp_Convenience")
    utils.ApplyPropertyChange("MaxStepHeight", CONVENIENT_MaxStepHeight, config.defaultMaxStepHeight, false, movementComponent, "MovementComp_Convenience")
    utils.ApplyPropertyChange("MaxAcceleration", CONVENIENT_MaxAcceleration, config.defaultMaxAcceleration, false, movementComponent, "MovementComp_Convenience")
    utils.ApplyPropertyChange("AirControl", CONVENIENT_AirControl, config.defaultAirControl, false, movementComponent, "MovementComp_Convenience")
end

return M