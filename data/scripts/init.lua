dofile_once( "data/scripts/lib/utilities.lua" )
local init_biome_modifiers = dofile_once( "data/scripts/biome_modifiers.lua")

--[[
-- function OnPlayerSpawned( player_entity )
-- function OnPlayerDied( player_entity )
-- function OnMagicNumbersAndWorldSeedInitialized()
-- function OnBiomeConfigLoaded()
-- function OnWorldInitialized()
-- function OnWorldPreUpdate()
-- function OnWorldPostUpdate()
-- function OnPausedChanged( is_paused, is_inventory_pause )
-- function OnModSettingsChanged() -- Will be called when the game is unpaused, if player changed any mod settings while the game was paused.
-- function OnPausePreUpdate() -- Will be called when the game is paused, either by the pause menu or some inventory menus. Please be careful with this, as not everything will behave well when called while the game is paused.
]]--

--
-- NOTICE FROM A FELLOW CONJURER:
--
-- This is a really ugly hack we have to make due to technical reasons.
-- 1. Include this whole file, and manually keep it up-to-date
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
  -- GUI less confusing with many overlapping layers of functionality.
end
