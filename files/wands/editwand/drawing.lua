dofile_once("data/scripts/lib/utilities.lua")

dofile_once("mods/raksa/files/wands/editwand/helpers.lua");
dofile_once("mods/raksa/files/wands/wand_utilities.lua");

dofile_once("mods/raksa/files/powers/binoculars.lua")
dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/scripts/enums.lua")


ENTITY_TO_MOVE = ENTITY_TO_MOVE or nil
ENTITY_TO_ROTATE = ENTITY_TO_ROTATE or nil
PREV_HOVERED_ENTITY = PREV_HOVERED_ENTITY or nil


function move_entity(entity, x, y)
  EntityApplyTransform(entity, x, y)
end


function freeze_entity(entity)
  PhysicsSetStatic(entity, true)

  ENTITY_TO_MOVE = nil
  ENTITY_TO_ROTATE = nil
end


function rotate_entity(entity, x, y)
  local mass = EntityGetValue(entity, "PhysicsBody2Component", "mPixelCount")

  -- This essentially resets the torque, making it turn linearly
  PhysicsSetStatic(entity, true)
  PhysicsSetStatic(entity, false)

  if mass then
    PhysicsApplyTorque(entity, mass)
    return
  end

  local entity_x, entity_y = EntityGetTransform(entity)
  local rot = math.atan2(entity_y-y, entity_x-x)

  EntitySetTransform(entity, entity_x, entity_y, rot)
end


function m1_click_event(entity)
  ENTITY_TO_MOVE = entity
  PhysicsSetStatic(entity, false)
  physics_enabled(entity, false)
  remove_joints(entity)
end


function m2_click_event(entity)
  ENTITY_TO_ROTATE = entity
  physics_enabled(entity, false)
  remove_joints(entity)
end


function m1_release_event(entity)
  physics_enabled(entity, true)
  ENTITY_TO_MOVE = nil
end


function m2_release_event(entity)
  freeze_entity(entity)
end


function m1_action(entity, x, y)
  move_entity(entity, x, y)

  if has_clicked_m2() then
    freeze_entity(entity)
  end
end


function m2_action(entity, x, y)
  rotate_entity(entity, x, y)
end

function interact_action(entity, x, y)
  local target_has_changed = GlobalsGetNumber(ENTITY_TO_INSPECT) ~= PREV_HOVERED_ENTITY
  local target_is_alive = entity and EntityGetIsAlive(entity)

  if not target_is_alive or target_has_changed then
    GlobalsSetValue(SIGNAL_RESET_EDITWAND_GUI, "1")
  end

  GlobalsSetValue(ENTITY_TO_INSPECT, tostring(entity))

  -- Toggle indicator
  local old_indicator = EntityGetWithName("editwand_indicator")
  if old_indicator and EntityGetIsAlive(old_indicator) and target_has_changed then
    EntityKill(old_indicator)
  end

  if target_is_alive and target_has_changed then
    local new_indicator = EntityLoad("mods/raksa/files/wands/editwand/selected_indicator.xml", x-1000, y-1000)
    EntityAddChild(entity, new_indicator)
  end
end


local x, y = DEBUG_GetMouseWorld()
local hovered_entity = scan_entity(x, y)

local only_m1_clicked = has_clicked_m1() and not is_holding_m2() and hovered_entity
local only_m2_clicked = has_clicked_m2() and not is_holding_m1() and hovered_entity

local m1_action_released = not is_holding_m1() and ENTITY_TO_MOVE
local m2_action_released = not is_holding_m2() and ENTITY_TO_ROTATE

-- Click events
if only_m1_clicked then m1_click_event(hovered_entity) end
if only_m2_clicked then m2_click_event(hovered_entity) end

-- Release event
if m1_action_released then m1_release_event(ENTITY_TO_MOVE) end
if m2_action_released then m2_release_event(ENTITY_TO_ROTATE) end

-- Actions
if ENTITY_TO_MOVE then m1_action(ENTITY_TO_MOVE, x, y) end
if ENTITY_TO_ROTATE then m2_action(ENTITY_TO_ROTATE, x, y) end

if has_clicked_interact() then interact_action(hovered_entity, x, y) end


PREV_HOVERED_ENTITY = hovered_entity
