dofile_once("mods/raksa/files/scripts/lists/animals.lua")
dofile_once("mods/raksa/files/scripts/lists/props.lua")
dofile_once("mods/raksa/files/scripts/lists/pickups.lua")

dofile_once("mods/raksa/files/scripts/enums.lua")

------------------------------
-- Matwand-specific helpers --
------------------------------
ENTITY_TYPES = {"Animals", "Props", "Pickups"}
ALL_ENTITIES = {Animals=ANIMALS, Props=PROPS, Pickups=PICKUPS};

ICON_DELETE_ENTITY = "mods/raksa/files/gfx/entwand_icons/icon_delete_entity.png"

ENTITY_TYPE_ICONS = {
  Animals="mods/raksa/files/gfx/entwand_icons/icon_animals.png",
  Props="mods/raksa/files/gfx/entwand_icons/icon_props.png",
  Pickups="mods/raksa/files/gfx/entwand_icons/icon_pickups.png",
}

ENTITY_TYPE_ICONS_OFF = {
  Animals="mods/raksa/files/gfx/entwand_icons/icon_animals_off.png",
  Props="mods/raksa/files/gfx/entwand_icons/icon_props_off.png",
  Pickups="mods/raksa/files/gfx/entwand_icons/icon_pickups_off.png",
}

function get_entity_type_icon(category, enabled)
  local icon_table = enabled and ENTITY_TYPE_ICONS or ENTITY_TYPE_ICONS_OFF
  return icon_table[category]
end

function change_active_entity(index, etype)
  GlobalsSetValue(SELECTED_ENTITY_INDEX, tostring(index))
  GlobalsSetValue(SELECTED_ENTITY_TYPE, tostring(etype))
end


function get_active_entity()
  local index = tonumber(GlobalsGetValue(SELECTED_ENTITY_INDEX, SELECTED_ENTITY_INDEX_DEFAULT))
  local etype = GlobalsGetValue(SELECTED_ENTITY_TYPE, SELECTED_ENTITY_TYPE_DEFAULT)

  local entity = ALL_ENTITIES[etype][index]
  return entity
end
