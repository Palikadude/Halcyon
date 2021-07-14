require 'common'

local zone_20 = {}
--------------------------------------------------
-- Map Callbacks
--------------------------------------------------
function zone_20.Init(zone)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> Init_zone_20")
  

end

function zone_20.AllyInteract(chara, target, zone)
  COMMON.DungeonInteract(chara, target, zone)
end

function zone_20.Rescued(zone, mail)
  COMMON.Rescued(zone, mail)
end

function zone_20.ExitSegment(zone, result, rescue, segmentID, mapID)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> ExitSegment_zone_20 result "..tostring(result).." segment "..tostring(segmentID))
  
  --first check for rescue flag; if we're in rescue mode then take a different path
  if rescue == true then
    COMMON.EndRescue(zone, result, segmentID)
  elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
    COMMON.EndDungeonDay(result, SV.checkpoint.Zone, SV.checkpoint.Structure, SV.checkpoint.Map, SV.checkpoint.Entry)
  else
    if segmentID == 0 then
      COMMON.EndDungeonDay(result, 1, -1, 4, 0)
    else
      PrintInfo("No exit procedure found!")
    end
  end
  
end

return zone_20
