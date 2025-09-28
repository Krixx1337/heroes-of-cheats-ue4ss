# Heroes of Valor UE4SS Mod

> [!WARNING]
> **This mod is for a now-outdated Early Access version of *Heroes of Valor*.**
> Due to significant game changes, **it is highly unlikely to work** with the current retail build or any post-early access patch. It is kept here for historical and educational purposes only.

A Lua-based mod for **Heroes of Valor**, built using **UE4SS (v3.0.1+)**, demonstrating custom gameplay modifications for educational and research purposes.

## Features & Default Keybinds

Toggle features ON/OFF using these keys:

*   **F1:** Damage Multiplier
*   **F2:** Burning Bullets
*   **F3:** Super Speed
*   **F4:** Perfect Accuracy (No Spread/Sway/Recoil)
*   **F5:** Rapid Fire Modes:
    *   **Character:** Weapon rapid fire & instant reload
    *   **Plane:** Rapid bomb dropping
    *   **Tank:** Holding Left Mouse Button fires main gun rapidly (bypasses reload)
*   **F7:** Vehicle Resilience Mode (Instant Repair)

Toggled status is shown in the UE4SS console. Modifications persist across respawns.

## Showcase

[Gameplay Mod Demonstration](https://streamable.com/0bpj9x)

## Installation (For End Users)

1.  **Install UE4SS:** Ensure UE4SS v3.0.1 or newer is installed for Heroes of Valor. Follow the official UE4SS installation guide. Typically this involves placing `dwmapi.dll` (or another proxy DLL) into the game's `...\Binaries\Win64\` folder and other UE4SS files into `...\Binaries\Win64\ue4ss\`. Ensure `UE4SS-settings.ini` enables the GUI console (`GuiConsoleEnabled = 1`, `GuiConsoleVisible = 1`).
2.  **Download Mod:**
    *   **Recommended:** Go to the [Releases page](https://github.com/Krixx1337/heroes-of-cheats-ue4ss/releases) and download the latest `.zip` file.
    *   **Alternatively (Latest Code):** On the main repository page, click "<> Code" -> "Download ZIP".
3.  **Extract Mod:** Copy the `HeroesOfValorMod` folder from the zip into your game's UE4SS mods directory:  
    `...\Heroes of Valor\Binaries\Win64\ue4ss\Mods\`
4.  **Enable Mod & Improve Stability:**
    *   Open `mods.txt` located in `...\Win64\ue4ss\Mods\`.
    *   Add the line: `HeroesOfValorMod : 1`
    *   **Stability Tip:** If present, disable `BPModLoaderMod` and `BPML_GenericFunctions` by setting them to `: 0`. This improves stability when using Lua mods only.
    ```
    ; Example mods.txt
    BPModLoaderMod : 0
    BPML_GenericFunctions : 0
    HeroesOfValorMod : 1
    Keybinds : 1
    ; other essential mods...
    ```
5.  **Launch Game:** Check the UE4SS console for loading messages from `[HeroesOfValorMod]`.

## Recommended Development Setup

1.  **Clone Repository:** Clone this repo to a folder **outside** your game directory.
2.  **Symbolic Link:** Link the `HeroesOfValorMod` folder from your repository into the game's `...\Win64\ue4ss\Mods\` directory using `mklink /D` (run Command Prompt as Administrator).
3.  **VSCode & IntelliSense:**
    *   Open the repository folder in VSCode.
    *   Install the `Lua` extension by `sumneko`.
    *   Run the game, use UE4SS console -> Dumpers -> "Generate Lua Types".
    *   Copy the generated `Mods\shared\types` folder into your repository root.
    *   Ensure `/types/` is in `.gitignore`.
    *   The included `.luarc.json` configures the Lua extension to use these types.
    *   Use `---@type ClassName` hints in code for best results.
4.  **Enable Mod:** Ensure `HeroesOfValorMod : 1` and the BP Loader mods (`: 0`) are set correctly in `mods.txt` for stable reloading during development.

## Development Notes

*   Built with a modular Lua structure
*   Requires UE4SS Lua API knowledge
*   Relies on game-specific properties and functions found via reverse engineering; game updates may break functionality

## Credits

*   **[fluffysnaff](https://github.com/fluffysnaff)** - Contributed to initial code and testing

## Disclaimer

This project is provided as-is, intended for educational and research purposes only. It demonstrates how to extend UE4-based games with Lua scripting through UE4SS. It is not designed for competitive or commercial use, and future game updates may break functionality.
