dofile_once("mods/luoja/files/scripts/utilities.lua")

function add_mod_projectile(path)
  add_projectile(MOD_PATH .. path)
end

table.insert( actions,
{
  id                = "SHOTGUNSHELL",
  name              = "Shotgun Shells",
  description       = "Bandolier of 12 Gauge Shotgun Shells",
  sprite            = MOD_PATH .. "weapons/shotgun/projectile/shotgunshell.png",
  type              = ACTION_TYPE_PROJECTILE,
  spawn_level       = "0,4,5,6",
  spawn_probability = "1,1,1,1",
  price             = 600,
  mana              = 0,
  max_uses          = 6,
  --custom_xml_file = "mods/luoja/files/weapons/magazine.xml",
  action = function()
    --add_mod_projectile("weapons/shotgun/projectile/entity.xml")
  end,
})
