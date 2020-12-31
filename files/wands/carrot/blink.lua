dofile_once("mods/raksa/files/scripts/utilities.lua")


if has_clicked_m1() then
  local x, y = DEBUG_GetMouseWorld()
  teleport_player(x, y)
end
