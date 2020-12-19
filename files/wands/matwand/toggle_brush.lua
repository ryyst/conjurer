dofile_once("data/scripts/lib/utilities.lua")

dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/wands/matwand/helpers.lua")


function enabled_changed(entity, is_enabled)
  if is_enabled then
    local x, y = DEBUG_GetMouseWorld()
    EntityLoad("mods/raksa/files/wands/matwand/brushes/brush_reticle.xml", x, y)
    EntityLoad("mods/raksa/files/wands/matwand/brushes/eraser_reticle.xml", x, y)

    local brush, index = get_active_brush()
    change_active_brush(brush, index)
    change_eraser_reticle()
    return
  end

  local brush = EntityGetWithName("brush_reticle")
  if brush then EntityKill(brush) end

  local eraser = EntityGetWithName("eraser_reticle")
  if eraser then EntityKill(eraser) end
end
