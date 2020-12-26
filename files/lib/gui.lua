dofile("data/scripts/lib/coroutines.lua")

dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/scripts/enums.lua")


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


function Grid(items, callback, x, y, size)
  local auto_size = math.max(6, math.min((#items) ^ 0.75, 12))
  local row_length = math.ceil(size or auto_size);
  local row_count = math.ceil(#items / row_length)

  x = x or 0
  y = y or 0

  local item_pos = 1
  for row=1, row_count do
    if not items[item_pos] then break end

    Horizontal(x, y, function()
      for col = 1, row_length do
        if not items[item_pos] then break end
        callback(items[item_pos], item_pos)
        item_pos = item_pos + 1
      end
    end)
  end
end


function Button(vars, click_action, right_click_action)
  local ButtonType = vars.text and GuiButton or GuiImageButton
  local click, right_click = ButtonType(
    GUI, BID(),
    vars.x or 0,
    vars.y or 0,
    vars.text or "",
    vars.image or ICON_UNKNOWN
  )

  if vars.tooltip then
    Tooltip(vars.tooltip, vars.tooltip_desc or "")
  end

  if click and click_action then
    click_action()
  end

  if right_click and right_click_action then
    right_click_action()
  end
end


NPBG_STYLES = {
  [NPBG_DEFAULT]="data/ui_gfx/decorations/9piece0_gray.png",
  [NPBG_GOLD]="data/ui_gfx/decorations/9piece0.png",
  [NPBG_TAB]="mods/raksa/files/gfx/9piece_tab.png",
  [NPBG_BLUE]="mods/raksa/files/gfx/9piece_blue.png",
  [NPBG_BLUE_TAB]="mods/raksa/files/gfx/9piece_blue_tab.png",
  [NPBG_BROWN]="mods/raksa/files/gfx/9piece_brown.png",
  [NPBG_BROWN_TAB]="mods/raksa/files/gfx/9piece_brown_tab.png",
}

function Background(margin, style, z_index, callback)
  if not style then style = NPBG_DEFAULT end
  local sprite = NPBG_STYLES[style]

  GuiBeginAutoBox(GUI)
    callback()
  GuiZSetForNextWidget(GUI, z_index)
  GuiEndAutoBoxNinePiece(GUI, margin, 5, 5, false, 0, sprite, sprite)
end


function Slider(vars, callback)
  callback(GuiSlider(
    GUI, BID(),
    vars.x or 0,
    vars.y or 0,
    vars.text or "",
    vars.value,
    vars.min or 0,
    vars.max,
    vars.default or 0,
    vars.display_multiplier or 1,
    vars.formatting or "",
    vars.width or 50
  ))

  if vars.tooltip then
    Tooltip(vars.tooltip, vars.tooltip_desc or "")
  end
end

function Text(x, y, text)
  GuiText(GUI, x, y, text)
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
