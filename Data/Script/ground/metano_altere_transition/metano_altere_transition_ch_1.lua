require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'

metano_altere_transition_ch_1 = {}


	

--cutscene after getting out of Relic Forest where partner reveals some info about themselves and our duo agree to sign up at the guild together
function metano_altere_transition_ch_1.HeartToHeartCutscene()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	GROUND:AddMapStatus("dusk")--dusk
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("relic_forest")
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	--GAME:MoveCamera(232, 184, 1, false)
	GROUND:TeleportTo(partner, 260, 340, Direction.Right)
	GROUND:TeleportTo(hero, 264, 372, Direction.Right)
	GAME:MoveCamera(236, 184, 1, false)
	GROUND:Hide('South_Exit')
	GROUND:Hide('North_Exit')
	GAME:FadeIn(40)
	
	--Move to about mid screen, and have the conversation there.
	local coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, 240, 176, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(hero, 240, 208, false, 1) end)
	TASK:JoinCoroutines({coro1, coro2})
	
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 240, 176, false, 1) end)
	GROUND:MoveToPosition(partner, 208, 176, false, 1)
	GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
	TASK:JoinCoroutines({coro1})
	GROUND:CharAnimateTurnTo(hero, Direction.Left, 4)
	GAME:WaitFrames(20)
	GeneralFunctions.LookAround(partner, 2, 4, false, false, true, Direction.Right)

	
	--conversation begins, hero wonders why they couldnt talk back at the pond and why partner was in relic forest to begin with 
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion('Normal')
	
	UI:WaitShowDialogue("Alright,[pause=10] this spot is better to talk.")
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
	GROUND:CharSetEmote(partner, "sweating", 1)
	UI:WaitShowDialogue('Oh...[pause=0] Er...')
	GAME:WaitFrames(20)
	
	--they consider making something up and pause, but just decide to be honest
	GeneralFunctions.EmoteAndPause(partner, "Sweatdrop", true)
	UI:SetSpeakerEmotion('Sad')
	SOUND:FadeOutBGM(120)
	UI:WaitShowDialogue('Bah...[pause=0] I may as well be honest with you.')
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion('Normal')
	UI:WaitShowDialogue('Do you remember earlier how I said nobody was supposed to be in ' .. zone:GetColoredName() .. '?')
	UI:SetSpeakerEmotion('Sad')
	GAME:WaitFrames(20)
	UI:WaitShowDialogue('Well...[pause=0] That includes me.')
	UI:WaitShowDialogue("I didn't want to linger around the pond because our town elder lives there.")
	UI:WaitShowDialogue("He forbids anyone from entering due to some supposed danger lurking inside.")
	UI:WaitShowDialogue("If he saw me by the entrance,[pause=10] he'd know that I've been in there again.")
	UI:WaitShowDialogue("That's why we stayed close to the trees when we left the pond.")
	UI:WaitShowDialogue("He has bad eyesight...[pause=0] So he can't see us if we use the trees as cover.")
	
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
	UI:WaitShowDialogue('I go there a lot because...[pause=0] it makes me feel like an adventurer.')
	GAME:WaitFrames(40)
	SOUND:PlayBGM("On the Beach at Dusk.ogg", false)
	UI:WaitShowDialogue("Ever since I was young,[pause=10] I've wanted to be an adventurer.")
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("The adventurers in the guild do so much important and exciting work.[br]I want to do what they do too!")
	GAME:WaitFrames(20)
	
	--wtf is an adventurer
	GeneralFunctions.EmoteAndPause(hero, 'Question', true)
	--GeneralFunctions.HeroDialogue(hero, "(Adventurer?[pause=0] What's that?)", 'Worried')
	GeneralFunctions.HeroSpeak(hero, 60)
	
	--you dont know what an adventurer is?
	GeneralFunctions.EmoteAndPause(partner, 'Exclaim', true)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion('Surprised')
	UI:WaitShowDialogue("What!?[pause=0] You don't know what an adventurer is?")
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion('Worried')
	GROUND:CharSetEmote(partner, "sweating", 1)
	UI:WaitShowDialogue("Oh...[pause=0] right...[pause=0] I almost forgot who I'm speaking to.")
	
	--gush over how great adventuring is
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion('Inspired')
	UI:WaitShowDialogue('Adventurers are the best![pause=0] They do all sorts of amazing things!')
	GAME:WaitFrames(20)
