dofile("data/scripts/lib/utilities.lua")

dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/scripts/enums.lua")

-- Wolverine
-- Lynx
-- Rabbit
-- Bear
-- Fox
-- Stoat
-- Bat
-- "European" Badger (kärppä)
-- Arctic Fox (naali)
-- Ringed Seal (norppa)
-- Hedgehog
-- Raccoon
function path(name)
  return "mods/raksa/files/gfx/power_icons/waypoints/"..name..".png"
end

function key(name)
  return "RAKSA_WAYPOINT_"..name
end


local NOT_FOUND = "not_found"
SetRandomSeed(GameGetFrameNum(), GameGetFrameNum())

local MNENOMIC_DEVICES = {
 -- { name="ahma", image=""},
 -- { name="hiiri", image=""},
 -- { name="ilves", image=""},
 -- { name="jänis", image=""},
 -- { name="karhu", image=""},
 -- { name="kettu", image=""},
 -- { name="kissa", image=""},
 -- { name="koira", image=""},
 -- { name="kärppä", image=""},
 -- { name="lepakko", image=""},
 -- { name="mäyrä", image=""},
 -- { name="naali", image=""},
 -- { name="norppa", image=""},
 -- { name="orava", image=""},
  { name="Peura", image=path("peura")},
  { name="Hirvi", image=path("hirvi")},
  { name="Rotta", image=path("rotta")},
 -- { name="rusakko", image=""},
 -- { name="siili", image=""},
 -- { name="sopuli", image=""},
 -- { name="supi", image=""},
  { name="Susi", image=path("susi")},
}

LOCATION_MEMORY = {
  -- Automatically populated format:
  -- { name="kettu", image="kettu.png", x=123, y=456 }
}


--
-- Automatic re-population when continuing a saved game
--
function init_location_memory_from_globals()
  function parse_coordinates(value)
    local x, y = value:match("([^,]+);([^,]+)")
    return tonumber(x), tonumber(y)
  end

  for i, animal in ipairs(MNENOMIC_DEVICES) do

    local key = key(animal.name)
    local value = GlobalsGetValue(key, NOT_FOUND)

    if value ~= NOT_FOUND then
      local x, y = parse_coordinates(value)
      table.insert(LOCATION_MEMORY, {
        name=animal.name,
        image=animal.image,
        x=x,
        y=y,
      })
    end
  end
end

print("Populating waypoints...")
init_location_memory_from_globals()
print("Done!")


--
-- Manual handling in-game
--
function check_duplicate(name)
  for i, animal in ipairs(LOCATION_MEMORY) do
    if name == animal.name then
      return true
    end
  end
  return false
end


function get_random_animal()
  if #LOCATION_MEMORY == #MNENOMIC_DEVICES then
    -- All animals exhausted. One shouldn't need this many waypoints?!
    return nil
  end

  local new_animal = nil
  local is_duplicate = false

  repeat
    new_animal = random_from_array(MNENOMIC_DEVICES)
    is_duplicate = check_duplicate(new_animal.name)
  until(not is_duplicate)

  return new_animal
end


function set_waypoint(x, y)
  local animal = get_random_animal()

  if not animal then
    GamePrint("Too many animal-coordinate combinations in your mind. Have to forget some first...")
    return
  end

  -- Add to table for immediate use
  table.insert(LOCATION_MEMORY, {
    name=animal.name,
    image=animal.image,
    x=x,
    y=y,
  })

  -- Add to globals for reloading upon restart
  GlobalsSetValue(
    key(animal.name),
    x..";"..y
  )

  GamePrint("This location makes you think of a "..animal.name)
end


function remove_waypoint(animal, index)
  table.remove(LOCATION_MEMORY, index)
  GlobalsSetValue(key(animal.name), NOT_FOUND)
end
