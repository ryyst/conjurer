dofile("data/scripts/lib/coroutines.lua")
dofile("data/scripts/lib/utilities.lua")

dofile_once("mods/raksa/files/lib/gui.lua")
dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/scripts/enums.lua")

dofile_once("mods/raksa/files/powers/toggle_speed.lua")


local render_active_overlay = nil
local GUI = GuiCreate()
local main_menu_pos_x = 93
local main_menu_pos_y = 94
local sub_menu_pos_x = main_menu_pos_x
local sub_menu_pos_y = main_menu_pos_y-4


function render_main_buttons()
  local bid = 100

  local main_menu_items = {
    {
      name="Toggle Mortality",
      image = ICON_UNKNOWN,
      action = function() GamePrint("Mortality achieved") end
    },
    {
      name="Toggle Speed",
      image = ICON_UNKNOWN,
      action = toggle_speed,
    },
  };

  -- Render picker buttons
  Background(GUI, 1, NPBG_GOLD, 100, function()
    for i, item in ipairs(main_menu_items) do
      bid = Button(
        GUI, bid,
        {image=item.image, tooltip=item.name},
        item.action
      )
      GuiLayoutAddHorizontalSpacing(GUI, 2)
    end
  end)
end


function toggle_active_overlay(func)
  render_active_overlay = (render_active_overlay ~= func) and func or nil
end


async_loop(function()

  if GUI ~= nil then
    GuiStartFrame(GUI)
    GuiOptionsAdd(GUI, GUI_OPTION.NoPositionTween)
  end

  if GameIsInventoryOpen() == false then

    Horizontal(GUI, main_menu_pos_x, main_menu_pos_y, function()
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
