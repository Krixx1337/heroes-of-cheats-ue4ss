--[[ Feature: Vehicle God Mode (Instant Repair) ]]--
local utils = require("utils")
local state = require("state")
local config = require("config")

local M = {}

-- Applies the instant repair effect if the feature is enabled and the player is in a vehicle.
function M.Apply()
    if not state.Get(config.Features.VEHICLE_GOD_MODE) then return end

    ---@type ABP_VehicleBase_C | nil
    local vehicle = utils.GetCurrentVehicle()

    -- If the player is in a valid vehicle, attempt to call the server-side repair function.
    if vehicle and vehicle:IsValid() then
        -- Use pcall for safety as the function call might fail or the object could become invalid.
        local success, err = pcall(function() vehicle:S_SetRepaired() end)
        -- Optionally log errors, but avoid spamming console on repeated failures.
        -- if not success then print(string.format("[HeroesOfCheatsMod] ERROR calling S_SetRepaired: %s", tostring(err))) end
    end
end

return M