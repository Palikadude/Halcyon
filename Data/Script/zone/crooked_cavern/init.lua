require 'common'
require 'GeneralFunctions'

local crooked_cavern = {}
--------------------------------------------------
-- Map Callbacks
--------------------------------------------------
function crooked_cavern.Init(zone)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> Init_crooked_cavern")

	--GAME:RemovePlayerGuest(0)
	--GAME:RemovePlayerGuest(0)
	--local guestCount = GAME:GetPlayerGuestCount()
	--for i = 1, guestCount, 1 do 
	--	local g = GAME:RemovePlayerGuest(i-1)
	--end
  --Mark this as the last dungeon entered.
  SV.TemporaryFlags.LastDungeonEntered = 'crooked_cavern'

end

function crooked_cavern.EnterSegment(zone, rescuing, segmentID, mapID)
	if rescuing ~= true then
		COMMON.BeginDungeon(zone.ID, segmentID, mapID)
	end
end

function crooked_cavern.Rescued(zone, mail)
  COMMON.Rescued(zone, mail)
end


function crooked_cavern.ExitSegment(zone, result, rescue, segmentID, mapID)
	GeneralFunctions.RestoreIdleAnim()
  if segmentID == 0 then--crooked cavern exit segment 
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
		COMMON.ExitDungeonMissionCheck(zone.ID, segmentID)
		if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then

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
			GAME:EndDungeonRun(result, "master_zone", -1, exit_ground, 0, true, true)			
					
			if not SV.Chapter3.DefeatedBoss and result ~= RogueEssence.Data.GameProgress.ResultType.Escaped then --team died before making it to the end for the first time. 
				UI:SetSpeaker(GAME:GetPlayerPartyMember(1))--set partner as speaker 
				UI:SetSpeakerEmotion("Pain")
				UI:WaitShowDialogue("Urf...[pause=0] This is harder than I expected...")
				UI:WaitShowDialogue("We can't continue on like this...[pause=0] Let's call it a day.")
				SV.Chapter3.FailedCavern = true--mark that they died before the end so Team Style can taunt them for this.
				GAME:WaitFrames(20)
			end
			
			--go to dinner room 
			GAME:EnterZone("master_zone", -1, exit_ground, 0)

		
		else 
			--dont set generic end flags if you haven't beaten the boss (i.e. you're arresting sandile)
			if SV.Chapter3.FinishedRootScene then 
				--set generic flags for generic end of day / start of next day.
				SV.TemporaryFlags.Dinnertime = true 
				SV.TemporaryFlags.Bedtime = true
				SV.TemporaryFlags.MorningWakeup = true 
				SV.TemporaryFlags.MorningAddress = true 
				
				GAME:EnterGroundMap('crooked_den', 'Main_Entrance_Marker') --Go to Crooked Den, end dungeon run in the ground rather than here 

			else--for chapter 3, dont show results and dont set generic end flags
				GAME:EnterZone("master_zone", -1, 42, 0) --Go to Crooked Den ground map, end dungeon run in the boss fight zone rather than here so the replays concatenate.
			end
		end
	else--crooked den exit segment 
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
		
		GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 42, 0, false, false) --Go to Crooked Den ground map
	end
end
	

return crooked_cavern