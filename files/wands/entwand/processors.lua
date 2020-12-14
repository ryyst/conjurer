function disable_new_physicsbody_optimizations(entity)
  local Body = EntityGetFirstComponentIncludingDisabled(entity, "PhysicsBody2Component")
  if Body then
    ComponentSetValue2(Body, "kill_entity_after_initialized", false)
    ComponentSetValue2(Body, "destroy_body_if_entity_destroyed", true)
  end
end


function remove_spawn_limits_set_by_camerabound(entity)
  -- The only thing limiting player's imagination should be his CPU.
  -- TODO: Figure out how big of a performance hit this actually is.
  local CameraBound = EntityGetFirstComponentIncludingDisabled(entity, "CameraBoundComponent")
  if CameraBound then
    EntityRemoveComponent(entity, CameraBound)
  end
end
