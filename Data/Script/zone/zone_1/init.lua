require 'common'

local zone_1 = {}
--------------------------------------------------
-- Map Callbacks
--------------------------------------------------
function zone_1.Init(zone)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> Init_zone_1")
  

end

function zone_1.AllyInteract(chara, target, zone)
  COMMON.DungeonInteract(chara, target, zone)
end

function zone_1.Rescued(zone, mail)
  COMMON.Rescued(zone, mail)
end

function zone_1.ExitSegment(zone, result, rescue, segmentID, mapID)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine

  if segmentID == 0 then
    -- TODO: need to add an entrypoint for the boss battle's result, as well as a scripting variable for the boss battle's result
	-- if cleared, set a save variable
	-- if failed, a save variable
	if mapID == 3 then
	  COMMON.EndSession(result, 1,-1,3,0)
	else
	  PrintInfo("No exit procedure found!")
	end
  else
    PrintInfo("No exit procedure found!")
  end
end

return zone_1