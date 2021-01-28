dofile_once("data/scripts/newgame_plus.lua")

dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/scripts/enums.lua")


-- Teleport player to spawn locations only when changing between Noita's
-- and our Conjurer's own worlds, not just different biomes.
function teleport_if_necessary(destination, x, y)
  local current_world = GlobalsGet(BIOME_CURRENT_WORLD)

  local to_conjurer = (
    current_world == BIOME_NOITA or current_world == BIOME_NOITA_NG
  )
  local to_noita = (
    current_world ~= BIOME_NOITA and
    current_world ~= BIOME_NOITA_NG and
    destination == BIOME_NOITA or destination == BIOME_NOITA_NG
  )

  if to_noita or to_conjurer then
    x, y = get_spawn_position(destination)
    print("TELEPORTING PLAYER TO "..tostring(x)..", "..tostring(y))
    teleport_player(x, y)
  else
    teleport_player(x, y)
  end
end


function collision_trigger(entity)
  if IsPlayer(entity) then
    local destination = GlobalsGet(BIOME_SELECTION)

    local biome_file = GlobalsGet(BIOME_SELECTION_FILE)
    local scene_file = GlobalsGet(BIOME_SELECTION_SCENE_FILE)

    -- Get previous world coordinates for keeping player position
    local x, y = EntityGetTransform(entity)

    print("Loading world files:")
    print(biome_file)
    print(scene_file)


    teleport_if_necessary(destination, x, y)

    -- Override all our own fun stuff with things necessary for loading NG+
    if destination == BIOME_NOITA_NG then
      GameClearOrbsFoundThisRun()

      do_newgame_plus()
      GlobalsSetValue(BIOME_CURRENT_WORLD, destination)
      return
    end

    -- Actually change the map
    BiomeMapLoad_KeepPlayer(biome_file, scene_file)

    -- [sic] teleport twice.
    -- Not all cases are handled by the first,
    -- and not all cases are handled by the second either.
    teleport_if_necessary(destination, x, y)

    -- Update current location
    GlobalsSetValue(BIOME_CURRENT_WORLD, destination)
    return
  end

  -- Kill any non-player colliding entities
  EntityConvertToMaterial(entity, "void_liquid")
  EntityKill(entity)
end
