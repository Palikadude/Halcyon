require 'common'
require 'GeneralFunctions'

local beginner_lesson = {}
--------------------------------------------------
-- Map Callbacks
--------------------------------------------------
function beginner_lesson.Init(zone)
    --Set team to just player+partner, then add Ledian. Set current lesson to beginner
	SV.Tutorial.Lesson = 'beginner_lesson';
	
    GeneralFunctions.DefaultParty(false)
	--move partner to assembly for the tutorial after setting party to default
	local p = GAME:GetPlayerPartyMember(1)
	GAME:RemovePlayerTeam(1)
	GAME:AddPlayerAssembly(p)
	
	--setup Ledian's stats/moves. She doesn't get capped to 5 and has her regular stats.
	local mon_id = RogueEssence.Dungeon.MonsterID("ledian", 0, "normal", Gender.Female)
	local sensei = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 5, "iron_fist", 0)
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
	sensei:ReplaceSkill("mach_punch", 0, false)--mach punch
	sensei:ReplaceSkill("u_turn", 1, false)--u-turn
	sensei:ReplaceSkill("swords_dance", 2, false)--Swords dance
	sensei:ReplaceSkill("ice_punch", 3, false)--Ice punch
	GAME:AddPlayerGuest(sensei)
	sensei:FullRestore()
    local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("SenseiInteract")
    sensei.ActionEvents:Add(talk_evt)
	sensei:RefreshTraits()
	
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> Init_beginner_lesson")
end

function beginner_lesson.Rescued(zone, mail)
  COMMON.Rescued(zone, mail)
end


function beginner_lesson.ExitSegment(zone, result, rescue, segmentID, mapID)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> ExitSegment_beginner_lesson (Beginner Lesson) result "..tostring(result).." segment "..tostring(segmentID))

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
	
	--cannot use the general functions command to end dungeon runs when risk is set to none or flags are not saved properly
	--as a result we need to end dungeon run, then set flags, then enter the ledian zone
	GAME:EndDungeonRun(result, "master_zone", -1, 36, 0, false, false)

	
	--failed or gave up on the tutorial
	if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then 
		if SV.ChapterProgression.Chapter == 2 then
			--If we've completed the training already, then flag a generic ending to the lesson. Otherwise, flag nothing.
			if SV.Chapter2.StartedTraining and SV.Chapter2.FinishedTraining then--generic ending
				SV.Dojo.LessonFailedGeneric = true
			end 
			
		else--generic ending
			SV.Dojo.LessonFailedGeneric = true
		end
	--passed tutorial
	else
		if SV.ChapterProgression.Chapter == 2 then
            if SV.Chapter2.StartedTraining and not SV.Chapter2.FinishedTraining then
                SV.Chapter2.FinishedTraining = true
            else--generic ending
                SV.Dojo.LessonCompletedGeneric = true
            end 
		else--generic ending
			SV.Dojo.LessonCompletedGeneric = true
		end
	end
	
	--no matter the result, clear the tutorial flags back to their defaults
	SV.Tutorial.Lesson = 'null'
	SV.Tutorial.LastSpeech = 'null'
	SV.Tutorial.Progression = 0
	
	--flag zone 51 as last dojo zone
	SV.Dojo.LastZone = "beginner_lesson"
	
	--Since this is risk none, we need to first "save" the game with end dungeon run, then save the game a second time after setting variables to preserve those variable changes in the save.
	--GAME:EndDungeonRun(result, "master_zone", -1, 36, 0, false, false)
	
	GAME:EnterZone("master_zone", -1, 36, 0)
	
end
	

return beginner_lesson
