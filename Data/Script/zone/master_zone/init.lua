require 'common'

local master_zone = {}
--------------------------------------------------
-- Map Callbacks
--------------------------------------------------
function master_zone.Init(zone)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> Init_master_zone")
  

end

function master_zone.AllyInteract(chara, target, zone)
  COMMON.DungeonInteract(chara, target, zone)
end

function master_zone.Rescued(zone, mail)
  COMMON.Rescued(zone, mail)
end

function master_zone.ExitSegment(zone, result, rescue, segmentID, mapID)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  
end

return master_zone