require 'common'
require 'GeneralFunctions'

local zone_50 = {}
--------------------------------------------------
-- Map Callbacks
--------------------------------------------------
function zone_50.Init(zone)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> Init_zone_50")
  

end

function zone_50.Rescued(zone, mail)
  COMMON.Rescued(zone, mail)
end


function zone_50.ExitSegment(zone, result, rescue, segmentID, mapID)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> ExitSegment_zone_50 (Relic Forest) result "..tostring(result).." segment "..tostring(segmentID))

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
	if SV.ChapterProgression.Chapter == 1 then 
		GeneralFunctions.EndDungeonRun(result, 0, -1, 0, 0, false, false)
		if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
		
			if SV.Chapter1.PartnerEnteredForest and not SV.Chapter1.PartnerCompletedForest then--partner died solo before clearing
				GAME:EnterGroundMap("altere_pond", "Main_Entrance_Marker")
				
			elseif SV.Chapter1.PartnerCompletedForest then--the duo wiped before making it back to town
				GAME:EnterGroundMap("relic_forest", "Main_Entrance_Marker")
			
			else --failsafe

			end
		else 
		
			if SV.Chapter1.PartnerEnteredForest and not SV.Chapter1.PartnerCompletedForest then--partner made it through solo
				SV.Chapter1.PartnerCompletedForest = true		
				GAME:EnterGroundMap("relic_forest", "Main_Entrance_Marker")	
				
			elseif SV.Chapter1.PartnerCompletedForest then--the duo made it back to town
				SV.Chapter1.TeamCompletedForest = true
				GAME:EnterGroundMap("altere_pond", "Main_Entrance_Marker")
				
			else--failsafe 

			end
		end
	else--todo: generic case (no special cutscenes to be played)
		if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
				SV.DungeonFlags.GenericEnding = true
		elseif result == RogueEssence.Data.GameProgress.ResultType.Escaped then
				--???
		else
		
		end
	end
end
	

return zone_50