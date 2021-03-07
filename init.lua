ModMaterialsFileAdd("mods/raksa/files/overrides/materials.xml")
ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/raksa/files/actions.lua")
ModLuaFileAppend("data/scripts/items/drop_money.lua", "mods/raksa/files/overrides/drop_money.lua")

dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/scripts/enums.lua")
dofile_once("mods/raksa/files/scripts/settings_handlers.lua")
dofile_once("mods/raksa/files/scripts/world_handlers.lua")


-- Settings handlers
handle_zoom_setting()

-- World overrides
append_custom_biomes()
replace_pixel_scenes()
replace_biome_map()


function handle_inventory(player)
  local ITEMS_QUICK = {
    "mods/raksa/files/wands/matwand/entity.xml",
    "mods/raksa/files/wands/entwand/entity.xml",
    "mods/raksa/files/wands/editwand/entity.xml",
    "data/entities/items/starting_wand_rng.xml",
    "mods/raksa/files/wands/carrot/entity.xml",
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
    local world = GameGetWorldStateEntity()

    -- Wind control
    local wind = GlobalsGetNumber(WIND_SPEED)
    EntitySetValue(world, "WorldStateComponent", "wind_speed", wind)

    -- Fog control
    local fog = GlobalsGetNumber(FOG_AMOUNT)
    EntitySetValue(world, "WorldStateComponent", "fog", fog)
    EntitySetValue(world, "WorldStateComponent", "fog_target", fog)
    EntitySetValue(world, "WorldStateComponent", "fog_target_extra", fog)

    -- Cloud control
    -- [sic] "Rain" variables, from the docs:
    -- "should be called clouds, controls amount of cloud cover in the sky"
    local clouds = GlobalsGetNumber(CLOUD_AMOUNT)
    EntitySetValue(world, "WorldStateComponent", "rain", clouds)
    EntitySetValue(world, "WorldStateComponent", "rain_target_extra", clouds)
  end
end
