dofile("data/scripts/lib/utilities.lua")

dofile_once("mods/raksa/files/wands/matwand/helpers.lua");
dofile_once("mods/raksa/files/scripts/lists/brushes.lua");
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


function render_material_picker()
  local active_category = ALL_MATERIALS[active_material_type]
  -- TODO: Migrate this over to use the new MaterialPicker component as well

  -- Render material type buttons
  Horizontal(1, 1, function()
    for i, category in ipairs(ALL_MATERIALS) do
      local is_selected = (i == active_material_type)
      local image = is_selected and category.icon or category.icon_off
      local style = is_selected and NPBG_BROWN_TAB or NPBG_BROWN
      local y_override = -0.3

      local vars = {tooltip=category.name, image=image, y=y_override, tooltip_desc=category.desc}
      Background({margin=0, style=style}, function()
        Button(vars, function()
          active_material_type = i
        end)
      end)
      HorizontalSpacing(3)
    end
  end)

  -- Render material buttons
  Background({margin=3, style=NPBG_BROWN, z_index=200}, function()
    Grid({items=active_category.materials, x=1, y=2, size=8}, function(material)
      local vars = {
        image=material.image,
        image_letter_text=material.name,
        tooltip=material.name,
        tooltip_desc=material.desc
      }
      local click = function()
        GlobalsSetValue(SELECTED_MATERIAL, material.id)
        GlobalsSetValue(SELECTED_MATERIAL_ICON, material.image or GLOBAL_UNDEFINED)
        GlobalsSetValue(SELECTED_MATERIAL_IS_PHYSICS, bool_to_global(material.is_physics))
      end
      local right_click = add_mat_to_favorites(vars, click)
      Button(vars, click, right_click)
    end)
  end)
end


function render_brush_picker()
  Horizontal(1, 1, function()
    Text("Brush Options")
  end)

  -- Render brushes
  Background({margin=3, style=NPBG_BROWN, z_index=200}, function()
    Grid({items=BRUSHES, x=1, y=2, size=7}, function(brush, i)
      local vars = {image=brush.icon_file, tooltip=brush.name, tooltip_desc=brush.desc}
      local click = function() change_active_brush(brush, i) end
      local right_click = add_mat_to_favorites(vars, click)
      Button(vars, click, right_click)
    end)

    Horizontal(1, 3, function()
      local vars = {
        text="Grid",
        value=get_brush_grid_size(),
        default=float(DEFAULTS[BRUSH_GRID_SIZE]),
        min=1,
        max=100,
        width=100,
        tooltip="Brush grid snapping size"
      }

      Slider(vars, function(new_value)
        GlobalsSetValue(BRUSH_GRID_SIZE, math.ceil(new_value))
      end)
    end)
  end)
end


