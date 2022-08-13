require 'common'
require 'GeneralFunctions'

local zone_52 = {}
--------------------------------------------------
-- Map Callbacks
--------------------------------------------------
function zone_52.Init(zone)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> Init_zone_52")
end

function zone_52.Rescued(zone, mail)
  COMMON.Rescued(zone, mail)
end


function zone_52.ExitSegment(zone, result, rescue, segmentID, mapID)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> ExitSegment_zone_52 (Normal Maze) result "..tostring(result).." segment "..tostring(segmentID))

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
	
	
	--flag zone 52 as last dojo zone
	SV.Dojo.LastZone = 52

	
	--failed or gave up on the initial training
	if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then 
		if SV.ChapterProgression.Chapter == 2 then
			--If we've completed the training already, then flag a generic ending to the training. Otherwise, flag nothing.
			if SV.Chapter2.StartedTraining and SV.Chapter2.FinishedTraining then--generic ending
				SV.Dojo.TrainingFailedGeneric = true
			end 
		else--generic ending
			SV.Dojo.TrainingFailedGeneric = true
		end
	--passed initial training
	else
		if SV.ChapterProgression.Chapter == 2 then
            --We have started the initial training but haven't finished it yet            
            if SV.Chapter2.StartedTraining and not SV.Chapter2.FinishedTraining then
                SV.Chapter2.FinishedTraining = true
            else--generic ending
                SV.Dojo.TrainingCompletedGeneric = true
            end 
		else--generic ending
			SV.Dojo.TrainingCompletedGeneric = true
		end
	end
	
	
	--after setting flags, save the dungeon run and then go to the dojo.
	GAME:EndDungeonRun(result, 0, -1, 36, 0, false, false)			
	GAME:EnterZone(0, -1, 36, 0)
end
	

return zone_52
