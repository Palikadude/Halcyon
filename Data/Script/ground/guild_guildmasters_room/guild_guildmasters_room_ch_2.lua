require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

guild_guildmasters_room_ch_2 = {}


function guild_guildmasters_room_ch_2.Tropius_Action(chara, activator)
	if not SV.Chapter2.FinishedTraining then 
		GeneralFunctions.StartConversation(chara, "Howdy,[pause=10] Team " .. GAME:GetTeamName() .. "![pause=0] Good luck training with Sensei " .. CharacterEssentials.GetCharacterName("Ledian") .. " today!")
	else 
		--He gives you a reviver seed as a one-off to help you with your mission
		if not SV.Chapter2.TropiusGaveReviver then 
			GeneralFunctions.StartConversation(chara, "Howdy,[pause=10] Team " .. GAME:GetTeamName() .. "![pause=0] I heard that you got your first mission already!")
			UI:WaitShowDialogue("I want you to take this.[pause=0] It'll help you if you encounter trouble!")
			GAME:WaitFrames(20)
			GeneralFunctions.RewardItem("seed_reviver")
			GAME:WaitFrames(20)
			UI:SetSpeaker(CH('Teammate1'))
			UI:SetSpeakerEmotion("Inspired")
			GROUND:CharSetEmote(CH('Teammate1'), "happy", 0)
			UI:WaitShowDialogue("Wow![pause=0] Thank you Guildmaster!")
			GAME:WaitFrames(20)
			GROUND:CharSetEmote(CH('Teammate1'), "", 0)
			UI:SetSpeaker(chara)
			UI:SetSpeakerEmotion("Happy")
			UI:WaitShowDialogue("Of course![pause=0] Good luck with the job![pause=0] I know you can do it!")
			SV.Chapter2.TropiusGaveReviver = true
		elseif not SV.Chapter2.EnteredRiver then 
			GeneralFunctions.StartConversation(chara, "Good luck with the job![pause=0] I know you can do it!", "Happy")
		else--failed the dungeon at least once 
			GeneralFunctions.StartConversation(chara, "Having trouble with your mission?[pause=0] Jobs can be tough sometimes!")
			UI:SetSpeakerEmotion("Happy")
			UI:WaitShowDialogue("I know you can do it though.[pause=0] Just keep at it!")
		end
	end
	GeneralFunctions.EndConversation(chara)
end


