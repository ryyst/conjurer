local t = GameGetRealWorldTimeSinceStarted();

dofile_once( "mods/raksa/files/gui/base.lua" );
dofile_once( "mods/raksa/files/gui/helper.lua" );
dofile_once( "mods/raksa/files/scripts/material_icons.lua" );


dofile_once( "data/scripts/gun/gun_enums.lua" );
dofile_once( "data/scripts/gun/gun_actions.lua" );

--[[
ACTION_TYPE_PROJECTILE	= 0
ACTION_TYPE_STATIC_PROJECTILE = 1
ACTION_TYPE_MODIFIER	= 2
ACTION_TYPE_DRAW_MANY	= 3
ACTION_TYPE_MATERIAL	= 4
ACTION_TYPE_OTHER		= 5
ACTION_TYPE_UTILITY		= 6
ACTION_TYPE_PASSIVE		= 7
]]

MATERIAL_SOLIDS  = 0
MATERIAL_SANDS   = 1
MATERIAL_LIQUIDS = 2
MATERIAL_GASES   = 3
MATERIAL_FIRES   = 4


local type_order = {
  MATERIAL_SOLIDS,
  MATERIAL_SANDS,
  MATERIAL_LIQUIDS,
  MATERIAL_GASES,
  MATERIAL_FIRES,
};

local type_text = {
  [MATERIAL_SOLIDS]="Solids",
  [MATERIAL_SANDS]="Sands",
  [MATERIAL_LIQUIDS]="Liquid",
  [MATERIAL_GASES]="Gases",
  [MATERIAL_FIRES]="Fires",
}


local type_funcs = {
  [MATERIAL_SOLIDS]=CellFactory_GetAllSolids,
  [MATERIAL_SANDS]=CellFactory_GetAllSands,
  [MATERIAL_LIQUIDS]=CellFactory_GetAllLiquids,
  [MATERIAL_GASES]=CellFactory_GetAllGases,
  [MATERIAL_FIRES]=CellFactory_GetAllFires,
}

local now = GameGetFrameNum();
local spell_lab_entity = EntityGetWithTag( "spell_lab_config" )[1];
local entity = GetUpdatedEntityID();
local player_x, player_y = EntityGetTransform( entity );
local camera_x, camera_y = GameGetCameraPos();
local x,y = camera_x, camera_y;
local ui_buttons_scale =  2/3;
local action_scale = 2/3;
local actions_width = 160;
local selection_width = 320;
local selection_height = 160;
local vertical_offset = 20;
local held_wand_vertical_offset = 110;
local action_width = 16 * action_scale;
local action_height = 16 * action_scale;
local action_spacing_x = 20 * action_scale;
local action_spacing_y = 20 * action_scale;
local action_columns = 12;
filter_type = filter_type or MATERIAL_SOLIDS;
action_count = action_count;
sorted_actions = sorted_actions or {};
action_data = action_data or {};
action_metadata = action_metadata or {};
current_challenge = current_challenge or nil;
if selected_acton_index == nil then selected_acton_index = 0 end
if first_refresh == nil then first_refresh = false end

local font = {
  sprite_filepath = "mods/raksa/files/font/small_font.xml",
  character_width = 11,
  character_height = 12,
  character_spacing = -7,
  character_specific_spacing = {
    ["W"] = {1,-6},
    ["M"] = {1,-6},
    ["N"] = {1,-7},
    ["_"] = {1,-6},
    ["#"] = {1,-6},
    ["%"] = {1,-6},
    ["/"] = {1,-6},
    ["\\"] = {1,-6},
    ["~"] = {1,-6},
    [","] = {-1,-8},
  }
}

