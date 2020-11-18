ModMagicNumbersFileAdd("mods/raksa/files/magic_numbers.xml")
--ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/raksa/files/actions.lua")

dofile_once("mods/raksa/files/scripts/utilities.lua")


function OnWorldPostUpdate()
  --ComponentSetValue2(
  --  EntityGetFirstComponent(GameGetWorldStateEntity(), "WorldStateComponent"),
  --  "time", 0
  --)
end


function handle_inventory(player)
  local ITEMS_QUICK = {
    "mods/raksa/files/guns/matgun/entity.xml",
  }
  local ITEMS_FULL = {
  }

  local inv_quick = EntityGetWithName("inventory_quick")
  local inv_full = EntityGetWithName("inventory_full")

  clear_player_inventory(player, inv_quick)
  give_player_items(inv_quick, ITEMS_QUICK)
  give_player_items(inv_full, ITEMS_FULL)
end


function player_overrides(player)
  EntitySetValue(player, "PlatformShooterPlayerComponent", "move_camera_with_aim", false)
end


function OnPlayerSpawned(player)
  if (GlobalsGetValue("RAKSA_FIRST_LOAD_DONE") == "1") then
    return
  end

  EntityAddComponent2( player, "LuaComponent", {
    execute_every_n_frame=1,
    script_source_file="mods/raksa/files/gui/layout.lua"
  });

  handle_inventory(player)
  player_overrides(player)

  local x, y = EntityGetTransform(player)
  set_time_of_day(0.4)

  GlobalsSetValue("RAKSA_FIRST_LOAD_DONE", "1")
end
