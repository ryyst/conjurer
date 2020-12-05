dofile_once("mods/raksa/files/scripts/enums.lua")


function toggle_kalma()
  if HasFlagPersistent(KALMA_RECALL_FLAG) then
    RemoveFlagPersistent(KALMA_RECALL_FLAG)
  else
    AddFlagPersistent(KALMA_RECALL_FLAG)
  end
end
