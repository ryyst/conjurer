dofile_once("mods/raksa/files/scripts/utilities.lua")

function add_mod_projectile(path)
  add_projectile(MOD_PATH .. path)
end

table.insert( actions,
{
  id                = "MATWAND",
  name              = "Stone of the Elements",
  description       = "Control the elements themselves",
  sprite            = MOD_PATH .. "wands/matwand/spell.png",
  type              = ACTION_TYPE_PROJECTILE,
  spawn_level       = "",
  spawn_probability = "",
  price             = 100000,
  mana              = 0,
  action = function()
    -- Could we make some sparks fly here? Some eartherly lights?
  end,
})

table.insert( actions,
{
  id                = "ENTWAND",
  name              = "Illusion Shard",
  description       = "Create and manipulate the most convincing illusions",
  sprite            = MOD_PATH .. "wands/entwand/spell.png",
  type              = ACTION_TYPE_PROJECTILE,
  spawn_level       = "",
  spawn_probability = "",
  price             = 100000,
  mana              = 0,
  action = function()
    -- Could we make some sparks fly here? Some eartherly lights?
  end,
})
