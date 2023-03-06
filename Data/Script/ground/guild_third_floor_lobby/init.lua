--[[
    init.lua
    Created: 06/28/2021 23:00:22--i've been copy and pasting this data so this timestamp is a couple days off lul, same for the bedroom areas
    Description: Autogenerated script file for the map guild_third_floor_lobby.
]]--
-- Commonly included lua functions and data
require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'AudinoAssembly'
require 'ground.guild_third_floor_lobby.guild_third_floor_lobby_ch_1'
require 'ground.guild_third_floor_lobby.guild_third_floor_lobby_ch_2'
require 'ground.guild_third_floor_lobby.guild_third_floor_lobby_ch_3'
require 'ground.guild_third_floor_lobby.guild_third_floor_lobby_helper'


-- Package name
local guild_third_floor_lobby = {}

-- Local, localized strings table
-- Use this to display the named strings you added in the strings files for the map!
-- Ex:
--      local localizedstring = MapStrings['SomeStringName']
local MapStrings = {}

-------------------------------
-- Map Callbacks
-------------------------------
---guild_third_floor_lobby.Init
--Engine callback function
function guild_third_floor_lobby.Init(map)
	DEBUG.EnableDbgCoro()
	print('=>> Init_guild_third_floor_lobby<<=')
	MapStrings = COMMON.AutoLoadLocalizedStrings()
	COMMON.RespawnAllies()
	PartnerEssentials.InitializePartnerSpawn()


	if not SV.ChapterProgression.UnlockedAssembly then--hide audino at her assembly if it isn't unlocked yet
		GROUND:Hide('Assembly')
		GROUND:Hide('Assembly_Owner')
	end


end

---guild_third_floor_lobby.Enter
--Engine callback function
function guild_third_floor_lobby.Enter(map)
	guild_third_floor_lobby.PlotScripting()
end

---guild_third_floor_lobby.Exit
--Engine callback function
function guild_third_floor_lobby.Exit(map)


end

---guild_third_floor_lobby.Update
--Engine callback function
function guild_third_floor_lobby.Update(map)


end


function guild_third_floor_lobby.GameLoad(map)
	PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
	guild_third_floor_lobby.PlotScripting()
end

function guild_third_floor_lobby.GameSave(map)
	PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function guild_third_floor_lobby.PlotScripting()
	--if generic morning address is flagged, prioritize that.
	if SV.TemporaryFlags.MorningAddress then 
		guild_third_floor_lobby.MorningAddress(true)
	else
	--plot scripting	
		if SV.ChapterProgression.Chapter == 1 then
			if SV.Chapter1.TeamCompletedForest and not SV.Chapter1.TeamJoinedGuild then 
				guild_third_floor_lobby_ch_1.GoToGuildmasterRoom()
			else
				guild_third_floor_lobby_ch_1.SetupGround()
			end
		elseif SV.ChapterProgression.Chapter == 2 then
			if not SV.Chapter2.FirstMorningMeetingDone then
				guild_third_floor_lobby_ch_2.FirstMorningMeeting()
			elseif SV.Chapter2.FinishedNumelTantrum and not SV.Chapter2.FinishedFirstDay then 
				guild_third_floor_lobby_ch_2.BeforeFirstDinner()
			else
				guild_third_floor_lobby_ch_2.SetupGround()
			end
		elseif SV.ChapterProgression.Chapter == 3 then
			if not SV.Chapter3.FinishedOutlawIntro then
				guild_third_floor_lobby_ch_3.FirstMorningAddress()
			else 
				guild_third_floor_lobby_ch_3.SetupGround()
			end
		else
			GAME:FadeIn(20)
		end
	end
end

