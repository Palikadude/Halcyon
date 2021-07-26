--[[
    init.lua
    Created: 06/24/2021 22:23:31
    Description: Autogenerated script file for the map relic_forest.
]]--
-- Commonly included lua functions and data
require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'

-- Package name
local relic_forest = {}

-- Local, localized strings table
-- Use this to display the named strings you added in the strings files for the map!
-- Ex:
--      local localizedstring = MapStrings['SomeStringName']
local MapStrings = {}

-------------------------------
-- Map Callbacks
-------------------------------
---relic_forest.Init
--Engine callback function
function relic_forest.Init(map)

  DEBUG.EnableDbgCoro()
  print('=>> Init_relic_forest <<=')
  MapStrings = COMMON.AutoLoadLocalizedStrings()
  COMMON.RespawnAllies()
  PartnerEssentials.InitializePartnerSpawn()


end

---relic_forest.Enter
--Engine callback function
function relic_forest.Enter(map)
	--relic_forest.PartnerFindsHeroCutscene()  

	if SV.ChapterProgression.Chapter == 1 then 
	  if not SV.Chapter1.PlayedIntroCutscene then --Opening Cutscene on a fresh save
		relic_forest.Intro_Cutscene()
	  elseif SV.Chapter1.PartnerCompletedForest and not SV.Chapter1.PartnerMetHero then --our duo meet
		relic_forest.PartnerFindsHeroCutscene()  
	  elseif SV.Chapter1.PartnerCompletedForest and not SV.Chapter1.TeamCompletedForest then--team wiped in the dungeon
		relic_forest.WipedInForest()
	  end
	else 
		GAME:FadeIn(20)
	end
end

---relic_forest.Exit
--Engine callback function
function relic_forest.Exit(map)


end

---relic_forest.Update
--Engine callback function
function relic_forest.Update(map)


end

-------------------------------
--Cutscene functions
-------------------------------

