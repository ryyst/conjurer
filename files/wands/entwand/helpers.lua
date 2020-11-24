dofile_once("mods/raksa/files/scripts/lists/animals.lua")
dofile_once("mods/raksa/files/scripts/lists/props.lua")
dofile_once("mods/raksa/files/scripts/lists/pickups.lua")

dofile_once("mods/raksa/files/scripts/enums.lua")

------------------------------
-- Matwand-specific helpers --
------------------------------
ENTITY_TYPES = {"Enemies", "Props", "Pickups"}
ALL_ENTITIES = {Enemies=ANIMALS, Props=PROPS, Pickups=PICKUPS};


function change_active_entity(index, etype)
  GlobalsSetValue(SELECTED_ENTITY_INDEX, tostring(index))
  GlobalsSetValue(SELECTED_ENTITY_TYPE, tostring(etype))
  print("setting:")
  print(str(index))
  print(str(etype))
end


function get_active_entity()
  local index = tonumber(GlobalsGetValue(SELECTED_ENTITY_INDEX, SELECTED_ENTITY_INDEX_DEFAULT))
  local etype = GlobalsGetValue(SELECTED_ENTITY_TYPE, SELECTED_ENTITY_TYPE_DEFAULT)

  local entity = ALL_ENTITIES[etype][index]
  return entity.path
end
