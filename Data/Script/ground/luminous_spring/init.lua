require 'common'
require 'PartnerEssentials'
require 'ground.luminous_spring.luminous_spring_ch_2'

-- Package name
local luminous_spring = {}

-- Local, localized strings table
-- Use this to display the named strings you added in the strings files for the map!
-- Ex:
--      local localizedstring = MapStrings['SomeStringName']
local MapStrings = {}

-------------------------------
-- Map Callbacks
-------------------------------
---luminous_spring.Init
--Engine callback function
function luminous_spring.Init(map, time)

	DEBUG.EnableDbgCoro()
	print('=>> Init_luminous_spring <<=')
	MapStrings = COMMON.AutoLoadLocalizedStrings()
	COMMON.RespawnAllies(true)
	PartnerEssentials.InitializePartnerSpawn()
end

---luminous_spring.Enter
--Engine callback function
function luminous_spring.Enter(map, time)

	luminous_spring.PlotScripting()

end

---luminous_spring.Exit
--Engine callback function
function luminous_spring.Exit(map, time)


end

---luminous_spring.Update
--Engine callback function
function luminous_spring.Update(map, time)


end

function luminous_spring.GameLoad(map)
	PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
	luminous_spring.PlotScripting()
end

function luminous_spring.GameSave(map)
	PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end


function luminous_spring.PlotScripting()
	if SV.ChapterProgression.Chapter == 2 then 
		luminous_spring_ch_2.FindNumelCutscene()
	else
		--generic ending 
		luminous_spring.GenericEnding()
	end
end





function luminous_spring.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
 end



--No cutscene to play, play a generic ending saying there's nothing here.
function luminous_spring.GenericEnding()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local team2 = CH('Teammate2')
	local team3 = CH('Teammate3')
	AI:DisableCharacterAI(partner)
	SOUND:StopBGM()
	GAME:WaitFrames(20)
	
	GROUND:TeleportTo(hero, 276, 400, Direction.Up)
	GROUND:TeleportTo(partner, 308, 400, Direction.Up)
	if team2 ~= nil then
		GROUND:TeleportTo(team2, 292, 432, Direction.Up)
	end
	if team3 ~= nil then
		GROUND:TeleportTo(team3, 260, 432, Direction.Up)
	end
	
	GAME:MoveCamera(300, 264, 1, false)
		
	GAME:CutsceneMode(true)
	UI:ResetSpeaker()
	UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
	GAME:WaitFrames(60)
	UI:WaitHideTitle(20)
	GAME:FadeIn(40)
	
	SOUND:PlayBGM('In The Depths of the Pit.ogg', true)
	
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 308, 288, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:MoveToPosition(hero, 276, 288, false, 1) end)
	local coro3 = TASK:BranchCoroutine(function() if team2 ~= nil then GAME:WaitFrames(14) GROUND:MoveToPosition(team2, 292, 320, false, 1) end end)
	local coro4 = TASK:BranchCoroutine(function() if team3 ~= nil then GAME:WaitFrames(18) GROUND:MoveToPosition(team3, 260, 320, false, 1) end end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	GAME:WaitFrames(10)	
	
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.LookAround(partner, 3, 4, false, false, true, Direction.Up) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.LookAround(hero, 3, 4, false, false, true, Direction.Up) end)
	coro3 = TASK:BranchCoroutine(function() if team2 ~= nil then GAME:WaitFrames(14) GeneralFunctions.LookAround(team2, 3, 4, false, false, true, Direction.Right) end end)										  
	coro4 = TASK:BranchCoroutine(function() if team3 ~= nil then GAME:WaitFrames(18) GeneralFunctions.LookAround(team3, 3, 4, false, false, true, Direction.Left) end end)										  
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	--temporary flags are set by the zone script rather than here.
	GAME:WaitFrames(20)
	UI:SetCenter(true)
	UI:WaitShowDialogue("There doesn't appear to be anything of interest here.")
	UI:WaitShowDialogue("It's impossible to go any further.[pause=0]\nIt's time to go back.")
	UI:SetCenter(false)
	SOUND:FadeOutBGM(60)
	GAME:FadeOut(false, 60)
	GAME:CutsceneMode(false)
	GAME:WaitFrames(20)
	--Go to second floor if mission was done, else, dinner room
	if SV.TemporaryFlags.MissionCompleted then
		GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared, "master_zone", -1, 22, 0, true, true)
	else
		GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared, "master_zone", -1, 6, 0, true, true)
	end	
	
end
--------------------------------------------------
-- Objects Callbacks
--------------------------------------------------

