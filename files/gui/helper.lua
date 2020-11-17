dofile_once("data/scripts/gun/procedural/gun_action_utils.lua");

function ShootProjectile( who_shot, entity_file, x, y, vx, vy, send_message )
  local entity = EntityLoad( entity_file, x, y );
  local genome = EntityGetFirstComponent( who_shot, "GenomeDataComponent" );
  -- this is the herd id string
  --local herd_id = ComponentGetValue2( genome, "herd_id" );
  local herd_id = ComponentGetValueInt( genome, "herd_id" );
  if send_message == nil then send_message = true end

  GameShootProjectile( who_shot, x, y, x+vx, y+vy, entity, send_message );

  local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
  if projectile ~= nil then
    ComponentSetValue2( projectile, "mWhoShot", who_shot );
    -- NOTE the returned herd id actually breaks the herd logic, so don't bother
    --ComponentSetValue2( projectile, "mShooterHerdId", herd_id );
  end

  local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
  if velocity ~= nil then
    ComponentSetValue2( velocity, "mVelocity", vx, vy )
  end

  return entity;
end

function WandGetActive( entity )
  local chosen_wand = nil;
  local wands = {};
  local children = EntityGetAllChildren( entity )  or {};
  for key, child in pairs( children ) do
    if EntityGetName( child ) == "inventory_quick" then
      wands = EntityGetChildrenWithTag( child, "wand" );
      break;
    end
  end
  if #wands > 0 then
    local inventory2 = EntityGetFirstComponent( entity, "Inventory2Component" );
    local active_item = ComponentGetValue2( inventory2, "mActiveItem" );
    for _,wand in pairs( wands ) do
      if wand == active_item then
        chosen_wand = wand;
        break;
      end
    end
    return chosen_wand;
  end
end

function WandGetActiveOrRandom( entity )
  local chosen_wand = nil;
  local wands = {};
  local children = EntityGetAllChildren( entity )  or {};
  for key, child in pairs( children ) do
    if EntityGetName( child ) == "inventory_quick" then
      wands = EntityGetChildrenWithTag( child, "wand" );
      break;
    end
  end
  if #wands > 0 then
    local inventory2 = EntityGetFirstComponent( entity, "Inventory2Component" );
    local active_item = ComponentGetValue2( inventory2, "mActiveItem" );
    for _,wand in pairs( wands ) do
      if wand == active_item then
        chosen_wand = wand;
        break;
      end
    end
    if chosen_wand == nil then
      chosen_wand =  random_from_array( wands );
    end
    return chosen_wand;
  end
end

function benchmark( callback, iterations )
  if iterations == nil then
    iterations = 1;
  end
  local t = GameGetRealWorldTimeSinceStarted();
  for i=1,iterations do
    callback();
  end
  return GameGetRealWorldTimeSinceStarted() - t;
end

function map(func, array)
  local new_array = {};
  for i,v in ipairs(array) do
    new_array[i] = func(v);
  end
  return new_array;
end


function DoFileEnvironment( filepath, environment )
  if environment == nil then environment = {} end
  local f = loadfile( filepath );
  local set_f = setfenv( f, setmetatable( environment, { __index = _G } ) );
  local status,result = pcall( set_f );
  if status == false then print_error( "do file environment for "..filepath..": "..result ); end
  return environment;
end

function ModTextFileAppend( left, right )
  ModTextFileSetContent( left, (ModTextFileGetContent( left ) or "") .. "\r\n" .. (ModTextFileGetContent( right ) or "") );
end

function ModTextFilePrepend( left, right )
  ModTextFileSetContent( left, (ModTextFileGetContent( right ) or "") .. "\r\n" .. (ModTextFileGetContent( left ) or "") );
end

function PackString( separator, ... )
  local string = {};
  for n=1,select( '#' , ... ) do
    local j = select( n, ... );
    local text = nil;
    if type(j) == "boolean" then
      if j then
        text = "true";
      else
        text = "false";
      end
    else
      if type(j) == "string" and #j == 0 then
        text = "\"\"";
      else
        text = tostring( j ) or "nil";
      end
    end
    string[n] = text;
  end
  return table.concat( string, separator or "" );
end

function Log( ... )
  print( PackString(" ", ... ) );
end

function LogCompact( ... )
  local length = 0;
  local log = {};
  for k,v in pairs( {...} ) do
    table.insert( log, v );
    length = length + #v;
    if length > 80 then
      table.insert(log,"\n");
      length = 0;
    end
  end
  Log( unpack( log ) );
end

local screen_log_queue = {};
local screen_log_max = 20;
local screen_log_interval = 0.333;
function LogScreen( ... )
  table.insert( screen_log_queue, PackString( " ", ... ) );
end

function RenderLog( gui )
  local start_index = math.floor(GameGetRealWorldTimeSinceStarted()/screen_log_interval);
  for i=1,screen_log_max do
    local adjusted_index = (i + start_index) % #screen_log_queue;
    if screen_log_queue[adjusted_index] ~= nil then
      GuiText( gui, 0,0, tostring(screen_log_queue[adjusted_index]) );
    end
    GuiLayoutAddVerticalSpacing( gui );
  end
  screen_log_queue = {};
end

function LogTable( t )
  if type(t) == "table" then
    for k,v in pairs ( t ) do
      Log( k,v );
    end
  else
    Log( t );
  end
end

