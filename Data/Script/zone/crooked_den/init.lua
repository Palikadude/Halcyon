require 'common'
require 'GeneralFunctions'

local crooked_den = {}
--------------------------------------------------
-- Map Callbacks
--------------------------------------------------
function crooked_den.Init(zone)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> Init_crooked_den")
  

end

function crooked_den.Rescued(zone, mail)
  COMMON.Rescued(zone, mail)
end

--This zone is only accessible through Chapter 3's boss fight.
function crooked_den.ExitSegment(zone, result, rescue, segmentID, mapID)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> ExitSegment_crooked_den (Crooked Den) result "..tostring(result).." segment "..tostring(segmentID))

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
	

return crooked_den