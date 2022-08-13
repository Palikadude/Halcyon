require 'common'
require 'GeneralFunctions'

local crooked_cavern = {}
--------------------------------------------------
-- Map Callbacks
--------------------------------------------------
function crooked_cavern.Init(zone)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> Init_crooked_cavern")
  
  --Mark this as the last dungeon entered.
  SV.TemporaryFlags.LastDungeonEntered = 57

end

function crooked_cavern.Rescued(zone, mail)
  COMMON.Rescued(zone, mail)
end


function crooked_cavern.ExitSegment(zone, result, rescue, segmentID, mapID)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> ExitSegment_crooked_cavern (Crooked Cavern) result "..tostring(result).." segment "..tostring(segmentID))

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

		GAME:WaitFrames(20)
		
		if not SV.Chapter3.DefeatedBoss and result ~= RogueEssence.Data.GameProgress.ResultType.Escaped then --team died before making it to the end for the first time. 
			UI:SetSpeaker(GAME:GetPlayerPartyMember(1))--set partner as speaker 
			UI:SetSpeakerEmotion("Pain")
			UI:WaitShowDialogue("Urf...[pause=0] This is harder than I expected...")
			UI:WaitShowDialogue("We can't continue on like this...[pause=0] Let's call it a day.")
			SV.Chapter3.FailedCavern = true--mark that they died before the end so Team Style can taunt them for this.
		end
		
		--set generic flags for generic end of day / start of next day.
		SV.TemporaryFlags.Dinnertime = true 
		SV.TemporaryFlags.Bedtime = true
		SV.TemporaryFlags.MorningWakeup = true 
		SV.TemporaryFlags.MorningAddress = true 
					
		--I use the components of the general function version of this so I can have the textbox pop up after the results screen
		GAME:EndDungeonRun(result, "master_zone", -1, 6, 0, true, true)			
					
		--go to dinner room 
		GAME:EnterZone("master_zone", -1, 6, 0)

	
	else 
		--dont set generic end flags if it's chapter 2 (i.e. you're rescuing numel)
		if SV.ChapterProgression.Chapter ~= 3 then 
			--set generic flags for generic end of day / start of next day.
			SV.TemporaryFlags.Dinnertime = true 
			SV.TemporaryFlags.Bedtime = true
			SV.TemporaryFlags.MorningWakeup = true 
			SV.TemporaryFlags.MorningAddress = true 
			GAME:EnterZone("master_zone", -1, 42, 0) --Go to Crooked Den ground map, end dungeon run in the ground rather than here 

		else--for chapter 3, dont show results and dont set generic end flags
			GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 42, 0, false, false) --Go to Crooked Den ground map
		end
	end
end
	

return crooked_cavern