function LogTableCompact( t, show_keys )
  if type(t) == "table" then
    local length = 0;
    local log = {};
    for k,v in pairs( t ) do
      local join = PackString( "=", k, v );
      table.insert( log, join );
      length = length + #join;
      if length > 80 then
        table.insert(log,"\n");
        length = 0;
      end
    end
    Log( unpack( log ) );
  else
    Log( t );
  end
end

function ExploreGlobals()
  local g = {};
  for k,v in pairs(_G) do
    if type(v) ~= "function" then
      g[k] = v;
    end
  end
  LogTable(g);
end

function ListEntityComponents( entity )
  local components = EntityGetAllComponents( entity );
  for i, component_id in ipairs( components ) do
    Log( i, component_id );
  end
end

function ListEntityComponentObjects( entity, component_type_name, component_object_name )
  local component = EntityGetFirstComponent( entity, component_type_name );
  local members = ComponentObjectGetMembers( component, component_object_name );
  for member in pairs(members) do
    Log( member, ComponentObjectGetValue2( component, component_object_name, member ) );
  end
end

function CopyEntityComponentList( component_type_name, base_entity, copy_entity, keys )
  local base_component = EntityGetFirstComponent( base_entity, component_type_name );
  local copy_component = EntityGetFirstComponent( copy_entity, component_type_name );
  if base_component ~= nil and copy_component ~= nil then
    for index,key in pairs( keys ) do
      ComponentSetValue2( copy_component, key, ComponentGetValue2( base_component, key ) );
    end
  end
end

function CopyComponentMembers( base_component, copy_component )
  if base_component ~= nil and copy_component ~= nil then
    for key,value in pairs( ComponentGetMembers( base_component ) ) do
      ComponentSetValue2( copy_component, key, ComponentGetValue2( copy_component, key, value ) );
    end
  end
end

function CopyListedComponentMembers( base_component, copy_component, ... )
  if base_component ~= nil and copy_component ~= nil then
    for index,key in pairs( {...} ) do
      ComponentSetValue2( copy_component, key, ComponentGetValue2( base_component, key ) );
    end
  end
end

function CopyComponentObjectMembers( base_component, copy_component, component_object_name )
  if base_component ~= nil and copy_component ~= nil then
    for object_key in pairs( ComponentObjectGetMembers( base_component, component_object_name ) ) do
      ComponentObjectSetValue2( copy_component, component_object_name, object_key, ComponentObjectGetValue2( base_component, component_object_name, object_key ) );
    end
  end
end

function CopyEntityComponent( component_type_name, base_entity, copy_entity )
  local base_component = EntityGetFirstComponent( base_entity, component_type_name );
  local copy_component = EntityGetFirstComponent( copy_entity, component_type_name );
  CopyComponentMembers( base_component, copy_component );
end

function WandGetAbilityComponent( wand )
  local components = EntityGetAllComponents( wand ) or {};
  for _, component in pairs( components ) do
    if ComponentGetTypeName( component ) == "AbilityComponent" then
      return component;
    end
  end
end

function EnableWandAbilityComponent(wand_id)
  local components = EntityGetAllComponents( wand_id );
  for i, component_id in ipairs( components ) do
    for k, v2 in pairs( ComponentGetMembers( component_id ) ) do
      if k == "mItemRecoil" then
        EntitySetComponentIsEnabled( wand_id, component_id, true );
        break;
      end
    end
  end
end

function EntityComponentGetValue( entity_id, component_type_name, component_key, default_value )
  local component = EntityGetFirstComponent( entity_id, component_type_name );
  if component ~= nil then return ComponentGetValue2( component, component_key ); end
  return default_value;
end

function EntityGetNamedChild( entity_id, name )
  local children = EntityGetAllChildren( entity_id ) or {};
  if children ~= nil then
    for index,child_entity in pairs( children ) do
      local child_entity_name = EntityGetName( child_entity );

      if child_entity_name == name then
        return child_entity;
      end
    end
  end
end

function EntityGetChildrenWithTag( entity_id, tag )
  local valid_children = {};
  local children = EntityGetAllChildren( entity_id ) or {};
  for index, child in pairs( children ) do
    if EntityHasTag( child, tag ) then
      table.insert( valid_children, child );
    end
  end
  return valid_children;
end



function FindComponentByType( entity_id, component_type_name )
  local components = EntityGetAllComponents( entity_id ) or {};
  local valid_components = {};
  for _,component in pairs( components ) do
    if ComponentGetTypeName( component ) == component_type_name then
      table.insert( valid_components, component );
    end
  end
  return valid_components;
end

function FindComponentThroughTags( entity_id, ... )
  local matching_components = EntityGetAllComponents( entity_id ) or {};
  local valid_components = {};
  for _,tag in pairs( {...} ) do
    for index,component in pairs( matching_components ) do
      if ComponentGetValue2( component, tag ) ~= "" and ComponentGetValue2( component, tag ) ~= nil then
        table.insert( valid_components, component );
      end
    end
    matching_components = valid_components;
    valid_components = {};
  end
  return matching_components;
end

function FindFirstComponentThroughTags( entity_id, ... )
  return FindComponentThroughTags( entity_id, ...)[1];
end

function ComponentGetValueDefault( component_id, key, default )
  local value = ComponentGetValue2( component_id, key );
  if value ~= nil then
    return value;
  end
  return default;
end

function GetEntityCustomVariable( entity_id, variable_storage_tag, key, default )
  local variable_storage = EntityGetFirstComponent( entity_id, "VariableStorage", variable_storage_tag );
  if variable_storage ~= nil then
    return ComponentGetValue2( variable_storage, "value_string" );
  end
  return default;
end

