dofile_once("data/scripts/lib/utilities.lua")

dofile_once("mods/raksa/files/wands/entwand/helpers.lua");

dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/scripts/enums.lua")


function spawn_entity(x, y)
  EntityLoad(get_active_entity(), x, y)
end


function delete_entity(x, y)
  local radius = 50
  -- tags: sheep, rat, prop,
  -- mortal, if not IsPlayer()
  local entities = EntityGetInRadiusWithTag(x, y, radius, "enemy")
  local props = EntityGetInRadiusWithTag(x, y, radius, "prop")

  -- Or delete any entity that is not the player, or world? Ie. blacklist instead of tag whitelist
  GamePrint("Trying kill??")
  if entities then
    local root = EntityGetRootEntity(entities[1])
    debug_entity(root)
    --EntityKill(entities[1])
    EntityKill(root)

  end
  GamePrint("Entity should be deleted here")
end


local x, y = DEBUG_GetMouseWorld()


if has_clicked_m1() then
  spawn_entity(x, y)
end


if has_clicked_m2() then
  delete_entity(x, y)
end
