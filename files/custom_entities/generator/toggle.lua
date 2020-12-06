function interacting(interacter, switch, switch_name)
  toggle_electricity(switch)
  toggle_switch_sprite(switch)

  GameEntityPlaySound(switch, "player_projectiles/critical_hit" )
end


function toggle_switch_sprite(switch)
  local offSpriteComp = EntityGetFirstComponentIncludingDisabled(switch, "SpriteComponent", "switch_off")
  local onSpriteComp = EntityGetFirstComponentIncludingDisabled(switch, "SpriteComponent", "switch_on")

  local is_on = ComponentGetIsEnabled(onSpriteComp)

  EntitySetComponentIsEnabled(switch, offSpriteComp, is_on)
  EntitySetComponentIsEnabled(switch, onSpriteComp, not is_on)
end


function toggle_electricity(switch)
  local pos_x, pos_y = EntityGetTransform(switch)
  local generator = EntityGetClosestWithTag(pos_x, pos_y, "generator")
  if generator == nil or generator == 0 then
    return
  end

  local eChargeComp = EntityGetFirstComponentIncludingDisabled(generator, "ElectricChargeComponent")
  local eSourceComp = EntityGetFirstComponentIncludingDisabled(generator, "ElectricitySourceComponent")

  local is_enabled = ComponentGetIsEnabled(eChargeComp)

  EntitySetComponentIsEnabled(generator, eChargeComp, not is_enabled)
  EntitySetComponentIsEnabled(generator, eSourceComp, not is_enabled)
end
