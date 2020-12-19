dofile("data/scripts/lib/utilities.lua")

dofile_once("mods/raksa/files/scripts/lists/brushes.lua");
dofile_once("mods/raksa/files/wands/matwand/helpers.lua");
dofile_once("mods/raksa/files/scripts/lists/material_categories.lua");

dofile_once("mods/raksa/files/lib/gui.lua")
dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/scripts/enums.lua")


local render_active_matwand_overlay = nil
local main_menu_pos_x = 1
local main_menu_pos_y = 18
local sub_menu_pos_x = main_menu_pos_x+3
local sub_menu_pos_y = main_menu_pos_y-5.3

local active_material_type = 1
local favorites = {}


function remove_mat_from_favorites(i)
  return function()
    table.remove(favorites, i)
  end
end


function add_mat_to_favorites(vars, click)
  return function()
    table.insert(favorites, { vars=vars, click=click })
  end
end


function render_material_picker(GUI, BID_SPACE)
  local bid = BID_SPACE + 200
  local active_category = ALL_MATERIALS[active_material_type]

  -- Render material type buttons
  Horizontal(GUI, 1, 1, function()
    for i, category in ipairs(ALL_MATERIALS) do
      local is_selected = (i == active_material_type)
      local image = is_selected and category.icon or category.icon_off
      local style = is_selected and NPBG_BROWN_TAB or NPBG_BROWN
      local y_override = -0.3

      local vars = {tooltip=category.name, image=image, y=y_override, tooltip_desc=category.desc}
      Background(GUI, 0, style, 100, function()
        bid = Button(GUI, bid, vars, function()
          active_material_type = i
        end)
      end)
      GuiLayoutAddHorizontalSpacing(GUI, 3)
    end
  end)

  -- Render material buttons
  Background(GUI, 3, NPBG_BROWN, 200, function()
    Grid(GUI, active_category.materials, function(material)
      local vars = { image=material.image, tooltip=material.name }
      local click = function()
        GlobalsSetValue(SELECTED_MATERIAL, material.id)
        GlobalsSetValue(SELECTED_MATERIAL_ICON, material.image)
      end
      local right_click = add_mat_to_favorites(vars, click)
      bid = Button(GUI, bid, vars, click, right_click)
    end, 1, 2, 8)
  end)
end


function render_brush_picker(GUI, BID_SPACE)
  local bid = BID_SPACE + 300

  Horizontal(GUI, 1, 1, function()
    GuiText(GUI, 0, 0, "Brush Options")
  end)

  -- Render brushes
  Background(GUI, 3, NPBG_BROWN, 200, function()
    Grid(GUI, BRUSHES, function(brush, i)
      local vars = { image=brush.icon_file, tooltip=brush.name, tooltip_desc=brush.desc }
      local click = function() change_active_brush(brush, i) end
      local right_click = add_mat_to_favorites(vars, click)
      bid = Button(GUI, bid, vars, click, right_click)
    end, 1, 2, 7)

    Horizontal(GUI, 1, 3, function()
      local value = get_brush_grid_size()
      local repr = tostring(value)
      local default = tonumber(BRUSH_DEFAULT_GRID_SIZE)

      local new_val = GuiSlider(GUI, bid, 0, 0, "Grid", value, 1, 100, default, 1, repr, 100)
      GuiTooltip(GUI, "Brush snapping grid size", "")
      GlobalsSetValue(BRUSH_GRID_SIZE, math.ceil(new_val))
    end)
  end)
end