--	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	UI:WaitShowDialogue("Exploring lands untouched for centuries,[pause=10] filled with hidden treasures...")
	UI:WaitShowDialogue("Helping Pokémon in need and bringing outlaws to justice...")
	UI:WaitShowDialogue("Forging friendships with Pokémon from all around the world...")
	
	--GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
	
	UI:WaitShowDialogue("These are things I dream of doing![pause=0] Don't you think it's exciting too?[script=0]", {function() return GeneralFunctions.Hop(partner) end})
	--GeneralFunctions.Hop(partner, 'None', 10, 10, false, false)
	
	--hero is excited by the idea of adventurers because THATS WHY THEY CAME TO THIS WORLD :v)
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(I have to say...[pause=0] That does sound like a lot of fun!)", "Inspired")
	GAME:WaitFrames(20)
	GeneralFunctions.DoAnimation(hero, 'Nod')
	GAME:WaitFrames(20)
	
	--why cant the partner join the guild themself?
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion('Happy')
	UI:WaitShowDialogue("I'm glad you think so too!")
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion('Normal')
	UI:WaitShowDialogue("I've been wanting to sign up to apprentice at the guild so I could be an adventurer,[pause=10] but...")
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion('Sad')
	UI:WaitShowDialogue("I can't.[pause=0] You see...")
	UI:WaitShowDialogue("...The guild doesn't allow anyone to apply for apprenticeship without a teammate.")
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion('Normal')
	UI:WaitShowDialogue("Adventuring is a team effort.[pause=0] It's a lot harder to adventure without a partner.")
	UI:WaitShowDialogue("Working as a team is a part of the culture too.[pause=0] Adventuring alone just isn't the same experience.")
	
	--get teary-eyed that you have nobody like that 
	--music cue around here for beach song?
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion('Sad')
	UI:WaitShowDialogue('My problem is...[pause=0] that...')
	GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4)
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(partner, 'Sweating', true)
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4)
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion('Teary-Eyed')
	--GeneralFunctions.StartTremble(partner)
	UI:WaitShowDialogue("There's no one who's willing to form a team with me...")
	UI:WaitShowDialogue("So it's impossible for me to join the guild...")
	UI:WaitShowDialogue("I'm just a pretender,[pause=10] stuck exploring the local forest...")
	GAME:WaitFrames(20)
	--GeneralFunctions.StopTremble(partner)
	GeneralFunctions.ShakeHead(partner, 4)
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Sad")
	GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
	UI:WaitShowDialogue('Sorry...')
	
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("Anyway,[pause=10] that's why I was in " .. zone:GetColoredName() .. ".")
	UI:WaitShowDialogue("If I can't join the guild and become an adventurer...")
	UI:WaitShowDialogue("...at least I can go on my own little adventures in the forest.")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(" .. partner:GetDisplayName() .. "...)", "Sad")
	
	--recruit the player
	GAME:WaitFrames(40)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("But enough about me...[pause=0] What about you,[pause=10] " .. hero:GetDisplayName() .. "?")
	UI:WaitShowDialogue("You woke up in a forest with no memory,[pause=10] transformed into a Pokémon...")
	UI:WaitShowDialogue("What are you going to do now?[pause=0] Do you have anywhere to go?")
	
	GAME:WaitFrames(10)
	GROUND:CharAnimateTurnTo(hero, Direction.DownLeft, 4)
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(.........)", "Sad")

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("Well...[pause=0] This may b-be sudden,[pause=10] but...[pause=0] C-could I ask s-something of you then?")
	
	GAME:WaitFrames(10)
	GROUND:CharAnimateTurnTo(hero, Direction.Left, 4)
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("W-would you,[pause=10] um...")
	GeneralFunctions.EmoteAndPause(partner, 'Sweating', true)
	GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
	GeneralFunctions.DoAnimation(partner, 'DeepBreath')

	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
	
	GeneralFunctions.Hop(partner)
	GeneralFunctions.Hop(partner)
	UI:WaitShowDialogue("Would you please form an adventuring team with me?")
	GAME:WaitFrames(10)
	
	GeneralFunctions.EmoteAndPause(hero, "Exclaim", true)
	UI:SetSpeakerEmotion('Sad')
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("It's just...[pause=0] After seeing how you handled yourself back in " .. zone:GetColoredName() .. "...")
	UI:WaitShowDialogue("I thought that we would make a good team.[pause=0] You have a lot of natural talent for this.")
	UI:WaitShowDialogue("You also don't have anywhere else to go and you seem to like adventuring...")
	UI:WaitShowDialogue("So please...[pause=0] What do you say?")
	
	--Woah! I'm getting recruited out of the blue!
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(Hmm...[pause=0] What should I do?)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(Being an adventurer sounds fun,[pause=10] but I don't know " .. partner:GetDisplayName() .. " that well...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(But what else would I even do?[pause=0] I don't know anybody else...)", "Worried")
	--add another option here maybe? couldnt think of anything at the time to put that was decent
	UI:BeginChoiceMenu("(Should I team up with " .. partner:GetDisplayName() .. "?)", {"Team up", "No thanks"}, 1, 2)
	UI:WaitForChoice()
	UI:SetSpeaker(partner)
	local result = UI:ChoiceResult()
	while result == 2 do 
		GAME:WaitFrames(20)
		GeneralFunctions.Recoil(partner)
		GROUND:CharSetAnim(partner, 'None', true)
		UI:SetSpeakerEmotion("Surprised")
		UI:WaitShowDialogue("Wh-what!? B-but...")
		GeneralFunctions.EmoteAndPause(partner, "Sweating", true)
		UI:SetSpeakerEmotion("Sad")
		UI:WaitShowDialogue("I really think we would make a great duo.[pause=0] We worked so well together in " .. zone:GetColoredName() .. ".")
		UI:WaitShowDialogue("And with your amnesia,[pause=10] I'm worried what would happen to you if you had nobody to help you.")
		UI:WaitShowDialogue("We both would really benefit by sticking together.")
		UI:BeginChoiceMenu("So please,[pause=10] I'm begging you...[pause=0] Form an adventuring team with me.", {"Team up", "No thanks"}, 1, 2)
		UI:WaitForChoice()
		result = UI:ChoiceResult()		
	end
	
	GAME:WaitFrames(20)
	--if result == 3 then	end
	GeneralFunctions.HeroDialogue(hero, "(I really don't have anywhere to go or anyone else to turn to...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(" .. partner:GetDisplayName() .. " has been kind and honest with me so far...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(I feel like I can trust " .. GeneralFunctions.GetPronoun(partner, 'them') .. ".[pause=0] I can't think of any good reason not to.)", "Normal")
	GeneralFunctions.HeroDialogue(hero, "(And being an adventurer sounded really cool...)", "Inspired")
	GeneralFunctions.HeroDialogue(hero, "(Alright![pause=0] Then it's decided!)", "Normal")	
	GeneralFunctions.HeroDialogue(hero, "(Who knows?[pause=0] Maybe together we'll figure out why I turned into a Pokémon.)", "Normal")

	GAME:WaitFrames(20)
	GeneralFunctions.HeroSpeak(hero, 60)
	
	--you'll team with me!!??
	GeneralFunctions.Hop(partner)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("Really!?")
	GAME:WaitFrames(20)
	GROUND:MoveToPosition(partner, 220, 176, true, 2)
	GeneralFunctions.Hop(partner, 'None', 10, 10, true, true)
	GeneralFunctions.Hop(partner, 'None', 10, 10)
	UI:SetSpeakerEmotion("Joyous")
	GROUND:CharSetEmote(hero, "shock", 1)
	GROUND:CharSetEmote(partner, "happy", 0)
	GROUND:CharSetAnim(partner, 'Idle', true)--show idle anim to show their excitement (rather than none i.e. no anim)
	UI:WaitShowDialogue("Thank you thank you thank you!")
	UI:WaitShowDialogue("We're going to make a great team![pause=0] We'll go on such amazing journeys together!")
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(partner, "", 0)
	GAME:WaitFrames(20)
	
	--we need to sign up at the guild
	GROUND:CharSetEmote(partner, "exclaim", 1)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
	UI:SetSpeakerEmotion("Surprised")
	GROUND:CharSetAnim(partner, 'None', true)
	UI:WaitShowDialogue("Oh![pause=0] I'm getting ahead of myself!")
	GAME:WaitFrames(20)
	
	GROUND:AnimateInDirection(partner, "Walk", Direction.Right, Direction.Left, 12, 1, 1)
	GAME:WaitFrames(20)
	
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Before anything else,[pause=10] we need to go sign up at the guild!")
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Top-class adventurers from all over the world meet there to find jobs and exchange news.")
	UI:WaitShowDialogue("Some Pokémon live in the guild and train together to become great adventurers.")
	UI:WaitShowDialogue("That's what we're going to do too!")
	GAME:WaitFrames(20)
	
	coro1 = TASK:BranchCoroutine(GROUND:_CharAnimateTurnTo(partner, Direction.Up, 4))
	GAME:WaitFrames(10)
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	TASK:JoinCoroutines({coro1})
	
	UI:WaitShowDialogue("The guild is in Metano Town.[pause=0] We're actually on the outskirts of town right now.")
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(GROUND:_CharAnimateTurnTo(partner, Direction.Right, 4))
	GAME:WaitFrames(10)
	GROUND:CharAnimateTurnTo(hero, Direction.Left, 4)
	TASK:JoinCoroutines({coro1})
	
	--lets go to the guild
	GeneralFunctions.Hop(partner, 'None', 10, 10, true, true)
	GeneralFunctions.Hop(partner)
	UI:SetSpeakerEmotion("Inspired")
	GROUND:CharSetEmote(partner, "happy", 0)
	GROUND:CharSetAnim(partner, 'Idle', true)--show idle anim to show their excitement (rather than none i.e. no anim)
	UI:WaitShowDialogue("Ohhhh![pause=0] I can't contain myself any longer!")
	UI:WaitShowDialogue("C'mon![pause=0] To the guild![pause=0] Let's go let's go let's go!")
	GAME:WaitFrames(10)
	GROUND:CharSetEmote(partner, "", 0)
	
	--partner runs off to the guild in excitement, player has to run to catch up
	--SOUND:PlayBattleSE("_UNK_EVT_069")--run away sfx, maybe dont use tho?
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 208, -32, true, 4) end)
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	GeneralFunctions.EmoteAndPause(hero, "Exclaim", true)
	UI:SetSpeaker('', false, hero.CurrentForm.Species, hero.CurrentForm.Form, hero.CurrentForm.Skin, hero.CurrentForm.Gender)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowTimedDialogue("(H-hey![pause=20] Wait up!)", 60)
	GROUND:MoveToPosition(hero, 208, 176, true, 3)
	GROUND:MoveToPosition(hero, 208, -32, true, 3)
	TASK:JoinCoroutines({coro1})

	SOUND:FadeOutBGM()
	GAME:FadeOut(false, 40)
	--
	GAME:CutsceneMode(false)
	GAME:EnterGroundMap("metano_town", "Main_Entrance_Marker")
	

	

	
end