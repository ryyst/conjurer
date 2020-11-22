dofile("data/scripts/lib/coroutines.lua")
dofile("data/scripts/lib/utilities.lua")

dofile_once("mods/raksa/files/scripts/material_icons.lua");
dofile_once("mods/raksa/files/wands/matwand/brushes/list.lua");
dofile_once("mods/raksa/files/wands/matwand/helpers.lua");

dofile_once("mods/raksa/files/lib/gui.lua")
dofile_once("mods/raksa/files/scripts/utilities.lua")

local render_active_overlay = nil
local GUI = GuiCreate()
local main_menu_items = {}
local main_menu_pos_x = 1
local main_menu_pos_y = 18
local sub_menu_pos_x = main_menu_pos_x+3
local sub_menu_pos_y = main_menu_pos_y-5.3

local active_material_type = MATERIAL_TYPES[1]


function render_material_picker()
  local bid = 200
  local active_materials = ALL_MATERIALS[active_material_type]

  -- Render material type buttons
  Horizontal(GUI, 1, 1, function()
    for i, cat in ipairs(MATERIAL_TYPES) do
      name = (cat == active_material_type) and string.upper(cat) or cat

      bid = Button(GUI, bid, {text=name}, function()
        active_material_type = cat
      end)
      GuiLayoutAddHorizontalSpacing(GUI, 3)
    end
  end)

  -- Render material buttons
  Grid(GUI, active_materials, function(material)
    bid = Button(GUI, bid, {image=material.image, tooltip=material.name}, function()
      GlobalsSetValue("raksa_selected_material", material.id)
    end)
  end)
end


function render_brush_picker()
  local bid = 300

  Horizontal(GUI, 1, 1, function()
    GuiText(GUI, 0, 0, "Select a brush shape")
  end)

  Grid(GUI, BRUSHES, function(brush, i)
    bid = Button(GUI, bid, {image=brush.icon_file, tooltip=brush.name}, function()
        change_active_brush(brush, i)
    end)
  end)
end


function render_eraser_picker()
  local bid = 400
  GamePrint("eraser picker active")
end


function render_main_buttons()
  local bid = 100

  for i,item in ipairs(main_menu_items) do
    local image = item.image or item.image_func()
    local vars = {image=image, tooltip=item.ui_name, tooltip_desc=item.ui_description}
    bid = Button(GUI, bid, vars, item.action)
    GuiLayoutAddVerticalSpacing(GUI, 2)
  end
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
    image_func = function() return get_active_brush().icon_file end,
    action = function() toggle_active_overlay(render_brush_picker) end,
  },
  --{
  --  ui_name="Eraser Size",
  --  ui_description="",
  --  image = get_active_material_image(),
  --  action = function() toggle_active_overlay(render_eraser_picker) end,
  --},
}


generate_all_materials()

async_loop(function()

  if GUI ~= nil then
    GuiStartFrame(GUI)
  end

  if GameIsInventoryOpen() == false then

    Vertical(GUI, main_menu_pos_x, main_menu_pos_y, function()
      render_main_buttons()
    end)

    if render_active_overlay ~= nil then
      Vertical(GUI, sub_menu_pos_x, sub_menu_pos_y, function()
        render_active_overlay()
      end)
    end
  end

  wait(0)
end)
