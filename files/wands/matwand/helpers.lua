dofile_once("mods/raksa/files/scripts/lists/brushes.lua");
dofile_once("mods/raksa/files/scripts/lists/material_categories.lua");
dofile_once("mods/raksa/files/scripts/enums.lua")


------------------------------
-- Matwand-specific helpers --
------------------------------

ERASER_ICONS = {
  [ERASER_MODE_ALL]="mods/raksa/files/gfx/matwand_icons/icon_erase_solids.png",
  [ERASER_MODE_SELECTED]="none, use active material",
  [ERASER_MODE_SOLIDS]="mods/raksa/files/gfx/matwand_icons/icon_solid.png",
  [ERASER_MODE_LIQUIDS]="mods/raksa/files/gfx/matwand_icons/icon_liquid.png",
  [ERASER_MODE_SANDS]="mods/raksa/files/gfx/matwand_icons/icon_sand.png",
  [ERASER_MODE_GASES]="mods/raksa/files/gfx/matwand_icons/icon_gas.png",
  [ERASER_MODE_FIRE]="mods/raksa/files/gfx/matwand_icons/icon_fire.png",
}

ERASER_CHUNK_SIZE = 5  -- pixels, with a radius of 3
ERASER_CHUNK_RADIUS = 3  -- Creates a square 5px hole


function get_active_material()
  return GlobalsGetValue(SELECTED_MATERIAL, SELECTED_MATERIAL_DEFAULT)
end

function get_active_material_image()
  return GlobalsGetValue(SELECTED_MATERIAL_ICON, SELECTED_MATERIAL_ICON_DEFAULT)
end

function get_eraser_mode()
  return GlobalsGetValue(ERASER_MODE, ERASER_MODE_DEFAULT)
end

function get_eraser_size()
  -- Eraser sizes with chunk_count multiplier:
  -- 1: 5px
  -- 2: 10px
  -- 3: 15px
  -- ...

  local chunk_size = ERASER_CHUNK_SIZE
  local chunk_count = tonumber(GlobalsGetValue(ERASER_SIZE, ERASER_SIZE_DEFAULT))
  local total_size = chunk_count * chunk_size
  return chunk_count, chunk_size, total_size
end

function eraser_use_brush_grid()
  return GlobalsGetValue(ERASER_SHARED_GRID, ERASER_SHARED_GRID_DEFAULT) == "1"
end

function eraser_use_replacer()
  return GlobalsGetValue(ERASER_REPLACE, ERASER_REPLACE_DEFAULT) == "1"
end

function get_eraser_grid_size()
  return tonumber(GlobalsGetValue(ERASER_GRID_SIZE, ERASER_DEFAULT_GRID_SIZE))
end

function get_brush_grid_size()
  return tonumber(GlobalsGetValue(BRUSH_GRID_SIZE, BRUSH_DEFAULT_GRID_SIZE))
end


function change_eraser_reticle()
  local chunk_count, chunk_size, total_size = get_eraser_size()
  local reticle = EntityGetWithName("eraser_reticle")

  local corners = {
    { -- Topleft
      math.floor(total_size / 2),
      math.floor(total_size / 2)
    },
    { -- Topright
      math.floor(-total_size / 2) + 1,
      math.floor(total_size / 2)
    },
    { -- Bottomleft
      math.floor(total_size / 2),
      math.floor(-total_size / 2) + 1
    },
    { -- Bottomright
      math.floor(-total_size / 2) + 1,
      math.floor(-total_size / 2) + 1
    },
  }

  local replace = GlobalsGetValue(ERASER_REPLACE, ERASER_REPLACE_DEFAULT) == "1"
  local image = replace and REPLACER_PIXEL or ERASER_PIXEL

  for i, SpriteComponent in ipairs(EntityGetComponent(reticle, "SpriteComponent")) do
    -- The odd sizes (15, 25, ...) require their own offset
    local offset = chunk_count % 2

    local corner = corners[i]
    ComponentSetValue2(SpriteComponent, "offset_x", corner[1] + offset)
    ComponentSetValue2(SpriteComponent, "offset_y", corner[2] + offset)
    ComponentSetValue2(SpriteComponent, "image_file", image)
  end
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
  return BRUSHES[brush_index], brush_index
end


function get_active_eraser_image()
  local current_eraser = GlobalsGetValue(ERASER_MODE, ERASER_MODE_DEFAULT)
  if current_eraser == ERASER_MODE_SELECTED then
    return get_active_material_image()
  end
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
