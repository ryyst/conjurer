dofile_once("data/scripts/newgame_plus.lua")

dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/scripts/enums.lua")

dofile_once("mods/raksa/files/wands/matwand/toggle_brush.lua")


-- Teleport player to spawn locations only when changing between Noita's
-- and our Conjurer's own worlds, not just different biomes.
function teleport_if_necessary(destination_world)
  local current_world = GlobalsGet(WORLD_CURRENT)

  if current_world ~= destination_world then
    local x, y = get_spawn_position(destination_world)
    print("TELEPORTING PLAYER TO "..tostring(x)..", "..tostring(y))
    teleport_player(x, y)
  end
end


function collision_trigger(entity)
  if IsPlayer(entity) then
    local destination_biome = GlobalsGet(BIOME_SELECTION)
    local destination_world = GlobalsGet(WORLD_SELECTION)

    local biome_file = GlobalsGet(BIOME_SELECTION_FILE)
    local scene_file = GlobalsGet(BIOME_SELECTION_SCENE_FILE)

    print("Loading world files:")
    print(biome_file)
    print(scene_file)

    teleport_if_necessary(destination_world)

    -- Mimic a "real" seeds that base worlds get. Something between 8 and 10 digits
    local seed = Random(10000000, 9999999999)
    SetWorldSeed(seed)

    -- Override all our own fun stuff with things necessary for loading NG+
    if destination_biome == BIOME_NOITA_NG then
      GameClearOrbsFoundThisRun()

      do_newgame_plus()
      GlobalsSetValue(BIOME_CURRENT, destination_biome)
      return
    end

    -- Actually change the map
    BiomeMapLoad_KeepPlayer(biome_file, scene_file)

    -- Update current location
    GlobalsSetValue(BIOME_CURRENT, destination_biome)
    GlobalsSetValue(WORLD_CURRENT, destination_world)

    -- Fix a case where you couldn't draw after a teleport, before swapping wands.
    if EntityGetName(get_active_wand()) == "matwand" then
      create_brush()
    end
    return
  end

  -- Kill any non-player colliding entities
  EntityConvertToMaterial(entity, "void_liquid")
  EntityKill(entity)
end
