-- TODO: Cursor handling very similar to entwand. See if they could be combined.
function get_or_create_cursor(x, y)
  local cursor = EntityGetWithName("editwand_cursor")
  if cursor and cursor ~= 0 then
    return cursor
  end

  -- Offset initial load by *many pixels* from cursor position, because
  -- the engine insists on rendering it for 1 frame at the spawn position, no matter
  -- what hiding tricks we do. The positioning is immediately overtaken by
  -- InheritTransformComponent anyway.
  return EntityLoad("mods/raksa/files/wands/editwand/cursor.xml", x+1000, y+1000)
end


function scan_entity(x, y)
  local SCAN_RADIUS = 32
  local entities = EntityGetInRadius(x, y, SCAN_RADIUS)

  local entity = (#entities > 1) and EntityGetClosest(x, y) or entities[1]

  if entity then
    local root = EntityGetRootEntity(entity)
    if is_valid_entity(root) then
      show_cursor(root, x, y)
      return root
    end
    -- else: get_next_entity()
  end

  -- Nothing found
  hide_cursor()
  return nil
end


function hide_cursor()
  local cursor = EntityGetWithName("editwand_cursor")
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


function physics_enabled(entity, enable)
  local a = EntityFirstComponent(entity, "PhysicsBodyComponent")
  local b = EntityFirstComponent(entity, "CharacterDataComponent")
  local c = EntityFirstComponent(entity, "SimplePhysicsComponent")

  if a then ComponentSetValue2(a, "is_kinematic", not enable) end
  if b then EntitySetComponentIsEnabled(entity, b, enable) end
  if c then EntitySetComponentIsEnabled(entity, c, enable) end
end


function remove_joints(entity)
  local removable_components = {
    "PhysicsJointComponent", "PhysicsJoint2Component", "PhysicsJoint2MutatorComponent"
  }
  for _, comp_name in pairs(removable_components) do
    local comps = EntityGetComponentIncludingDisabled(entity, comp_name)
    if not comps then return end

    for _, comp in ipairs(comps) do
      EntityRemoveComponent(entity, comp)
    end
  end
end
