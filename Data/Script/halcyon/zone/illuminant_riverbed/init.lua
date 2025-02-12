require 'origin.common'
require 'halcyon.GeneralFunctions'

local illuminant_riverbed = {}
--------------------------------------------------
-- Map Callbacks
--------------------------------------------------
function illuminant_riverbed.Init(zone)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> Init_illuminant_riverbed")
  --Mark this as the last dungeon entered.
  SV.TemporaryFlags.LastDungeonEntered = 'illuminant_riverbed'
  
end

function illuminant_riverbed.EnterSegment(zone, rescuing, segmentID, mapID)
	GeneralFunctions.CheckAllowSetRescue(zone.ID)
	if rescuing ~= true then
		COMMON.BeginDungeon(zone.ID, segmentID, mapID)
	end
end

function illuminant_riverbed.Rescued(zone, mail)
  COMMON.Rescued(zone, mail)
end


function illuminant_riverbed.ExitSegment(zone, result, rescue, segmentID, mapID)
	GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> ExitSegment_illuminant_riverbed (Illuminant Riverbed) result "..tostring(result).." segment "..tostring(segmentID))
  	
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
	local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)

  if exited == true then
    --do nothing
	elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then


		GAME:WaitFrames(20)
		
		--set generic flags for generic end of day / start of next day.
		SV.TemporaryFlags.Dinnertime = true 
		SV.TemporaryFlags.Bedtime = true
		SV.TemporaryFlags.MorningWakeup = true 
		SV.TemporaryFlags.MorningAddress = true 
		
	    --Go to dinner if a mission wasn't completed, otherwise, go to 2nd floor
		local exit_ground = 6
		if SV.TemporaryFlags.MissionCompleted then exit_ground = 22 end 
					
		--I use the components of the general function version of this so I can have the textbox pop up after the results screen
		--this saves the game, so it must be called 2nd to last.
		GAME:EndDungeonRun(result, "master_zone", -1, exit_ground, 0, true, true)
	
		if not SV.Chapter2.FinishedRiver and result ~= RogueEssence.Data.GameProgress.ResultType.Escaped then --team died before making it to the end for the first time. 
			GeneralFunctions.DeathFadeOutDialogue(GAME:GetPlayerPartyMember(1), "Urgh...[pause=0] That didn't go well...", "Pain")--set partner as speaker
			GAME:WaitFrames(20)
		end
				
		--go to dinner room 
		GAME:EnterZone("master_zone", -1, exit_ground, 0)

	
	else 
		--dont set generic end flags if it's chapter 2 (i.e. you're rescuing numel)
		if SV.ChapterProgression.Chapter ~= 2 then 
			--set generic flags for generic end of day / start of next day.
			SV.TemporaryFlags.Dinnertime = true 
			SV.TemporaryFlags.Bedtime = true
			SV.TemporaryFlags.MorningWakeup = true 
			SV.TemporaryFlags.MorningAddress = true 
		
			GAME:EnterGroundMap('luminous_spring', 'Main_Entrance_Marker') --Go to Luminous Spring, end dungeon run in the ground rather than here 

		else--for chapter 2, dont show results and dont set generic end flags
			GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 20, 0, false, false) --Go to Luminous Spring 
		end
	end
end

return illuminant_riverbed