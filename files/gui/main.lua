dofile("data/scripts/lib/coroutines.lua")
dofile("data/scripts/lib/utilities.lua")

dofile_once("mods/raksa/files/scripts/utilities.lua")

dofile_once("mods/raksa/files/lib/gui.lua")

dofile_once("mods/raksa/files/gui/matwand.lua")
dofile_once("mods/raksa/files/gui/entwand.lua")
dofile_once("mods/raksa/files/gui/powers.lua")



async_loop(function()
  if GUI ~= nil then
    GuiStartFrame(GUI)
    GuiOptionsAdd(GUI, GUI_OPTION.NoPositionTween)
  end

  -- Start button ID counter from 0 every frame
  RESET_BID()

  if GameIsInventoryOpen() == false then
    local wand = EntityGetName(get_active_wand())

    if wand == "matwand" then
      render_matwand()
    elseif wand == "entwand" then
      render_entwand()
    end

    -- Don't show any GUI when the player is polymorphed,
    -- checking if we have an active wand works nicely for now.
    if wand then
      render_powers()
    end
  end

  wait(0)
end)
