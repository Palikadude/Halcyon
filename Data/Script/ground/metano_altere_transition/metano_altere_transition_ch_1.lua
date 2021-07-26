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
	GAME:MoveCamera(236, 184, 1, false)
	GROUND:TeleportTo(partner, 260, 340, Direction.Right)
	GROUND:TeleportTo(hero, 264, 372, Direction.Right)
	GAME:FadeIn(20)
	
	--Move to about mid screen, and have the conversation there.
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 240, 176, false, 1) end)
	GROUND:MoveToPosition(hero, 240, 208, false, 1)
	TASK:JoinCoroutines({coro1})
	
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 240, 176, false, 1) end)
	GROUND:MoveToPosition(partner, 208, 176, false, 1)
	GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
	TASK:JoinCoroutines({coro1})
	GROUND:CharAnimateTurnTo(hero, Direction.Left, 4)
	GAME:WaitFrames(20)
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
	UI:WaitShowDialogue("I didn't want to linger around the pond because our town elder lives there.")
	UI:WaitShowDialogue("He forbids anyone from entering due to some supposed danger lurking inside.")
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
	--GeneralFunctions.HeroDialogue(hero, "(Adventurer?[pause=0] What's that?)", 'Worried')
	GeneralFunctions.HeroSpeak(hero, 60)
	
	--you dont know what an adventurer is?
	GeneralFunctions.EmoteAndPause(partner, 'Exclaim', true)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion('Surprised')
	UI:WaitShowDialogue("What!?[pause=0] You don't know what adventurers are?")
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion('Worried')
	GROUND:CharSetEmote(partner, 5, 1)
	UI:WaitShowDialogue("Oh...[pause=0] right...[pause=0] I almost forgot who I'm speaking to.")
	
	--gush over how great adventuring is
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion('Inspired')
	UI:WaitShowDialogue('Adventurers are...[pause=0] the best.[pause=0] They do all sorts of amazing things!')
	GAME:WaitFrames(20)
