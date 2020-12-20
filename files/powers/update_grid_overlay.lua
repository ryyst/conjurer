dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/powers/grid_overlay.lua")


local grid = GetUpdatedEntityID()

local x, y = calculate_grid_position(grid)
EntitySetTransform(grid, x, y)