--potentially calls relevant scripts after a generic morning address was given. This would be stuff like
--Anything that happens after a completely generic opening should be called from here. If it wasn't completely generic, it won't be called from here.
--noctowl giving the day's mission or a comment from the partner.
function guild_third_floor_lobby.PostAddressScripting()
	if SV.ChapterProgression.Chapter == 2 then
		if SV.Chapter2.FinishedFirstDay and not SV.Chapter2.FinishedCameruptRequestScene then
			guild_third_floor_lobby_ch_2.PostSecondMorningAddress()--Noctowl will show you to the board for your first job.
		elseif SV.Chapter2.EnteredRiver then 
			guild_third_floor_lobby_ch_2.FailedRiver()--partner mentions that you need to go return to Illuminant Riverbed to rescue numel
		end
	elseif SV.ChapterProgression.Chapter == 3 then 
		if SV.Chapter3.DefeatedBoss then --Second half of chapter 3, after defeating team style. 
			guild_third_floor_lobby.GenericMissions()
		elseif SV.Chapter3.EncounteredBoss then 
			guild_third_floor_lobby_ch_3.FailedCavernAfterBoss()--You made it to Team Style but haven't beaten them yet. Partner is mad about them. 
		elseif SV.TemporaryFlags.LastDungeonEntered ~= 57 then 
			guild_third_floor_lobby_ch_3.NotEnteredCavern() --Latest dungeon attempt was not the cavern and you haven't seen Team Style yet.
		else
			guild_third_floor_lobby_ch_3.FailedCavernBeforeBoss()--Your last dungeon was the cavern but you've not made it to Team Style yet.
		end	
	else --if there's nothing special to do, just give back control. I don't think this block should be reached in normal play.
		GeneralFunctions.PanCamera()
		GAME:CutsceneMode(false)
		AI:EnableCharacterAI(CH('Teammate1'))
		AI:SetCharacterAI(CH('Teammate1'), "ai.ground_partner", CH('PLAYER'), CH('Teammate1').Position)
	end
end


function guild_third_floor_lobby.GenericMissions()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local noctowl = CH('Noctowl')
	
	GROUND:CharAnimateTurnTo(noctowl, Direction.DownLeft, 4)
	
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("Team " .. GAME:GetTeamName() .. ".[pause=0] Allow me to give you your assignment for the day.")
	
	GAME:WaitFrames(16)
	GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4)
	GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4)
	
	UI:WaitShowDialogue("Complete requests from the Job Bulletin Board and the Outlaw Notice Board.")
	UI:WaitShowDialogue("That will be all for today.[pause=0] I wish you luck in your day's endeavors.")
	
	GROUND:CharAnimateTurnTo(noctowl, Direction.Down, 4)
	GAME:WaitFrames(20)
	
	GeneralFunctions.PanCamera()
	GAME:CutsceneMode(false)
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)
end