function relic_forest.Intro_Cutscene()
	--First cutscene
	GAME:CutsceneMode(true)
	UI:ResetSpeaker()
	SOUND:FadeOutBGM()
	
	
	--initialize some save data
	_DATA.Save.ActiveTeam:SetRank(0)
	_DATA.Save.ActiveTeam.Money = 0
	_DATA.Save.ActiveTeam.Bank = 0
	
	--remove any team members that may exist by default for some reason
	local party_count = _DATA.Save.ActiveTeam.Players.Count
	for ii = 1, party_count, 1 do
		_DATA.Save.ActiveTeam.Players:RemoveAt(0)
	end

	local assembly_count = GAME:GetPlayerAssemblyCount()
	for i = 1, assembly_count, 1 do
	   _DATA.Save.ActiveTeam.Assembly.RemoveAt(i-1)--not sure if this permanently deletes or not...
	end 
	
	
  	UI:WaitShowVoiceOver(STRINGS:Format(MapStrings['Personality_Quiz_001']), -1)  
  	UI:WaitShowVoiceOver(STRINGS:Format(MapStrings['Personality_Quiz_002']), -1)  
	UI:WaitShowVoiceOver(STRINGS:Format(MapStrings['Personality_Quiz_003']), -1)  
	UI:WaitShowVoiceOver(STRINGS:Format(MapStrings['Personality_Quiz_004']), -1)  
	UI:WaitShowVoiceOver(STRINGS:Format(MapStrings['Personality_Quiz_005']), -1) 

	--Hero data
	--This will be replaced by a personality quiz when I get around to it.
	local msg = STRINGS:Format(MapStrings['Test_Hero'])
	local hero_choices = {'Treecko', 'Cyndaquil', 'Turtwig', 'Squirtle'}
	UI:BeginChoiceMenu(msg, hero_choices, 1, 4)
	UI:WaitForChoice()	
	local result = UI:ChoiceResult()

	
	local gender = 0
	local gender_choices = {'Boy', 'Girl'}
	msg = STRINGS:Format(MapStrings['Gender_Prompt_Hero'])
	UI:BeginChoiceMenu(msg, gender_choices, 1, 2)
	UI:WaitForChoice()
	gender = UI:ChoiceResult()
	
	if gender == 1 then
		gender = Gender.Male
	else 
		gender = Gender.Female
	end
		
	local mon_ID = 0
	local egg_move = 0
	if result == 1 then 
		mon_id = RogueEssence.Dungeon.MonsterID(252, 0, 0, gender)
		egg_move = 225--dragonbreath
	elseif result == 2 then
		mon_id = RogueEssence.Dungeon.MonsterID(155, 0, 0, gender)
		egg_move = 24--double kick
	elseif result == 3 then
		mon_id = RogueEssence.Dungeon.MonsterID(387, 0, 0, gender)
		egg_move = 328--sand tomb
	else
		mon_id = RogueEssence.Dungeon.MonsterID(7, 0, 0, gender)
		egg_move = 196--icy wind
	end
	
	_DATA.Save.ActiveTeam.Players:Add(_DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 5, -1, 0))--dunno what the -1 and 0 are exactly...
	
	GAME:LearnSkill(GAME:GetPlayerPartyMember(0), egg_move)
	GAME:SetTeamLeaderIndex(0)
	

	--Partner data
	msg = STRINGS:Format(MapStrings['Test_Partner'])
	local partner_choices = {'Chikorita', 'Piplup', 'Riolu', 'Torchic'}
	UI:BeginChoiceMenu(msg, partner_choices, 1, 4)
	UI:WaitForChoice()
	result = UI:ChoiceResult()
	
	gender = 0
	msg = STRINGS:Format(MapStrings['Gender_Prompt_Partner'])
	UI:BeginChoiceMenu(msg, gender_choices, 1, 2)
	UI:WaitForChoice()
	gender = UI:ChoiceResult()
	
	if gender == 1 then
		gender = Gender.Male
	else 
		gender = Gender.Female
	end
		

	mon_ID = 0
	egg_move = 0
	if result == 1 then 
		mon_id = RogueEssence.Dungeon.MonsterID(152, 0, 0, gender)
		egg_move = 246--ancient power
	elseif result == 2 then
		mon_id = RogueEssence.Dungeon.MonsterID(393, 0, 0, gender)
		egg_move = 196--icy wind
	elseif result == 3 then
		mon_id = RogueEssence.Dungeon.MonsterID(447, 0, 0, gender)
		egg_move = 418--Bullet punch
	else
		mon_id = RogueEssence.Dungeon.MonsterID(255, 0, 0, gender)
		egg_move = 67--low kick
	end
  	
	_DATA.Save.ActiveTeam.Players:Add(_DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 5, -1, 0))--dunno what the -1 and 0 are exactly...
	
	GAME:LearnSkill(GAME:GetPlayerPartyMember(1), egg_move)

    _DATA.Save:UpdateTeamProfile(true)
    _DATA.Save.ActiveTeam.Leader.IsFounder = true
  
	local yesnoResult = false 
	while not yesnoResult do
		UI:NameMenu(STRINGS:Format(MapStrings['Partner_Name_Prompt']), "It is highly recommended to give a nickname.")
		UI:WaitForChoice()
		result = UI:ChoiceResult()
		UI:ChoiceMenuYesNo("Is [color=#FFFF00]" .. result .. "[color] correct?")
		UI:WaitForChoice()
		yesnoResult = UI:ChoiceResult()
	end

	
	local partner = GAME:GetPlayerPartyMember(1)
	--if no name given, set name to species name
	--if result == "" then result = _DATA:GetMonster(partner.CurrentForm.Species).Name:ToLocal() end

	
	GAME:SetCharacterNickname(partner, result)
	_DATA.Save.ActiveTeam.Name = result --set team name to partner's name temporarily
	COMMON.RespawnAllies()
	
	GAME:WaitFrames(180)
  
  
  	local hero = CH('PLAYER')
	local marker = MRKR("WakeupLocation")
	GROUND:CharSetAnim(hero, 'Laying', true)
	GROUND:TeleportTo(hero, marker.Position.X, marker.Position.Y, Direction.Right)
	
	--todo: show a screen for Chapter 1:
	
	
	UI:WaitShowVoiceOver(STRINGS:Format(MapStrings['Opening_Cutscene_001']), -1)
	UI:WaitShowVoiceOver(STRINGS:Format(MapStrings['Opening_Cutscene_002']), -1)
	UI:WaitShowVoiceOver(STRINGS:Format(MapStrings['Opening_Cutscene_003']), -1)
	UI:WaitShowVoiceOver(STRINGS:Format(MapStrings['Opening_Cutscene_004']), -1)
	UI:WaitShowVoiceOver(STRINGS:Format(MapStrings['Opening_Cutscene_005']), -1)
	
	GAME:WaitFrames(60)
	GAME:FadeIn(120)
	GAME:WaitFrames(120)
	UI:ResetSpeaker()
	UI:SetSpeaker('', false, hero.CurrentForm.Species, hero.CurrentForm.Form, hero.CurrentForm.Skin, hero.CurrentForm.Gender)
	UI:SetSpeakerEmotion('Pain')
	UI:WaitShowDialogue(STRINGS:Format(MapStrings['Opening_Cutscene_006']))
	GAME:WaitFrames(60)
	GAME:FadeOut(false, 120)
	
	SV.Chapter1.PlayedIntroCutscene = true
	GAME:CutsceneMode(false)
	GAME:EnterGroundMap("metano_town", "Main_Entrance_Marker")
	
	
	
