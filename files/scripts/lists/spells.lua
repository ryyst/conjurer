dofile_once("data/scripts/gun/gun_actions.lua")
dofile_once("data/scripts/gun/gun_enums.lua")


SPELLS = {}


for i, action in ipairs(actions) do
  if not action.hide_from_conjurer then
    table.insert(SPELLS, {
        name=action.name,
        desc=action.description,
        spawn_func=function(x, y) return CreateItemActionEntity(action.id, x, y) end,
        image=action.sprite,
    })
  end
end
