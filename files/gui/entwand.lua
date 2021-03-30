dofile("data/scripts/lib/utilities.lua")

dofile_once("mods/raksa/files/wands/entwand/helpers.lua");
dofile_once("mods/raksa/files/scripts/lists/entity_categories.lua");

dofile_once("mods/raksa/files/lib/gui.lua")
dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/scripts/enums.lua")


local render_active_entwand_overlay = nil
local main_menu_pos_x = 1
local main_menu_pos_y = 18
local sub_menu_pos_x = main_menu_pos_x+3
local sub_menu_pos_y = main_menu_pos_y-5.3

local active_entity_tab = DEFAULTS[SELECTED_ENTITY_TYPE]
local favorites = {}


function remove_entity_from_favorites(i)
  return function()
    table.remove(favorites, i)
  end
end

function add_entity_to_favorites(vars, click)
  return function()
    table.insert(favorites, { vars=vars, click=click })
  end
end


function render_entity_picker()
  Horizontal(1, 1, function()
    for i, category in ipairs(ALL_ENTITIES) do
      local is_selected = (i == active_entity_tab)
      local image = is_selected and category.icon or category.icon_off
      local style = is_selected and NPBG_BLUE_TAB or NPBG_BLUE
      local y_override = -0.3

      local vars = {tooltip=category.name, image=image, y=y_override, tooltip_desc=category.desc}
      Background({margin=0, style=style}, function()
        Button(vars, function()
          active_entity_tab = i
        end)
      end)
      HorizontalSpacing(3)
    end
  end)

  -- Render entities
  local active_category = ALL_ENTITIES[active_entity_tab]

  Background({margin=3, style=NPBG_BLUE, z_index=200}, function()
    Grid({
        items=active_category.entities,
        x=1,
        y=2,
        size=active_category.grid_size or nil
      },
      function(entity, i)
        local tab_copy = active_entity_tab  -- For favorites
        local vars = {tooltip=entity.name, image=entity.image, tooltip_desc=entity.desc}
        local click = function() change_active_entity(i, tab_copy) end
        local right_click = add_entity_to_favorites(vars, click)
        Button(vars, click, right_click)
    end)
  end)
end


