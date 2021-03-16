
dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/scripts/enums.lua")


------------------------------
-- Matwand-specific helpers --
------------------------------

ERASER_ICONS = {
  [ERASER_MODE_ALL]="mods/raksa/files/gfx/matwand_icons/icon_erase_solids.png",
  [ERASER_MODE_SELECTED]="none, use active material",
  [ERASER_MODE_SOLIDS]="mods/raksa/files/gfx/matwand_icons/icon_solid.png",
  [ERASER_MODE_LIQUIDS]="mods/raksa/files/gfx/matwand_icons/icon_liquid.png",
  [ERASER_MODE_SANDS]="mods/raksa/files/gfx/matwand_icons/icon_sand.png",
  [ERASER_MODE_GASES]="mods/raksa/files/gfx/matwand_icons/icon_gas.png",
  [ERASER_MODE_FIRE]="mods/raksa/files/gfx/matwand_icons/icon_fire.png",
}

ERASER_CHUNK_SIZE = 5  -- pixels, with a radius of 3
ERASER_CHUNK_RADIUS = 3  -- Creates a square 5px hole


function get_active_material()
  return GlobalsGet(SELECTED_MATERIAL), GlobalsGetBool(SELECTED_MATERIAL_IS_PHYSICS)
end

function get_active_material_image()
  return GlobalsGet(SELECTED_MATERIAL_ICON)
end

function get_eraser_mode()
  return GlobalsGet(ERASER_MODE)
end

function get_eraser_size()
  -- Eraser sizes with chunk_count multiplier:
  -- 1: 5px
  -- 2: 10px
  -- 3: 15px
  -- ...

  local chunk_size = ERASER_CHUNK_SIZE
  local chunk_count = GlobalsGetNumber(ERASER_SIZE)
  local total_size = chunk_count * chunk_size
  return chunk_count, chunk_size, total_size
end

function eraser_use_brush_grid()
  return GlobalsGetBool(ERASER_SHARED_GRID)
end

function eraser_use_replacer()
  return GlobalsGetBool(ERASER_REPLACE)
end

function get_eraser_grid_size()
  return GlobalsGetNumber(ERASER_GRID_SIZE)
end

function get_brush_grid_size()
  return GlobalsGetNumber(BRUSH_GRID_SIZE)
end


function grid_snap(x, y, grid_size)
  -- Snap to given grid
  x = x - x % grid_size
  y = y - y % grid_size

  -- Center-align around the cursor
  x = x + grid_size/2
  y = y + grid_size/2

  -- Finally, snap to Noita's pixel grid
  return math.floor(x), math.floor(y)
end


function change_eraser_reticle()
  local chunk_count, chunk_size, total_size = get_eraser_size()
  local reticle = EntityGetWithName("eraser_reticle")

  local corners = {
    { -- Topleft
      math.floor(total_size / 2),
      math.floor(total_size / 2)
    },
    { -- Topright
      math.floor(-total_size / 2) + 1,
      math.floor(total_size / 2)
    },
    { -- Bottomleft
      math.floor(total_size / 2),
      math.floor(-total_size / 2) + 1
    },
    { -- Bottomright
      math.floor(-total_size / 2) + 1,
      math.floor(-total_size / 2) + 1
    },
  }

  local replace = GlobalsGetBool(ERASER_REPLACE)
  local image = replace and REPLACER_PIXEL or ERASER_PIXEL

  for i, SpriteComponent in ipairs(EntityGetComponent(reticle, "SpriteComponent")) do
    -- The odd sizes (15, 25, ...) require their own offset
    local offset = chunk_count % 2

    local corner = corners[i]
    ComponentSetValue2(SpriteComponent, "offset_x", corner[1] + offset)
    ComponentSetValue2(SpriteComponent, "offset_y", corner[2] + offset)
    ComponentSetValue2(SpriteComponent, "image_file", image)

    EntityRefreshSprite(reticle, SpriteComponent)
  end
end


function change_active_brush(brush, brush_category_index, brush_index)
  -- Change reticle
  local brush_reticle = EntityGetWithName("brush_reticle")
  EntitySetValues(brush_reticle, "SpriteComponent", {
    image_file = brush.reticle_file,
    offset_x = brush.offset_x,
    offset_y = brush.offset_y,
  })

  EntityRefreshSprite(brush_reticle, EntityFirstComponent(brush_reticle, "SpriteComponent"))

  -- Change drawing brush shape
  GlobalsSetValue(SELECTED_BRUSH, tostring(brush_index))
  GlobalsSetValue(SELECTED_BRUSH_CATEGORY, tostring(brush_category_index))
end


function get_active_brush()
  -- Avoid circular imports
  local ALL_DRAWING_TOOLS = dofile("mods/raksa/files/scripts/lists/brushes.lua")

  local brush_index = GlobalsGetNumber(SELECTED_BRUSH)
  local brush_category_index = GlobalsGetNumber(SELECTED_BRUSH_CATEGORY)

  local brushes = ALL_DRAWING_TOOLS[brush_category_index].brushes

  return brushes[brush_index], brush_category_index, brush_index
end


function get_active_eraser_image()
  local current_eraser = GlobalsGet(ERASER_MODE)
  if current_eraser == ERASER_MODE_SELECTED then
    return get_active_material_image()
  end
  return ERASER_ICONS[current_eraser]
end


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
