dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/scripts/enums.lua")


local player_defaults = {
  jump_velocity_y=-95,
  jump_velocity_x=56,
  fly_speed_max_up=95,
  fly_speed_max_down=85,
  --fly_speed_change_spd=0.25,
  run_velocity=154,
  fly_velocity_x=52,
  velocity_min_x=-57,
  velocity_max_x=57,
  velocity_min_y=-200,
  velocity_max_y=350,
}


local MULTIPLIER = 7
local speedy_vars = {}
for key, var in pairs(player_defaults) do
  speedy_vars[key] = var*7
end


function toggle_speed()
  local player = get_player()

  -- TODO: Control with a simple particle entity on a player
  if HasFlagPersistent(SPEED_FLAG) then
    EntitySetValues(player, "CharacterPlatformingComponent", player_defaults)

    local particles = EntityGetWithName("raksa_speed_particles")
    EntityRemoveFromParent(particles)
    EntityKill(particles)

    RemoveFlagPersistent(SPEED_FLAG)
    GamePrint("The nimble magic wears off.")
  else
    EntitySetValues(player, "CharacterPlatformingComponent", speedy_vars)

    local particles = EntityLoad("mods/raksa/files/powers/speed_particles.xml")
    EntityAddChild(player, particles)

    AddFlagPersistent(SPEED_FLAG)
    GamePrint("You're feeling light!")
  end
end
