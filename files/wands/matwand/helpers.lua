dofile_once("mods/raksa/files/wands/matwand/brushes/list.lua");

dofile_once("mods/raksa/files/scripts/lists/materials.lua");
dofile_once("mods/raksa/files/scripts/enums.lua")

------------------------------
-- Matwand-specific helpers --
------------------------------
MATERIAL_TYPES = {"Solids", "Sands", "Liquids", "Gases", "Fires"};
ALL_MATERIALS = {Solids={}};

MATERIAL_TYPE_ICONS = {
  Solids="mods/raksa/files/gfx/matwand_icons/icon_solid.png",
  Sands="mods/raksa/files/gfx/matwand_icons/icon_sand.png",
  Liquids="mods/raksa/files/gfx/matwand_icons/icon_liquid.png",
  Gases="mods/raksa/files/gfx/matwand_icons/icon_gas.png",
  Fires="mods/raksa/files/gfx/matwand_icons/icon_fire.png",
}

MATERIAL_TYPE_ICONS_OFF = {
  Solids="mods/raksa/files/gfx/matwand_icons/icon_solid_off.png",
  Sands="mods/raksa/files/gfx/matwand_icons/icon_sand_off.png",
  Liquids="mods/raksa/files/gfx/matwand_icons/icon_liquid_off.png",
  Gases="mods/raksa/files/gfx/matwand_icons/icon_gas_off.png",
  Fires="mods/raksa/files/gfx/matwand_icons/icon_fire_off.png",
}

ERASER_ICONS = {
  [ERASER_MODE_SOLIDS]="mods/raksa/files/gfx/matwand_icons/icon_erase_solids.png" ,
  [ERASER_MODE_LIQUIDS]="mods/raksa/files/gfx/matwand_icons/icon_suck_liquids.png" ,
}


function get_material_type_icon(category, enabled)
  local icon_table = enabled and MATERIAL_TYPE_ICONS or MATERIAL_TYPE_ICONS_OFF
  return icon_table[category]
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


function get_active_material_image()
  local material = GlobalsGetValue(SELECTED_MATERIAL, SELECTED_MATERIAL_DEFAULT)
  return MATERIAL_ICONS[material]
end


function get_active_brush()
  local brush_index = tonumber(
    GlobalsGetValue(SELECTED_BRUSH, tostring(DEFAULT_BRUSH))
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
  return ERASER_ICONS[current_eraser]
end
