# Heroes of Cheats (UE4SS Mod for Heroes of Valor)

A Lua-based mod for **Heroes of Valor**, built using **UE4SS (v3.0.1+)**, providing several cheat features.

## Features & Default Keybinds

Toggle features ON/OFF using these keys:

*   **F1:** Damage Multiplier (x3)
*   **F2:** Burning Bullets
*   **F3:** Super Speed (x15)
*   **F4:** Perfect Accuracy (No Spread + No Sway + No Recoil)
*   **F5:** Rapid Fire Toggle:
    *   **Character:** Enables weapon rapid fire & instant reload.
    *   **Plane:** Enables rapid bomb dropping.
    *   **Tank:** While F5 is active, pressing **Left Mouse Button** in a tank directly triggers main gun firing, bypassing normal reload checks.

Toggled status is shown in the UE4SS console. Cheats persist across respawns.

## Clip Showcase

[Heroes of Rapid Fire](https://streamable.com/0bpj9x)

## Installation (For End Users)

1.  **Install UE4SS:** Ensure UE4SS v3.0.1 or newer is installed for Heroes of Valor. Follow the official UE4SS installation guide (typically involves placing `dwmapi.dll` in `...\Binaries\Win64\` and other files in `...\Binaries\Win64\ue4ss\`). Configure `UE4SS-settings.ini` (in `...\Win64\ue4ss\`) for Lua mods (`GuiConsoleEnabled = 1`, `GuiConsoleVisible = 1`, etc.).
2.  **Download Mod:**
    *   **Recommended:** Go to the [Releases page](https://github.com/Krixx1337/heroes-of-cheats-ue4ss/releases) and download the latest tagged release `.zip` file for a stable version.
    *   **Alternatively (Latest Code):** Go to the main repository page, click the green "<> Code" button, and select "Download ZIP". This will download the current development state, which might be unstable.
3.  **Extract Mod:** Copy the `HeroesOfCheatsMod` folder from the zip into your game's UE4SS mods directory: `...\Heroes of Valor\Binaries\Win64\ue4ss\Mods\`
4.  **Enable Mod:** Open `...\Win64\ue4ss\Mods\mods.txt` and add the line `HeroesOfCheatsMod : 1` (usually placed under `BPModLoaderMod : 1` if it exists).
5.  **Launch Game:** Check the UE4SS console for loading messages.

## Recommended Development Setup

1.  **Clone Repository:** Clone this repo to a dedicated folder **outside** your game directory (e.g., `C:\MyMods\heroes-of-cheats-ue4ss`).
2.  **Symbolic Link:**
    *   Delete any existing `HeroesOfCheatsMod` folder inside `<GameDir>\...\Win64\ue4ss\Mods\`.
    *   Open Command Prompt **as Administrator**.
    *   Run: `cd /d "<GameDir>\Heroes of Valor\Binaries\Win64\ue4ss\Mods"`
    *   Run: `mklink /D "HeroesOfCheatsMod" "<YourDevFolder>\heroes-of-cheats-ue4ss\HeroesOfCheatsMod"`
    *   *(Replace `<GameDir>` and `<YourDevFolder>` with your actual paths).*
3.  **VSCode & IntelliSense:**
    *   Open the **repository root folder** (e.g., `C:\MyMods\heroes-of-cheats-ue4ss`) in VSCode.
    *   Install the `Lua` extension by `sumneko`.
    *   Run the game once, use UE4SS console -> Dumpers -> "Generate Lua Types".
    *   Copy the generated `types` folder from `<GameDir>\...\Win64\ue4ss\Mods\shared\types` into your repository root.
    *   Ensure `/types/` is in `.gitignore`.
    *   The included `.luarc.json` is pre-configured to use `./types` and define common globals for better IntelliSense.
    *   Restart VSCode. Use `---@type ClassName` hints in code for best results (e.g., `---@type ABP_TankBase_C`).
4.  **Enable Mod:** Ensure `HeroesOfCheatsMod : 1` is in the game's `...\Win64\ue4ss\Mods\mods.txt` file (usually placed under `BPModLoaderMod : 1` if it exists).

## Configuration

Key settings can be adjusted in `Scripts/config.lua`:

*   `requiredPlayerClassName`, `requiredWeaponBaseClassName`, `requiredTankBaseClassName`, `requiredPlaneBaseClassName`: Verify these match your game version if cheats fail.
*   `loopIntervalMs`: Cheat enforcement loop speed.
*   `VK_LBUTTON`: Virtual Key code used for tank rapid fire override.

## Development Notes

*   Built with a modular Lua structure.
*   Requires UE4SS Lua API knowledge.
*   Relies on specific game property/function names (`DamageMultiplier`, `ActiveEquipable`, `VehicleRef`, `MC_Fire`, `BombReloading`, etc.) found via SDK/memory dumps. Game updates may break these.

## Credits

*   **[fluffysnaff](https://github.com/fluffysnaff)** - Helped with initial code and testing.

## Disclaimer

Use responsibly. Provided as-is. Game updates may break functionality.