dofile_once("data/scripts/lib/utilities.lua")

dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/wands/matwand/helpers.lua");
dofile_once("mods/raksa/files/scripts/enums.lua")


--
-- LOCATION TRACKING
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


function brush_reticle_follow_mouse(x, y)
  local brush_reticle = EntityGetWithName("brush_reticle")
  if brush_reticle then
    local grid_size = get_brush_grid_size()
    -- Calculate offset for cursor to always be in the middle.
    x = x - x % grid_size + grid_size/2
    y = y - y % grid_size + grid_size/2
    EntitySetTransform(brush_reticle, math.floor(x), math.floor(y))
  end
end


--
-- DRAWING HANDLERS
--
function draw(material, brush)
  local reticle = EntityGetWithName("brush_reticle")
  local x, y = EntityGetTransform(reticle)
  local draw_vars = get_draw_vars(material, brush)

  EntityAddComponent2(reticle, "ParticleEmitterComponent", draw_vars)
end


function draw_filler(material, brush, x, y)
  local filler = EntityCreateNew()
  local draw_vars = get_draw_vars(material, brush)

  draw_vars["image_animation_raytrace_from_center"] = true

  EntityAddComponent2(filler, "LifetimeComponent", { lifetime=200 })
  EntityAddComponent2(filler, "ParticleEmitterComponent", draw_vars)
  EntitySetTransform(filler, x, y)
end


function draw_physics(material, brush, x, y)
  local reticle = EntityGetWithName("brush_reticle")
  EntityAddComponent2(
    reticle,
    "ParticleEmitterComponent",
    get_draw_vars("under_construction", brush)
  )
end


function draw_physics_release(material, brush, x, y)
  -- Conversion delay is added because our drawing logic has a short
  -- "trailing" for a few frames upon releasing mouse (on purpose).
  local seconds = 0.33
  SetTimeOut(
    seconds,
    "mods/raksa/files/wands/matwand/convert_to_box2d.lua",
    "convert_material"
  )
end


function erase(material)
  local chunk_count, chunk_size, total_size = get_eraser_size()
  local eraser_mode = get_eraser_mode()
  local eraser_replace = eraser_use_replacer()

  local from_any_material = (eraser_mode == ERASER_MODE_ALL)
  local from_selected = (eraser_mode == ERASER_MODE_SELECTED)

  local from_tag = from_any_material and "" or eraser_mode
  local from_material = from_selected and CellFactory_GetType(material) or 0
  local to_material = eraser_replace and material or "air"

  local reticle = EntityGetWithName("eraser_reticle")
  local x, y = EntityGetTransform(reticle)

  -- Start from the top left corner of the reticle
  x = math.floor(x - total_size / 2) + 2
  y = math.floor(y - total_size / 2) + 2


  -- Create 5x5px rectangular erasers in a grid shape.
  -- This is done *only* because making even-sized erasers witha radius seems
  -- impossible.  Eg. no radius will allow for an exactly 10px eraser.
  for row=0, chunk_count-1, 1 do
    for col=0, chunk_count-1, 1 do

      local eraser = EntityCreateNew()

      EntitySetTransform(eraser,
        math.floor(x + col * chunk_size),
        math.floor(y + row * chunk_size)
      )
      local vars = {
        radius=ERASER_CHUNK_RADIUS,
        is_circle=false,
        steps_per_frame=300,
        to_material=CellFactory_GetType(to_material),
        from_material_tag=from_tag,
        from_any_material=from_any_material,
        from_material=from_material,
        extinguish_fire=true,
        kill_when_finished=true
      }

      EntityAddComponent2(eraser, "MagicConvertMaterialComponent", vars)

      -- Sand is inconveniently split into 3 different tags. So we'll be
      -- creating one eraser chunk for each. And even *then* we'll be missing
      -- some sands, because they just aren't tagged as any type of sand.
      if eraser_mode == ERASER_MODE_SANDS then
        for i, sand_tag in ipairs({"[sand_metal]", "[sand_other]"}) do
          vars["from_material_tag"] = sand_tag
          EntityAddComponent2(eraser, "MagicConvertMaterialComponent", vars)
        end
      end
    end
  end
end


--
-- MISC UTILITIES
--
function get_draw_vars(material, brush)
  return {
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
end


--
-- MAIN LOGIC
--
local x, y = DEBUG_GetMouseWorld()
brush_reticle_follow_mouse(x, y)
eraser_reticle_follow_mouse(x, y)

local brush = get_active_brush()
local material, is_physics = get_active_material()

local holding_m1 = is_holding_m1()
local ACTION_HOLD_DRAW = not brush.click_to_use and holding_m1
local ACTION_CLICK_DRAW = brush.click_to_use and has_clicked_m1()
local ACTION_RELEASE_DRAW = (holding_m1 == false and PREV_HOLDING_M1 == true)
local ACTION_HOLD_ERASE = is_holding_m2()


if ACTION_HOLD_DRAW then
  if is_physics then
    draw_physics(material, brush, x, y)
  elseif brush.action then
    brush.action(material, brush, x, y)
  else
    -- Default action
    draw(material, brush)
  end
end


if ACTION_CLICK_DRAW then
  if is_physics then
    GamePrint("Physics materials not supported with radial brushes")
  elseif brush.action then
    brush.action(material, brush, x, y)
  else
    -- Default action
    draw_filler(material, brush, x, y)
  end
end


if ACTION_RELEASE_DRAW then
  if is_physics then
    draw_physics_release(material, brush, x, y)
  elseif brush.release_action then
    brush.release_action(material, brush, x, y)
  end
end


if ACTION_HOLD_ERASE then
  erase(material)
end


PREV_HOLDING_M1 = holding_m1