function SetEntityCustomVariable( entity_id, variable_storage_tag, variable_name, value )
  local variable_storage = EntityGetFirstComponent( entity_id, "VariableStorage", variable_storage_tag );
  if variable_storage == nil then
    EntityAddComponent( entity_id, "VariableStorage", {
        _tags=tag,
        name=variable_name,
        value_string=tostring(value),
      });
  else
    ComponentSetValue2( variable_storage, "value_string", tostring(value) );
  end
end

function GetWandActions( wand )
  local actions = {};
  local children = EntityGetAllChildren( wand ) or {};
  for i,v in ipairs( children ) do
    local item = EntityGetFirstComponentIncludingDisabled( v, "ItemComponent" );
    local item_action = EntityGetFirstComponentIncludingDisabled( v, "ItemActionComponent" );
    if item and item_action then
      local action_id = ComponentGetValue2( item_action, "action_id" );
      local permanent = ComponentGetValue2( item, "permanently_attached" );
      local x, y = ComponentGetValue2( item, "inventory_slot" );
      if action_id ~= nil then
        table.insert( actions, { action_id = action_id, permanent = permanent, x = x, y = y } );
      end
    end
  end
  return actions;
end

function CopyWandActions( base_wand, copy_wand )
  local actions = GetWandActions( base_wand );
  for index,action_data in pairs( actions ) do
    local action_entity = CreateItemActionEntity( action_data.action_id );
    local item = EntityGetFirstComponentIncludingDisabled( action_entity, "ItemComponent" );
    if action_data.permanent then
      ComponentSetValue2( item, "permanently_attached", true );
    end
    if ComponentSetValue2 and action_data.x ~= nil and action_data.y ~= nil then
      ComponentSetValue2( item, "inventory_slot", action_data.x, action_data.y );
    end
    EntitySetComponentsWithTagEnabled( action_entity, "enabled_in_world", false );
    EntityAddChild( copy_wand, action_entity );
    --[[
        if action_data.permanent ~= "1" then
            AddGunAction( copy_wand, action_data.action_id );
        else
            AddGunActionPermanent( copy_wand, action_data.action_id );
        end
        ]]
  end
end

function FindEntityInInventory( inventory, entity )
  local inventory_items = EntityGetAllChildren( inventory )  or {};

  -- remove default items
  if inventory_items ~= nil then
    for i,item_entity in ipairs( inventory_items ) do
      --Log( i, item_entity );
    end
    --    GameKillInventoryItem( player_entity, item_entity )
    --end
  end
end

function TryGivePerk( player_entity_id, ... )
  for index,perk_id in pairs( {...} ) do
    local perk_entity = perk_spawn( x, y, perk_id );
    if perk_entity ~= nil then
      perk_pickup( perk_entity, player_entity_id, EntityGetName( perk_entity ), false, false );
    end
  end
end

function TryAdjustDamageMultipliers( entity, resistances )
  local damage_models = EntityGetComponent( entity, "DamageModelComponent" );
  if damage_models ~= nil then
    for index,damage_model in pairs( damage_models ) do
      for damage_type,multiplier in pairs( resistances ) do
        local resistance = ComponentObjectGetValue2( damage_model, "damage_multipliers", damage_type );
        resistance = resistance * multiplier;
        ComponentObjectSetValue2( damage_model, "damage_multipliers", damage_type, resistance );
      end
    end
  end
end


--[[
    ice
    electricity
    radioactive
    slice
    projectile
    healing
    physics_hit
    explosion
    poison
    melee
    drill
    fire
]]

function TryAdjustMaxHealth( entity, callback )
  local damage_models = EntityGetComponent( entity, "DamageModelComponent" );
  if damage_models ~= nil then
    for index,damage_model in pairs( damage_models ) do
      local current_hp = ComponentGetValue2( damage_model, "hp" );
      local max_hp = ComponentGetValue2( damage_model, "max_hp" );
      local new_max = callback( max_hp, current_hp );
      local regained = new_max - current_hp;
      ComponentSetValue2( damage_model, "max_hp", new_max );
      ComponentSetValue2( damage_model, "hp", current_hp + regained );
    end
  end
end

function GetInventoryQuickActiveItem( entity )
  if entity ~= nil then
    local component = EntityGetFirstComponent( entity, "Inventory2Component" );
    if component ~= nil then
      return ComponentGetValue2( component, "mActiveItem" );
    end
  end
end

function EntityIterateComponentsByType( entity, component_type_name, callback )
  local matched_components = {};
  local components = EntityGetAllComponents( entity ) or {};
  for _,component in pairs(components) do
    if ComponentGetTypeName( component ) == component_type_name then
      table.insert( matched_components, component );
    end
  end
  if callback ~= nil then
    for _,component in pairs(matched_components) do
      callback( component );
    end
  end
  return matched_components;
end

function EntityGetHitboxCenter( entity )
  local tx, ty = EntityGetTransform( entity );
  local hitbox = EntityGetFirstComponent( entity, "HitboxComponent" );
  if hitbox ~= nil then
    local width = ComponentGetValue2( hitbox, "aabb_max_x" ) - ComponentGetValue2( hitbox, "aabb_min_x" );
    local height = ComponentGetValue2( hitbox, "aabb_max_y" ) - ComponentGetValue2( hitbox, "aabb_min_y" );
    tx = tx + ComponentGetValue2( hitbox, "aabb_min_x" ) + width * 0.5;
    ty = ty + ComponentGetValue2( hitbox, "aabb_min_y" ) + height * 0.5;
  end
  return tx, ty;
