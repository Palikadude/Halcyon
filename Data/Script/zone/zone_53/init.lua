require 'common'
require 'GeneralFunctions'

local zone_53 = {}
--------------------------------------------------
-- Map Callbacks
--------------------------------------------------
function zone_53.Init(zone)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> Init_zone_53")
  

end

function zone_53.Rescued(zone, mail)
  COMMON.Rescued(zone, mail)
end


function zone_53.ExitSegment(zone, result, rescue, segmentID, mapID)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> ExitSegment_zone_53 (Illuminant Riverbed) result "..tostring(result).." segment "..tostring(segmentID))

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
	if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
		if not SV.Chapter2.FinishedRiver and result ~= RogueEssence.Data.GameProgress.ResultType.Escaped then --team died before making it to the end for the first time. 
			UI:SetSpeaker(GAME:GetPlayerPartyMember(1))--set partner as speaker 
			UI:SetSpeakerEmotion("Pain")
			UI:WaitShowDialogue("Urgh...[pause=0] That didn't go well...")
		end
		
		--set generic flags for generic end of day / start of next day.
		SV.TemporaryFlags.Dinnertime = true 
		SV.TemporaryFlags.Bedtime = true
		SV.TemporaryFlags.MorningWakeup = true 
		SV.TemporaryFlags.MorningAddress = true 
			
		GAME:WaitFrames(60)
		
		--go to dinner room 
		GeneralFunctions.EndDungeonRun(result, 0, -1, 6, 0, false, false)

	
	else 
		--dont set generic end flags if it's chapter 2 (i.e. you're rescuing numel)
		if SV.ChapterProgression.Chapter ~= 2 then 
			--set generic flags for generic end of day / start of next day.
			SV.TemporaryFlags.Dinnertime = true 
			SV.TemporaryFlags.Bedtime = true
			SV.TemporaryFlags.MorningWakeup = true 
			SV.TemporaryFlags.MorningAddress = true 
		end
						
		--Go to Luminous Spring 
		GeneralFunctions.EndDungeonRun(result, 0, -1, 20, 0, false, false)
	end
end
	

return zone_53