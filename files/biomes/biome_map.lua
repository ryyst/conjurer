dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/scripts/enums.lua")


-- NOTE: These have to be synced with biome_map.png
-- The width is purposefully so large, to make biome generation repeat less often.
-- Otherwise it doesn't matter for our island at all.
BIOME_MAP_WIDTH = 63
BIOME_MAP_HEIGHT = 32

-- Slightly above the horizon area, yet still below the floating island.
BOTTOM_AREA_START_Y = 12

function paint_biome_area(x, y, w, h, biome_color)
  for i=y, y+h-1 do
    for j=x, x+w-1 do
      BiomeMapSetPixel(j, i, biome_color)
    end
  end
end

BiomeMapSetSize(BIOME_MAP_WIDTH, BIOME_MAP_HEIGHT)
-- This is always the default base for us
BiomeMapLoadImage(0, 0, "mods/raksa/files/biomes/biome_map.png")
SetRandomSeed(123, 321)

local BIOME_COLORS = {
  [BIOME_DESERT] = 0xFFCC9944,
  [BIOME_FOREST] = 0xFF006B1E,
  [BIOME_WINTER] = 0xFFD6D8E3,
  [BIOME_WATER] = 0xFF0000ff,
  [BIOME_HELL] = 0xFFab4d00,
}

local biome = GlobalsGet(BIOME_SELECTION)

-- Don't paint takapiha, because it's already the default in map image
paint_biome_area(
  0,
  BOTTOM_AREA_START_Y,
  BIOME_MAP_WIDTH,
  BIOME_MAP_HEIGHT - BOTTOM_AREA_START_Y,
  BIOME_COLORS[biome]
)
