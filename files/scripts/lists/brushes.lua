dofile_once("mods/raksa/files/wands/matwand/custom_tools.lua")


local _radial_warning="---\nWARNING: Test before applying!\n- Goes through same material\n- Can easily ruin things when not careful\n- Heavy on performance\n- But really fun to use when you get the hang of it!"


BRUSHES = {
  {
    name="1px brush",
    desc="---\nWorks badly with solids, try other material types!",
    offset_x=1,
    offset_y=0,
    reticle_file="mods/raksa/files/wands/matwand/brushes/1_reticle.png",
    brush_file="mods/raksa/files/wands/matwand/brushes/1_brush.png",
    icon_file="mods/raksa/files/wands/matwand/brushes/1_icon.png",
    physics_supported=true,
  },
  {
    name="2px brush",
    offset_x=1,
    offset_y=1,
    reticle_file="mods/raksa/files/wands/matwand/brushes/2_reticle.png",
    brush_file="mods/raksa/files/wands/matwand/brushes/2_brush.png",
    icon_file="mods/raksa/files/wands/matwand/brushes/2_icon.png",
    physics_supported=true,
  },
  {
    name="5px brush",
    offset_x=3,
    offset_y=2,
    reticle_file="mods/raksa/files/wands/matwand/brushes/5_reticle.png",
    brush_file="mods/raksa/files/wands/matwand/brushes/5_brush.png",
    icon_file="mods/raksa/files/wands/matwand/brushes/5_icon.png",
    physics_supported=true,
  },
  {
    name="10px brush",
    offset_x=5,
    offset_y=5,
    reticle_file="mods/raksa/files/wands/matwand/brushes/10_reticle.png",
    brush_file="mods/raksa/files/wands/matwand/brushes/10_brush.png",
    icon_file="mods/raksa/files/wands/matwand/brushes/10_icon.png",
    physics_supported=true,
  },
  {
    name="20px brush",
    offset_x=10,
    offset_y=10,
    reticle_file="mods/raksa/files/wands/matwand/brushes/20_reticle.png",
    brush_file="mods/raksa/files/wands/matwand/brushes/20_brush.png",
    icon_file="mods/raksa/files/wands/matwand/brushes/20_icon.png",
    physics_supported=true,
  },
  {
    name="40px brush",
    offset_x=20,
    offset_y=20,
    reticle_file="mods/raksa/files/wands/matwand/brushes/40_reticle.png",
    brush_file="mods/raksa/files/wands/matwand/brushes/40_brush.png",
    icon_file="mods/raksa/files/wands/matwand/brushes/40_icon.png",
    physics_supported=true,
  },
  {
    name="80px brush",
    offset_x=40,
    offset_y=40,
    reticle_file="mods/raksa/files/wands/matwand/brushes/80_reticle.png",
    brush_file="mods/raksa/files/wands/matwand/brushes/80_brush.png",
    icon_file="mods/raksa/files/wands/matwand/brushes/80_icon.png",
    physics_supported=true,
  },
  {
    name="40px long horizontal",
    offset_x=20,
    offset_y=1,
    reticle_file="mods/raksa/files/wands/matwand/brushes/40_lh_reticle.png",
    brush_file="mods/raksa/files/wands/matwand/brushes/40_lh_brush.png",
    icon_file="mods/raksa/files/wands/matwand/brushes/40_lh_icon.png",
    physics_supported=true,
  },
  {
    name="40px long vertical",
    offset_x=1,
    offset_y=20,
    reticle_file="mods/raksa/files/wands/matwand/brushes/40_lv_reticle.png",
    brush_file="mods/raksa/files/wands/matwand/brushes/40_lv_brush.png",
    icon_file="mods/raksa/files/wands/matwand/brushes/40_lv_icon.png",
    physics_supported=true,
  },
  {
    name="40px diagonal brush 1",
    offset_x=20,
    offset_y=20,
    reticle_file="mods/raksa/files/wands/matwand/brushes/40_d1_reticle.png",
    brush_file="mods/raksa/files/wands/matwand/brushes/40_d1_brush.png",
    icon_file="mods/raksa/files/wands/matwand/brushes/40_d1_icon.png",
    physics_supported=true,
  },
  {
    name="40px diagonal brush 2",
    offset_x=20,
    offset_y=20,
    reticle_file="mods/raksa/files/wands/matwand/brushes/40_d2_reticle.png",
    brush_file="mods/raksa/files/wands/matwand/brushes/40_d2_brush.png",
    icon_file="mods/raksa/files/wands/matwand/brushes/40_d2_icon.png",
    physics_supported=true,
  },
  {
    name="40px hollow box brush",
    offset_x=20,
    offset_y=20,
    reticle_file="mods/raksa/files/wands/matwand/brushes/40_box_reticle.png",
    brush_file="mods/raksa/files/wands/matwand/brushes/40_box_brush.png",
    icon_file="mods/raksa/files/wands/matwand/brushes/40_box_icon.png",
    physics_supported=true,
  },
  {
    name="40px triangle-up brush",
    offset_x=20,
    offset_y=20,
    reticle_file="mods/raksa/files/wands/matwand/brushes/40_tri_reticle.png",
    brush_file="mods/raksa/files/wands/matwand/brushes/40_tri_brush.png",
    icon_file="mods/raksa/files/wands/matwand/brushes/40_tri_icon.png",
    physics_supported=true,
  },
  {
    name="40px triangle-right brush",
    offset_x=20,
    offset_y=20,
    reticle_file="mods/raksa/files/wands/matwand/brushes/40_trir_reticle.png",
    brush_file="mods/raksa/files/wands/matwand/brushes/40_trir_brush.png",
    icon_file="mods/raksa/files/wands/matwand/brushes/40_trir_icon.png",
    physics_supported=true,
  },
  {
    name="40px triangle-down brush",
    offset_x=20,
    offset_y=20,
    reticle_file="mods/raksa/files/wands/matwand/brushes/40_trid_reticle.png",
    brush_file="mods/raksa/files/wands/matwand/brushes/40_trid_brush.png",
    icon_file="mods/raksa/files/wands/matwand/brushes/40_trid_icon.png",
    physics_supported=true,
  },
  {
    name="40px triangle-left brush",
    offset_x=20,
    offset_y=20,
    reticle_file="mods/raksa/files/wands/matwand/brushes/40_tril_reticle.png",
    brush_file="mods/raksa/files/wands/matwand/brushes/40_tril_brush.png",
    icon_file="mods/raksa/files/wands/matwand/brushes/40_tril_icon.png",
    physics_supported=true,
  },
  {
    name="40px circular brush",
    offset_x=20,
    offset_y=20,
    reticle_file="mods/raksa/files/wands/matwand/brushes/40_cir_reticle.png",
    brush_file="mods/raksa/files/wands/matwand/brushes/40_cir_brush.png",
    icon_file="mods/raksa/files/wands/matwand/brushes/40_cir_icon.png",
    physics_supported=true,
  },
  {
    name="Cauldron",
    offset_x=12,
    offset_y=13,
    reticle_file="mods/raksa/files/wands/matwand/brushes/cauldron_reticle.png",
    brush_file="mods/raksa/files/wands/matwand/brushes/cauldron_brush.png",
    icon_file="mods/raksa/files/wands/matwand/brushes/cauldron_icon.png",
    physics_supported=true,
  },
}

