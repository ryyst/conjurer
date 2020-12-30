dofile_once("data/scripts/lib/utilities.lua")

dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/wands/entwand/helpers.lua")


function enabled_changed(entity, is_enabled)
  if is_enabled then
    local x, y = DEBUG_GetMouseWorld()
    get_or_create_reticle(x, y)
    --EntityLoad("mods/raksa/files/wands/entwand/spawner_reticle.xml", x, y)

    change_spawner_reticle()
    return
  end

  local reticle = EntityGetWithName(RETICLE_NAME)
  if reticle then EntityKill(reticle) end
end
