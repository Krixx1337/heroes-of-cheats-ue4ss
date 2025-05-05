local utils = require("utils")
local UEHelpers = require("UEHelpers") -- Required for PlayerController access

local M = {}

-- Apply runs continuously via apply_all.lua loop.
---@param playerPawn ABP_Character_C | nil (Unused)
---@param possessedVehicle ABP_VehicleBase_C | nil (Unused)
---@param currentWeapon ABP_RangedWeaponBase_C | nil (Unused)
function M.Apply(playerPawn, possessedVehicle, currentWeapon)
    local controller = UEHelpers.GetPlayerController()
    if not controller or not controller:IsValid() then
        return -- No valid controller to modify.
    end

    -- ApplyPropertyChange only writes if the current value differs from the target.
    -- 'disabledValue' is set to nil as it's irrelevant for an always-on enforcement.
    -- utils.ApplyPropertyChange("CurrentZoneTypePawnIsIn", 0, nil, true, controller, "Controller_CombatZoneEnforce")
    utils.ApplyPropertyChange("InAllowedCombatZone", true, nil, true, controller, "Controller_CombatZoneEnforce")
    utils.ApplyPropertyChange("OutOfCombatZoneCountdown", 5.0, nil, true, controller, "Controller_CombatZoneEnforce")
end

-- No Reset function is needed as this feature is always active when the mod runs.

return M