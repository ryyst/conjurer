dofile("data/scripts/lib/mod_settings.lua")


local mod_id = "raksa"

mod_settings_version = 1
mod_settings =
{
  {
    category_id = "general_settings",
    ui_name = "General",
    settings = {
      {
        id = "zoom_level",
        ui_name = "Zoom level",
        ui_description = [[How much do you want to see? Heavily affects performance.
WARNING: Big resolutions are glitchy, and probably not useful
for anything but screenshots.]],
        value_default = "conjurer",
        values = {
          {"conjurer", "Conjurer"}, {"noita", "Noita"},
          {"huge", "Big (2x Noita)"}, {"fullhd", "Full HD (4.5x Noita)"}
        },
        scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
      },
      {
        id = "map_selection",
        ui_name = "Map selection",
        ui_description = "Which map do you want to play as the Conjurer?",
        value_default = "conjurer",
        values = { {"conjurer", "Conjurer"}, {"noita", "Noita"} },
        scope = MOD_SETTING_SCOPE_NEW_GAME,
      },
    },
  },
  {
    category_id = "control_settings",
    ui_name = "Controls",
    settings = {
      {
        id = "secondary_button",
        ui_name = "Secondary button scheme",
        ui_description = "Which button do you want to use for erasing/removing action?",
        value_default = "mouse2",
        values = { {"throw", "Throw"}, {"mouse2", "Mouse2"} },
        scope = MOD_SETTING_SCOPE_RUNTIME,
      },
    },
  },
  {
    category_id = "control_settings",
    ui_name = [[,
!   NOTICE!
!
!   If you experience problems using [Restart with enabled mods active]
!   it is advised to rather just [Save & Quit] and [Continue].
!
!   Quick restart is known to mess up at least the following:
!     1. Selected zoom level
!     2. The tower background
!     3. Custom Staff GUI
`
    ]],
    settings = {},
  },
}


function ModSettingsUpdate( init_scope )
  local old_version = mod_settings_get_version( mod_id ) -- This can be used to migrate some settings between mod versions.
  mod_settings_update( mod_id, mod_settings, init_scope )
end


function ModSettingsGuiCount()
  return mod_settings_gui_count( mod_id, mod_settings )
end


function ModSettingsGui( gui, in_main_menu )
  mod_settings_gui( mod_id, mod_settings, gui, in_main_menu )
end
