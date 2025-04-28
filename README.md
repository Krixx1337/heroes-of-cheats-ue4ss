# Heroes of Cheats (UE4SS Mod for Heroes of Valor)

A Lua-based mod for **Heroes of Valor**, built using **UE4SS (v3.0.1+)**, providing several cheat features.

## Features & Default Keybinds

Toggle features ON/OFF using these keys:

*   **F1:** Damage Multiplier (x100)
*   **F2:** Burning Bullets
*   **F3:** Super Speed (x15)
*   **F4:** Perfect Accuracy (No Spread + No Sway + No Recoil)
*   **F5:** Rapid Fire (+ Instant Reload)

Toggled status is shown in the UE4SS console. Cheats persist across respawns.

## Clip Showcase

[Heroes of Rapid Fire](https://streamable.com/0bpj9x)

## Installation

1.  **Install UE4SS:** Ensure UE4SS v3.0.1 or newer is installed for Heroes of Valor. Follow the official UE4SS installation guide. Configure `UE4SS-settings.ini` for Lua mods (`ConsoleEnabled = 0`, `GuiConsoleEnabled = 1`, etc.).
2.  **Download Mod:**
    *   **Recommended:** Go to the [Releases page](https://github.com/Krixx1337/heroes-of-cheats-ue4ss/releases) and download the latest tagged release `.zip` file.
    *   **Alternatively (Latest Code):** Go to the main repository page, click the green "<> Code" button, and select "Download ZIP". This will download the current development state.
3.  **Extract Mod:** Extract the downloaded zip file. Inside, you should find a folder named `HeroesOfCheatsMod` (or similar, containing a `Scripts` folder). Copy this `HeroesOfCheatsMod` folder into your game's UE4SS mods directory: `...\Heroes of Valor\Binaries\Win64\ue4ss\Mods\`
    *   The final path should look like: `...\ue4ss\Mods\HeroesOfCheatsMod\Scripts\`
4.  **Enable Mod:** Open `...\ue4ss\Mods\mods.txt` and add the line:
    ```
    HeroesOfCheatsMod : 1
    ```
5.  **Launch Game:** The UE4SS console should show messages from `[HeroesOfCheatsMod]` on startup, including the keybind list.

## Configuration

Key settings can be adjusted in `Scripts/config.lua`:

*   `requiredPlayerClassName`, `requiredWeaponBaseClassName`: Verify these match your game version if cheats fail.
*   `loopIntervalMs`: Cheat enforcement loop speed.
*   Default values for speed/rapid fire reset.

## Development Notes

*   Built with a modular Lua structure.
*   Requires UE4SS Lua API knowledge.
*   Relies on specific game property names (`DamageMultiplier`, `ActiveEquipable`, `PawnDataComponent.Team`, etc.) found via SDK/memory dumps. Game updates may break these.

## Credits

*   **[fluffysnaff](https://github.com/fluffysnaff)** - Helped with initial code and testing.

## Disclaimer

Use cheats responsibly, especially in online environments (if applicable). This mod is provided as-is. Game updates may break functionality.