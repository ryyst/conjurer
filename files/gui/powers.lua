dofile("data/scripts/lib/utilities.lua")

dofile_once("mods/raksa/files/lib/gui.lua")
dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/scripts/enums.lua")

dofile_once("mods/raksa/files/powers/toggle_speed.lua")
dofile_once("mods/raksa/files/powers/toggle_kalma.lua")
dofile_once("mods/raksa/files/powers/change_herd.lua")
dofile_once("mods/raksa/files/powers/control_happiness.lua")
dofile_once("mods/raksa/files/powers/grid_overlay.lua")
dofile_once("mods/raksa/files/powers/binoculars.lua")


if ACTIVE_HERD == nil then
  local player = get_player()
  if player then
    ACTIVE_HERD = get_active_herd(EntityGetValue(player, "GenomeDataComponent", "herd_id"))
  end
end


local main_menu_items = {
  {
    name="Toggle Conscious Eye of Glass",
    image="mods/raksa/files/gfx/power_icons/binoculars.png",
    action = toggle_camera_controls,
  },
  {
    name="Toggle Conjurer Eye",
    desc="Movement keys to move and shift to boost.",
    image="mods/raksa/files/gfx/power_icons/binoculars.png",
    action = toggle_binoculars,
  },
  {
    name="Toggle Grid",
    image="mods/raksa/files/gfx/power_icons/grid.png",
    action = toggle_grid,
  },
  {
    name="Control World Happiness",
    image_func = function() return get_happiness_icon(ACTIVE_HAPPINESS_LEVEL) end,
    action = function() toggle_active_overlay(render_happiness_menu) end,
  },
  {
    name="Change Herd",
    image_func = function() return ACTIVE_HERD.image end,
    action = function() toggle_active_overlay(render_herd_menu) end,
  },
  {
    name="Return to Tower",
    image = "mods/raksa/files/gfx/power_icons/tower.png",
    action = function() teleport_player(SPAWN_X, SPAWN_Y) end,
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
    name="Control Weather",
    image = "mods/raksa/files/gfx/power_icons/planetary_controls.png",
    action = function() toggle_active_overlay(render_weather_menu) end,
  },
  {
    name="Control Planetary Rotation",
    image = "mods/raksa/files/gfx/power_icons/planetary_controls.png",
    action = function() toggle_active_overlay(render_time_menu) end,
  },
};


local BUTTON_WIDTH = 3
local render_active_powers_overlay = nil
local main_menu_pos_x = 100 - BUTTON_WIDTH * #main_menu_items + 1
local main_menu_pos_y = 94
local sub_menu_pos_x = main_menu_pos_x
local sub_menu_pos_y = main_menu_pos_y-15


function render_happiness_menu()
  local relation_buttons = {
    {
      name="Nightfall Nakkikiska",
      desc="Turns brother on brother. Hiisi on hiisi.\nThere is no love in this world.",
      image=get_happiness_icon(HAPPINESS_HATE),
      action=function()
        GamePrint("You don't feel so safe anymore.")
        change_happiness(HAPPINESS_HATE)
      end,
    },
    {
      name="Status Quo",
      desc="You choose not to influence this world.\nAll relations stay intact.",
      image=get_happiness_icon(HAPPINESS_NEUTRAL),
      action=function()
        GamePrint("Back to normal.")
        change_happiness(HAPPINESS_NEUTRAL)
      end,
    },
    {
      name="Sonata Sauna",
      desc="Purges all hatred from the world.",
      image=get_happiness_icon(HAPPINESS_LOVE),
      action=function()
        GamePrint("You feel a sudden ease as love fills the world.")
        change_happiness(HAPPINESS_LOVE)
      end,
    },
  };

  Background(1, nil, 100, function()
    Grid(relation_buttons, function(item)
      Button(
        {image=item.image, tooltip=item.name, tooltip_desc=item.desc},
        item.action
      )
    end, 0, 8, 3)
  end)
end


