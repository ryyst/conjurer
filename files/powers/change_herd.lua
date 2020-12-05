dofile_once("mods/raksa/files/scripts/utilities.lua")

HERDS = {
  "player",
  "slimes",
  "ant",
  "robot",
  "fly",
  "boss_dragon",
  "crawler",
  "helpless",
  "eel",
  "fire",
  "fungus",
  "ghoul",
  "giant",
  "ice",
  "spider",
  "orcs",
  "rat",
  "electricity",
  "wolf",
  "worm",
  "zombie",
  "nest",
  "mage",
  "flower",
  "ghost",
  "boss_limbs",
  "healer",
  "apparition",
  "bat",
  "mage_swapper",
  "curse",
  "trap",
}

function change_player_herd(herd_name)
  local player = get_player()
  EntitySetValue(player, "GenomeDataComponent", "herd_id", StringToHerdId(herd_name))
  GamePrint("You now belong to the '" .. herd_name .. "' herd!")
end
