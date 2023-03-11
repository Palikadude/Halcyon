require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

first_core_location_ch_3 = {}

function first_core_location_ch_3.RootPreviewScene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	--SOUND:PlayBGM('Time Gear Remix.ogg', false)
	GAME:CutsceneMode(true)
	GROUND:Hide(partner.EntName)
	GROUND:Hide(hero.EntName)
	UI:SetSpeaker(partner:GetDisplayName(), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	GAME:MoveCamera(276, 134, 1, false)
	GAME:FadeIn(40)
	
	UI:WaitShowDialogue("Nobody really knows where they are,[pause=10] but " .. CharacterEssentials.GetCharacterName("Relicanth") ..  " says they could be in all sorts of places.")
	UI:WaitShowDialogue("They could be in a dangerous volcano...[pause=0] In a ruined,[pause=10] ancient city lost to time...")
	UI:WaitShowDialogue("...Or they could be in a place as regular as a forest.")
	
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("Wherever they are in the world,[pause=10] they each serve a very important purpose.")
	UI:WaitShowDialogue("According to " .. CharacterEssentials.GetCharacterName("Relicanth") .. ",[pause=10] Anima Cores are what allow a region of the world to sustain life.")
	UI:WaitShowDialogue("If something was to break a region's Anima Core...")
	UI:WaitShowDialogue("Well,[pause=10] " ..  CharacterEssentials.GetCharacterName("Relicanth") .. " didn't seem too sure what would happen.")
	UI:WaitShowDialogue("But if I had to guess,[pause=10] that region would probably lose its ability to sustain life properly.")
	UI:WaitShowDialogue("It would be an absolute disaster if something ever happened to one of them.")
	
	GAME:WaitFrames(20)
	GAME:FadeOut(false, 40)
	SV.Chapter3.RootSceneTransition = true--mark this flag so the game knows to resume the cutscene in the proper place back in the hero room
	GAME:EnterGroundMap('guild_heros_room', 'Main_Entrance_Marker', true)

end

function first_core_location_ch_3.RootDeactivationScene()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	GROUND:Hide(partner.EntName)
	GROUND:Hide(hero.EntName)
	GAME:CutsceneMode(true)
	SOUND:StopBGM()
	GAME:MoveCamera(276, 134, 1, false)
	local root = OBJ('Anima_Root')
	local core = OBJ('Anima_Core')
	SOUND:FadeInSE('Anima Core Glow', 60)
	GAME:FadeIn(60)

	--setup darkness
	--It'll fade in for 200 frames, last 0 frames, and fade out in 0 frames. It'll transition to the darkness map status though at 200 frames.
	local overlay = RogueEssence.Content.FiniteOverlayEmitter()
    overlay.TotalTime = 0;
	overlay.FadeIn = 200;
	overlay.FadeOut = 0;
	overlay.Layer = DrawLayer.Top;
	overlay.Anim = RogueEssence.Content.BGAnimData("White", 0)
	overlay.Color = Color(0, 0, 0, 76/255)
	
	GROUND:ObjectSetDefaultAnim(root, 'Anima_Root', 10, 0, 15, Direction.Down)
	GROUND:ObjectSetDefaultAnim(core, 'Anima_Core', 10, 0, 31, Direction.Down)

	GROUND:ObjectWaitAnimFrame(core, 0)
	GROUND:ObjectWaitAnimFrame(core, 25)
	SOUND:FadeOutSE('Anima Core Glow', 60)
	GROUND:ObjectWaitAnimFrame(core, 0)
	
	SOUND:PlayBattleSE('EVT_EP_Nightmare_Break')
	GROUND:ObjectSetDefaultAnim(core, 'Core_Deactivation', 0, 0, 0, Direction.Down)

	GROUND:ObjectSetAnim(core, 10, 0, 11, Direction.Down, 1)
	GROUND:ObjectSetDefaultAnim(core, 'Core_Deactivation', 0, 11, 11, Direction.Down)
	
	GROUND:ObjectWaitAnimFrame(core, 11)
	GAME:WaitFrames(40)
	
	--move core slowly down after deactivating
	for i = 1, 10, 1 do
		GROUND:MoveObjectToPosition(core, core.Position.X, core.Position.Y + 1, 1)
		GAME:WaitFrames(8)
	end
	
	GROUND:ObjectWaitAnimFrame(root, 0)
	
	GROUND:PlayVFX(overlay, core.Position.X, core.Position.Y)
	SOUND:PlayBattleSE("_UNK_EVT_079")
	GROUND:ObjectSetDefaultAnim(root, 'Anima_Root_Turnoff', 0, 0, 0, Direction.Down)

	GROUND:ObjectSetAnim(root, 40, 0, 5, Direction.Down, 1)
	GROUND:ObjectSetDefaultAnim(root, 'Anima_Root_Turnoff', 0, 5, 5, Direction.Down)
	
	GAME:WaitFrames(200)
	GROUND:AddMapStatus("darkness")
	GAME:WaitFrames(180)
	GAME:FadeOut(false, 120)
	
	GAME:WaitFrames(60)
	UI:ResetSpeaker()
	
	--[[
	UI:WaitShowDialogue("That's the end of the demo! Thank you so much for playing.")
	UI:WaitShowDialogue("I worked so very hard on this project over the last couple of years...")
	UI:WaitShowDialogue("...So it means a lot that you would play it!")
	UI:WaitShowDialogue("Please let me know what you think! Writing, gameplay wise, anything!")
	UI:WaitShowDialogue("Oh, and if you find any bugs, please let me know too.")
	UI:WaitShowDialogue("Finishing this game is going to take a long time and a lot of work...")
	UI:WaitShowDialogue("...So any help you can provide, no matter how small, is huge!")
	UI:WaitShowDialogue("Especially any help with sprites! I want to include more custom sprite work in the future!")
	UI:WaitShowDialogue("Big thanks as always to Audino for all the help he provides and for making PMDO.")
	UI:WaitShowDialogue("Be sure to check the readme that came with Halcyon to see the rest of the credits!")
	UI:WaitShowDialogue("I'm going to reset the chapter 3 flags now.")
	UI:WaitShowDialogue("This will send you back to the start of chapter 3 plot-wise...")
	UI:WaitShowDialogue("But you'll keep any items, levels, and that sort of thing that you've gained.")
	UI:WaitShowDialogue("This'll let you playthrough again if you so wish.")
	UI:WaitShowDialogue("Alright. Resetting... Now!")
	GAME:WaitFrames(60)
	
	SV.Chapter3 = 
	{
		ShowedTitleCard = false,--Did the generic wakeup for the first day? Need a variable for this due to chapter 3 title card.
		FinishedOutlawIntro = false,--did shuca and ganlon teach you about outlaws?
		MetTeamStyle = false,--did you meet team style?
		FinishedCafeCutscene = false,--did partner point out the cafe's open?
		EnteredCavern = false,--did duo enter the dungeon?
		FailedCavern = false,--did duo die in cavern to either dungeon or the boss?
		EncounteredBoss = false,--did duo find team style in the dungeon yet?
		LostToBoss = false,--did duo die to boss?
		EscapedBoss = false,--due team use an escape orb to escape boss?
		DefeatedBoss = false, --did duo defeat team style?
		FinishedRootScene = false, --Showed root scene? This is used to mark the first half of chapter 3 (the non filler portion) as having been completed or not

		TropiusGaveWand = false,--did tropius give some wands to help the duo?
		BreloomGirafarigConvo = false --talked to breloom/girafarig about their expedition?
	}
	]]--
	
	SV.Chapter3.FinishedRootScene = true
	SV.ChapterProgression.CurrentStoryDungeon = ''--Clear the current story dungeon flag
	SV.TemporaryFlags.MorningAddress = true
	SV.TemporaryFlags.MorningWakeup = true
	GeneralFunctions.EndOfDay()
	GAME:CutsceneMode(false)
	GAME:EnterGroundMap('guild_heros_room', 'Main_Entrance_Marker')
end
	



return first_core_location_ch_3




