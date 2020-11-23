dofile_once("data/scripts/lib/utilities.lua")

dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/scripts/enums.lua")


function spawn_entity(material)
  GamePrint("Entity should be created here")
end


function delete_entity(x, y)
  GamePrint("Entity should be deleted here")
end


local x, y = DEBUG_GetMouseWorld()


if is_holding_m1() then
  spawn_entity(material)
end


if is_holding_m2() then
  delete_entity(x, y)
end
