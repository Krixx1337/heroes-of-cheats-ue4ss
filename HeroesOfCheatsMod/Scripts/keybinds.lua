--[[
    Keybind Registration
    Registers feature toggles and handles LMB override for tank rapid fire.
--]]
local config = require("config")
local handler = require("handler")
local state = require("state")
local utils = require("utils")

-- Feature modules needed for specific toggle handlers (Apply/Reset)
local damage = require("features.damage")
local burning_bullets = require("features.burning_bullets")
local speed = require("features.speed")
local perfect_accuracy = require("features.perfect_accuracy")
local rapid_fire = require("features.rapid_fire")

local M = {}
local KeybindList = {} -- Stores info for the load message

-- Helper to register and track toggleable feature keybinds
local function AddKeybind(key, keyName, mods, featureDisplayName, featureInternalName, onEnableFunc, onDisableFunc)
    RegisterKeyBind(key, mods, handler.CreateToggleHandler(featureDisplayName, featureInternalName, onEnableFunc, onDisableFunc))
    -- Format modifiers for display string
    local modStr = ""
    if mods and #mods > 0 then local modNames = {}; for _, modKey in ipairs(mods) do if modKey == ModifierKey.CONTROL then table.insert(modNames, "Ctrl") elseif modKey == ModifierKey.SHIFT then table.insert(modNames, "Shift") elseif modKey == ModifierKey.ALT then table.insert(modNames, "Alt") else table.insert(modNames, "Mod?") end end; modStr = table.concat(modNames, "+") .. "+" end
    table.insert(KeybindList, string.format("    %s%s -> %s", modStr, keyName, featureDisplayName or "Unknown Feature"))
end

-- Function to register all binds
function M.RegisterAll()
    print("[HeroesOfCheatsMod] Registering Keybinds...")

    -- Register toggleable cheats
    AddKeybind(Key.F1, "F1", {}, "Damage Multiplier", config.Features.INF_DAMAGE, damage.Apply, damage.Apply)
    AddKeybind(Key.F2, "F2", {}, "Burning Bullets", config.Features.BURN_BULLETS, burning_bullets.Apply, burning_bullets.Apply)
    AddKeybind(Key.F3, "F3", {}, "Super Speed", config.Features.SUPER_SPEED, speed.Apply, speed.Apply)
    AddKeybind(Key.F4, "F4", {}, "Perfect Accuracy", config.Features.PERFECT_ACCURACY, perfect_accuracy.Apply, perfect_accuracy.Apply)
    AddKeybind(Key.F5, "F5", {}, "Rapid Fire (Character/Plane/Tank)", config.Features.RAPID_FIRE, rapid_fire.Apply, rapid_fire.Reset)
    -- F6 skipped
    AddKeybind(Key.F7, "F7", {}, "Vehicle God Mode", config.Features.VEHICLE_GOD_MODE, nil, nil)
    -- AddKeybind(Key.HOME, "HOME", {}, "Experimental Toggle", config.Features.EXPERIMENTAL_TOGGLE, nil, nil)

    -- Register Left Mouse Button handler for Tank Rapid Fire directly using VK code
    -- This allows firing the tank gun by holding LMB when F5 is active, bypassing normal checks.
    RegisterKeyBind(Key.LEFT_MOUSE_BUTTON, {}, function()
        if not state.Get(config.Features.RAPID_FIRE) then return end -- Check F5 state

        ---@type ABP_VehicleBase_C | nil
        local vehicle = utils.GetCurrentVehicle()
        if vehicle and utils.DoesInheritFrom(vehicle, config.requiredTankBaseClassName) then
            ---@type ABP_TankBase_C
            local tank = vehicle -- Type hint after successful check
            -- Attempt to call MC_Fire directly via pcall for safety
            pcall(function() tank:MC_Fire() end)
        end
    end)

    print("[HeroesOfCheatsMod] Keybind Registration Complete.")
end

-- Function to get the formatted list for the main load message
function M.GetKeybindList()
    table.sort(KeybindList)
    return KeybindList
end

return M