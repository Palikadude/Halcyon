require 'common'
require 'GeneralFunctions'

local water_maze = {}
--------------------------------------------------
-- Map Callbacks
--------------------------------------------------
function water_maze.Init(zone)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> Init_water_maze")
end

function water_maze.Rescued(zone, mail)
  COMMON.Rescued(zone, mail)
end


function water_maze.ExitSegment(zone, result, rescue, segmentID, mapID)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> ExitSegment_water_maze (Water Maze) result "..tostring(result).." segment "..tostring(segmentID))

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
	
	
	--flag zone 56 as last dojo zone
	SV.Dojo.LastZone = "water_maze"

	
	--Failed to clear
	if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then 
		SV.Dojo.TrainingFailedGeneric = true
	else--Cleared
		SV.Dojo.TrainingCompletedGeneric = true
	end
	
	GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 36, 0, false, false)

end
	

return water_maze
