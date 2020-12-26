dofile_once("mods/raksa/files/scripts/enums.lua")


function toggle_kalma()
  if GlobalsGetBool(KALMA_IS_IMMORTAL) then
    GamePrint("You feel small and frail once again.")
  else
    GamePrint("You're feeling indestructible!")
  end

  GlobalsToggleBool(KALMA_IS_IMMORTAL)
end
