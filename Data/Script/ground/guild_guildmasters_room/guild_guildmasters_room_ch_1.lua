require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

guild_guildmasters_room_ch_1 = {}

function guild_guildmasters_room_ch_1.MeetGuildmaster()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local tropius = CH('Tropius')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	GAME:MoveCamera(192, 112, 1, false) 
	
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
	UI:SetSpeaker('[color=#00FFFF]Guildmaster[color]', true, tropius.CurrentForm.Species, tropius.CurrentForm.Form, tropius.CurrentForm.Skin, tropius.CurrentForm.Gender)
	UI:WaitShowDialogue("Howdy![pause=0] My name is " .. tropius:GetDisplayName() .. ",[pause=10] and I'm the Guildmaster here!")
	UI:SetSpeaker(tropius)
	GAME:WaitFrames(20)
	UI:WaitShowDialogue(noctowl:GetDisplayName() .. " here has told me that the two of you want to apprentice at the guild.[pause=0] That's great!")
	UI:WaitShowDialogue("I don't think I got your names though.[pause=0] Could you tell me them please?")
	
	--partner speaks up
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GROUND:CharSetEmote(partner, 5, 1)
	UI:WaitShowDialogue("M-my name is " .. partner:GetDisplayName() .. "!")
	GAME:WaitFrames(12)

	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	UI:WaitShowDialogue("And this is " .. hero:GetDisplayName() .. "!") --[pause=0] " .. GeneralFunctions.GetPronoun(hero, "they", true) .. " want to be an adventurer too!")
	GROUND:CharTurnToCharAnimated(partner, tropius, 4)
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("It's nice to meet the two of you!")
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(noctowl:GetDisplayName() .. " here told me that you two want to train here at the guild.")
	UI:WaitShowDialogue("Do you two have any experience adventuring already?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("...N-not really...[pause=0] We're pretty new to it...")
	GAME:WaitFrames(20)
	--todo: a hop 
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("But we want to train here so we can become great adventurers,[pause=10] like you!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Happy")
	GROUND:CharSetEmote(tropius, 4, 0)
	UI:WaitShowDialogue("Ha ha,[pause=10] you flatter me!")
	GAME:WaitFrames(10)
	UI:SetSpeakerEmotion("Normal")
	GROUND:CharSetEmote(tropius, -1, 0)
	UI:WaitShowDialogue("It's alright if you don't have experience![pause=0] That's what apprenticing is for,[pause=10] right?")
	GAME:WaitFrames(20)
	
	--Huh? trying times? what do you mean? something's wrong with the world or something?
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Frankly,[pause=10] it amazes me that so many Pokémon still wish to become adventurers ...")
	UI:WaitShowDialogue("...given the life force issues in recent times...")
	
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(hero, "Question", true)
	GeneralFunctions.HeroDialogue(hero, "(Huh?[pause=0] Issues with life forces?[pause=0] What is he talking about?)", "Worried")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("But I'm getting offtopic.[pause=0] What's important right now is your apprenticeship!")
	UI:WaitShowDialogue("Before you can sign up with us though,[pause=10] I do need to ask the two of you an important question.")
	UI:WaitShowDialogue("Don't be nervous.[pause=0] This isn't some sort of test of knowledge or anything.")
	UI:WaitShowDialogue("...So it's crucial that you answer honestly.[pause=0] Your answer is only wrong if you lie.")
	
	--what kind of questions is he about to ask us, oh goodness
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GAME:WaitFrames(12)
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GeneralFunctions.EmoteAndPause(hero, 'Sweating', true) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(partner, 'Sweating') end)
	TASK:JoinCoroutines({coro1, coro2})	
	GAME:WaitFrames(20)	
	
	GROUND:CharTurnToCharAnimated(partner, tropius, 4)
	GROUND:CharTurnToCharAnimated(hero, tropius, 4)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Stunned")
	UI:WaitShowDialogue("O-of course![pause=0] Ask us a-anything,[pause=10] Guildmaster!")
	GAME:WaitFrames(20)
	
	--question 1: why do you wanna be an adventurer?
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Great![pause=0] Now,[pause=10] first,[pause=10] let's hear from " ..partner:GetDisplayName() .. "...")
	GROUND:CharAnimateTurnTo(tropius, Direction.DownRight, 4)
	GAME:WaitFrames(16)
	UI:WaitShowDialogue("Why do you want to become an adventurer?")
	
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(partner, "Exclaim", true)
	UI:SetSpeaker(partner)
	--todo: do a little hop
	UI:WaitShowDialogue("Oh,[pause=10] that's an easy one![pause=0] I want to do all the things that adventurers do!")
	UI:SetSpeakerEmotion("Inspired")
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("I wanna explore new places,[pause=10] help Pokémon in trouble,[pause=10] and make friends all around the world!")
	UI:WaitShowDialogue("Maybe if I'm lucky I'll find some treasure too![pause=0] That would be cool!")
	
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Adventurers sure do a lot of amazing things,[pause=10] don't we?")
	UI:WaitShowDialogue("Helping other Pokémon is one of the most important jobs!")
	UI:WaitShowDialogue("In doing so we get to meet so many unique and interesting Pokémon!")
	UI:WaitShowDialogue("A lot of Pokémon think that adventuring is about the treasure.[pause=0] But that's a bonus,[pause=10] not the purpose.")
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("You seem to understand that though.")
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(tropius, Direction.DownLeft, 4)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("What about you,[pause=10] " .. hero:GetDisplayName() .. "?")
	GAME:WaitFrames(20)
	
	--hero question 1 response
	GeneralFunctions.HeroDialogue(hero, "(Uh...[pause=0] That's a good question actually.[pause=0] I haven't put that much thought into it...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(It sounded fun,[pause=10] sure,[pause=10] but I didn't really have any other options given my circumstances...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(...I don't know if I really have a proper answer then...)", "Worried")
	UI:BeginChoiceMenu("(...Why do I want to be an adventurer?)", {"It's a lot of fun", "Solve mysteries", partner:GetDisplayName() .. " is my friend"}, 3, 3)
	UI:WaitForChoice()

	--menu with 3 options here:
	--Solve my origins (but i cant say that so i'll say solve mysteries of the world)
	--it's really fun 
	--partner is my friend and they wanna be one
	local result = UI:ChoiceResult()
	GAME:WaitFrames(20)
	if result == 1 then 
		GeneralFunctions.HeroDialogue(hero, "(Hmm...[pause=0] I guess it just sounded like fun when " .. partner:GetDisplayName() .. " described it to me.)", "Worried")
		GAME:WaitFrames(20)
		GeneralFunctions.HeroDialogue(hero, "(I'll go with that as my answer then!)", "Normal")
		GAME:WaitFrames(20)
		GeneralFunctions.HeroSpeak(hero, 60)
		GAME:WaitFrames(20)
		UI:SetSpeaker(tropius)
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("I see![pause=0] It's true that adventuring can be a lot of fun!")
		GAME:WaitFrames(20)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("But keep in mind that it's not always fun and games.[pause=0] It can be very serious work at times.")--foreshadowing
	
	elseif result == 2 then 
		GeneralFunctions.HeroDialogue(hero, "(Truthfully,[pause=10] I'd like to figure out who I used to be and how I lost my memory.", "Worried")
		GeneralFunctions.HeroDialogue(hero, "(Being an adventurer seems like it could help me with that...)", "Worried")
		GeneralFunctions.HeroDialogue(hero, "(But " .. partner:GetDisplayName() .. " said I shouldn't tell anyone that I was a human...)", "Worried")
		GAME:WaitFrames(20)
		GeneralFunctions.HeroDialogue(hero, "(I guess if I phrase it a certain way it wouldn't sound suspicious.)", "Normal")
		GAME:WaitFrames(20)
		GeneralFunctions.HeroSpeak(hero, 60)
		GAME:WaitFrames(20)
		UI:SetSpeaker(tropius)
		UI:WaitShowDialogue("You want to solve mysteries?[pause=0] There's a lot of secrets in this world,[pause=10] isn't there?")
		UI:WaitShowDialogue("The pursuit of knowledge is an admirable goal.[pause=0] So much good can come from learning more about the world.")
		UI:WaitShowDialogue("...But bad things can too.[pause=0] There are some things we might be better off not knowing.")--foreshadowing
	else
		GeneralFunctions.HeroDialogue(hero, "(The only reason I'm here in the first place is because of " .. partner:GetDisplayName() .. "...)", "Worried")
		GeneralFunctions.HeroDialogue(hero, "(I don't know them that well yet but they're still my only friend in this world...)", "Worried")
		GAME:WaitFrames(20)
		GeneralFunctions.HeroDialogue(hero, "(So I guess the real reason I'm here to be an adventurer is because of " .. partner:GetDisplayName() .. "!)", "Normal")
		GAME:WaitFrames(20)
		GeneralFunctions.HeroSpeak(hero, 60)
		GAME:WaitFrames(20)
		UI:SetSpeaker(tropius)
		--tropius likes this answer, partner is surprised by your answer 
		coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(tropius, "Exclaim", true) end)
		coro2 = TASK:BranchCoroutine(function() GROUND:CharSetEmote(partner, 3, 1)
											    GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
		TASK:JoinCoroutines({coro1, coro2})
		UI:WaitShowDialogue("Oh?[pause=0] You want to be an adventurer so you can team up with your friend?")
		GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
		GAME:WaitFrames(16)
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("That's quite admirable![pause=0] Many Pokémon forget that the most important part of a team is your partner!")
		GAME:WaitFrames(20)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("The best teams are those who share a strong bond and put their teammates before anything else.")
		GAME:WaitFrames(20)
		UI:SetSpeakerEmotion("Sad")--foreshadowing
		UI:WaitShowDialogue("...And the worst are those who put glory or treasure above all else.")--FORESHADOWING
		UI:SetSpeakerEmotion("Normal")
	end
	GROUND:CharAnimateTurnTo(tropius, Direction.Down, 4)
	GAME:WaitFrames(40)
	--hmm, how to reconcile that tropius wants to teach people the error of his ways but turned away team style because they were vain and had poor morals?
	--either: they got kicked out because they weren't changing or were acting up, or they weren't allowed to join in the first place because of their bad attitude/philosophy
	
	
	--looks at noctowl, they agree that they should be allowed to apprentice here
	--that was too easy... as it this was meant to happen...
	UI:WaitShowDialogue("That's all I needed to hear from you two.")
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(tropius, noctowl, 4)
	GROUND:CharTurnToCharAnimated(noctowl, tropius, 4)
	UI:WaitShowDialogue("What do you think,[pause=10] " .. noctowl:GetDisplayName() .. "?")
	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("I believe we are on the same page,[pause=10] Guildmaster.")
	GAME:WaitFrames(20)
	UI:SetSpeaker(tropius)
	UI:WaitShowDialogue("That's what I thought!")
	GROUND:CharAnimateTurnTo(tropius, Direction.Down, 4)
	GROUND:CharAnimateTurnTo(noctowl, Direction.DownRight, 4)
	GAME:WaitFrames(10)
	
	
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Congratulations you two![pause=0] You're now an official adventuring team with the guild!")
	
	
	--yay we did it!!
	--todo: two hops
	--GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(partner, "Exclaim", true) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GeneralFunctions.EmoteAndPause(hero, "Exclaim", false) end)
	TASK:JoinCoroutines({coro1, coro2})	
	UI:SetSpeaker(partner)
	GROUND:CharSetAnim(partner, "Idle", true)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("R-really!?")
	
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	
	GROUND:CharSetEmote(partner, 1, 0)
	GROUND:CharSetAnim(hero, "Idle", true)
	UI:SetSpeakerEmotion("Joyous")
	UI:WaitShowDialogue("We did it " .. hero:GetDisplayName() .. "!")
	
	GAME:WaitFrames(40)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Happy")
	GROUND:CharSetEmote(tropius, 4, 0)
	UI:WaitShowDialogue("Ha ha ha!")
	GAME:WaitFrames(10)
	GROUND:CharSetEmote(tropius, -1, 0)
	GROUND:CharSetEmote(partner, -1, 0)
	GROUND:CharSetAnim(partner, "None", true)
	GROUND:CharSetAnim(hero, "None", true)
	GROUND:CharTurnToCharAnimated(partner, tropius, 4)
	GROUND:CharTurnToCharAnimated(hero, tropius, 4)
	GAME:WaitFrames(20)
	
	
	--what is your team's name?
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Your training will start tomorrow.[pause=0] But before that can start,[pause=10] I need to update our records with your info.")
	
	GROUND:CharSetEmote(partner, -1, 0)
	GROUND:CharSetAnim(partner, "None", true)
	GROUND:CharSetAnim(hero, "None", true)
	GROUND:CharTurnToCharAnimated(partner, tropius, 4)
	GROUND:CharTurnToCharAnimated(hero, tropius, 4)
	GAME:WaitFrames(12)
	UI:WaitShowDialogue("I have most of what I need already...[pause=0] But I still need your team's name.[pause=0] What is it?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("A team name?[pause=0] We hadn't thought of one.")
	
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	
	--give team name, tropius gives a couple of items and some adventurers tool (like a badge to tp others and urselves out of dungeons)
	--then noctowl shows u to ur room
	
	GAME:WaitFrames(12)
	UI:WaitShowDialogue("What do you think our name should be,[pause=10] " .. hero:GetDisplayName() .. "?")
	
	--give team name 
	GAME:WaitFrames(20)
	UI:ResetSpeaker()
	local yesnoResult = false
	while not yesnoResult do
		UI:NameMenu("What will your team's name be?", "You don't need to put 'Team' in the name itself.")
		UI:WaitForChoice()
		result = UI:ChoiceResult()
		GAME:SetTeamName(result)
		UI:ChoiceMenuYesNo("Is Team " .. GAME:GetTeamName() .. " correct?")
		UI:WaitForChoice()
		yesnoResult = UI:ChoiceResult()
	end
	
	UI:SetSpeaker(partner)
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue(GAME:GetTeamName() .. "...[pause=0] I like it!")
	
	--I'll register you as your teamname then!
	GAME:WaitFrames(20)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Alright then![pause=0] I'll register you as Team " .. GAME:GetTeamName() .. "!")
	GROUND:CharTurnToCharAnimated(partner, tropius, 4)
	GROUND:CharTurnToCharAnimated(hero, tropius, 4)
	
	GAME:WaitFrames(12)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Before I go and dive into the wonderful world of paperwork though...")
	UI:WaitShowDialogue("I need to give you some essential items that all adventurers carry!")
	GAME:WaitFrames(20)
	
	GROUND:MoveInDirection(tropius, Direction.Down, 16, false, 1)
	--todo: tropius walks forward and places a chest
	GAME:WaitFrames(20)
	GROUND:AnimateInDirection(tropius, "Walk", Direction.Down, Direction.Up, 16, 1, 1)
	GAME:WaitFrames(20)
	
	UI:WaitShowDialogue("This box contains all the special tools that adventurers need.[pause=0] Go ahead,[pause=10] open it!")
	GAME:WaitFrames(20)
	
	--open the box
	GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4)
	GROUND:CharAnimateTurnTo(partner, Direction.UpLeft, 4)
	GAME:WaitFrames(10)
	GeneralFunctions.Monologue(hero:GetDisplayName() .. " opened the box.")
	
	--todo: box animation
	--todo: set bag size to 1 for first dungeon, then set it to 2 pages here
	--pipe dream todo: have scarves for the sprites from now on
	GAME:WaitFrames(20)
	GeneralFunctions.Monologue("Inside the box there was...")
	SOUND:PlayFanfare("Item")
	GeneralFunctions.Monologue("A map...")
	SOUND:PlayFanfare("Item")
	GeneralFunctions.Monologue("A set of adventurer's badges...")
	SOUND:PlayFanfare("Item")
	GeneralFunctions.Monologue("An item bag...")
	SOUND:PlayFanfare("Item")
	GeneralFunctions.Monologue("And a pair of Vibrant Scarves!")
	
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("You should find these items useful in your adventures to come.")
	UI:WaitShowDialogue("The map will help you locate discovered areas.[pause=0] It should help you keep from getting lost.")
	UI:WaitShowDialogue("Those adventurers badges are incredible tools![pause=0] Not only are they trackers in case something should ever happen to you...")
	UI:WaitShowDialogue("...they can also be used to rescue Pokémon in danger!")
	UI:WaitShowDialogue("You can use them to warp out from the end of a dungeon,[pause=10] too.[pause=0] No more backtracking!")
	UI:WaitShowDialogue("The item bag is self-explanatory.[pause=0] One thing to note though is that the bag can be upgraded.")
	UI:WaitShowDialogue("Do enough good adventuring work and it'll be able to carry more items!")
	UI:WaitShowDialogue("Lastly,[pause=10] a pair of Vibrant Scarves.[pause=0] You can wear them for a bit of a power boost!")
	UI:SetSpeakerEmotion("Happy")--change to a wink? how do you wink when only one eye shows
	UI:WaitShowDialogue("...But personally I think they're best as a fashion statement.")

	--thank you for the items and letting us join guildmaster
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Inspired")
	GROUND:CharTurnToCharAnimated(partner, tropius, 4)
	GROUND:CharTurnToCharAnimated(hero, tropius, 4)
	UI:WaitShowDialogue("Th-these items are amazing![pause=0] Thank you Guildmaster!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Of course![pause=0] I expect great things of you two.[pause=0] So work hard at your training!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("We'll train real hard![pause=0] We're gonna do what it takes to become great adventurers!")
	
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:WaitShowDialogue("Right,[pause=10] " .. hero:GetDisplayName() .. "?")
	
	GAME:WaitFrames(20)
	GeneralFunctions.DoAnimation(hero, "Nod")
	GAME:WaitFrames(20)
	
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("Yeah!")
	
	--pose before fading out
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
	GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
	GAME:WaitFrames(20)
	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharPoseAnim(partner, "Pose") end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharPoseAnim(hero, "Pose") end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) GROUND:CharSetEmote(tropius, 4, 0) end)
	GAME:WaitFrames(60)
	
	--rank up to normal rank upon joining guild
	GAME:FadeOut(60)
	_DATA.Save.ActiveTeam:SetRank(1)
	SV.Chapter1.TeamJoinedGuild = true
	GAME:CutsceneMode(false)
	GAME:EnterGroundMap("guild_heros_room", "Main_Entrance_Marker")

	
end