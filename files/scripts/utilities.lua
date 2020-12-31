dofile_once("data/scripts/lib/utilities.lua")

dofile_once("mods/raksa/files/scripts/enums.lua")


-- Include this file with:
-- dofile_once("mods/raksa/files/scripts/utilities.lua")

MOD_PATH = "mods/raksa/files/"
ICON_UNKNOWN = "mods/raksa/files/gfx/icon_unknown.png"

M1_CLICKED = false

local BUTTON_SETTING = ModSettingGet("raksa.secondary_button")
local BUTTON_CHOICES = {
  throw={hold="mButtonDownThrow", click="mButtonFrameThrow"},
  mouse2={hold="mButtonDownRightClick", click="mButtonFrameRightClick"}
}

local SELECTED_BUTTON = BUTTON_CHOICES[BUTTON_SETTING]

---------------------------
-- General utilities
--
function round(num)
    if num >= 0 then return math.floor(num+.5)
    else return math.ceil(num-.5) end
end


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
    SELECTED_BUTTON.hold
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
    get_player(), "ControlsComponent", SELECTED_BUTTON.click
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


function bool_to_global(value)
  if value then
    return "1"
  end
  return "0"
end


function toggle_global(value)
  if value == "0" or value == false then
    return "1"
  end
  return "0"
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


-- Shorthands for a really common actions
function EntityGetValue(entity, component_name, attr_name)
  if entity == nil or entity == 0 then return nil end

  return ComponentGetValue2(
    EntityGetFirstComponentIncludingDisabled(entity, component_name), attr_name
  )
end

function EntitySetValue(entity, component_name, attr_name, value)
  if entity == nil or entity == 0 then return end

  return ComponentSetValue2(
    EntityGetFirstComponentIncludingDisabled(entity, component_name), attr_name, value
  )
end

function EntitySetValues(entity, component_name, values)
  if entity == nil or entity == 0 then return end

  local comp = EntityGetFirstComponentIncludingDisabled(entity, component_name)
  ComponentSetValues(comp, values)
end

function EntityToggleValue(entity, component_name, attr_name)
  if entity == nil or entity == 0 then return end

  local value = EntityGetValue(entity, component_name, attr_name)
  EntitySetValue(entity, component_name, attr_name, not value)
end

function ComponentSetValues(component, values)
  for key, value in pairs(values) do
    ComponentSetValue2(component, key, value)
  end
end

function GlobalsGet(key)
  return GlobalsGetValue(key, tostring(DEFAULTS[key]))
end

function GlobalsToggleBool(key)
  GlobalsSetValue(key, toggle_global(GlobalsGetBool(key)))
end

function GlobalsGetBool(key)
  return GlobalsGet(key) == "1"
end

function GlobalsGetNumber(key)
  return tonumber(GlobalsGet(key))
end


function teleport_player(x, y)
  local player = get_player()
  if not player then
    return
  end

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
      if type(k) ~= 'number' then
        k = '["'..k..'"] = '
      else
        k = ""
      end
      s = s .. k .. str(v) .. ','
    end
    return s .. '} '
  end
  if type(var) == 'string' then
    return tostring('"' .. var .. '"')
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
