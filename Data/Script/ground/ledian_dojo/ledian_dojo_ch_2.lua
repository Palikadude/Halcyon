require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

ledian_dojo_ch_2 = {}

--NOTE: Gible and Ledian appear on the map without needing to be spawned in.
function ledian_dojo_ch_2.SetupGround()

end


--nothing to put here
function ledian_dojo_ch_2.Sensei_Action(chara, activator)
	
end 

function ledian_dojo_ch_2.Gible_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Isn't Sensei " .. CharacterEssentials.GetCharacterName("Ledian") .. " amazing?")
	GeneralFunctions.EndConversation(chara)
end


function ledian_dojo_ch_2.PreTrainingCutscene()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local gible = CH('Gible')
	local ledian = CH('Sensei')
	GROUND:Hide('Dungeon_Entrance')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	GAME:MoveCamera(204, 120, 1, false)
	GROUND:TeleportTo(ledian, 196, 340, Direction.Down)
	GROUND:TeleportTo(gible, 264, 172, Direction.DownLeft)	
	local lesson = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("beginner_lesson")
	local maze = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("normal_maze")
	GAME:FadeIn(20)

	GAME:WaitFrames(20)
	local coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(partner, "Exclaim", true) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) 
												  GeneralFunctions.EmoteAndPause(hero, "Exclaim", false) end)
	TASK:JoinCoroutines({coro1, coro2})

	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Wow![pause=0] I never realized there was a cavern like this beneath town!")
	UI:WaitShowDialogue("I've passed by that ladder so many times,[pause=10] but I've never actually been down here!")
	
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("This must be the dojo,[pause=10] right?")
	UI:WaitShowDialogue("Let's see if we can find the sensei so we can do our training.")
	GAME:WaitFrames(10)
	GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
	GAME:WaitFrames(20)
	
	GeneralFunctions.LookAround(partner, 2, 4, false, false, true, Direction.DownRight)
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(partner, "Notice", true)
	UI:WaitShowDialogue("Excuse me!")
	GAME:WaitFrames(8)

	GROUND:CharAnimateTurnTo(hero, Direction.DownRight, 4)
	GeneralFunctions.EmoteAndPause(gible, "Exclaim", true)
	GAME:WaitFrames(30)
	GROUND:CharAnimateTurnTo(gible, Direction.Left, 4)
	GROUND:MoveToPosition(gible, 208, 172, false, 1)
	GROUND:EntTurn(partner, Direction.Down)
	GROUND:EntTurn(hero, Direction.Down)
	GROUND:MoveToPosition(gible, 196, 160, false, 1)
	GROUND:CharAnimateTurnTo(gible, Direction.Up, 4)
	
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, gible.CurrentForm.Species, gible.CurrentForm.Form, gible.CurrentForm.Skin, gible.CurrentForm.Gender)
	UI:WaitShowDialogue("Yes?[pause=0] Is there something I can help you with?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("My partner and I here were sent by the guild to ask Sensei " .. ledian:GetDisplayName() .. " for the basic lesson.")
	UI:WaitShowDialogue("Do you know where she is?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, gible.CurrentForm.Species, gible.CurrentForm.Form, gible.CurrentForm.Skin, gible.CurrentForm.Gender)
	UI:WaitShowDialogue("Sensei " .. ledian:GetDisplayName() .. "?[pause=0] She's in one of the training areas.[pause=0] Right this way.")
	GAME:WaitFrames(20)

	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(gible, Direction.Down, 4)
												  GROUND:MoveToPosition(gible, 196, 208, false, 1) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(26)
												  GROUND:MoveToPosition(partner, 184, 184, false, 1) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(36)
												  GROUND:MoveToPosition(hero, 208, 184, false, 1) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(12)
												  GAME:MoveCamera(204, 192, 72, false) end)

	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	

	UI:WaitShowDialogue("Sensei " .. ledian:GetDisplayName() .. "![pause=0] Could you come out here?")
	GAME:WaitFrames(40)
	GROUND:MoveToPosition(ledian, 196, 240, false, 1)

	GAME:WaitFrames(90)
	
	UI:SetSpeaker(ledian)
	UI:SetSpeakerEmotion("Shouting")
	--GROUND:CharAnimateTurnTo(ledian, Direction.Up, 4)
	
	coro1 = TASK:BranchCoroutine(function()	ledian_dojo_ch_2.Hwacha(ledian) end)
	coro2 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue("HWACHA!", 40) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.Recoil(partner) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharSetEmote(hero, "exclaim", 1) end)	
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	GAME:WaitFrames(40)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Yes,[pause=10] what is it,[pause=10] " .. gible:GetDisplayName() .. ",[pause=10] my pupil?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(gible)
	UI:WaitShowDialogue("These apprentices from the guild are here for the basic lesson.")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(ledian)
	UI:WaitShowDialogue("Oh,[pause=10] is that so?")
	
	GAME:WaitFrames(20)

	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(gible, Direction.Right, 4)
											GROUND:MoveToPosition(gible, 256, 208, false, 1)
											GROUND:CharAnimateTurnTo(gible, Direction.Left, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(30)
											GROUND:MoveToPosition(ledian, 196, 208, false, 1) end)
											
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)
	
	UI:WaitShowDialogue("Hmm...")
	GAME:WaitFrames(20)
										
	--Ledian inspects the duo
	coro1 = TASK:BranchCoroutine(function() GROUND:AnimateToPosition(ledian, "Walk", Direction.Up, 176, 208, 1, 1, 0)
											GROUND:AnimateToPosition(ledian, "Walk", Direction.UpRight, 160, 192, 1, 1, 0)
											GROUND:AnimateToPosition(ledian, "Walk", Direction.Right, 160, 184, 1, 1, 0) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.FaceMovingCharacter(hero, ledian, 4, Direction.Left) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.FaceMovingCharacter(partner, ledian, 4, Direction.Left) end)

	TASK:JoinCoroutines({coro1, coro2, coro3})

	GAME:WaitFrames(60)
	
	coro1 = TASK:BranchCoroutine(function() GROUND:AnimateToPosition(ledian, "Walk", Direction.Right, 160, 184, 1, 1, 0)
											GROUND:AnimateToPosition(ledian, "Walk", Direction.UpRight, 176, 208, 1, 1, 0)
											GROUND:AnimateToPosition(ledian, "Walk", Direction.Up, 216, 208, 1, 1, 0)
											GROUND:AnimateToPosition(ledian, "Walk", Direction.UpLeft, 232, 192, 1, 1, 0)
											GROUND:AnimateToPosition(ledian, "Walk", Direction.Left, 232, 184, 1, 1, 0) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(hero, ledian, 4, Direction.Right) end)
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(partner, ledian, 4, Direction.Right) end)
	coro4 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(gible, ledian, 4, Direction.UpLeft) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	GAME:WaitFrames(60)
	
	coro1 = TASK:BranchCoroutine(function() GROUND:AnimateToPosition(ledian, "Walk", Direction.Left, 232, 176, 1, 1, 0)
											GROUND:AnimateToPosition(ledian, "Walk", Direction.DownLeft, 216, 160, 1, 1, 0)
											GROUND:AnimateToPosition(ledian, "Walk", Direction.Down, 196, 160, 1, 1, 0)
											GROUND:CharEndAnim(ledian) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(hero, ledian, 4, Direction.Up) end)
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(partner, ledian, 4, Direction.Up) 
											GROUND:EntTurn(partner, Direction.Up) end)
	coro4 = TASK:BranchCoroutine(function() GAME:MoveCamera(204, 168, 24, false) end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	GAME:WaitFrames(40)
	
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(partner, "Sweating", true) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) 
											GeneralFunctions.EmoteAndPause(hero, "Sweating", false) end)
	
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Shouting")

	coro1 = TASK:BranchCoroutine(function()	ledian_dojo_ch_2.Hwacha(ledian) end)
	coro2 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue("HWACHA!", 40) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.Recoil(partner) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharSetEmote(hero, "exclaim", 1) end)	
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	GAME:WaitFrames(60)
	
	--they're a bit unnerved by Ledian
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(partner, "Sweatdrop", true) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) 
											GeneralFunctions.EmoteAndPause(hero, "Sweatdrop", false) end)
	
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)
	
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Yes,[pause=10] you will make fine students in my dojo!")
	UI:WaitShowDialogue("Wahtah![pause=0] I am Sensei " .. ledian:GetDisplayName() .. "![pause=0] You are here for the basic lesson,[pause=10] yes?")
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(partner, "sweating", 1)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Stunned")
	UI:WaitShowDialogue("Y-yeah![pause=0] " .. CharacterEssentials.GetCharacterName("Noctowl") .. " sent us here to get trained.")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(ledian)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Hoiyah![pause=0] Very well![pause=0] You will do the " .. lesson:GetColoredName() .. " then.")
	UI:WaitShowDialogue("Hmm...[pause=0] But I sense that perhaps you may somehow already know the basics of adventuring,[pause=10] yes?")
	UI:WaitShowDialogue("If that is the case,[pause=10] you may train in the " .. maze:GetColoredName() .. ",[pause=10] one of the training mazes instead.")
	UI:WaitShowDialogue("Which will you choose?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Hmm...[pause=0] I'm not sure which one is best for us.")
	
	GAME:WaitFrames(12)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:SetSpeakerEmotion("Normal")
	UI:BeginChoiceMenu("Which one do you think we should do,[pause=10] " .. hero:GetDisplayName() .. "?", {lesson:GetColoredName() .. " (tutorial)", maze:GetColoredName() .. " (skip tutorial)"}, 1, 2)
	UI:WaitForChoice()
	local result = UI:ChoiceResult()	
	GAME:WaitFrames(20)
	
	if result == 2 then 
		UI:WaitShowDialogue("We'll do the " .. maze:GetColoredName() .. " then!")
		GAME:WaitFrames(20)
		
		GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
		GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
		UI:SetSpeaker(ledian)
		UI:WaitShowDialogue("Oohcha![pause=0] Do not be too hasty my students!")
		UI:BeginChoiceMenu("Are you sure you do not wish to do take the " ..  lesson:GetColoredName() .. "?[pause=0] It has much to teach!", {lesson:GetColoredName() .. " (tutorial)", maze:GetColoredName() .. " (skip tutorial)"}, 1, 2)
		UI:WaitForChoice()
		result = UI:ChoiceResult()
		GAME:WaitFrames(20)
			
	end 
	
	if result == 1 then 
		UI:SetSpeaker(partner)
		UI:WaitShowDialogue("We'll do the " .. lesson:GetColoredName() .. " then!")
		GAME:WaitFrames(20)
	end
	

	UI:SetSpeaker(ledian)
	UI:WaitShowDialogue("Hwacha![pause=0] Very well!")
	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	UI:WaitShowDialogue("But first,[pause=10] would you tell me your names,[pause=10] my students?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("O-oh,[pause=10] right.[pause=0] I'm " .. partner:GetDisplayName() .. " and my partner here is " .. hero:GetDisplayName() .. ".")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(ledian)
	UI:WaitShowDialogue("Hoiyah![pause=0] Ok!")
	GAME:WaitFrames(20)
	
	if result == 1 then
		GROUND:CharTurnToCharAnimated(ledian, hero, 4)
		UI:WaitShowDialogue(hero:GetDisplayName() .. ",[pause=10] you will come with me for your lesson.")
		
		GAME:WaitFrames(12)
		GROUND:CharTurnToCharAnimated(ledian, partner, 4)
		UI:WaitShowDialogue(partner:GetDisplayName() .. ",[pause=10] you will go with " .. gible:GetDisplayName() .. ",[pause=10] my star pupil for your lesson.")
		
		GAME:WaitFrames(20)
		UI:SetSpeaker(gible)
		UI:WaitShowDialogue("That would be me![pause=0] Hello!")
		
		GAME:WaitFrames(20)
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Surprised")
		UI:WaitShowDialogue("Huh?[pause=0] You're splitting us up?")
		
		GAME:WaitFrames(16)
		GROUND:CharAnimateTurnTo(ledian, Direction.Down, 4)
		UI:SetSpeaker(ledian)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("It is much easier to teach one-on-one.[pause=0] You will both be taking the same lesson though,[pause=10] worry not.")
		UI:WaitShowDialogue("You should know that dojo lessons take place in a special environment.")
		UI:WaitShowDialogue("Any sort of physical progress that happens within dojo lessons is self-contained!")
		UI:WaitShowDialogue("Hoiyah![pause=0] That is to say,[pause=10] items,[pause=10] experience,[pause=10] money,[pause=10] moves,[pause=10] party members...")
		UI:WaitShowDialogue("Any gained in the lesson are not kept when leaving a dojo lesson!")
		UI:WaitShowDialogue("Your level will also be set to 5 when you enter the lesson and your money and items sent to storage!")
		UI:WaitShowDialogue("Your proper level will be restored once you leave the lesson.")
		UI:WaitShowDialogue("Be sure to visit " .. CharacterEssentials.GetCharacterName('Kangaskhan') .. " and " .. CharacterEssentials.GetCharacterName('Murkrow') .. " in town after to get your belongings back!")
		UI:WaitShowDialogue("Wahtah![pause=0] This is all necessary so you can properly train your mind!")
		UI:WaitShowDialogue("Dojo lessons are for learning,[pause=10] not training![pause=0] And learn much you will!")
		UI:WaitShowDialogue("Oohcha![pause=0] Let us not delay any further![pause=0] Let us begin with the lesson!")

		GAME:WaitFrames(40)
		
		coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(hero, Direction.Left, 4)
												GROUND:AnimateInDirection(hero, "Walk", Direction.Left, Direction.Right, 8, 1, 1) 
												GAME:WaitFrames(22)
												GeneralFunctions.FaceMovingCharacter(hero, ledian, 4, Direction.Down) 
												GAME:WaitFrames(10)
												GROUND:MoveInDirection(hero, Direction.Down, 136, false, 1) end)
		coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
												GROUND:AnimateInDirection(partner, "Walk", Direction.Right, Direction.Left, 8, 1, 1) 
												GAME:WaitFrames(22)
												GeneralFunctions.FaceMovingCharacter(partner, ledian, 4, Direction.Down) 
												GAME:WaitFrames(10)
												GROUND:MoveInDirection(partner, Direction.Down, 136, false, 1) end)										
		coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
												GROUND:MoveInDirection(ledian, Direction.Down, 196, false, 1) end)
		coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
												GeneralFunctions.FaceMovingCharacter(gible, ledian, 4, Direction.Left) 
												GAME:WaitFrames(10)
												GROUND:MoveToPosition(gible, 224, 240, false, 1)
												GROUND:MoveInDirection(gible, Direction.Down, 120, false, 1) end)
		local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(136) SOUND:FadeOutBGM() GAME:FadeOut(false, 40) end)
	
	
		TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})

		SV.Chapter2.StartedTraining = true
		GeneralFunctions.SendInvToStorage()--clear inventory
		GAME:CutsceneMode(false)
		GAME:UnlockDungeon("beginner_lesson")
		GAME:EnterDungeon("beginner_lesson", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.None, true, false)
	end 
	
	if result == 2 then 
		UI:WaitShowDialogue("I will show you to the " .. maze:GetColoredName() .. " then![pause=0] Hwacha!")
		UI:WaitShowDialogue("Training mazes act similarly to mystery dungeons,[pause=10] but are designed for training!")
		UI:WaitShowDialogue("Any items and money on you when you enter will be sent to storage though.")
		UI:WaitShowDialogue("Be sure to visit " .. CharacterEssentials.GetCharacterName('Kangaskhan') .. " and " .. CharacterEssentials.GetCharacterName('Murkrow') .. " in town after to get your belongings back!")
		UI:WaitShowDialogue("Hoiyah![pause=0] Enough talk![pause=0] Now,[pause=10] let us begin your training!")

		GAME:WaitFrames(40)
		
		coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(hero, Direction.Left, 4)
												GROUND:AnimateInDirection(hero, "Walk", Direction.Left, Direction.Right, 8, 1, 1) 
												GAME:WaitFrames(20)
												GeneralFunctions.FaceMovingCharacter(hero, ledian, 4, Direction.Down) 
												GAME:WaitFrames(10)
												GROUND:MoveInDirection(hero, Direction.Down, 136, false, 1) end)
		coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
												GROUND:AnimateInDirection(partner, "Walk", Direction.Right, Direction.Left, 8, 1, 1) 
												GAME:WaitFrames(20)
												GeneralFunctions.FaceMovingCharacter(partner, ledian, 4, Direction.Down) 
												GAME:WaitFrames(10)
												GROUND:MoveInDirection(partner, Direction.Down, 136, false, 1) end)										
		coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
												GROUND:MoveInDirection(ledian, Direction.Down, 196, false, 1) end)
		local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(120) SOUND:FadeOutBGM() GAME:FadeOut(false, 40) end)
	
	
		TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

		SV.Chapter2.StartedTraining = true
		SV.Chapter2.SkippedTutorial = true
		GeneralFunctions.SendInvToStorage()--clear inventory
		GAME:CutsceneMode(false)
		GAME:UnlockDungeon("normal_maze")
		GAME:EnterDungeon("normal_maze", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
	end
end

--used for Ledian's HWACHA! - similar to Yoomtah!
function ledian_dojo_ch_2.Hwacha(chara)
	--setup flashes
	local emitter = RogueEssence.Content.FlashEmitter()
	emitter.FadeInTime = 2
	emitter.HoldTime = 4
	emitter.FadeOutTime = 2
	emitter.StartColor = Color(0, 0, 0, 0)
	emitter.Layer = DrawLayer.Top
	emitter.Anim = RogueEssence.Content.BGAnimData("White", 0)
	GROUND:CharSetAnim(chara, "Hop", true)
	GROUND:PlayVFX(emitter, chara.Position.X, chara.Position.Y)
	SOUND:PlayBattleSE("EVT_Battle_Flash")
	GAME:WaitFrames(14)
	GROUND:PlayVFX(emitter, chara.Position.X, chara.Position.Y)
	SOUND:PlayBattleSE("EVT_Battle_Flash")
	GAME:WaitFrames(10)
	GROUND:CharEndAnim(chara)
end 

--cutscene that plays if you fail the training maze or tutorial before finishing it for the first time
function ledian_dojo_ch_2.FailedTrainingCutscene()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local gible = CH('Gible')
	local ledian = CH('Sensei')
	GROUND:Hide('Dungeon_Entrance')
	GAME:CutsceneMode(true)
	GAME:MoveCamera(204, 184, 1, false)
	SOUND:StopBGM()
	AI:DisableCharacterAI(partner)
	if SV.Chapter2.SkippedTutorial then
		GROUND:TeleportTo(ledian, 196, 176, Direction.Down)
		GROUND:TeleportTo(hero, 208, 200, Direction.Up)	
		GROUND:TeleportTo(partner, 184, 200, Direction.Up)
		local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("normal_maze")
		GAME:FadeIn(40)
		
		GAME:WaitFrames(20)
		GeneralFunctions.EmoteAndPause(partner, 'Sweating', true)
		GAME:WaitFrames(20)
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Pain")
		UI:WaitShowDialogue("Urgh...[pause=0] This training is harder than I was expecting...")
		
		GAME:WaitFrames(20)
		UI:SetSpeaker(ledian)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("Hoiyah![pause=0] The journey to a stronger self is not an easy one.")
		UI:WaitShowDialogue("This is simply one of the hardships you will encounter on the path to success.")
		UI:WaitShowDialogue("Wahtah![pause=0] If you continue to seek victory,[pause=10] it cannot continue to hide!")
		UI:WaitShowDialogue("Go and give it your all again!")
		
		GAME:WaitFrames(20)
		GROUND:CharTurnToCharAnimated(partner, hero, 4)
		GROUND:CharTurnToCharAnimated(hero, partner, 4)
		
		GAME:WaitFrames(20)
		local coro1 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(hero, 'Nod') end)
		local coro2 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(partner, 'Nod') end)
		TASK:JoinCoroutines({coro1, coro2})
		
		GAME:WaitFrames(20)
		coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
							GROUND:MoveInDirection(hero, Direction.Down, 120, false, 1) end)
		coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
							GROUND:MoveInDirection(partner, Direction.Down, 120, false, 1) end)
		local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(60) GAME:FadeOut(false, 40) end)
		TASK:JoinCoroutines({coro1, coro2, coro3})
		
		GAME:CutsceneMode(false)
		GAME:EnterDungeon("normal_maze", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
	else
		GROUND:TeleportTo(ledian, 196, 176, Direction.Down)
		GROUND:TeleportTo(hero, 196, 200, Direction.Up)	
		GROUND:Hide('Teammate1')
		GROUND:Hide('Gible')
		local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("beginner_lesson")
		GAME:FadeIn(40)
		
		GAME:WaitFrames(20)
		GeneralFunctions.EmoteAndPause(hero, 'Sweating', true)
		GAME:WaitFrames(20)
		GeneralFunctions.HeroDialogue(hero, "(Urf...[pause=0] This is tough...)", "Pain")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(ledian)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("Not all lessons are easy to learn![pause=0] Don't let this roadblock deter you!")
		UI:WaitShowDialogue("Hwacha![pause=0] Keep pursuing success,[pause=10] and all obstacles will be conquered!")
		UI:WaitShowDialogue("Come on![pause=0] Give it another try!")
	
		
		GAME:WaitFrames(20)
		local coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
							GROUND:MoveInDirection(hero, Direction.Down, 120, false, 1) end)
		local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
							GROUND:MoveInDirection(ledian, Direction.Down, 120, false, 1) end)
		local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(60) GAME:FadeOut(false, 40) end)
		TASK:JoinCoroutines({coro1, coro2, coro3})
		
		GAME:CutsceneMode(false)
		GAME:EnterDungeon("beginner_lesson", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.None, true, false)
	end