function render_entity_options()
  Horizontal(1, 1, function()
    Text("Staff Options")
  end)

  Background({margin=3, style=NPBG_BLUE, z_index=200}, function()
    Vertical(1, 2, function()
      Text("Spawning", {color=COLOR_TEXT_TITLE})
      VerticalSpacing(2)
      Checkbox({
          is_active=GlobalsGetBool(ENTWAND_HOLD_TO_SPAWN),
          text="Spawn when holding",
          tooltip="Really quick way to flood entities.",
          tooltip_desc="Beware when spawning multiple rows/columns of entities.",
        },
        function() GlobalsToggleBool(ENTWAND_HOLD_TO_SPAWN) end
      )
      Slider({
          text="Rows",
          value=GlobalsGetNumber(ENTWAND_ROWS),
          default=float(DEFAULTS[ENTWAND_ROWS]),
          min=1,
          max=50,
          width=100,
          tooltip="How many rows to spawn entities",
          tooltip_desc="Warning: Things can quickly turn sour with high numbers",
        },
        function(new_value)
          GlobalsSetValue(ENTWAND_ROWS, new_value)
          change_spawner_reticle()
        end
      )
      Slider({
          text="Cols",
          value=GlobalsGetNumber(ENTWAND_COLS),
          default=float(DEFAULTS[ENTWAND_COLS]),
          min=1,
          max=50,
          width=100,
          tooltip="How many columns to spawn entities",
          tooltip_desc="Warning: Things can quickly turn sour with high numbers",
        },
        function(new_value)
          GlobalsSetValue(ENTWAND_COLS, new_value)
          change_spawner_reticle()
        end
      )
      Slider({
          text="Grid",
          value=GlobalsGetNumber(ENTWAND_GRID_SIZE),
          default=float(DEFAULTS[ENTWAND_GRID_SIZE]),
          min=1,
          max=100,
          width=100,
          tooltip="Entity spawner grid snapping size"
        },
        function(new_value)
          GlobalsSetValue(ENTWAND_GRID_SIZE, new_value)
          change_spawner_reticle()
        end
      )

      VerticalSpacing(6)
      Text("Deleting", {color=COLOR_TEXT_TITLE})
      VerticalSpacing(2)
      Checkbox({
          is_active=GlobalsGetBool(ENTWAND_KILL_INSTEAD),
          text="Kill instead of deleting",
          tooltip="If the entity has a pulse, it will be killed instead.",
        },
        function() GlobalsToggleBool(ENTWAND_KILL_INSTEAD) end
      )
      Checkbox({
          is_active=GlobalsGetBool(ENTWAND_HOLD_TO_DELETE),
          text="Delete when holding",
          tooltip="Less accurate but more efficient way of removing multiple entities"
        },
        function() GlobalsToggleBool(ENTWAND_HOLD_TO_DELETE) end
      )
      Checkbox({
          is_active=GlobalsGetBool(ENTWAND_DELETE_ALL),
          text="Delete multiple",
          tooltip="Deletes everything in a short radius around the mouse",
        },
        function() GlobalsToggleBool(ENTWAND_DELETE_ALL) end
      )
      Checkbox({
          is_active=GlobalsGetBool(ENTWAND_IGNORE_BACKGROUNDS),
          text="Don't target bg/fg visuals",
          tooltip="Prevents you from deleting background & foreground entities.",
        },
        function() GlobalsToggleBool(ENTWAND_IGNORE_BACKGROUNDS) end
      )

      VerticalSpacing(6)
      Text("Other", {color=COLOR_TEXT_TITLE})
      VerticalSpacing(2)
      Checkbox({
          is_active=GlobalsGetBool(ANIMALS_SPAWN_GOLD),
          text="Gold drops",
          tooltip="If creatures should drop gold upon death or not.",
        },
        function() GlobalsToggleBool(ANIMALS_SPAWN_GOLD) end
      )
    end)

    -- TODO: Auto-select the newest entity spawned with Claw
  end)
end


function render_entwand_buttons()
  local active_entity = get_active_entity();
  local main_menu_items = {
    {
      name = "Entity Picker",
      image_func = function() return active_entity.image end,
      action = function() toggle_active_entwand_overlay(render_entity_picker) end,
      desc="["..GameTextGetTranslatedOrNot(active_entity.name).."]"
    },
    {
      name = "Staff Options",
      image = ICON_STAFF_OPTIONS,
      action = function() toggle_active_entwand_overlay(render_entity_options) end,
      desc="[LEFT-CLICK] to conjure entities"
    },
    {
      name = "Delete Entity",
      image = ICON_DELETE_ENTITY,
      action = function() return end,
      desc="[RIGHT-CLICK] to delete entities"
    },
  };

  -- Render picker buttons
  Background({margin=1, style=NPBG_BLUE, z_index=200}, function()
    for i, item in ipairs(main_menu_items) do
      Button(
        {
          image=item.image or item.image_func(),
          tooltip=item.name, tooltip_desc=item.desc
        },
        item.action
      )
      VerticalSpacing(2)
    end
  end)

  VerticalSpacing(2)
  Text("fav.", {x=1})
  Tooltip("Add favorites with [RIGHT-CLICK]\non individual entity icons", "")
  VerticalSpacing(1)

  -- Render favorite buttons
  Background({margin=1, style=NPBG_BLUE, z_index=200}, function()
    for i, fav in ipairs(favorites) do
      Button(fav.vars, fav.click, remove_entity_from_favorites(i))
      VerticalSpacing(2)
    end
  end)
end


function toggle_active_entwand_overlay(func)
  render_active_entwand_overlay = (render_active_entwand_overlay ~= func) and func or nil
end


function render_entwand()
  Vertical(main_menu_pos_x, main_menu_pos_y, function()
    render_entwand_buttons()
  end)

  if render_active_entwand_overlay ~= nil then
    Vertical(sub_menu_pos_x, sub_menu_pos_y, function()
      render_active_entwand_overlay()
    end)
  end
end
