# Halcyon
Halcyon is a mod for [PMDO](https://github.com/audinowho/PMDODump/) created by Palika that aims to recapture the vibes and energy of Explorers in an all-new original adventure.
It currently consists of 4 chapters. 
A final length of 10-12 chapters is currently planned.

## To install and play
1. [Download and install PMDO](https://github.com/audinowho/PMDODump/releases) if you have not already.
2. Download Halcyon as a zip file from the [Github project releases](https://github.com/Palikadude/Halcyon/releases). The latest release should be the most stable one.
3. Extract the Halcyon zip file to its own folder.
4. Place extracted Halcyon folder into PMDO's MODS folder. The exact file path changes depending on where you put PMDO, but it should go something like PMDO/MODS/Halcyon in the end.
5. Make sure Halcyon is not embedded an extra folder down! When you click on Halcyon's folder in your MODS folder, it should have the readme file in plain sight, and not in another folder!
6. Start PMDO, and select Halcyon from the main menu via Special Episodes.

If you're having trouble installing the game, or have any questions, comments, feedback, etc., please join the [PMDO discord](https://discord.gg/37VKndMsr2) and talk with Palika there! The dedicated channel for Halcyon discussion is #quest-halcyon.



## FAQ
1. I'm having a weird audio stuttering issue! How can I fix it?
* If you're encountering this issue, you'll need to run PMDO with the following command line argument to force it to use a different audio driver: -audiodriver:wasapi
* If you don't know how to this, look in the Halcyon Mods folder and put the audio-wasapi.bat file into the same folder as your PMDO.exe, then use the .bat file to boot the game instead of the .exe file.

2. I got softlocked in a dungeon/cutscene! Why is this, and how can I fix it?
* This is typically caused by one of two things:
* 1. PMDO has updated since the build of Halcyon you're playing on was released, and caused some sort of incompatibility issue due to changing how some function works or something else under the hood.
* 2. The build of Halcyon you're playing on is meant for a later version of PMDO than the version you're playing on.
* If the first case happens, you'll either need to downgrade using PMDOSetup.exe to an earlier version of PMDO that is compatible with that build of Halcyon, or you'll need to wait for a fix that addresses the incompatibility. This case is more likely if your PMDO version is recent, but the build of Halcyon is from a while ago.
* If the second case happens, you'll need to simply update PMDO to the latest version using PMDOSetup.exe. This case is more likely if you haven't updated your PMDO in a while.
* Alternatively, there is a third case which is more rare, which is simply a programming error. In any event, if you're struggling to fix the softlock, don't hestitate to report the issue in the Halcyon channel in the PMDO Discord. It'll help you (and the developer) figure out what's wrong and address it properly.

## Credits
* **Palika** — mod author. scripting, writing, balancing, mapping, etc. (all non-engine work, except where other credit is given)  
* **Audino** — for making the engine, adding features that I needed for the game. His work cannot be understated as without him this mod would not exist  
* **Trio-** — Mission_gen in-dungeon scripting, other scripting features/enhancements/quality of lifes 

### Music credits:
* Minemaker0430 - Anima Core theme

### Scripting credits:
* MistressNebula - Recruitment Search integration for Halcyon, Custom Menu used for Cafe/Merchant Daily Specials. All starter's mod custom menu for picking player/partner.
* Touhou Project - Dungeon Generation help. Illuminant Riverbed rocks / river extension work.

### Spriting credits:
* Edan Momu — guild exterior and partial interior sprite work
* D4yz — guild interior tilesets and original guild decorations pixel art
* Jaifain — Eating and Posing sprites for Growlithe, Breloom, Noctowl, Tropius, Snubbull, Cranidos, Girafarig, and Zigzagoon; <br>
River animations for Illuminant Riverbed's Entrance, Metano Town, Metano Outskirts, and Altere Pond. <br>
Anima core and anima root animations. Scarfed Sandile Portraits.
* Baroness Faron — Audino upwards eating + posing sprites
* Happysmily — Shuckle's cafe animations, sandile scarf sprites
* Cait_Sith — Luxio fainting animation
* NanaelJustice — Cleaning up staircases inside guild and adding some detail to them
* Minemaker0430 — Scarf sprites for player/partner characters, except where other credit is given for these
* Sunkern — Apricorn Grove tilesets, recolor for Searing Tunnel's exterior
* 3P1C - Snivy and Tepig Scarf sprites

### Playtesters:
* Sunkern
* Audino
* Xindage
* Minemaker0430
* NanaelJustice
* Trio-
* Dovey
* Brimcon
* The kitchen sunk

Other custom sprites and animations come from the master [PMD Sprite Repository](https://sprites.pmdcollab.org/) and were not custom made for this mod.

If you helped in some way and aren't listed here (probably because I forgot, sorry!) please let me know.

### Special thanks
* Game Freak, Spike Chunsoft, and The Pokémon Company for creating Pokémon and Pokémon Mystery Dungeon. They reserve all rights to Pokémon and Pokémon Mystery Dungeon.
* NeoGeoThomas — For putting the first trailer together
* borzoiteeth — for inspiring the game in the first place
* [SkyTemple](https://skytemple.org/) community — For helping me figure out base Explorer's behavior for some cutscenes and functions
