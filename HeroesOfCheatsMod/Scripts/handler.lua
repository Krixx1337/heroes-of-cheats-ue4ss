--[[
    Keybind Toggle Handler
    Creates callback functions for keybinds to toggle persistent state.
--]]
local config = require("config")
local state = require("state")
local utils = require("utils")

local M = {}

-- Creates a keybind handler function.
function M.CreateToggleHandler(featureDisplayName, featureInternalName, immediateApplyFunc, resetFunc)
    return function()
        -- Read current state, toggle it, save new state
        local currentState = state.Get(featureInternalName)
        local newState = not currentState
        state.Set(featureInternalName, newState)

        -- Provide user feedback
        local stateStr = newState and "ON" or "OFF"
        print(string.format("[HeroesOfCheatsMod] %s -> %s", featureDisplayName, stateStr))

        -- Optionally attempt immediate apply/reset for responsiveness
        ExecuteInGameThread(function()
            ---@type ABP_Character_C | nil
            local playerPawn = utils.GetPlayerPawn()
            if playerPawn then
                 if newState then
                     if immediateApplyFunc then immediateApplyFunc() end
                 elseif resetFunc then
                     resetFunc()
                 elseif immediateApplyFunc then
                     -- Fallback to apply if reset isn't provided but apply is
                     immediateApplyFunc()
                 end
             end
        end)
    end
end

return M