GROWERS = {
  {
    name="Tree",
    desc=_radial_warning,
    offset_x=5,
    offset_y=5,
    reticle_file="mods/raksa/files/wands/matwand/brushes/tree_2_reticle.png",
    brush_file="mods/raksa/files/wands/matwand/brushes/tree_2_brush.png",
    icon_file="mods/raksa/files/wands/matwand/brushes/tree_2_icon.png",
    click_to_use=true,
    physics_supported=false,
    raytrace_from_center=true,
  },
  {
    name="Small Radial Expander",
    desc=_radial_warning,
    offset_x=5,
    offset_y=5,
    reticle_file="mods/raksa/files/wands/matwand/brushes/radial_xs_reticle.png",
    brush_file="mods/raksa/files/wands/matwand/brushes/radial_xs_brush.png",
    icon_file="mods/raksa/files/wands/matwand/brushes/radial_xs_icon.png",
    click_to_use=true,
    physics_supported=false,
    raytrace_from_center=true,
  },
  {
    name="Medium Radial Expander",
    desc=_radial_warning,
    offset_x=5,
    offset_y=5,
    reticle_file="mods/raksa/files/wands/matwand/brushes/radial_s_reticle.png",
    brush_file="mods/raksa/files/wands/matwand/brushes/radial_s_brush.png",
    icon_file="mods/raksa/files/wands/matwand/brushes/radial_s_icon.png",
    click_to_use=true,
    physics_supported=false,
    raytrace_from_center=true,
  },
  {
    name="Large Radial Expander",
    desc=_radial_warning,
    offset_x=5,
    offset_y=5,
    reticle_file="mods/raksa/files/wands/matwand/brushes/radial_m_reticle.png",
    brush_file="mods/raksa/files/wands/matwand/brushes/radial_m_brush.png",
    icon_file="mods/raksa/files/wands/matwand/brushes/radial_m_icon.png",
    click_to_use=true,
    physics_supported=false,
    raytrace_from_center=true,
  },
  {
    name="Huge Radial Expander",
    desc=_radial_warning,
    offset_x=5,
    offset_y=5,
    reticle_file="mods/raksa/files/wands/matwand/brushes/radial_l_reticle.png",
    brush_file="mods/raksa/files/wands/matwand/brushes/radial_l_brush.png",
    icon_file="mods/raksa/files/wands/matwand/brushes/radial_l_icon.png",
    click_to_use=true,
    physics_supported=false,
    raytrace_from_center=true,
  },
}

