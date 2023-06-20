require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

guild_guildmasters_room_ch_1 = {}

--TASK:BranchCoroutine(guild_guildmasters_room_ch_1.MeetGuildmaster)
function guild_guildmasters_room_ch_1.MeetGuildmaster()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local tropius = CH('Tropius')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	GAME:MoveCamera(192, 112, 1, false) 
	GROUND:EntTurn(tropius, Direction.Up)
	
	local box = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Yellow_Box", 1), --anim data. Don't set that number to 0 for valid anims
								 				 RogueElements.Rect(184, 144, 16, 16),--xy coords, then size
								  				 RogueElements.Loc(4, 14), --offset
												 true, 
												 "Yellow_Box")--object entity name
	box:ReloadEvents()
	GAME:GetCurrentGround():AddTempObject(box)
	GROUND:ObjectSetDefaultAnim(box, 'Yellow_Box', 0, 0, 0,Direction.Down)
	GROUND:Hide(box.EntName)
	local noctowl = 
		CharacterEssentials.MakeCharactersFromList({
			{"Noctowl", 184, 288, Direction.Up}
		})
	
	GROUND:TeleportTo(hero, 168, 344, Direction.Up)
	GROUND:TeleportTo(partner, 200, 344, Direction.Up)
	
	GAME:FadeIn(40)
	
	GAME:WaitFrames(60)
	UI:SetSpeaker('[color=#00FFFF]Guildmaster[color]', true, tropius.CurrentForm.Species, tropius.CurrentForm.Form, tropius.CurrentForm.Skin, tropius.CurrentForm.Gender)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Hmm...[pause=0] Two prospective teams in one day...")
	UI:WaitShowDialogue("I don't think that's ever happened before.")
	
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
--	GROUND:CharTurnToCharAnimated(tropius, noctowl, 4)
	UI:SetSpeaker(noctowl)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("These are the two Pokémon I informed you of,[pause=10] Guildmaster.")
	
	GROUND:CharTurnToCharAnimated(noctowl, hero, 4)
	GAME:WaitFrames(40)
	GROUND:CharTurnToCharAnimated(tropius, hero, 4)
	GAME:WaitFrames(20)
	UI:SetSpeaker('[color=#00FFFF]Guildmaster[color]', true, tropius.CurrentForm.Species, tropius.CurrentForm.Form, tropius.CurrentForm.Skin, tropius.CurrentForm.Gender)
	UI:WaitShowDialogue("Howdy![pause=0] My name is " .. tropius:GetDisplayName() .. ",[pause=10] and I'm the Guildmaster here!")
	UI:SetSpeaker(tropius)
	GAME:WaitFrames(20)
	UI:WaitShowDialogue(noctowl:GetDisplayName() .. " has told me that the two of you want to apprentice at the guild.")
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("That's wonderful![pause=0] The world could always use more adventurers!")
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("I don't think I got your names,[pause=10] though.[pause=0] Could you tell me them please?")
	
	--partner speaks up
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GROUND:CharSetEmote(partner, "sweating", 1)
	UI:WaitShowDialogue("M-my n-name is...[pause=0] I-Is...")
	GAME:WaitFrames(20)
	
	GeneralFunctions.EmoteAndPause(partner, 'Sweating', true)
	UI:SetSpeakerEmotion('Pain')
	UI:WaitShowDialogue("(C'mon,[pause=10] I can't get cold feet now...)")
	
	GAME:WaitFrames(20)
	GeneralFunctions.ShakeHead(partner, 4)
	
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("(I just need to have a little confidence!)")
	UI:WaitShowDialogue("(It'll be scary...[pause=0] But I know I can do it!)")
	GAME:WaitFrames(20)
	GeneralFunctions.Hop(partner)
	
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("My name is " .. partner:GetDisplayName() .. "!")
	--GAME:WaitFrames(20)
	--GeneralFunctions.HeroDialogue(hero, "(Guess it's my turn now then.)", "Normal")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroSpeak(hero, 60)
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(tropius)
	UI:WaitShowDialogue(partner:GetDisplayName() .. " and " .. hero:GetDisplayName() .. "...[pause=0] Alright!")
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("It's nice to meet the both of you!")
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("I understand that you two want to train here at the guild.")
	UI:WaitShowDialogue("Do either of you have any experience adventuring already?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("Um...[pause=0] N-not really...[pause=0] We're pretty new to it...")
	GAME:WaitFrames(10)
	GeneralFunctions.Hop(partner)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("But we want to train here so we can become great adventurers,[pause=10] like you are!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Happy")
	GROUND:CharSetEmote(tropius, "glowing", 0)
	UI:WaitShowDialogue("Ha ha,[pause=10] you flatter me!")
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Normal")
	GROUND:CharSetEmote(tropius, "", 0)
	UI:WaitShowDialogue("It's alright if you don't have experience![pause=0] That's what apprenticing is for,[pause=10] right?")
	GAME:WaitFrames(20)
	
	--[[
	--Huh? trying times? what do you mean? something's wrong with the world or something?
	--this part rmeoved because I decided that the calamity (the blight) should only start to manifest once the hero comes to the world
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Frankly,[pause=10] it amazes me that so many Pokémon still wish to become adventurers ...")
	UI:WaitShowDialogue("...given the life force issues in recent times...")
	
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(hero, "Question", true)
	GeneralFunctions.HeroDialogue(hero, "(Huh?[pause=0] Issues with life forces?[pause=0] What is he talking about?)", "Worried")
	GAME:WaitFrames(20)
	]]--
	
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Normal")
--	UI:WaitShowDialogue("But I'm getting offtopic.[pause=0] What's important right now is your apprenticeship!")
	UI:WaitShowDialogue("Before you can sign up with us though,[pause=10] I do need to ask the two of you an important question.")
	UI:WaitShowDialogue("Don't be nervous.[pause=0] This isn't some sort of test of knowledge or anything.")
	UI:WaitShowDialogue("...So it's crucial that you answer honestly.[pause=0] Your answer is only wrong if you lie.")
	
	--what kind of questions is he about to ask us, oh goodness
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GAME:WaitFrames(12)
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GeneralFunctions.EmoteAndPause(hero, 'Sweating', false) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(partner, 'Sweating', true) end)
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
	GeneralFunctions.Hop(partner)
	UI:SetSpeaker(partner)
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
	GeneralFunctions.HeroDialogue(hero, "(Uh...[pause=0] That's a good question actually.[pause=0] I haven't put that much thought into it.)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(It sounded fun,[pause=10] sure,[pause=10] but I didn't really have any other options given my circumstances.)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(I'm not really sure what my answer is then...)", "Worried")
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
		GeneralFunctions.HeroDialogue(hero, "(Truthfully,[pause=10] I'd like to figure out who I used to be and how I lost my memory.)", "Worried")
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
		GeneralFunctions.HeroDialogue(hero, "(I don't know " .. GeneralFunctions.GetPronoun(partner, "them") .. " that well yet,[pause=10] but " .. GeneralFunctions.GetPronoun(partner, "they're") .. " still my only friend in this world...)", "Worried")
		GAME:WaitFrames(20)
		GeneralFunctions.HeroDialogue(hero, "(So I guess the real reason I'm here to be an adventurer is because of " .. partner:GetDisplayName() .. "!)", "Normal")
		GAME:WaitFrames(20)
		GeneralFunctions.HeroSpeak(hero, 60)
		GAME:WaitFrames(20)
		UI:SetSpeaker(tropius)
		--tropius likes this answer, partner is surprised by your answer 
		coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(tropius, "Exclaim", true) end)
		coro2 = TASK:BranchCoroutine(function() GROUND:CharSetEmote(partner, "exclaim", 1)
											    GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
		TASK:JoinCoroutines({coro1, coro2})
		UI:WaitShowDialogue("Oh?[pause=0] You want to be an adventurer so you can journey with your friend?")
		GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
		GAME:WaitFrames(16)
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("That's quite admirable![pause=0] Many Pokémon forget that the most important part of a team is your partner!")
		GAME:WaitFrames(20)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("The best teams are those whose members share a strong bond and put their teammates before anything else.")
		GAME:WaitFrames(20)
		UI:SetSpeakerEmotion("Worried")--foreshadowing
		UI:WaitShowDialogue("...And the worst are those who put glory or treasure first.")--FORESHADOWING
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
	
--	GAME:WaitFrames(20)
--	UI:SetSpeaker(noctowl)
--	UI:WaitShowDialogue("Of course I have thoughts,[pause=10] Guildmaster.[pause=0] I spend a lot of my time thinking,[pause=10] after all.")
--	GAME:WaitFrames(20)
--	UI:SetSpeaker(tropius)
--	UI:WaitShowDialogue("...What I meant was,[pause=10] do you have any thoughts on our prospective recruits here?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("I have no quarrels,[pause=10] Guildmaster.")
	GAME:WaitFrames(20)
	UI:SetSpeaker(tropius)
	UI:WaitShowDialogue("That's what I figured![pause=0] In that case...")
	GROUND:CharAnimateTurnTo(tropius, Direction.Down, 4)
	GROUND:CharAnimateTurnTo(noctowl, Direction.DownRight, 4)
	GAME:WaitFrames(10)
	
	
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Congratulations![pause=0] You two are now an official guild adventuring team!")
	
	
	--yay we did it!!
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
	GAME:WaitFrames(10)
	
	GROUND:CharSetEmote(partner, "happy", 0)
	GROUND:CharSetAnim(hero, "Idle", true)
	UI:SetSpeakerEmotion("Joyous")
	GeneralFunctions.DoubleHop(partner, "Idle")
	GROUND:CharSetAnim(partner, "Idle", true)
	UI:WaitShowDialogue("We did it![pause=0] We're in the guild,[pause=10] " .. hero:GetDisplayName() .. "![pause=0] I can't believe it!")
	
	GAME:WaitFrames(40)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Happy")
	GROUND:CharSetEmote(tropius, "glowing", 0)
	UI:WaitShowDialogue("Ha ha ha!")
	GAME:WaitFrames(10)
	GROUND:CharSetEmote(tropius, "", 0)
	GROUND:CharSetEmote(partner, "", 0)
	GROUND:CharSetAnim(partner, "None", true)
	GROUND:CharSetAnim(hero, "None", true)
	GROUND:CharTurnToCharAnimated(partner, tropius, 4)
	GROUND:CharTurnToCharAnimated(hero, tropius, 4)
	GAME:WaitFrames(20)
	
	
	--what is your team's name?
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Your training will start tomorrow.[pause=0] But before that,[pause=10] I need to update our records with your info.")
	
	GROUND:CharSetEmote(partner, "", 0)
	GROUND:CharSetAnim(partner, "None", true)
	GROUND:CharSetAnim(hero, "None", true)
	GROUND:CharTurnToCharAnimated(partner, tropius, 4)
	GROUND:CharTurnToCharAnimated(hero, tropius, 4)
	GAME:WaitFrames(12)
	UI:WaitShowDialogue("I have most of what I need already...[pause=0] But I still need your team's name.[pause=0] Have you decided on one?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("A team name?[pause=0] We hadn't thought of one yet.")
	
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
		UI:NameMenu("What will your team's name be?", "You don't need to put 'Team' in the name itself.", 60)
		UI:WaitForChoice()
		result = UI:ChoiceResult()
		GAME:SetTeamName(result)
		UI:ChoiceMenuYesNo("Is Team " .. GAME:GetTeamName() .. " correct?", true)
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
	UI:WaitShowDialogue("I need to give you the essential items that all adventurers carry!")
	GAME:WaitFrames(20)
	
	GROUND:MoveInDirection(tropius, Direction.Down, 16, false, 1)
	GAME:WaitFrames(10)
	--tropius walks forward and places a chest
	SOUND:PlayBattleSE('EVT_CH02_Item_Place')
	GROUND:Unhide("Yellow_Box")
	GAME:WaitFrames(20)
	GROUND:AnimateInDirection(tropius, "Walk", Direction.Down, Direction.Up, 16, 1, 1)
	GAME:WaitFrames(20)
	
	UI:WaitShowDialogue("This box contains all the special tools that adventurers use.[pause=0] Go ahead,[pause=10] open it!")
	GAME:WaitFrames(20)
	
	--open the box
	GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4)
	GROUND:CharAnimateTurnTo(partner, Direction.UpLeft, 4)
	GAME:WaitFrames(10)
	GROUND:ObjectSetAnim(box, 4, 0, 5, Direction.Down, 1)
	GROUND:ObjectSetDefaultAnim(box, 'Yellow_Box', 0, 5, 5, Direction.Down)
	SOUND:PlayBattleSE('EVT_CH02_Box_Open')
	GeneralFunctions.Monologue(hero:GetDisplayName() .. " opened the box.")
	
	--local scarf_name = RogueEssence.Dungeon.InvItem("held_synergy_scarf"):GetDisplayName()
	--have to hardcode this so I can have it say scarves instead of scarf
	local scarf_name = STRINGS:Format('\\uE0AE')..'[color=#FFCEFF]Synergy Scarves[color]'
	
	--pipe dream todo: have scarves for the sprites from now on
	GAME:WaitFrames(20)
	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue("Inside the box there was...")
	SOUND:PlayFanfare("Fanfare/Item")
	UI:WaitShowDialogue("A Wonder Map...[pause=40]")
	SOUND:PlayFanfare("Fanfare/Item")
	UI:WaitShowDialogue("A set of Adventurer Badges...[pause=40]")
	SOUND:PlayFanfare("Fanfare/Item")
	UI:WaitShowDialogue("A Treasure Bag...[pause=40]")
	SOUND:PlayFanfare("Fanfare/Item")
	UI:WaitShowDialogue("And a pair of " .. scarf_name .. "![pause=60]")
	UI:SetCenter(false)
	
	
	GAME:WaitFrames(30)
	GeneralFunctions.Hop(partner)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("Wow![pause=0] There's a ton of items here!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("You should find these items useful in your adventures to come.")
	UI:WaitShowDialogue("The Wonder Map will help you locate discovered areas.[pause=0] It should keep you from getting lost.")
	UI:WaitShowDialogue("The Adventurer Badges are incredible tools!")
	UI:WaitShowDialogue("Not only are they unique trackers in case something should ever happen to you...")
	UI:WaitShowDialogue("...They can also be used to rescue Pokémon in danger!")
	UI:WaitShowDialogue("You can use them to warp out from the end of a dungeon,[pause=10] too.")
	UI:WaitShowDialogue("That way you won't need to backtrack through the dungeon to get home.")
	UI:WaitShowDialogue("The Treasure Bag is self-explanatory.")
	UI:WaitShowDialogue("If you do enough good adventuring work,[pause=10] it'll be upgraded to carry more items!")
	UI:WaitShowDialogue("Lastly,[pause=10] a pair of " .. scarf_name .. ".")
	UI:WaitShowDialogue("These scarves are very special,[pause=10] so special in fact that they cannot be lost even if you faint in a dungeon!")
	UI:WaitShowDialogue("By themselves,[pause=10] the scarves won't do anything.")
	UI:WaitShowDialogue("But if the both of you wear the scarves and are close to each other...")
	UI:WaitShowDialogue("...Then the scarves will give you a number of useful boons!")
	UI:SetSpeakerEmotion("Happy")--change to a wink? how do you wink when only one eye shows
	UI:WaitShowDialogue("They also make a great fashion statement!")
	
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("We give a pair to all of our apprentices to help encourage teamwork.")
	UI:WaitShowDialogue("Please make good use of them!")


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
	UI:WaitShowDialogue("Of course![pause=0] I expect great things from you two![pause=0] So work hard at your training!")
	
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
	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharSetAction(partner, RogueEssence.Ground.PoseGroundAction(partner.Position, partner.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose"))) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharSetAction(hero, RogueEssence.Ground.PoseGroundAction(hero.Position, hero.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose"))) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(40) GROUND:CharSetEmote(tropius, "glowing", 0) end)
	GAME:WaitFrames(120)
	
	--rank up to normal rank upon joining guild
	SOUND:FadeOutBGM(60)
	GAME:FadeOut(false, 60)
	_DATA.Save.ActiveTeam:SetRank("normal")
	GAME:GivePlayerItem("held_synergy_scarf", 2)--give 2 vibrant scarves
	GAME:CutsceneMode(false)
	GAME:WaitFrames(60)
	GAME:EnterGroundMap("guild_heros_room", "Main_Entrance_Marker")
 	
end