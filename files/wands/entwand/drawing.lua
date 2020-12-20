dofile_once("data/scripts/lib/utilities.lua")

dofile_once("mods/raksa/files/wands/entwand/helpers.lua");

dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/scripts/enums.lua")


local HOVERED_ENTITY = nil
local SCAN_RADIUS = 32

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
  end

  -- Nothing found
  hide_cursor()
  HOVERED_ENTITY = nil
end


function is_valid_entity(entity)
  return (
    entity ~= nil and
    entity ~= 0 and
    EntityGetName(entity) ~= "entwand_cursor" and
    EntityGetName(entity) ~= "grid_overlay" and
    not IsPlayer(entity) and
    entity ~= GameGetWorldStateEntity() and
    -- This is something that always exists in 0,0.
    EntityGetName(entity) ~= "example_container"
  )
end


function delete_entity(x, y)
  EntityKill(HOVERED_ENTITY)
  HOVERED_ENTITY = nil
end


function spawn_entity(x, y)
  local entity_selection = get_active_entity()
  local entity = EntityLoad(entity_selection.path, x, y)
  postprocess_entity(entity)
end

function postprocess_entity(entity)
  for _, func in ipairs(ENTITY_POST_PROCESSORS) do
    func(entity)
  end
end


local x, y = DEBUG_GetMouseWorld()
scan_entity(x, y)


if has_clicked_m1() then
  spawn_entity(x, y)
end


if has_clicked_m2() then
  delete_entity(x, y)
end
