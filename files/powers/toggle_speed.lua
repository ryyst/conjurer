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
  GamePrint("Swoooosh!")

  -- TODO: Control with a simple particle entity on a player
  if HasFlagPersistent(SPEED_FLAG) then
    EntitySetValues(player, "CharacterPlatformingComponent", player_defaults)
    RemoveFlagPersistent(SPEED_FLAG)
  else
    EntitySetValues(player, "CharacterPlatformingComponent", speedy_vars)
    AddFlagPersistent(SPEED_FLAG)
  end
end
