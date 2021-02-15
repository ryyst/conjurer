dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/raksa/files/scripts/utilities.lua")


-- Do not leave the cursor hanging when changing wands
function enabled_changed(entity, is_enabled)
  if not is_enabled then
    local cursor = EntityGetWithName("editwand_cursor")
    EntityKill(cursor)

    local indicator = EntityGetWithName("editwand_indicator")
    EntityKill(indicator)
  else
    -- Or enable it! Hah!
    -- TODO: Rename this file etc.
    local selected_entity = GlobalsGetNumber(ENTITY_TO_INSPECT)
    if selected_entity and EntityGetIsAlive(selected_entity) then
      local x, y = EntityGetTransform(selected_entity)

      local indicator = EntityLoad("mods/raksa/files/wands/editwand/selected_indicator.xml", x-1000, y-1000)
      EntityAddChild(selected_entity, indicator)
    end

  end
end
