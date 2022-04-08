require 'common'
require 'GeneralFunctions'

local zone_51 = {}
--------------------------------------------------
-- Map Callbacks
--------------------------------------------------
function zone_51.Init(zone)
    --Set team to just player+partner, then add Ledian. Set current lesson to beginner
	SV.Tutorial.Lesson = 'beginner_lesson';
	
    GeneralFunctions.DefaultParty(false, false, true)
	--move partner to assembly for the tutorial after setting party to default
	local p = GAME:GetPlayerPartyMember(1)
	GAME:RemovePlayerTeam(1)
	GAME:AddPlayerAssembly(p)
	
	--setup Ledian's stats/moves. She doesn't get capped to 5 and has her regular stats.
	local mon_id = RogueEssence.Dungeon.MonsterID(166, 0, 0, Gender.Female)
	local sensei = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 5, 89, 0)
	sensei.Discriminator = _DATA.Save.Rand:Next()--tbh idk what this is lol
	sensei.Level = 58
	sensei.Nickname = 'Lotus'
	sensei.IsPartner = true-- if they somehow manage to die, end the run
	sensei.MaxHPBonus = 10
	sensei.AtkBonus = 12
	sensei.DefBonus = 3
	sensei.MDefBonus = 5
	sensei.SpeedBonus = 8
	--all of lotus's moves are toggled off, she's only allowed to basic attack
	sensei:ReplaceSkill(183, 0, false)--mach punch
	sensei:ReplaceSkill(369, 1, false)--u-turn
	sensei:ReplaceSkill(14, 2, false)--Swords dance
	sensei:ReplaceSkill(8, 3, false)--Ice punch
	GAME:AddPlayerGuest(sensei)
	sensei:FullRestore()
    local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("SenseiInteract")
    sensei.ActionEvents:Add(talk_evt)
	sensei:RefreshTraits()
	
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> Init_zone_51")
end

function zone_51.Rescued(zone, mail)
  COMMON.Rescued(zone, mail)
end


function zone_51.ExitSegment(zone, result, rescue, segmentID, mapID)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> ExitSegment_zone_51 (Beginner Lesson) result "..tostring(result).." segment "..tostring(segmentID))

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
	
	--no matter the result, clear the tutorial flags back to their defaults
	SV.Tutorial.Lesson = 'null'
	SV.Tutorial.LastSpeech = 'null'
	SV.Tutorial.Progression = 0
	
	--failed or gave up on the tutorial
	if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then 
		if SV.ChapterProgression.Chapter == 2 then
			--If we've completed the training already, then flag a generic ending to the lesson. Otherwise, flag nothing.
			if SV.Chapter2.StartedTraining and SV.Chapter2.FinishedTraining then--generic ending
				SV.Dojo.LessonFailedGeneric = true
			end 
			GeneralFunctions.EndDungeonRun(result, 0, -1, 36, 0, false, false)
		else--generic ending
			SV.Dojo.LessonFailedGeneric = true
			GeneralFunctions.EndDungeonRun(result, 0, -1, 36, 0, false, false)
		end
	--passed tutorial
	else
		if SV.ChapterProgression.Chapter == 2 then
			--We have started the tutorial but haven't finished it yet
			if SV.Chapter2.StartedTraining and not SV.Chapter2.FinishedTraining then
				SV.Chapter2.FinishedTraining = true
			else--generic ending
				SV.Dojo.LessonCompletedGeneric = true
			end 
			GeneralFunctions.EndDungeonRun(result, 0, -1, 36, 0, false, false)
		else--generic ending
			SV.Dojo.LessonCompletedGeneric = true
			GeneralFunctions.EndDungeonRun(result, 0, -1, 36, 0, false, false)
		end
	end
	
	
end
	

return zone_51
