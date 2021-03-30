***************************
** THE BACKGROUND UPDATE **
***************************

Map changes:
  - Spruced up all backgrounds & visuals for the whole spawn tower area
  - Fixed: The fireplace should be generally less hazardous
  - Fixed: The lake leaking into teleportatium
  - *Secrets*

Material wand:
  - New category: Solid Physics
    - Finally the ability to draw physical, moving, chunks of meat!
  - Changed: Default eraser filter from "Solids" to "All materials"
  - Fixed: Brush reticle now updates instantly when swapping brushes
  - Fixed: Eraser reticle now updates correctly when toggling Replace mode
  - Brush system overhaul:
    - "Brush Options" have been changed to "Drawing Options", with new sub-sections
    - Many new tools: Filler tool, Line tool, Different shapes, Tree grower...

Entity wand:
  - New category: Backgrounds
  - New category: Foregrounds
  - New wand setting: Ignore backgrounds when removing entities
  - New wand setting: Kill instead of deleting
  - New custom entities:
    - Heavy Machine Gun
    - Domino Blocks
  - Fixed: Terrible performance problem when using spawned wands/spells

New wand: Chaos Claw
  - Move, rotate & scale any entities
  - Inspect entities via [use]:
    - List the entity name, tags & other properties
    - Micro-adjust the entity position
    - Display animal hitboxes
    - Change internal component values

Powers:
  - New power: Trans-dimensional traveling; Change maps/biomes while in-game!
    - Includes 6 new custom areas and 6 basegame worlds
    - The "map selection" Mod Setting is removed along this new power
  - Nightfall Nakkikiska will now also enable self-damage for any enemies

Items:
  - Fixed: You will no longer suffocate inside materials when using the enchanted carrot

Other:
  - Fixed: Fog of war hole around the player was off for custom zoom levels.
  - Fixed: Global progress is disabled by default. Can be toggled via [Mod Settings]

Mod Extensions:
  - Material wand: Refactored huge parts of the brush system:
    - Brushes can now be freely categorized
    - More flags to brush controls
    - Exposed all brush & eraser click/hold/release handlers
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
