dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/scripts/enums.lua")


function get_binoculars_active()
  return GlobalsGetBool(BINOCULARS_ACTIVE)
end


-- Conjurer Eye
function toggle_player_movement(is_enabled)
  local player = get_player()
  if not player then return end

  local CharacterPlatforming = EntityGetFirstComponentIncludingDisabled(
    player,
    "CharacterPlatformingComponent"
  )

  EntitySetComponentIsEnabled(player, CharacterPlatforming, is_enabled)

  if not is_enabled then
    local dataComp = EntityGetFirstComponent(player, "CharacterDataComponent")
    ComponentSetValueVector2(dataComp, "mVelocity", 0, 0)
  end
end


function toggle_binoculars()
  local is_active = get_binoculars_active()

  toggle_player_movement(is_active)
  GameSetCameraFree(not is_active)

  GlobalsToggleBool(BINOCULARS_ACTIVE)

  local text = not is_active and "You leave your body behind" or "You return to your body"
  GamePrint(text)
end


-- Glass Eye
function toggle_camera_controls()
  local player = get_player()
  if not player then return end

  -- Make sure binoculars are turned off
  if get_binoculars_active() then
    -- TODO:
    -- Figure out how to make the camera stay properly when binoculars are used.
    -- Previous tries always put the camera back in player's starting position,
    -- no matter how we tried to set it manually.
    toggle_binoculars()
  end

  EntityToggleValue(
    player,
    "PlatformShooterPlayerComponent",
    "center_camera_on_this_entity"
  )

  local is_active = not EntityGetValue(
    player,
    "PlatformShooterPlayerComponent",
    "center_camera_on_this_entity"
  )

  local text = is_active and "You feel a familiar presence watching over you..." or "The watcher fades"
  GamePrint(text)
end
