require 'common'

local backup_master_zone = {}
--------------------------------------------------
-- Map Callbacks
--------------------------------------------------
function backup_master_zone.Init(zone)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> Init_backup_master_zone")
  

end

function backup_master_zone.AllyInteract(chara, target, zone)
  COMMON.DungeonInteract(chara, target, zone)
end

function backup_master_zone.Rescued(zone, mail)
  COMMON.Rescued(zone, mail)
end

function backup_master_zone.ExitSegment(zone, result, rescue, segmentID, mapID)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine

  if segmentID == 0 then
    -- TODO: need to add an entrypoint for the boss battle's result, as well as a scripting variable for the boss battle's result
	-- if cleared, set a save variable
	-- if failed, a save variable
	if mapID == 3 then
	  COMMON.EndSession(result, "backup_master_zone",-1,3,0)
	else
	  PrintInfo("No exit procedure found!")
	end
  else
    PrintInfo("No exit procedure found!")
  end
end

return backup_master_zone