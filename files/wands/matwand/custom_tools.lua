dofile("data/scripts/lib/utilities.lua")

dofile_once("mods/raksa/files/scripts/utilities.lua")
dofile_once("mods/raksa/files/wands/matwand/helpers.lua");

local DRAGGER_NAME = "matwand_dragger_reticle"


--
-- Filler tool
--
function filler_action(material, brush, x, y)
  local filler = EntityCreateNew()

  EntityAddComponent2(filler, "LifetimeComponent", { lifetime=2 })
  EntityAddComponent2(
    filler,
    "ParticleEmitterComponent",
    get_draw_vars("construction_paste", brush)
  )

  EntitySetTransform(filler, x, y)
end


function filler_release_action(material, brush, x, y)
  ConvertMaterialOnAreaInstantly(
    x-1000, y-1000,
    2000, 2000,
    CellFactory_GetType("construction_paste"), CellFactory_GetType(material),
    true,
    false
  )
end


--
-- Line tool
--
function line_action(material, brush, x, y)
  local FINAL_WIDTH = 4
  local WIDTH_OFFSET = 0.5

  local line = EntityGetWithName(DRAGGER_NAME)

  if EntityGetIsAlive(line) then
    -- Get coordinates of starting point
    local line_x, line_y = EntityGetTransform(line)

    local length = get_distance(line_x, line_y, x, y)
    local rotation = math.atan2(y-line_y, x-line_x)

    EntitySetTransform(line, line_x, line_y, rotation, length, FINAL_WIDTH)
  else
    line = EntityCreateNew(DRAGGER_NAME)
    EntitySetTransform(line, x, y-WIDTH_OFFSET)
    EntityAddComponent2(line, "SpriteComponent", {
      image_file=brush.brush_file,
      alpha=0.1,
      additive=true,
      emissive=true,
      z_index=80,
      offset_y=WIDTH_OFFSET,
    })
  end
end


--
-- Shape tools
--
function dragger_release_action(material, brush, x, y)
  local line = EntityGetWithName(DRAGGER_NAME)
  EntityConvertToMaterial(line, material)
  EntityKill(line)
end


function corner_aligned_polygon_action(material, brush, x, y)
  local rect = EntityGetWithName(DRAGGER_NAME)
  local SPRITE_SIZE = brush.brush_sprite_size

  if EntityGetIsAlive(rect) then
    -- Get coordinates of starting point
    local rect_x, rect_y = EntityGetTransform(rect)

    local width = rect_x - x
    local height = rect_y - y

    EntitySetTransform(rect, rect_x, rect_y, 0, -width/SPRITE_SIZE, -height/SPRITE_SIZE)
  else
    rect = EntityCreateNew(DRAGGER_NAME)
    EntitySetTransform(rect, x, y, 0, 1/SPRITE_SIZE, 1/SPRITE_SIZE)
    EntityAddComponent2(rect, "SpriteComponent", {
      image_file=brush.brush_file,
      alpha=0.1,
      additive=true,
      emissive=true,
      z_index=80,
    })
  end
end
