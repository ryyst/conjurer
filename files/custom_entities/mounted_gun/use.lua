dofile_once("data/scripts/lib/utilities.lua")

dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/custom_entities/mounted_gun/toggle_use.lua")


local gun = GetUpdatedEntityID()
local player = get_player()

local player_x, player_y = EntityGetTransform(player)
local mouse_x, mouse_y = DEBUG_GetMouseWorld()
local x, y = EntityGetTransform(gun)

local rot = 0 - math.atan2( mouse_y - y, mouse_x - x )

-- Turn the gun
EntitySetTransform(gun, x, y, -rot)

-- Shoot every...
local EVERY_N_FRAMES = 3
if is_holding_m1(true) and GameGetFrameNum() % EVERY_N_FRAMES == 0 then
  -- shoot_pos
  local offset_x, offset_y = EntityGetValue(gun, "HotspotComponent", "offset")

  local VELOCITY = 3000
  local vel_x = math.cos(rot) * VELOCITY
  local vel_y = 0 - math.sin(rot) * VELOCITY

  local gun_length = 12
  local shoot_x = x + gun_length * math.cos(rot)
  local shoot_y = y + gun_length * -math.sin(rot)

  shoot_projectile(
    player,
    "mods/raksa/files/custom_entities/mounted_gun/bullet.xml",
    shoot_x, shoot_y,
    vel_x, vel_y,
    true
  )

  local muzzle = EntityLoad("mods/raksa/files/custom_entities/mounted_gun/muzzle_flash.xml", shoot_x, shoot_y)
  EntitySetTransform(muzzle, shoot_x, shoot_y, -rot)
end


-- Turn off when going too far
if get_distance(x, y, player_x, player_y) > 16 then
  toggle_usage(player, gun)
end
