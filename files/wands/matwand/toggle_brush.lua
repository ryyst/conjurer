dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/raksa/files/scripts/utilities.lua")


function enabled_changed(entity, is_enabled)
  if is_enabled then
    local x, y = DEBUG_GetMouseWorld()
    EntityLoad("mods/raksa/files/wands/matwand/brushes/brush_reticle.xml", x, y)
    return
  end

  local brush = EntityGetWithName("brush_reticle")
  if brush then
    EntityKill(brush)
  end
end
