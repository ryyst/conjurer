dofile_once("data/scripts/lib/utilities.lua")

-- Lazy random weights, just duplicate the entries.
potions = {
  "blood_worm",
  "alcohol",
  "bone",
  "bone",
  "bone",
  "bone",
  "bone",
  "meat",
  "pea_soup",
  "pea_soup",
  "pea_soup",
  "honey",
  "honey",
  "honey",
  "honey",
  "honey",
  "salt",
  "salt",
  "salt",
  "salt",
  "salt",
  "salt",
  "salt",
  "salt",
  "sima",
  "sima",
  "sima",
  "pea_soup",
  "pea_soup",
  "pea_soup",
}


function init( entity_id )
  local x,y = EntityGetTransform( entity_id )
  SetRandomSeed( x, y )
  -- so that all the potions will be the same in every position with the same seed
  local potion = random_from_array( potions )

  AddMaterialInventoryMaterial( entity_id, potion, 500 )
end
