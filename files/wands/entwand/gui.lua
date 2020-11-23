dofile("data/scripts/lib/coroutines.lua")
dofile("data/scripts/lib/utilities.lua")

dofile_once("mods/raksa/files/scripts/material_icons.lua");
dofile_once("mods/raksa/files/wands/entwand/brushes/list.lua");
dofile_once("mods/raksa/files/wands/entwand/helpers.lua");

dofile_once("mods/raksa/files/lib/gui.lua")
dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/scripts/enums.lua")


local render_active_overlay = nil
local GUI = GuiCreate()
local main_menu_pos_x = 1
local main_menu_pos_y = 18
local sub_menu_pos_x = main_menu_pos_x+3
local sub_menu_pos_y = main_menu_pos_y-5.3

local active_entity_type = ENTITY_TYPES[1]
local favorites = {}


function remove_from_favorites(i)
  return function()
    table.remove(favorites, i)
  end
end

function add_to_favorites(vars, click)
  return function()
    table.insert(favorites, { vars=vars, click=click })
  end
end


function render_entity_picker()
  local bid = 200
end


function render_main_buttons()
  local bid = 100

  local main_menu_items = {
    {
      name="Entity Picker",
      image=ICON_UNKNOWN,
      action = function() toggle_active_overlay(render_entity_picker) end
    },
    {
      name="Secondary Action",
      image=ICON_UNKNOWN,
      action = function() GamePrint("haloo") end,
    },
  };

  -- Render picker buttons
  for i, item in ipairs(main_menu_items) do
    bid = Button(
      GUI, bid,
      {image=item.image, tooltip=item.name},
      item.action
    )
    GuiLayoutAddVerticalSpacing(GUI, 2)
  end

  GuiLayoutAddVerticalSpacing(GUI, 2)
  GuiText(GUI, 1, 0, "fav.")
  GuiTooltip(GUI, "Add favorites by right-clicking on individual entities", "")

  -- Render favorite buttons
  for i, fav in ipairs(favorites) do
    bid = Button(GUI, bid, fav.vars, fav.click, remove_from_favorites(i))
    GuiLayoutAddVerticalSpacing(GUI, 2)
  end
end


function toggle_active_overlay(func)
  render_active_overlay = (render_active_overlay ~= func) and func or nil
end


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
