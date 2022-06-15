--[[
    init.lua
    Created: 06/28/2021 23:00:22
    Description: Autogenerated script file for the map guild_heros_room.
]]--
-- Commonly included lua functions and data
require 'common'
require 'PartnerEssentials'
require 'ground.guild_heros_room.guild_heros_room_ch_1'
require 'ground.guild_heros_room.guild_heros_room_ch_2'


-- Package name
local guild_heros_room = {}

-- Local, localized strings table
-- Use this to display the named strings you added in the strings files for the map!
-- Ex:
--      local localizedstring = MapStrings['SomeStringName']
local MapStrings = {}

-------------------------------
-- Map Callbacks
-------------------------------
---guild_heros_room.Init
--Engine callback function
function guild_heros_room.Init(map)
	DEBUG.EnableDbgCoro()
	print('=>> Init_guild_heros_room<<=')
	MapStrings = COMMON.AutoLoadLocalizedStrings()
	COMMON.RespawnAllies()
	PartnerEssentials.InitializePartnerSpawn()


end

---guild_heros_room.Enter
--Engine callback function
function guild_heros_room.Enter(map)
	guild_heros_room.PlotScripting()
end

---guild_heros_room.Exit
--Engine callback function
function guild_heros_room.Exit(map)


end

---guild_heros_room.Update
--Engine callback function
function guild_heros_room.Update(map)


end

function guild_heros_room.GameLoad(map)
	PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
	guild_heros_room.PlotScripting()
end

function guild_heros_room.GameSave(map)
	PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function guild_heros_room.PlotScripting()
	--if generic morning is flagged, prioritize that.
	if SV.TemporaryFlags.MorningWakeup or SV.TemporaryFlags.Bedtime then 
		if SV.TemporaryFlags.Bedtime then guild_heros_room.Bedtime(true) end
		GAME:WaitFrames(90)
		if SV.TemporaryFlags.MorningWakeup then guild_heros_room.Morning(true) end
	else
		--plot scripting
		if SV.ChapterProgression.Chapter == 1 then
			if SV.Chapter1.TeamCompletedForest and not SV.Chapter1.TeamJoinedGuild then
				guild_heros_room_ch_1.RoomIntro()
			else
				GAME:FadeIn(20)
			end		
		elseif SV.ChapterProgression.Chapter == 2 then
			if not SV.Chapter2.FirstMorningMeetingDone then 
				guild_heros_room_ch_2.FirstMorning()
			elseif SV.Chapter2.FinishedNumelTantrum and not SV.Chapter2.FinishedFirstDay then
				guild_heros_room_ch_2.FirstNightBedtalk()
			elseif SV.Chapter2.FinishedRiver then
				guild_heros_room_ch_2.PostRiverBedtalk()
			else
				GAME:FadeIn(20)
			end
		else 
			GAME:FadeIn(20)
		end
	end
end



---------------------------------
-- Event Trigger
-- This is a temporary object created by a script used to trigger events that only happen
-- once, typically a cutscene of sorts for a particular chapter.
---------------------------------
function guild_heros_room.Event_Trigger_1_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("guild_heros_room_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Event_Trigger_1_Touch(...,...)"), obj, activator))
end











------------------------------------
--Special Functions
------------------------------------
function guild_heros_room.Bedtime(generic)
--if generic is true, do a generic nighttime cutscene and relevant processing. 
--if generic is false, just make the room look like it's night and put the duo in bed.
	if generic == nil then generic = false end
	
	local groundObj = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Night_Window", 1, 0, 0), 
													RogueElements.Rect(176, 56, 64, 64),
													RogueElements.Loc(0, 0), 
													false, 
													"Window_Cutscene")
	groundObj:ReloadEvents()
	GAME:GetCurrentGround():AddTempObject(groundObj)
	GROUND:AddMapStatus(50)
	SOUND:StopBGM()--cut bgm so it doesn't kick in until we want it to
	AI:DisableCharacterAI(CH('Teammate1'))

	local hero_bed = MRKR('Hero_Bed')
	local partner_bed = MRKR('Partner_Bed')
	GROUND:Hide("Save_Point")--disable bed saving
	GROUND:TeleportTo(CH('PLAYER'), hero_bed.Position.X, hero_bed.Position.Y, Direction.Right)
	GROUND:TeleportTo(CH('Teammate1'), partner_bed.Position.X, partner_bed.Position.Y, Direction.Left)
	GeneralFunctions.CenterCamera({CH('PLAYER'), CH('Teammate1')})

	
	--todo: generic 
	if generic then 
		local partner = CH('Teammate1')
		local hero = CH('PLAYER')
		GAME:CutsceneMode(true)
		GAME:FadeIn(20)
		SOUND:PlayBGM('Goodnight.ogg', true)
		GAME:WaitFrames(40)
		UI:SetSpeaker(partner)
		UI:WaitShowDialogue("Today was tiring.[pause=0] We should get some rest so we can give it our all tomorrow!")
		UI:WaitShowDialogue("OK,[pause=10] good night,[pause=10] " .. hero:GetDisplayName() .. ".")
		SOUND:FadeOutBGM()
		GAME:FadeOut(false, 60)
		SV.TemporaryFlags.Bedtime = false 
		GROUND:RemoveMapStatus(50)
		GAME:CutsceneMode(false)
		GAME:GetCurrentGround():RemoveTempObject(groundObj)
	end
