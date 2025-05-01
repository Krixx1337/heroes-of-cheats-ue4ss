--[[ Feature: Vehicle God Mode (Instant Repair) ]]--
local utils = require("utils")
local state = require("state")
local config = require("config")

local M = {}

-- Applies the instant repair effect if the feature is enabled and the player is in a vehicle.
function M.Apply()
    if not state.Get(config.Features.VEHICLE_GOD_MODE) then return end

    ---@type ABP_VehicleBase_C | nil
    local vehicle = utils.GetCurrentlyPossessedVehicle()

    if vehicle and vehicle:IsValid() then
        pcall(function() vehicle:S_SetRepaired() end)
    end
end

return M