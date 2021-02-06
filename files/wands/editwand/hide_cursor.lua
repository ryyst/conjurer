dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/raksa/files/scripts/utilities.lua")


-- Do not leave the cursor hanging when changing wands
function enabled_changed(entity, is_enabled)
  if not is_enabled then
    local cursor = EntityGetWithName("editwand_cursor")
    EntityKill(cursor)
  end
end
