dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/luoja/files/scripts/utilities.lua")

dofile_once("mods/luoja/files/gui/base.lua");


-- Brush reticle mouse follow
local x, y = DEBUG_GetMouseWorld()
local brush_reticle = EntityGetWithName("brush_reticle")
if brush_reticle then
  EntitySetTransform(brush_reticle, x, y)
end


function draw(material, size)
  local brush_reticle = EntityGetWithName("brush_reticle")
  EntityAddComponent2(brush_reticle, "ParticleEmitterComponent", {
    emitted_material_name=material,
    create_real_particles=true,
    lifetime_min=1,
    lifetime_max=1,
    count_min=1,
    count_max=1,
    render_on_grid=true,
    fade_based_on_lifetime=true,
    cosmetic_force_create=false,
    airflow_force=0.251,
    airflow_time=1.01,
    airflow_scale=0.05,
    emission_interval_min_frames=1,
    emission_interval_max_frames=1,
    emit_cosmetic_particles=false,
    image_animation_file="mods/luoja/files/guns/matgun/brushes/draw_".. size ..".png",
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

function is_blocked()
  return GlobalsGetValue("is_drawing_blocked", "0" ) == "1";
end

if is_holding_m1() then
  if is_blocked() then return end

  local material = GlobalsGetValue("luoja_selected_material", "soil")
  draw(material, 1)
end


if is_holding_m2() then
  if is_blocked() then return end

  erase(2, x, y)
end
