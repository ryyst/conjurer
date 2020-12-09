dofile_once("data/scripts/lib/utilities.lua")

dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/wands/matwand/helpers.lua");
dofile_once("mods/raksa/files/scripts/enums.lua")


function brush_reticle_follow_mouse(x, y)
  local brush_reticle = EntityGetWithName("brush_reticle")
  if brush_reticle then
    local grid_size = get_brush_grid_size()
    EntitySetTransform(
      brush_reticle,
      -- Calculate +offset for cursor to always be in the middle.
      x - x % grid_size + grid_size/2,
      y - y % grid_size + grid_size/2
    )
  end
end


function draw(material, brush, draw_vars)
  local reticle = EntityGetWithName("brush_reticle")
  local x, y = EntityGetTransform(reticle)

  EntityAddComponent2(reticle, "ParticleEmitterComponent", draw_vars)
end


function draw_filler(material, brush, draw_vars, x, y)
  local filler = EntityCreateNew()

  draw_vars["image_animation_raytrace_from_center"] = true

  -- The lifetime might not be enough for whole 1024px² sprite to render entirely,
  -- but it should strike a good balance between performance & most common usecases.
  EntityAddComponent2(filler, "LifetimeComponent", { lifetime=90 })
  EntityAddComponent2(filler, "ParticleEmitterComponent", draw_vars)
  EntitySetTransform(filler, x, y)
end


function erase(x, y)
  local size = tonumber(GlobalsGetValue(ERASER_SIZE, ERASER_SIZE_DEFAULT))
  local eraser_mode = GlobalsGetValue(ERASER_MODE, ERASER_MODE_DEFAULT)

  local eraser = EntityCreateNew()
  EntitySetTransform(eraser, x, y)

  -- TODO:
  -- * Make ERASER_MODE_BOTH work properly.
  -- * Figure out why liquid eraser is not affected by size

  if eraser_mode == ERASER_MODE_LIQUIDS then
    EntityAddComponent(eraser, "MaterialSuckerComponent", {
      num_cells_sucked_per_frame=size*10000,
      material_type=0,
      barrel_size=1000000,
    })
  end

  if eraser_mode == ERASER_MODE_SOLIDS then
    EntityAddComponent(eraser, "CellEaterComponent",{
      radius=size*4,
      eat_probability="100",
      limited_materials="0"
    })
  end

  EntityAddComponent(eraser, "LifetimeComponent", { lifetime=2 })
end


local x, y = DEBUG_GetMouseWorld()
local brush = get_active_brush()
local material = GlobalsGetValue(SELECTED_MATERIAL, SELECTED_MATERIAL_DEFAULT)
local draw_vars = {
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
  image_animation_speed=2,
  image_animation_loop=false,
  image_animation_raytrace_from_center=false,
  collide_with_gas_and_fire=false,
  set_magic_creation=true,
  is_emitting=true
}

brush_reticle_follow_mouse(x, y)


if is_holding_m1() and not brush.is_filler_tool then
  draw(material, brush, draw_vars)
end


if has_clicked_m1() and brush.is_filler_tool then
  draw_filler(material, brush, draw_vars, x, y)
end


if is_holding_m2() then
  erase(x, y)
end
