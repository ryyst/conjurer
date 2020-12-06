dofile_once("mods/raksa/files/scripts/enums.lua")


function toggle_kalma()
  if GlobalsGetValue(KALMA_IS_IMMORTAL, "0") == "1" then
    GlobalsSetValue(KALMA_IS_IMMORTAL, "0")
    GamePrint("You feel small and frail once again.")
  else
    GlobalsSetValue(KALMA_IS_IMMORTAL, "1")
    GamePrint("You're feeling indestructible!")
  end
end
