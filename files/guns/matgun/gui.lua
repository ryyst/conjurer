dofile("data/scripts/lib/coroutines.lua")
dofile("data/scripts/lib/utilities.lua")

dofile_once("mods/raksa/files/scripts/material_icons.lua");
dofile_once("mods/raksa/files/guns/matgun/brushes/list.lua");
dofile_once("mods/raksa/files/guns/matgun/helpers.lua");

dofile_once("mods/raksa/files/scripts/utilities.lua")

local render_active_overlay = nil
local GUI = GuiCreate()
local main_menu_items = {}
local main_menu_pos_x = 1
local main_menu_pos_y = 18
local sub_menu_pos_x = main_menu_pos_x+3
local sub_menu_pos_y = main_menu_pos_y-5.3

local active_material_type = MATERIAL_TYPES[1]


function GuiHorizontal(gui, x, y, func)
  GuiLayoutBeginHorizontal(gui, x, y)
  func()
  GuiLayoutEnd(gui)
end

function GuiVertical(gui, x, y, func)
  GuiLayoutBeginVertical(gui, x, y)
  func()
  GuiLayoutEnd(gui)
end


function render_grid(items, callback)
  local row_length = math.max( 6, math.min( (#items) ^ 0.5, 12 ) );
  local row_count = math.ceil(#items / row_length)

  local item_pos = 1
  for row=1, row_count do
    if not items[item_pos] then break end

    GuiHorizontal(GUI, 1, 2, function()
      for col = 1, row_length do
        if not items[item_pos] then break end
        callback(items[item_pos], item_pos)
        item_pos = item_pos + 1
      end
    end)
  end
end


function render_material_picker()
  local btn_id = 200
  local active_materials = ALL_MATERIALS[active_material_type]

  -- Render material type buttons
  GuiHorizontal(GUI, 1, 1, function()
    for i, cat in ipairs(MATERIAL_TYPES) do
      name = (cat == active_material_type) and string.upper(cat) or cat

      if GuiButton( GUI, btn_id, 0, 0, name) then
        active_material_type = cat
      end
      GuiLayoutAddHorizontalSpacing(GUI, 3)
      btn_id = btn_id + 1
    end
  end)

  -- Render material buttons
  render_grid(active_materials, function(material)
    if GuiImageButton(GUI, btn_id, 0, 0, "", material.image) then
      GlobalsSetValue("raksa_selected_material", material.id)
    end
    GuiTooltip(GUI, material.name, "")
    btn_id = btn_id + 1
  end)
end

function render_brush_picker()
  local btn_id = 300

  GuiHorizontal(GUI, 1, 1, function()
    GuiText(GUI, 0, 0, "Select a brush shape")
  end)

  render_grid(BRUSHES, function(brush, i)
    if GuiImageButton(GUI, btn_id, 0, 0, "", brush.icon_file) then
      change_active_brush(brush, i)
    end
    GuiTooltip(GUI, brush.name, "")
    btn_id = btn_id + 1
  end)
end

function render_eraser_picker()
  local btn_id = 400
  GamePrint("eraser picker active")
end


function render_main_buttons()
  local btn_id = 100

  for i,item in ipairs(main_menu_items) do
    local image = item.image or item.image_func()
    if GuiImageButton(GUI, btn_id, 0, 0, "", image) then
      item.action()
    end
    GuiTooltip(GUI, item.ui_name, item.ui_description)
    GuiLayoutAddVerticalSpacing(GUI, 2)
    btn_id = btn_id + 1
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
  {
    ui_name="Eraser Size",
    ui_description="",
    image = get_active_material_image(),
    action = function() toggle_active_overlay(render_eraser_picker) end,
  },
}


generate_all_materials()

async_loop(function()

  if GUI ~= nil then
    GuiStartFrame(GUI)
  end

  if GameIsInventoryOpen() == false then

    GuiVertical(GUI, main_menu_pos_x, main_menu_pos_y, function()
      render_main_buttons()
    end)

    if render_active_overlay ~= nil then
      GuiVertical(GUI, sub_menu_pos_x, sub_menu_pos_y, function()
        render_active_overlay()
      end)
    end
  end

  wait(0)
end)