--TASK:BranchCoroutine(guild_guildmasters_room_ch_2.MeetGuildmaster)
function guild_guildmasters_room_ch_2.NoctowlTropiusScene()
	local tropius = CH('Tropius')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GROUND:TeleportTo(tropius, 296, 208, Direction.Right)
	local noctowl, numel = 
		CharacterEssentials.MakeCharactersFromList({
			{"Noctowl", 184, 360, Direction.Up},
			{"Numel"}
		})
	SOUND:StopBGM()
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	--keep them offscreen for the entire cutscene
	GROUND:TeleportTo(hero, 400, 400, Direction.Up)
	GROUND:TeleportTo(partner, 400, 400, Direction.Up)
	
	GAME:MoveCamera(304, 216, 1, false)
	
	--window + nighttime darkness
	local groundObj = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Night_Window", 1, 0, 0), 
													   RogueElements.Rect(160, 24, 64, 64),
													   RogueElements.Loc(0, 0), 
													   false, 
													   "Window_Cutscene")
	groundObj:ReloadEvents()
	GAME:GetCurrentGround():AddTempObject(groundObj)
	GROUND:AddMapStatus("darkness")
	
	GAME:WaitFrames(100)
	GAME:FadeIn(40)
	
	GROUND:MoveToPosition(noctowl, 184, 272, false, 1)
	
	GAME:WaitFrames(20)
	GeneralFunctions.LookAround(noctowl, 1, 4, false, false, true, Direction.UpRight)
	GeneralFunctions.EmoteAndPause(noctowl, "Notice", true)
	
	GROUND:MoveToPosition(noctowl, 248, 208, false, 1)
	GROUND:MoveToPosition(noctowl, 256, 208, false, 1)
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("Guildmaster.")
	
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(tropius, "Notice", true)
	GAME:WaitFrames(10)
	
	GROUND:CharTurnToCharAnimated(tropius, noctowl, 4)
	UI:SetSpeaker(tropius)
	UI:WaitShowDialogue("Oh,[pause=10] howdy " .. noctowl:GetDisplayName() .. ".[pause=0] I didn't notice you come in.")
	UI:WaitShowDialogue("What's up?[pause=0] I was about to get ready for bed.[pause=0]\nI was just finishing up in here.")

	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("There is something that I wanted to bring to your attention as soon as I could,[pause=10] Guildmaster.")
	UI:WaitShowDialogue("The new recruits.[pause=0] You are aware of their successful mission today,[pause=10] correct?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(tropius)
	UI:WaitShowDialogue(hero:GetDisplayName() .. " and " .. partner:GetDisplayName() .. "?[pause=0] Yup,[pause=10] they were raving about it at dinner.")
	UI:SetSpeakerEmotion("Happy")
	GROUND:CharSetEmote(tropius, "glowing", 0)
	UI:WaitShowDialogue("They were ecstatic about their first completed job.[pause=0] Good on them!")
	UI:WaitShowDialogue("They're showing good potential,[pause=10] don't you think?")
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(tropius, "", 0)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("Indeed they are.[pause=0] However,[pause=10] their accomplishment today is not what I wanted to discuss.")
	
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(tropius, "Question", true)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("What did you want to discuss exactly,[pause=10] then?")
	
	local numel_species = _DATA:GetMonster(numel.CurrentForm.Species):GetColoredName()
	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("While Team " .. GAME:GetTeamName() .. " was rescuing the young " .. numel_species .. " today,[pause=10] they made a discovery.")
	UI:WaitShowDialogue("Luminous Spring no longer appears to be functioning.")
	
	GAME:WaitFrames(10)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Surprised")
	SOUND:PlayBattleSE('EVT_Emote_Shock_2')
	GeneralFunctions.EmoteAndPause(tropius, "Shock", false)
	--SOUND:PlayBGM('Growing Anxiety.ogg', true)
	UI:WaitShowDialogue("What!?[pause=0] Are you serious!?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("I am afraid so,[pause=10] Guildmaster.[pause=0] I have not been able to confirm this myself,[pause=10] yet.")
	UI:WaitShowDialogue("But I believe we should take their claim at face value.")
	
	GAME:WaitFrames(40)
	UI:WaitShowDialogue("Do you think that there could be an issue with the...?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("...I hope not.[pause=0] But it's possible.[pause=0] There's no way to tell for sure.")
	
	
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("What should we do,[pause=10] Guildmaster?")
	
	--SOUND:FadeOutBGM(120)
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(tropius, Direction.Up, 8)
	GAME:WaitFrames(60)
	GROUND:CharTurnToCharAnimated(tropius, noctowl, 4)
	UI:SetSpeaker(tropius)
	UI:WaitShowDialogue("For right now,[pause=10] there isn't a whole lot we can do.")
	UI:WaitShowDialogue("This spring issue could be an isolated incident for all we know.")
	UI:WaitShowDialogue("If that's the case,[pause=10] we don't want to cause a false panic.") 
	UI:WaitShowDialogue("If it isn't,[pause=10] we need to be prepared.[pause=0] We should do what we can in the meantime,[pause=10] just in case.")
	
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("...Let's just hope this spring issue isn't a sign of worse to come.")
	
	GAME:WaitFrames(20)
	GAME:FadeOut(false, 120)	
	GAME:WaitFrames(120)
	GAME:CutsceneMode(false)
	
	--demo only, let player know end of demo
	--UI:ResetSpeaker()
	--UI:WaitShowDialogue("Thus ends Chapter 2, and thus ends the demo! Thank you for playing!")
	--UI:WaitShowDialogue("I hope you enjoyed it as much as I enjoyed making it.")
	--UI:WaitShowDialogue("Let me know if you found any bugs, what you enjoyed, what you didn't like.")
	--UI:WaitShowDialogue("Your feedback is invaluable to improving Halcyon!")
	--UI:WaitShowDialogue("I'll be setting plot flags to Chapter 3 now (none of which is scripted out).")
	--UI:WaitShowDialogue("Things may be unstable in this state as nothing is really properly programmed out for chapter 3.")
	--UI:WaitShowDialogue("But it's better than being stuck in a black screen, right?")
	--UI:WaitShowDialogue("Alright. Returning control... now!")
	
	--no temporary flags need to be set here.
	SV.ChapterProgression.Chapter = 3
	SV.ChapterProgression.CurrentStoryDungeon = "crooked_cavern" -- Crooked Cavern
	SV.Dojo.NewMazeUnlocked = true
	GAME:UnlockDungeon("grass_maze")--unlock new mazes at ledian dojo
	GAME:UnlockDungeon("fire_maze")--unlock new mazes at ledian dojo
	GAME:UnlockDungeon("water_maze")--unlock new mazes at ledian dojo
	GAME:UnlockDungeon("crooked_cavern")--unlock chapter 3 dungeon
	GeneralFunctions.EndOfDay()--reset daily flags and increment day counter by 1
	GeneralFunctions.PromptChapterSaveAndQuit("guild_heros_room", "Main_Entrance_Marker", 2)
	
end

return guild_guildmasters_room_ch_2