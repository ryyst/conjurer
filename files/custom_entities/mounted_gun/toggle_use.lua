dofile_once("mods/raksa/files/scripts/utilities.lua")


function toggle_usage(player, gun)
  local GunUsageScript = EntityGetFirstComponentIncludingDisabled(
    gun, "LuaComponent", "gun_active_script"
  )

  local is_active = ComponentGetIsEnabled(GunUsageScript)
  EntitySetComponentIsEnabled(gun, GunUsageScript, not is_active)

  local GunComponent = EntityGetFirstComponentIncludingDisabled(player, "GunComponent")
  local is_wand_active = ComponentGetIsEnabled(GunComponent)
  EntitySetComponentIsEnabled(player, GunComponent, not is_wand_active)
end


function interacting(player, gun, gun_name)
  toggle_usage(player, gun)
end
