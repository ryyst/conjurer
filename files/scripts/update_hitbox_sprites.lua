dofile_once("mods/raksa/files/scripts/utilities.lua")

local entity = GetUpdatedEntityID()


function get_hitbox_transform(box)
  local min_x = ComponentGetValue2(box, "aabb_min_x")
  local max_x = ComponentGetValue2(box, "aabb_max_x")
  local min_y = ComponentGetValue2(box, "aabb_min_y")
  local max_y = ComponentGetValue2(box, "aabb_max_y")
  local offset_x, offset_y = ComponentGetValue2(box, "offset")

  -- Animals turning around flips the scale, thus also flipping the X offset.
  local _, _, _, scale_x = EntityGetTransform(entity)
  local sign = scale_x < 0 and -1 or 1
  offset_x = offset_x * sign

  -- Worm-like creatures get special treatment.
  local worm_hitbox = EntityGetValue(entity, "WormComponent", "hitbox_radius")
  if worm_hitbox then
    local size = worm_hitbox * 2
    local x = 0-min_x/size - offset_x/size
    local y = 0-min_y/size - offset_y/size
    return x, y, size, size
  end

  if (min_x > max_x) or (min_y > max_y) then
    -- Invalid AABB. Our super-generalized calculations below were actually made to
    -- support these, before I noticed the game itself doesn't accept such scenarios.
    --
    -- So we'll just handle this with a simple if clause and be done with it.
    return 0, 0, 0, 0
  end

  local width  = math.abs(math.min(min_x, max_x) - math.max(min_x, max_x)) or 1
  local height = math.abs(math.min(min_y, max_y) - math.max(min_y, max_y)) or 1

  local x = 0 - math.min(min_x, max_x)/width - offset_x/width
  local y = 0 - math.min(min_y, max_y)/height - offset_y/height

  return x, y, width, height
end


function reset_sprites(sprites, hitboxes)
  -- Reset sprites
  for i, comp in ipairs(sprites) do
    EntityRemoveComponent(entity, comp)
  end
  create_sprites(hitboxes)
end


function update_sprites(sprites, hitboxes)
  if #hitboxes ~= #sprites then
    reset_sprites(sprites, hitboxes)
    return
  end

  for i, box in ipairs(hitboxes) do
    local sprite = sprites[i]

    local x, y, width, height = get_hitbox_transform(box)

    ComponentSetValues(sprite, {
        special_scale_x=width,
        special_scale_y=height,
        offset_x=x,
        offset_y=y,
    })
  end
end

function create_sprites(hitboxes)
  for i, box in ipairs(hitboxes) do
    local x, y, width, height = get_hitbox_transform(box)

    -- Silly boolean conversion
    local is_worm = not not EntityGetValue(entity, "WormComponent", "hitbox_radius")

    EntityAddComponent2(entity, "SpriteComponent", {
        _tags="raksa_hitbox_display",
        image_file="mods/raksa/files/gfx/eraser_pixel.png",
        has_special_scale=true,
        special_scale_x=width,
        special_scale_y=height,
        update_transform_rotation=is_worm,
        offset_x=x,
        offset_y=y,
        emissive=true,
        alpha=0.3,
      })
  end
end


local hitbox_sprites = EntityGetComponentIncludingDisabled(
  entity, "SpriteComponent", "raksa_hitbox_display"
)
local hitboxes = EntityGetComponentIncludingDisabled(entity, "HitboxComponent")

if hitbox_sprites and hitboxes then
  update_sprites(hitbox_sprites, hitboxes)
elseif hitboxes then
  create_sprites(hitboxes)
end
