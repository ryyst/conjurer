dofile("data/scripts/lib/utilities.lua")

dofile_once("mods/raksa/files/wands/editwand/helpers.lua");
dofile_once("mods/raksa/files/wands/wand_utilities.lua");
dofile_once("mods/raksa/files/gui/editable_components.lua")

dofile_once("mods/raksa/files/lib/gui.lua")
dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/scripts/enums.lua")


local render_active_editwand_overlay = nil

local main_menu_pos_x = 1
local main_menu_pos_y = 18
local sub_menu_pos_x = main_menu_pos_x+3
local sub_menu_pos_y = main_menu_pos_y-5.3
local detail_menu_pos_x = sub_menu_pos_x+28
local detail_menu_pos_y = main_menu_pos_y

local active_entity = nil
local active_component = nil


function render_entity_properties()
  local entity = active_entity
  local filename = EntityGetFilename(entity)

  if not EntityGetIsAlive(entity) then
    render_active_editwand_overlay = nil
    return
  end

  local name = GameTextGetTranslatedOrNot(EntityGetName(entity))
  if not name or #name == 0 or name == "unknown" then
    name = get_entity_name_from_file(filename)
  end
  local readable_name = normalize_name(name)

  local tags = EntityGetTags(entity)
  if not tags or #tags == 0 then
    tags = "No tags found"
  end

  local tags_text = "Tags: "..tags
  local filepath = "Entity: "..(filename or "No XML found")

  local x, y, rot, scale_x, scale_y = EntityGetTransform(entity)

  -- Snap to grid
  x = math.floor(x)
  y = math.floor(y)

  Text(readable_name, {x=4})

  Background({margin=3, style=NPBG_DEFAULT, z_index=200, min_width=90}, function()
    Vertical(1, 1, function()
      Horizontal(0, 0, function()
        Image({sprite="mods/raksa/files/gfx/editwand_icons/info_position.png", tooltip="Position"})
        Text(math.floor(x)..", "..math.floor(y), {tooltip="Position", x=2})
      end)
      Horizontal(0, 0, function()
        Image({sprite="mods/raksa/files/gfx/editwand_icons/info_rotation.png", tooltip="Rotation"})
        Text(string.format("%.4f", rot), {tooltip="Rotation (rad)", x=2})
      end)
      Horizontal(0, 0, function()
        Image({sprite="mods/raksa/files/gfx/editwand_icons/info_scale.png", tooltip="Scale"})
        Text(string.format("%.2f", scale_x)..", "..string.format("%.2f", scale_y), {tooltip="Scale", x=2})
      end)

      Horizontal(0, 0, function()
        Image({sprite="mods/raksa/files/gfx/editwand_icons/info_xml.png", tooltip="Tags & XML"})
        HoverText(filepath .."\n"..tags_text, {x=2})
      end)

      VerticalSpacing(2)
      Text("Fine-tuning:", {color=COLOR_TEXT_TITLE})

      if is_physical_entity(entity) then
        Text("[not supported]", {
          tooltip="Physical entities don't like micro adjustments.",
          tooltip_desc="Try animals or backgrounds!",
          color={red=180, green=159, blue=129},
        })
      else
        Horizontal(0, -2, function()
          Button(
            {x=11, y=12, tooltip="Rotation -0.5 degrees", image="mods/raksa/files/gfx/editwand_icons/icon_arrow_left_cycle_small.png"},
            function() EntitySetTransform(entity, x, y, rot-math.rad(0.5), scale_x, scale_y) end
          )
          Button(
            {x=12, y=12, tooltip="Rotation +0.5 degrees", image="mods/raksa/files/gfx/editwand_icons/icon_arrow_right_cycle_small.png"},
            function() EntitySetTransform(entity, x, y, rot+math.rad(0.5), scale_x, scale_y) end
          )
        end)
        Horizontal(0, 0, function()
          Button(
            {tooltip="Rotation -90 degrees", image="mods/raksa/files/gfx/editwand_icons/icon_arrow_left_cycle.png"},
            function() EntitySetTransform(entity, x, y, rot-math.rad(90), scale_x, scale_y) end
          )
          Button(
            {tooltip="Y-Pos -1.0", image="mods/raksa/files/gfx/editwand_icons/icon_arrow_up.png"},
            function() EntitySetTransform(entity, x, y-1, rot, scale_x, scale_y) end
          )
          Button(
            {tooltip="Rotation +90 degrees", image="mods/raksa/files/gfx/editwand_icons/icon_arrow_right_cycle.png"},
            function() EntitySetTransform(entity, x, y, rot+math.rad(90), scale_x, scale_y) end
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
            {x=3, tooltip="Scale +0.5", image="mods/raksa/files/gfx/editwand_icons/icon_plus.png"},
            function()
              EntitySetTransform(entity, x, y, rot, incr(scale_x, 0.5), incr(scale_y, 0.5))
            end
          )
          Button(
            {x=-1, tooltip="Scale -0.5", image="mods/raksa/files/gfx/editwand_icons/icon_minus.png"},
            function()
              EntitySetTransform(entity, x, y, rot, decr(scale_x, 0.5), decr(scale_y, 0.5))
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
            function() EntitySetTransform(entity, x, y, rot, scale_x*-1, scale_y) end
          )
          Button(
            {x=-1, tooltip="Flip vertically", image="mods/raksa/files/gfx/editwand_icons/icon_arrow_vertical.png"},
            function() EntitySetTransform(entity, x, y, rot, scale_x, scale_y*-1) end
          )
          Button(
            {x=1, y=1, tooltip="Reset rotation & scale", image="mods/raksa/files/gfx/editwand_icons/icon_reset_3.png"},
            function() EntitySetTransform(entity, x, y, 0, 1, 1) end
          )
        end)
      end

      VerticalSpacing(16)
      Text("Other tools:", {color=COLOR_TEXT_TITLE})

      Vertical(0, 0, function()
        Horizontal(0, 0, function()
          local DamageModel = EntityFirstComponent(entity, "DamageModelComponent")
          if DamageModel then
            Button(
              {
                tooltip='Kill entity',
                tooltip_desc='Only available for "living" creatures',
                image="mods/raksa/files/gfx/editwand_icons/icon_kill.png",
              },
              function()
                -- Re-fetch damagemodel just in case
                local DamageModel = EntityFirstComponent(entity, "DamageModelComponent")
                ComponentSetValue2(DamageModel, "hp", 0)
                ComponentSetValue2(DamageModel, "air_needed", true)
                ComponentSetValue2(DamageModel, "air_in_lungs", 0)
                GlobalsSetValue(SIGNAL_RESET_EDITWAND_GUI, "1")
              end
            )
          end
          Button(
            {
              tooltip="Delete entity",
              image="mods/raksa/files/gfx/editwand_icons/icon_del.png",
            },
            function()
              EntityKill(entity)
              GlobalsSetValue(SIGNAL_RESET_EDITWAND_GUI, "1")
            end
          )

          -- TODO: Fix the bg/fg entities cloning
          if name ~= "raksa_background" then
            Button(
              {
                tooltip="Clone entity",
                tooltip_desc="Only a pure copy is made, no modifications are preserved.",
                image="mods/raksa/files/gfx/editwand_icons/icon_cln.png",
              },
              function()
                local x, y = EntityGetTransform(entity)
                EntityLoadProcessed(filename, x+10, y-10)
              end
            )
          end

          if DebugGetIsDevBuild() then
            Button(
              {
                tooltip="Save entity",
                tooltip_desc="Dumps the whole entity XML into your Noita base directory",
                image="mods/raksa/files/gfx/editwand_icons/icon_sav.png",
              },
              function()
                local basename = get_path_basename(filename)
                local save_file = "conjurer_"..basename
                EntitySave(entity, save_file)
                GamePrint("Entity saved as "..save_file.." in the Noita base folder")
              end
            )
          end
        end)

        local hitboxes = EntityGetComponentIncludingDisabled(entity, "HitboxComponent")
        if hitboxes then
          local hitbox_sprites = EntityGetComponentIncludingDisabled(entity, "SpriteComponent", "raksa_hitbox_display")
          local hitbox_updater = EntityGetFirstComponentIncludingDisabled(entity, "LuaComponent", "raksa_hitbox_updater")

          Checkbox({
              is_active=hitbox_sprites,
              text="Show hitboxes",
            },
            function()
              if hitbox_sprites then
                EntityRemoveComponent(entity, hitbox_updater)

                for i, comp in ipairs(hitbox_sprites) do
                  EntityRemoveComponent(entity, comp)
                end
                return
              end
              EntityAddComponent2(entity, "LuaComponent", {
                _tags="raksa_hitbox_updater",
                script_source_file="mods/raksa/files/scripts/update_hitbox_sprites.lua",
                execute_on_added=true,
                execute_every_n_frame=1,
              })
            end
          )
        end
      end)
    end)
  end)
