--[[
    init.lua
    Created: 06/29/2021 10:19:56
    Description: Autogenerated script file for the map guild_second_floor.
]]--
-- Commonly included lua functions and data
require 'common'
require 'PartnerEssentials'
require 'ground.guild_second_floor.guild_second_floor_ch_1'
require 'ground.guild_second_floor.guild_second_floor_ch_2'


-- Package name
local guild_second_floor = {}

local MapStrings = {}

-------------------------------
-- Map Callbacks
-------------------------------
---guild_second_floor.Init
function guild_second_floor.Init(map)
	DEBUG.EnableDbgCoro()
	print('=>> Init_guild_second_floor<<=')
	MapStrings = COMMON.AutoLoadLocalizedStrings()
	COMMON.RespawnAllies()
	PartnerEssentials.InitializePartnerSpawn()
end

---guild_second_floor.Enter
function guild_second_floor.Enter(map)
	DEBUG.EnableDbgCoro()
	print('Enter_guild_second_floor')
	UI:ResetSpeaker()
	guild_second_floor.PlotScripting()
end

---guild_second_floor.Exit
function guild_second_floor.Exit(map)


end

---guild_second_floor.Update
function guild_second_floor.Update(map)


end


function guild_second_floor.GameLoad(map)
	PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
	guild_second_floor.PlotScripting()
end

function guild_second_floor.GameSave(map)
	PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function guild_second_floor.PlotScripting()
	--plot scripting
	if SV.ChapterProgression.Chapter == 1 then
		if SV.Chapter1.TeamCompletedForest and not SV.Chapter1.TeamJoinedGuild then 
			guild_second_floor_ch_1.MeetNoctowl()
		else
			guild_second_floor_ch_1.SetupGround()
		end
	elseif SV.ChapterProgression.Chapter == 2 then
		guild_second_floor_ch_2.SetupGround()
	else
		GAME:FadeIn(20)
	end
end


--[[
Markers used for generic NPC spawning (i.e. where flavor NPCs should be going)

Teams gathered around the left message board 
Left_Trio_1, 2, 3 
Left_Duo_1, 2
Left_Solo

Teams gathered around the right message board
Right_Trio_1, 2, 3 
Right_Duo_1, 2
Right_Solo

Teams having a conversation:
Generic_Spawn_Duo_1, 2, 3 ,4
TODO: Add a couple sets of trio spawn markers 

Generic Spawns:
Generic_Spawn_1, 2, 3, 4, 5, 6, 7, 8
]]--




---------------------------------
-- Event Trigger
-- This is a temporary object created by a script used to trigger events that only happen
-- once, typically a cutscene of sorts for a particular chapter.
---------------------------------
function guild_second_floor.Event_Trigger_1_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("guild_second_floor_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Event_Trigger_1_Touch(...,...)"), obj, activator))
end






-------------------------------
-- Entities Callbacks
-------------------------------
function guild_second_floor.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function guild_second_floor.Mission_Board_Action(chara, activator)
	if SV.ChapterProgression.Chapter < 3 then 
		GROUND:CharTurnToCharAnimated(CH('Teammate1'), CH('PLAYER'),  4)
		UI:SetSpeaker(CH('Teammate1'))
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue("Hmm...[pause=0] I don't think we should being taking jobs from the board right now...")
		GROUND:CharTurnToCharAnimated(CH('PLAYER'), CH('Teammate1'), 4)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("We only just joined after all.[pause=0] Let's come back another time!")
	end
end

function guild_second_floor.Outlaw_Board_Action(chara, activator)
	if SV.ChapterProgression.Chapter < 3 then 
		GROUND:CharTurnToCharAnimated(CH('Teammate1'), CH('PLAYER'),  4)
		UI:SetSpeaker(CH('Teammate1'))
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue("Hmm...[pause=0] I don't think we should being taking jobs from the board right now...")
		GROUND:CharTurnToCharAnimated(CH('PLAYER'), CH('Teammate1'), 4)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("We only just joined after all.[pause=0] Let's come back another time!")
	end
end



function guild_second_floor.Cleffa_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  assert(pcall(load("guild_second_floor_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Cleffa_Action(...,...)"), chara, activator))
end

function guild_second_floor.Aggron_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  assert(pcall(load("guild_second_floor_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Aggron_Action(...,...)"), chara, activator))
end

function guild_second_floor.Zigzagoon_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  assert(pcall(load("guild_second_floor_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Zigzagoon_Action(...,...)"), chara, activator))
end

function guild_second_floor.Marill_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  assert(pcall(load("guild_second_floor_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Marill_Action(...,...)"), chara, activator))
end

function guild_second_floor.Spheal_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  assert(pcall(load("guild_second_floor_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Spheal_Action(...,...)"), chara, activator))
end

function guild_second_floor.Jigglypuff_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  assert(pcall(load("guild_second_floor_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Jigglypuff_Action(...,...)"), chara, activator))
end

function guild_second_floor.Cranidos_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  assert(pcall(load("guild_second_floor_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Cranidos_Action(...,...)"), chara, activator))
end

function guild_second_floor.Mareep_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  assert(pcall(load("guild_second_floor_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Mareep_Action(...,...)"), chara, activator))
end

function guild_second_floor.Seviper_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  assert(pcall(load("guild_second_floor_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Seviper_Action(...,...)"), chara, activator))
end

function guild_second_floor.Zangoose_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  assert(pcall(load("guild_second_floor_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Zangoose_Action(...,...)"), chara, activator))
end







---------------------------
-- Map Transitions
---------------------------
function guild_second_floor.Upwards_Stairs_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("guild_third_floor_lobby", "Main_Entrance_Marker")
  SV.partner.Spawn = 'Default'
end


function guild_second_floor.Downwards_Stairs_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("guild_first_floor", "Guild_First_Floor_Stairs_Marker")
  SV.partner.Spawn = 'Guild_First_Floor_Stairs_Marker_Partner'
end

return guild_second_floor