end

function EntityGetFirstHitboxSize( entity, fallbackWidth, fallbackHeight )
  local hitbox = EntityGetFirstComponent( entity, "HitboxComponent" );

  local width = fallbackWidth or 0;
  local height = fallbackHeight or 0;
  if hitbox ~= nil then
    width =  ComponentGetValue2( hitbox, "aabb_max_x" ) - ComponentGetValue2( hitbox, "aabb_min_x" );
    height =  ComponentGetValue2( hitbox, "aabb_max_y" ) - ComponentGetValue2( hitbox, "aabb_min_y" );
  end
  return width, height;
end

function EntitySetVelocity( entity, x, y )
  EntityIterateComponentsByType( entity, "VelocityComponent", function( component )
    ComponentSetValue2( component, "mVelocity", x, y );
  end );
end


function EaseAngle( angle, target_angle, easing )
  local dir = (angle - target_angle) / (math.pi*2);
  dir = dir - math.floor(dir + 0.5);
  dir = dir * (math.pi*2);
  return angle - dir * easing;
end

function WeightedRandom( items, weights, sum )
  if weights == nil  then
    weights = {};
    for k,v in pairs( items ) do
      weights[k] = 1;
    end
    sum = items.length;
  end
  if sum == nil then
    sum = 0;
    for k,v in pairs( weights ) do
      sum = sum + v;
    end
  end
  if sum <= 0 then
    return nil;
  end
  local random = Random() * sum;
  for k,v in pairs(items) do
    local weight = weights[k];
    if random <= weight then
      return items[k];
    end
    random = random - weight;
  end
end

function WeightedRandomTable( entries )
  local sum = 0;
  for k,v in pairs( entries ) do
    sum = sum + v;
  end
  if sum <= 0 then
    return nil;
  end
  local random = Random() * sum;
  for k,v in pairs( entries ) do
    if random <= v then
      return k;
    end
    random = random - v;
  end
end


function EntityHasScript( entity, filepath, script_type )
  if script_type == nil then
    script_type = "script_source_file";
  end
  for _,lua_component in pairs( EntityGetComponentIncludingDisabled(entity,"LuaComponent") or {}) do
    if ComponentGetValue2( lua_component, script_type ) == filepath then
      return true;
    end
  end
  return false;
end




-- HELPERS.LUA

