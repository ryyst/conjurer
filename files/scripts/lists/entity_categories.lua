dofile_once("mods/raksa/files/scripts/lists/animals.lua")
dofile_once("mods/raksa/files/scripts/lists/props.lua")
dofile_once("mods/raksa/files/scripts/lists/pickups.lua")
dofile_once("mods/raksa/files/scripts/lists/perks.lua")
dofile_once("mods/raksa/files/scripts/lists/spells.lua")
dofile_once("mods/raksa/files/scripts/lists/custom_entities.lua")


ALL_ENTITIES = {
  {
    name="Creatures",
    icon="mods/raksa/files/gfx/entwand_icons/icon_animals.png",
    icon_off="mods/raksa/files/gfx/entwand_icons/icon_animals_off.png",
    entities=ANIMALS,
  },
  {
    name="Props",
    icon="mods/raksa/files/gfx/entwand_icons/icon_props.png",
    icon_off="mods/raksa/files/gfx/entwand_icons/icon_props_off.png",
    entities=PROPS,
  },
  {
    name="Pickups",
    icon="mods/raksa/files/gfx/entwand_icons/icon_pickups.png",
    icon_off="mods/raksa/files/gfx/entwand_icons/icon_pickups_off.png",
    entities=PICKUPS,
  },
  {
    name="Perks",
    desc="Notice: There's no undoing picked up perks",
    icon="mods/raksa/files/gfx/entwand_icons/icon_pickups.png",
    icon_off="mods/raksa/files/gfx/entwand_icons/icon_pickups_off.png",
    entities=PERKS,
  },
  {
    name="Spells",
    desc="Added for your (in)convenience, until proper wand crafting is developed",
    icon="mods/raksa/files/gfx/entwand_icons/icon_pickups.png",
    icon_off="mods/raksa/files/gfx/entwand_icons/icon_pickups_off.png",
    entities=SPELLS,
    grid_size=32,
  },
  {
    name="Custom",
    icon="mods/raksa/files/gfx/entwand_icons/icon_custom.png",
    icon_off="mods/raksa/files/gfx/entwand_icons/icon_custom_off.png",
    entities=CUSTOM_ENTITIES,
  },
};