TOOLS = {
  {
    name="Filler Tool",
    desc="---\n[HOLD] to fill and [RELEASE] to apply\nWARNING: Can leak from edges if held too long!\nApply in small doses.",
    offset_x=5,
    offset_y=5,
    reticle_file="mods/raksa/files/wands/matwand/brushes/filler_reticle.png",
    brush_file="mods/raksa/files/wands/matwand/brushes/filler_brush.png",
    icon_file="mods/raksa/files/wands/matwand/brushes/filler_icon.png",
    click_to_use=true,
    physics_supported=true,
    action=filler_action,
    release_action=filler_release_action,
  },
  {
    name="Line tool",
    desc="---\n[HOLD] to draw and [RELEASE] to apply",
    offset_x=0,
    offset_y=0,
    reticle_file="mods/raksa/files/wands/matwand/brushes/0_reticle.png",
    brush_file="mods/raksa/files/wands/matwand/brushes/scaled_brush.png",
    icon_file="mods/raksa/files/wands/matwand/brushes/line_icon.png",
    physics_supported=true,
    click_to_use=false,
    action=line_action,
    release_action=dragger_release_action,
  },
  {
    name="Rectangle tool",
    desc="---\n[HOLD] to draw  and [RELEASE] to apply",
    offset_x=0,
    offset_y=0,
    reticle_file="mods/raksa/files/wands/matwand/brushes/0_reticle.png",
    brush_file="mods/raksa/files/wands/matwand/brushes/scaled_brush.png",
    icon_file="mods/raksa/files/wands/matwand/brushes/rectangle_icon.png",
    brush_sprite_size=1,
    physics_supported=true,
    click_to_use=false,
    action=corner_aligned_polygon_action,
    release_action=dragger_release_action,
  },
  {
    name="Ellipse tool",
    desc="---\n[HOLD] to draw and [RELEASE] to apply",
    offset_x=0,
    offset_y=0,
    reticle_file="mods/raksa/files/wands/matwand/brushes/0_reticle.png",
    brush_file="mods/raksa/files/wands/matwand/brushes/scaled_brush_circle.png",
    icon_file="mods/raksa/files/wands/matwand/brushes/circle_icon.png",
    brush_sprite_size=500,
    physics_supported=true,
    click_to_use=false,
    action=corner_aligned_polygon_action,
    release_action=dragger_release_action,
  },
  {
    name="Rectangle tool, hollow",
    desc="---\n[HOLD] to draw [RELEASE] to apply",
    offset_x=0,
    offset_y=0,
    reticle_file="mods/raksa/files/wands/matwand/brushes/0_reticle.png",
    brush_file="mods/raksa/files/wands/matwand/brushes/scaled_brush_empty.png",
    icon_file="mods/raksa/files/wands/matwand/brushes/rectangle_icon_empty.png",
    brush_sprite_size=500,
    physics_supported=true,
    click_to_use=false,
    action=corner_aligned_polygon_action,
    release_action=dragger_release_action,
  },
  {
    name="Ellipse tool, hollow",
    desc="---\n[HOLD] to draw and [RELEASE] to apply",
    offset_x=0,
    offset_y=0,
    reticle_file="mods/raksa/files/wands/matwand/brushes/0_reticle.png",
    brush_file="mods/raksa/files/wands/matwand/brushes/scaled_brush_circle_empty.png",
    icon_file="mods/raksa/files/wands/matwand/brushes/circle_icon_empty.png",
    brush_sprite_size=500,
    physics_supported=true,
    click_to_use=false,
    action=corner_aligned_polygon_action,
    release_action=dragger_release_action,
  },
}


ALL_DRAWING_TOOLS = {
  {
    name="Brushes",
    tooltip="Basic brushes for drawing",
    brushes=BRUSHES,
  },
  {
    name="Growing brushes",
    tooltip="Time-based brushes for more exciting drawing action",
    brushes=GROWERS,
  },
  {
    name="Tools",
    tooltip="More specialized tools",
    brushes=TOOLS,
  },
}

-- Helps avoid circular imports
return ALL_DRAWING_TOOLS