function draw_action_list( actions, x, y, scale_x, scale_y )
  for i,action_id in pairs( actions or {} ) do
    local action = action_data[action_id];
    local ax = x + action_spacing_x * ( i - 1 ) - (action_spacing_x * (#actions - 1)) * 0.5;
    local ay = y;
    draw_sprite( "mods/raksa/files/gui/sheet.xml", ax - 2 * action_scale, ay - 2 * action_scale, 0, 0, action_scale, action_scale, 0, 1.0, true, 0, "spell_box_"..action.type );
    draw_sprite( action.sprite, ax, ay, 0, 0, action_scale, action_scale, 0, 1.0, true, -1 );
  end
end

function block_held_wand_firing()
  local held_wand = get_entity_first_or_random_wand( entity, false );
  if held_wand ~= 0 then
    local ability = EntityGetFirstComponentIncludingDisabled( held_wand, "AbilityComponent" );
    if ability then
      ComponentSetValue2( ability, "mReloadFramesLeft", 2 );
      ComponentSetValue2( ability, "mNextFrameUsable", now + 2 );
      ComponentSetValue2( ability, "mReloadNextFrameUsable", now + 2 );
    end
  end
end

function force_refresh_wand()
  local inventory2 = EntityGetFirstComponent( entity, "Inventory2Component" );
  if inventory2 ~= nil then
    ComponentSetValue2( inventory2, "mForceRefresh", true );
    ComponentSetValue2( inventory2, "mActualActiveItem", 0 );
  end
end

local OVERLAYS = {
  None = nil,
  MaterialPicker = "raksa_material_picker",
  ChallengePicker = "spell_lab_challenge_picker",
  WandPicker = "spell_lab_wand_picker",
};

function is_picker_active( picker )
  return GlobalsGetValue( picker, "0" ) == "1";
end

function change_picker( picker )
  local was_active = GlobalsGetValue( picker, "0" ) == "1";
  for k,v in pairs( OVERLAYS ) do GlobalsSetValue( v, "0" ); end
  if picker ~= nil and not was_active then GlobalsSetValue( picker, "1" ); end
end

local metadata_to_show = {
  c = {
    --max_uses = { "Max Uses", -1, function(value) return tostring( value ); end },
    mana = { "Mana Drain", 0, function(value) return tostring( value ); end },
    fire_rate_wait = { "Cast Delay", 0, function(value) return tostring( math.floor( ( value / 60 ) * 1000 ) / 1000 ) .. " s"; end },
    reload_time = { "Recharge Time", 0, function(value) return tostring( math.floor( ( value / 60 ) * 1000 ) / 1000 ) .. " s"; end },
    spread_degrees = { "Spread", 0, function(value) return tostring( math.floor( value * 100 ) / 100 ) .. " deg"; end },
    damage_critical_chance = { "Crit. Chance", 0, function(value) return tostring( value ) .. "%"; end },
  },
  projectiles = {
    { "Damage", function( data ) if data.damage and data.damage ~= 0 then return tostring( math.floor( ( data.damage * 25 ) * 100 ) / 100 ); end end },
    { "Speed", function( data ) if data.speed_min ~= nil and data.speed_max ~= nil then return tostring( data.speed_min.."-"..data.speed_max ); end end },
    -- NOTE Lifetime is randomized so this won't be accurate
    --{ "Lifetime", function( data ) return tostring( data.lifetime_randomness == 0 and data.lifetime or (data.lifetime - data.lifetime_randomness) .. "-" .. (data.lifetime + data.lifetime_randomness ) ); end },
  }
};


function material_button( material, x, y, width, height, scale, selected, permanent, locked, click_callback )
  local material_path = MATERIAL_ICONS[material]
  local action_metadata = nil
  ui_button( x, y, width, height,
    function( x, y, hover )
      local action_alpha = 1.0;
      if material_path and locked then
        action_alpha = 0.6;
      end
      if material_path then
        draw_sprite( "mods/raksa/files/gui/sheet.xml", x - 2 * scale, y - 2 * scale, 0, 0, scale, scale, 0, 1.0, true, 0, "spell_box_0" );
        draw_sprite( material_path, x, y, -2, -2, scale*0.45, scale*0.45, 0, action_alpha, true, -3 );
      else
        draw_sprite( "mods/raksa/files/gui/sheet.xml", x - 2 * scale, y - 2 * scale, 0, 0, scale, scale, 0, 1.0, true, 0, "spell_box" );
      end
      if hover then
        if action_data then
          draw_text( font, material, x + 2, y - 6, 1, 1, 1, true, -2 );
          --draw_text( font, type_text[ action_data.type ], x + 4, y - 14, 0.67, 0.67, 1, true, -2 );
        end
        draw_sprite( "mods/raksa/files/gui/sheet.xml", x -2 * scale, y -2 * scale, 0, 0, scale, scale, 0, 1.0, true, 0, "spell_box_hover" );
      elseif selected then
        draw_sprite( "mods/raksa/files/gui/sheet.xml", x -2 * scale, y -2 * scale, 0, 0, scale, scale, 0, 1.0, true, 0, "spell_box_active" );
      end
    end,
    click_callback
    );
end




ui_button( -40 * ui_buttons_scale, -110, 20 * ui_buttons_scale, 20 * ui_buttons_scale,
  function( x, y, hover )
    if is_picker_active( OVERLAYS.MaterialPicker ) then
      if hover then
        draw_text( font, "Close Material Picker", x, y - 6 * ui_buttons_scale, ui_buttons_scale, ui_buttons_scale, 1, true, -2 );
      end
      draw_sprite( "mods/raksa/files/gui/sheet.xml", x, y, 0, 0, ui_buttons_scale, ui_buttons_scale, 0, 1, true, 0, "edit_wands" );
    else
      if hover then
        draw_text( font, "Material Picker", x, y - 6 * ui_buttons_scale, ui_buttons_scale, ui_buttons_scale, 1, true, -2 );
        draw_sprite( "mods/raksa/files/gui/sheet.xml", x, y, 0, 0, ui_buttons_scale, ui_buttons_scale, 0, 1.0, true, 0, "edit_wands" );
      else
        draw_sprite( "mods/raksa/files/gui/sheet.xml", x, y, 0, 0, ui_buttons_scale, ui_buttons_scale, 0, 0.5, true, 0, "edit_wands" );
      end
    end
  end,
  function( left_click, right_click )
    if left_click then
      change_picker( OVERLAYS.MaterialPicker );
    end
  end
  );




-- Draw bottom bar?
local held_wand = get_entity_first_or_random_wand( entity, false );
if held_wand ~= 0 then
  local held_wand_actions = wand_get_actions_absolute( held_wand );
  local ability = EntityGetFirstComponentIncludingDisabled( held_wand, "AbilityComponent" );
  if ability then
    local max_actions = ability_component_get_stat( ability, "deck_capacity" );
    local local_scale = 2/3;
    local spell_width = 8 / local_scale;
    for i=1,max_actions do
      local held_action = held_wand_actions[i-1] or {};
      material_button(
        held_action.action_id,
        i * spell_width - max_actions * spell_width * 0.5 - spell_width,
        held_wand_vertical_offset - action_height * local_scale,
        spell_width,
        spell_width,
        local_scale,
        i-1 == selected_acton_index,
        held_action.permanent,
        held_action.locked,
        function( left_click, right_click )
          if held_action and right_click then
            if held_action.locked == false then
              EntityRemoveFromParent( held_action.entity );
              EntityKill( held_action.entity );
              force_refresh_wand();
            else
              GamePrint("Can't remove a locked spell");
            end
          end
          selected_acton_index = i - 1;
        end
        );
    end
  end
end



-- Draw all the actions per correct list?
if GameIsInventoryOpen() == false then
  if is_picker_active( OVERLAYS.MaterialPicker ) then
    --local adjusted_materials = sorted_actions[filter_type];
    local adjusted_materials = type_funcs[filter_type]()

    local adjusted_columns = math.max( 6, math.min( (#adjusted_materials) ^ 0.5, 12 ) );

    local action_y = 0;
    local action_x = 0;
    for _,material in pairs( adjusted_materials or {} ) do
      if action_x >= adjusted_columns * action_spacing_x then
        action_x = 0;
        action_y = action_y + action_spacing_y;
      end

      material_button(
        material, -190 + action_x, -75 + action_y, action_width, action_height, 2/3, false, false, false,
        function( left_click, right_click )
          GlobalsSetValue("raksa_selected_material", material)
          GamePrint("Selected " .. material)
        end
      );

      action_x = action_x + action_spacing_x;
    end

    -- Draw the hoverable material type buttons
    for i=0,#type_order-1 do
      ui_button( -210, i * 20 * ui_buttons_scale - 80, 20 * ui_buttons_scale, 20 * ui_buttons_scale,
        function( x, y, hover )
          if filter_type == i then
            draw_sprite( "mods/raksa/files/gui/sheet.xml", x, y, 0, 0, ui_buttons_scale, ui_buttons_scale, 0, 1.0, true, 0, "type_filter_"..i );
          else
            draw_sprite( "mods/raksa/files/gui/sheet.xml", x, y, 0, 0, ui_buttons_scale, ui_buttons_scale, 0, 0.5, true, 0, "type_filter_"..i );
          end
          if hover then
            draw_text( font, type_text[i], x, y - 10 * ui_buttons_scale, ui_buttons_scale, ui_buttons_scale, 1, true, -2 );
            filter_type = i;
          end
        end,
        function( left_click, right_click ) end
        );
    end
    if not first_refresh then
      force_refresh_wand();
      first_refresh = true;
    end
  end
end

handle_input( camera_x, camera_y );

--[[
VIRTUAL_RESOLUTION_X="427"
VIRTUAL_RESOLUTION_Y="242"
]]
local spell_lab_time = tonumber( GlobalsGetValue("spell_lab_frame_time","0") );
local debug_string = "";
debug_string = debug_string ..
tostring( #EntityGetInRadius( x, y, 9999999 ) ) .. "e " ..
tostring( #EntityGetInRadiusWithTag( x, y, 9999999,"projectile_player" ) ) .. "p " ..
tostring( now ) .. "f " ..
tostring( math.floor( player_x + 0.5 ) ) .. "x " ..
tostring( math.floor( player_y + 0.5 ) ) .. "y " ..
tostring( math.floor( spell_lab_time * 100000 ) / 1000 ) .. "t ";
draw_text( font, debug_string, camera_x + 212, camera_y + 130, 1/3, 1/3, 1, true, -2, 1, 1 );

render();

GlobalsSetValue( "spell_lab_frame_time", tostring( GameGetRealWorldTimeSinceStarted() - t ) );
