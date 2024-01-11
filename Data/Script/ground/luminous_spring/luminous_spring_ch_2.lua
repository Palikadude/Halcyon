require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

luminous_spring_ch_2 = {}


function luminous_spring_ch_2.FindNumelCutscene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local numel = CharacterEssentials.MakeCharactersFromList({{"Numel", 292, 248, Direction.Up}})
	GAME:WaitFrames(60)
	AI:DisableCharacterAI(partner)
	SOUND:StopBGM()
	
	GROUND:TeleportTo(hero, 276, 624, Direction.Up)
	GROUND:TeleportTo(partner, 308, 624, Direction.Up)
	GAME:MoveCamera(300, 600, 1, false)
	--Start numel's trembling
	--GeneralFunctions.StartTremble(numel)
		
	GAME:CutsceneMode(true)
	UI:ResetSpeaker()
	UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
	GAME:WaitFrames(60)
	UI:WaitHideTitle(20)
	GAME:FadeIn(40)
	
	SOUND:PlayBGM('In The Depths of the Pit.ogg', true)
	
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 308, 488, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:MoveToPosition(hero, 276, 488, false, 1) end)
												  
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("Hmm...[pause=10] We've made it pretty far...")
	GAME:WaitFrames(20)
	
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:WaitShowDialogue("Do you think we've made it to Luminous Spring?")
	UI:WaitShowDialogue("If this is Luminous Spring,[pause=10] then where could " .. numel:GetDisplayName() .. " be?")
	
	GAME:WaitFrames(20)
	
	GeneralFunctions.LookAround(partner, 4, 4, true, false, false, Direction.Up)
	GeneralFunctions.EmoteAndPause(partner, "Exclaim", true)
	UI:SetSpeakerEmotion("Surprised")
	SOUND:FadeOutBGM(120)
	UI:WaitShowDialogue("Oh![pause=0] " .. hero:GetDisplayName() .. "![pause=0] Look over there!")
	GAME:WaitFrames(20)
	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:MoveCamera(300, 478, 1, false)
											GAME:MoveCamera(300, 256, 116, false) end)
	
	
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(numel)
	UI:SetSpeakerEmotion("Teary-Eyed")
	UI:WaitShowDialogue("Sniff...[pause=0] Momma...[pause=0] I never should have ran away...")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Look![pause=0] There he is![pause=0] It's " .. numel:GetDisplayName() .. "!")
	
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 308, 280, false, 2) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:MoveToPosition(hero, 276, 280, false, 2) end)
											
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(10)	
	
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(numel:GetDisplayName() .. "![pause=0] There you are![pause=0] We found him,[pause=10] " .. hero:GetDisplayName() .. "!")
	GAME:WaitFrames(20)
	
	--GeneralFunctions.StopTremble(numel)	
	GeneralFunctions.EmoteAndPause(numel, "Notice", true)
	UI:SetSpeaker(numel)
	UI:SetSpeakerEmotion("Teary-Eyed")
	UI:WaitShowDialogue("Huh?")
	
	GAME:WaitFrames(12)
	GROUND:CharAnimateTurnTo(numel, Direction.Down, 4)
	GAME:WaitFrames(10)
	
	GeneralFunctions.Recoil(numel)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Wh-who are y-you guys?[pause=0] P-please d-don't hurt me!")
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(partner, "sweating", 1)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Woah,[pause=10] we're not gonna hurt you![pause=0] We wouldn't dream of it!")	
	UI:SetSpeakerEmotion("Normal")
	SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true)
	UI:WaitShowDialogue("We're Team " .. GAME:GetTeamName() .. "![pause=0] We're an adventuring team and we're here to rescue you!")
	
	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(numel, "Exclaim", true)
	UI:SetSpeaker(numel)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("You're an adventuring team?")
	
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Yup![pause=0] We're here to bring you back to Metano Town!")
	
	GAME:WaitFrames(10)
	SOUND:PlayBattleSE('EVT_Emote_Startled_2')
	GeneralFunctions.Hop(numel)
	GeneralFunctions.Hop(numel)
	
	UI:SetSpeaker(numel)
	UI:SetSpeakerEmotion("Joyous")
	GROUND:CharSetEmote(numel, "glowing", 0)
	UI:WaitShowDialogue("Really!?[pause=0] Hooray![pause=0] I was starting to think I'd be stuck here forever!")
	UI:WaitShowDialogue("I used up all my energy to get here![pause=0] I was too tired to make the trip back!")
	UI:WaitShowDialogue("But now,[pause=10] I'm saved![pause=0] Thank you!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Of course![pause=0] We're just glad you're safe!")
	GAME:WaitFrames(20)
	SOUND:FadeOutBGM(120)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("But,[pause=10] before we go,[pause=10] " .. numel:GetDisplayName() .. "...[pause=0] Can you tell us how you wound up out here?")
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(numel, "", 0)
	UI:SetSpeaker(numel)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("Well...[pause=0] My mom is always trying to boss me around...")
	UI:WaitShowDialogue("She always has me doing all sorts of boring and tiring chores...")
	UI:WaitShowDialogue("I thought that if I was grown up she couldn't tell me what to do anymore.")
	UI:WaitShowDialogue("So I snuck out of the house while she was sleeping and came here so I could evolve...[pause=0] But...")
	GROUND:CharAnimateTurnTo(numel, Direction.Up, 4) 
	GAME:WaitFrames(10)
	GeneralFunctions.Complain(numel, true)
	UI:SetSpeakerEmotion("Angry")
	UI:WaitShowDialogue("The stupid spring doesn't even work![pause=0] I did all this for nothing!")
	
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(partner, "Question", true)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("The spring doesn't work?[pause=0] What do you mean?")
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(numel, "", 0)
	GROUND:CharAnimateTurnTo(numel, Direction.Down, 4)
	UI:SetSpeaker(numel)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Well,[pause=10] you're supposed to stand under the light in the spring,[pause=10] then you hear a voice and get to evolve...")
	UI:WaitShowDialogue("But when I stand under the light,[pause=10] nothing happens![pause=0]\nI don't even hear a voice!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("That's odd...")
	GAME:WaitFrames(20)
	
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Let me give it a try.[pause=0] Maybe it'll work for me?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(numel)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("I guess you may as well give it a shot...")
	
	GAME:WaitFrames(20)
	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(numel, Direction.Right, 4) 
											GROUND:MoveToPosition(numel, 324, 248, false, 1)
											GeneralFunctions.FaceMovingCharacter(numel, partner, 4, Direction.Up) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GeneralFunctions.EightWayMove(partner, 292, 248, false, 1)
											GeneralFunctions.MoveCharAndCamera(partner, 292, 192, false, 1)
											GROUND:CharAnimateTurnTo(partner, Direction.Down, 4) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(60)
												  GROUND:MoveInDirection(hero, Direction.Up, 32, false, 1) end)
											

	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("Like this,[pause=10] right?")
	
	GAME:WaitFrames(20)
	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue("...........................")
	--GAME:WaitFrames(20)
	--UI:WaitShowDialogue("...........................")
	UI:SetCenter(false)
	GAME:WaitFrames(80)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("...Nothing's happening.[pause=0] I don't hear a voice either.")
	UI:WaitShowDialogue("Guess it doesn't work for me.")
	
	GAME:WaitFrames(10)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(hero:GetDisplayName() .. ",[pause=10] why don't you give it a try?")
	GAME:WaitFrames(20)

	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(hero, 292, 216, false, 1)
											GROUND:MoveToPosition(hero, 292, 192, false, 1) 
											GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) end)
	coro2 = TASK:BranchCoroutine(function()	GAME:WaitFrames(8)
											GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
											GROUND:MoveToPosition(partner, 340, 192, false, 1)
											GROUND:CharAnimateTurnTo(partner, Direction.Left, 4) end)
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(numel, hero, 4, Direction.Up) end)
											

	TASK:JoinCoroutines({coro1, coro2, coro3})
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(I just stand here,[pause=10] then?[pause=0] This is pretty weird...)", "Worried")
	
	GAME:WaitFrames(20)
	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue("...........................")
	GAME:WaitFrames(20)
	GeneralFunctions.Shake(hero)
	GAME:WaitFrames(10)
	UI:SetCenter(false)
	GeneralFunctions.EmoteAndPause(hero, "Notice", true)
	GeneralFunctions.HeroDialogue(hero, "(I'm feeling something...[pause=0] strange.)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(Could it be however this evolution thing is supposed to feel?)", "Worried")
	GAME:WaitFrames(40)
	
	GeneralFunctions.HeroDialogue(hero, "(...No.[pause=0] It can't be.[pause=0] This weird tension,[pause=10] I've felt it before...[pause=0] But where?)", "Worried")
	
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("relic_forest")
	GAME:WaitFrames(40)
	SOUND:PlayBattleSE('EVT_Emote_Exclaim_Idea')
	GeneralFunctions.EmoteAndPause(hero, 'Exclaim', false)	
	GeneralFunctions.HeroDialogue(hero, "(Oh,[pause=10] that's right!)", "Surprised")
	GeneralFunctions.HeroDialogue(hero, "(I felt this way back in " .. zone:GetColoredName() .. "![pause=0] When I touched that stone tablet!)", "Surprised")
	
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(Something feels different this time though.[pause=0] It's making me a bit nauseous,[pause=10] actually.)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(...Is there something wrong with the spring?)", "Worried")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	SOUND:PlayBGM('In The Depths of the Pit.ogg', true)
	UI:WaitShowDialogue("Nothing's happening for you too,[pause=10] huh " .. hero:GetDisplayName() .. "?")
	
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("It's a bit concerning that the spring doesn't seem to be working...")
	UI:WaitShowDialogue("We should let " .. CharacterEssentials.GetCharacterName("Noctowl") .. " know about this when we get back.")
	
	GAME:WaitFrames(20)
	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, numel, 4) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) end)
	
	TASK:JoinCoroutines({coro1, coro2})
	
	GROUND:CharTurnToCharAnimated(numel, partner, 4)
	
	UI:WaitShowDialogue(numel:GetDisplayName() .. ",[pause=10] are you ready to go home?[pause=0] Your poor mom is worried sick about you!")
	
	
	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(numel, "Exclaim", true)
	UI:SetSpeaker(numel)
	UI:SetSpeakerEmotion("Teary-Eyed")
	UI:WaitShowDialogue("Oh...[pause=0] My poor momma...[pause=0] I probably made her so worried about me...")
	GAME:WaitFrames(20)
	--GeneralFunctions.ShakeHead(numel, 4, true)
	
	GAME:WaitFrames(20)
	GeneralFunctions.Hop(numel)
	UI:WaitShowDialogue("Yes![pause=0] Please take me home![pause=0] I want to see my momma again!")
	

	GAME:WaitFrames(30)
	SOUND:FadeOutBGM(60)
	GAME:FadeOut(false, 60)	
	GAME:WaitFrames(90)
	SV.Chapter2.FinishedRiver = true 
	GAME:CutsceneMode(false)
	GAME:EnterGroundMap("guild_second_floor", "Main_Entrance_Marker")

	
end
	


return luminous_spring_ch_2




