require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'

metano_altere_transition_ch_1 = {}


	

--cutscene after getting out of Relic Forest where partner reveals some info about themselves and our duo agree to sign up at the guild together
function metano_altere_transition_ch_1.HeartToHeartCutscene()
	--todo: add map effect for evening lighting
	--todo: music (beach music?)
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone].Entries[50]
	--todo: hide player
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	GAME:MoveCamera(840, 312, 1, false)
	GROUND:TeleportTo(partner, 264, 324, Direction.Right)
	GROUND:TeleportTo(partner, 264, 356, Direction.Right)
	GAME:FadeIn(20)
	
	--Move to about mid screen, and have the conversation there.
	local coro1 = TASK:BranchCoroutine(GROUND:_MoveToPosition(partner, 240, 176, false, 1)
	GROUND:MoveToPosition(hero, 240, 208, false, 1)
	TASK:JoinCoroutines({coro1})
	
	local coro1 = TASK:BranchCoroutine(GROUND:_MoveToPosition(hero, 240, 176, false, 1)
	GROUND:MoveToPosition(partner, 216, 208, false, 1)
	GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
	TASK:JoinCoroutines({coro1})
	GeneralFunctions.LookAround(partner, 2, 4, false, false, true, Direction.Right)

	
	--conversation begins, hero wonders why they couldnt talk back at the pond and why partner was in relic forest to begin with 
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion('Normal')
	
	UI:WaitShowDialogue("Alright,[pause=10] this is a more suitable spot.")
	GAME:WaitFrames(20)
	--GeneralFunctions.HeroDialogue(hero, "(But what was wrong with staying near the pond?[pause=0] Something seems off...)", "Worried")
	--GeneralFunctions.HeroDialogue(hero, "(And why )", "Worried")

	
	GAME:WaitFrames(20)
	GeneralFunctions.HeroSpeak(hero, 60)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion('Normal')
	GeneralFunctions.EmoteAndPause(partner, 'Question', true)
	UI:WaitShowDialogue('Huh?[pause=0] What was wrong with staying by the pond?')
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion('Worried')
	UI:TextDialogue('Oh...[pause=0] Er...')
	GROUND:CharSetEmote(partner, 5, 1)
	UI:WaitDialog()
	
	--they consider making something up and pause, but just decide to be honest
	GAME:WaitFrames(40)
	UI:SetSpeakerEmotion('Sad')
	UI:WaitShowDialogue('Bah...[pause=0] I may as well be honest with you.')
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion('Normal')
	UI:WaitShowDialogue('Do you remember earlier how I said nobody was supposed to be in ' .. zone:GetColoredName() .. '?')
	UI:SetSpeakerEmotion('Sad')
	GAME:WaitFrames(20)
	UI:WaitShowDialogue('Well...[pause=0] That includes me.')
	UI:WaitShowDialogue("I didn't want to linger around the pond because our town elder[br] who lives in it forbids anyone from entering.")
	UI:WaitShowDialogue("If he saw me by the entrance,[pause=10] he'd know that I've been in there again.")
	UI:WaitShowDialogue("That's why we stayed close to the trees when we left the pond.")
	UI:WaitShowDialogue("It's the best way I've figured out to slip by him.")
	
	--wait, figured out? i.e. you've done this enough times to figure out a strategy?
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(That means " .. partner:GetDisplayName() .. " has been in there more than once...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(But why would " .. GeneralFunctions.GetPronoun(partner, 'they') .. " go there multiple times if " .. GeneralFunctions.GetPronoun(partner, "they're") .. " not allowed?)", "Worried")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroSpeak(hero, 60)
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(partner, Direction.DownRight, 4)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion('Sad')
	UI:WaitShowDialogue('...')
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
	UI:WaitShowDialogue('I go there a lot because...[pause=0] I want to be a great adventurer.')
	
	--wtf is an adventurer
	GeneralFunctions.EmoteAndPause(hero, 'Question', true)
	GeneralFunctions.HeroDialogue(hero, "Adventurer?[pause=0] What's that?", 'Worried')
	GeneralFunctions.HeroSpeak(hero, 60)
	
	--you dont know what an adventurer is?
	GeneralFunctions.EmoteAndPause(partner, 'Exclaim', true)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion('Surprised')
	UI:WaitShowDialogue("What!?[pause=0] You don't know what adventurers are?")
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion('Worried')
	UI:WaitShowDialogue("Oh...[pause=0] right...[pause=0] I almost forgot who I'm speaking to.")
	
	--gush over how great adventuring is
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion('Normal')
	UI:WaitShowDialogue('Adventurers are...[pause=0] the best.[pause=0] They do all sorts of amazing things!')
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("Exploring lands untouched by civilization with hidden treasures...")
	UI:WaitShowDialogue("Helping Pokémon in need and bringing outlaws to justice...")
	UI:WaitShowDialogue("Forging friendships with Pokémon you meet from all around the world...")
	
	UI:CharAnimateTurnTo(partner, Direction.Right, 4)
	
	UI:WaitShowDialogue("These are things I've always dreamed of doing![pause=0] Don't you think it's exciting too?")
	
	--hero is excited by the idea of adventurers because THATS WHY THEY CAME TO THIS WORLD :v)
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(Wow![pause=0] Being an adventurer sounds like a lot of fun.)", "Inspired")
	GAME:WaitFrames(20)
	GROUND:CharSetAnim(hero, 'Nod', false)
	GAME:WaitFrames(20)
	GROUND:CharSetAnim(hero, 'None', true)
	GAME:WaitFrames(20)
	
	

end