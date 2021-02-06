dofile("data/scripts/lib/utilities.lua")

dofile_once("mods/raksa/files/wands/editwand/helpers.lua");
dofile_once("mods/raksa/files/gui/editable_components.lua")

dofile_once("mods/raksa/files/lib/gui.lua")
dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/scripts/enums.lua")


local render_active_editwand_overlay = nil
local main_menu_pos_x = 1
local main_menu_pos_y = 18
local sub_menu_pos_x = main_menu_pos_x+3
local sub_menu_pos_y = main_menu_pos_y-4

local active_entity = nil
local active_props = nil


function render_entity_properties()
  local entity = active_entity
  if not EntityGetIsAlive(entity) then
    render_active_editwand_overlay = nil
    return
  end

  local name = EntityGetName(entity)
  if not name or #name == 0 then
    name = "unnamed"
  end

  local tags = EntityGetTags(entity)
  if not tags or #tags == 0 then
    tags = "No tags"
  end

  local x, y, rot, scale_x, scale_y = EntityGetTransform(entity)
  Text(GameTextGetTranslatedOrNot(name), {tooltip=tags, x=4})

  Background({margin=3, style=NPBG_DEFAULT, z_index=200, min_width=90}, function()
    Vertical(1, 1, function()
      Horizontal(0, 0, function()
        Image({sprite="mods/raksa/files/gfx/editwand_icons/info_position.png", tooltip="Position"})
        Text(math.floor(x)..", "..math.floor(y), {tooltip="Position", x=4})
      end)
      Horizontal(0, 0, function()
        Image({sprite="mods/raksa/files/gfx/editwand_icons/info_rotation.png", tooltip="Rotation"})
        Text(string.format("%.2f", rot), {tooltip="Rotation", x=2})
      end)
      Horizontal(0, 0, function()
        Image({sprite="mods/raksa/files/gfx/editwand_icons/info_scale.png", tooltip="Scale"})
        Text(string.format("%.2f", scale_x)..", "..string.format("%.2f", scale_y), {tooltip="Scale", x=2})
      end)

      VerticalSpacing(2)
      Text("Fine-tuning:", {color={red=155, green=173, blue=183}})
      VerticalSpacing(2)

      if is_physical_entity(entity) then
        Text("[not supported]", {
          tooltip="Physical entities don't like micro adjustments.",
          tooltip_desc="Try animals or backgrounds!",
          color={red=183, green=146, blue=110},
        })
        return
      end

      Horizontal(0, 0, function()
        Button(
          {tooltip="Rotation -0.01", image="mods/raksa/files/gfx/editwand_icons/icon_arrow_left_cycle.png"},
          function() EntitySetTransform(entity, x, y, rot-0.01, scale_x, scale_y) end
        )
        Button(
          {tooltip="Y-Pos -1.0", image="mods/raksa/files/gfx/editwand_icons/icon_arrow_up.png"},
          function() EntitySetTransform(entity, x, y-1, rot, scale_x, scale_y) end
        )
        Button(
          {tooltip="Rotation +0.01", image="mods/raksa/files/gfx/editwand_icons/icon_arrow_right_cycle.png"},
          function() EntitySetTransform(entity, x, y, rot+0.01, scale_x, scale_y) end
        )
      end)
      Horizontal(0, 0, function()
        Button(
          {tooltip="X-Pos -1.0", image="mods/raksa/files/gfx/editwand_icons/icon_arrow_left.png"},
          function() EntitySetTransform(entity, x-1, y, rot, scale_x, scale_y) end
        )
        Button(
          {tooltip="Y-Pos +1.0", image="mods/raksa/files/gfx/editwand_icons/icon_arrow_down.png"},
          function() EntitySetTransform(entity, x, y+1, rot, scale_x, scale_y) end
        )
        Button(
          {tooltip="X-Pos +1.0", image="mods/raksa/files/gfx/editwand_icons/icon_arrow_right.png"},
          function() EntitySetTransform(entity, x+1, y, rot, scale_x, scale_y) end
        )
      end)

      function incr(var, amount)
        local sign = var < 0 and -1 or 1
        return var + amount * sign
      end

      function decr(var, amount)
        local sign = var < 0 and -1 or 1

        local new = var - amount * sign
        if sign == 1 then
          return math.max(0.01, new)
        end
        return math.min(0.01, new)
      end

      Horizontal(0, 0, function()
        Vertical(0, 1, function()
          Button(
            {x=1, y=-3, tooltip="Scale +0.1", image="mods/raksa/files/gfx/editwand_icons/icon_plus_small.png"},
            function()
              EntitySetTransform(entity, x, y, rot, incr(scale_x, 0.1), incr(scale_y, 0.1))
            end
          )
          Button(
            {x=1, y=1, tooltip="Scale +0.01", image="mods/raksa/files/gfx/editwand_icons/icon_plus_small.png"},
            function()
              EntitySetTransform(entity, x, y, rot, incr(scale_x, 0.01), incr(scale_y, 0.01))
            end
          )
        end)
        Button(
          {x=3, tooltip="Scale +1.0", image="mods/raksa/files/gfx/editwand_icons/icon_plus.png"},
          function()
            EntitySetTransform(entity, x, y, rot, incr(scale_x, 1), incr(scale_y, 1))
          end
        )
        Button(
          {x=-1, tooltip="Scale -1.0", image="mods/raksa/files/gfx/editwand_icons/icon_minus.png"},
          function()
            EntitySetTransform(entity, x, y, rot, decr(scale_x, 1), decr(scale_y, 1))
          end
        )
        Vertical(0, 1, function()
          Button(
            {y=-3, tooltip="Scale -0.1", image="mods/raksa/files/gfx/editwand_icons/icon_minus_small.png"},
            function()
              EntitySetTransform(entity, x, y, rot, decr(scale_x, 0.1), decr(scale_y, 0.1))
            end
          )
          Button(
            {y=1, tooltip="Scale -0.01", image="mods/raksa/files/gfx/editwand_icons/icon_minus_small.png"},
            function()
              EntitySetTransform(entity, x, y, rot, decr(scale_x, 0.01), decr(scale_y, 0.01))
            end
          )
        end)
      end)

      Horizontal(0, 3, function()
        Button(
          {tooltip="Flip horizontally", image="mods/raksa/files/gfx/editwand_icons/icon_arrow_horizontal.png"},
          function()EntitySetTransform(entity, x, y, rot, scale_x*-1, scale_y) end
        )
        Button(
          {x=-1, tooltip="Flip vertically", image="mods/raksa/files/gfx/editwand_icons/icon_arrow_vertical.png"},
          function() EntitySetTransform(entity, x, y, rot, scale_x, scale_y*-1) end
        )
        Button(
          {x=2, tooltip="Reset rotation & scale", image="mods/raksa/files/gfx/editwand_icons/icon_reset_2.png"},
          function() EntitySetTransform(entity, x, y, 0, 1, 1) end
        )
      end)
    end)
  end)