function render_eraser_picker(GUI, BID_SPACE)
  local bid = BID_SPACE + 400

  local eraser_categories = {
    {
      { text="All materials", mode=ERASER_MODE_ALL, image=ERASER_ICONS[ERASER_MODE_ALL] },
      { text="Selected material", mode=ERASER_MODE_SELECTED, image=get_active_material_image() },
    },
    {
      { text="Solid", mode=ERASER_MODE_SOLIDS, image=ERASER_ICONS[ERASER_MODE_SOLIDS], desc="Statics + Sands" },
      { text="Liquid", mode=ERASER_MODE_LIQUIDS, image=ERASER_ICONS[ERASER_MODE_LIQUIDS] },
      { text="Sand", mode=ERASER_MODE_SANDS, image=ERASER_ICONS[ERASER_MODE_SANDS] },
      { text="Gas", mode=ERASER_MODE_GASES, image=ERASER_ICONS[ERASER_MODE_GASES] },
      { text="Fire", mode=ERASER_MODE_FIRE, image=ERASER_ICONS[ERASER_MODE_FIRE] },
    }
  };

  local current_eraser = GlobalsGetValue(ERASER_MODE, ERASER_MODE_DEFAULT)

  Horizontal(GUI, 1, 1, function()
    GuiText(GUI, 0, 0, "Eraser Options")
  end)

  -- TODO: Rewrite the following to have a bit more generalized components.
  --       Seeing a lot of repetition here.
  Background(GUI, 3, NPBG_BROWN, 200, function()
    Vertical(GUI, 1, 2, function()

      GuiText(GUI, 0, 0, "Material filter")
      GuiTooltip(GUI, "Choose which material types to erase/replace", "")

      -- Render eraser filters
      for r, row in ipairs(eraser_categories) do
        Horizontal(GUI, 0, 0, function()
          for i, item in ipairs(row) do
            local vars = { tooltip=item.text, tooltip_desc=item.desc, image=item.image }
            local click = function() GlobalsSetValue(ERASER_MODE, item.mode) end
            local right_click = add_mat_to_favorites(vars, click)
            bid = Button(GUI, bid, vars, click, right_click)
          end
        end)
      end

      GuiLayoutAddVerticalSpacing(GUI, 4)

      -- TOGGLE MATERIAL REPLACEMENT
      local is_replacer_active = eraser_user_replacer()
      local new_replace = is_replacer_active and "0" or "1"
      local replacer_vars = {
        text=is_replacer_active and "[*] Replace mode" or "[ ] Replace mode",
        tooltip="Instead of erasing, existing materials will be\nreplaced with the currently selected one.",
        tooltip_desc="Note: Does nothing with the 'selected material' filter.",
      }
      bid = Button(GUI, bid, replacer_vars, function ()
        GlobalsSetValue(ERASER_REPLACE, new_replace)
      end)

      -- GRID SELECTION
      local use_brush_grid = eraser_use_brush_grid()
      local new_grid = use_brush_grid and "0" or "1"
      local grid_vars = {
        text=use_brush_grid and "[*] Use brush grid" or "[ ] Use brush grid",
        tooltip="Use the same grid setting as brushes",
      }
      bid = Button(GUI, bid, grid_vars, function ()
        GlobalsSetValue(ERASER_SHARED_GRID, new_grid)
      end)

      GuiLayoutAddVerticalSpacing(GUI, 2)

      -- OWN GRID SLIDER
      if not use_brush_grid then
        local grid_value = get_eraser_grid_size()
        local grid_repr = tostring(grid_value)
        local grid_default = tonumber(ERASER_DEFAULT_GRID_SIZE)

        local new_grid_val = GuiSlider(GUI, bid, 0, 0, "Grid", grid_value, 1, 100, grid_default, 1, grid_repr, 100)
        bid = bid + 1

        GuiTooltip(GUI, "Eraser snapping grid size", "")
        GlobalsSetValue(ERASER_GRID_SIZE, math.ceil(new_grid_val))

        GuiLayoutAddVerticalSpacing(GUI, 2)
      end

      -- SIZE BAR
      local value = GlobalsGetValue(ERASER_SIZE, ERASER_SIZE_DEFAULT)
      local repr = tostring(value*5) .. "px"
      local default = tonumber(ERASER_SIZE_DEFAULT)

      local new_val = GuiSlider(GUI, bid, 0, 0, "Size", value, 1, 20, default, 1, repr, 60 )
      bid = bid + 1

      GlobalsSetValue(ERASER_SIZE, math.ceil(new_val))
      change_eraser_reticle()
    end)
  end)
end


function render_matwand_buttons(GUI, BID_SPACE)
  local bid = BID_SPACE + 100

  local main_menu_items = {
    {
      name="Material Picker",
      image_func = get_active_material_image,
      action = function() toggle_active_matwand_overlay(render_material_picker) end,
      desc="Left-click to draw materials"
    },
    {
      name="Brush Options",
      image_func = function() return get_active_brush().icon_file end,
      action = function() toggle_active_matwand_overlay(render_brush_picker) end,
    },
    {
      name="Eraser Options",
      image_func = get_active_eraser_image,
      action = function() toggle_active_matwand_overlay(render_eraser_picker) end,
      desc="Right-click to erase materials"
    },
  };

  -- Render picker buttons
  Background(GUI, 1, NPBG_BROWN, 100, function()
    for i, item in ipairs(main_menu_items) do
      bid = Button(
        GUI, bid,
        {image=item.image_func(), tooltip=item.name, tooltip_desc=item.desc},
        item.action
      )
      GuiLayoutAddVerticalSpacing(GUI, 2)
    end
  end)

  GuiLayoutAddVerticalSpacing(GUI, 2)
  GuiText(GUI, 1, 0, "fav.")
  GuiTooltip(GUI, "Add favorites by right-clicking on individual mats/brushes/erasers", "")
  GuiLayoutAddVerticalSpacing(GUI, 1)

  Background(GUI, 1, NPBG_BROWN, 200, function()
    -- Render favorite buttons
    for i, fav in ipairs(favorites) do
      bid = Button(GUI, bid, fav.vars, fav.click, remove_mat_from_favorites(i))
      GuiLayoutAddVerticalSpacing(GUI, 2)
    end
  end)
end


function toggle_active_matwand_overlay(func)
  render_active_matwand_overlay = (render_active_matwand_overlay ~= func) and func or nil
end


-- Do this once.
--print("Generating materials table")
--generate_all_materials()


function render_matwand(GUI, BID_SPACE)
  Vertical(GUI, main_menu_pos_x, main_menu_pos_y, function()
    render_matwand_buttons(GUI, BID_SPACE)
  end)

  if render_active_matwand_overlay ~= nil then
    Vertical(GUI, sub_menu_pos_x, sub_menu_pos_y, function()
      render_active_matwand_overlay(GUI, BID_SPACE)
    end)
  end
end
