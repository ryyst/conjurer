function disable_new_physicsbody_optimizations(entity)
  local Body = EntityGetFirstComponentIncludingDisabled(entity, "PhysicsBody2Component")
  if Body then
    ComponentSetValue2(Body, "kill_entity_after_initialized", false)
    ComponentSetValue2(Body, "destroy_body_if_entity_destroyed", true)
  end
end


function remove_spawn_limits_set_by_camerabound(entity)
  -- The only thing limiting player's imagination should be his CPU.
  local CameraBound = EntityGetFirstComponentIncludingDisabled(entity, "CameraBoundComponent")
  if CameraBound then
    EntityRemoveComponent(entity, CameraBound)
  end
end


function add_friendly_fire_corrector(entity)
  -- If global world hatred is <=-100 we'll want enemies to hurt the same herd.
  EntityAddComponent2(entity, "LuaComponent", {
    script_shot="mods/raksa/files/powers/correct_friendly_fire.lua"
  })
end
