require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

luminous_spring_ch_2 = {}


function luminous_spring_ch_2.FindNumelCutscene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local numel = CharacterEssentials.MakeCharactersFromList({{"Numel", 292, 288, Direction.Up}})

	AI:DisableCharacterAI(partner)
	SOUND:StopBGM()
	
	GROUND:TeleportTo(hero, 276, 624, Direction.Up)
	GROUND:TeleportTo(partner, 308, 624, Direction.Up)
	GAME:MoveCamera(300, 600, 1, false)
		
	GAME:CutsceneMode(true)
	UI:ResetSpeaker()
	UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
	GAME:WaitFrames(60)
	UI:WaitHideTitle(20)
	GAME:FadeIn(20)
	
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
	SOUND:FadeOutBGM()
	UI:WaitShowDialogue("Oh![pause=0] " .. hero:GetDisplayName() .. "![pause=0] Look over there!")
	GAME:WaitFrames(20)
	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:MoveCamera(300, 296, 92, false) end)
	
	
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(numel)
	UI:SetSpeakerEmotion("Teary-Eyed")
	UI:WaitShowDialogue("Sniff...")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Look![pause=0] There he is![pause=0] It's " .. numel:GetDisplayName() .. "!")
	GAME:WaitFrames(20)
	
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 308, 320, false, 2) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:MoveToPosition(hero, 276, 320, false, 2) end)
											
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(10)	
	
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(numel:GetDisplayName() .. "![pause=0] There you are![pause=0] We found him,[pause=10] " .. hero:GetDisplayName() .. "!")
	GAME:WaitFrames(20)
	
	GeneralFunctions.EmoteAndPause(numel, "Notice", true)
	UI:SetSpeaker(numel)
	UI:SetSpeakerEmotion("Teary-Eyed")
	UI:WaitShowDialogue("Huh?")
	
	GAME:WaitFrames(12)
	GROUND:CharAnimateTurnTo(numel, Direction.Down, 4)
	GAME:WaitFrames(10)
	
	GeneralFunctions.Recoil(numel)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Wh-who are y-you g-guys?[pause=0] P-please d-don't hurt m-me!")
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(partner, 5, 1)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Woah,[pause=10] we're not gonna hurt you![pause=0] We wouldn't dream of it!")	
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("We're Team " .. GAME:GetTeamName() .. "![pause=0] We're an adventuring team and we're here to rescue you!")
	
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(numel, "Exclaim", true)
	UI:SetSpeaker(numel)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("You're an adventuring team?")
	
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Yup![pause=0] We're going to bring you back to Metano Town!")
	
	GAME:WaitFrames(20)
	GeneralFunctions.Hop(numel)
	GeneralFunctions.Hop(numel)
	
	UI:SetSpeakerEmotion("Joyous")
	GROUND:CharSetEmote(numel, 4, 0)
	UI:WaitShowDialogue("Hooray![pause=0] I was starting to think I'd be stuck here forever!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("But " .. numel:GetDisplayName() .. "...[pause=0] How did you wind up out here anyway?")
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(numel, -1, 0)
	UI:SetSpeaker(numel)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("Well...[pause=0] My mom is always trying to boss me around...")
	UI:WaitShowDialogue("I figured that if I was bigger she couldn't tell me what to do anymore.")
	UI:WaitShowDialogue("So I snuck out of the house while she was sleeping and came here so I could evolve...[pause=0] But...")
	GROUND:CharAnimateTurnTo(numel, Direction.Up, 4) 
	GeneralFunctions.Complain(numel, true)
	UI:SetSpeakerEmotion("Angry")
	UI:WaitShowDialogue("The stupid spring doesn't even work![pause=0]")
	
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(partner, "Question", true)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("The spring doesn't work?[pause=0] What do you mean?")
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(numel, -1, 0)
	GROUND:CharAnimateTurnTo(numel, Direction.Down, 4)
	UI:SetSpeaker(numel)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Well,[pause=10] you're supposed to stand under the light in the spring,[pause=10] then you hear a voice and get to evolve...")
	UI:WaitShowDialogue("But when I stand under the light,[pause=10] nothing happens![pause=0] I don't even hear a voice!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("That's odd...")
	GAME:WaitFrames(20)
	
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Let me give it a try.[pause=0] Maybe it'll work for me?")
	GAME:WaitFrames(20)
	
	--coro1 = TASK:BranchCoroutine()
	
	--todo: have an npc in town describe what evolving is
	
	

	--hero gets a strange feeling similar to that in relic forest when standing in the light, but not a good one
	
	
	
	
	
end
	


return luminous_spring_ch_2




