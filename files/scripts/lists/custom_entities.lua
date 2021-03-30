dofile_once("mods/raksa/files/scripts/utilities.lua")

local spawn_img = create_image_spawner(100)

CUSTOM_ENTITIES = {
  {
    name="Generator",
    desc="Requires a switch to work",
    path="mods/raksa/files/custom_entities/generator/generator.xml",
    image="mods/raksa/files/custom_entities/generator/icon_generator.png",
  },
  {
    name="Generator switch",
    desc="Toggles the closest generator",
    path="mods/raksa/files/custom_entities/generator/switch.xml",
    image="mods/raksa/files/custom_entities/generator/icon_switch.png",
  },
  {
    name="Door",
    path="mods/raksa/files/custom_entities/door/door.xml",
    image="mods/raksa/files/custom_entities/door/icon_door.png",
  },
  {
    name="Metal door",
    desc="Can be powered by electricity.",
    path="mods/raksa/files/custom_entities/door_metal/door_metal.xml",
    image="mods/raksa/files/custom_entities/door_metal/icon_door.png",
  },
  {
    name="Hatch",
    path="mods/raksa/files/custom_entities/hatch/hatch.xml",
    image="mods/raksa/files/custom_entities/hatch/icon_hatch.png",
  },
  {
    name="Magical Drain",
    desc="Sucks up liquids, sands & gases.\nMakes sewage a breeze!",
    path="mods/raksa/files/custom_entities/drain/drain.xml",
    image="mods/raksa/files/custom_entities/drain/drain.png",
  },
  {
    name="Grid",
    path="mods/raksa/files/custom_entities/grid/grid.xml",
    image="mods/raksa/files/custom_entities/grid/icon_grid.png",
  },
  {
    name="Ball",
    path="mods/raksa/files/custom_entities/ball/ball.xml",
    image="mods/raksa/files/custom_entities/ball/ui_gfx.png",
  },
  {
    name="Background 20px - Windowed",
    spawn_func=spawn_img("mods/raksa/files/custom_entities/backgrounds/bg_20_window.png", 0, 0),
    image="mods/raksa/files/custom_entities/backgrounds/icon_bg_window.png",
  },
  {
    name="Background 20px",
    spawn_func=spawn_img("mods/raksa/files/custom_entities/backgrounds/bg_20.png", 0, 0),
    image="mods/raksa/files/custom_entities/backgrounds/icon_bg.png",
  },
  {
    name="Background 40px",
    spawn_func=spawn_img("mods/raksa/files/custom_entities/backgrounds/bg_40.png", 0, 0),
    image="mods/raksa/files/custom_entities/backgrounds/icon_bg.png",
  },
  {
    name="Background 80px",
    spawn_func=spawn_img("mods/raksa/files/custom_entities/backgrounds/bg_80.png", 0, 0),
    image="mods/raksa/files/custom_entities/backgrounds/icon_bg.png",
  },
  {
    name="Background 160px",
    spawn_func=spawn_img("mods/raksa/files/custom_entities/backgrounds/bg_160.png", 0, 0),
    image="mods/raksa/files/custom_entities/backgrounds/icon_bg.png",
  },
  {
    name="Mounted Gun",
    path="mods/raksa/files/custom_entities/mounted_gun/hmg.xml",
    image="mods/raksa/files/custom_entities/mounted_gun/icon.png",
  },
  {
    name="Domino Blocks",
    path="mods/raksa/files/custom_entities/dominos/physics_domino.xml",
    image="mods/raksa/files/custom_entities/dominos/gfx/icon.png",
  },
}
