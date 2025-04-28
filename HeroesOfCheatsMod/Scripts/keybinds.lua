--[[
    Keybind Registration
    Registers all keybinds for the mod features.
--]]
local config = require("config")
local handler = require("handler")

-- Require features if their Apply/Reset funcs are needed by handler
local damage = require("features.damage")
local burning_bullets = require("features.burning_bullets")
local speed = require("features.speed")
local perfect_accuracy = require("features.perfect_accuracy")
local rapid_fire = require("features.rapid_fire") -- Need Reset

local M = {}
local KeybindList = {} -- Stores info for the load message

-- Helper to register and track keybinds
local function AddKeybind(key, keyName, mods, featureDisplayName, ...)
    RegisterKeyBind(key, mods, handler.CreateToggleHandler(featureDisplayName, ...))
    local modStr = ""
    if mods and #mods > 0 then local modNames = {}; for _, modKey in ipairs(mods) do if modKey == ModifierKey.CONTROL then table.insert(modNames, "Ctrl") elseif modKey == ModifierKey.SHIFT then table.insert(modNames, "Shift") elseif modKey == ModifierKey.ALT then table.insert(modNames, "Alt") else table.insert(modNames, "Mod?") end end; modStr = table.concat(modNames, "+") .. "+" end
    table.insert(KeybindList, string.format("    %s%s -> %s", modStr, keyName, featureDisplayName or "Unknown Feature"))
end

-- Function to register all binds
function M.RegisterAll()
    print("[HeroesOfCheatsMod] Registering Keybinds...")

    -- Register remaining cheats with F-keys
    AddKeybind(Key.F1,    "F1",     {}, "Damage Multiplier", config.Features.INF_DAMAGE, damage.Apply)
    AddKeybind(Key.F2,    "F2",     {}, "Burning Bullets", config.Features.BURN_BULLETS, burning_bullets.Apply)
    AddKeybind(Key.F3,    "F3",     {}, "Super Speed", config.Features.SUPER_SPEED, speed.Apply)
    AddKeybind(Key.F4,    "F4",     {}, "Perfect Accuracy", config.Features.PERFECT_ACCURACY, perfect_accuracy.Apply)
    AddKeybind(Key.F5,    "F5",     {}, "Rapid Fire", config.Features.RAPID_FIRE, nil, rapid_fire.Reset)
    -- F6 skipped
    -- AddKeybind(Key.F7,    "F7",     {}, "Telekill Enemies", config.Features.TELEKILL, nil, nil)
    -- AddKeybind(Key.F8,    "F8",     {}, "Experimental Toggle", config.Features.EXPERIMENTAL_TOGGLE, nil, nil)

    print("[HeroesOfCheatsMod] Keybind Registration Complete.")
end

-- Function to get the formatted list for the main load message
function M.GetKeybindList()
    table.sort(KeybindList)
    return KeybindList
end

return M