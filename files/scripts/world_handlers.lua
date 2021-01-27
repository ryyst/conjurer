local nxml = dofile_once("mods/raksa/files/lib/nxml.lua")


local BIOMES = {
  {
    biome_filename="mods/raksa/files/biomes/takapiha.xml",
    height_index="0",
    color="ffc0ff33",
  },
  {
    biome_filename="mods/raksa/files/biomes/forest_nocaves.xml",
    height_index="0",
    color="ffc4ff33",
  },
  {
    biome_filename="mods/raksa/files/biomes/forest_pond.xml",
    height_index="0",
    color="ff0220ff",
  },
  {
    biome_filename="mods/raksa/files/biomes/hellscape.xml",
    height_index="0",
    color="ffab4d00",
  }
}
-- DESOLATE HELLSCAPE????


function replace_pixel_scenes()
  -- We don't want any of the default pixel scenes spawning in our world so:
  -- * Back up original pixel scenes to a new file, for changing back later
  -- * Override all pixel scenes with our own
  print("Backing up original pixel scenes...")
  local original_scenes = ModTextFileGetContent(PIXEL_SCENES_DEFAULT)
  ModTextFileSetContent(PIXEL_SCENES_NOITA, original_scenes)

  print("Replacing pixel scenes with Conjurer's...")
  local conjurer_scenes = ModTextFileGetContent("mods/raksa/files/overrides/_pixel_scenes.xml")
  ModTextFileSetContent(PIXEL_SCENES_DEFAULT, conjurer_scenes)
end


function append_custom_biomes()
  local biome_data = ModTextFileGetContent("data/biome/_biomes_all.xml")
  local biomes_xml = nxml.parse(biome_data)

  for i, biome in ipairs(BIOMES) do
    biomes_xml:add_child(nxml.new_element("Biome", biome))
  end

  local biome_data_patched = nxml.tostring(biomes_xml)
  ModTextFileSetContent("data/biome/_biomes_all.xml", biome_data_patched)
end


function replace_biome_map()
  ModMagicNumbersFileAdd("mods/raksa/files/overrides/map_conjurer.xml")
end
