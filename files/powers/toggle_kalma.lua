dofile_once("mods/raksa/files/scripts/enums.lua")


function toggle_kalma()
  if HasFlagPersistent(KALMA_RECALL_FLAG) then
    RemoveFlagPersistent(KALMA_RECALL_FLAG)
    GamePrint("You gained immortality.")
  else
    AddFlagPersistent(KALMA_RECALL_FLAG)
    GamePrint("You abandoned your immortality.")
  end
end