end

function guild_heros_room.Morning(generic)
	if generic == nil then generic = true end
	
	if generic then 
		GAME:FadeOut(false, 1)--fadeout if we aren't already
		local hero = CH('PLAYER')
		local partner = CH('Teammate1')
		GAME:CutsceneMode(true)
		AI:DisableCharacterAI(partner)
		UI:ResetSpeaker()
		SOUND:StopBGM()
		GROUND:CharSetAnim(hero, 'EventSleep', true)
		GROUND:CharSetAnim(partner, 'EventSleep', true)
		GROUND:Hide('Bedroom_Exit')--disable map transition object
		GROUND:Hide("Save_Point")--disable bed saving
		local hero_bed = MRKR('Hero_Bed')
		local partner_bed = MRKR('Partner_Bed')
		GROUND:TeleportTo(CH('PLAYER'), hero_bed.Position.X, hero_bed.Position.Y, Direction.Down)
		GROUND:TeleportTo(CH('Teammate1'), partner_bed.Position.X, partner_bed.Position.Y, Direction.Down)
		GeneralFunctions.CenterCamera({hero, partner})
		GAME:WaitFrames(60)--wait a bit just in case we didn't wait before starting this scene 

		local audino =
			CharacterEssentials.MakeCharactersFromList({
				{"Audino", 120, 204, Direction.UpRight},
			})
			
		UI:SetAutoFinish(true)
		UI:WaitShowVoiceOver("The next morning...\n\n", -1)
		UI:SetAutoFinish(false)
	
		GAME:WaitFrames(60)
		UI:SetSpeaker(audino)
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("Good morning sleepyheads![pause=0] It's a bright new day!")
		GAME:FadeIn(20)
		GAME:WaitFrames(20)
	
		GROUND:CharAnimateTurnTo(audino, Direction.Down, 4)
		GAME:WaitFrames(10)
		SOUND:PlayBattleSE("DUN_Heal_Bell")
		GROUND:CharPoseAnim(audino, "Pose")
		GAME:WaitFrames(100)
		GROUND:CharEndAnim(audino)
		GAME:WaitFrames(10)
		GROUND:CharAnimateTurnTo(audino, Direction.Left, 4)
		GROUND:MoveToPosition(audino, 0, 204, false, 2)
		GAME:GetCurrentGround():RemoveTempChar(audino)

		--todo: add shakes 
		coro1 = TASK:BranchCoroutine(function () GAME:WaitFrames(10)
												 GeneralFunctions.DoAnimation(hero, 'Wake') 
												 GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) 
												 GAME:WaitFrames(20) end)
		coro2 = TASK:BranchCoroutine(function () GeneralFunctions.DoAnimation(partner, 'Wake') 
												 GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
												 GAME:WaitFrames(20) end)
		TASK:JoinCoroutines({coro1, coro2})
		
		GROUND:CharTurnToCharAnimated(partner, hero, 4)
		GROUND:CharTurnToCharAnimated(hero, partner, 4)
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Happy")
		SOUND:PlayBGM("Wigglytuff's Guild.ogg", true)
		UI:WaitShowDialogue("Good morning,[pause=10] " .. hero:GetDisplayName() .. "!")	
		GAME:WaitFrames(20)
		GeneralFunctions.PanCamera()
		GAME:WaitFrames(20)
		GROUND:CharEndAnim(hero)
		GROUND:CharEndAnim(partner)
		GROUND:Unhide("Bedroom_Exit")
		GROUND:Unhide("Save_Point")
		GAME:CutsceneMode(false)
		AI:EnableCharacterAI(partner)
		AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)
		
		SV.guild.JustWokeUp = true
		SV.TemporaryFlags.MorningWakeup = false
	end
	
end

function guild_heros_room.Save_Point_Touch(obj, activator)
	if SV.ChapterProgression.Chapter == 1 then
		guild_heros_room_ch_1.Save_Bed_Dialogue(obj, activator)--partner talks to you a bit in chapter 1 before you try to save, as going to sleep is the trigger to end the chapter
	else
		GeneralFunctions.PromptSaveAndQuit()
	end
end
-------------------------------


-- Entities Callbacks
-------------------------------
function guild_heros_room.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

---------------------------
-- Map Transitions
---------------------------
function guild_heros_room.Bedroom_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  if SV.guild.JustWokeUp then --skip the hallway if we just woke up and queue up the morning 
	SV.guild.JustWokeUp = false
	--SV.TemporaryFlags.MorningAddress = true
	GAME:EnterGroundMap("guild_third_floor_lobby", "Guild_Third_Floor_Lobby_Right_Marker")
	SV.partner.Spawn = 'Guild_Third_Floor_Lobby_Right_Marker_Partner'
  else
	GAME:EnterGroundMap("guild_bedroom_hallway", "Guild_Bedroom_Hallway_Right_Marker")
	SV.partner.Spawn = 'Guild_Bedroom_Hallway_Right_Marker_Partner'
  end
end

return guild_heros_room

