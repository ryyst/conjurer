LETTERS = {
  a="mods/raksa/files/gfx/letter_icons/1.png",
  b="mods/raksa/files/gfx/letter_icons/2.png",
  c="mods/raksa/files/gfx/letter_icons/3.png",
  d="mods/raksa/files/gfx/letter_icons/4.png",
  e="mods/raksa/files/gfx/letter_icons/5.png",
  f="mods/raksa/files/gfx/letter_icons/6.png",
  g="mods/raksa/files/gfx/letter_icons/7.png",
  h="mods/raksa/files/gfx/letter_icons/8.png",
  i="mods/raksa/files/gfx/letter_icons/9.png",
  j="mods/raksa/files/gfx/letter_icons/10.png",
  k="mods/raksa/files/gfx/letter_icons/11.png",
  l="mods/raksa/files/gfx/letter_icons/12.png",
  m="mods/raksa/files/gfx/letter_icons/13.png",
  n="mods/raksa/files/gfx/letter_icons/14.png",
  o="mods/raksa/files/gfx/letter_icons/15.png",
  p="mods/raksa/files/gfx/letter_icons/16.png",
  q="mods/raksa/files/gfx/letter_icons/17.png",
  r="mods/raksa/files/gfx/letter_icons/18.png",
  s="mods/raksa/files/gfx/letter_icons/19.png",
  t="mods/raksa/files/gfx/letter_icons/20.png",
  u="mods/raksa/files/gfx/letter_icons/21.png",
  v="mods/raksa/files/gfx/letter_icons/22.png",
  w="mods/raksa/files/gfx/letter_icons/23.png",
  x="mods/raksa/files/gfx/letter_icons/24.png",
  y="mods/raksa/files/gfx/letter_icons/25.png",
  z="mods/raksa/files/gfx/letter_icons/26.png",
  å="mods/raksa/files/gfx/letter_icons/27.png",
  ä="mods/raksa/files/gfx/letter_icons/28.png",
  ö="mods/raksa/files/gfx/letter_icons/29.png",
}

local DEFAULT_UNKNOWN = "ö"

function get_letter_icon(name)
  name = name or DEFAULT_UNKNOWN
  local first_character = name:sub(1, 1)
  local path = LETTERS[string.lower(first_character)]

  if not path then
    -- Oudot tapaukset menee ö-mappiin
    path = LETTERS[DEFAULT_UNKNOWN]
  end

  return path
end
