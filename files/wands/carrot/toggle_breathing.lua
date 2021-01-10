dofile_once("mods/raksa/files/scripts/utilities.lua")


-- Toggle breathing, according to are we using the carrot or not.
-- Always reset breath when changing carrot in/out.
function enabled_changed(entity, is_enabled)
  local player = get_player()
  if not player then return end

  EntitySetValue(player, "DamageModelComponent", "air_needed", not is_enabled)
  EntitySetValue(player, "DamageModelComponent", "air_in_lungs", 7)
end