end

function render_editwand_buttons()
  local main_menu_items = {
    {
      name = "[LEFT-CLICK] to move entities",
      image = "mods/raksa/files/gfx/editwand_icons/icon_m1.png",
      desc="[RIGHT-CLICK] while moving to freeze."
    },
    {
      name = "[RIGHT-CLICK] to rotate entities",
      image = "mods/raksa/files/gfx/editwand_icons/icon_m2.png",
      desc="Note: physics entities have no free rotation, only torque."
    },
    {
      name = "[INTERACT] to inspect entities",
      image = "mods/raksa/files/gfx/editwand_icons/icon_use.png",
      desc="Below this button will appear different properties\nof an entity, which you can edit freely."
    },
  };

  -- Render helper buttons
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

  VerticalSpacing(5)

  if not EntityGetIsAlive(active_entity) then
    return
  end

  -- Always show entity properties
  Button(
    {
      tooltip="Entity properties",
      image="mods/raksa/files/gfx/editwand_icons/icon_entity_properties.png",
      style=NPBG_DEFAULT,
      padding=0,
    },
    function()
      toggle_active_editwand_overlay(render_entity_properties)
    end
  )
  VerticalSpacing(4)

  -- TODO: Run this code only once, then load from globals
  local valid_comps = {}
  local comps = EntityGetAllComponents(active_entity)
  for c, comp in ipairs(comps) do
    local name = ComponentGetTypeName(comp)
    if SUPPORTED_COMPONENTS[name] and not ComponentHasTag(comp, "raksa_hitbox_display") then
      table.insert(valid_comps, SUPPORTED_COMPONENTS[name](comp))
    end
  end
  ------

  for i, item in ipairs(valid_comps) do
    Button(
      {
        tooltip=item.name, tooltip_desc=item.desc,
        image_letter_text=item.name
      },
      function()
        active_component = item
        raksa_editwand_active_field = nil
        toggle_active_editwand_overlay(render_component_properties)
      end
    )
    VerticalSpacing(2)
  end
