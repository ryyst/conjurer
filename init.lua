ModMagicNumbersFileAdd("mods/raksa/files/magic_numbers.xml")
ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/raksa/files/actions.lua")

dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/powers/gui.lua")


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

  -- Never die
  EntitySetValue(player, "DamageModelComponent", "wait_for_kill_flag_on_death", true)
  EntityAddComponent(player, "LuaComponent", {
    script_damage_received="mods/raksa/files/scripts/death.lua",
  })
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
  RemoveFlagPersistent(SPEED_FLAG)

  -- The global GUI. Otherwise we use wands for specific tool GUIs.
  if #(EntityGetWithTag("raksa_powers_gui") or {}) == 0 then
    EntityLoad('mods/raksa/files/powers/gui_container.xml' );
  end

  local is_first_load = GlobalsGetValue("RAKSA_FIRST_LOAD_DONE", "0") == "0"
  local has_died = GlobalsGetValue("RAKSA_DIED", "0") == "1"
  if (is_first_load or has_died) then
    AddFlagPersistent(KALMA_RECALL_FLAG)

    handle_inventory(player)
    player_overrides(player)


    local world_state_entity = GameGetWorldStateEntity()
    EntitySetValues(world_state_entity, "WorldStateComponent", {
      -- MAYBE SOME OF THESE COULD WORK, PLEASE?!
      fog=0, rain=0,
      fog_target=0, rain_target=0,
      fog_target_extra=0, rain_target_extra=0,
    })

    local defaultttt = EntityGetValue(world_state_entity, "WorldStateComponent", "time_dt")
    GamePrint(str(defaultttt))

    -- Always start on noon
    set_time_of_day(NOON)


    GlobalsSetValue("RAKSA_FIRST_LOAD_DONE", "1")
    GlobalsSetValue("RAKSA_DIED", "0")
  end
end


function OnPlayerDied(player)
  GlobalsSetValue("RAKSA_DIED", "1")
  GamePrintImportant("You managed to die", "[Save & Quit] and [Continue] to keep your progress and respawn")
end
