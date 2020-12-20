dofile_once("mods/raksa/files/scripts/utilities.lua");


-- Allow enemies to shoot friends of the same herd genome.
-- Without this the bullets would just go through, with only melee working.
function shot(projectile)
  local happiness = EntityGetValue(
    GameGetWorldStateEntity(),
    "WorldStateComponent",
    "global_genome_relations_modifier"
  )

  if happiness <= -100 then
    EntitySetValue(projectile, "ProjectileComponent", "friendly_fire", true)
  end
end