function get_entity_first_or_random_wand( entity, or_random )
  if or_random == nil then or_random = true; end
  local base_wand = nil;
  local wands = {};
  local children = EntityGetAllChildren( entity );
  for key,child in pairs( children ) do
    if EntityGetName( child ) == "inventory_quick" then
      wands = EntityGetChildrenWithTag( child, "wand" );
      break;
    end
  end
  if #wands > 0 then
    local inventory2 = EntityGetFirstComponent( entity, "Inventory2Component" );
    local active_item = ComponentGetValue2( inventory2, "mActiveItem" );
    for _,wand in pairs( wands ) do
      if wand == active_item then
        base_wand = wand;
        break;
      end
    end
    if base_wand == nil and or_random then
      SetRandomSeed( EntityGetTransform( entity ) );
      base_wand =  Random( 1, #wands );
    end
  end
  return base_wand;
end

function thousands_separator(amount)
  local formatted = amount;
  while true do
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted;
end



-- WAND.LUA

local WAND_STAT_SETTER = {
    Direct = 1,
    Gun = 2,
    GunAction = 3
}

local WAND_STAT_SETTERS = {
    shuffle_deck_when_empty = WAND_STAT_SETTER.Gun,
    actions_per_round = WAND_STAT_SETTER.Gun,
    speed_multiplier = WAND_STAT_SETTER.GunAction,
    deck_capacity = WAND_STAT_SETTER.Gun,
    reload_time = WAND_STAT_SETTER.Gun,
    fire_rate_wait = WAND_STAT_SETTER.GunAction,
    spread_degrees = WAND_STAT_SETTER.GunAction,
    mana_charge_speed = WAND_STAT_SETTER.Direct,
    mana_max = WAND_STAT_SETTER.Direct,
    mana = WAND_STAT_SETTER.Direct,
}

function wand_clear_actions( wand )
    local actions = {};
    local children = EntityGetAllChildren( wand ) or {};
    for i,v in ipairs( children ) do
        local item = EntityGetFirstComponentIncludingDisabled( v, "ItemComponent" );
        local item_action = EntityGetFirstComponentIncludingDisabled( v, "ItemActionComponent" );
        if item and item_action then
            EntityRemoveFromParent( v );
            EntityKill( v );
        end
    end
    return actions;
end

function wand_get_actions( wand )
    local actions = {};
    local children = EntityGetAllChildren( wand ) or {};
    for i,v in ipairs( children ) do
        local item = EntityGetFirstComponentIncludingDisabled( v, "ItemComponent" );
        local item_action = EntityGetFirstComponentIncludingDisabled( v, "ItemActionComponent" );
        if item and item_action then
            local action_id = ComponentGetValue2( item_action, "action_id" );
            local permanent = ComponentGetValue2( item, "permanently_attached" );
            local locked = ComponentGetValue2( item, "is_frozen" );
            local x, y = ComponentGetValue2( item, "inventory_slot" );
            if action_id ~= nil then
                table.insert( actions, { action_id = action_id, permanent = permanent, locked = locked, x = x, y = y, entity = v, item = item } );
            end
        end
    end
    return actions;
end

-- TODO: Deduplicate
function wand_get_actions_absolute( wand )
    local actions = {};
    local children = EntityGetAllChildren( wand ) or {};
    for i,v in ipairs( children ) do
        local item = EntityGetFirstComponentIncludingDisabled( v, "ItemComponent" );
        local item_action = EntityGetFirstComponentIncludingDisabled( v, "ItemActionComponent" );
        if item and item_action then
            local action_id = ComponentGetValue2( item_action, "action_id" );
            local permanent = ComponentGetValue2( item, "permanently_attached" );
            local locked = ComponentGetValue2( item, "is_frozen" );
            local x, y = ComponentGetValue2( item, "inventory_slot" );
            if action_id ~= nil then
                actions[x] = { action_id = action_id, permanent = permanent, locked = locked, x = x, y = y, entity = v, item = item };
            end
        end
    end
    return actions;
end

function wand_set_actions( wand, actions_table )
    for _,action_id in pairs(actions_table) do
        AddGunAction( wand, action_id );
    end
end

function wand_shuffle_actions( wand )
    local actions = {};
    local actions_data = {};
    local children = EntityGetAllChildren( wand ) or {};
    for i,v in ipairs( children ) do
        local item = EntityGetFirstComponentIncludingDisabled( v, "ItemComponent" );
        local item_action = EntityGetFirstComponentIncludingDisabled( v, "ItemActionComponent" );
        if item and item_action then
            local action_id = ComponentGetValue2( item_action, "action_id" );
            local permanent = ComponentGetValue2( item, "permanently_attached" );
            local locked = ComponentGetValue2( item, "is_frozen" );
            local x, y = ComponentGetValue2( item, "inventory_slot" );
            if action_id ~= nil and permanent ~= true and locked ~= true then
                table.insert( actions, { action_entity = v, item = item } );
                table.insert( actions_data, { x = x, y = y } );
            end
        end
    end
    local wx, wy = EntityGetTransform( wand );
    SetRandomSeed( GameGetFrameNum(), wx + wy );
    local actions_data_shuffled = {};
    for i, v in ipairs(actions_data) do
        local pos = Random( 1, #actions_data_shuffled + 1 );
        table.insert( actions_data_shuffled, pos, v )
    end
    for i=1,#actions do
        local action = actions[i];
        local action_data = actions_data_shuffled[i];
        ComponentSetValue2( action.item, "inventory_slot", action_data.x, action_data.y );
    end
end

function wand_copy_actions( base_wand, copy_wand )
    local actions = wand_get_actions( base_wand );
    for index,action_data in pairs( actions ) do
        local action_entity = CreateItemActionEntity( action_data.action_id );
        local item = EntityGetFirstComponentIncludingDisabled( action_entity, "ItemComponent" );
        if action_data.permanent then
            ComponentSetValue2( item, "permanently_attached", true );
        end
        if ComponentSetValue2 and action_data.x ~= nil and action_data.y ~= nil then
            ComponentSetValue2( item, "inventory_slot", action_data.x, action_data.y );
        end
        EntitySetComponentsWithTagEnabled( action_entity, "enabled_in_world", false );
        EntityAddChild( copy_wand, action_entity );
    end
end

function wand_copy_stats( base_wand, copy_wand )
    local base_ability = EntityGetFirstComponentIncludingDisabled( base_wand, "AbilityComponent" );
    local target_ability = EntityGetFirstComponentIncludingDisabled( copy_wand, "AbilityComponent" );
    if base_ability and target_ability then
        for stat,stat_type in pairs( WAND_STAT_SETTERS ) do
            ability_component_set_stat( target_ability, stat, ability_component_get_stat( base_ability, stat ) );
        end
    end
end

function wand_copy( base_wand, copy_wand, copy_sprite, copy_actions )
    wand_copy_stats( base_wand, copy_wand );
    if copy_sprite ~= false then
        local base_ability = EntityGetFirstComponentIncludingDisabled( base_wand, "AbilityComponent" );
        local target_ability = EntityGetFirstComponentIncludingDisabled( copy_wand, "AbilityComponent" );
        ComponentSetValue2( target_ability, "sprite_file", ComponentGetValue2( base_ability, "sprite_file" ) );
        local base_sprite = EntityGetFirstComponentIncludingDisabled( base_wand, "SpriteComponent" )
        local copy_sprite = EntityGetFirstComponentIncludingDisabled( copy_wand, "SpriteComponent" )
        CopyListedComponentMembers( base_sprite, copy_sprite, "image_file","offset_x","offset_y");
        local base_hotspot = EntityGetFirstComponentIncludingDisabled( base_wand, "HotspotComponent", "shoot_pos" );
        local copy_hotspot = EntityGetFirstComponentIncludingDisabled( copy_wand, "HotspotComponent", "shoot_pos" );
        CopyComponentMembers( base_hotspot, copy_hotspot );
        local base_hotspot_x, base_hotspot_y = ComponentGetValue2( base_hotspot, "offset" );
        ComponentSetValue2( copy_hotspot, "offset", base_hotspot_x, base_hotspot_y );
    end
    if copy_actions ~= false then
        wand_copy_actions( base_wand, copy_wand );
    end
end

function ability_component_get_stat( ability, stat )
    local setter = WAND_STAT_SETTERS[stat];
    if setter ~= nil then
        if setter == WAND_STAT_SETTER.Direct then
            return ComponentGetValue2( ability, stat );
        elseif setter == WAND_STAT_SETTER.Gun then
            return ComponentObjectGetValue2( ability, "gun_config", stat );
        elseif setter == WAND_STAT_SETTER.GunAction then
            return ComponentObjectGetValue2( ability, "gunaction_config", stat );
        end
    end
end

function ability_component_set_stat( ability, stat, value )
    local setter = WAND_STAT_SETTERS[stat];
    if setter ~= nil then
        if setter == WAND_STAT_SETTER.Direct then
            ComponentSetValue2( ability, stat, value );
        elseif setter == WAND_STAT_SETTER.Gun then
            ComponentObjectSetValue2( ability, "gun_config", stat, value );
        elseif setter == WAND_STAT_SETTER.GunAction then
            ComponentObjectSetValue2( ability, "gunaction_config", stat, value );
        end
    end
end

function ability_component_adjust_stat( ability, stat, callback )
    local setter = WAND_STAT_SETTERS[stat];
    if setter ~= nil then
        local current_value = nil;
        if setter == WAND_STAT_SETTER.Direct then
            current_value = ComponentGetValue2( ability, stat );
        elseif setter == WAND_STAT_SETTER.Gun then
            current_value = ComponentObjectGetValue2( ability, "gun_config", stat );
        elseif setter == WAND_STAT_SETTER.GunAction then
            current_value = ComponentObjectGetValue2( ability, "gunaction_config", stat );
        end
        local new_value = callback( current_value );
        if setter == WAND_STAT_SETTER.Direct then
            ComponentSetValue2( ability, stat, new_value );
        elseif setter == WAND_STAT_SETTER.Gun then
            ComponentObjectSetValue2( ability, "gun_config", stat, new_value );
        elseif setter == WAND_STAT_SETTER.GunAction then
            ComponentObjectSetValue2( ability, "gunaction_config", stat, new_value );
        end
    end
end

function ability_component_get_stats( ability, stat )
    local stats = {};
    for k,v in pairs( WAND_STAT_SETTERS ) do
        stats[k] = ability_component_get_stat( ability, k );
    end
    return stats;
end

function ability_component_set_stats( ability, stat_value_table )
    for stat,value in pairs(stat_value_table) do
        ability_component_set_stat( ability, stat, value );
    end
end

function ability_component_adjust_stats( ability, stat_callback_table )
    for stat,callback in pairs(stat_callback_table) do
        ability_component_adjust_stat( ability, stat, callback );
    end
end

function initialize_wand( wand, wand_data )
    local ability = EntityGetFirstComponentIncludingDisabled( wand, "AbilityComponent" );
    local item = EntityGetFirstComponent( wand, "ItemComponent" );
    if wand_data.name ~= nil then
        ComponentSetValue2( ability, "ui_name", wand_data.name );
        if item ~= nil then
            ComponentSetValue2( item, "item_name", wand_data.name );
            ComponentSetValue2( item, "always_use_item_name_in_ui", true );
        end
    end

    for stat,value in pairs( wand_data.stats or {} ) do
        ability_component_set_stat( ability, stat, value );
    end

    for stat,range in pairs( wand_data.stat_ranges or {} ) do
        ability_component_set_stat( ability, stat, Random( range[1], range[2] ) );
    end

    for stat,random_values in pairs( wand_data.stat_randoms or {} ) do
        ability_component_set_stat( ability, stat, random_values[ Random( 1, #random_values ) ] );
    end

    ability_component_set_stat( ability, "mana", ability_component_get_stat( ability, "mana_max" ) );

    for _,actions in pairs( wand_data.permanent_actions or {} ) do
        local random_action = actions[ Random( 1, #actions ) ];
        if random_action ~= nil then
            AddGunActionPermanent( wand, random_action );
        end
    end

    --for _,actions in pairs( wand_data.actions or {} ) do
    if wand_data.actions then
        for action_index=1,#wand_data.actions,1 do
            local actions = wand_data.actions[action_index];
            if actions ~= nil then
                local random_action = actions[ Random( 1, #actions ) ];
                if random_action ~= nil then
                    if type( random_action ) == "table" then
                        local amount = random_action.amount or 1;
                        for _=1,amount,1 do
                            local action_entity = CreateItemActionEntity( random_action.action );
                            if action_entity then
                                local item = EntityGetFirstComponentIncludingDisabled( action_entity, "ItemComponent" );
                                if random_action.locked then
                                    ComponentSetValue2( item, "is_frozen", true );
                                end
                                if random_action.permanent then
                                    ComponentSetValue2( item, "permanently_attached", true );
                                end
                                ComponentSetValue2( item, "inventory_slot", action_index - 1, 0 );
                                EntitySetComponentsWithTagEnabled( action_entity, "enabled_in_world", false );
                                EntityAddChild( wand, action_entity );
                            end
                        end
                    else
                        local action_entity = CreateItemActionEntity( random_action );
                        if action_entity then
                            local item = EntityGetFirstComponentIncludingDisabled( action_entity, "ItemComponent" );
                            if item ~= nil then
                                ComponentSetValue2( item, "inventory_slot", action_index - 1, 0 );
                            end
                            EntitySetComponentsWithTagEnabled( action_entity, "enabled_in_world", false );
                            EntityAddChild( wand, action_entity );
                            --AddGunAction( wand, random_action );
                        end
                    end
                end
            end
        end
    end
    
    if wand_data.sprite ~= nil then
        if wand_data.sprite.file ~= nil then
            ComponentSetValue2( ability, "sprite_file", wand_data.sprite.file );
            -- TODO this takes a second to apply, probably worth fixing, but for now just prefer using custom file
            local sprite = EntityGetFirstComponent( wand, "SpriteComponent", "item" );
            if sprite ~= nil then
                ComponentSetValue2( sprite, "image_file", wand_data.sprite.file );
                EntityRefreshSprite( wand, sprite );
            end
        end
        if wand_data.sprite.hotspot ~= nil then
            local hotspot = EntityGetFirstComponent( wand, "HotspotComponent", "shoot_pos" );
            if hotspot ~= nil then
                ComponentSetValue2( hotspot, "offset", wand_data.sprite.hotspot.x, wand_data.sprite.hotspot.y );
            end
        end
    else
        local gun = {
            deck_capacity               = ability_component_get_stat( ability, "deck_capacity" ),
            actions_per_round           = ability_component_get_stat( ability, "actions_per_round" ),
            reload_time                 = ability_component_get_stat( ability, "reload_time" ),
            shuffle_deck_when_empty     = ability_component_get_stat( ability, "shuffle_deck_when_empty" ) and 1 or 0,
            fire_rate_wait              = ability_component_get_stat( ability, "fire_rate_wait" ),
            spread_degrees              = ability_component_get_stat( ability, "spread_degrees" ),
            speed_multiplier            = ability_component_get_stat( ability, "speed_multiplier" ),
            mana_charge_speed           = ability_component_get_stat( ability, "mana_charge_speed" ),
            mana_max                    = ability_component_get_stat( ability, "mana_max" ),
        };
        local dynamic_wand = GetWand( gun );
        SetWandSprite( wand, ability, dynamic_wand.file, dynamic_wand.grip_x, dynamic_wand.grip_y, ( dynamic_wand.tip_x - dynamic_wand.grip_x ), ( dynamic_wand.tip_y - dynamic_wand.grip_y ) );
        EntityRefreshSprite( wand, EntityGetFirstComponent( wand, "SpriteComponent", "item" ) );
    end

    if wand_data.callback ~= nil then
        wand_data.callback( wand, ability );
    end
end

function wand_serialize( wand )
    --[[
    local string = "";
    local ability = EntityGetFirstComponent( wand, "AbilityComponent" );
    if ability then
        for stat,setter in pairs( WAND_STAT_SETTERS ) do
            string = string..stat.."="..tostring(ability_component_get_stat( ability, stat ))..",";
        end
    end
    local action_string = "";
    for _,action_data in pairs( wand_get_actions_absolute( wand ) or {} ) do
        action_string = action_string .."{";
        for k,v in pairs( action_data ) do
            action_string = action_string..k.."="..tostring(v);
        end
        action_string = action_string .."},";
    end
    string = string.."actions="..action_string;
    return string;
    ]]
end

function wand_explode_random_action( wand, include_permanent_actions, include_frozen_actions, ox, oy )
    local x, y = EntityGetTransform( wand );
    local actions = {};
    local children = EntityGetAllChildren( wand ) or {};
    for i,action in ipairs( children ) do
        local item_action = EntityGetFirstComponentIncludingDisabled( action, "ItemActionComponent" );
        if item_action ~= nil then
            local item = EntityGetFirstComponentIncludingDisabled( action, "ItemComponent" );
            if item ~= nil then
                local action_id = ComponentGetValue2( item_action, "action_id" );
                if action_id ~= nil then
                    if include_permanent_actions == true or ComponentGetValue2( item, "permanently_attached" ) == false then
                        if include_frozen_actions == true or ComponentGetValue2( item, "is_frozen" ) == false then
                            table.insert( actions, { action_id=action_id, permanent=permanent, entity=action } );
                        end
                    end
                end
            end
        end
    end
    if #actions > 0 then
        local r = math.ceil( math.random() * #actions );
        local action_to_remove = actions[ r ];
        local card = CreateItemActionEntity( action_to_remove.action_id, ox or x, oy or y );
        ComponentSetValue2( EntityGetFirstComponent( card, "VelocityComponent" ), "mVelocity", Random( -150, 150 ), Random( -250, -100 ) );
        EntityRemoveFromParent( action_to_remove.entity );
        return action_to_remove;
    end
end

function wand_remove_first_action( wand, include_permanent_actions, include_frozen_actions )
    local x, y = EntityGetTransform( wand );
    local actions = {};
    local children = EntityGetAllChildren( wand ) or {};
    for _,action in pairs( children ) do
        local item_action = EntityGetFirstComponentIncludingDisabled( action, "ItemActionComponent" );
        if item_action ~= nil then
            local item = EntityGetFirstComponentIncludingDisabled( action, "ItemComponent" );
            if item ~= nil then
                if include_permanent_actions == true or ComponentGetValue2( item, "permanently_attached" ) == false then
                    if include_frozen_actions == true or ComponentGetValue2( item, "is_frozen" ) == false then
                        EntityRemoveFromParent( action );
                        EntitySetComponentsWithTagEnabled( action,  "enabled_in_world", true );
                        EntitySetComponentsWithTagEnabled( action,  "enabled_in_hand", false );
                        EntitySetComponentsWithTagEnabled( action,  "enabled_in_inventory", false );
                        EntitySetComponentsWithTagEnabled( action,  "item_unidentified", false );
                        EntitySetTransform( action, x, y );
                        return action;
                    end
                end
            end
        end
    end
end

function wand_lock( wand, lock_spells, lock_wand )
    if lock_spells == nil then lock_spells = true; end
    if lock_wand == nil then lock_wand = true; end
    if lock_spells then
        local children = EntityGetAllChildren( wand ) or {};
        for i,action in ipairs( children ) do
            local item = EntityGetFirstComponentIncludingDisabled( action, "ItemComponent" );
            if item ~= nil then
                ComponentSetValue2( item, "is_frozen", true );
            end
        end
    end
    if lock_wand then
        local item = EntityGetFirstComponentIncludingDisabled( wand, "ItemComponent" );
        if item ~= nil then
            ComponentSetValue2( item, "is_frozen", true );
        end
    end
end

function wand_attach_action( wand, action, permanent, locked )
    EntityAddChild( wand, action );
    local item_action = EntityGetFirstComponentIncludingDisabled( action, "ItemActionComponent" );
    if item_action ~= nil then
        EntitySetComponentsWithTagEnabled( action,  "enabled_in_world", false );
        EntitySetComponentsWithTagEnabled( action,  "enabled_in_hand", false );
        EntitySetComponentsWithTagEnabled( action,  "enabled_in_inventory", false );
    end
end

function wand_is_always_cast_valid( wand )
    local children = EntityGetAllChildren( wand ) or {};
    for i,v in ipairs( children ) do
        local items = EntityGetComponentIncludingDisabled( v, "ItemComponent" )
        local has_a_valid_spell = false;
        for _,item in pairs( items or {}) do
            if ComponentGetValue2( item, "permanently_attached" ) == false then
                has_a_valid_spell = true;
                break;
            end
        end
        if has_a_valid_spell then
            return true;
        end
    end
    return false;
end

function force_always_cast( wand, amount )
    if amount == nil then amount = 1 end
    local children = EntityGetAllChildren( wand ) or {};
    local always_cast_count = 0;
    for _,child in pairs( children ) do
        local item_component = EntityGetFirstComponentIncludingDisabled( child, "ItemComponent" );
        if item_component then
            if ComponentGetValue2( item_component, "permanently_attached" ) == true then
                always_cast_count = always_cast_count + 1;
                break;
            end
        end
    end
    while always_cast_count < amount do
        local random_child = children[ Random( 1,#children ) ];
        local item_component = EntityGetFirstComponentIncludingDisabled( random_child, "ItemComponent" );
        if item_component and ComponentGetValue2( item_component, "permanently_attached" ) ~= true then
            ComponentSetValue2( item_component, "permanently_attached", true );
            always_cast_count = always_cast_count + 1;
        end
    end
end



-- VARIABLES.LUA
--
function EntityClearVariable( entity, variable_tag, value )
    local variable = EntityGetFirstComponent( entity, "VariableStorageComponent", variable_tag );
    if variable ~= nil then
        EntityRemoveComponent( entity, variable );
    end
end

function EntityGetVariableString( entity, variable_tag, default )
    local variable = EntityGetFirstComponent( entity, "VariableStorageComponent", variable_tag );
    if variable ~= nil then
        return ComponentGetValue2( variable, "value_string" );
    end
    return default;
end

function EntitySetVariableString( entity, variable_tag, value )
    local current_variable = EntityGetFirstComponent( entity, "VariableStorageComponent", variable_tag );
    if current_variable == nil then
        EntityAddComponent( entity, "VariableStorageComponent", {
            _tags=variable_tag..",enabled_in_world,enabled_in_hand,enabled_in_inventory",
            value_string=tostring(value)
        } );
    else
        ComponentSetValue2( current_variable, "value_string", value );
    end
end

function EntityHasNamedVariable( entity, name )
    for k,component in pairs( EntityGetComponent( entity, "VariableStorageComponent" ) or {} ) do
        if ComponentGetValue2( component, "name") == name then
            return true;
        end
    end
    return false;
end

function EntityGetVariableNumber( entity, variable_tag, default )
    return tonumber( EntityGetVariableString( entity, variable_tag, default ) );
end

function EntitySetVariableNumber( entity, variable_tag, value )
    return EntitySetVariableString( entity, variable_tag, value );
end

function EntityAdjustVariableNumber( entity, variable_tag, default, callback )
    local new_value = callback( EntityGetVariableNumber( entity, variable_tag, default ) );
    EntitySetVariableNumber( entity, variable_tag, tostring( new_value ) );
    return new_value;
end

function ComponentAdjustValue( component, member, callback )
    local new_value = callback( ComponentGetValue2( component, member ) );
    ComponentSetValue2( component, member, new_value );
    return new_value;
end

function ComponentSetValues( component, member_value_table )
    for member,new_value in pairs(member_value_table) do
        ComponentSetValue2( component, member, new_value );
    end
end

function ComponentAdjustValues( component, member_callback_table )
    for member,callback in pairs( member_callback_table ) do
        ComponentSetValue2( component, member, callback( ComponentGetValue2( component, member ) ) );
    end
end

function ComponentObjectSetValues( component, object, member_value_table )
    for member,new_value in pairs(member_value_table) do
        ComponentObjectSetValue2( component, object, member, new_value );
    end
end

function ComponentObjectAdjustValues( component, object, member_callback_table )
    for member,callback in pairs(member_callback_table) do
        ComponentObjectSetValue2( component, object, member, callback( ComponentObjectGetValue2( component, object, member ) ) );
    end
end

function ComponentSetValues( component, member_value_table )
    for member,new_value in pairs(member_value_table) do
        ComponentSetValue2( component, member, new_value );
    end
end

function ComponentAdjustMetaCustoms( component, member_callback_table )
    for member,callback in pairs(member_callback_table) do
        local current_value = ComponentGetValue2( component, member );
        local new_value = callback( current_value );
        ComponentSetValue2( component, member, new_value );
    end
end
