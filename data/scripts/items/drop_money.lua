-- Block enemies from dropping gold. Gets in the way of proper gladiatior action and
-- serves no purpose for the Conjurer who has everything.
--
-- TODO: See if we ever want a toggle for this, eg. for special game modes or when we
-- allow for changing maps or something.
--

function do_money_drop(not_really)
  -- pass.
  -- Required for drop_money_x* scripts.
end

function death(damage_type_bit_field, damage_message, responsible_entity, drop_items)
  -- pass
end
