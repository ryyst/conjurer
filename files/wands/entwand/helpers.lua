dofile_once("mods/raksa/files/wands/entwand/processors.lua")
dofile_once("mods/raksa/files/scripts/lists/entity_categories.lua");
dofile_once("mods/raksa/files/scripts/enums.lua")

------------------------------
-- Entwand-specific helpers --
------------------------------

ICON_DELETE_ENTITY = "mods/raksa/files/gfx/entwand_icons/icon_delete_entity.png"

ENTITY_POST_PROCESSORS = {
  disable_new_physicsbody_optimizations,
  remove_spawn_limits_set_by_camerabound,
  add_friendly_fire_corrector,
}


function change_active_entity(entity_index, category_index)
  GlobalsSetValue(SELECTED_ENTITY_INDEX, tostring(entity_index))
  GlobalsSetValue(SELECTED_ENTITY_TYPE, tostring(category_index))
end


function get_active_entity()
  local category_index = tonumber(GlobalsGetValue(
    SELECTED_ENTITY_TYPE, SELECTED_ENTITY_TYPE_DEFAULT
  ))
  local entity_index = tonumber(GlobalsGetValue(
    SELECTED_ENTITY_INDEX, SELECTED_ENTITY_INDEX_DEFAULT
  ))

  local category = ALL_ENTITIES[category_index]
  local entity = category.entities[entity_index]
  return entity
end
