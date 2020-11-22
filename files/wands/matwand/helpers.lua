dofile_once("mods/raksa/files/wands/matwand/brushes/list.lua");

dofile_once("mods/raksa/files/scripts/material_icons.lua");
dofile_once("mods/raksa/files/scripts/enums.lua")

-----------------------------
-- Matwand-specific helpers --
-----------------------------
MATERIAL_TYPES = {"Solids", "Sands", "Liquids", "Gases", "Fires"};
ALL_MATERIALS = {Solids={}};

BRUSH_GLOBAL = "raksa_selected_brush"


function change_active_brush(brush, brush_index)
  -- Change reticle
  local brush_reticle = EntityGetWithName("brush_reticle")
  EntitySetValues(brush_reticle, "SpriteComponent", {
    image_file = brush.reticle_file,
    offset_x = brush.offset_x,
    offset_y = brush.offset_y,
  })

  -- Change drawing brush shape
  GlobalsSetValue(BRUSH_GLOBAL, tostring(brush_index))
end


function get_active_material_image()
  local material = GlobalsGetValue("raksa_selected_material", "soil")
  return MATERIAL_ICONS[material]
end


function get_active_brush()
  local brush_index = tonumber(
    GlobalsGetValue(BRUSH_GLOBAL, tostring(DEFAULT_BRUSH))
  )
  return BRUSHES[brush_index]
end


function material_to_name(id)
  id = id:gsub("_",' ')
  id = id:gsub("(%l)(%w*)", function(a,b) return string.upper(a)..b end)
  return id
end


function is_static(str)
  if string.match(str, "static") then return true else return false end
end


-- TODO: This is a bit ugly, needs cleanup.
function generate_all_materials()
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


function get_active_eraser_image()
  local current_eraser = GlobalsGetValue(ERASER_MODE, ERASER_MODE_DEFAULT)
  local path = "mods/raksa/files/wands/matwand/erasers/"

  if current_eraser == ERASER_MODE_SOLIDS then
    return path.."solids.png"
  end

  return path.."liquids.png"
end
