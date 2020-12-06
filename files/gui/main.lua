dofile("data/scripts/lib/coroutines.lua")
dofile("data/scripts/lib/utilities.lua")

dofile_once("mods/raksa/files/scripts/utilities.lua")

dofile_once("mods/raksa/files/gui/matwand.lua")
dofile_once("mods/raksa/files/gui/entwand.lua")
dofile_once("mods/raksa/files/gui/powers.lua")


local GUI = GuiCreate()

async_loop(function()
  if GUI ~= nil then
    GuiStartFrame(GUI)
  end

  if GameIsInventoryOpen() == false then
    local wand = EntityGetName(get_active_wand())

    if wand == "matwand" then
      render_matwand(GUI, 1000)
    elseif wand == "entwand" then
      render_entwand(GUI, 2000)
    end

    -- Don't show any GUI when the player is polymorphed,
    -- checking if we have an active wand works nicely for now.
    if wand then
      GuiOptionsAdd(GUI, GUI_OPTION.NoPositionTween)
      render_powers(GUI, 3000)
    end
  end

  wait(0)
end)
