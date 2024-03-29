dofile_once("data/scripts/lib/utilities.lua")

dofile_once("mods/raksa/files/wands/entwand/helpers.lua");
dofile_once("mods/raksa/files/wands/wand_utilities.lua");

dofile_once("mods/raksa/files/powers/binoculars.lua")
dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/scripts/enums.lua")


local HOVERED_ENTITY = nil


function spawner_reticle_follow_mouse(x, y)
  local reticle = EntityGetWithName(RETICLE_NAME)
  if reticle then
    local grid_size = GlobalsGetNumber(ENTWAND_GRID_SIZE)
    x = x - x % grid_size
    y = y - y % grid_size
    EntitySetTransform(reticle, math.floor(x+RETICLE_OFFSET), math.floor(y+RETICLE_OFFSET))
  end
end


function get_or_create_cursor(x, y)
  local cursor = EntityGetWithName("entwand_cursor")
  if cursor and cursor ~= 0 then
    return cursor
  end

  -- Offset initial load by *many pixels* from cursor position, because
  -- the engine insists on rendering it for 1 frame at the spawn position, no matter
  -- what hiding tricks we do. The positioning is immediately overtaken by
  -- InheritTransformComponent anyway.
  return EntityLoad("mods/raksa/files/wands/entwand/cursor.xml", x+1000, y+1000)
end


function hide_cursor()
  local cursor = EntityGetWithName("entwand_cursor")
  EntityKill(cursor)
end


function show_cursor(entity, x, y)
  local cursor = get_or_create_cursor(x, y)

  if EntityGetParent(cursor) ~= entity then
    if EntityGetParent(cursor) ~= cursor then
      EntityRemoveFromParent(cursor)
    end
    EntityAddChild(entity, cursor)
  end
end


function scan_entity(x, y)
  local entities = EntityGetInRadius(x, y, SCAN_RADIUS)

  local entity = (#entities > 1) and EntityGetClosest(x, y) or entities[1]

  if entity then
    local root = EntityGetRootEntity(entity)
    if is_valid_entity(root) then
      show_cursor(root, x, y)
      HOVERED_ENTITY = root
      return
    end
    -- else: get_next_entity()
  end

  -- Nothing found
  hide_cursor()
  HOVERED_ENTITY = nil
end



function delete_entity(x, y)
  local DamageModel = EntityFirstComponent(HOVERED_ENTITY, "DamageModelComponent")
  if GlobalsGetBool(ENTWAND_KILL_INSTEAD) and DamageModel then
    -- Thanks KeithSammut!
    ComponentSetValue2(DamageModel, "hp", 0)
    ComponentSetValue2(DamageModel, "air_needed", true)
    ComponentSetValue2(DamageModel, "air_in_lungs", 0)
    HOVERED_ENTITY = nil
    return
  end

  EntityKill(HOVERED_ENTITY)
  HOVERED_ENTITY = nil
end


function delete_all(x, y)
  local entities = EntityGetInRadius(x, y, SCAN_RADIUS)
  for i, entity in ipairs(entities) do
    local root = EntityGetRootEntity(entity)
    if is_valid_entity(root) then
      EntityKill(root)
    end
  end
end


function spawn_entity()
  local rows = GlobalsGetNumber(ENTWAND_ROWS)
  local cols = GlobalsGetNumber(ENTWAND_COLS)
  local grid_size = GlobalsGetNumber(ENTWAND_GRID_SIZE)
  local reticle = EntityGetWithName(RETICLE_NAME)
  local reticle_x, reticle_y = EntityGetTransform(reticle)

  local entity_selection = get_active_entity()

  -- Centering grid around the mouse & match it with the brush grid
  local centerize_offset_x = (cols - cols % 2) * grid_size / 2
  local centerize_offset_y = (rows - rows % 2) * grid_size / 2

  for row=0, rows-1 do
    local grid_offset_y = reticle_y - row*grid_size
    local y = math.floor(grid_offset_y - RETICLE_OFFSET + centerize_offset_y)

    for col=0, cols-1 do
      local grid_offset_x = reticle_x - col*grid_size
      local x = math.floor(grid_offset_x - RETICLE_OFFSET + centerize_offset_x)

      -- Manual spawn function always overrides simple spawn-by-path
      local entity = (
        entity_selection.spawn_func
        and entity_selection.spawn_func(x, y)
        or EntityLoad(entity_selection.path, x, y)
      )

      -- Per-entity post-processing
      if entity_selection.post_processor then
        entity_selection.post_processor(entity, x, y)
      end

      -- Global level post-processors, for every entity
      postprocess_entity(entity)
    end
  end
end


local x, y = DEBUG_GetMouseWorld()
scan_entity(x, y)
spawner_reticle_follow_mouse(x, y)


local spawn_function = GlobalsGetBool(ENTWAND_HOLD_TO_SPAWN) and is_holding_m1 or has_clicked_m1
if spawn_function() then
  spawn_entity()
end


local delete_function = GlobalsGetBool(ENTWAND_HOLD_TO_DELETE) and is_holding_m2 or has_clicked_m2
if delete_function() then
  if GlobalsGetBool(ENTWAND_DELETE_ALL) then
    delete_all(x, y)
  else
    delete_entity(x, y)
  end
end
