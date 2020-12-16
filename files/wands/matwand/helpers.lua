dofile_once("mods/raksa/files/scripts/lists/brushes.lua");
dofile_once("mods/raksa/files/scripts/lists/material_categories.lua");
dofile_once("mods/raksa/files/scripts/enums.lua")


------------------------------
-- Matwand-specific helpers --
------------------------------

ERASER_ICONS = {
  [ERASER_MODE_SOLIDS]="mods/raksa/files/gfx/matwand_icons/icon_erase_solids.png" ,
  [ERASER_MODE_LIQUIDS]="mods/raksa/files/gfx/matwand_icons/icon_suck_liquids.png" ,
}


function get_active_material_image()
  return GlobalsGetValue(SELECTED_MATERIAL_ICON, SELECTED_MATERIAL_ICON_DEFAULT)
end


function get_brush_grid_size()
  return tonumber(GlobalsGetValue(BRUSH_GRID_SIZE, BRUSH_DEFAULT_GRID_SIZE))
end


function change_active_brush(brush, brush_index)
  -- Change reticle
  local brush_reticle = EntityGetWithName("brush_reticle")
  EntitySetValues(brush_reticle, "SpriteComponent", {
    image_file = brush.reticle_file,
    offset_x = brush.offset_x,
    offset_y = brush.offset_y,
  })

  -- Change drawing brush shape
  GlobalsSetValue(SELECTED_BRUSH, tostring(brush_index))
end


function get_active_brush()
  local brush_index = tonumber(
    GlobalsGetValue(SELECTED_BRUSH, tostring(DEFAULT_BRUSH))
  )
  return BRUSHES[brush_index]
end


function get_active_eraser_image()
  local current_eraser = GlobalsGetValue(ERASER_MODE, ERASER_MODE_DEFAULT)
  return ERASER_ICONS[current_eraser]
end



-------------------------------------------------------------------------------
-- Deprecated functions from old material table generation system.
-- TODO: Return to these later for uncategorized material detection system.
function material_to_name(id)
  id = id:gsub("_",' ')
  id = id:gsub("(%l)(%w*)", function(a,b) return string.upper(a)..b end)
  return id
end

function is_static(str)
  if string.match(str, "static") then return true else return false end
end

function generate_all_materials()
  MATERIAL_TYPES = {"Solids", "Sands", "Liquids", "Gases", "Fires"};
  for i,cat in ipairs(MATERIAL_TYPES) do
    local temp = {}
    local mats = getfenv()["CellFactory_GetAll"..cat]()
    table.sort(mats)

    for i,x in ipairs(mats)
    do
      if is_static(x) then
        table.insert(ALL_MATERIALS.Solids, {id=x, name=material_to_name(x), image=MATERIAL_ICONS[x]})
      else
        table.insert(temp, {id=x, name=material_to_name(x), image=MATERIAL_ICONS[x]})
      end
    end
    if cat ~= "Solids" then
      ALL_MATERIALS[cat] = temp
    end
  end
end
