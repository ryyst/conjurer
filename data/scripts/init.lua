dofile_once( "data/scripts/lib/utilities.lua" )
local init_biome_modifiers = dofile_once( "data/scripts/biome_modifiers.lua")

--
-- NOTICE FROM A FELLOW CONJURER:
--
-- This is a really ugly hack we have to make due to technical reasons.
-- 1. Override this file directly, and manually keep it up-to-date
-- 2. Conditionally run functions depending on the map setting
--
-- Why?
-- * We want to get rid of all vanilla weather effects (for now)
-- * We want to preserve biome modifiers for inter-mod compatibility
-- * ModLuaFileAppend and ModTextFileSetContent are run too late from our own init.
function OnBiomeConfigLoaded()
  init_biome_modifiers()
end

function OnWorldPreUpdate()
  -- DESIGN DECISION:
  -- All default weather features are disabled, just to make our own weather
  -- GUI less confusing with too many overlapping layers of functionality.
end
