require 'common'
require 'GeneralFunctions'

local zone_55 = {}
--------------------------------------------------
-- Map Callbacks
--------------------------------------------------
function zone_55.Init(zone)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> Init_zone_55")
end

function zone_55.Rescued(zone, mail)
  COMMON.Rescued(zone, mail)
end


function zone_55.ExitSegment(zone, result, rescue, segmentID, mapID)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> ExitSegment_zone_55 (Fire Maze) result "..tostring(result).." segment "..tostring(segmentID))

	GAME:SetRescueAllowed(false)
	
	--[[Different dungeon result typeS (cleared, died, etc)
	       public enum ResultType
        {
            Unknown = -1,
            Downed,
            Failed,
            Cleared,
            Escaped,
            TimedOut,
            GaveUp,
            Rescue
        }
		]]--
	
	
	--flag zone 55 as last dojo zone
	SV.Dojo.LastZone = 55

	
	--Failed to clear
	if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then 
		SV.Dojo.TrainingFailedGeneric = true
		GeneralFunctions.EndDungeonRun(result, 0, -1, 36, 0, false, false)
	else--Cleared
		SV.Dojo.TrainingCompletedGeneric = true
		GeneralFunctions.EndDungeonRun(result, 0, -1, 36, 0, false, false)
	end
	
	
end
	

return zone_55
