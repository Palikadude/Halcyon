require 'common'

local zone_0 = {}
--------------------------------------------------
-- Map Callbacks
--------------------------------------------------
function zone_0.Init(zone)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> Init_zone_0")
  

end

function zone_0.AllyInteract(chara, target, zone)
  COMMON.DungeonInteract(chara, target, zone)
end

function zone_0.Rescued(zone, mail)
  COMMON.Rescued(zone, mail)
end

function zone_0.ExitSegment(zone, result, rescue, segmentID, mapID)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  
end

return zone_0