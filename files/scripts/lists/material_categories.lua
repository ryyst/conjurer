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
    icon="mods/raksa/files/gfx/matwand_icons/icon_solid.png",
    icon_off="mods/raksa/files/gfx/matwand_icons/icon_solid_off.png",
    materials=BOX2D_SOLIDS,
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


for i, mat in ipairs(ALL_MATERIALS[2].materials) do
  mat.action = function(material, brush, x, y)
    print("HALOO!")
    local reticle = EntityGetWithName("brush_reticle")
    EntityAddComponent2(reticle, "ParticleEmitterComponent", {
        emitted_material_name="under_construction",
        image_animation_file=brush.brush_file,

        create_real_particles=true,
        lifetime_min=1,
        lifetime_max=1,
        count_min=1,
        count_max=1,
        render_on_grid=true,
        fade_based_on_lifetime=true,
        cosmetic_force_create=false,
        emission_interval_min_frames=1,
        emission_interval_max_frames=1,
        emit_cosmetic_particles=false,
        image_animation_speed=2,
        image_animation_loop=false,
        image_animation_raytrace_from_center=false,
        collide_with_gas_and_fire=false,
        set_magic_creation=true,
        is_emitting=true
      })
  end
  mat.release_action = function(material, brush, x, y)
    local player = get_player()
    local x, y = EntityGetTransform(player)
    ConvertMaterialOnAreaInstantly(
      x-1000, y-1000,
      3000, 3000,
      CellFactory_GetType("under_construction"), CellFactory_GetType(material),
      true,
      false
    )
  end
end

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
