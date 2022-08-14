require 'common'
require 'GeneralFunctions'

local fire_maze = {}
--------------------------------------------------
-- Map Callbacks
--------------------------------------------------
function fire_maze.Init(zone)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> Init_fire_maze")
end

function fire_maze.Rescued(zone, mail)
  COMMON.Rescued(zone, mail)
end


function fire_maze.ExitSegment(zone, result, rescue, segmentID, mapID)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> ExitSegment_fire_maze (Fire Maze) result "..tostring(result).." segment "..tostring(segmentID))

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
	SV.Dojo.LastZone = "fire_maze"

	
	--Failed to clear
	if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then 
		SV.Dojo.TrainingFailedGeneric = true
	else--Cleared
		SV.Dojo.TrainingCompletedGeneric = true
	end
	
	GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 36, 0, false, false)
	
end
	

return fire_maze
