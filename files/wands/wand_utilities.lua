dofile_once("mods/raksa/files/scripts/enums.lua")
dofile_once("mods/raksa/files/wands/entwand/processors.lua")


ENTITY_POST_PROCESSORS = {
  disable_new_physicsbody_optimizations,
  remove_spawn_limits_set_by_camerabound,
  add_friendly_fire_corrector,
}

function postprocess_entity(entity, x, y)
  for _, func in ipairs(ENTITY_POST_PROCESSORS) do
    func(entity, x, y)
  end
end

function EntityLoadProcessed(path, x, y)
  local entity = EntityLoad(path, x, y)
  postprocess_entity(entity, x, y)
  return entity
end


function is_freecam_entity(entity, name)
  -- Upon activating the free camera (Conjurer Eye), an entity appears approximately
  -- in the middle of the screen. It seems this entity is tied to something on the
  -- engine side, because deleting this causes a fairly certain crash to desktop
  -- soon after. So we make sure it cannot be deleted.
  --
  -- This entity has no name, no tags and exactly two LightComponents.
  --
  -- We were also unable to detect it upon Conjurer Eye activation (eg. to give it
  -- an easily fetchable name). So we do a bit more hax here.
  --
  -- Has to be checked even when freecam is not in use, because toggling it off will
  -- actually leave this entity lying behind.
  local components = EntityGetAllComponents(entity)
  local basic_signature_matches = (
    name == "" and
    #components == 2 and
    EntityGetTags(entity) == ""
  )

  if basic_signature_matches then
    -- Final check, the component types.
    for i, comp in ipairs(components) do
      if ComponentGetTypeName(comp) ~= "LightComponent" then
        -- TODO: If we start running into false positives, check
        -- that all colors are 255 and radius is 750
        return false
      end
    end

    -- All checks pass and signature matches.
    -- This entity should not be deleted.
    return true
  end

  -- Failed at component inspection, not our guy.
  return false
end


function is_valid_entity(entity)
  local name = EntityGetName(entity)
  local basic_checks = (
    entity ~= nil and
    entity ~= 0 and
    name ~= "entwand_cursor" and
    name ~= "editwand_cursor" and
    name ~= "grid_overlay" and
    -- The reticle shouldn't ever even be detected, but good to have anyway.
    name ~= RETICLE_NAME and
    not IsPlayer(entity) and
    entity ~= GameGetWorldStateEntity() and
    -- This is something that always exists in 0,0.
    name ~= "example_container"
  )

  if GlobalsGetBool(ENTWAND_IGNORE_BACKGROUNDS) and name == BG_NAME then
    return false
  end

  if not basic_checks then
    return false
  end

  if is_freecam_entity(entity, name) then
    return false
  end

  return true
end
