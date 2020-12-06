dofile_once("data/scripts/lib/utilities.lua")

-- Include this file with:
-- dofile_once("mods/raksa/files/scripts/utilities.lua")

MOD_PATH = "mods/raksa/files/"

ICON_UNKNOWN = "mods/raksa/files/gfx/icon_unknown.png"

---------------------------
-- General utilities
--
function get_player()
  local players = get_players()
  if players ~= nil then
    return players[1]
  end

  -- Player is dead
  return nil
end

function is_holding_m1()
  local player = get_player()
  if not player then return false end

  return ComponentGetValue2(
    EntityGetFirstComponentIncludingDisabled(player, "ControlsComponent"),
    "mButtonDownFire"
  )
end

function is_holding_m2()
  local player = get_player()
  if not player then return false end

  return ComponentGetValue2(
    EntityGetFirstComponentIncludingDisabled(player, "ControlsComponent"),
    "mButtonDownRightClick"
  )
end


function has_clicked_m1()
  local click_frame = EntityGetValue(
    get_player(), "ControlsComponent", "mButtonFrameFire"
  )
  return click_frame == GameGetFrameNum()
end


function has_clicked_m2()
  local click_frame = EntityGetValue(
    get_player(), "ControlsComponent", "mButtonFrameRightClick"
  )
  return click_frame == GameGetFrameNum()
end


function get_frames_in_air(player)
  return EntityGetValue(
    player or get_player(),
    "CharacterPlatformingComponent",
    "mFramesInAirCounter"
  )
end


function get_active_wand()
  local player = get_player()
  if not player then return nil end

  return EntityGetValue(player, "Inventory2Component", "mActiveItem")
end


function set_time_of_day(time)
  local entity = GameGetWorldStateEntity()
  edit_component(entity, "WorldStateComponent", function(comp,vars)
    vars.time = time
  end)
end


function set_weather()
  local worldState = EntityGetFirstComponentIncludingDisabled(
    GameGetWorldStateEntity(), "WorldStateComponent"
  )
  ComponentSetValue2(worldState, "intro_weather", true)
end


function entity_set_genome(entity, herd)
  local genomeComp = EntityGetFirstComponentIncludingDisabled(entity, "GenomeDataComponent")
  local herd_id = StringToHerdId(herd)

  ComponentSetValue2(genomeComp, "herd_id", herd_id)
end


local PI = math.pi
unitCircle = {
  ["topleft"] = 5*PI / 6,
  ["botleft"] = 9*PI / 8, -- 7*PI / 6
  ["topright"] = PI / 4,
  ["botright"] = 15*PI / 8, -- 11*PI / 6
  ["top"] = PI / 2,
  ["bot"] = 3*PI / 2,
}



function UniqueRandom()
  -- Return a generator for fetching multiple unique random numbers from a list.
  local used = {}
  local function generator(...)
    local num = Random(...)
    if used[num] then
      return generator(...)
    else
      used[num] = true
      return num
    end
  end
  return generator
end


-- Shorthands for a really common action
function EntityGetValue(entity, component_name, attr_name)
  return ComponentGetValue2(
    EntityGetFirstComponentIncludingDisabled(entity, component_name), attr_name
  )
end

function EntitySetValue(entity, component_name, attr_name, value)
  return ComponentSetValue2(
    EntityGetFirstComponentIncludingDisabled(entity, component_name), attr_name, value
  )
end

function EntitySetValues(entity, component_name, values)
  local comp = EntityGetFirstComponentIncludingDisabled(entity, component_name)
  ComponentSetValues(comp, values)
end

function ComponentSetValues(component, values)
  for key, value in pairs(values) do
    ComponentSetValue2(component, key, value)
  end
end

function teleport_player(x, y)
  -- Spawn on top of player
  local player = get_player()
  if not player then return end

  EntitySetTransform(player, x, y)
end


---------------------------
-- PERKS
function has_perk(perk_id)
  return GameHasFlagRun("PERK_PICKED_" .. perk_id)
end


function enable_perks(player, perks)
  local x, y = EntityGetTransform(player)
  for _,name in ipairs(perks) do
    local perk = perk_spawn(x, y, name)
    if ( perk ~= nil ) then
      perk_pickup(perk, player, EntityGetName(perk), false, false)
    end
  end
end


function enable_perks_without_icons(player, perks)
  enable_perks(player, perks)

  local children = EntityGetAllChildren(player)
  for _, child in ipairs(children) do
    local icons = EntityGetComponentIncludingDisabled(child, "UIIconComponent")
    if icons then
      EntityRemoveFromParent(child)
      EntityKill(child)
    end
  end
end


---------------------------
-- ITEMS
function item_in_inventory(item)
  local full_items = EntityGetAllChildren(EntityGetWithName("inventory_full"))
  local quick_items = EntityGetAllChildren(EntityGetWithName("inventory_quick"))

  if (full_items and #full_items > 0) then
    for _, i in ipairs(full_items) do
      if i == item then return true end
    end
  end

  if (quick_items and #quick_items > 0) then
    for _, i in ipairs(quick_items) do
      if i == item then return true end
    end
  end

  return false
end


function clear_player_inventory(player, inventory)
  local items = EntityGetAllChildren(inventory)
  if (items == nil) then return end

  for _, item in ipairs(items) do
    GameKillInventoryItem(player, item)
  end
end


function give_player_items(inventory, items)
  for _, path in ipairs(items) do
    local item = EntityLoad(path)
    if item then
      EntityAddChild(inventory, item)
    else
      GamePrint("Couldn't load the item ["..path.."], something's terribly wrong!")
    end
  end
end


---------------------------
-- Debugging utils

-- Missing Python?
function float(var)
  return tonumber(var)
end


function debug_component(comp)
  print("--- COMPONENT DATA ---")
  print(str(ComponentGetMembers(comp)))
  print("--- END COMPONENT DATA ---")
end


function str(var)
  if type(var) == 'table' then
    local s = '{ '
    for k,v in pairs(var) do
      if type(k) ~= 'number' then k = '"'..k..'"' end
      s = s .. '['..k..'] = ' .. str(v) .. ','
    end
    return s .. '} '
  end
  return tostring(var)
end


function debug_entity(e)
    local parent = EntityGetParent(e)
    local children = EntityGetAllChildren(e)
    local comps = EntityGetAllComponents(e)

    print("--- ENTITY DATA ---")
    print("Parent: ["..parent.."] " .. (EntityGetName(parent) or "nil"))

    print(" Entity: ["..str(e).."] " .. (EntityGetName(e) or "nil"))
    print("  Tags: " .. (EntityGetTags(e) or "nil"))
    if (comps ~= nil) then
      for _, comp in ipairs(comps) do
          print("  Comp: ["..comp.."] " .. (ComponentGetTypeName(comp) or "nil"))
      end
    end

    if children == nil then return end

    for _, child in ipairs(children) do
        local comps = EntityGetAllComponents(child)
        print("  Child: ["..child.."] " .. EntityGetName(child))
        for _, comp in ipairs(comps) do
            print("   Comp: ["..comp.."] " .. (ComponentGetTypeName(comp) or "nil"))
        end
    end
    print("--- END ENTITY DATA ---")
end


function Print(...)
  GamePrint(str(...))
end
