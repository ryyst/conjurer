ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/raksa/files/actions.lua")

dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/scripts/enums.lua")
dofile_once("mods/raksa/files/scripts/settings_handlers.lua")


handle_map_setting()
handle_zoom_setting()


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


function OnPlayerSpawned(player)
  -- Make real sure the global GUI container is loaded.
  if #(EntityGetWithTag("raksa_gui_container") or {}) == 0 then
    EntityLoad('mods/raksa/files/gui/gui_container.xml' );
  end

  if not GlobalsGetBool(FIRST_LOAD_DONE) or GlobalsGetBool(PLAYER_HAS_DIED) then
    handle_inventory(player)
    player_overrides(player)

    -- Always start on noon
    set_time_of_day(NOON)

    -- Disable initial fog & cloud (="rain") states
    EntitySetValues(
      GameGetWorldStateEntity(),
      "WorldStateComponent", {
        fog=0, fog_target=0, fog_target_extra=0,
        rain=0, rain_target=0, rain_target_extra=0,
    })

    GlobalsSetValue(FIRST_LOAD_DONE, "1")
    GlobalsSetValue(PLAYER_HAS_DIED, "0")
  end
end


function OnPlayerDied(player)
 GlobalsToggleBool(PLAYER_HAS_DIED)
  GamePrintImportant(
    "Somehow you managed to die for real",
    "[Save & Quit] and [Continue] to keep your progress and respawn"
  )
end


function OnWorldPreUpdate()
  if GlobalsGetBool(RAIN_ENABLED) then
    -- TODO: Maybe add a little variance to the count?
    GameEmitRainParticles(
      GlobalsGetNumber(RAIN_COUNT),
      GlobalsGetNumber(RAIN_WIDTH),
      GlobalsGet(RAIN_MATERIAL),
      GlobalsGetNumber(RAIN_VELOCITY_MIN),
      GlobalsGetNumber(RAIN_VELOCITY_MAX),
      GlobalsGetNumber(RAIN_GRAVITY),
      GlobalsGetBool(RAIN_BOUNCE),
      GlobalsGetBool(RAIN_DRAW_LONG)
    )
  end

  if GlobalsGetBool(WIND_OVERRIDE_ENABLED) then
    EntitySetValue(
      GameGetWorldStateEntity(),
      "WorldStateComponent",
      "wind_speed",
      GlobalsGetNumber(WIND_SPEED)
    )
  end
end
