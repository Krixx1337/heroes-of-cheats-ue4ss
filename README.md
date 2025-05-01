# Heroes of Cheats (UE4SS Mod for Heroes of Valor)

A Lua-based mod for **Heroes of Valor**, built using **UE4SS (v3.0.1+)**, providing several cheat features.

## Features & Default Keybinds

Toggle features ON/OFF using these keys:

*   **F1:** Damage Multiplier
*   **F2:** Burning Bullets
*   **F3:** Super Speed
*   **F4:** Perfect Accuracy (No Spread/Sway/Recoil)
*   **F5:** Rapid Fire Toggle:
    *   **Character:** Weapon rapid fire & instant reload.
    *   **Plane:** Rapid bomb dropping.
    *   **Tank:** Holding Left Mouse Button fires main gun rapidly (bypasses reload).
*   **F7:** Vehicle God Mode (Instant Repair)

Toggled status is shown in the UE4SS console. Cheats persist across respawns.

## Clip Showcase

[Heroes of Rapid Fire](https://streamable.com/0bpj9x)

## Installation (For End Users)

1.  **Install UE4SS:** Ensure UE4SS v3.0.1 or newer is installed for Heroes of Valor. Follow the official UE4SS installation guide. Typically, this involves placing `dwmapi.dll` (or another proxy DLL) into the game's `...\Binaries\Win64\` folder and other UE4SS files into `...\Binaries\Win64\ue4ss\`. Ensure `UE4SS-settings.ini` enables the GUI console (`GuiConsoleEnabled = 1`, `GuiConsoleVisible = 1`).
2.  **Download Mod:**
    *   **Recommended:** Go to the [Releases page](https://github.com/Krixx1337/heroes-of-cheats-ue4ss/releases) and download the latest `.zip` file.
    *   **Alternatively (Latest Code):** On the main repository page, click "<> Code" -> "Download ZIP".
3.  **Extract Mod:** Copy the `HeroesOfCheatsMod` folder from the zip into your game's UE4SS mods directory: `...\Heroes of Valor\Binaries\Win64\ue4ss\Mods\`
4.  **Enable Mod & Improve Stability:**
    *   Open `mods.txt` located in `...\Win64\ue4ss\Mods\`.
    *   Add the line: `HeroesOfCheatsMod : 1`
    *   **Stability Tip:** If present, disable `BPModLoaderMod` and `BPML_GenericFunctions` by setting them to `: 0`. This improves stability if you only use Lua mods and can prevent crashes when reloading mods in-game.
    ```
    ; Example mods.txt
    BPModLoaderMod : 0
    BPML_GenericFunctions : 0
    HeroesOfCheatsMod : 1
    Keybinds : 1
    ; other essential mods...
    ```
5.  **Launch Game:** Check the UE4SS console for loading messages from `[HeroesOfCheatsMod]`.

## Recommended Development Setup

1.  **Clone Repository:** Clone this repo to a folder **outside** your game directory.
2.  **Symbolic Link:** Link the `HeroesOfCheatsMod` folder from your repository into the game's `...\Win64\ue4ss\Mods\` directory using `mklink /D` (run Command Prompt as Administrator).
3.  **VSCode & IntelliSense:**
    *   Open the repository folder in VSCode.
    *   Install the `Lua` extension by `sumneko`.
    *   Run the game, use UE4SS console -> Dumpers -> "Generate Lua Types".
    *   Copy the generated `Mods\shared\types` folder into your repository root.
    *   Ensure `/types/` is in `.gitignore`.
    *   The included `.luarc.json` configures the Lua extension to use these types.
    *   Use `---@type ClassName` hints in code for best results.
4.  **Enable Mod:** Ensure `HeroesOfCheatsMod : 1` and the BP Loader mods (`: 0`) are set correctly in `mods.txt` for stable reloading during development.

## Development Notes

*   Built with a modular Lua structure.
*   Requires UE4SS Lua API knowledge.
*   Relies on game-specific properties and functions found via reverse engineering; game updates may break functionality.

## Credits

*   **[fluffysnaff](https://github.com/fluffysnaff)** - Helped with initial code and testing.

## Disclaimer

Use responsibly. Provided as-is. Game updates may break functionality.