function render_eraser_picker()
  local active_material = GlobalsGet(SELECTED_MATERIAL)
  local eraser_categories = {
    {
      { text="All materials", mode=ERASER_MODE_ALL, image=ERASER_ICONS[ERASER_MODE_ALL] },
      {
        text="Selected material",
        mode=ERASER_MODE_SELECTED,
        image_func=get_active_material_image,
        desc="Erase ONLY the currently active material\n["..active_material.."]",
      },
    },
    {
      { text="Solid", mode=ERASER_MODE_SOLIDS, image=ERASER_ICONS[ERASER_MODE_SOLIDS],
        desc="Statics + Sands"
      },
      { text="Liquid", mode=ERASER_MODE_LIQUIDS, image=ERASER_ICONS[ERASER_MODE_LIQUIDS] },
      { text="Sand", mode=ERASER_MODE_SANDS, image=ERASER_ICONS[ERASER_MODE_SANDS],
        desc="NOTE: Some of the more specialized sands are not caught by this\nfilter, due to the way Noita's materials are tagged.\nFor fine-grained work, use the 'selected material' filter."
      },
      { text="Gas", mode=ERASER_MODE_GASES, image=ERASER_ICONS[ERASER_MODE_GASES] },
      { text="Fire", mode=ERASER_MODE_FIRE, image=ERASER_ICONS[ERASER_MODE_FIRE],
        desc="Extinguish fires, assuming it's not too late..."
      },
    }
  };

  local current_eraser = get_eraser_mode()

  Horizontal(1, 1, function()
    Text("Eraser Options")
  end)

  Background({margin=3, style=NPBG_BROWN, z_index=200}, function()
    Vertical(1, 2, function()

      Text("Material filters")
      Tooltip("Choose which material types to erase/replace", "")

      -- Render eraser filters
      for r, row in ipairs(eraser_categories) do
        Horizontal(0, 0, function()
          for i, item in ipairs(row) do
            local vars = {
              tooltip=item.text,
              tooltip_desc=item.desc,
              image=item.image or item.image_func(),
              image_func=item.image_func,
              image_letter_text=active_material,
            }
            local click = function() GlobalsSetValue(ERASER_MODE, item.mode) end
            local right_click = add_mat_to_favorites(vars, click)
            Button(vars, click, right_click)
          end
        end)
      end

      VerticalSpacing(4)

      -- TOGGLE MATERIAL REPLACEMENT
      local is_replacer_active = eraser_use_replacer()
      local replacer_vars = {
        is_active=is_replacer_active,
        text="Replace mode",
        tooltip="Instead of erasing, existing materials will be\nreplaced with the currently selected one.",
        tooltip_desc="Note: Does nothing with the 'selected material' filter.",
      }
      Checkbox(replacer_vars, function ()
        GlobalsSetValue(ERASER_REPLACE, toggle_global(is_replacer_active))
      end)

      -- GRID SELECTION TOGGLE
      local use_brush_grid = eraser_use_brush_grid()
      local toggle_vars = {
        is_active=use_brush_grid,
        text="Use brush grid",
        tooltip="Use the same grid setting as brushes",
      }
      Checkbox(toggle_vars, function ()
        GlobalsSetValue(ERASER_SHARED_GRID, toggle_global(use_brush_grid))
      end)

      VerticalSpacing(2)

      -- ERASER GRID SLIDER
      if not use_brush_grid then
        local grid_slider_vars = {
          text="Grid",
          value=get_eraser_grid_size(),
          default=float(DEFAULTS[ERASER_GRID_SIZE]),
          min=1,
          max=100,
          width=100,
          tooltip="Eraser grid snapping size"
        }
        Slider(grid_slider_vars, function(new_value)
          GlobalsSetValue(ERASER_GRID_SIZE, math.ceil(new_value))
        end)

        VerticalSpacing(2)
      end

      -- SIZE BAR
      local value = get_eraser_size()
      local reticle_vars = {
        text="Size",
        value=value,
        formatting=str(value*5) .. "px",
        default=tonumber(DEFAULTS[ERASER_SIZE]),
        min=1,
        max=20,
        width=60,
      }

      Slider(reticle_vars, function(new_value)
        GlobalsSetValue(ERASER_SIZE, math.ceil(new_value))
        change_eraser_reticle()
      end)
    end)
  end)
end


function render_matwand_buttons()
  local main_menu_items = {
    {
      name="Material Picker",
      image_func = get_active_material_image,
      action = function() toggle_active_matwand_overlay(render_material_picker) end,
      desc="["..GlobalsGet(SELECTED_MATERIAL).."]",
    },
    {
      name="Brush Options",
      image_func = function() return get_active_brush().icon_file end,
      action = function() toggle_active_matwand_overlay(render_brush_picker) end,
      desc="Left-click to draw materials"
    },
    {
      name="Eraser Options",
      image_func = get_active_eraser_image,
      action = function() toggle_active_matwand_overlay(render_eraser_picker) end,
      desc="Right-click to erase materials"
    },
  };

  -- Render picker buttons
  Background({margin=1, style=NPBG_BROWN}, function()
    for i, item in ipairs(main_menu_items) do
      Button({
          image=item.image_func(),
          image_letter_text=GlobalsGet(SELECTED_MATERIAL),
          tooltip=item.name,
          tooltip_desc=item.desc,
        },
        item.action
      )
      VerticalSpacing(2)
    end
  end)

  VerticalSpacing(2)
  Text("fav.", {x=1})
  Tooltip("Add favorites by right-clicking on individual mats/brushes/erasers", "")
  VerticalSpacing(1)

  Background({margin=1, style=NPBG_BROWN, z_index=200}, function()
    -- Render favorite buttons
    for i, fav in ipairs(favorites) do
      if fav.vars.image_func then
        fav.vars.image = fav.vars.image_func()
        fav.vars.image_letter_text = GlobalsGet(SELECTED_MATERIAL)
      end
      Button(fav.vars, fav.click, remove_mat_from_favorites(i))
      VerticalSpacing(2)
    end
  end)
end


function toggle_active_matwand_overlay(func)
  render_active_matwand_overlay = (render_active_matwand_overlay ~= func) and func or nil
end


function render_matwand()
  Vertical(main_menu_pos_x, main_menu_pos_y, function()
    render_matwand_buttons()
  end)

  if render_active_matwand_overlay ~= nil then
    Vertical(sub_menu_pos_x, sub_menu_pos_y, function()
      render_active_matwand_overlay()
    end)
  end
end
