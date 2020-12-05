dofile_once("mods/raksa/files/scripts/enums.lua")


function damage_received(damage, message, entity_thats_responsible, is_fatal)
  if is_fatal and HasFlagPersistent(KALMA_RECALL_FLAG) then
    local player = GetUpdatedEntityID()

    -- Momentary blindness
    local blindness = EntityCreateNew()
    EntityAddComponent2(blindness, "GameEffectComponent", {
        effect="BLINDNESS",
        frames=120,
    })
    EntityAddChild(player, blindness)

    -- Teleport to spawn
    EntitySetTransform(player, 400, -410)

    -- Refresh health
    local dmgComponent = EntityGetFirstComponentIncludingDisabled(player, "DamageModelComponent")
    local max_health = tonumber(ComponentGetValue(dmgComponent, "max_hp"))
    ComponentSetValue2(dmgComponent, "hp", max_health)
  end
end