function guild_third_floor_lobby.MorningAddress(generic)
	
	if generic == nil then generic = false end 
	
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')

	local tropius, noctowl, audino, snubbull, growlithe, zigzagoon, girafarig, 
		  breloom, mareep, cranidos = guild_third_floor_lobby_helper.SetupMorningAddress()

	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Normal")
	GROUND:CharSetEmote(tropius, "happy", 0)
	UI:WaitShowDialogue("One for all...")
	GAME:WaitFrames(20)
	

	UI:SetSpeaker('[color=#00FFFF]Everyone[color]', true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	GROUND:CharSetEmote(tropius, "", 0)
	GROUND:CharSetEmote(growlithe, "happy", 0)
	GROUND:CharSetEmote(zigzagoon, "happy", 0)
	GROUND:CharSetEmote(mareep, "happy", 0)
	GROUND:CharSetEmote(breloom, "happy", 0)
	GROUND:CharSetEmote(audino, "happy", 0)
	GROUND:CharSetEmote(partner, "happy", 0)
	UI:WaitShowDialogue("AND ALL FOR ONE!")
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(growlithe, "", 0)
	GROUND:CharSetEmote(zigzagoon, "", 0)
	GROUND:CharSetEmote(mareep, "", 0)
	GROUND:CharSetEmote(breloom, "", 0)
	GROUND:CharSetEmote(audino, "", 0)
	GROUND:CharSetEmote(partner, "", 0)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Alright Pokémon,[pause=10] let's get to the day's adventures!")
	GAME:WaitFrames(20)
	
	--HURRAH!
	GROUND:CharSetEmote(growlithe, "happy", 0)
	GROUND:CharSetEmote(zigzagoon, "happy", 0)
	GROUND:CharSetEmote(mareep, "happy", 0)
	GROUND:CharSetEmote(breloom, "happy", 0)
	GROUND:CharSetEmote(audino, "happy", 0)	
	GROUND:CharSetEmote(partner, "happy", 0)

	--turn pokemon on the edges up so pose is appropriate
	GROUND:EntTurn(growlithe, Direction.Up)
	GROUND:EntTurn(zigzagoon, Direction.Up)
	GROUND:EntTurn(hero, Direction.Up)
	GROUND:EntTurn(partner, Direction.Up)
	
	GROUND:CharSetAction(growlithe, RogueEssence.Ground.PoseGroundAction(growlithe.Position, growlithe.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(zigzagoon, RogueEssence.Ground.PoseGroundAction(zigzagoon.Position, zigzagoon.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(breloom, RogueEssence.Ground.PoseGroundAction(breloom.Position, breloom.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(girafarig, RogueEssence.Ground.PoseGroundAction(girafarig.Position, girafarig.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(cranidos, RogueEssence.Ground.PoseGroundAction(cranidos.Position, cranidos.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(mareep, RogueEssence.Ground.PoseGroundAction(mareep.Position, mareep.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(audino, RogueEssence.Ground.PoseGroundAction(audino.Position, audino.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(snubbull, RogueEssence.Ground.PoseGroundAction(snubbull.Position, snubbull.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))	
	GROUND:CharSetAction(partner, RogueEssence.Ground.PoseGroundAction(partner.Position, partner.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))	
	GROUND:CharSetAction(hero, RogueEssence.Ground.PoseGroundAction(hero.Position, hero.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))	
	UI:SetSpeaker('[color=#00FFFF]Everyone[color]', true, "", -1, "", RogueEssence.Data.Gender.Unknown)	
	UI:WaitShowDialogue("HURRAH!")
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(growlithe, "", 0)
	GROUND:CharSetEmote(zigzagoon, "", 0)
	GROUND:CharSetEmote(mareep, "", 0)
	GROUND:CharSetEmote(breloom, "", 0)
	GROUND:CharSetEmote(audino, "", 0)	
	GROUND:CharSetEmote(partner, "", 0)

	GROUND:CharEndAnim(growlithe)
	GROUND:CharEndAnim(zigzagoon)
	GROUND:CharEndAnim(breloom)
	GROUND:CharEndAnim(girafarig)
	GROUND:CharEndAnim(cranidos)
	GROUND:CharEndAnim(mareep)
	GROUND:CharEndAnim(audino)
	GROUND:CharEndAnim(snubbull)	
	GROUND:CharEndAnim(partner)	
	GROUND:CharEndAnim(hero)	
	
	--everyone leaves
	GAME:WaitFrames(40)
	local coro1 = TASK:BranchCoroutine(function() guild_third_floor_lobby_helper.ApprenticeLeave(growlithe) end)
	local coro2 = TASK:BranchCoroutine(function() --GAME:WaitFrames(6) 
											guild_third_floor_lobby_helper.ApprenticeLeaveBottom(zigzagoon) end)
	local coro3 = TASK:BranchCoroutine(function() --GAME:WaitFrames(10)
											guild_third_floor_lobby_helper.ApprenticeLeave(mareep) end)
	local coro4 = TASK:BranchCoroutine(function() --GAME:WaitFrames(18)
											guild_third_floor_lobby_helper.ApprenticeLeaveBottom(cranidos) end)
	local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											guild_third_floor_lobby_helper.ApprenticeLeaveFast(snubbull) end)
	local coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											guild_third_floor_lobby_helper.ApprenticeLeaveBottomFast(audino) end)
	local coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											guild_third_floor_lobby_helper.ApprenticeLeaveFast(breloom) end)
	local coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											guild_third_floor_lobby_helper.ApprenticeLeaveBottomFast(girafarig) end)
	local coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(16) 
											GROUND:CharAnimateTurnTo(partner, Direction.Right, 4) end)
	local coro10 = TASK:BranchCoroutine(function() GAME:WaitFrames(26) 
											 GROUND:CharAnimateTurnTo(hero, Direction.Right, 4) end)
	local coro11 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
													GeneralFunctions.CenterCamera({hero, partner}, GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 1) end)
	local coro12 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) 
												   GROUND:CharAnimateTurnTo(tropius, Direction.Up, 4)
												   GROUND:MoveInDirection(tropius, Direction.Up, 24, false, 1)
												   GAME:GetCurrentGround():RemoveTempChar(tropius) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9, coro10, coro11, coro12})


	if generic then 
		--call post address scripting to see if anything additional is needed if address is generic 
		print("generic address.")
		SV.TemporaryFlags.MorningAddress = false
		guild_third_floor_lobby.PostAddressScripting()
		--[[the commented out functionality below was moved to the scripts that post address scripting calls		
		GeneralFunctions.PanCamera()
		GAME:CutsceneMode(false)
		AI:EnableCharacterAI(partner)
		AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)	]]--
	end

	
end 



---------------------------------
-- Event Object
-- This is a temporary object created by a script used for temporary objects events that only happen
-- that only exist when certain story flag conditions are met.
---------------------------------
function guild_third_floor_lobby.Event_Object_1_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("guild_third_floor_lobby_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Event_Object_1_Action(...,...)"), obj, activator))
end




---------------------------
-- Map Objects 
---------------------------
function guild_third_floor_lobby.Board_Action(chara, activator)
	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue("(There are a number of internal guild postings here...)")
	UI:WaitShowDialogue("(...But you're not really sure what to make of them yet.)")
	UI:SetCenter(false)
end




-------------------------------
-- Entities Callbacks
-------------------------------
function guild_third_floor_lobby.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function guild_third_floor_lobby.Noctowl_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("guild_third_floor_lobby_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Noctowl_Action(...,...)"), chara, activator))
end

function guild_third_floor_lobby.Test_Action(chara, activator)
	SV.Chapter1.MetSnubbull = true
	SV.Chapter1.MetZigzagoon = true
	SV.Chapter1.MetCranidosMareep = true
	SV.Chapter1.MetBreloomGirafarig = true
	SV.Chapter1.MetAudino = false
	SV.Chapter1.TeamJoinedGuild = true

	UI:SetSpeaker(chara)
	UI:WaitShowDialogue("All guildmates now considered met.")
	local coro1 = TASK:BranchCoroutine(function() UI:WaitShowTitle("Chapter 1\n\nAnother Beginning\n", 20)
												  GAME:WaitFrames(120)
												  UI:WaitHideTitle(20) end)
	local coro2 = TASK:BranchCoroutine(function() UI:WaitShowBG("Chapter_1", 120, 20)
												  GAME:WaitFrames(120)
												  UI:WaitHideBG(20) end)
	TASK:JoinCoroutines({coro1, coro2})
	
	UI:WaitShowDialogue("poop " .. STRINGS:LocalKeyString(9))

end

function guild_third_floor_lobby.Assembly_Action(obj, activator)
	AudinoAssembly.Assembly(CH('Assembly_Owner'))
end

---------------------------
-- Map Transitions
---------------------------
function guild_third_floor_lobby.Right_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("guild_bedroom_hallway", 'Main_Entrance_Marker')
  SV.partner.Spawn = 'Default'
end

function guild_third_floor_lobby.Left_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("guild_dining_room", 'Main_Entrance_Marker')
  SV.partner.Spawn = 'Default'
end

function guild_third_floor_lobby.Bottom_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("guild_storage_hallway", 'Main_Entrance_Marker')
  SV.partner.Spawn = 'Default'
end

function guild_third_floor_lobby.Door_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("guild_guildmasters_room", 'Main_Entrance_Marker')
  SV.partner.Spawn = 'Default'
end

function guild_third_floor_lobby.Stairs_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("guild_second_floor", 'Guild_Second_Floor_Upwards_Stairs_Marker')
  SV.partner.Spawn = 'Guild_Second_Floor_Upwards_Stairs_Marker_Partner'
end




return guild_third_floor_lobby

