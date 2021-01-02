dofile_once("mods/raksa/files/wands/entwand/processors.lua")
dofile_once("mods/raksa/files/scripts/lists/entity_categories.lua");

dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/scripts/enums.lua")

------------------------------
-- Entwand-specific helpers --
------------------------------

ICON_DELETE_ENTITY = "mods/raksa/files/gfx/entwand_icons/icon_delete_entity.png"
ICON_STAFF_OPTIONS = "mods/raksa/files/gfx/entwand_icons/icon_entity_staff_options.png"

ENTITY_POST_PROCESSORS = {
  disable_new_physicsbody_optimizations,
  remove_spawn_limits_set_by_camerabound,
  add_friendly_fire_corrector,
}

SCAN_RADIUS = 32
RETICLE_NAME = "spawner_reticle"

-- This is a fun little hack to keep the entity scanning still working & efficient.
-- Simply set the reticle entity outside the scanning range, and offset all sprites
-- & spawn points accordingly.
RETICLE_OFFSET = SCAN_RADIUS + 5


function change_active_entity(entity_index, category_index)
  GlobalsSetValue(SELECTED_ENTITY_INDEX, str(entity_index))
  GlobalsSetValue(SELECTED_ENTITY_TYPE, str(category_index))
end


function get_active_entity()
  local category_index = GlobalsGetNumber(SELECTED_ENTITY_TYPE)
  local entity_index = GlobalsGetNumber(SELECTED_ENTITY_INDEX)

  local category = ALL_ENTITIES[category_index]
  local entity = category.entities[entity_index]
  return entity
end


function get_or_create_reticle(x, y)
  local reticle = EntityGetWithName(RETICLE_NAME)
  if reticle and reticle ~= 0 then
    return reticle
  end

  return EntityCreateNew(RETICLE_NAME, x, y)
end


function change_spawner_reticle()
  local rows = GlobalsGetNumber(ENTWAND_ROWS)
  local cols = GlobalsGetNumber(ENTWAND_COLS)
  local grid_size = GlobalsGetNumber(ENTWAND_GRID_SIZE)
  local reticle = get_or_create_reticle()

  -- Destroy all existing SpriteComponents from the reticle
  local sprites = EntityGetComponentIncludingDisabled(reticle, "SpriteComponent")
  for i, SpriteComponent in ipairs(sprites or {}) do
    EntityRemoveComponent(reticle, SpriteComponent)
  end

  -- Populate entity with new spritecomponents
  function vars(x, y)
    local sprite_offset = 1

    -- Centering grid around the mouse & match it with the brush grid
    local center_x_offset = (cols - cols % 2) * grid_size / 2
    local center_y_offset = (rows - rows % 2) * grid_size / 2

    return {
      image_file="mods/raksa/files/gfx/spawner_pixel.png",
      offset_x=x + RETICLE_OFFSET + sprite_offset - center_x_offset,
      offset_y=y + RETICLE_OFFSET + sprite_offset - center_y_offset,
      alpha=0.5,
      additive=false,
      emissive=false,
      z_index=80,
    }
  end

  for row=0, rows-1 do
    local y = row*grid_size

    for col=0, cols-1 do
      local x = col*grid_size
      EntityAddComponent2(reticle, "SpriteComponent", vars(x, y))
    end
  end
end
