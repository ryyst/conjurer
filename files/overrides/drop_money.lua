dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/scripts/enums.lua")

-- Block enemies from dropping gold. Gets in the way of proper gladiatior action and
-- serves no purpose for the Conjurer who has everything.

local do_real_money_drop = do_money_drop

function do_money_drop(amount_multiplier, trick_kill)
  if GlobalsGetBool(ANIMALS_SPAWN_GOLD) then
    do_real_money_drop(amount_multiplier, trick_kill)
  end
end