end


function render_component_properties()
  if not EntityGetIsAlive(active_entity) then
    return
  end

  local props = active_component.props
  local name = active_component.name
  local component = props.component
  local fields = props.fields
  local id = tostring(component)

  Vertical(1, 1, function()
    Text(name.." properties ".." ["..id.."]")
  end)

  Vertical(1, 2, function()
    Scroller({margin_x=0, x=-3, margin_y=5, width=160, height=props.height}, function()
      Vertical(1, 0, function()
        for f, field in ipairs(fields) do
          field(component, active_entity)
        end
      end)
    end)
  end)
end


function render_detail_menu(active_field)
  Background({margin=3, style=NPBG_GOLD, z_index=200, min_width=90}, function()
    Text("Tuning " .. active_field.name)
    NumberInput({value=active_field.value}, function(new_value)
      active_field.value = new_value
    end)

    Horizontal(0, 1, function()
      function value_step(incr)
        active_field.value = active_field.value + incr
      end

      Button(
        {tooltip="Value -100", image="mods/raksa/files/gfx/editwand_icons/icon_minus_small.png"},
        function() value_step(-100) end
      )
      Button(
        {tooltip="Value -10", image="mods/raksa/files/gfx/editwand_icons/icon_minus_small.png"},
        function() value_step(-10) end
      )
      Button(
        {tooltip="Value -1", image="mods/raksa/files/gfx/editwand_icons/icon_minus_small.png"},
        function() value_step(-1) end
      )
      Button(
        {tooltip="Value -0.1", image="mods/raksa/files/gfx/editwand_icons/icon_minus_small.png"},
        function() value_step(-0.1) end
      )
      Text(",")
      Button(
        {tooltip="Value +0.1", image="mods/raksa/files/gfx/editwand_icons/icon_plus_small.png"},
        function() value_step(0.1) end
      )
      Button(
        {tooltip="Value +1", image="mods/raksa/files/gfx/editwand_icons/icon_plus_small.png"},
        function() value_step(1) end
      )
      Button(
        {tooltip="Value +10", image="mods/raksa/files/gfx/editwand_icons/icon_plus_small.png"},
        function() value_step(10) end
      )
      Button(
        {tooltip="Value +100", image="mods/raksa/files/gfx/editwand_icons/icon_plus_small.png"},
        function() value_step(100) end
      )
    end)

    Button(
      {x=0, y=0, tooltip="Value +10", image="mods/raksa/files/gfx/editwand_icons/icon_plus.png"},
      function()
        local value = tonumber(active_field.value)
        if not value then
          GamePrint("Sorry, that's not a valid number")
          return
        end

        ComponentSetValue2(active_field.comp, active_field.name, value)
      end
    )
  end)
end


function toggle_active_editwand_overlay(func)
  render_active_editwand_overlay = func
end


function render_editwand()
  if GlobalsGetBool(SIGNAL_RESET_EDITWAND_GUI) then
    active_entity = nil
    active_component = nil
    raksa_editwand_active_field=nil
    toggle_active_editwand_overlay(render_entity_properties)
    GlobalsSetValue(SIGNAL_RESET_EDITWAND_GUI, "0")
  end

  active_entity = GlobalsGetNumber(ENTITY_TO_INSPECT)

  -- Should run only the first time an entity is selected for inspection
  if active_entity and EntityGetIsAlive(active_entity) and render_active_editwand_overlay == nil then
    toggle_active_editwand_overlay(render_entity_properties)
  end

  Vertical(main_menu_pos_x, main_menu_pos_y, function()
    render_editwand_buttons()
  end)

  if render_active_editwand_overlay ~= nil and active_entity and EntityGetIsAlive(active_entity) then
    Vertical(sub_menu_pos_x, sub_menu_pos_y, function()
      render_active_editwand_overlay()
    end)

    local active_field = raksa_editwand_active_field
    if active_field then
      Vertical(detail_menu_pos_x, detail_menu_pos_y, function()
        render_detail_menu(active_field)
      end)
    end
  end

end
