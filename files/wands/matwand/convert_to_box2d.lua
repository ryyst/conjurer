dofile_once("mods/raksa/files/wands/matwand/helpers.lua");


function convert_material()
  local x, y = DEBUG_GetMouseWorld()
  local material = get_active_material()

  -- Instead of tracking everywhere where the player drew, we just
  -- take a huge area where we convert everything. Lazy, but covers 99% of
  -- the legit cases (which wouldn't crash the game anyway).
  ConvertMaterialOnAreaInstantly(
    x-1000, y-1000,
    2000, 2000,
    CellFactory_GetType("construction_steel"), CellFactory_GetType(material),
    true,
    false
  )
end
