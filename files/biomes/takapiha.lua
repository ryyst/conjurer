dofile_once("mods/raksa/files/scripts/utilities.lua")

RegisterSpawnFunction( 0xffB40001, "spawn_random_book" )
RegisterSpawnFunction( 0xffB40002, "spawn_sammon_taistelu" )
RegisterSpawnFunction( 0xffB40003, "DEBUG_spawn_all_books" )

RegisterSpawnFunction( 0xff0000ff, "spawn_eel" )
RegisterSpawnFunction( 0xffff00dd, "spawn_potion_food" )
RegisterSpawnFunction( 0xff051051, "spawn_hatch" )
RegisterSpawnFunction( 0xff051052, "spawn_door" )
RegisterSpawnFunction( 0xffcc0570, "spawn_switch" )
RegisterSpawnFunction( 0xffcc0571, "spawn_generator" )


RegisterSpawnFunction( 0xffbeed00, "spawn_bed" )
RegisterSpawnFunction( 0xffbeed01, "spawn_wardrobe" )
RegisterSpawnFunction( 0xffbeed02, "spawn_divan" )
RegisterSpawnFunction( 0xffbeed03, "spawn_castletable" )
RegisterSpawnFunction( 0xffbeed04, "spawn_castlechair" )
RegisterSpawnFunction( 0xffbeed05, "spawn_rockingchair" )
RegisterSpawnFunction( 0xffbeed06, "spawn_chandelier" )
RegisterSpawnFunction( 0xffbeed07, "spawn_stool" )


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

function spawn_sammon_taistelu(x, y)
  EntityLoad(book("kalevala3"), x, y)
end

function spawn_random_book(x, y)
  SetRandomSeed(x, y)
  local roll = Random(1, #BOOKS)
  local random_book = book(BOOKS[roll])

  EntityLoad(random_book, x, y)
end

function DEBUG_spawn_all_books(x, y)
  for i, name in ipairs(BOOKS) do
    EntityLoad(book(name), x, y)
    x = x + 10
  end
  spawn_sammon_taistelu(x, y)
end


--
-- Everything else.
--
function spawn_eel(x, y) EntityLoad("data/entities/animals/eel.xml", x, y) end
function spawn_potion_food(x, y) EntityLoad(centity("potion_food/potion"), x, y-3) end
function spawn_hatch(x, y) EntityLoad(centity("hatch/hatch"), x, y-2) end
function spawn_door(x, y) EntityLoad(centity("door/door"), x, y) end
function spawn_switch(x, y) EntityLoad(centity("generator/switch"), x, y) end
function spawn_generator(x, y) EntityLoad(centity("generator/generator"), x, y) end
function spawn_lamp(x, y)
  -- For some reason lantern spawning is broken again. TODO
  -- EntityLoad("data/entities/props/physics/lantern_small.xml", x, y)
end

function spawn_bed(x, y) EntityLoad("data/entities/props/furniture_bed.xml", x, y) end
function spawn_wardrobe(x, y) EntityLoad("data/entities/props/furniture_wardrobe.xml", x, y) end
function spawn_divan(x, y) EntityLoad("data/entities/props/furniture_castle_divan.xml", x, y) end
function spawn_castletable(x, y) EntityLoad("data/entities/props/furniture_castle_table.xml", x, y) end
function spawn_castlechair(x, y) EntityLoad("data/entities/props/furniture_castle_chair.xml", x, y) end
function spawn_rockingchair(x, y) EntityLoad("data/entities/props/furniture_rocking_chair.xml", x, y) end
function spawn_chandelier(x, y) EntityLoad("data/entities/props/physics_chandelier.xml", x, y) end
function spawn_stool(x, y) EntityLoad("data/entities/props/furniture_stool.xml", x, y) end

-- bed
-- couch & other furniture for lounge
