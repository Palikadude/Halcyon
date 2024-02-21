require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

relic_forest_ch_1 = {}

-------------------------------
--Cutscene functions
-------------------------------
function relic_forest_ch_1.Intro_Cutscene()
	--First cutscene
	GAME:CutsceneMode(true)
	GROUND:Hide('Teammate1')
	UI:ResetSpeaker()
	SOUND:FadeOutBGM()
	
	local hero = CH('PLAYER')
	local marker = MRKR("WakeupLocation")
	GROUND:CharSetAnim(hero, 'Laying', true)
	GROUND:TeleportTo(hero, marker.Position.X, marker.Position.Y, Direction.Right)
	
	--set auto finish has it so the voiceover fades in and out as the complete line
	--rather than typing it out like in the personality quiz
	UI:SetAutoFinish(true)

	--chapter 1 title card
	local coro1 = TASK:BranchCoroutine(function() UI:WaitShowTitle("Chapter 1\n\nAnother Beginning\n", 20)
												  GAME:WaitFrames(180)
												  UI:WaitHideTitle(20) end)
	local coro2 = TASK:BranchCoroutine(function() UI:WaitShowBG("Chapter_1", 180, 20)
												  GAME:WaitFrames(180)
												  UI:WaitHideBG(20) end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(180)
	
	
  	UI:WaitShowVoiceOver(".........", -1)  
  	UI:WaitShowVoiceOver("...Eyes close to dream of fantastical realms...", -1)  
	UI:WaitShowVoiceOver("...Eyes open to meet with candid reality...", -1)  
	UI:WaitShowVoiceOver("...Worlds apart, yet intertwined.", -1)  
	UI:WaitShowVoiceOver(".........", -1)  
	UI:WaitShowVoiceOver("Where does that leave you?", -1) 
	
	UI:SetAutoFinish(false)
	
	GAME:WaitFrames(120)
	
	GAME:FadeIn(120)
	GAME:WaitFrames(120)
	UI:ResetSpeaker()
	UI:SetSpeaker('', false, hero.CurrentForm.Species, hero.CurrentForm.Form, hero.CurrentForm.Skin, hero.CurrentForm.Gender)
	UI:SetSpeakerEmotion('Pain')
	UI:WaitShowDialogue("(...[pause=0] No...[pause=0] Can't stay awake...)")
	GAME:WaitFrames(60)
	GAME:FadeOut(false, 120)
	
	SV.Chapter1.PlayedIntroCutscene = true
	GAME:CutsceneMode(false)
	GAME:EnterGroundMap("metano_town", "Main_Entrance_Marker")
	
	
	
end


function relic_forest_ch_1.PartnerFindsHeroCutscene()
--[color=#FFFF00]Riolu[color]
--[color=#00FFFF]Erleuchtet[color]

	--clear party, set up party with hero as player and partner as partner
	GeneralFunctions.DefaultParty(true)
	--[[
	local h = GAME:GetPlayerAssemblyMember(0)
	local p = GAME:GetPlayerPartyMember(0)
	GAME:RemovePlayerAssembly(0)
	GAME:RemovePlayerTeam(0)
	
	GAME:AddPlayerTeam(h)
	GAME:AddPlayerTeam(p)
	GAME:SetTeamLeaderIndex(0)	
	
	--spawn partner in manually, this is a special case because of party shenanigans
	COMMON.RespawnAllies()
	]]--
	
  
	
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local marker = MRKR("WakeupLocation")
	GROUND:CharSetAnim(hero, 'Laying', true)
	GROUND:TeleportTo(hero, marker.Position.X, marker.Position.Y, Direction.Right)

	SOUND:StopBGM()
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	GAME:MoveCamera(300, 536, 1, false)
	GROUND:TeleportTo(partner, 292, 616, Direction.Up)
	UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
	GAME:WaitFrames(60)
	UI:WaitHideTitle(20)
	GAME:FadeIn(40)
	SOUND:PlayBGM('In The Depths of the Pit.ogg', true)

	
	--walk into frame from the bottom 
	GeneralFunctions.MoveCharAndCamera(partner, 292, 528, false, 1)
	GAME:WaitFrames(20)
	GeneralFunctions.LookAround(partner, 2, 4, false, false, false, Direction.Up)
	GAME:WaitFrames(10)
	
	--celebrate that you made it through 
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("I've been at it for a while...[pause=0] Looks like I've made it to the deepest part of the forest.")
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("I'll never understand why " .. CharacterEssentials.GetCharacterName("Relicanth") .. " thinks the forest is so dangerous.")
	GAME:WaitFrames(40)
	UI:WaitShowDialogue("I've been here plenty of times before,[pause=10] but...")
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("I can't help but feel glad everytime I make it here.")
	SOUND:PlayBattleSE('EVT_Emote_Startled_2')
	GeneralFunctions.DoubleHop(partner)
	GROUND:CharSetEmote(partner, "glowing", 0)
	UI:WaitShowDialogue("My own little adventuring success!")
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(partner, "", 0)
	GAME:WaitFrames(20)

	
	--look around a bit 
	GeneralFunctions.LookAround(partner, 2, 4, false, true, false, Direction.Up)
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion('Normal')
	UI:WaitShowDialogue("Time to go check out my lucky charm while I'm here.")
	GAME:WaitFrames(20)

	--huh? something's over there?
	GeneralFunctions.MoveCharAndCamera(partner, 292, 408, false, 1)
	GeneralFunctions.LookAround(partner, 3, 4, false, false, true, Direction.UpLeft)
	SOUND:PlayBattleSE('EVT_Emote_Exclaim')
	GROUND:CharSetEmote(partner, "notice", 1)
	GAME:WaitFrames(20)
	SOUND:FadeOutBGM(120)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Huh?[pause=0] What's that over there?")
	GeneralFunctions.MoveCharAndCamera(partner, 292, 360, false, 1)
	GROUND:CharAnimateTurnTo(partner, Direction.UpLeft, 4)
	
	--"Waah! Someone has collapsed on the sand!" 
	--SOUND:PlayBattleSE('EVT_Emote_Startled')
	--GROUND:CharSetAnim(partner, 'Hurt', true)
	--GROUND:CharSetEmote(partner, "shock", 1)
	GeneralFunctions.Recoil(partner)
	GAME:WaitFrames(20)
	GROUND:CharSetAnim(partner, 'None', true)
	
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Waah![pause=0] Someone's passed out in the grass!")
	GeneralFunctions.MoveCharAndCamera(partner, 292, 272, true, 4)
	GeneralFunctions.MoveCharAndCamera(partner, 268, 272, true, 4)
	
	GAME:WaitFrames(10)
	GeneralFunctions.Hop(partner)
	UI:WaitShowDialogue("H-hey![pause=0] What happened!?[pause=0] Are you alright!?")
	GAME:WaitFrames(80)
	
	--step in and out twice, facing forward the entire time
	UI:WaitShowDialogue("Oh no,[pause=10] c'mon,[pause=10] please be okay!")
	GROUND:MoveInDirection(partner, Direction.Left, 4, false, 2)
	GROUND:AnimateInDirection(partner, "Walk", Direction.Left, Direction.Right, 4, 1, 2)
	GAME:WaitFrames(10)
	GROUND:MoveInDirection(partner, Direction.Left, 4, false, 2)
	GROUND:AnimateInDirection(partner, "Walk", Direction.Left, Direction.Right, 4, 1, 2)
	
	--wakeup
	GAME:WaitFrames(40)
	GeneralFunctions.Shake(hero)
	GAME:WaitFrames(30)
	UI:SetSpeaker(hero)
	GeneralFunctions.HeroDialogue(hero, "(...)", "Pain")
	GROUND:CharSetAnim(hero, 'Wake', false)
	GAME:WaitFrames(40)
	GROUND:CharSetAnim(hero, 'None', true)
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(partner, "exclaim", 1)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim")
	GAME:WaitFrames(40)
	GROUND:AnimateInDirection(partner, "Walk", Direction.Left, Direction.Right, 8, 1, 1)
	
	GeneralFunctions.LookAround(hero, 4, 4, true, true, false, Direction.Right)
	GAME:WaitFrames(40)
	
	--partner is relieved you arent dead
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Sigh")
	UI:WaitShowDialogue("Phew![pause=0] You weren't waking up.[pause=0] You had me scared for a moment there!")
		
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Well,[pause=10] I'm glad to see you're alright.[pause=0] My name's " .. partner:GetDisplayName() .."!")
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("How did you end up here anyway?[pause=0] Nobody's really supposed to be out here.")
	
	--amnesia
	local hero_species = _DATA:GetMonster(hero.CurrentForm.Species):GetColoredName()
	local partner_species = _DATA:GetMonster(partner.CurrentForm.Species):GetColoredName()
	GAME:WaitFrames(20)
	GeneralFunctions.HeroSpeak(hero, 60)
	GAME:WaitFrames(20)
	GeneralFunctions.Recoil(partner)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Huh?[pause=0] You don't know how you got here?")
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("That's worrisome...[pause=0] How would " .. GeneralFunctions.GetColoredStringArticle(hero_species) .. " " .. hero_species .. " end up conked out here with no memory of it?")
	
	--hero realizes they are a pokemon, pinches themselves to see if they are dreaming
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(hero, "question", 1)
	SOUND:PlayBattleSE("EVT_Emote_Confused")
	GAME:WaitFrames(40)
	GeneralFunctions.LookAround(hero, 3, 4, false, false, false, Direction.Right)
	GAME:WaitFrames(40)
	GROUND:CharSetEmote(hero, "shock", 1)
	SOUND:PlayBattleSE("EVT_Emote_Shock")
	GAME:WaitFrames(40)
	GeneralFunctions.HeroDialogue(hero, "(Wh-what!?[pause=0] I am " .. GeneralFunctions.GetColoredStringArticle(hero_species) .. " " .. hero_species .. "!)", "Surprised")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(This must be a dream![pause=0] There's no way I really turned into " .. GeneralFunctions.GetColoredStringArticle(hero_species) .. " " .. hero_species .. "!)", "Surprised")
	GeneralFunctions.HeroDialogue(hero, "(I'll just pinch myself right now and wake up!)", "Surprised")
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(hero, "shock", 1)
	SOUND:PlayBattleSE("DUN_Bounced")--pinch sfx
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(Yowch!)", "Pain")
	GAME:WaitFrames(40)
	GeneralFunctions.HeroDialogue(hero, "(I'm still here!?[pause=0] This is actually real!?)", "Surprised")
	GAME:WaitFrames(10)
	SOUND:PlayBattleSE('EVT_Emote_Sweating')
	GROUND:CharSetEmote(hero, "sweating", 1)
	GAME:WaitFrames(40)
	GeneralFunctions.HeroDialogue(hero, "(I can't believe this...[pause=0] I'm really " .. GeneralFunctions.GetColoredStringArticle(hero_species) .. " " .. hero_species .. "...)", "Worried")--at some point, should comment on how being a Pokémon is actually sick, just initially shocked and overwhelmed which is why they reacted like this
	GeneralFunctions.HeroDialogue(hero, "(But how did this happen?[pause=0] I can't remember anything...)", "Worried")
	GAME:WaitFrames(40)
	GeneralFunctions.HeroSpeak(hero, 60)
	GAME:WaitFrames(20)
	
	--human? this a joke?
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(partner, "question", 1)
	SOUND:PlayBattleSE("EVT_Emote_Confused")
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Surprised")
	GAME:WaitFrames(40)
	--maybe add a hop at the end of the dialogue
	UI:WaitShowDialogue("Huh?[pause=0] You say you're actually a human?")
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Are you trying to pull a fast one on me?[pause=0] I thought humans were just some myth...")
	UI:WaitShowDialogue("Besides,[pause=10] you look like a " ..  hero_species .. " to me...")
	
	
	GROUND:CharSetEmote(hero, "exclaim", 1)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
	GAME:WaitFrames(20)
	GeneralFunctions.ShakeHead(hero, 4, true)
	
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("relic_forest")
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("You're adamant that you're a human,[pause=10] huh?")
	UI:WaitShowDialogue("I'm having a hard time believing that a human could turn into a Pokémon...")
	GAME:WaitFrames(20)
	
	
	SOUND:PlayBattleSE('EVT_Emote_Sweating')
	GROUND:CharSetEmote(hero, "sweating", 1)
	GAME:WaitFrames(40)
	GeneralFunctions.HeroDialogue(hero, "(Is it really that hard to trust that I was a human?)", "Sad")
	GAME:WaitFrames(60)
	GeneralFunctions.HeroDialogue(hero, "(This " .. partner_species .. " doesn't believe me...[pause=0] Would anyone else?)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(I can't remember anything...[pause=0] What am I going to do?)", "Worried")


	--partner realizes you're scared and lost
	GAME:WaitFrames(40)
	SOUND:PlayBattleSE('EVT_Emote_Exclaim')
	GROUND:CharSetEmote(partner, "notice", 1)
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("(Hmm...[pause=0] " .. GeneralFunctions.GetPronoun(hero, 'they', true) .. " " .. GeneralFunctions.Conjugate(hero, 'look') .. " stunned,[pause=10] actually...[pause=0] Maybe " .. GeneralFunctions.GetPronoun(hero, "they're", false) .. " telling the truth after all?)")
	UI:WaitShowDialogue("(" .. GeneralFunctions.GetPronoun(hero, 'they', true) .. " even pinched " .. GeneralFunctions.GetPronoun(hero, 'themself') .. " like " .. GeneralFunctions.GetPronoun(hero, 'they') .. " " .. GeneralFunctions.GetPronoun(hero, "were") .. " trying to wake up or something...)")
	UI:WaitShowDialogue("(...There's no reason for someone to lie about this sort of thing,[pause=10] right?)")
	GAME:WaitFrames(40)
	
	--ok i believe you kinda 
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Hey...[pause=0] Um...[pause=0] I thought about it a bit more and...")
	UI:WaitShowDialogue("I think that maybe you're not lying after all.[pause=0] Your reaction seems genuine.")
	UI:WaitShowDialogue("Someone wouldn't just lie unconscious in a mystery dungeon claiming what you are as a joke.")
	UI:WaitShowDialogue("Even if it turns out your story isn't one hundred percent true...")
	UI:WaitShowDialogue("I do think that you're being honest at least.[pause=0] Something strange certainly happened to you.")
	GAME:WaitFrames(20)

	--name yourself	
	UI:SetSpeakerEmotion("Worried")
	GAME:WaitFrames(40)
	UI:WaitShowDialogue("But...[pause=0] Are you sure you can't remember anything at all?[pause=0] A name perhaps?")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(...I don't think I even remember something as simple as that...)", "Sad")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(I could just pick something that I'd like to be called,[pause=10] I suppose.)", "Normal")
	GAME:WaitFrames(20)
	UI:ResetSpeaker()
	local yesnoResult = false
	while not yesnoResult do
		UI:NameMenu("What will your name be?", "", 60)
		UI:WaitForChoice()
		result = UI:ChoiceResult()
		GAME:SetCharacterNickname(GAME:GetPlayerPartyMember(0), result)
		UI:ChoiceMenuYesNo("Is " .. hero:GetDisplayName() .. " correct?")
		UI:WaitForChoice()
		yesnoResult = UI:ChoiceResult()
	end

	GAME:WaitFrames(20)
	GeneralFunctions.HeroSpeak(hero, 60)
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("I see.[pause=0] So " .. hero:GetDisplayName() .. " is your name.")
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Glad to meet you,[pause=10] " .. hero:GetDisplayName() .. "!")
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("I'm sorry for being skeptical before.[pause=0] It's just hard to believe that a human could turn into a Pokémon.")
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Even if you weren't a human,[pause=10] you think you were one and that's good enough for me.")
	
	
	
	--will you come with me back to metano town?
	GAME:WaitFrames(20)
	GeneralFunctions.LookAround(partner, 2, 4, false, false, false, Direction.Left)
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("But,[pause=10] um...[pause=0] It's getting late...")
	--GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("I think you should come with me to the nearby town.")
	UI:WaitShowDialogue("You've lost your memory and turned into a Pokémon for some reason...")
	UI:WaitShowDialogue("It wouldn't be right to leave you all alone after all that you've told me.")
	UI:BeginChoiceMenu("So,[pause=10] what do you say?[pause=0] Will you come with me?", {"Go with " .. GeneralFunctions.GetPronoun(partner, 'them'), "Refuse"}, 1, 2)
	UI:WaitForChoice()
	local result = UI:ChoiceResult()	
	--if you say no, loop a dialogue until you say yes
	while result == 2 do 
		GAME:WaitFrames(20)
		GeneralFunctions.Recoil(partner)
		GROUND:CharSetAnim(partner, 'None', true)
		UI:SetSpeakerEmotion("Surprised")
		UI:WaitShowDialogue("Wh-what!?")
		SOUND:PlayBattleSE('EVT_Emote_Sweating')
		GROUND:CharSetEmote(partner, "sweating", 1)
		GAME:WaitFrames(40)
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue(hero:GetDisplayName() .. "...")
		UI:WaitShowDialogue("You've lost your memory and turned into a Pokémon...")
		UI:WaitShowDialogue("Where else would you go?[pause=0] What else would you do?")
		GAME:WaitFrames(20)
		UI:SetSpeakerEmotion("Sad")
		UI:WaitShowDialogue("I can't in good conscience leave you out here...")
		UI:BeginChoiceMenu("So please...[pause=0] Will you come back with me?", {"Go with " ..  GeneralFunctions.GetPronoun(partner, 'them'), "Refuse"}, 1, 2)
		UI:WaitForChoice()
		result = UI:ChoiceResult()	
	end
	
	--player agrees
	GAME:WaitFrames(40)
	GeneralFunctions.HeroDialogue(hero, "(I don't exactly have many options here...)", "Worried")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(But " .. partner:GetDisplayName() .. " seems kind.[pause=0] Sticking with " ..  GeneralFunctions.GetPronoun(partner, 'them') .. " for now seems like a good idea.)", "Normal")
	GeneralFunctions.HeroDialogue(hero, "(Besides...[pause=0] I have a strangely good feeling about " .. partner:GetDisplayName() .. ".)", "Normal")
	GAME:WaitFrames(20)
	GeneralFunctions.DoAnimation(hero, 'Nod')
	GAME:WaitFrames(20)
	
	--hooray we'll have to go thru the dungeon though
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Great![pause=0] Glad to hear it!")
	UI:SetSpeakerEmotion("Worried")
	GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
	GAME:WaitFrames(16)
	UI:WaitShowDialogue("We'll have to trek back through the mystery dungeon to get there though.")
	GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
	GAME:WaitFrames(16)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("I managed to get here by myself,[pause=10] so as long as we work together it'll be easy to get back through it!")

	--lets look around before leaving
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	GAME:WaitFrames(40)
	GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Before we leave,[pause=10] could you look at something with me for a moment?")
	UI:WaitShowDialogue("I want to show you something cool.")
	GAME:WaitFrames(20)
	

	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.MoveCharAndCamera(partner, 293, 247, false, 1)
											GeneralFunctions.MoveCharAndCamera(partner, 293, 218, false, 1) end)
	GAME:WaitFrames(40)
	GeneralFunctions.EightWayMove(hero, 270, 236, false, 1)
	GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4)
	TASK:JoinCoroutines({coro1})
	GAME:WaitFrames(20)
	
	--wow a stone tablet
	GeneralFunctions.EmoteAndPause(hero, "Question", true)
	GeneralFunctions.HeroDialogue(hero, "(Huh?[pause=0] There's a stone obelisk over here.)", "Normal")
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion('Normal')
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	UI:WaitShowDialogue("I've explored here many times,[pause=10] but this tablet has always mystified me.")
	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	UI:WaitShowDialogue("If you look closely at it,[pause=10] you can see there's some sort of ancient script written on it.")
	GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4)

	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion('Normal')
	GROUND:CharAnimateTurnTo(partner, Direction.DownLeft, 4)
	UI:WaitShowDialogue("This is the only place I've ever seen letters like this!")
	UI:SetSpeakerEmotion('Worried')
	UI:WaitShowDialogue('But...[pause=0] I have no clue what the letters or the writing means...')
	
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion('Inspired')
	GeneralFunctions.Hop(partner)
	GROUND:CharSetEmote(partner, "happy", 0)
	UI:WaitShowDialogue("Isn't it amazing though?[br]There must be some important history behind this tablet and the writing on it!")
	UI:WaitShowDialogue("Things like this just fascinate me so much!")
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Normal")
	GROUND:CharSetEmote(partner, "", 0)
	UI:WaitShowDialogue('Anyways,[pause=10] I always rub the stone for good luck when I come out here.')
	GAME:WaitFrames(20)
	
	
	--touch the tablet
	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	GROUND:MoveToPosition(partner, 293, 210, false, 1)	
	GAME:WaitFrames(20)
	GROUND:CharSetAction(partner, RogueEssence.Ground.PoseGroundAction(partner.Position, partner.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GAME:WaitFrames(40)

	GeneralFunctions.Monologue(partner:GetDisplayName() .. " rubbed the ancient stone tablet.")
	UI:SetSpeaker(partner)
	GAME:WaitFrames(40)
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:AnimateToPosition(partner, "Walk", Direction.Up, 293, 218, 1, 1, 0)
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(partner, Direction.DownLeft, 4)
	
	--ask hero to try
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("You should rub it for luck too,[pause=10] " .. hero:GetDisplayName() .. "!")
	
	--partner moves out of way, hero tries looking and touching
	coro1 = TASK:BranchCoroutine(function() GROUND:AnimateToPosition(partner, "Walk", Direction.Left, 317, 218, 1, 1, 0) end)
	GAME:WaitFrames(32)
	GROUND:MoveToPosition(hero, 293, 218, false, 1)	
	TASK:JoinCoroutines({coro1})
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	GAME:WaitFrames(20)
	--sense a vague connection with the tablet

	GeneralFunctions.HeroDialogue(hero, "(" .. partner:GetDisplayName() .. "'s right.[pause=0] There is bizarre writing on the tablet.)", "Normal")
	GeneralFunctions.HeroDialogue(hero, "(I'll give it a rub for luck too then.)", "Normal")
	GROUND:MoveToPosition(hero, 293, 210, false, 1)	
	GAME:WaitFrames(20)
	GROUND:CharSetAction(hero, RogueEssence.Ground.PoseGroundAction(hero.Position, hero.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	
	GAME:WaitFrames(40)
	GeneralFunctions.Monologue(hero:GetDisplayName() .. " rubbed the ancient stone tablet.")
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(hero, "notice", 1)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(Nothing seems out of the ordinary here,[pause=10] but...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(Something about this tablet is giving me a strange tension all over.)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(But why?[pause=0] There doesn't seem to be anything outstanding about this tablet...)", "Worried")
	GAME:WaitFrames(20)

	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:AnimateToPosition(hero, "Walk", Direction.Up, 293, 218, 1, 1, 0)
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(hero, Direction.Right, 4)
	GAME:WaitFrames(16)
	GeneralFunctions.HeroSpeak(hero, 60)

	--couldnt really learn anything meaningful from touching the tablet.
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("When you touched the tablet,[pause=10] you had some sort of strange,[pause=10] tense feeling?")
	GAME:WaitFrames(20)
	--UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("That's weird...[pause=0] But if you don't know anything about it,[pause=10] we don't know if that feeling means something.")
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("It's something to keep in mind,[pause=10] I suppose.[pause=0] Too bad we don't know more about this tablet...")
	GAME:WaitFrames(20)
	
	--nothing else is nearby. Let's leave.
	GeneralFunctions.LookAround(partner, 4, 4, true, false, false, Direction.Left)
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("I think it's time we headed towards town.")
	UI:WaitShowDialogue("If we stick together,[pause=10] we should be able to make it through the mystery dungeon in one piece.")
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("Alright![pause=0] Let's get a move on!")
	GAME:WaitFrames(20)

	--leave together, 
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 317, 298, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GeneralFunctions.WaitThenMove(hero, 293, 298, false, 1, 20) end)
	GAME:WaitFrames(40)
	GAME:FadeOut(false, 40)
	TASK:JoinCoroutines({coro1, coro2})	

	SV.Chapter1.PartnerMetHero = true
	--set team name temporarily to hero and partners name
	GAME:SetTeamName(hero.Nickname .. " and " .. partner.Nickname)
	GAME:CutsceneMode(false)

	--relic forest dungeon round 2
	GAME:EnterDungeon("relic_forest", 0, 4, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, true)

end

--the duo wiped trying to make it back to town
function relic_forest_ch_1.WipedInForest()
	--reset party
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	GAME:MoveCamera(294, 520, 1, false)
	GROUND:TeleportTo(hero, 276, 512, Direction.Left)
	GROUND:TeleportTo(partner, 308, 512, Direction.Right)
	GROUND:CharSetAnim(partner, 'EventSleep', true)
	GROUND:CharSetAnim(hero, 'EventSleep', true)

	GAME:FadeIn(40)
	--SOUND:PlayBGM('In The Depths of the Pit.ogg', true) --the music has a bit of a delay to starting, so i think having it fade in as soon as the map loads is OK.

	GAME:WaitFrames(110)--slightly less than 120 frames so that the sleep animation doesnt barely start another frame before waking
	
	coro1 = TASK:BranchCoroutine(function () GeneralFunctions.DoAnimation(hero, 'Wake')
											 GAME:WaitFrames(10) 
											 GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
											 GAME:WaitFrames(40)
											 GeneralFunctions.LookAround(hero, 3, 4, false, false, false, Direction.Left)
											 end)
	coro2 = TASK:BranchCoroutine(function () GAME:WaitFrames(10)
											 GeneralFunctions.DoAnimation(partner, 'Wake')
											 GAME:WaitFrames(15) 
											 GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
											 GAME:WaitFrames(40)
											 GeneralFunctions.LookAround(partner, 3, 4, false, false, true, Direction.Right)
											 end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function () GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) --so he rotates down
											 GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
	coro2 = TASK:BranchCoroutine(function () GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
	TASK:JoinCoroutines({coro1, coro2})

	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion('Pain')
	GeneralFunctions.EmoteAndPause(partner, 'Sweating', true)	
	UI:WaitShowDialogue('Ouch...[pause=0] That was tougher than I expected...')
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion('Normal')
	UI:WaitShowDialogue('Are you okay,[pause=10] ' .. hero:GetDisplayName() .. '?')
	
	GAME:WaitFrames(10)
	GeneralFunctions.DoAnimation(hero, 'Nod')
	GAME:WaitFrames(20)

	UI:WaitShowDialogue("I guess if either of us get knocked out,[pause=10] then the other can't continue...")
	--UI:WaitShowDialogue("I wonder why that is?")
	
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
	GAME:WaitFrames(40)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	UI:WaitShowDialogue("Well,[pause=10] we can't dawdle here.[pause=0] We got to make it back to town before it gets any later.")
	UI:WaitShowDialogue("Let's give it another shot,[pause=10] " .. hero:GetDisplayName() .. "![script=0]", {function() return GeneralFunctions.Hop(partner) end})
	GAME:WaitFrames(20)

	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Down, 4) GROUND:MoveToPosition(partner, 308, 612, false, 1) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)  GROUND:MoveToPosition(hero, 276, 612, false, 1) end)
	GAME:WaitFrames(60)
	SOUND:FadeOutBGM(40)
	GAME:FadeOut(false, 40)
	TASK:JoinCoroutines({coro1, coro2})	
	
	GAME:CutsceneMode(false)

	--relic forest dungeon round 2
	GAME:EnterDungeon("relic_forest", 0, 4, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, true)
end