--	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	UI:WaitShowDialogue("Exploring lands untouched by civilization with hidden treasures...")
	UI:WaitShowDialogue("Helping Pokémon in need and bringing outlaws to justice...")
	UI:WaitShowDialogue("Forging friendships with Pokémon you meet from all around the world...")
	
	--GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
	
	--todo: do a little hop 
	UI:WaitShowDialogue("These are things I've always dreamed of doing![pause=0] Don't you think it's exciting too?")
	
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
	UI:WaitShowDialogue("I've been wanting to sign up to apprentice at the guild...[br]...so I could learn how to be a great adventurer,[pause=10] but...")
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion('Sad')
	UI:WaitShowDialogue("I can't.[pause=0] You see...")
	UI:WaitShowDialogue("...the guild doesn't allow anyone to apply for apprenticeship without a teammate.")
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion('Normal')
	UI:WaitShowDialogue("Adventuring is a joint effort.[pause=0] You need someone else to watch your back in case things go south.")
	UI:WaitShowDialogue("Working as a team is part of the culture as well.[pause=0] Adventuring alone just isn't the same.")
	
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
	UI:WaitShowDialogue("I don't know anyone who would form a team with me...")
	UI:WaitShowDialogue("So I'm ineligible to join the guild...[pause=0] Even though I want nothing more...")
	GAME:WaitFrames(20)
	GeneralFunctions.ShakeHead(partner, 4)
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Sad")
	GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
	UI:WaitShowDialogue('Sorry...')
	
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion('Normal')
	UI:WaitShowDialogue("Anyway,[pause=10] that's why I was in " .. zone:GetColoredName() .. ".")
	UI:WaitShowDialogue("If I can't join the guild and become a great adventurer...")
	UI:SetSpeakerEmotion("Sad")
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
	GeneralFunctions.HeroDialogue(hero, "(...)", "Sad")

	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("Well...[pause=0] This may be sudden,[pause=10] but...[pause=0] Could I ask s-something of you then?")
	
	GAME:WaitFrames(10)
	GROUND:CharAnimateTurnTo(hero, Direction.Left, 4)
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("W-would you,[pause=10] um...")
	GROUND:CharAnimateTurnTo(partner, Direction.DownRight, 4)
	GeneralFunctions.EmoteAndPause(partner, 'Sweating', true)
	GROUND:CharSetAnim(partner, 'DeepBreath', false)
	GAME:WaitFrames(60)
	GROUND:CharSetAnim(hero, 'None', true)
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
	
	--todo: maybe play this scene out a little different?
	UI:SetSpeakerEmotion("Shouting")
	GROUND:CharSetEmote(hero, 8, 1)
	UI:WaitShowDialogue("Would you please form an adventuring team with me!?")
	
	GeneralFunctions.EmoteAndPause(hero, 'Sweating', true)
	
	UI:SetSpeakerEmotion('Sad')
	UI:WaitShowDialogue("S-sorry for shouting.[pause=0] I guess I'm just nervous,[pause=10] aha...")
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("It's just...[pause=0] After seeing how you handled yourself back in " .. zone:GetColoredName() .. "...")
	UI:WaitShowDialogue("I thought that we would make a good team.[pause=0] You have a lot of natural talent for this.")
	UI:WaitShowDialogue("You also don't have anywhere else to go and seem to like adventuring...")
	UI:WaitShowDialogue("So please...[pause=0] What do you say?")
	
	--Woah! I'm getting recruited out of the blue!
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(Hmm... What should I do?)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(Being an adventurer sounds fun,[pause=10] but I don't know " .. partner:GetDisplayName() .. " that well...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(But what else would I even do?[pause=0] I don't know anybody else...)", "Worried")
	--add another option here maybe? couldnt think of anything at the time to put that was decent
	UI:BeginChoiceMenu("(Should I team up with " .. partner:GetDisplayName() .. "?)", {"Team up", "No thanks"}, 1, 2)
	UI:WaitForChoice()
	UI:SetSpeaker(partner)
	local result = UI:ChoiceResult()
	while result == 2 do 
		GAME:WaitFrames(20)
		GROUND:CharSetAnim(partner, 'Hurt', true)
		SOUND:PlayBattleSE('EVT_Emote_Shock')
		GROUND:CharSetEmote(partner, 8, 1)
		--todo: do a little hop
		GAME:WaitFrames(20)
		GROUND:CharSetAnim(partner, 'None', true)
		UI:SetSpeakerEmotion("Surprised")
		UI:WaitShowDialogue("W-what!? B-but...")
		GeneralFunctions.EmoteAndPause(partner, "Sweating", true)
		UI:SetSpeakerEmotion("Sad")
		UI:WaitShowDialogue("I really think we would make a great duo.[pause=0] We worked so well together back in " .. zone:GetColoredName() .. ".")
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
	GeneralFunctions.HeroDialogue(hero, "(Who knows?[pause=0] Maybe togther we will figure out why I turned into a Pokémon.)", "Normal")

	GAME:WaitFrames(20)
	GeneralFunctions.HeroSpeak(hero, 60)
	
	--you'll team with me!!??
	--todo: do a little hop
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("Really!?")
	GAME:WaitFrames(20)
	--todo" do two hops
	UI:SetSpeakerEmotion("Joyous")
	GROUND:CharSetEmote(partner, 1, 0)
	GROUND:CharSetAnim(partner, 'Idle', true)--show idle anim to show their excitement (rather than none i.e. no anim)
	UI:WaitShowDialogue("Thank you thank you thank you!")
	--todo: do a little dance around the hero
	UI:WaitShowDialogue("We're going to make a great team![pause=0] We'll go on such amazing journeys together!")
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(partner, -1, 0)
	GAME:WaitFrames(20)
	
	--we need to sign up at the guild
	GROUND:CharSetEmote(partner, 3, 1)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
	UI:SetSpeakerEmotion("Surprised")
	GROUND:CharSetAnim(partner, 'None', true)
	UI:WaitShowDialogue("Oh![pause=0] I'm getting ahead of myself!")
	
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Before anything else,[pause=10] we need to go sign up at the guild!")
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Top-class adventurers from all over the world meet there to find jobs and exchange news.")
	UI:WaitShowDialogue("Some Pokémon live in the guild and train together to become great adventurers.")
	UI:WaitShowDialogue("That's what we're going to do too!")
	
	coro1 = TASK:BranchCoroutine(GROUND:_CharAnimateTurnTo(partner, Direction.Up, 4))
	GAME:WaitFrames(10)
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	TASK:JoinCoroutines({coro1})
	
	UI:WaitShowDialogue("The guild is in Metano Town.[pause=0] We're actually in the outskirts of town right now.")
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(GROUND:_CharAnimateTurnTo(partner, Direction.Right, 4))
	GAME:WaitFrames(10)
	GROUND:CharAnimateTurnTo(hero, Direction.Left, 4)
	TASK:JoinCoroutines({coro1})
	
	--lets go to the guild
	--maybe do a little dance here?
	GAME:WaitFrames(20)
	SOUND:PlayBattleSE("EVT_Emote_Startled_2")
	--todo: do a little hop
	UI:SetSpeakerEmotion("Inspired")
	GROUND:CharSetEmote(partner, 1, 0)
	GROUND:CharSetAnim(partner, 'Idle', true)--show idle anim to show their excitement (rather than none i.e. no anim)
	UI:WaitShowDialogue("C'mon![pause=0] Let's go let's go let's go![pause=0] I can't contain myself any longer!")
	GROUND:CharSetEmote(partner, -1, 0)
	
	--partner runs off to the guild in excitement, player has to run to catch up
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 208, -32, true, 4) end)
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	GeneralFunctions.EmoteAndPause(hero, "Exclaim", true)
	UI:SetSpeaker('', false, hero.CurrentForm.Species, hero.CurrentForm.Form, hero.CurrentForm.Skin, hero.CurrentForm.Gender)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowTimedDialogue("(Hey![pause=20] Wait up!)", 60)
	GROUND:MoveToPosition(hero, 208, 176, true, 4)
	GROUND:MoveToPosition(hero, 208, -32, true, 4)
	TASK:JoinCoroutines({coro1})

	GAME:FadeOut(false, 20)
	--
	GAME:CutsceneMode(false)
	GAME:EnterGroundMap("metano_town", "Main_Entrance_Marker")
	

	

	
end