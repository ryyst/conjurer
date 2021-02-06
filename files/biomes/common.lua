dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/wands/entwand/helpers.lua");
dofile_once("data/scripts/perks/perk.lua")

RegisterSpawnFunction( 0xffB40001, "spawn_random_book" )
RegisterSpawnFunction( 0xffB40002, "spawn_sammon_taistelu" )
RegisterSpawnFunction( 0xffB40003, "DEBUG_spawn_all_books" )
RegisterSpawnFunction( 0xffB40004, "spawn_travel_manual" )

RegisterSpawnFunction( 0xffb075ee, "spawn_eel" )
RegisterSpawnFunction( 0xffb075ed, "spawn_drummer" )
RegisterSpawnFunction( 0xffff00dd, "spawn_potion_food" )
RegisterSpawnFunction( 0xff051051, "spawn_hatch" )
RegisterSpawnFunction( 0xff051052, "spawn_door" )
RegisterSpawnFunction( 0xffcc0570, "spawn_switch" )
RegisterSpawnFunction( 0xffcc0571, "spawn_generator" )
RegisterSpawnFunction( 0xff2c0f4b, "spawn_eye_perk" )

RegisterSpawnFunction( 0xffbeed00, "spawn_bed" )
RegisterSpawnFunction( 0xffbeed01, "spawn_wardrobe" )
RegisterSpawnFunction( 0xffbeed02, "spawn_divan" )
RegisterSpawnFunction( 0xffbeed03, "spawn_castletable" )
RegisterSpawnFunction( 0xffbeed04, "spawn_castlechair" )
RegisterSpawnFunction( 0xffbeed05, "spawn_rockingchair" )
RegisterSpawnFunction( 0xffbeed06, "spawn_chandelier" )
RegisterSpawnFunction( 0xffbeed07, "spawn_stool" )
RegisterSpawnFunction( 0xffbeed08, "spawn_bone" )
RegisterSpawnFunction( 0xffbeed09, "spawn_skull" )
RegisterSpawnFunction( 0xffbeed10, "spawn_skull2" )


-- Apply the same global post-processors to biome entities as we do to
-- the ones that we can spawn ourselves. Makes props deletable normally.
function EntityLoadProcessed(path, x, y)
  local entity = EntityLoad(path, x, y)
  for _, func in ipairs(ENTITY_POST_PROCESSORS) do
    func(entity, x, y)
  end
end


--
-- Book related things.
--
local BOOKS = {
  "kalevala",
  "kalevala2",
  -- "kalevala3",  -- Always spawned
  "poem",
  "pohjantahti",
  "abckiria",
  "muumi",
  "muumi2",
  "note",
  "note2",
  "note3",
}

function centity(name)
  return "mods/raksa/files/custom_entities/"..name..".xml"
end
function book(name)
  return "mods/raksa/files/secrets/books/"..name..".xml"
end

function spawn_travel_manual(x, y)
  EntityLoadProcessed(book("manual"), x, y)
end

function spawn_sammon_taistelu(x, y)
  EntityLoadProcessed(book("kalevala3"), x, y)
end

function spawn_random_book(x, y)
  SetRandomSeed(x, y)
  local roll = Random(1, #BOOKS)
  local random_book = book(BOOKS[roll])

  EntityLoadProcessed(random_book, x, y)
end

function DEBUG_spawn_all_books(x, y)
  for i, name in ipairs(BOOKS) do
    EntityLoadProcessed(book(name), x, y)
    x = x + 10
  end
  spawn_sammon_taistelu(x, y)
end


--
-- Everything else.
--
function spawn_eel(x, y) EntityLoadProcessed("data/entities/animals/eel.xml", x, y) end
function spawn_drummer(x, y)
  if ModIsEnabled("new_enemies") then
    EntityLoadProcessed("data/entities/buildings/ritualist_c.xml", x, y)
  end
end

function spawn_potion_food(x, y) EntityLoadProcessed(centity("potion_food/potion"), x, y-3) end
function spawn_hatch(x, y) EntityLoadProcessed(centity("hatch/hatch"), x, y-2) end
function spawn_door(x, y) EntityLoadProcessed(centity("door/door"), x, y) end
function spawn_switch(x, y) EntityLoadProcessed(centity("generator/switch"), x, y) end
function spawn_generator(x, y) EntityLoadProcessed(centity("generator/generator"), x, y) end
function spawn_lamp(x, y)
  -- TODO: For some reason lantern spawning is broken again.
  -- EntityLoad("data/entities/props/physics/lantern_small.xml", x, y)
end
function spawn_eye_perk(x, y) perk_spawn(x+3, y, "REMOVE_FOG_OF_WAR") end

function spawn_bed(x, y) EntityLoadProcessed("data/entities/props/furniture_bed.xml", x, y) end
function spawn_wardrobe(x, y) EntityLoadProcessed("data/entities/props/furniture_wardrobe.xml", x, y) end
function spawn_divan(x, y) EntityLoadProcessed("data/entities/props/furniture_castle_divan.xml", x, y) end
function spawn_castletable(x, y) EntityLoadProcessed("data/entities/props/furniture_castle_table.xml", x, y) end
function spawn_castlechair(x, y) EntityLoadProcessed("data/entities/props/furniture_castle_chair.xml", x, y) end
function spawn_rockingchair(x, y) EntityLoadProcessed("data/entities/props/furniture_rocking_chair.xml", x, y) end
function spawn_chandelier(x, y) EntityLoadProcessed("data/entities/props/physics_chandelier.xml", x, y) end
function spawn_stool(x, y) EntityLoadProcessed("data/entities/props/furniture_stool.xml", x, y) end

function spawn_bone(x, y) EntityLoadProcessed("data/entities/props/physics_bone_01.xml", x, y) end
function spawn_skull(x, y) EntityLoadProcessed("data/entities/props/physics_skull_01.xml", x, y) end
function spawn_skull2(x, y) EntityLoadProcessed("data/entities/props/physics_skull_02.xml", x, y) end

-- Expected by some base game pixel scenes / caves / something. Spawn nothing.
function spawn_small_enemies(x, y) end
function spawn_items(x, y) end
