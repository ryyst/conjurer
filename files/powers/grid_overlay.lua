dofile_once("mods/raksa/files/scripts/utilities.lua")


function calculate_grid_position()
  local x, y = GameGetCameraPos()
  local GRID_SIZE = 100

  -- Lock to grid
  x = x - x % GRID_SIZE
  y = y - y % GRID_SIZE

  return x, y
end


function toggle_grid()
  local grid = EntityGetWithName("grid_overlay")
  if grid == nil or grid == 0 then
    local x, y = calculate_grid_position()
    EntityLoad("mods/raksa/files/powers/grid_overlay.xml", x, y)
  else
    EntityKill(grid)
  end
end
