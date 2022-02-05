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
	--sensei:ReplaceIntrinsic = 89 --Iron fist
	sensei:ReplaceSkill(183, 1, true)--mach punch
	sensei:ReplaceSkill(369, 2, true)--u-turn
	sensei:ReplaceSkill(14, 3, false)--Swords dance
	sensei:ReplaceSkill(8, 4, true)--Ice punch
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
		if SV.ChapterProgression.Chapter == 2 then --todo: cutscenes
			GeneralFunctions.EndDungeonRun(result, 0, -1, 36, 0, false, false)
		else 
			GeneralFunctions.EndDungeonRun(result, 0, -1, 36, 0, false, false)
		end
	--passed tutorial
	else
		if SV.ChapterProgression.Chapter == 2 then --todo: cutscenes
			GeneralFunctions.EndDungeonRun(result, 0, -1, 36, 0, false, false)
		else
			GeneralFunctions.EndDungeonRun(result, 0, -1, 36, 0, false, false)
		end
	end
	
	
end
	

return zone_51