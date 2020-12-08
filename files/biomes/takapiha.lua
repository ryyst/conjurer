RegisterSpawnFunction( 0xff0000ff, "spawn_eel" )
RegisterSpawnFunction( 0xffB40001, "spawn_book1" )
RegisterSpawnFunction( 0xffB40002, "spawn_book2" )
RegisterSpawnFunction( 0xffB40003, "spawn_book3" )
RegisterSpawnFunction( 0xffB40004, "spawn_book4" )


function book(name)
  return "mods/raksa/files/secrets/books/"..name..".xml"
end

function spawn_eel(x, y) EntityLoad("data/entities/animals/eel.xml", x, y) end


function spawn_book1(x, y) EntityLoad(book("kalevala"), x, y) end
function spawn_book2(x, y) EntityLoad(book("pohjantahti"), x, y) end
function spawn_book3(x, y) EntityLoad(book("abckiria"), x, y) end
function spawn_book4(x, y) EntityLoad(book("poem01"), x, y) end
