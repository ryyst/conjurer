dofile_once("mods/raksa/files/wands/entwand/processors.lua")
dofile_once("mods/raksa/files/scripts/lists/entity_categories.lua");

dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/scripts/enums.lua")

------------------------------
-- Entwand-specific helpers --
------------------------------

ICON_DELETE_ENTITY = "mods/raksa/files/gfx/entwand_icons/icon_delete_entity.png"

ENTITY_POST_PROCESSORS = {
  disable_new_physicsbody_optimizations,
  remove_spawn_limits_set_by_camerabound,
  add_friendly_fire_corrector,
}

RETICLE_NAME = "spawner_reticle"


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
  GamePrint("changing reticle!")
  -- Get grid size
  -- Get rows, cols
  -- Destroy all spritecomponents from the reticle
  -- Populate entity with new spritecomponents
  --  * counts according to the rows, cols 
  --  * distance by grid
  local reticle = get_or_create_reticle()
  EntityAddComponent2(reticle, "SpriteComponent", {
    image_file="mods/raksa/files/gfx/spawner_pixel.png",
    offset_x=1,
    offset_y=1,
    alpha=0.5,
    additive=false,
    emissive=false,
    z_index=80,
  })

  --
  --local corners = {
  --  { -- Topleft
  --    math.floor(total_size / 2),
  --    math.floor(total_size / 2)
  --  },
  --  { -- Topright
  --    math.floor(-total_size / 2) + 1,
  --    math.floor(total_size / 2)
  --  },
  --  { -- Bottomleft
  --    math.floor(total_size / 2),
  --    math.floor(-total_size / 2) + 1
  --  },
  --  { -- Bottomright
  --    math.floor(-total_size / 2) + 1,
  --    math.floor(-total_size / 2) + 1
  --  },
  --}

  --local replace = GlobalsGetBool(ERASER_REPLACE)
  --local image = replace and REPLACER_PIXEL or ERASER_PIXEL

  --for i, SpriteComponent in ipairs(EntityGetComponent(reticle, "SpriteComponent")) do
  --  -- The odd sizes (15, 25, ...) require their own offset
  --  local offset = chunk_count % 2

  --  local corner = corners[i]
  --  ComponentSetValue2(SpriteComponent, "offset_x", corner[1] + offset)
  --  ComponentSetValue2(SpriteComponent, "offset_y", corner[2] + offset)
  --  ComponentSetValue2(SpriteComponent, "image_file", image)
  --end
end

