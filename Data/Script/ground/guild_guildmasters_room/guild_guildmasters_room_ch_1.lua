require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'

guild_guildmasters_room_ch_1 = {}

function guild_guildmasters_room_ch_1.MeetGuildmaster()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local tropius = CH('Tropius')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	GAME:MoveCamera(192, 94, 1, false) 
	
	local noctowl = 
		CharacterEssentials.MakeCharactersFromList({
			{"Noctowl", 184, 288, Direction.Up}
		})
	
	GROUND:TeleportTo(hero, 168, 344, Direction.Up)
	GROUND:TeleportTo(partner, 200, 344, Direction.Up)
	
	GAME:FadeIn(20)
	
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(noctowl, 184, 224, false, 1) 
												  GeneralFunctions.EightWayMove(noctowl, 152, 120, false, 1) 
												  GROUND:CharAnimateTurnTo(noctowl, Direction.DownRight, 4) end) 
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
												  GROUND:MoveToPosition(hero, 168, 152, false, 1) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:MoveToPosition(partner, 200, 152, false, 1) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})	
	GAME:WaitFrames(40)
	
	--noctowl tells tropius
	GROUND:CharTurnToCharAnimated(noctowl, tropius, 4)
	GROUND:CharTurnToCharAnimated(tropius, noctowl, 4)
	UI:SetSpeaker(noctowl)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("These are the two Pokémon I told you about,[pause=10] Guildmaster.")
	
	GROUND:CharTurnToCharAnimated(noctowl, hero, 4)
	GROUND:CharTurnToCharAnimated(tropius, hero, 4)
	GAME:WaitFrames(20)
	UI:SetSpeaker('Guildmaster', true, tropius.CurrentForm.Species, tropius.CurrentForm.Form, tropius.CurrentForm.Skin, tropius.CurrentForm.Gender)
	UI:WaitShowDialogue("Howdy![pause=0] My name is " .. tropius:GetDisplayName() .. ",[pause=10] and I'm the Guildmaster here!")
	UI:SetSpeaker(tropius)
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("What are your names?[pause=0] Can you tell me a little bit about yourselves?")
	
	--partner speaks up
	UI:SetSpeaker(partner)
	GROUND:CharSetEmote(partner, 5, 1)
	UI:WaitShowDialogue("M-my name is " partner:GetDisplayName() .. "![pause=0] I w-want to be an adventurer!")
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	UI:WaitShowDialogue("And this is " .. hero:GetDisplayName() .. "![pause=0] " .. GeneralFunctions.GetPronoun(hero, "they", true) .. " want to be an adventurer too!")
	GROUND:CharTurnToCharAnimated(partner, tropius, 4)
	UI:WaitShowDialogue("We're here b-because we want to be great adventurers,[pause=10] like you!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Happy")
	GROUND:CharSetEmote(tropius, 4, 0)
	UI:WaitShowDialogue("Ha ha,[pause=10] you flatter me!")
	GAME:WaitFrames(10)
	UI:SetSpeakerEmotion("Normal")
	GROUND:CharSetEmote(tropius, -1, 0)
	
	--Huh? trying times? what do you mean? something's wrong with the world or something?
	UI:WaitShowDialogue("It's encouraging that the youth of today still seek to be adventurers,[pause=10] especially with the life force issues in recent times...")
	
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(hero, "Notice", true)
	GeneralFunctions.HeroDialogue(hero, "(Huh?[pause=0] Issues with life forces?[pause=0] What is he talking about?)", "Worried")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("However,[pause=10] before you can sign up with the guild,[pause=10] I do need to ask you two some very important questions.")
	UI:WaitShowDialogue("Don't be nervous.[pause=0] This isn't some sort of test of knowledge or anything.[pause=0] I just want to learn some things about you...")
	UI:WaitShowDialogue("...So it's crucial that you answer these honestly.[pause=0] The only wrong answer is a deceitful one.")
	
	--what kind of questions is he about to ask us, oh goodness
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GAME:WaitFrames(12)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.DoEmote(hero, 'Sweating', true) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.DoEmote(partner, 'Sweating') end)
	TASK:JoinCoroutines({coro1, coro2})	
	GAME:WaitFrames(20)	
	
	GROUND:CharTurnToCharAnimated(partner, tropius, 4)
	GROUND:CharTurnToCharAnimated(hero, tropius, 4)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Stunned")
	UI:WaitShwoDialogue("O-of course![pause=0] Ask us a-anything,[pause=10] Guildmaster!")
	GAME:WaitFrames(20)
	
	--question 1: why do you wanna be an adventurer?
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Great![pause=0] Now,[pause=10] first question,[pause=10] for you " ..partner:GetDisplayName() .. "...")
	GROUND:CharAnimateTurnTo(tropius, Direction.DownRight, 4)
	UI:WaitShowDialogue("Why do you want to become an adventurer?")
	
	UI:SetSpeaker(partner)
	--todo: do a little hop
	UI:WaitShowDialogue("Oh,[pause=10] that's an easy one![pause=0] I want to do all the things that adventurers do!")
	UI:SetSpeakerEmotion("Inspired")
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("I wanna explore new lands,[pause=10] help Pokémon in need,[pause=10] and make friends all around the world!")
	UI:WaitShowDialogue("Maybe if I'm lucky I'll find some treasure too![pause=0] That would be cool!")
	
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("I see.")
	GROUND:CharAnimateTurnTo(tropius, Direction.DownLeft, 4)
	UI:WaitShowDialogue("What about you,[pause=10] " .. hero:GetDisplayName() .. "?")
	GAME:WaitFrames(20)
	
	--hero question 1 response
	GeneralFunctions.HeroDialogue(hero, "(Uh...[pause=0] That's a good question actually.[pause=0] I haven't put that much thought into it...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(It sounded fun,[pause=10] sure,[pause=10] and I didn't really have any other options given the circumstances...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(...But I don't really think those are a proper answer...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(Why else do I want to be an adventurer?"), "Worried")
	
	--menu with 3 options here:
	--Solve my origins (but i cant say that so i'll say solve mysteries of the world)
	--discover new places
	--partner is my friend and they wanna be one

	
	
	
	
	
	GAME:CutsceneMode(false)
	GAME:EnterGroundMap("guild_second_floor", "Main_Entrance_Marker")

	
end