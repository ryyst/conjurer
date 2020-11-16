dofile_once("mods/luoja/files/scripts/utilities.lua")

function add_mod_projectile(path)
  add_projectile(MOD_PATH .. path)
end

table.insert( actions,
{
  id                = "MATGUN",
  name              = "Paint any materials",
  description       = "Left mouse to paint and right mouse to erase.",
  sprite            = MOD_PATH .. "guns/matgun/matgun.png",
  type              = ACTION_TYPE_PROJECTILE,
  spawn_level       = "",
  spawn_probability = "",
  price             = 600,
  mana              = 0,
  max_uses          = 6,
  --custom_xml_file = "mods/luoja/files/weapons/magazine.xml",
  action = function()
    GamePrint("Drawing should happen here!")
    --add_mod_projectile("weapons/shotgun/projectile/entity.xml")
  end,
})
