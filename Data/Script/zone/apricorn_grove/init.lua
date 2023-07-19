--[[
    init.lua
    Created: 06/19/2023 11:32:20
    Description: Autogenerated script file for the map apricorn_grove.
]]--
-- Commonly included lua functions and data
require 'common'
require 'GeneralFunctions'

local apricorn_grove = {}
--------------------------------------------------
-- Map Callbacks
--------------------------------------------------
function apricorn_grove.Init(zone)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> Init_apricorn_grove")
  --Mark this as the last dungeon entered.
  SV.TemporaryFlags.LastDungeonEntered = 60
  
end

function apricorn_grove.EnterSegment(zone, rescuing, segmentID, mapID)
	
	if segmentID == 0 then
		SV.ApricornGrove.InDungeon = true
	end
	
	if rescuing ~= true then
		COMMON.BeginDungeon(zone.ID, segmentID, mapID)
	end
end

function apricorn_grove.Rescued(zone, mail)
  COMMON.Rescued(zone, mail)
end


function apricorn_grove.ExitSegment(zone, result, rescue, segmentID, mapID)
	GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> ExitSegment_apricorn_grove (Illuminant Riverbed) result "..tostring(result).." segment "..tostring(segmentID))
  
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

		--no longer in the dungeon.
		SV.ApricornGrove.InDungeon = false
		
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
	
		if not SV.Chapter4.FinishedGrove and result ~= RogueEssence.Data.GameProgress.ResultType.Escaped then --team died before making it to the end for the first time. 
			UI:SetSpeaker(GAME:GetPlayerPartyMember(1))--set partner as speaker 
			UI:SetSpeakerEmotion("Pain")
			UI:WaitShowDialogue("Urk![pause=0] That didn't go as planned...")
			GAME:WaitFrames(20)
		end
				
		--go to dinner room 
		GAME:EnterZone("master_zone", -1, exit_ground, 0)

	
	else 
		--since you can choose to go back into the dungeon at the end or not, do all end of dungeon stuff in the ground.
		GAME:EnterGroundMap('apricorn_glade', 'Main_Entrance_Marker') --Go to Apricorn Glade, end dungeon run in the ground rather than here 
	end
end
	

return apricorn_grove