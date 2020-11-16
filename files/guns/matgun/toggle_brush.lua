dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/luoja/files/scripts/utilities.lua")


function enabled_changed(entity, is_enabled)
  if is_enabled then
    local x, y = DEBUG_GetMouseWorld()
    EntityLoad("mods/luoja/files/guns/matgun/brushes/brush.xml", x, y)
    return
  end

  local brush = EntityGetWithName("brush_reticle")
  if brush then
    EntityKill(brush)
  end
end