--[[
Base Game functionality, commented out 
function luminous_spring.South_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 40)
  GAME:EnterGroundMap("base_camp_2", "entrance_north")
end

function luminous_spring.Spring_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
	UI:ResetSpeaker()
	
	local state = 0
	local repeated = false
	local member = nil
	local evo = nil
	local player = CH('PLAYER')
	
	GAME:CutsceneMode(true)
	GAME:MoveCamera(300, 152, 90, false)
	GROUND:TeleportTo(player, 292, 312, Direction.Down)
	
	UI:WaitShowDialogue(STRINGS:Format(MapStrings['Evo_Intro_1']))
	UI:WaitShowDialogue(STRINGS:Format(MapStrings['Evo_Intro_2']))
	while state > -1 do
		if state == 0 then
			local evo_choices = {STRINGS:Format(MapStrings['Evo_Option_Evolve']),
			STRINGS:FormatKey("MENU_INFO"),
			STRINGS:FormatKey("MENU_EXIT")}
			UI:BeginChoiceMenu(STRINGS:Format(MapStrings['Evo_Ask']), evo_choices, 1, 3)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			repeated = true
			if result == 1 then
				state = 1
			elseif result == 2 then
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Evo_Info_001']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Evo_Info_002']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Evo_Info_003']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Evo_Info_004']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Evo_Info_005']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Evo_Info_006']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Evo_Info_007']))
			else
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Evo_End']))
				state = -1
			end
		elseif state == 1 then
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Evo_Ask_Who']))
			UI:ShowPromoteMenu()
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			if result > -1 then
				state = 2
				member = GAME:GetPlayerPartyMember(result)--GAME:GetPlayerAssemblyMember(result)
			else
				state = 0
			end
		elseif state == 2 then
			if not GAME:CanPromote(member) then
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Evo_None'], member.BaseName))
				state = 1
			else
				local branches = GAME:GetAvailablePromotions(member, 349)
				if #branches == 0 then
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['Evo_None_Now'], member.BaseName))
					state = 1
				elseif #branches == 1 then
					local branch = branches[1]
					local evo_item = -1
					for detail_idx = 0, branch.Details.Count  - 1 do
						local detail = branch.Details[detail_idx]
						if detail.GiveItem > -1 then
							evo_item = detail.GiveItem
							break
						end
					end
					-- harmony scarf hack-in
					if member.EquippedItem.ID == 349 then
						evo_item = 349
					end
					local mon = RogueEssence.Data.DataManager.Instance:GetMonster(branch.Result)
					if evo_item > -1 then
						local item = RogueEssence.Data.DataManager.Instance:GetItem(evo_item)
						UI:ChoiceMenuYesNo(STRINGS:Format(MapStrings['Evo_Confirm_Item'], member.BaseName, item.Name:ToLocal(), mon.Name:ToLocal()), false)
					else
						UI:ChoiceMenuYesNo(STRINGS:Format(MapStrings['Evo_Confirm'], member.BaseName, mon.Name:ToLocal()), false)
					end
					UI:WaitForChoice()
					local result = UI:ChoiceResult()
					if result then
						evo = branch
						state = 3
					else
						state = 1
					end
				else
					local evo_names = {}
					for branch_idx = 1, #branches do
						local mon = RogueEssence.Data.DataManager.Instance:GetMonster(branches[branch_idx].Result)
						table.insert(evo_names, mon.Name:ToLocal())
					end
					table.insert(evo_names, STRINGS:FormatKey("MENU_CANCEL"))
					UI:BeginChoiceMenu(STRINGS:Format(MapStrings['Evo_Choice'], member.BaseName), evo_names, 1, #evo_names)
					UI:WaitForChoice()
					local result = UI:ChoiceResult()
					if result < #evo_names then
						evo = branches[result]
						state = 3
					else
						state = 1
					end
				end
			end
		elseif state == 3 then
			--execute evolution
			local mon = RogueEssence.Data.DataManager.Instance:GetMonster(evo.Result)
			
			GROUND:SpawnerSetSpawn("EVO_SUBJECT",member)
			local subject = GROUND:SpawnerDoSpawn("EVO_SUBJECT")
			
			GROUND:MoveInDirection(subject, Direction.Up, 60)
			GROUND:EntTurn(subject, Direction.Down)
			
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Evo_Begin']))
			
			SOUND:PlayBattleSE("EVT_Evolution_Start")
			GAME:FadeOut(true, 20)
			
			GAME:PromoteCharacter(member, evo, 349)
			COMMON.RespawnAllies()
			GROUND:RemoveCharacter("EvoSubject")
			--GROUND:SpawnerSetSpawn("EVO_SUBJECT",member)
			subject = GROUND:SpawnerDoSpawn("EVO_SUBJECT")
			GROUND:TeleportTo(subject, 292, 192, Direction.Down)
			
			GAME:WaitFrames(30)
			
			SOUND:PlayBattleSE("EVT_Title_Intro")
			GAME:FadeIn(40)
			SOUND:PlayFanfare("Fanfare/Promotion")
			
			
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Evo_Complete'], member.BaseName, mon.Name:ToLocal()))
			
			
			GROUND:MoveInDirection(subject, Direction.Down, 60)
			
			GROUND:RemoveCharacter("EvoSubject")
			
			state = 0
		end
	end
	
	GAME:MoveCamera(0, 0, 90, true)
	GAME:CutsceneMode(false)
end

function luminous_spring.Assembly_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  UI:ResetSpeaker()
  COMMON.ShowTeamAssemblyMenu(COMMON.RespawnAllies)
end

function luminous_spring.Storage_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  COMMON:ShowTeamStorageMenu()
end


function luminous_spring.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  COMMON.GroundInteract(activator, chara, true)
end

function luminous_spring.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  COMMON.GroundInteract(activator, chara, true)
end

function luminous_spring.Teammate3_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  COMMON.GroundInteract(activator, chara, true)
end

]]--

return luminous_spring