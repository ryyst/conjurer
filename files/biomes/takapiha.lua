dofile_once("mods/raksa/files/scripts/utilities.lua")

RegisterSpawnFunction( 0xff0000ff, "spawn_eel" )
RegisterSpawnFunction( 0xffB40001, "spawn_random_book" )
RegisterSpawnFunction( 0xffB40002, "spawn_sammon_taistelu" )
RegisterSpawnFunction( 0xffB40003, "DEBUG_spawn_all_books" )


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

function book(name)
  return "mods/raksa/files/secrets/books/"..name..".xml"
end

function spawn_sammon_taistelu(x, y)
  EntityLoad(book("kalevala3"), x, y)
end

function spawn_random_book(x, y)
  SetRandomSeed(x, y)
  local roll = Random(1, #BOOKS+1)
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
function spawn_eel(x, y)EntityLoad("data/entities/animals/eel.xml", x, y) end
