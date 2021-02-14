dofile_once("mods/raksa/files/scripts/lists/solids.lua");
dofile_once("mods/raksa/files/scripts/lists/sands.lua");
dofile_once("mods/raksa/files/scripts/lists/liquids.lua");
dofile_once("mods/raksa/files/scripts/lists/gases.lua");
dofile_once("mods/raksa/files/scripts/lists/fires.lua");
dofile_once("mods/raksa/files/scripts/lists/box2d_solids.lua");
dofile_once("mods/raksa/files/scripts/lists/dangerous_materials.lua");

dofile_once("mods/raksa/files/scripts/utilities.lua")

ALL_MATERIALS = {
  {
    name="Statics",
    icon="mods/raksa/files/gfx/matwand_icons/icon_solid.png",
    icon_off="mods/raksa/files/gfx/matwand_icons/icon_solid_off.png",
    materials=SOLIDS,
  },
  {
    name="Solid Physics",
    desc="NOTICE:\nConjurer discretion is advised when summoning physical elements.\nRecklessness may cause total dimensional obliteration.",
    icon="mods/raksa/files/gfx/matwand_icons/icon_solid.png",
    icon_off="mods/raksa/files/gfx/matwand_icons/icon_solid_off.png",
    materials=enable_physics(BOX2D_SOLIDS),
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
  },
};


-- Create a second table for places where we don't want box2d materials
-- eg. rain, particle emitters, etc.
function _strip_physics()
  local nonphysics = {}
  for i, category in ipairs(ALL_MATERIALS) do
    if i ~= 2 then
      table.insert(nonphysics, category)
    end
  end

  return nonphysics
end

ALL_NONPHYSICS_MATERIALS = _strip_physics()


-- Remove all beta materials for non-beta builds.
-- Try to do this before calculating leftovers, so that when the materials
-- finally *are* released, I'm not in a hurry to set the is_beta to false,
-- because they should be found in the leftovers until I do.
if not GameIsBetaBuild() then
  print("Hiding pre-defined beta materials:")
  for i, category in ipairs(ALL_MATERIALS) do
    for j, mat in ipairs(category.materials) do
      if mat.is_beta then
        print("  * "..mat.name)
        table.remove(category.materials, j)
      end
    end
  end
end


-- Generate leftover materials table
dofile_once("mods/raksa/files/scripts/lists/leftovers.lua");
if LEFTOVERS and #LEFTOVERS > 0 then
  table.insert(ALL_MATERIALS, {
    name="Uncategorized",
    desc="All materials (including modded) appear here before\nthey are explicitly categorized by the modders.",
    icon="mods/raksa/files/gfx/matwand_icons/icon_leftovers.png",
    icon_off="mods/raksa/files/gfx/matwand_icons/icon_leftovers_off.png",
    materials=LEFTOVERS,
  })
end
