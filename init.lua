ModMagicNumbersFileAdd("mods/raksa/files/magic_numbers.xml")
ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/raksa/files/actions.lua")

dofile_once("mods/raksa/files/scripts/utilities.lua")
--dofile_once("mods/raksa/files/lib/gui.lua")


function OnWorldPostUpdate()
  --ComponentSetValue2(
  --  EntityGetFirstComponent(GameGetWorldStateEntity(), "WorldStateComponent"),
  --  "time", 0
  --)
end


function handle_inventory(player)
  local ITEMS_QUICK = {
    "mods/raksa/files/wands/matwand/entity.xml",
    "mods/raksa/files/wands/entwand/entity.xml",
    "data/entities/items/starting_wand_rng.xml",
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
  -- Camera follow sucks hard when building stuff
  EntitySetValue(player, "PlatformShooterPlayerComponent", "move_camera_with_aim", false)

  -- Endless flight
  EntitySetValue(player, "CharacterDataComponent", "flying_needs_recharge", false)
end


function OnPausedChanged( is_paused, is_inventory_pause )
  if is_paused then
    print("Paused!")
    GlobalsSetValue("raksa_is_paused", "1")
  else
    GlobalsSetValue("raksa_is_paused", "0")
  end
end


function OnPlayerSpawned(player)
  if (GlobalsGetValue("RAKSA_FIRST_LOAD_DONE") == "1") and (GlobalsGetValue("RAKSA_DIED") == "0") then
    return
  end

  handle_inventory(player)
  player_overrides(player)

  local x, y = EntityGetTransform(player)
  set_time_of_day(0.4)


  GlobalsSetValue("RAKSA_FIRST_LOAD_DONE", "1")
  GlobalsSetValue("RAKSA_DIED", "0")
end


function OnPlayerDied(player)
  GlobalsSetValue("RAKSA_DIED", "1")
  GamePrintImportant("You managed to die", "[Save & Quit] and [Continue] to keep your progress")
end
