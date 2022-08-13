require 'common'
require 'GeneralFunctions'

local zone_58 = {}
--------------------------------------------------
-- Map Callbacks
--------------------------------------------------
function zone_58.Init(zone)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> Init_zone_58")
  

end

function zone_58.Rescued(zone, mail)
  COMMON.Rescued(zone, mail)
end

--This zone is only accessible through Chapter 3's boss fight.
function zone_58.ExitSegment(zone, result, rescue, segmentID, mapID)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> ExitSegment_zone_58 (Crooked Den) result "..tostring(result).." segment "..tostring(segmentID))

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
	if result == RogueEssence.Data.GameProgress.ResultType.Escaped then--this should go unused due to the mysterious force
		SV.Chapter3.EscapedBoss = true
	elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
		SV.Chapter3.LostToBoss = true
	else 
		SV.Chapter3.DefeatedBoss = true
	end
	
	GeneralFunctions.EndDungeonRun(result, 0, -1, 42, 0, false, false) --Go to Crooked Den ground map


end
	

return zone_58