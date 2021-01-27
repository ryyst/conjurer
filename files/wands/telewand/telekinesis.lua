dofile_once("mods/raksa/files/scripts/utilities.lua")


function get_or_create_reticle(x, y)
  local reticle = EntityGetWithName("telewand_reticle")
  if reticle and reticle ~= 0 then
    return reticle
  end

  return EntityLoad("mods/raksa/files/wands/telewand/reticle.xml", x, y)
end


function reticle_follow_mouse(reticle, x, y)
  EntitySetTransform(reticle, x, y)
end


local x, y = DEBUG_GetMouseWorld()
local reticle = get_or_create_reticle(x, y)
reticle_follow_mouse(reticle, x, y)


if is_holding_m1() then
  local reticle = get_or_create_reticle(x, y)
  local telekinesis = EntityGetFirstComponentIncludingDisabled(reticle, "TelekinesisComponent")
  ComponentSetValue2(telekinesis, "mInteract", true)
end
