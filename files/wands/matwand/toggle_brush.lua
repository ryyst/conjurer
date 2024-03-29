dofile_once("data/scripts/lib/utilities.lua")

dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/wands/matwand/helpers.lua")


function create_brush()
  local x, y = DEBUG_GetMouseWorld()
  EntityLoad("mods/raksa/files/wands/matwand/brushes/brush_reticle.xml", x, y)
  EntityLoad("mods/raksa/files/wands/matwand/brushes/eraser_reticle.xml", x, y)

  local brush, brush_category_index, brush_index = get_active_brush()
  change_active_brush(brush, brush_category_index, brush_index)
  change_eraser_reticle()
end


function enabled_changed(entity, is_enabled)
  if is_enabled then
    create_brush()
    return
  end

  local brush = EntityGetWithName("brush_reticle")
  if brush then EntityKill(brush) end

  local eraser = EntityGetWithName("eraser_reticle")
  if eraser then EntityKill(eraser) end
end
