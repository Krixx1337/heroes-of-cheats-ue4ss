--[[
    Persistence Mechanisms
    Sets up the continuous enforcement loop. Relies solely on the loop
    and shared state for persistence. Keeps the loop callback minimal.
--]]
local config = require("config")
local state = require("state")
local apply_all = require("apply_all") -- Ensure apply_all is required

local M = {}

-- Function to setup the enforcement loop
function M.SetupLoop()
    LoopAsync(config.loopIntervalMs, function()
        local anyFeatureEnabled = false
        -- Check if any feature is globally enabled
        for featureKey, featureInternalName in pairs(config.Features) do
            if state.Get(featureInternalName) then anyFeatureEnabled = true; break end
        end

        -- Only schedule work if a feature is on
        if anyFeatureEnabled then
            ExecuteInGameThread(function()
                -- Directly call ApplyAllCheats.
                -- Getters and validity/state checks will happen inside ApplyAllCheats.
                apply_all.ApplyAllCheats()
            end)
        end
    end)
    print(string.format("[HeroesOfCheatsMod] Started Enforcement Loop (%dms).", config.loopIntervalMs))
end

return M