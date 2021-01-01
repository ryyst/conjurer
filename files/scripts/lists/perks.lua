dofile_once("data/scripts/perks/perk.lua")
dofile_once("data/scripts/perks/perk_list.lua")


PERKS = {}


function dont_remove_other_perks_on_pickup(entity)
  EntityAddComponent2(entity, "VariableStorageComponent", {
    name="perk_dont_remove_others",
    value_bool=true,
  })
end


for i, perk in ipairs(perk_list) do
  table.insert(PERKS, {
      name=perk.ui_name,
      desc=perk.ui_description,
      spawn_func=function(x, y) return perk_spawn(x, y, perk.id) end,
      image=perk.perk_icon,
      post_processor=dont_remove_other_perks_on_pickup,
  })
end
