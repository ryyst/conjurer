dofile_once("mods/raksa/files/scripts/enums.lua")


function handle_zoom_setting()
  local zoom = ModSettingGet("raksa.zoom_level")
  if zoom == "noita" then
    -- Nothing needs overwriting
    return
  end

  -- Change the actual zoom level
  local ZOOM_LEVELS = {
    conjurer="mods/raksa/files/overrides/resolution_conjurer.xml",
    huge="mods/raksa/files/overrides/resolution_huge.xml",
    fullhd="mods/raksa/files/overrides/resolution_fullhd.xml",
  }

  ModMagicNumbersFileAdd(ZOOM_LEVELS[zoom])


  -- Make the fog of war shader match the zoom level.
  --
  -- Note for `fullhd`:
  -- The zoom level breaks so much it actually doesn't even care about the shader
  -- anymore, so just make it same as the `huge` and call it a day.
  local FOW_SHADERS = {
    conjurer="mods/raksa/files/overrides/resolution_conjurer.vert",
    huge="mods/raksa/files/overrides/resolution_huge.vert",
    fullhd="mods/raksa/files/overrides/resolution_huge.vert",
  }
  ModTextFileSetContent(
    "data/shaders/post_final.vert",
    ModTextFileGetContent(FOW_SHADERS[zoom])
  )
end
