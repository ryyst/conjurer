dofile("data/scripts/lib/coroutines.lua")
dofile("data/scripts/lib/utilities.lua")

dofile_once("mods/raksa/files/scripts/lists/material_categories.lua");
dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/scripts/enums.lua")

dofile_once("mods/raksa/files/scripts/letter_icons.lua")


local function _init_bid_handler(value)
  local initial = 1
  local _bid = value or initial

  local new = function()
    _bid = _bid + 1
    return _bid
  end

  local reset = function(value)
    _bid = initial
    return _bid
  end

  return new, reset
end

print("Loading GUI handlers...")
BID, RESET_BID = _init_bid_handler()
GUI = GuiCreate()


function ColorNextWidget(vars)
  GuiColorSetForNextWidget(
    GUI,
    (vars.red or 255) / 255,
    (vars.green or 255) / 255,
    (vars.blue or 255) / 255,
    (vars.alpha or 255) / 255
  )
end


function OptionNextWidget(option)
  GuiOptionsAddForNextWidget(GUI, option)
end


function GetScreenDimensions()
  return GuiGetScreenDimensions(GUI)
end


function Horizontal(x, y, callback)
  GuiLayoutBeginHorizontal(GUI, x, y)
    callback()
  GuiLayoutEnd(GUI)
end


function Vertical(x, y, callback)
  GuiLayoutBeginVertical(GUI, x, y)
    callback()
  GuiLayoutEnd(GUI)
end


function HorizontalSpacing(amount)
  GuiLayoutAddHorizontalSpacing(GUI, amount)
end


function VerticalSpacing(amount)
  GuiLayoutAddVerticalSpacing(GUI, amount)
end


function Grid(vars, callback)
  local items = vars.items or {}
  local x = vars.x or 0
  local y = vars.y or 0

  local auto_size = math.max(6, math.min((#items) ^ 0.75, 12))
  local row_length = math.ceil(vars.size or auto_size);
  local row_count = math.ceil(#items / row_length)

  local item_pos = 1
  for row=0, row_count-1 do
    if not items[item_pos] then break end

    local y_reverse = vars.reverse and row*10 or 0

    Horizontal(x, y-y_reverse, function()
      for col = 1, row_length do
        if not items[item_pos] then break end
        callback(items[item_pos], item_pos)
        item_pos = item_pos + 1

        if vars.padding_x then
          HorizontalSpacing(vars.padding_x)
        end
      end
    end)

    if vars.padding_y then
      VerticalSpacing(vars.padding_y)
    end
  end
end


function Button(vars, click_action, right_click_action)
  local Wrapper = vars.style and Background or Noop

  -- "Padding" because we are working inside the button borders now.
  Wrapper({style=vars.style, margin=vars.padding or -2}, function()
    local click = nil
    local right_click = nil

    -- Simple icon buttons don't have any text attached to them
    if vars.text then
      click, right_click = GuiButton(
        GUI, BID(),
        vars.x or 0,
        vars.y or 0,
        vars.text
      )
    else
      click, right_click = GuiImageButton(
        GUI, BID(),
        vars.x or 0,
        vars.y or 0,
        "",
        vars.image or get_letter_icon(vars.image_letter_text)
      )
    end

    if vars.tooltip then
      Tooltip(vars.tooltip, vars.tooltip_desc or "")
    end

    if click and click_action then
      click_action()
    end

    if right_click and right_click_action then
      right_click_action()
    end
  end)
end


function Noop(vars, callback)
  -- No-op wrapper for easier boolean logic elsewhere
  callback()
end


function Background(vars, callback)
  local sprite = NPBG_STYLES[vars.style or NPBG_DEFAULT]

  GuiBeginAutoBox(GUI)
    callback()
  GuiZSetForNextWidget(GUI, vars.z_index or 100)
  GuiEndAutoBoxNinePiece(
    GUI,
    vars.margin or 5,
    vars.min_width or 5,
    vars.min_height or 5,
    vars.mirrorize_over_x_axis == true,
    vars.x_axis or 0,
    sprite,
    sprite
  )
end


function Scroller(vars, callback)
  GuiBeginScrollContainer(
    GUI, BID(),
    vars.x or 0,
    vars.y or 0,
    vars.width or 100,
    vars.height or 100,
    vars.gamepad_focusable or true,
    vars.margin_x or 0,
    vars.margin_y or 0
  )
    callback()
  GuiEndScrollContainer(GUI)
end


function Slider(vars, callback)
  -- The display value of GuiSlider component itself seems to use rounding,
  -- so we'll make it match with the real value.
  local new_value = GuiSlider(
    GUI, BID(),
    vars.x or 0,
    vars.y or 0,
    vars.text and vars.text.." " or "",
    vars.value,
    vars.min or 0,
    vars.max,
    vars.default or 0,
    vars.display_multiplier or 1,
    vars.formatting or "",
    vars.width or 50
  )

  -- Most sliders want integers, but a select few don't. Round by default.
  if not vars.decimals then
    new_value = round(new_value)
  end

  -- Run callback only if value changed.
  if new_value ~= vars.value then
    callback(new_value)
  end

  if vars.tooltip then
    Tooltip(vars.tooltip, vars.tooltip_desc or "")
  end
end


-- Breaking the signature uniformity here just because this is so
-- simple component, and arguably the vars are all optional while
-- text really is not.
function Text(text, vars)
  vars = vars or {}
  local x = vars.x or 0
  local y = vars.y or 0

  ColorNextWidget(vars.color or {})
  GuiText(GUI, x, y, text or "")
end


function Tooltip(text, desc)
  GuiTooltip(GUI, text, desc)
end


function Checkbox(vars, callback)
  local button_vars = {
    text=vars.is_active and "[*] "..vars.text or "[ ] "..vars.text,
    tooltip=vars.tooltip or nil,
    tooltip_desc=vars.tooltip_desc or nil,
  }
  Button(button_vars, callback)
end


local _active_category = 1  -- TODO: enum

function MaterialPicker(vars, click_handler, right_click_handler)
  local x = vars.x or 1
  local y = vars.y or 1

  -- Category selection tab buttons
  Horizontal(x, y, function()
    for i, category in ipairs(ALL_MATERIALS) do
      local is_selected = (i == _active_category)
      local image = is_selected and category.icon or category.icon_off
      local style = is_selected and NPBG_BROWN_TAB or NPBG_BROWN
      local y_override = -0.3

      local vars = {tooltip=category.name, image=image, y=y_override, tooltip_desc=category.desc}
      Background({margin=0, style=style}, function()
        Button(vars, function()
          _active_category = i
        end)
      end)
      HorizontalSpacing(3)
    end
  end)

  -- Material buttons
  local category = ALL_MATERIALS[_active_category]

  Background({margin=3, style=NPBG_BROWN, z_index=200}, function()
    Grid({
      items=category.materials,
      x=x, y=y+1,
      size=8,
    },
    function(material)
      Button({
          image=material.image,
          image_letter_text=material.name,
          tooltip=material.name
        },
        click_handler(material),
        right_click_handler(material)
      )
    end)
  end)
end
