dofile_once("mods/raksa/files/scripts/utilities.lua")

dofile_once("mods/raksa/files/scripts/lists/solids.lua");
dofile_once("mods/raksa/files/scripts/lists/sands.lua");
dofile_once("mods/raksa/files/scripts/lists/liquids.lua");
dofile_once("mods/raksa/files/scripts/lists/gases.lua");
dofile_once("mods/raksa/files/scripts/lists/fires.lua");
dofile_once("mods/raksa/files/scripts/lists/box2d_solids.lua");
dofile_once("mods/raksa/files/scripts/lists/dangerous_materials.lua");


local _all_defined_materials = {
  SOLIDS, LIQUIDS, SANDS, GASES, FIRES, DANGEROUS, BOX2D_SOLIDS
}

function material_to_name(id)
  id = id:gsub("_",' ')
  id = id:gsub("(%l)(%w*)", function(a,b) return string.upper(a)..b end)
  return id
end

function is_material_defined(id)
  for i, category in ipairs(_all_defined_materials) do
    for j, material in ipairs(category) do
      if id == material.id then
        return true
      end
    end
  end
  return false
end

function generate_leftover_materials()
  local leftovers = {}

  local all_materials = {
    CellFactory_GetAllLiquids(true),
    CellFactory_GetAllSands(true),
    CellFactory_GetAllGases(true),
    CellFactory_GetAllFires(true),
    CellFactory_GetAllSolids(true),
  }

  for i, category in ipairs(all_materials) do
    for j, material in ipairs(category) do
      if not is_material_defined(material) then
        table.insert(leftovers, {
          image=ICON_UNKNOWN,
          name=material_to_name(material),
          id=material
        })
      end
    end
  end

  return leftovers
end

function print_leftovers_for_devs()
  print("List of leftover materials for mod developers:")
  print("LEFTOVERS = {")
  for i, material in ipairs(LEFTOVERS) do
    print("  {")
    for key, value in pairs(material) do
      print("    "..tostring(key).."="..str(value)..",")
    end
    print("  },")
  end
  print("}")
end


LEFTOVERS = nil

if not LEFTOVERS then
  print("Generating leftover materials...")
  local start = GameGetRealWorldTimeSinceStarted()

  LEFTOVERS = generate_leftover_materials()

  -- This builds so fast I just assume it's milliseconds
  local finish = GameGetRealWorldTimeSinceStarted()
  print("Done! [" .. tostring((finish - start)*1000) .."ms]")

  if DebugGetIsDevBuild() then
    print_leftovers_for_devs()
  end
end
