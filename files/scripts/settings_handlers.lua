local nxml = dofile_once("mods/raksa/files/lib/nxml.lua")


function _replace_map()
  -- We don't want any of the default pixel scenes spawning in our world,
  -- so just replace everything. Conjurer-specific pixel scenes are something to
  -- look into, if that ever comes up.
  local pixel_scenes = ModTextFileGetContent("mods/raksa/files/overrides/_pixel_scenes.xml")
  ModTextFileSetContent("data/biome/_pixel_scenes.xml", pixel_scenes)
end


function _append_biomes()
  local biome_backyard = nxml.new_element("Biome", {
      biome_filename="mods/raksa/files/biomes/takapiha.xml",
      height_index="0",
      color="ffc0ff33",
  })

  local biome_data = ModTextFileGetContent("data/biome/_biomes_all.xml")
  local biomes_xml = nxml.parse(biome_data)

  biomes_xml:add_child(biome_backyard)

  local biome_data_patched = nxml.tostring(biomes_xml)
  ModTextFileSetContent("data/biome/_biomes_all.xml", biome_data_patched)
end


function handle_zoom_setting()
  local zoom = ModSettingGet("raksa.zoom_level")
  if zoom == "noita" then
    -- Nothing needs overwriting
    return
  end

  local ZOOM_LEVELS = {
    conjurer="mods/raksa/files/overrides/resolution_conjurer.xml",
    huge="mods/raksa/files/overrides/resolution_huge.xml",
    fullhd="mods/raksa/files/overrides/resolution_fullhd.xml",
  }

  ModMagicNumbersFileAdd(ZOOM_LEVELS[zoom])
end


function handle_map_setting()
  local map = ModSettingGet("raksa.map_selection")
  if map == "noita" then
    -- Nothing needs overwriting
    return
  end

  local AVAILABLE_MAPS = {
    conjurer="mods/raksa/files/overrides/map_conjurer.xml",
  }

  ModMagicNumbersFileAdd(AVAILABLE_MAPS[map])
  _append_biomes()
  _replace_map()
end
