dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/guns/matgun/helpers.lua");


function brush_reticle_follow_mouse(x, y)
  local brush_reticle = EntityGetWithName("brush_reticle")
  if brush_reticle then
    EntitySetTransform(brush_reticle, x, y)
  end
end


function draw(material, size)
  local default_brush = "mods/raksa/files/guns/matgun/brushes/5_brush.png"

  local brush_reticle = EntityGetWithName("brush_reticle")
  local brush = get_active_brush()

  EntityAddComponent2(brush_reticle, "ParticleEmitterComponent", {
    emitted_material_name=material,
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
    image_animation_speed=1,
    image_animation_loop=false,
    image_animation_raytrace_from_center=true,
    collide_with_gas_and_fire=false,
    set_magic_creation=true,
    is_emitting=true
  })
end


function erase(size, x, y)
  local eraser = EntityCreateNew()

  EntitySetTransform(eraser, x, y)
  EntityAddComponent(eraser, "CellEaterComponent",{
    eat_probability="100",
    radius=size*4,
    limited_materials="0"
  })
  EntityKill(eraser)
end


local x, y = DEBUG_GetMouseWorld()

brush_reticle_follow_mouse(x, y)


if is_holding_m1() then
  local material = GlobalsGetValue("raksa_selected_material", "soil")
  draw(material, 1)
end


if is_holding_m2() then
  erase(2, x, y)
end
