dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/scripts/enums.lua")


function get_binoculars_active()
  return GlobalsGetValue(BINOCULARS_ACTIVE, BINOCULARS_ACTIVE_DEFAULT) == "1"
end


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
  local is_active = get_binoculars_active()

  toggle_player_movement(is_active)

  is_active = not is_active
  GameSetCameraFree(is_active)

  GlobalsSetValue(BINOCULARS_ACTIVE, bool_to_global(is_active))
end
