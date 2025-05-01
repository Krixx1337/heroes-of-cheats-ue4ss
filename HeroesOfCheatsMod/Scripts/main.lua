--[[
=====================================================================
 Heroes of Valor - Lua Mod
=====================================================================
 Main entry point for the Mod.
 Loads configuration, initializes state, sets up persistence,
 registers keybinds, and prints load messages.
 Ensures all features start disabled on load/reload.
=====================================================================
--]]

-- Load Core Modules with Error Checking
local success, config = pcall(require, "config"); if not success then error("FATAL: Failed to load config.lua: " .. tostring(config)) end
local success, state = pcall(require, "state"); if not success then error("FATAL: Failed to load state.lua: " .. tostring(state)) end
local success, utils = pcall(require, "utils"); if not success then error("FATAL: Failed to load utils.lua: " .. tostring(utils)) end
local success, persistence = pcall(require, "persistence"); if not success then error("FATAL: Failed to load persistence.lua: " .. tostring(persistence)) end
local success, keybinds = pcall(require, "keybinds"); if not success then error("FATAL: Failed to load keybinds.lua: " .. tostring(keybinds)) end

-- Load Feature Modules Safely
print("[HeroesOfCheatsMod] Loading Feature Modules...")
local featureModules = {
    "features.damage", "features.burning_bullets", "features.speed",
    "features.perfect_accuracy", "features.rapid_fire",
    "features.vehicle_god_mode",
    "features.experimental"
}
for _, path in ipairs(featureModules) do
    local s, err = pcall(require, path)
    if not s then print(string.format("FATAL ERROR loading '%s': %s", path, tostring(err))); error("Feature load failed.") end
end
print("[HeroesOfCheatsMod] Feature Modules Loaded.")

-- Load ApplyAll Module Last
local success, apply_all = pcall(require, "apply_all"); if not success then error("FATAL: Failed to load apply_all.lua: " .. tostring(apply_all)) end


-- Initialize Feature States
print("[HeroesOfCheatsMod] Initializing Feature States...")
for featureKey, featureInternalName in pairs(config.Features) do
    state.Initialize(featureInternalName) -- Ensure variable exists
    state.Set(featureInternalName, false) -- Force disable on load/reload
end
print("[HeroesOfCheatsMod] State Initialization Complete (All Features OFF).")


-- Setup Persistence Loop
print("[HeroesOfCheatsMod] Setting up Persistence Mechanism...")
persistence.SetupLoop()
print("[HeroesOfCheatsMod] Persistence Mechanism Active.")


-- Register Keybinds
keybinds.RegisterAll()


-- Mod Load Completion Message
print("-----------------------------------------------------")
print("[HeroesOfCheatsMod] Loaded Successfully (v1.1).")
print("  > All features initialized to OFF.")
print("  > Keybinds:")
local bindList = keybinds.GetKeybindList()
for _, bindInfo in ipairs(bindList) do
    print(bindInfo)
end
print("-----------------------------------------------------")
-- End of main script execution