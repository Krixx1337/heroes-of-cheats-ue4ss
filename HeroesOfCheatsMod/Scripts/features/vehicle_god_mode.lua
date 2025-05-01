--[[ Feature: Vehicle God Mode (Instant Repair - No Timer Optimization) ]]--
-- Checks health before repairing to reduce unnecessary calls.
local utils = require("utils")
local state = require("state")
local config = require("config")

local M = {}

-- Applies the instant repair effect only if the vehicle is damaged. Runs every cycle.
---@param playerPawn ABP_Character_C | nil
---@param possessedVehicle ABP_VehicleBase_C | nil
---@param currentWeapon ABP_RangedWeaponBase_C | nil
function M.Apply(playerPawn, possessedVehicle, currentWeapon)
    -- No need to check state here, apply_all already did.
    -- Use the passed-in vehicle reference
    ---@type ABP_VehicleBase_C | nil
    local vehicle = possessedVehicle -- Use the argument directly

    if vehicle and vehicle:IsValid() then
        local needsRepair = false
        local currentHealth = nil
        local maxHealth = nil

        -- Safely get current health
        local successGetCurr, healthVal = pcall(function() return vehicle.CurrentHealth end)
        if successGetCurr then currentHealth = healthVal end

        -- Safely get max health
        local successGetMax, maxVal = pcall(function() return vehicle['MaxHealth(InitialHP)'] end)
        if successGetMax then maxHealth = maxVal end

        -- Determine if repair is needed (only if both values were successfully read)
        if currentHealth ~= nil and maxHealth ~= nil and currentHealth < maxHealth then
            needsRepair = true
        end

        -- Call repair function only if needed
        if needsRepair then
            -- Still use pcall for the function call itself for safety
            pcall(function() vehicle:S_SetRepaired() end)
        end
    end
end

-- No Reset function needed.

return M