dofile_once("data/scripts/lib/utilities.lua")

dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/wands/matwand/helpers.lua");
dofile_once("mods/raksa/files/scripts/enums.lua")


--
-- TODO: THIS THING????
-- MagicConvertMaterialComponent
--


function eraser_reticle_follow_mouse(x, y)
  local eraser_reticle = EntityGetWithName("eraser_reticle")
  if eraser_reticle then
    local grid_size = eraser_use_brush_grid() and get_brush_grid_size() or get_eraser_grid_size()
    x = x - x % grid_size + grid_size/2
    y = y - y % grid_size + grid_size/2
    EntitySetTransform(eraser_reticle, math.floor(x), math.floor(y))
  end
end

function brush_reticle_follow_mouse(x, y, is_filler_tool)
  local brush_reticle = EntityGetWithName("brush_reticle")
  if brush_reticle then
    local grid_size = get_brush_grid_size()
    -- Calculate offset for cursor to always be in the middle.
    x = x - x % grid_size + grid_size/2
    y = y - y % grid_size + grid_size/2
    EntitySetTransform(brush_reticle, math.floor(x), math.floor(y))
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

  EntityAddComponent2(filler, "LifetimeComponent", { lifetime=200 })
  EntityAddComponent2(filler, "ParticleEmitterComponent", draw_vars)
  EntitySetTransform(filler, x, y)
end


function erase(material)
  local PIXELS = 5  -- with a radius of 3
  local multiplier = tonumber(GlobalsGetValue(ERASER_SIZE, ERASER_SIZE_DEFAULT))
  local size = multiplier * PIXELS
  local eraser_mode = GlobalsGetValue(ERASER_MODE, ERASER_MODE_DEFAULT)

  local eraser_replace = GlobalsGetValue(ERASER_REPLACE, ERASER_REPLACE_DEFAULT) == "1"

  -- Eraser sizes with multiplier:
  -- 1: 5px
  -- 2: 10px
  -- 3: 15px
  -- ...

  local reticle = EntityGetWithName("eraser_reticle")
  local x, y = EntityGetTransform(reticle)

  -- Start from the top left corner of the reticle
  x = math.floor(x - size / 2) + 2
  y = math.floor(y - size / 2) + 2

  for row=0, multiplier-1, 1 do
    for col=0, multiplier-1, 1 do
      local eraser = EntityCreateNew()

      -- offset each entity
      EntitySetTransform(eraser,
        math.floor(x + col * PIXELS),
        math.floor(y + row * PIXELS)
      )

      local from_any_material = (eraser_mode == ERASER_MODE_ALL)
      local from_selected = (eraser_mode == ERASER_MODE_SELECTED)

      local from_tag = from_any_material and "" or eraser_mode
      local from_material = from_selected and CellFactory_GetType(material) or 0

      local to_material = eraser_replace and material or "air"

      EntityAddComponent2(eraser, "MagicConvertMaterialComponent",{
        radius=3, -- Creates a square 5px hole
        is_circle=false,
        to_material=CellFactory_GetType(to_material),
        from_material_tag=from_tag,
        from_any_material=from_any_material,
        from_material=from_material,
        extinguish_fire=true,
        kill_when_finished=true
      })
    end
  end
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
eraser_reticle_follow_mouse(x, y)


if is_holding_m1() and not brush.is_filler_tool then
  draw(material, brush, draw_vars)
end


if has_clicked_m1() and brush.is_filler_tool then
  draw_filler(material, brush, draw_vars, x, y)
end


if is_holding_m2() then
  erase(material)
end
