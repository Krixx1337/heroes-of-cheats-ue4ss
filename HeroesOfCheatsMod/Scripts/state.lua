--[[
    State Management
    Handles reading/writing persistent toggle states using UE4SS Shared Variables.
--]]
local config = require("config")

local M = {}

-- Initializes a shared variable to 'false' if it doesn't exist.
function M.Initialize(featureInternalName)
    local varName = config.sharedVarPrefix .. featureInternalName
    if ModRef:GetSharedVariable(varName) == nil then
        ModRef:SetSharedVariable(varName, false)
    end
end

-- Reads the persistent state for a feature. Returns false if not set.
function M.Get(featureInternalName)
    return ModRef:GetSharedVariable(config.sharedVarPrefix .. featureInternalName) or false
end

-- Writes the persistent state for a feature.
function M.Set(featureInternalName, newState)
    ModRef:SetSharedVariable(config.sharedVarPrefix .. featureInternalName, newState)
end

return M