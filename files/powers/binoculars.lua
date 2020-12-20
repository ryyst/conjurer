dofile_once("mods/raksa/files/scripts/utilities.lua")


BINOCULARS_ACTIVE = false


function toggle_player_movement(is_enabled)
  local player = get_player()
  if not player then return end

  local platComponent = EntityGetFirstComponentIncludingDisabled(player, "CharacterPlatformingComponent")

  EntitySetComponentIsEnabled(player, platComponent, is_enabled)

  if not is_enabled then
    local dataComp = EntityGetFirstComponent(player, "CharacterDataComponent")
    ComponentSetValueVector2(dataComp, "mVelocity", 0, 0)
  end
end


function toggle_binoculars()
  toggle_player_movement(BINOCULARS_ACTIVE)

  BINOCULARS_ACTIVE = not BINOCULARS_ACTIVE
  GameSetCameraFree(BINOCULARS_ACTIVE)
end
