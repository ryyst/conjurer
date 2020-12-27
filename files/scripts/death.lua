dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/scripts/enums.lua")


function damage_received(damage, message, entity_thats_responsible, is_fatal)
  if is_fatal and not GlobalsGetBool(KALMA_IS_IMMORTAL) then
    local player = GetUpdatedEntityID()

    -- Momentary blindness
    local blindness = EntityCreateNew()
    EntityAddComponent2(blindness, "GameEffectComponent", {
        effect="BLINDNESS",
        frames=120,
    })
    EntityAddChild(player, blindness)

    -- Teleport to spawn
    EntitySetTransform(player, SPAWN_X, SPAWN_Y)

    -- Refresh health
    local dmgComponent = EntityGetFirstComponentIncludingDisabled(player, "DamageModelComponent")
    local max_health = tonumber(ComponentGetValue(dmgComponent, "max_hp"))
    ComponentSetValue2(dmgComponent, "hp", max_health)

    --
    GamePrintImportant("You died", "No rest for the wicked")

    EntityAddRandomStains(player, CellFactory_GetType("magic_liquid_hp_regeneration"), 100)
    EntityAddRandomStains(player, CellFactory_GetType("water"), 200)
  end
end
