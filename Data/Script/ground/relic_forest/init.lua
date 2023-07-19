--[[
    init.lua
    Created: 06/24/2021 22:23:31
    Description: Autogenerated script file for the map relic_forest.
]]--
-- Commonly included lua functions and data
require 'common'
require 'PartnerEssentials'
require 'ground.relic_forest.relic_forest_ch_1'


-- Package name
local relic_forest = {}

-- Local, localized strings table
-- Use this to display the named strings you added in the strings files for the map!
-- Ex:
--      local localizedstring = MapStrings['SomeStringName']
local MapStrings = {}

-------------------------------
-- Map Callbacks
-------------------------------
---relic_forest.Init
--Engine callback function
function relic_forest.Init(map)

  DEBUG.EnableDbgCoro()
  print('=>> Init_relic_forest <<=')
  MapStrings = COMMON.AutoLoadLocalizedStrings()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
  
end

---relic_forest.Enter
--Engine callback function
function relic_forest.Enter(map)
	relic_forest.PlotScripting()
end

---relic_forest.Exit
--Engine callback function
function relic_forest.Exit(map)


end

---relic_forest.Update
--Engine callback function
function relic_forest.Update(map)


end


function relic_forest.GameLoad(map)
	PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
	relic_forest.PlotScripting()
end

function relic_forest.GameSave(map)
	PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function relic_forest.PlotScripting()
  --plot scripting
  if SV.ChapterProgression.Chapter == 1 then 
	if not SV.Chapter1.PlayedIntroCutscene then --Opening Cutscene on a fresh save
	  relic_forest_ch_1.Intro_Cutscene()
	elseif SV.Chapter1.PartnerCompletedForest and not SV.Chapter1.PartnerMetHero then --our duo meet
	  relic_forest_ch_1.PartnerFindsHeroCutscene()  
	elseif SV.Chapter1.PartnerCompletedForest and not SV.Chapter1.TeamCompletedForest then--team wiped in the dungeon
	  relic_forest_ch_1.WipedInForest()
	end
  else 
	relic_forest.GenericEnding()
  end
end

--No cutscene to play, play a generic ending saying there's nothing here.
function relic_forest.GenericEnding()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local team2 = CH('Teammate2')
	local team3 = CH('Teammate3')

	AI:DisableCharacterAI(partner)
	SOUND:StopBGM()
	GAME:WaitFrames(20)

	GAME:MoveCamera(301, 224, 1, false)
	GROUND:TeleportTo(hero, 277, 400, Direction.Up)
	GROUND:TeleportTo(partner, 309, 400, Direction.Up)
	if team2 ~= nil then
		GROUND:TeleportTo(team2, 293, 432, Direction.Up)
	end
	if team3 ~= nil then
		GROUND:TeleportTo(team3, 325, 432, Direction.Up)
	end
	
	GAME:CutsceneMode(true)
	UI:ResetSpeaker()
	UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
	GAME:WaitFrames(60)
	UI:WaitHideTitle(20)
	GAME:FadeIn(40)
	
	SOUND:PlayBGM('In The Depths of the Pit.ogg', true)
	
	--numbers a bit wonk for camera and movement (not multiples of 2) to help match up with the slightly offcenter tablet and the other relic forest scripts
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 309, 240, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:MoveToPosition(hero, 277, 240, false, 1) end)
	local coro3 = TASK:BranchCoroutine(function() if team2 ~= nil then GAME:WaitFrames(14) GROUND:MoveToPosition(team2, 293, 272, false, 1) end end)
	local coro4 = TASK:BranchCoroutine(function() if team3 ~= nil then GAME:WaitFrames(18) GROUND:MoveToPosition(team3, 325, 272, false, 1) end end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	GAME:WaitFrames(10)	
	
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.LookAround(partner, 3, 4, false, false, true, Direction.Up) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.LookAround(hero, 3, 4, false, false, true, Direction.Up) end)
	coro3 = TASK:BranchCoroutine(function() if team2 ~= nil then GAME:WaitFrames(14) GeneralFunctions.LookAround(team2, 3, 4, false, false, true, Direction.Left) end end)										  
	coro4 = TASK:BranchCoroutine(function() if team3 ~= nil then GAME:WaitFrames(18) GeneralFunctions.LookAround(team3, 3, 4, false, false, true, Direction.Right) end end)										  
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	--temporary flags are set by the zone script rather than here.
	GAME:WaitFrames(20)
	UI:SetCenter(true)
	UI:WaitShowDialogue("There doesn't appear to be anything of interest here.")
	UI:WaitShowDialogue("It's impossible to go any further.[pause=0]\nIt's time to go back.")
	GAME:WaitFrames(40)
	
	--touch the rock, for luck 
	UI:WaitShowDialogue("...But first...")
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, 293, 210, false, 1) end)
	coro2 = TASK:BranchCoroutine(function() if team2 ~= nil then GAME:WaitFrames(2) GROUND:CharAnimateTurnTo(team2, Direction.Up, 4) end end)
	coro3 = TASK:BranchCoroutine(function() if team3 ~= nil then GAME:WaitFrames(6) GROUND:CharAnimateTurnTo(team3, Direction.Up, 4) end end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	GAME:WaitFrames(20)
	GROUND:CharSetAction(partner, RogueEssence.Ground.PoseGroundAction(partner.Position, partner.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GAME:WaitFrames(60)
	GROUND:CharEndAnim(partner)
	GAME:WaitFrames(20)
	GROUND:AnimateToPosition(partner, "Walk", Direction.Up, 293, 218, 1, 1)
	GAME:WaitFrames(30)
	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
											GROUND:AnimateToPosition(partner, "Walk", Direction.Left, 325, 218, 1, 1) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(32) 
											GeneralFunctions.EightWayMove(hero, 293, 210, false, 1)	end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)
	GROUND:CharSetAction(hero, RogueEssence.Ground.PoseGroundAction(hero.Position, hero.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GAME:WaitFrames(60)	
	GROUND:CharEndAnim(hero)
	GAME:WaitFrames(20)
	GROUND:AnimateToPosition(hero, "Walk", Direction.Up, 293, 218, 1, 1)
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(hero, "Nod") end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(partner, "Nod") end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("...For luck.")
	GAME:WaitFrames(30)
	UI:SetCenter(false)
	SOUND:FadeOutBGM(60)
	GAME:FadeOut(false, 60)
	GAME:CutsceneMode(false)
	GAME:WaitFrames(20)
	--Go to second floor if mission was done, else, dinner room. Missions shouldn't be genned for relic_forest, but just in case.
	if SV.TemporaryFlags.MissionCompleted then
		GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared, "master_zone", -1, 22, 0, true, true)
	else
		GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared, "master_zone", -1, 6, 0, true, true)
	end
end


function relic_forest.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

return relic_forest