end


function relic_forest.PartnerFindsHeroCutscene()
--[color=#FFFF00]Riolu[color]
--[color=#00FFFF]Erleuchtet[color]
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local marker = MRKR("WakeupLocation")
	GROUND:CharSetAnim(hero, 'Laying', true)
	GROUND:TeleportTo(hero, marker.Position.X, marker.Position.Y, Direction.Right)

	--add hero back to the team
    local p = GAME:GetPlayerAssemblyMember(0)
	GAME:RemovePlayerAssembly(0)
	GAME:AddPlayerTeam(p)

	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	GAME:MoveCamera(300, 536, 1, false)
	GROUND:TeleportTo(partner, 292, 616, Direction.Up)
	UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
	GAME:WaitFrames(60)
	UI:WaitHideTitle(20)
	GAME:FadeIn(20)
	
	--walk into frame from the bottom 
	GeneralFunctions.MoveCharAndCamera(partner, 292, 528, false, 1)
	GeneralFunctions.LookAround(partner, 2, 4, false, false, false, Direction.Up)
	GAME:WaitFrames(10)
	
	--celebrate that you made it through 
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("I've been at it for a while...[pause=0] Looks like I've made it to the deepest part of the forest.")
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("I'll never understand why [color=#00FFFF]Erleuchtet[color] thinks the forest is so dangerous.")
	--todo: do a little hop
	GAME:WaitFrames(40)
	UI:WaitShowDialogue("I've been here plenty of times before,[pause=10] but...")
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("I can't help but feel glad everytime I make it here.")
	GROUND:CharSetEmote(partner, 4, 0)
	UI:WaitShowDialogue("My own little adventuring triumph!")
	GROUND:CharSetEmote(partner, -1, 0)
	GAME:WaitFrames(20)

	
	--look around a bit 
	GeneralFunctions.LookAround(partner, 2, 4, false, true, false, Direction.Up)
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion('Normal')
	UI:WaitShowDialogue("I may as well look around while I'm here.")

	--huh? something's over there?
	GeneralFunctions.MoveCharAndCamera(partner, 292, 408, false, 1)
	GeneralFunctions.LookAround(partner, 3, 4, false, false, true, Direction.UpLeft)
	SOUND:PlayBattleSE('EVT_Emote_Exclaim')
	GROUND:CharSetEmote(partner, 2, 1)
	GAME:WaitFrames(20)
	SOUND:FadeOutBGM()
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Huh?[pause=0] What's that over there?")
	GeneralFunctions.MoveCharAndCamera(partner, 292, 360, false, 1)
	GROUND:CharAnimateTurnTo(partner, Direction.UpLeft, 4)
	
	--"Waah! Someone has collapsed on the sand!" 
	SOUND:PlayBattleSE('EVT_Emote_Startled')
	GROUND:CharSetAnim(partner, 'Hurt', true)
	GROUND:CharSetEmote(partner, 8, 1)
	--todo: do a little hop
	GAME:WaitFrames(20)
	GROUND:CharSetAnim(partner, 'None', true)
	
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Ahhh![pause=0] Someone's passed out in the grass!")
	GeneralFunctions.MoveCharAndCamera(partner, 292, 272, true, 4)
	GeneralFunctions.MoveCharAndCamera(partner, 268, 272, true, 4)
	
	--todo: a little hop
	UI:WaitShowDialogue("H-hey![pause=0] What happened!?[pause=0] Are you alright!?")
	GAME:WaitFrames(80)
	
	UI:WaitShowDialogue("Oh no,[pause=10] c'mon,[pause=10] wake up!")
	GROUND:MoveInDirection(partner, Direction.Left, 4)
	--todo: move in and out twice, moving backwards where applicable
	
	--wakeup
	--todo: shake before getting up
	GAME:WaitFrames(60)
	UI:SetSpeaker(hero)
	GeneralFunctions.HeroDialogue(hero, "(...)", "Pain")
	GROUND:CharSetAnim(hero, 'Wake', false)
	GAME:WaitFrames(40)
	GROUND:CharSetAnim(hero, 'None', true)
	GAME:WaitFrames(20)
	--todo: walk backwards
	GROUND:CharSetEmote(partner, 3, 1)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim")
	GAME:WaitFrames(40)
	GROUND:MoveInDirection(partner,Direction.Right, 4)
	GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
	
	GeneralFunctions.LookAround(hero, 4, 4, true, true, false, Direction.Right)
	GAME:WaitFrames(40)
	
	--partner is relieved you arent dead
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Sigh")
	UI:WaitShowDialogue("Phew![pause=0] You weren't waking up.[pause=0] You had me scared for a moment there!")
		
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Well,[pause=10] I'm glad to see you're alright.[pause=0] My name's " .. partner:GetDisplayName() ..".")
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("How did you end up here anyway?[pause=0] Nobody is supposed to be out here.")
	
	--amnesia
	local hero_species = _DATA:GetMonster(hero.CurrentForm.Species):GetColoredName()
	local partner_species = _DATA:GetMonster(partner.CurrentForm.Species):GetColoredName()
	GAME:WaitFrames(20)
	GeneralFunctions.HeroSpeak(hero, 60)
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Huh?[pause=0] You don't know how you got here?")
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("That's worrisome...[pause=0] How would a " .. hero_species .. " end up conked out here with no memory of it?")
	
	--hero realizes they are a pokemon, pinches themselves to see if they are dreaming
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(hero, 6, 1)
	SOUND:PlayBattleSE("EVT_Emote_Confused")
	GAME:WaitFrames(40)
	GeneralFunctions.LookAround(hero, 4, 4, false, false, false, Direction.Right)
	GAME:WaitFrames(40)
	GROUND:CharSetEmote(hero, 8, 1)
	SOUND:PlayBattleSE("EVT_Emote_Shock")
	GAME:WaitFrames(40)
	GeneralFunctions.HeroDialogue(hero, "(W-what!?[pause=0] I am a " .. hero_species .. "!)", "Surprised")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(This must be a dream![pause=0] That's all![pause=0] I just need to wake myself up!)", "Surprised")
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(hero, 8, 1)
	SOUND:PlayBattleSE("DUN_Bounced")--pinch sfx
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(Yowch!)", "Pain")
	GAME:WaitFrames(40)
	GeneralFunctions.HeroDialogue(hero, "(I'm still here!?[pause=0] Then I'm not dreaming!)", "Surprised")
	SOUND:PlayBattleSE('EVT_Emote_Sweating')
	GROUND:CharSetEmote(hero, 5, 1)
	GAME:WaitFrames(40)
	GeneralFunctions.HeroDialogue(hero, "(But how did this happen?[pause=0] I can't remember anything...)", "Worried")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroSpeak(hero, 60)
	GAME:WaitFrames(20)
	
	--human? this a joke?
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(partner, 6, 1)
	SOUND:PlayBattleSE("EVT_Emote_Confused")
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Surprised")
	GAME:WaitFrames(40)
	UI:WaitShowDialogue("Huh?[pause=0] You say you're actually a human?")
	GAME:WaitFrames(20)
	--todo: a little hop
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Is this some kind of joke?[pause=0] Humans are just a legend.")
	UI:WaitShowDialogue("You're very clearly a " ..  hero_species .. ".")

	
	GROUND:CharSetEmote(hero, 3, 1)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
	GAME:WaitFrames(20)
	GeneralFunctions.ShakeHead(hero, 4, true)
	
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone].Entries[50]
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("You're pretty adamant about this,[pause=10] huh?")
	GAME:WaitFrames(20)
	
	
	--todo: have partner emote in some way while this is going on to show that they're stressed out the whole time.
	SOUND:PlayBattleSE('EVT_Emote_Sweating')
	GROUND:CharSetEmote(hero, 5, 1)
	GAME:WaitFrames(40)
	GeneralFunctions.HeroDialogue(hero, "(Is it really that hard to trust that I was a human?)", "Sad")
	GAME:WaitFrames(60)
	GeneralFunctions.HeroDialogue(hero, "(What am I going to do?)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(This " .. partner_species .. " doesn't believe me...[pause=0] Would anyone else?)", "Worried")

	--partner realizes you're scared and lost
	GAME:WaitFrames(20)
	SOUND:PlayBattleSE('EVT_Emote_Exclaim')
	GROUND:CharSetEmote(partner, 2, 1)
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("(Hmm...[pause=0] They look sincerely worried...[pause=0] Maybe they're telling the truth after all?)")
	UI:WaitShowDialogue("(There's no reason to lie about this sort of thing,[pause=10] is there?)")
	GAME:WaitFrames(40)
	
	--ok i believe you kinda 
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Hey...[pause=0] Seeing that expression on your face...")
	UI:WaitShowDialogue("I don't think you're lying after all,[pause=10] you seem genuine.")
	UI:WaitShowDialogue("Someone wouldn't just lie unconscious in a mystery dungeon claiming what you are for a prank.")
	UI:WaitShowDialogue("Even if it turns out your story isn't one-hundred percent true...")
	UI:WaitShowDialogue("I do think that you're being honest at least.[pause=0] Something weird certainly happened to you.")
	GAME:WaitFrames(20)

	--name yourself	
	UI:SetSpeakerEmotion("Worried")
	GAME:WaitFrames(40)
	UI:WaitShowDialogue("But...[pause=0] Are you sure you can't remember anything at all?[pause=0] A name perhaps?")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(...I don't think I even remember something as simple as that...)", "Sad")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(I guess I can just pick something that I'd like to be called,[pause=10] at least...)", "Normal")
	GAME:WaitFrames(20)
	UI:ResetSpeaker()
	local yesnoResult = false
	while not yesnoResult do
		UI:NameMenu("What will your name be?", "")
		UI:WaitForChoice()
		result = UI:ChoiceResult()
		GAME:SetCharacterNickname(GAME:GetPlayerPartyMember(0), result)
		UI:ChoiceMenuYesNo("Is " .. hero:GetDisplayName() .. " correct?")
		UI:WaitForChoice()
		yesnoResult = UI:ChoiceResult()
	end

	--partner makes an excuse as to why they were acting odd. the truth is they're scared of the omen
	GAME:WaitFrames(20)
	GeneralFunctions.HeroSpeak(hero, 60)
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("I see. So " .. hero:GetDisplayName() .. " is your name.")
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("I'm sorry for being so skeptical before.[pause=0] It's just hard to believe that a human could turn into a Pokémon.")
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Even if you weren't a human,[pause=10] you truly think you were one and that's good enough for me.")
	
	
	
	--will you come with me back to metano town?
	GAME:WaitFrames(20)
	GeneralFunctions.LookAround(partner, 2, 4, false, false, false, Direction.Left)
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Hmm...[pause=0] It's getting late...")
	--GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("I think you should come with me to the town where I live.")
	UI:WaitShowDialogue("You've lost your memory and turned into a Pokémon for some reason...")
	UI:WaitShowDialogue("It wouldn't be right to leave you all alone after what you've told me.")
	UI:BeginChoiceMenu("So,[pause=10] what do you say?[pause=0] Will you come back with me to the town?", {"Go with them", "Refuse"}, 1, 2)
	UI:WaitForChoice()
	local result = UI:ChoiceResult()	
	--if you say no, loop a dialogue until you say yes
	while result == 2 do 
		GAME:WaitFrames(20)
		GROUND:CharSetAnim(partner, 'Hurt', true)
		SOUND:PlayBattleSE('EVT_Emote_Startled')
		GROUND:CharSetEmote(partner, 8, 1)
		--todo: do a little hop
		GAME:WaitFrames(20)
		GROUND:CharSetAnim(partner, 'None', true)
		UI:SetSpeakerEmotion("Surprised")
		UI:WaitShowDialogue("W-what!?")
		SOUND:PlayBattleSE('EVT_Emote_Sweating')
		GROUND:CharSetEmote(partner, 5, 1)
		GAME:WaitFrames(40)
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue(hero:GetDisplayName() .. "...")
		UI:WaitShowDialogue("You've lost your memory and turned into a Pokémon...")
		UI:WaitShowDialogue("Where else would you go?[pause=0] What else would you do?")
		GAME:WaitFrames(20)
		UI:SetSpeakerEmotion("Sad")
		UI:WaitShowDialogue("I can't in good conscience leave you out here...")
		UI:BeginChoiceMenu("So please...[pause=0] Will you come back with me?", {"Go with them", "Refuse"}, 1, 2)
		UI:WaitForChoice()
		result = UI:ChoiceResult()	
	end
	
	--player agrees
	GAME:WaitFrames(40)
	GeneralFunctions.HeroDialogue(hero, "(I don't exactly have many options here...)", "Worried")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(But " .. partner:GetDisplayName() .. " seems kind enough though.[pause=0] Sticking with them for now seems like a good idea.)", "Normal")
	GAME:WaitFrames(20)
	GeneralFunctions.DoAnimation(hero, 'Nod')
	GAME:WaitFrames(20)
	
	--hooray we'll have to go thru the dungeon though
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Great![pause=0] I think you'll like Metano Town.")
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
	UI:WaitShowDialogue("I want to show you something special.")
	

	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.MoveCharAndCamera(partner, 293, 218, false, 1) end)
	GAME:WaitFrames(40)
	GROUND:MoveToPosition(hero, 270, 236, false, 1)
	GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4)
	TASK:JoinCoroutines({coro1})
	GAME:WaitFrames(20)
	
	--wow a stone tablet
	GeneralFunctions.EmoteAndPause(hero, "Question", true)
	GeneralFunctions.HeroDialogue(hero, "(Huh?[pause=0] There's a stone obelisk over here.)", "Normal")
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion('Normal')
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	UI:WaitShowDialogue("I've explored here many times,[pause=10] but this marker has always mystified me.")
	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	UI:WaitShowDialogue("If you look closely at it,[pause=10] you can there's an ancient script written on it.")
	GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4)

	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion('Normal')
	GROUND:CharAnimateTurnTo(partner, Direction.DownLeft, 4)
	UI:WaitShowDialogue("This is the only place I've ever seen letters like this!")
	UI:SetSpeakerEmotion('Worried')
	UI:WaitShowDialogue('Unfortunately,[pause=10] I have no clue what the letters or the writing means...')
	
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion('Normal')
	UI:WaitShowDialogue('But I always rub the stone for good luck when I come out here.')
	
	
	
	--touch the tablet
	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	GROUND:MoveToPosition(partner, 293, 210, false, 1)	
	GAME:WaitFrames(20)
	GROUND:CharPoseAnim(partner, 'Pose')
	GAME:WaitFrames(40)
	--todo: center the text
	UI:WaitShowMonologue(partner:GetDisplayName() .. " rubbed the ancient stone tablet.")
	GAME:WaitFrames(40)
	GROUND:CharSetAnim(partner, 'None', true)
	--todo: walk backwards
	GROUND:MoveToPosition(partner, 293, 218, false, 1)
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(partner, Direction.DownLeft, 4)
	
	--ask hero to try
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("You should rub it for luck too,[pause=10] " .. hero:GetDisplayName() .. "!")
	
	--partner moves out of way, hero tries looking and touching
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 317, 218, false, 1) end)
	GAME:WaitFrames(20)
	GROUND:MoveToPosition(hero, 293, 218, false, 1)	
	GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
	TASK:JoinCoroutines({coro1})
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	
	--sense a vague connection with the tablet

	GeneralFunctions.HeroDialogue(hero, "(" .. partner:GetDisplayName() .. "'s right.[pause=0] There is bizarre writing on the tablet.)", "Normal")
	GeneralFunctions.HeroDialogue(hero, "(I'll give it a rub for good luck too then.)", "Normal")
	GROUND:MoveToPosition(hero, 293, 210, false, 1)	
	GROUND:CharPoseAnim(hero, 'Pose')
	GAME:WaitFrames(40)
	UI:WaitShowMonologue(hero:GetDisplayName() .. " rubbed the ancient stone tablet.")
	GROUND:CharSetEmote(hero, 2, 1)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(Nothing seems out of the ordinary here,[pause=10] but...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(Something seems familiar about this tablet to me.)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(But why?[pause=0] I can't remember anything...", "Worried")
	GAME:WaitFrames(20)

	GROUND:CharSetAnim(hero, 'None', true)
	--todo: walk backwards
	GROUND:MoveToPosition(hero, 293, 218, false, 1)	
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(hero, Direction.Right, 4)
	GAME:WaitFrames(16)
	GeneralFunctions.HeroSpeak(hero, 60)

	--couldnt really learn anything meaningful from touching the tablet.
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("When you touched the obelisk,[pause=10] you felt some sort of odd connection to it?")
	GAME:WaitFrames(20)
	--UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("That's strange...[pause=0] But if you don't remember anything about it,[pause=10] we don't know if that feeling means anything.")
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("It's something to keep in mind I suppose.[pause=0] Too bad we couldn't learn anything else...")
	
	--nothing else is nearby. Let's leave.
	GeneralFunctions.LookAround(partner, 4, 4, true, false, false, Direction.Left)
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("I think it's time we headed towards town.")
	UI:WaitShowDialogue("If we stick together we should be able to make it through the mystery dungeon in one piece.")
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("Alright![pause=0] Let's get a move on!")

	--leave together, 
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 317, 298, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GeneralFunctions.WaitThenMove(hero, 293, 298, false, 1, 20) end)
	GAME:WaitFrames(40)
	GAME:FadeOut(false, 20)
	TASK:JoinCoroutines({coro1, coro2})	

	SV.Chapter1.PartnerMetHero = true
	GAME:CutsceneMode(false)

	--relic forest dungeon round 2
	GAME:EnterDungeon(50, 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, true)

end


function relic_forest.WipedInForest()

end



function relic_forest.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

return relic_forest

