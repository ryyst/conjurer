dofile("data/scripts/lib/coroutines.lua")
dofile("data/scripts/lib/utilities.lua")

dofile_once("mods/raksa/files/scripts/material_icons.lua");
dofile_once("mods/raksa/files/scripts/utilities.lua")

local render_active_overlay = nil
local GUI = GuiCreate()
local main_menu_items = {}
local main_menu_pos_x = 1
local main_menu_pos_y = 18

local BUTTON_SIZE = 16
local PADDING = 2

local all_materials = {Solids={}};
local all_material_types = {"Solids", "Sands", "Liquids", "Gases", "Fires"};
local active_material_type = all_material_types[1]

function id_to_name(id)
  id = id:gsub("_",' ')
  id = id:gsub("(%l)(%w*)", function(a,b) return string.upper(a)..b end)
  return id
end

function check_static(str)
  if string.match(str, "static") then return true else return false end
end

for i,cat in ipairs(all_material_types) do
  local temp = {}
  local mats = getfenv()["CellFactory_GetAll"..cat]()
  table.sort(mats)

  for i,x in ipairs(mats)
  do
    if check_static(x) then
      table.insert(all_materials.Solids, {id=x, name=id_to_name(x), image=MATERIAL_ICONS[x]})
    else
      table.insert(temp, {id=x, name=id_to_name(x), image=MATERIAL_ICONS[x]})
    end
  end
  if cat ~= "Solids" then
    all_materials[cat] = temp
  end
end

print(str(all_materials))


function GuiHorizontal(gui, x, y, func)
  GuiLayoutBeginHorizontal(gui, x, y)
  func()
  GuiLayoutEnd(gui)
end


function render_material_picker()
  local btn_id = 200

  GuiLayoutBeginVertical( GUI, main_menu_pos_x+3, main_menu_pos_y-5.3)

  local active_materials = all_materials[active_material_type]
  local row_length = math.max( 6, math.min( (#active_materials) ^ 0.5, 12 ) );
  local row_count = math.ceil(#active_materials / row_length)

  -- Render mat type buttons
  GuiHorizontal(GUI, 1, 1, function()
    for i, cat in ipairs(all_material_types) do
      name = (cat == active_material_type) and string.upper(cat) or cat

      if GuiButton( GUI, btn_id, 0, 0, name) then
        active_material_type = cat
      end
      GuiLayoutAddHorizontalSpacing(GUI, 3)
      btn_id = btn_id + 1
    end
  end)


  -- Render material buttons
  local opt_pos = 1
  for row=1, row_count do
    if not active_materials[opt_pos] then break end

    GuiHorizontal(GUI, 1, 2, function()
      for col = 1, row_length do
        if not active_materials[opt_pos] then break end

        local mat = active_materials[opt_pos]

        if GuiImageButton(GUI, btn_id, 0, 0, "", mat.image) then --, MATERIAL_ICONS[mat.id]) then
          GlobalsSetValue("raksa_selected_material", mat.id)
        end
        GuiTooltip(GUI, mat.name, "")
        opt_pos = opt_pos + 1
        btn_id = btn_id + 1
      end
    end)

  end

  GuiLayoutEnd(GUI)
end

function render_brush_picker()
  local btn_id = 300
  GamePrint("brush picker active")
end

function render_eraser_picker()
  local btn_id = 400
  GamePrint("eraser picker active")
end

function render_main_buttons()
  local btn_id = 100
  GuiLayoutBeginVertical( GUI, main_menu_pos_x, main_menu_pos_y )

  for i,item in ipairs(main_menu_items) do
    local image = item.image or item.image_func()
    if GuiImageButton(GUI, btn_id, 0, 0, "", image) then
      item.action()
    end
    GuiTooltip(GUI, item.ui_name, item.ui_description)
    GuiLayoutAddVerticalSpacing(GUI, 2)
    btn_id = btn_id + 1
  end

  GuiLayoutEnd( GUI )
end


function get_active_material_image()
  local material = GlobalsGetValue("raksa_selected_material", "soil")
  return MATERIAL_ICONS[material]
end


function toggle_active_overlay(func)
  render_active_overlay = (render_active_overlay ~= func) and func or nil
end

main_menu_items =
{
  {
    ui_name="Material Picker",
    ui_description="",
    image_func = get_active_material_image,
    action = function() toggle_active_overlay(render_material_picker) end
  },
  {
    ui_name="Brush Picker",
    ui_description="",
    image = get_active_material_image(),
    action = function() toggle_active_overlay(render_brush_picker) end,
  },
  {
    ui_name="Eraser Size",
    ui_description="",
    image = get_active_material_image(),
    action = function() toggle_active_overlay(render_eraser_picker) end,
  },
}


async_loop(function()

  if GUI ~= nil then
    GuiStartFrame( GUI )
  end

  if GameIsInventoryOpen() == false then
    render_main_buttons()
    if render_active_overlay ~= nil then
      render_active_overlay()
    end
  end

  wait(0)
end)
