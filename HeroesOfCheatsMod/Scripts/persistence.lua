--[[
    Persistence Mechanisms
    Sets up the continuous enforcement loop. Relies solely on the loop
    and shared state for persistence.
--]]
local config = require("config")
local utils = require("utils")
local state = require("state")
local apply_all = require("apply_all")

local M = {}

-- Function to setup the enforcement loop
function M.SetupLoop()
    LoopAsync(config.loopIntervalMs, function()
        local anyFeatureEnabled = false
        for featureKey, featureInternalName in pairs(config.Features) do
            if state.Get(featureInternalName) then anyFeatureEnabled = true; break end end

        if anyFeatureEnabled then
            ExecuteInGameThread(function()
                local currentPawn = utils.GetPlayerPawn()
                if not currentPawn or not currentPawn:IsValid() then return end

                -- Check IsDead flag before applying cheats
                local isAlive = true
                local successGetDead, isDeadFlag = pcall(function() return currentPawn.IsDead end)
                if successGetDead then if isDeadFlag == true then isAlive = false end
                else print("[HeroesOfCheatsMod] WARNING: Failed to read IsDead property."); isAlive = false end -- Assume not safe if read fails

                if isAlive then apply_all.ApplyAllCheats() end
            end)
        end
    end)
    print(string.format("[HeroesOfCheatsMod] Started Enforcement Loop (%dms).", config.loopIntervalMs))
end

return M