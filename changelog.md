***************************
** THE BACKGROUND UPDATE **
***************************

Map changes:
  - Spruced up all backgrounds & visuals for the whole spawn area
  - Fixed: The fireplace should be generally less hazardous
  - Fixed: The lake leaking into teleportatium
  - Fixed: The default flat world has more uniform terrain generation now
  - *Secrets*

Material wand:
  - New category: Solid Physics
    - Finally the ability to draw physical, movable & kickable chunks of meat!
  - Changed: Default eraser filter from "Solids" to "All materials"
  - Fixed: Brush reticle now updates instantly when swapping brushes
  - Fixed: Eraser reticle now updates correctly when toggling Replace mode
  - Brush system overhaul:
    - "Brush Options" have been changed to "Drawing Options", with new sub-sections
    - New tools: Filler tool, Line tool, Different shapes, Tree grower...

Entity wand:
  - New category: Backgrounds
  - New category: Foregrounds
  - New wand setting: Ignore backgrounds when removing entities
  - New wand setting: Kill instead of deleting
  - New wand setting: Toggle enemy gold drop
  - New custom entities:
    - Mounted Heavy Machine Gun
    - Domino Blocks
  - Fixed: Terrible performance problem when using spawned wands/spells
  - Added: All enemies/pickups/props from the Epilogue update
    - Let me know if I missed something!

New wand: Chaos Claw
  - Move, rotate & scale entities freely
  - Inspect entities via [use]:
    - List the entity name, tags, components & other properties
    - List and change internal component values
    - Controls to micro-adjust the entity properties
    - Display animal hitboxes

Powers:
  - New power: Trans-dimensional traveling; Change maps/biomes while in-game!
    - Includes 6 new custom areas and 6 basegame worlds
    - The "map selection" Mod Setting is removed along this new power
  - Changed: Weather overrides are now enabled by default
  - Experimental: Nightfall Nakkikiska now also enables self-damage for enemies

Items:
  - Fixed: You will no longer suffocate inside materials when using the enchanted carrot

Other:
  - Support for save slots
    - Currently only available in Noita beta branch
  - Fixed: Fog of war hole around the player was off for custom zoom levels
  - Fixed: Global progress is disabled by default. Can be toggled via [Mod Settings]
  - Bunch of minor UI changes:
    - Nicer checkboxes
    - Fine-tuning of probably most menus

Mod Extensions:
  - Material wand: Refactored huge parts of the brush system:
    - Brushes can now be freely categorized
    - More flags to brush controls
    - Exposed all brush & eraser click/hold/release handlers (custom_tools.lua for examples)
    - All coordinates received by action handlers now use the correct grid settings




**************************
** THE SOMETHING UPDATE **
**************************

Powers:
  - New power: Weather controls
  - New power: Freeze camera
  - New power: Location waypoint save system
    - Locations are preserved even after [Save & Quit] + [Continue]
  - New sky tinting controls in planetary rotation

Entity wand:
  - New category: Perks
  - New category: Spells*
  - All base game wand entities added to pickups*
  - Entity spawning is now locked to grid
  - Options to spawn & delete multiple entities simultaneously
  - Options to spawn & delete entities by holding the buttons

Material wand:
  - New category: "Uncategorized". This inlcudes:
    - All uncategorized modded materials**
    - Any base materials that are yet to be categorized (eg. after an update)
  - Added all new beta materials into the material lists. Visible only in beta.
    - Highlights: Orb Powder, Poo Gas, Rat Powder, all "Dark" materials

Other:
  - New item for Teleporting & Flight/Noclip
  - The base game final boss is now *actually* possible to activate
  - Multiple minor GUI improvements & bugfixes (better descriptions etc.)


*: Easy and crude quickfixes, until proper wand crafting is implemented
**: Modders can choose to categorize them elsewhere if they want to
