dofile_once("mods/raksa/files/scripts/utilities.lua");


-- Allow enemies to shoot friends of the same herd genome.
-- Without this the bullets would just go through, with only melee working.
function shot(projectile)
  local happiness = EntityGetValue(
    GameGetWorldStateEntity(),
    "WorldStateComponent",
    "global_genome_relations_modifier"
  )

  -- Not every projectile actually has a ProjectileComponent. For example Polyorbs.
  local projComp = EntityGetFirstComponentIncludingDisabled(projectile, "ProjectileComponent")

  if happiness <= -100 and projComp then
    EntitySetValue(projectile, "ProjectileComponent", "friendly_fire", true)

    -- Everyone can self-damage, why not?
    EntitySetValue(projectile, "ProjectileComponent", "collide_with_shooter_frames", 10)
    EntitySetValue(projectile, "ProjectileComponent", "explosion_dont_damage_shooter", false)
  end
end
