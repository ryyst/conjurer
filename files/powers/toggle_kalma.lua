dofile_once("mods/raksa/files/scripts/enums.lua")
dofile_once("mods/raksa/files/scripts/utilities.lua")


function toggle_kalma()
  local player = get_player()

  if GlobalsGetBool(KALMA_IS_IMMORTAL) then
    EntityRemoveTag(player, "polymorphable_NOT")
    GamePrint("You feel small and frail once again.")
  else
    EntityAddTag(player, "polymorphable_NOT")
    GamePrint("You're feeling indestructible!")
  end

  GlobalsToggleBool(KALMA_IS_IMMORTAL)
end
