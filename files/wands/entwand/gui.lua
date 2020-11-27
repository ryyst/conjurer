dofile("data/scripts/lib/coroutines.lua")
dofile("data/scripts/lib/utilities.lua")

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

local active_entity_tab = SELECTED_ENTITY_TYPE_DEFAULT
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
  local active_entities = ALL_ENTITIES[active_entity_tab]

  Horizontal(GUI, 1, 1, function()
    for i, cat in ipairs(ENTITY_TYPES) do
      name = (cat == active_entity_tab) and string.upper(cat) or cat

      bid = Button(GUI, bid, {text=name}, function()
        active_entity_tab = cat
      end)
      GuiLayoutAddHorizontalSpacing(GUI, 3)
    end
  end)

  -- Render entities
  -- TODO: Make sure active_entity_tab reference is not lost when working with favorites
  Grid(GUI, active_entities, function(entity, i)
    local vars = { tooltip=entity.name, image=entity.image }
    local tab_copy = active_entity_tab  -- For favorites
    local click = function() change_active_entity(i, tab_copy) end
    local right_click = add_to_favorites(vars, click)
    bid = Button(GUI, bid, vars, click, right_click)
  end)
end


function render_main_buttons()
  local bid = 100

  local main_menu_items = {
    {
      name = "Entity Picker",
      image_func = function()
        local entity = get_active_entity();
        return entity.image
      end,
      action = function() toggle_active_overlay(render_entity_picker) end
    },
    {
      name = "Secondary Action",
      image = ICON_UNKNOWN,
      action = function() GamePrint("haloo") end,
    },
  };

  -- Render picker buttons
  for i, item in ipairs(main_menu_items) do
    bid = Button(
      GUI, bid,
      {image=item.image or item.image_func(), tooltip=item.name},
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