function render_herd_menu()
  Background(1, nil, 100, function()
    Grid(HERDS, function(herd)
      Button(
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
  local teleport_buttons = {
    {
      name="Tower",
      image = ICON_UNKNOWN,
      action = function() teleport_player(SPAWN_X, SPAWN_Y) end,
    },
    {
      name="Set Waypoint",
      image = ICON_UNKNOWN,
      action = function() GamePrint("Set waypoint here!") end,
    },
  };

  Grid(teleport_buttons, function(item)
    Button(
      {image=item.image, tooltip=item.name},
      item.action
    )
  end, 0, 0, 2)
end


function render_weather_menu()
  Vertical(0, -10, function()
    Checkbox({
        is_active=GlobalsGetBool(RAIN_ENABLED),
        text="Make it rain",
      },
      function() GlobalsToggleBool(RAIN_ENABLED) end
    )

    Slider({
        min=1,
        max=200,
        default=DEFAULTS[RAIN_COUNT],
        value=GlobalsGetNumber(RAIN_COUNT),
        text="Amount",
      },
      function(new_value)
        GlobalsSetValue(RAIN_COUNT, str(new_value))
      end
    )

    Slider({
        min=128,
        max=2048,
        default=DEFAULTS[RAIN_WIDTH],
        value=GlobalsGetNumber(RAIN_WIDTH),
        text="Extra width",
        tooltip="How far to rain outside the camera. Might help with performance."
      },
      function(new_value)
        GlobalsSetValue(RAIN_WIDTH, str(new_value))
      end
    )

    Slider({
        min=0,
        max=300,
        default=DEFAULTS[RAIN_VELOCITY_MIN],
        value=GlobalsGetNumber(RAIN_VELOCITY_MIN),
        text="Velocity min",
      },
      function(new_value)
        GlobalsSetValue(RAIN_VELOCITY_MIN, str(new_value))
      end
    )
    Slider({
        min=0,
        max=300,
        default=DEFAULTS[RAIN_VELOCITY_MAX],
        value=GlobalsGetNumber(RAIN_VELOCITY_MAX),
        text="Velocity max",
      },
      function(new_value)
        GlobalsSetValue(RAIN_VELOCITY_MAX, str(new_value))
      end
    )
    Slider({
        min=1,
        max=100,
        default=DEFAULTS[RAIN_GRAVITY],
        value=GlobalsGetNumber(RAIN_GRAVITY),
        text="Gravity",
      },
      function(new_value)
        GlobalsSetValue(RAIN_GRAVITY, str(new_value))
      end
    )
    -- MaterialPicker("material_name")
    -- Slider("gravity")
    -- Checkbox("Toggle natural rain cycle")
    --
    Checkbox({
        is_active=GlobalsGetBool(RAIN_BOUNCE),
        text="Droplets bounce",
      },
      function() GlobalsToggleBool(RAIN_BOUNCE) end
    )
    Checkbox({
        is_active=GlobalsGetBool(RAIN_DRAW_LONG),
        text="Long particles",
      },
      function() GlobalsToggleBool(RAIN_DRAW_LONG) end
    )
    --
    --
    --
    local world = GameGetWorldStateEntity()
    local value = EntityGetValue(world, "WorldStateComponent", "rain_target_extra")
    -- Slider("clouds")  -- WorldStateComponent.rain_target_extra
    --wind

  end)
end


function render_time_menu()
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

  Grid(time_of_day_buttons, function(item)
    Button(
      {image=item.image, tooltip=item.name},
      item.action
    )
  end, 0, 0, 2)

  -- time_dt slider
  local MULTIPLIER = 10

  function to_worldstate_value(val)
    if val <= 0.1 then return 0 end
    return math.max(10 ^ val / MULTIPLIER)
  end

  function to_slider_log_value(val)
    return math.max(math.log10(val*MULTIPLIER), 0)
  end

  local world = GameGetWorldStateEntity()
  local value = to_slider_log_value(EntityGetValue(world, "WorldStateComponent", "time_dt"))

  local vars = {
    x=-2,
    max=3.5,
    default=to_slider_log_value(1),
    value=value,
    formatting=string.format("%.2f", value),
    tooltip="Rotational Velocity",
    tooltip_desc="Right-click to reset back to natural order",
  }

  Slider(vars, function(new_value)
    EntitySetValue(world, "WorldStateComponent", "time_dt", to_worldstate_value(new_value))
  end)
end


function render_power_buttons()
  -- Render picker buttons
  Background(1, NPBG_GOLD, 100, function()
    for i, item in ipairs(main_menu_items) do
      Button(
        {image=item.image or item.image_func(), tooltip=item.name, tooltip_desc=item.desc},
        item.action
      )
    end
  end)
end


function toggle_active_overlay(func)
  render_active_powers_overlay = (render_active_powers_overlay ~= func) and func or nil
end


function render_powers()
  Horizontal(main_menu_pos_x, main_menu_pos_y, function()
    render_power_buttons()
  end)

  if render_active_powers_overlay ~= nil then
    Vertical(sub_menu_pos_x, sub_menu_pos_y, function()
      render_active_powers_overlay()
    end)
  end
end