end

function render_editwand_buttons()
  local main_menu_items = {
    {
      name = "Move & freeze entities",
      image = ICON_UNKNOWN,
      desc="Left-click to move entities.\nRight-click while moving to freeze."
    },
    {
      name = "Rotate entities",
      image = ICON_UNKNOWN,
      desc="Right-click to rotate entities.\nNote: physics entities have no free rotation, only torque."
    },
  };

  -- Render picker buttons
  Background({margin=1, style=NPBG_GOLD, z_index=200}, function()
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
  Text("ent.", {x=1, tooltip="Inspect the hovered entity by pressing [use]."})
  VerticalSpacing(1)

  if not EntityGetIsAlive(active_entity) then
    return
  end

  -- TODO: Run this code only once, then load from globals
  local valid_comps = {}
  local comps = EntityGetAllComponents(active_entity)
  for c, comp in ipairs(comps) do
    local name = ComponentGetTypeName(comp)
    if SUPPORTED_COMPONENTS[name] then
      table.insert(valid_comps, SUPPORTED_COMPONENTS[name](comp))
    end
  end
  --

  for i, item in ipairs(valid_comps) do
    Button(
      {
        --image=item.image or item.image_func(),
        tooltip=item.name, tooltip_desc=item.desc,
        image_letter_text=item.name
      },
      function()
        active_props = item.props
        toggle_active_editwand_overlay(render_component_properties)
      end
    )
    VerticalSpacing(2)
  end
end


function render_component_properties()
  local component = active_props.component
  local fields = active_props.fields

  Horizontal(1, 1, function()
    Text(ComponentGetTypeName(component) .. " properties")
  end)

  Background({margin=1, style=NPBG_DEFAULT, z_index=200}, function()
    Vertical(1, 2, function()
      for f, field in ipairs(fields) do
        field(component, active_entity)
      end
    end)
  end)
end


function toggle_active_editwand_overlay(func)
  render_active_editwand_overlay = (render_active_editwand_overlay ~= func) and func or nil
end


function render_editwand()
  active_entity = GlobalsGetNumber(ENTITY_TO_INSPECT)

  -- Should run only the first time an entity is selected for inspection
  if active_entity and EntityGetIsAlive(active_entity) and render_active_editwand_overlay == nil then
    toggle_active_editwand_overlay(render_entity_properties)
  end

  Vertical(main_menu_pos_x, main_menu_pos_y, function()
    render_editwand_buttons()
  end)

  if render_active_editwand_overlay ~= nil then
    Vertical(sub_menu_pos_x, sub_menu_pos_y, function()
      render_active_editwand_overlay()
    end)
  end
end
