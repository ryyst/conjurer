dofile("data/scripts/lib/coroutines.lua")

dofile_once("mods/raksa/files/scripts/utilities.lua")


function Horizontal(gui, x, y, callback)
  GuiLayoutBeginHorizontal(gui, x, y)
  callback()
  GuiLayoutEnd(gui)
end


function Vertical(gui, x, y, callback)
  GuiLayoutBeginVertical(gui, x, y)
  callback()
  GuiLayoutEnd(gui)
end


function Grid(gui, items, callback)
  local row_length = math.max( 6, math.min( (#items) ^ 0.75, 12 ) );
  local row_count = math.ceil(#items / row_length)

  local item_pos = 1
  for row=1, row_count do
    if not items[item_pos] then break end

    Horizontal(gui, 1, 2, function()
      for col = 1, row_length do
        if not items[item_pos] then break end
        callback(items[item_pos], item_pos)
        item_pos = item_pos + 1
      end
    end)
  end
end


function Button(gui, bid, vars, click_action, right_click_action)
  local x = vars.x or 0
  local y = vars.y or 0
  local image = vars.image or ICON_UNKNOWN
  local text = vars.text or ""
  local tooltip = vars.tooltip
  local tooltip_desc = vars.tooltip_desc or ""

  local ButtonType = vars.text and GuiButton or GuiImageButton

  local click, right_click = ButtonType(gui, bid, x, y, text, image)

  if tooltip then
    GuiTooltip(gui, tooltip, tooltip_desc)
  end

  if click and click_action then
    click_action()
  end

  if right_click and right_click_action then
    right_click_action()
  end

  -- Return the next button ID. Purposefully hiding the ugly incrementation
  -- logic from every single button loop.
  return bid + 1
end
