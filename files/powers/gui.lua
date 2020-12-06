dofile("data/scripts/lib/coroutines.lua")
dofile("data/scripts/lib/utilities.lua")

dofile_once("mods/raksa/files/lib/gui.lua")
dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/scripts/enums.lua")

dofile_once("mods/raksa/files/powers/toggle_speed.lua")
dofile_once("mods/raksa/files/powers/toggle_kalma.lua")
dofile_once("mods/raksa/files/powers/change_herd.lua")


local render_active_overlay = nil
local GUI = GuiCreate()
local main_menu_pos_x = 85
local main_menu_pos_y = 94
local sub_menu_pos_x = main_menu_pos_x
local sub_menu_pos_y = main_menu_pos_y-15


if ACTIVE_HERD == nil then
  local player = get_player()
  if player then
    ACTIVE_HERD = get_active_herd(EntityGetValue(player, "GenomeDataComponent", "herd_id"))
  end
end


function render_herd_menu()
  local bid = 400

  Background(GUI, 1, nil, 100, function()
    Grid(GUI, HERDS, function(herd)
        bid = Button(
        GUI, bid,
        {image=ICON_UNKNOWN, tooltip=herd.display, image=herd.image},
        function()
            change_player_herd(herd.name)
            ACTIVE_HERD = herd
        end
        )
    end, 0, -17, 5)
  end)
end


function render_teleport_menu()
  local bid = 300
  local teleport_buttons = {
    {
      name="Tower",
      image = ICON_UNKNOWN,
      action = function() teleport_player(400, -410) end,
    },
    {
      name="Set Waypoint",
      image = ICON_UNKNOWN,
      action = function() GamePrint("Set waypoint here!") end,
    },
  };

  Grid(GUI, teleport_buttons, function(item)
    bid = Button(
      GUI, bid,
      {image=item.image, tooltip=item.name},
      item.action
    )
  end, 0, 0, 2)
end


function render_time_menu()
  local bid = 200
  local MULTIPLIER = 10

  function to_worldstate_value(val)
    if val <= 0.1 then return 0 end
    return math.max(10 ^ val / MULTIPLIER)
  end

  function to_slider_log_value(val)
    return math.max(math.log10(val*MULTIPLIER), 0)
  end


  local time_of_day_buttons = {
    {
      name="Dawn",
      image = "mods/raksa/files/gfx/power_icons/dawn.png",
      action = function() set_time_of_day(DAWN) end,
    },
    {
      name="Noon",
      image = "mods/raksa/files/gfx/power_icons/noon.png",
      action = function() set_time_of_day(NOON) end,
    },
    {
      name="Dusk",
      image = "mods/raksa/files/gfx/power_icons/dusk.png",
      action = function() set_time_of_day(DUSK) end,
    },
    {
      name="Midnight",
      image = "mods/raksa/files/gfx/power_icons/midnight.png",
      action = function() set_time_of_day(MIDNIGHT) end,
    },
  };

  Grid(GUI, time_of_day_buttons, function(item)
    bid = Button(
      GUI, bid,
      {image=item.image, tooltip=item.name},
      item.action
    )
  end, 0, 0, 2)

  -- time_dt slider
  local default = to_slider_log_value(1)
  local world = GameGetWorldStateEntity()
  local value = EntityGetValue(world, "WorldStateComponent", "time_dt")
  value = to_slider_log_value(value)

  local new_val = GuiSlider(GUI, bid, -2, 0, "", value, 0, 3.5, default, 1, string.format("%.2f", value), 50 )
  GuiTooltip(GUI, "Rotational Velocity", "Right-click to reset back to natural order")

  new_val = to_worldstate_value(new_val)
  EntitySetValue(world, "WorldStateComponent", "time_dt", new_val)
end


function render_main_buttons()
  local bid = 100

  local main_menu_items = {
    {
      name="Change Herd",
      image = ACTIVE_HERD.image,
      action = function() toggle_active_overlay(render_herd_menu) end,
    },
    {
      name="Return to Tower",
      image = "mods/raksa/files/gfx/power_icons/tower.png",
      action = function() teleport_player(400, -410) end,
      -- TODO: Return to the waypoint system sometime later
      --action = function() toggle_active_overlay(render_teleport_menu) end,
    },
    {
      name="Toggle Kalma's Call",
      image = "mods/raksa/files/gfx/power_icons/kalma.png",
      action = toggle_kalma,
    },
    {
      name="Toggle Viima's Howl",
      image = "mods/raksa/files/gfx/power_icons/viima.png",
      action = toggle_speed,
    },
    {
      name="Control Planetary Rotation",
      image = "mods/raksa/files/gfx/power_icons/planetary_controls.png",
      action = function() toggle_active_overlay(render_time_menu) end,
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
