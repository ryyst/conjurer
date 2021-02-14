dofile_once("mods/raksa/files/scripts/utilities.lua")

local entity = GetUpdatedEntityID()


function get_hitbox_transform(box)

  local min_x = ComponentGetValue2(box, "aabb_min_x")
  local max_x = ComponentGetValue2(box, "aabb_max_x")
  local min_y = ComponentGetValue2(box, "aabb_min_y")
  local max_y = ComponentGetValue2(box, "aabb_max_y")
  local offset_x, offset_y = ComponentGetValue2(box, "offset")

  local width = math.abs(min_x)+math.abs(max_x) or 1
  local height = math.abs(min_y)+math.abs(max_y) or 1

  local x = 0-min_x/width - offset_x/width
  local y = 0-min_y/height - offset_y/height

  local worm_hitbox = EntityGetValue(entity, "WormComponent", "hitbox_radius")
  if worm_hitbox then
    local size = worm_hitbox * 2
    x = 0-min_x/size - offset_x/size
    y = 0-min_y/size - offset_y/size
    return x, y, size, size
  end

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
  if #hitboxes ~= sprites then
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

    EntityAddComponent2(entity, "SpriteComponent", {
        _tags="raksa_hitbox_display",
        image_file="mods/raksa/files/gfx/eraser_pixel.png",
        has_special_scale=true,
        special_scale_x=width,
        special_scale_y=height,
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
