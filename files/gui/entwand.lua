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

local active_entity_tab = SELECTED_ENTITY_TYPE_DEFAULT
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
  local active_entities = ALL_ENTITIES[active_entity_tab]

  Horizontal(1, 1, function()
    for i, category in ipairs(ALL_ENTITIES) do
      local is_selected = (i == active_entity_tab)
      local image = is_selected and category.icon or category.icon_off
      local style = is_selected and NPBG_BLUE_TAB or NPBG_BLUE
      local y_override = -0.3

      local vars = {tooltip=category.name, image=image, y=y_override, tooltip_desc=category.desc}
      Background(0, style, 100, function()
        Button(vars, function()
          active_entity_tab = i
        end)
      end)
      HorizontalSpacing(3)
    end
  end)

  -- Render entities
  Background(3, NPBG_BLUE, 200, function()
    Grid(active_entities.entities, function(entity, i)
      local vars = {tooltip=entity.name, image=entity.image, tooltip_desc=entity.desc}
      local tab_copy = active_entity_tab  -- For favorites
      local click = function() change_active_entity(i, tab_copy) end
      local right_click = add_entity_to_favorites(vars, click)
      Button(vars, click, right_click)
    end, 1, 2)
  end)
end


function render_entwand_buttons()
  local main_menu_items = {
    {
      name = "Entity Picker",
      image_func = function()
        local entity = get_active_entity();
        return entity.image
      end,
      action = function() toggle_active_entwand_overlay(render_entity_picker) end,
      desc="Left-click to conjure entities"
    },
    {
      name = "Delete Entity",
      image = ICON_DELETE_ENTITY,
      action = function() return end,
      desc="Right-click to delete entities"
    },
  };

  -- Render picker buttons
  Background(1, NPBG_BLUE, 200, function()
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
  Text(1, 0, "fav.")
  Tooltip("Add favorites by right-clicking on individual entities", "")
  VerticalSpacing(1)

  Background(1, NPBG_BLUE, 200, function()
    -- Render favorite buttons
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