end 



--cutscene that plays after finishing training maze or tutorial for first time.
function ledian_dojo_ch_2.PostTrainingCutscene()
	
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local gible = CH('Gible')
	local ledian = CH('Sensei')
	GROUND:Hide('Dungeon_Entrance')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	GAME:MoveCamera(204, 184, 1, false)
	if SV.Chapter2.SkippedTutorial then
		GROUND:TeleportTo(ledian, 196, 176, Direction.Down)
		GROUND:TeleportTo(hero, 208, 200, Direction.Up)	
		GROUND:TeleportTo(partner, 184, 200, Direction.Up)
		GROUND:EntTurn(gible, Direction.UpLeft)
		local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("normal_maze")
		GAME:FadeIn(40)
		
		GAME:WaitFrames(40)
		GeneralFunctions.EmoteAndPause(ledian, 'Exclaim', true)
		UI:SetSpeaker(ledian)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("Hoiyah![pause=0] You did it![pause=0] You successfully completed the " .. zone:GetColoredName() .."!")
		
		GAME:WaitFrames(20)
		UI:SetSpeakerEmotion("Shouting")
		local coro1 = TASK:BranchCoroutine(function()	ledian_dojo_ch_2.Hwacha(ledian) end)
		local coro2 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue("HWACHA!", 40) end)
		local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
										GROUND:CharSetEmote(hero, "exclaim", 1) end)	
		local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
										GeneralFunctions.Recoil(partner) end)
		TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
		
		GAME:WaitFrames(20)
		GROUND:CharTurnToCharAnimated(partner, hero, 4)
		GROUND:CharTurnToCharAnimated(hero, partner, 4)
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Joyous")
		GeneralFunctions.Hop(partner)
		GeneralFunctions.Hop(partner)
		GROUND:CharSetEmote(partner, "glowing", 0)
		GROUND:CharSetAnim(partner, "Idle", true)
		UI:WaitShowDialogue("We did it,[pause=10] " .. hero:GetDisplayName() .. "!")
		
		GAME:WaitFrames(20)
		UI:SetSpeaker(ledian)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("Wahtah![pause=0] Congratulations to the both of you for finishing the " .. zone:GetColoredName() .. "!")
		
		GROUND:CharEndAnim(partner)
		GROUND:CharSetEmote(partner, "", 0)
		GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
		GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
		
		UI:WaitShowDialogue("But this is only the beginning of your journey!")
		UI:WaitShowDialogue("Hwacha![pause=0] There is still so much training for you ahead!")
		--Training mazes and more advanced lessons will unlock with certain rank thresholds. Some may be unlocked as you progress in the game anyway. Still figuring this out.
		UI:WaitShowDialogue("There will be more training mazes and lessons for you to take as you grow as an adventurer!")
		UI:WaitShowDialogue("So please come back anytime you wish to train or learn![pause=0] Hoiyah!")
		
		GAME:WaitFrames(20)
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("We will![pause=0] Thank you Sensei " .. ledian:GetDisplayName() .. "!")
		
		GAME:WaitFrames(20)
		UI:SetSpeaker(ledian)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("Wahtah![pause=0] Until we meet again!")
		
		GAME:WaitFrames(20)
		GeneralFunctions.PanCamera()
		
		GAME:UnlockDungeon("beginner_lesson")--unlock the basic lesson 
		GROUND:Unhide("Dungeon_Entrance")
		SV.Chapter2.FinishedDojoCutscenes = true
		AI:EnableCharacterAI(partner)
		AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)
		GAME:CutsceneMode(false)
	else 
		GROUND:TeleportTo(ledian, 196, 176, Direction.Down)
		GROUND:TeleportTo(hero, 196, 200, Direction.Up)	
		GROUND:TeleportTo(partner, 184, 320, Direction.Up)
		GROUND:TeleportTo(gible, 208, 320, Direction.Up)
		GeneralFunctions.CenterCamera({ledian, hero})
		local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("beginner_lesson")
		GAME:FadeIn(40)
		
		GAME:WaitFrames(40)
		GeneralFunctions.EmoteAndPause(ledian, 'Exclaim', true)
		UI:SetSpeaker(ledian)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("Hoiyah![pause=0] You did it![pause=0] You successfully completed the " .. zone:GetColoredName() .."!")
			
		GAME:WaitFrames(20)
		UI:SetSpeakerEmotion("Shouting")
		local coro1 = TASK:BranchCoroutine(function() ledian_dojo_ch_2.Hwacha(ledian) end)
		local coro2 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue("HWACHA!", 40) end)
		local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
										GROUND:CharSetEmote(hero, "exclaim", 1) end)	
		TASK:JoinCoroutines({coro1, coro2, coro3})
		
		GAME:WaitFrames(40)
		GeneralFunctions.EmoteAndPause(ledian, "Notice", true)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("Hoiyah![pause=0] It appears that you are not the only one to have finished the " .. zone:GetColoredName() .. "!")
		
		
		coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) 
												GROUND:MoveToPosition(partner, 184, 280, false, 1)
												GeneralFunctions.EmoteAndPause(partner, "Exclaim", true)
												GROUND:MoveToPosition(partner, 184, 224, false, 1)
												GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
		coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(gible, 208, 224, false, 1) end)
		coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
												GROUND:CharSetEmote(hero, "exclaim", 1) end)

		TASK:JoinCoroutines({coro1, coro2, coro3})

		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Inspired")
		GROUND:CharTurnToChar(hero, partner)
		UI:WaitShowDialogue(hero:GetDisplayName() .. "![pause=0] You completed the " .. zone:GetColoredName() .. " too?")
		GeneralFunctions.Hop(partner)
		GeneralFunctions.Hop(partner)
		UI:SetSpeakerEmotion("Joyous")
		GROUND:CharSetEmote(partner, "glowing", 0)
		GROUND:CharSetAnim(partner, "Idle", true)
		UI:WaitShowDialogue("That's amazing![pause=0] We did it!")
		
		GAME:WaitFrames(20)
		UI:SetSpeaker(ledian)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("Wahtah![pause=0] Congratulations to the both of you for finishing the " .. zone:GetColoredName() .. "!")
		
		GROUND:CharEndAnim(partner)
		GROUND:CharSetEmote(partner, "", 0)
		GROUND:CharTurnToCharAnimated(partner, ledian, 4)
		GROUND:CharTurnToCharAnimated(hero, ledian, 4)
		
		UI:WaitShowDialogue("But this is only the beginning of your journey!")
		UI:WaitShowDialogue("Hwacha![pause=0] There is still so much training for you ahead!")
		--Training mazes and more advanced lessons will unlock with certain rank thresholds. Some may be unlocked as you progress in the game anyway. Still figuring this out.
		UI:WaitShowDialogue("There will be more training mazes and lessons for you to take as you grow as an adventurer!")
		UI:WaitShowDialogue("So please come back anytime you wish to train or learn![pause=0] Hoiyah!")
		
		GAME:WaitFrames(20)
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("We will![pause=0] Thank you Sensei " .. ledian:GetDisplayName() .. "!")
		
		GAME:WaitFrames(20)
		UI:SetSpeaker(ledian)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("Wahtah![pause=0] Until we meet again!")
		
		GAME:WaitFrames(20)
		GeneralFunctions.PanCamera()
		
		GAME:UnlockDungeon("normal_maze")--unlock the first training maze 
		GROUND:Unhide("Dungeon_Entrance")
		SV.Chapter2.FinishedDojoCutscenes = true
		AI:EnableCharacterAI(partner)
		AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)
		GAME:CutsceneMode(false)


	end 
	

end
