dofile_once("mods/raksa/files/scripts/utilities.lua")

local spawn_img = create_image_spawner(100)

-- NOTES TODO:
-- * Boss Arena Background is huge
-- * Left Entrance Background is huge
-- * Background pixel thingy is silly
-- * Add your own logo too :D
BACKGROUNDS = {
  {
    name="Logo visual",
    image="mods/raksa/files/gfx/bg_icons/0_logo_visual.png",
    spawn_func=spawn_img("data/biome_impl/trailer/logo_visual.png", 8, 5),
  },
  {
    name="Background panel big 01",
    image="mods/raksa/files/gfx/bg_icons/1_background_panel_big_01.png",
    spawn_func=spawn_img("data/biome_impl/liquidcave/background_panel_big_01.png", 0, 0),
  },
  {
    name="Background panel big 02",
    image="mods/raksa/files/gfx/bg_icons/2_background_panel_big_02.png",
    spawn_func=spawn_img("data/biome_impl/liquidcave/background_panel_big_02.png", 0, 0),
  },
  {
    name="Background panel big 03",
    image="mods/raksa/files/gfx/bg_icons/3_background_panel_big_03.png",
    spawn_func=spawn_img("data/biome_impl/liquidcave/background_panel_big_03.png", 0, 0),
  },
  {
    name="Background panel big 04",
    image="mods/raksa/files/gfx/bg_icons/4_background_panel_big_04.png",
    spawn_func=spawn_img("data/biome_impl/liquidcave/background_panel_big_04.png", 0, 0),
  },
  {
    name="Background panel big 05",
    image="mods/raksa/files/gfx/bg_icons/5_background_panel_big_05.png",
    spawn_func=spawn_img("data/biome_impl/liquidcave/background_panel_big_05.png", 0, 0),
  },
  {
    name="Background panel big 06",
    image="mods/raksa/files/gfx/bg_icons/6_background_panel_big_06.png",
    spawn_func=spawn_img("data/biome_impl/liquidcave/background_panel_big_06.png", 0, 0),
  },
  {
    name="Background panel big 07",
    image="mods/raksa/files/gfx/bg_icons/7_background_panel_big_07.png",
    spawn_func=spawn_img("data/biome_impl/liquidcave/background_panel_big_07.png", 0, 0),
  },
  {
    name="Background panel big 08",
    image="mods/raksa/files/gfx/bg_icons/8_background_panel_big_08.png",
    spawn_func=spawn_img("data/biome_impl/liquidcave/background_panel_big_08.png", 0, 0),
  },
  {
    name="Drape 1",
    image="mods/raksa/files/gfx/bg_icons/10_drape_1.png",
    spawn_func=spawn_img("data/biome_impl/wizardcave/drape_1.png", 0, 0),
  },
  {
    name="Drape 2",
    image="mods/raksa/files/gfx/bg_icons/11_drape_2.png",
    spawn_func=spawn_img("data/biome_impl/wizardcave/drape_2.png", 0, 0),
  },
  {
    name="Drape 3",
    image="mods/raksa/files/gfx/bg_icons/12_drape_3.png",
    spawn_func=spawn_img("data/biome_impl/wizardcave/drape_3.png", 0, 0),
  },
  {
    name="Altar background",
    image="mods/raksa/files/gfx/bg_icons/13_altar_background.png",
    spawn_func=spawn_img("data/biome_impl/coalmine/altar_background.png", 15, 0),
  },
  {
    name="Alcove 01 background",
    image="mods/raksa/files/gfx/bg_icons/14_alcove_01_background.png",
    spawn_func=spawn_img("data/biome_impl/crypt/alcove_01_background.png", 70, 3),
  },
  {
    name="Alcove 02 background",
    image="mods/raksa/files/gfx/bg_icons/15_alcove_02_background.png",
    spawn_func=spawn_img("data/biome_impl/crypt/alcove_02_background.png", 70, 3),
  },
  {
    name="Alcove 03 background",
    image="mods/raksa/files/gfx/bg_icons/16_alcove_03_background.png",
    spawn_func=spawn_img("data/biome_impl/crypt/alcove_03_background.png", 63, 3),
  },
  {
    name="Alcove 04 background",
    image="mods/raksa/files/gfx/bg_icons/17_alcove_04_background.png",
    spawn_func=spawn_img("data/biome_impl/crypt/alcove_04_background.png", 70, 3),
  },
  {
    name="Alcove 05 background",
    image="mods/raksa/files/gfx/bg_icons/18_alcove_05_background.png",
    spawn_func=spawn_img("data/biome_impl/crypt/alcove_05_background.png", 70, 3),
  },
  {
    name="Alcove 06 background",
    image="mods/raksa/files/gfx/bg_icons/19_alcove_06_background.png",
    spawn_func=spawn_img("data/biome_impl/crypt/alcove_06_background.png", 70, 3),
  },
  {
    name="Pillars 01 background",
    image="mods/raksa/files/gfx/bg_icons/20_pillars_01_background.png",
    spawn_func=spawn_img("data/biome_impl/crypt/pillars_01_background.png", 44, 0),
  },
  {
    name="Pillars 02 background",
    image="mods/raksa/files/gfx/bg_icons/21_pillars_02_background.png",
    spawn_func=spawn_img("data/biome_impl/crypt/pillars_02_background.png", 0, 0),
  },
  {
    name="Pillars 03 background",
    image="mods/raksa/files/gfx/bg_icons/22_pillars_03_background.png",
    spawn_func=spawn_img("data/biome_impl/crypt/pillars_03_background.png", 40, 3),
  },
  {
    name="Slab 01 background",
    image="mods/raksa/files/gfx/bg_icons/23_slab_01_background.png",
    spawn_func=spawn_img("data/biome_impl/crypt/slab_01_background.png", 10, 7),
  },
  {
    name="Slab 02 background",
    image="mods/raksa/files/gfx/bg_icons/24_slab_02_background.png",
    spawn_func=spawn_img("data/biome_impl/crypt/slab_02_background.png", 10, 7),
  },
  {
    name="Slab 03 background",
    image="mods/raksa/files/gfx/bg_icons/25_slab_03_background.png",
    spawn_func=spawn_img("data/biome_impl/crypt/slab_03_background.png", 10, 7),
  },
  {
    name="Slab 04 background",
    image="mods/raksa/files/gfx/bg_icons/26_slab_04_background.png",
    spawn_func=spawn_img("data/biome_impl/crypt/slab_04_background.png", 10, 7),
  },
  {
    name="Slab 05 background",
    image="mods/raksa/files/gfx/bg_icons/27_slab_05_background.png",
    spawn_func=spawn_img("data/biome_impl/crypt/slab_05_background.png", 10, 7),
  },
  {
    name="Slab 06 background",
    image="mods/raksa/files/gfx/bg_icons/28_slab_06_background.png",
    spawn_func=spawn_img("data/biome_impl/crypt/slab_06_background.png", 10, 7),
  },
  {
    name="Slab 07 background",
    image="mods/raksa/files/gfx/bg_icons/29_slab_07_background.png",
    spawn_func=spawn_img("data/biome_impl/crypt/slab_07_background.png", 10, 7),
  },
  {
    name="Cube chamber background",
    image="mods/raksa/files/gfx/bg_icons/30_cube_chamber_background.png",
    spawn_func=spawn_img("data/biome_impl/excavationsite/cube_chamber_background.png", 139, 145),
  },
  {
    name="Machine 1 background",
    image="mods/raksa/files/gfx/bg_icons/31_machine_1_background.png",
    spawn_func=spawn_img("data/biome_impl/excavationsite/machine_1_background.png", 54, 114),
  },
  {
    name="Machine 2 background",
    image="mods/raksa/files/gfx/bg_icons/32_machine_2_background.png",
    spawn_func=spawn_img("data/biome_impl/excavationsite/machine_2_background.png", 204, 40),
  },
  {
    name="Machine 3b background",
    image="mods/raksa/files/gfx/bg_icons/34_machine_3b_background.png",
    spawn_func=spawn_img("data/biome_impl/excavationsite/machine_3b_background.png", 70, 14),
  },
  {
    name="Machine 4 background",
    image="mods/raksa/files/gfx/bg_icons/35_machine_4_background.png",
    spawn_func=spawn_img("data/biome_impl/excavationsite/machine_4_background.png", 78, 16),
  },
  {
    name="Machine 5 background",
    image="mods/raksa/files/gfx/bg_icons/36_machine_5_background.png",
    spawn_func=spawn_img("data/biome_impl/excavationsite/machine_5_background.png", 270, 62),
  },
  {
    name="Mechanism background",
    image="mods/raksa/files/gfx/bg_icons/37_mechanism_background.png",
    spawn_func=spawn_img("data/biome_impl/excavationsite/mechanism_background.png", 0, 16),
  },
  {
    name="Mechanism background2",
    image="mods/raksa/files/gfx/bg_icons/38_mechanism_background2.png",
    spawn_func=spawn_img("data/biome_impl/excavationsite/mechanism_background2.png", 0, 42),
  },
  {
    name="Mechanism background3",
    image="mods/raksa/files/gfx/bg_icons/39_mechanism_background3.png",
    spawn_func=spawn_img("data/biome_impl/excavationsite/mechanism_background3.png", 0, 28),
  },
  {
    name="Hall background",
    image="mods/raksa/files/gfx/bg_icons/40_hall_background.png",
    spawn_func=spawn_img("data/biome_impl/mountain/hall_background.png", 0, 0),
  },
  {
    name="Left entrance background",
    image="mods/raksa/files/gfx/bg_icons/42_left_entrance_background.png",
    spawn_func=spawn_img("data/biome_impl/mountain/left_entrance_background.png", 0, 3),
  },
  {
    name="Left entrance below background",
    image="mods/raksa/files/gfx/bg_icons/43_left_entrance_below_background.png",
    spawn_func=spawn_img("data/biome_impl/mountain/left_entrance_below_background.png", 0, 0),
  },
  {
    name="Left stub background",
    image="mods/raksa/files/gfx/bg_icons/44_left_stub_background.png",
    spawn_func=spawn_img("data/biome_impl/mountain/left_stub_background.png", 397, 0),
  },
  {
    name="Right entrance background",
    image="mods/raksa/files/gfx/bg_icons/45_right_entrance_background.png",
    spawn_func=spawn_img("data/biome_impl/mountain/right_entrance_background.png", 0, 320),
  },
  {
    name="Right background",
    image="mods/raksa/files/gfx/bg_icons/46_right_background.png",
    spawn_func=spawn_img("data/biome_impl/mountain/right_background.png", 0, 147),
  },
  {
    name="Right stub background",
    image="mods/raksa/files/gfx/bg_icons/47_right_stub_background.png",
    spawn_func=spawn_img("data/biome_impl/mountain/right_stub_background.png", 0, 0),
  },
  {
    name="Hallway background",
    image="mods/raksa/files/gfx/bg_icons/48_hallway_background.png",
    spawn_func=spawn_img("data/biome_impl/pyramid/hallway_background.png", 0, 0),
  },
  {
    name="Left background",
    image="mods/raksa/files/gfx/bg_icons/49_left_background.png",
    spawn_func=spawn_img("data/biome_impl/pyramid/left_background.png", 6, 6),
  },
  {
    name="Entrance background",
    image="mods/raksa/files/gfx/bg_icons/50_entrance_background.png",
    spawn_func=spawn_img("data/biome_impl/pyramid/entrance_background.png", 7, 1),
  },
  {
    name="Top background",
    image="mods/raksa/files/gfx/bg_icons/51_top_background.png",
    spawn_func=spawn_img("data/biome_impl/pyramid/top_background.png", 0, 339),
  },
  {
    name="Right background",
    image="mods/raksa/files/gfx/bg_icons/52_right_background.png",
    spawn_func=spawn_img("data/biome_impl/pyramid/right_background.png", 0, 1),
  },
  {
    name="Hut01 background",
    image="mods/raksa/files/gfx/bg_icons/53_hut01_background.png",
    spawn_func=spawn_img("data/biome_impl/rainforest/hut01_background.png", 101, 65),
  },
  {
    name="Plantlife10 background",
    image="mods/raksa/files/gfx/bg_icons/54_plantlife10_background.png",
    spawn_func=spawn_img("data/biome_impl/rainforest/plantlife10_background.png", 45, 4),
  },
  {
    name="Plantlife11 background",
    image="mods/raksa/files/gfx/bg_icons/55_plantlife11_background.png",
    spawn_func=spawn_img("data/biome_impl/rainforest/plantlife11_background.png", 31, 4),
  },
  {
    name="Plantlife12 background",
    image="mods/raksa/files/gfx/bg_icons/56_plantlife12_background.png",
    spawn_func=spawn_img("data/biome_impl/rainforest/plantlife12_background.png", 49, 1),
  },
  {
    name="Plantlife2 background",
    image="mods/raksa/files/gfx/bg_icons/57_plantlife2_background.png",
    spawn_func=spawn_img("data/biome_impl/rainforest/plantlife2_background.png", 6, 18),
  },
  {
    name="Plantlife3 background",
    image="mods/raksa/files/gfx/bg_icons/58_plantlife3_background.png",
    spawn_func=spawn_img("data/biome_impl/rainforest/plantlife3_background.png", 8, 2),
  },
  {
    name="Plantlife4 background",
    image="mods/raksa/files/gfx/bg_icons/59_plantlife4_background.png",
    spawn_func=spawn_img("data/biome_impl/rainforest/plantlife4_background.png", 14, 2),
  },
  {
    name="Plantlife5 background",
    image="mods/raksa/files/gfx/bg_icons/60_plantlife5_background.png",
    spawn_func=spawn_img("data/biome_impl/rainforest/plantlife5_background.png", 33, 10),
  },
  {
    name="Plantlife6 background",
    image="mods/raksa/files/gfx/bg_icons/61_plantlife6_background.png",
    spawn_func=spawn_img("data/biome_impl/rainforest/plantlife6_background.png", 32, 10),
  },
  {
    name="Plantlife7 background",
    image="mods/raksa/files/gfx/bg_icons/62_plantlife7_background.png",
    spawn_func=spawn_img("data/biome_impl/rainforest/plantlife7_background.png", 11, 18),
  },
  {
    name="Plantlife8 background",
    image="mods/raksa/files/gfx/bg_icons/63_plantlife8_background.png",
    spawn_func=spawn_img("data/biome_impl/rainforest/plantlife8_background.png", 6, 18),
  },
  {
    name="Plantlife9 background",
    image="mods/raksa/files/gfx/bg_icons/64_plantlife9_background.png",
    spawn_func=spawn_img("data/biome_impl/rainforest/plantlife9_background.png", 30, 10),
  },
  {
    name="Plantlife background",
    image="mods/raksa/files/gfx/bg_icons/65_plantlife_background.png",
    spawn_func=spawn_img("data/biome_impl/rainforest/plantlife_background.png", 11, 18),
  },
  {
    name="Bar background",
    image="mods/raksa/files/gfx/bg_icons/66_bar_background.png",
    spawn_func=spawn_img("data/biome_impl/snowcastle/bar_background.png", 4, 1),
  },
  {
    name="Bedroom background",
    image="mods/raksa/files/gfx/bg_icons/67_bedroom_background.png",
    spawn_func=spawn_img("data/biome_impl/snowcastle/bedroom_background.png", 4, 1),
  },
  {
    name="Drill background",
    image="mods/raksa/files/gfx/bg_icons/68_drill_background.png",
    spawn_func=spawn_img("data/biome_impl/snowcastle/drill_background.png", 4, 10),
  },
  {
    name="Forge background",
    image="mods/raksa/files/gfx/bg_icons/69_forge_background.png",
    spawn_func=spawn_img("data/biome_impl/snowcastle/forge_background.png", 18, 5),
  },
  {
    name="Greenhouse background",
    image="mods/raksa/files/gfx/bg_icons/70_greenhouse_background.png",
    spawn_func=spawn_img("data/biome_impl/snowcastle/greenhouse_background.png", 1, 2),
  },
  {
    name="Pod large 01 background",
    image="mods/raksa/files/gfx/bg_icons/71_pod_large_01_background.png",
    spawn_func=spawn_img("data/biome_impl/snowcastle/pod_large_01_background.png", 1, 1),
  },
  {
    name="Pod small l 01 background",
    image="mods/raksa/files/gfx/bg_icons/72_pod_small_l_01_background.png",
    spawn_func=spawn_img("data/biome_impl/snowcastle/pod_small_l_01_background.png", 2, 1),
  },
  {
    name="Hourglass chamber background",
    image="mods/raksa/files/gfx/bg_icons/73_hourglass_chamber_background.png",
    spawn_func=spawn_img("data/biome_impl/snowcastle/hourglass_chamber_background.png", 81, 161),
  },
  {
    name="Sauna background",
    image="mods/raksa/files/gfx/bg_icons/74_sauna_background.png",
    spawn_func=spawn_img("data/biome_impl/snowcastle/sauna_background.png", 50, 56),
  },
  {
    name="Side cavern left background",
    image="mods/raksa/files/gfx/bg_icons/75_side_cavern_left_background.png",
    spawn_func=spawn_img("data/biome_impl/snowcastle/side_cavern_left_background.png", 7, 9),
  },
  {
    name="Side cavern right background",
    image="mods/raksa/files/gfx/bg_icons/76_side_cavern_right_background.png",
    spawn_func=spawn_img("data/biome_impl/snowcastle/side_cavern_right_background.png", 9, 9),
  },
  {
    name="Pod small r 01 background",
    image="mods/raksa/files/gfx/bg_icons/77_pod_small_r_01_background.png",
    spawn_func=spawn_img("data/biome_impl/snowcastle/pod_small_r_01_background.png", 11, 1),
  },
  {
    name="Horizontalobservatory background",
    image="mods/raksa/files/gfx/bg_icons/78_horizontalobservatory_background.png",
    spawn_func=spawn_img("data/biome_impl/snowcave/horizontalobservatory_background.png", 109, 14),
  },
  {
    name="Horizontalobservatory3 background",
    image="mods/raksa/files/gfx/bg_icons/79_horizontalobservatory3_background.png",
    spawn_func=spawn_img("data/biome_impl/snowcave/horizontalobservatory3_background.png", 184, 78),
  },
  {
    name="Horizontalobservatory2 background",
    image="mods/raksa/files/gfx/bg_icons/80_horizontalobservatory2_background.png",
    spawn_func=spawn_img("data/biome_impl/snowcave/horizontalobservatory2_background.png", 17, 19),
  },
  {
    name="Altar background",
    image="mods/raksa/files/gfx/bg_icons/81_altar_background.png",
    spawn_func=spawn_img("data/biome_impl/snowcave/altar_background.png", 68, 3),
  },
  {
    name="Puzzle capsule background",
    image="mods/raksa/files/gfx/bg_icons/82_puzzle_capsule_background.png",
    spawn_func=spawn_img("data/biome_impl/snowcave/puzzle_capsule_background.png", 5, 18),
  },
  {
    name="Snowcastle background",
    image="mods/raksa/files/gfx/bg_icons/83_snowcastle_background.png",
    spawn_func=spawn_img("data/biome_impl/snowcave/snowcastle_background.png", 46, 37),
  },
  {
    name="Puzzle capsule b background",
    image="mods/raksa/files/gfx/bg_icons/84_puzzle_capsule_b_background.png",
    spawn_func=spawn_img("data/biome_impl/snowcave/puzzle_capsule_b_background.png", 62, 248),
  },
  {
    name="Tinyobservatory2 background",
    image="mods/raksa/files/gfx/bg_icons/85_tinyobservatory2_background.png",
    spawn_func=spawn_img("data/biome_impl/snowcave/tinyobservatory2_background.png", 37, 12),
  },
  {
    name="Verticalobservatory2 background",
    image="mods/raksa/files/gfx/bg_icons/86_verticalobservatory2_background.png",
    spawn_func=spawn_img("data/biome_impl/snowcave/verticalobservatory2_background.png", 26, 2),
  },
  {
    name="Tinyobservatory background",
    image="mods/raksa/files/gfx/bg_icons/87_tinyobservatory_background.png",
    spawn_func=spawn_img("data/biome_impl/snowcave/tinyobservatory_background.png", 6, 7),
  },
  {
    name="Verticalobservatory background",
    image="mods/raksa/files/gfx/bg_icons/88_verticalobservatory_background.png",
    spawn_func=spawn_img("data/biome_impl/snowcave/verticalobservatory_background.png", 24, 175),
  },
  {
    name="Boss arena background",
    image="mods/raksa/files/gfx/bg_icons/89_boss_arena_background.png",
    spawn_func=spawn_img("data/biome_impl/spliced/boss_arena_background.png", 237, 562),
  },
  {
    name="Gourd room background",
    image="mods/raksa/files/gfx/bg_icons/90_gourd_room_background.png",
    spawn_func=spawn_img("data/biome_impl/spliced/gourd_room_background.png", 306, 392),
  },
  {
    name="Moon background",
    image="mods/raksa/files/gfx/bg_icons/92_moon_background.png",
    spawn_func=spawn_img("data/biome_impl/spliced/moon_background.png", 13, 8),
  },
  {
    name="Tree background",
    image="mods/raksa/files/gfx/bg_icons/93_tree_background.png",
    spawn_func=spawn_img("data/biome_impl/spliced/tree_background.png", 0, 0),
  },
  {
    name="Altar right background",
    image="mods/raksa/files/gfx/bg_icons/94_altar_right_background.png",
    spawn_func=spawn_img("data/biome_impl/temple/altar_right_background.png", 0, 0),
  },
  {
    name="Altar snowcastle capsule background",
    image="mods/raksa/files/gfx/bg_icons/95_altar_snowcastle_capsule_background.png",
    spawn_func=spawn_img("data/biome_impl/temple/altar_snowcastle_capsule_background.png", 17, 10),
  },
  {
    name="Altar left background",
    image="mods/raksa/files/gfx/bg_icons/96_altar_left_background.png",
    spawn_func=spawn_img("data/biome_impl/temple/altar_left_background.png", 205, 2),
  },
  {
    name="Altar background",
    image="mods/raksa/files/gfx/bg_icons/97_altar_background.png",
    spawn_func=spawn_img("data/biome_impl/temple/altar_background.png", 0, 0),
  },
  {
    name="Wall background",
    image="mods/raksa/files/gfx/bg_icons/98_wall_background.png",
    spawn_func=spawn_img("data/biome_impl/temple/wall_background.png", 0, 7),
  },
  {
    name="Wall top background",
    image="mods/raksa/files/gfx/bg_icons/99_wall_top_background.png",
    spawn_func=spawn_img("data/biome_impl/temple/wall_top_background.png", 2, 7),
  },
  {
    name="Mountain hall background",
    image="mods/raksa/files/gfx/bg_icons/101_mountain_hall_background.png",
    spawn_func=spawn_img("data/biome_impl/trailer/mountain_hall_background.png", 0, 0),
  },
  {
    name="Brain room background",
    image="mods/raksa/files/gfx/bg_icons/102_brain_room_background.png",
    spawn_func=spawn_img("data/biome_impl/vault/brain_room_background.png", 81, 100),
  },
  {
    name="Acidtank background",
    image="mods/raksa/files/gfx/bg_icons/103_acidtank_background.png",
    spawn_func=spawn_img("data/biome_impl/vault/acidtank_background.png", 0, 30),
  },
  {
    name="Catwalk 01 background",
    image="mods/raksa/files/gfx/bg_icons/104_catwalk_01_background.png",
    spawn_func=spawn_img("data/biome_impl/vault/catwalk_01_background.png", 0, 10),
  },
  {
    name="Catwalk 03 background",
    image="mods/raksa/files/gfx/bg_icons/105_catwalk_03_background.png",
    spawn_func=spawn_img("data/biome_impl/vault/catwalk_03_background.png", 0, 8),
  },
  {
    name="Catwalk 02 background",
    image="mods/raksa/files/gfx/bg_icons/106_catwalk_02_background.png",
    spawn_func=spawn_img("data/biome_impl/vault/catwalk_02_background.png", 0, 7),
  },
  {
    name="Lab2 background",
    image="mods/raksa/files/gfx/bg_icons/107_lab2_background.png",
    spawn_func=spawn_img("data/biome_impl/vault/lab2_background.png", 105, 93),
  },
  {
    name="Catwalk 04 background",
    image="mods/raksa/files/gfx/bg_icons/108_catwalk_04_background.png",
    spawn_func=spawn_img("data/biome_impl/vault/catwalk_04_background.png", 0, 1),
  },
  {
    name="Lab3 background",
    image="mods/raksa/files/gfx/bg_icons/109_lab3_background.png",
    spawn_func=spawn_img("data/biome_impl/vault/lab3_background.png", 103, 97),
  },
  {
    name="Catwalk 02b background",
    image="mods/raksa/files/gfx/bg_icons/110_catwalk_02b_background.png",
    spawn_func=spawn_img("data/biome_impl/vault/catwalk_02b_background.png", 0, 7),
  },
  {
    name="Electric tunnel room background",
    image="mods/raksa/files/gfx/bg_icons/111_electric_tunnel_room_background.png",
    spawn_func=spawn_img("data/biome_impl/vault/electric_tunnel_room_background.png", 30, 143),
  },
  {
    name="Lab background",
    image="mods/raksa/files/gfx/bg_icons/112_lab_background.png",
    spawn_func=spawn_img("data/biome_impl/vault/lab_background.png", 2, 2),
  },
  {
    name="Pillar 01 background",
    image="mods/raksa/files/gfx/bg_icons/113_pillar_01_background.png",
    spawn_func=spawn_img("data/biome_impl/vault/pillar_01_background.png", 10, 0),
  },
  {
    name="Pillar 03 background",
    image="mods/raksa/files/gfx/bg_icons/114_pillar_03_background.png",
    spawn_func=spawn_img("data/biome_impl/vault/pillar_03_background.png", 4, 0),
  },
  {
    name="Pillar base 01 background",
    image="mods/raksa/files/gfx/bg_icons/115_pillar_base_01_background.png",
    spawn_func=spawn_img("data/biome_impl/vault/pillar_base_01_background.png", 0, 0),
  },
  {
    name="Pillar 05 background",
    image="mods/raksa/files/gfx/bg_icons/116_pillar_05_background.png",
    spawn_func=spawn_img("data/biome_impl/vault/pillar_05_background.png", 6, 0),
  },
  {
    name="Pillar 04 background",
    image="mods/raksa/files/gfx/bg_icons/117_pillar_04_background.png",
    spawn_func=spawn_img("data/biome_impl/vault/pillar_04_background.png", 10, 0),
  },
  {
    name="Pillar base 02 background",
    image="mods/raksa/files/gfx/bg_icons/118_pillar_base_02_background.png",
    spawn_func=spawn_img("data/biome_impl/vault/pillar_base_02_background.png", 0, 0),
  },
  {
    name="Pillar 02 background",
    image="mods/raksa/files/gfx/bg_icons/119_pillar_02_background.png",
    spawn_func=spawn_img("data/biome_impl/vault/pillar_02_background.png", 10, 0),
  },
  {
    name="Warningstrip background",
    image="mods/raksa/files/gfx/bg_icons/120_warningstrip_background.png",
    spawn_func=spawn_img("data/biome_impl/vault/warningstrip_background.png", 0, 0),
  },
  {
    name="Acidtank 2 background",
    image="mods/raksa/files/gfx/bg_icons/121_acidtank_2_background.png",
    spawn_func=spawn_img("data/biome_impl/acidtank_2_background.png", 3, 2),
  },
  {
    name="Acidtank background",
    image="mods/raksa/files/gfx/bg_icons/122_acidtank_background.png",
    spawn_func=spawn_img("data/biome_impl/acidtank_background.png", 4, 2),
  },
  {
    name="Boss victoryroom background",
    image="mods/raksa/files/gfx/bg_icons/123_boss_victoryroom_background.png",
    spawn_func=spawn_img("data/biome_impl/boss_victoryroom_background.png", 0, 46),
  },
  {
    name="Bunker background",
    image="mods/raksa/files/gfx/bg_icons/124_bunker_background.png",
    spawn_func=spawn_img("data/biome_impl/bunker_background.png", 12, 2),
  },
  {
    name="Demonic altar background",
    image="mods/raksa/files/gfx/bg_icons/125_demonic_altar_background.png",
    spawn_func=spawn_img("data/biome_impl/demonic_altar_background.png", 128, 0),
  },
  {
    name="Essenceroom background",
    image="mods/raksa/files/gfx/bg_icons/126_essenceroom_background.png",
    spawn_func=spawn_img("data/biome_impl/essenceroom_background.png", 0, 0),
  },
  {
    name="Greed treasure background",
    image="mods/raksa/files/gfx/bg_icons/127_greed_treasure_background.png",
    spawn_func=spawn_img("data/biome_impl/greed_treasure_background.png", 108, 145),
  },
  {
    name="Fishing hut background",
    image="mods/raksa/files/gfx/bg_icons/128_fishing_hut_background.png",
    spawn_func=spawn_img("data/biome_impl/fishing_hut_background.png", 20, 11),
  },
  {
    name="Orbroom background",
    image="mods/raksa/files/gfx/bg_icons/129_orbroom_background.png",
    spawn_func=spawn_img("data/biome_impl/orbroom_background.png", 14, 29),
  },
  {
    name="Robot egg background",
    image="mods/raksa/files/gfx/bg_icons/130_robot_egg_background.png",
    spawn_func=spawn_img("data/biome_impl/robot_egg_background.png", 25, 69),
  },
  {
    name="Secret lab background",
    image="mods/raksa/files/gfx/bg_icons/131_secret_lab_background.png",
    spawn_func=spawn_img("data/biome_impl/secret_lab_background.png", 14, 71),
  },
  {
    name="Safe haven background",
    image="mods/raksa/files/gfx/bg_icons/132_safe_haven_background.png",
    spawn_func=spawn_img("data/biome_impl/safe_haven_background.png", 22, 11),
  },
  {
    name="Tank liquid 3 background",
    image="mods/raksa/files/gfx/bg_icons/133_tank_liquid_3_background.png",
    spawn_func=spawn_img("data/biome_impl/tank_liquid_3_background.png", 7, 16),
  },
  {
    name="Tank liquid 4 background",
    image="mods/raksa/files/gfx/bg_icons/134_tank_liquid_4_background.png",
    spawn_func=spawn_img("data/biome_impl/tank_liquid_4_background.png", 1, 33),
  },
  {
    name="1 visual",
    image="mods/raksa/files/gfx/bg_icons/135_1_visual.png",
    spawn_func=spawn_img("data/biome_impl/spliced/skull_in_desert/1_visual.png", 0, 0),
  },
  {
    name="Background cave 01",
    image="mods/raksa/files/gfx/bg_icons/136_background_cave_01.png",
    spawn_func=spawn_img("data/weather_gfx/background_cave_01.png", 0, 0),
  },
  {
    name="Background cave 02",
    image="mods/raksa/files/gfx/bg_icons/137_background_cave_02.png",
    spawn_func=spawn_img("data/weather_gfx/background_cave_02.png", 0, 0),
  },
  {
    name="Background cave 03",
    image="mods/raksa/files/gfx/bg_icons/138_background_cave_03.png",
    spawn_func=spawn_img("data/weather_gfx/background_cave_03.png", 0, 0),
  },
  {
    name="Background cave 04",
    image="mods/raksa/files/gfx/bg_icons/139_background_cave_04.png",
    spawn_func=spawn_img("data/weather_gfx/background_cave_04.png", 0, 0),
  },
  {
    name="Background cave 04 alt",
    image="mods/raksa/files/gfx/bg_icons/140_background_cave_04_alt.png",
    spawn_func=spawn_img("data/weather_gfx/background_cave_04_alt.png", 0, 0),
  },
  {
    name="Background cave 04 alt2",
    image="mods/raksa/files/gfx/bg_icons/141_background_cave_04_alt2.png",
    spawn_func=spawn_img("data/weather_gfx/background_cave_04_alt2.png", 0, 0),
  },
  {
    name="Background cave 04 alt3",
    image="mods/raksa/files/gfx/bg_icons/142_background_cave_04_alt3.png",
    spawn_func=spawn_img("data/weather_gfx/background_cave_04_alt3.png", 0, 0),
  },
  {
    name="Background cave 04 alt4",
    image="mods/raksa/files/gfx/bg_icons/143_background_cave_04_alt4.png",
    spawn_func=spawn_img("data/weather_gfx/background_cave_04_alt4.png", 0, 0),
  },
  {
    name="Background cave 04 alt5",
    image="mods/raksa/files/gfx/bg_icons/144_background_cave_04_alt5.png",
    spawn_func=spawn_img("data/weather_gfx/background_cave_04_alt5.png", 0, 0),
  },
  {
    name="Background cave 04 alt6",
    image="mods/raksa/files/gfx/bg_icons/145_background_cave_04_alt6.png",
    spawn_func=spawn_img("data/weather_gfx/background_cave_04_alt6.png", 0, 0),
  },
  {
    name="Background cave 04 alt7",
    image="mods/raksa/files/gfx/bg_icons/146_background_cave_04_alt7.png",
    spawn_func=spawn_img("data/weather_gfx/background_cave_04_alt7.png", 0, 0),
  },
  {
    name="Background cave 04 alt8",
    image="mods/raksa/files/gfx/bg_icons/147_background_cave_04_alt8.png",
    spawn_func=spawn_img("data/weather_gfx/background_cave_04_alt8.png", 0, 0),
  },
  {
    name="Background cave 04 alt9",
    image="mods/raksa/files/gfx/bg_icons/148_background_cave_04_alt9.png",
    spawn_func=spawn_img("data/weather_gfx/background_cave_04_alt9.png", 0, 0),
  },
  {
    name="Background cave 04 alt10",
    image="mods/raksa/files/gfx/bg_icons/149_background_cave_04_alt10.png",
    spawn_func=spawn_img("data/weather_gfx/background_cave_04_alt10.png", 0, 0),
  },
  {
    name="Background cave 07",
    image="mods/raksa/files/gfx/bg_icons/150_background_cave_07.png",
    spawn_func=spawn_img("data/weather_gfx/background_cave_07.png", 0, 0),
  },
  {
    name="Background cave 09",
    image="mods/raksa/files/gfx/bg_icons/151_background_cave_09.png",
    spawn_func=spawn_img("data/weather_gfx/background_cave_09.png", 0, 0),
  },
  {
    name="Background coalmine",
    image="mods/raksa/files/gfx/bg_icons/152_background_coalmine.png",
    spawn_func=spawn_img("data/weather_gfx/background_coalmine.png", 0, 0),
  },
  {
    name="Background crypt",
    image="mods/raksa/files/gfx/bg_icons/153_background_crypt.png",
    spawn_func=spawn_img("data/weather_gfx/background_crypt.png", 0, 0),
  },
  {
    name="Background excavationsite",
    image="mods/raksa/files/gfx/bg_icons/154_background_excavationsite.png",
    spawn_func=spawn_img("data/weather_gfx/background_excavationsite.png", 0, 0),
  },
  {
    name="Background fungicave 01",
    image="mods/raksa/files/gfx/bg_icons/155_background_fungicave_01.png",
    spawn_func=spawn_img("data/weather_gfx/background_fungicave_01.png", 0, 0),
  },
  {
    name="Background pyramid",
    image="mods/raksa/files/gfx/bg_icons/156_background_pyramid.png",
    spawn_func=spawn_img("data/weather_gfx/background_pyramid.png", 0, 0),
  },
  {
    name="Background rainforest",
    image="mods/raksa/files/gfx/bg_icons/157_background_rainforest.png",
    spawn_func=spawn_img("data/weather_gfx/background_rainforest.png", 0, 0),
  },
  {
    name="Background rainforest dark",
    image="mods/raksa/files/gfx/bg_icons/158_background_rainforest_dark.png",
    spawn_func=spawn_img("data/weather_gfx/background_rainforest_dark.png", 0, 0),
  },
  {
    name="Background snowcastle",
    image="mods/raksa/files/gfx/bg_icons/159_background_snowcastle.png",
    spawn_func=spawn_img("data/weather_gfx/background_snowcastle.png", 0, 0),
  },
  {
    name="Background snowcave",
    image="mods/raksa/files/gfx/bg_icons/160_background_snowcave.png",
    spawn_func=spawn_img("data/weather_gfx/background_snowcave.png", 0, 0),
  },
  {
    name="Background the end",
    image="mods/raksa/files/gfx/bg_icons/161_background_the_end.png",
    spawn_func=spawn_img("data/weather_gfx/background_the_end.png", 0, 0),
  },
  {
    name="Background vault",
    image="mods/raksa/files/gfx/bg_icons/162_background_vault.png",
    spawn_func=spawn_img("data/weather_gfx/background_vault.png", 0, 0),
  },
  {
    name="Background vault frozen",
    image="mods/raksa/files/gfx/bg_icons/163_background_vault_frozen.png",
    spawn_func=spawn_img("data/weather_gfx/background_vault_frozen.png", 0, 0),
  },
  {
    name="Background wandcave",
    image="mods/raksa/files/gfx/bg_icons/164_background_wandcave.png",
    spawn_func=spawn_img("data/weather_gfx/background_wandcave.png", 0, 0),
  },
  {
    name="Background wizardcave",
    image="mods/raksa/files/gfx/bg_icons/165_background_wizardcave.png",
    spawn_func=spawn_img("data/weather_gfx/background_wizardcave.png", 0, 0),
  },
}