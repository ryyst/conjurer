dofile_once("mods/raksa/files/scripts/lists/solids.lua");
dofile_once("mods/raksa/files/scripts/lists/sands.lua");
dofile_once("mods/raksa/files/scripts/lists/liquids.lua");
dofile_once("mods/raksa/files/scripts/lists/gases.lua");
dofile_once("mods/raksa/files/scripts/lists/fires.lua");
dofile_once("mods/raksa/files/scripts/lists/dangerous_materials.lua");


ALL_MATERIALS = {
  {
    name="Solids",
    icon="mods/raksa/files/gfx/matwand_icons/icon_solid.png",
    icon_off="mods/raksa/files/gfx/matwand_icons/icon_solid_off.png",
    materials=SOLIDS,
  },
  {
    name="Liquids",
    icon="mods/raksa/files/gfx/matwand_icons/icon_liquid.png",
    icon_off="mods/raksa/files/gfx/matwand_icons/icon_liquid_off.png",
    materials=LIQUIDS,
  },
  {
    name="Sands",
    icon="mods/raksa/files/gfx/matwand_icons/icon_sand.png",
    icon_off="mods/raksa/files/gfx/matwand_icons/icon_sand_off.png",
    materials=SANDS,
  },
  {
    name="Gases",
    materials=GASES,
    icon="mods/raksa/files/gfx/matwand_icons/icon_gas.png",
    icon_off="mods/raksa/files/gfx/matwand_icons/icon_gas_off.png",
  },
  {
    name="Fires & other",
    icon="mods/raksa/files/gfx/matwand_icons/icon_fire.png",
    icon_off="mods/raksa/files/gfx/matwand_icons/icon_fire_off.png",
    materials=FIRES,
  },
  {
    name="Catastrophic",
    icon="mods/raksa/files/gfx/matwand_icons/icon_dangerous.png",
    icon_off="mods/raksa/files/gfx/matwand_icons/icon_dangerous_off.png",
    materials=DANGEROUS,
  }
};
