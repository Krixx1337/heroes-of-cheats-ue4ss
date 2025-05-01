--[[
=====================================================================
 Heroes of Valor - Lua Mod
=====================================================================
 Main entry point for the Mod.
 Loads configuration, initializes state, sets up persistence,
 registers keybinds, and prints load messages.
 Ensures all features start disabled on load/reload.
 Includes hook for cache invalidation.
=====================================================================
--]]

-- Load Core Modules with Error Checking
local success_config, config = pcall(require, "config"); if not success_config then error("FATAL: Failed to load config.lua: " .. tostring(config)) end
local success_state, state = pcall(require, "state"); if not success_state then error("FATAL: Failed to load state.lua: " .. tostring(state)) end
local success_utils, utils = pcall(require, "utils"); if not success_utils then error("FATAL: Failed to load utils.lua: " .. tostring(utils)) end
local success_persistence, persistence = pcall(require, "persistence"); if not success_persistence then error("FATAL: Failed to load persistence.lua: " .. tostring(persistence)) end
local success_keybinds, keybinds = pcall(require, "keybinds"); if not success_keybinds then error("FATAL: Failed to load keybinds.lua: " .. tostring(keybinds)) end
local success_apply_all, apply_all = pcall(require, "apply_all"); if not success_apply_all then error("FATAL: Failed to load apply_all.lua: " .. tostring(apply_all)) end

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
    if not s then print(string.format("[HeroesOfCheatsMod] FATAL ERROR loading '%s': %s", path, tostring(err))); error("Feature load failed.") end
end
print("[HeroesOfCheatsMod] Feature Modules Loaded.")

-- Load ApplyAll Module
local success_apply_all, apply_all = pcall(require, "apply_all"); if not success_apply_all then error("FATAL: Failed to load apply_all.lua: " .. tostring(apply_all)) end

-- Initialize Feature States
print("[HeroesOfCheatsMod] Initializing Feature States...")
for featureKey, featureInternalName in pairs(config.Features) do
    state.Initialize(featureInternalName)
    state.Set(featureInternalName, false) -- Force disable on load/reload
end
print("[HeroesOfCheatsMod] State Initialization Complete (All Features OFF).")


-- Register Keybinds
keybinds.RegisterAll()


-- Setup Persistence Loop (Run immediately, relies on caching in utils)
print("[HeroesOfCheatsMod] Setting up Persistence Mechanism...")
persistence.SetupLoop()
print("[HeroesOfCheatsMod] Persistence Mechanism Active.")


-- Register Hook for Cache Invalidation
print("[HeroesOfCheatsMod] Registering Cache Invalidation Hook...")
RegisterHook("/Script/Engine.PlayerController:ClientRestart", function(ContextParam)
    -- This hook fires on map load, respawn, and potentially other state resets.
    -- Invalidate caches to force re-lookup of player pawn / possessed vehicle.
    -- print("[HeroesOfCheatsMod] PlayerController:ClientRestart hooked, invalidating caches...") -- Optional debug
    local s, e = pcall(utils.InvalidateCaches) -- Use the consolidated invalidation function
    if not s then print("[HeroesOfCheatsMod] Error invalidating caches: "..tostring(e)) end
end)
print("[HeroesOfCheatsMod] Cache Invalidation Hook Registered.")


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