require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'

relic_forest_ch_1 = {}

-------------------------------
--Cutscene functions
-------------------------------
function relic_forest_ch_1.Intro_Cutscene()
	--First cutscene
	GAME:CutsceneMode(true)
	UI:ResetSpeaker()
	SOUND:FadeOutBGM()
	
	
	--initialize some save data
	_DATA.Save.ActiveTeam:SetRank("unranked")
	_DATA.Save.ActiveTeam.Money = 0
	_DATA.Save.ActiveTeam.Bank = 0
	_DATA.Save.NoSwitching = true--switching is not allowed
	
	--remove any team members that may exist by default for some reason
	local party_count = _DATA.Save.ActiveTeam.Players.Count
	for ii = 1, party_count, 1 do
		_DATA.Save.ActiveTeam.Players:RemoveAt(0)
	end

	local assembly_count = GAME:GetPlayerAssemblyCount()
	for i = 1, assembly_count, 1 do
	   _DATA.Save.ActiveTeam.Assembly.RemoveAt(i-1)--not sure if this permanently deletes or not...
	end 
	
	
	GAME:WaitFrames(60)
  	UI:WaitShowVoiceOver("Welcome to the world of Pokémon!", -1)  
  	UI:WaitShowVoiceOver("Ahead of you lies a world full of exciting adventures\n and mysteries to discover!", -1)  
	UI:WaitShowVoiceOver("Before you go, you need to make some important decisions.", -1)  
	UI:WaitShowVoiceOver("Please think carefully before choosing!", -1)  
	UI:WaitShowVoiceOver("Now, make your choices!", -1) 
	GAME:WaitFrames(40)
	
	SOUND:PlayBGM("Welcome to the World of Pokémon!.ogg", true)

	--Hero data
	--todo: improve this. Perhaps move somewhere else.
	local msg = "Your hero."
	--[[local choices = {'Bulbasaur', 'Charmander', 'Squirtle', 'Pikachu', 'Vulpix', 'Vulpix-A', 'Meowth', 'Machop', 
					 'Cubone', 'Chikorita', 'Cyndaquil', 'Totodile', 'Houndour', 'Phanpy', 'Magby',
					 'Larvitar', 'Treecko', 'Torchic', 'Mudkip', 'Poochyena', 'Ralts', 'Skitty',
					 'Turtwig', 'Chimchar', 'Piplup', 'Shinx', 'Buizel', 'Munchlax', 'Riolu',
					 'Snivy', 'Oshawatt', 'Lilliup', 'Zorua', 'Minccino', 'Vanillite', 'Mienfoo',
					 'Chespin', 'Fennekin', 'Froakie', 'Skiddo', 'Espurr', 'Amaura', 'Noibat',
					 'Rowlet', 'Litten', 'Rockruff', 'Fomantis', 'Scorbunny', 'Wooloo', 'Yamper'}
		]]--			
	local choices = {RogueEssence.Dungeon.MonsterID("bulbasaur", 0, "normal", Gender.Genderless),
					RogueEssence.Dungeon.MonsterID("charmander", 0, "normal", Gender.Genderless),
					RogueEssence.Dungeon.MonsterID("squirtle", 0, "normal", Gender.Genderless),
					RogueEssence.Dungeon.MonsterID("pikachu", 0, "normal", Gender.Genderless),
					RogueEssence.Dungeon.MonsterID("vulpix", 0, "normal", Gender.Genderless),
					RogueEssence.Dungeon.MonsterID("vulpix", 1, "normal", Gender.Genderless),
					RogueEssence.Dungeon.MonsterID("meowth", 0, "normal", Gender.Genderless),
					RogueEssence.Dungeon.MonsterID("machop", 0, "normal", Gender.Genderless),
					RogueEssence.Dungeon.MonsterID("cubone", 0, "normal", Gender.Genderless),
					RogueEssence.Dungeon.MonsterID("eevee", 0, "normal", Gender.Genderless),
					RogueEssence.Dungeon.MonsterID("chikorita", 0, "normal", Gender.Genderless),
					RogueEssence.Dungeon.MonsterID("cyndaquil", 0, "normal", Gender.Genderless),
					RogueEssence.Dungeon.MonsterID("totodile", 0, "normal", Gender.Genderless),
					--RogueEssence.Dungeon.MonsterID("houndour", 0, "normal", Gender.Genderless),
					RogueEssence.Dungeon.MonsterID("phanpy", 0, "normal", Gender.Genderless),
					--RogueEssence.Dungeon.MonsterID("magby", 0, "normal", Gender.Genderless),
					--RogueEssence.Dungeon.MonsterID("larvitar", 0, "normal", Gender.Genderless),
					RogueEssence.Dungeon.MonsterID("treecko", 0, "normal", Gender.Genderless),
					RogueEssence.Dungeon.MonsterID("torchic", 0, "normal", Gender.Genderless),
					RogueEssence.Dungeon.MonsterID("mudkip", 0, "normal", Gender.Genderless),
					--RogueEssence.Dungeon.MonsterID("poochyena", 0, "normal", Gender.Genderless),
					--RogueEssence.Dungeon.MonsterID("ralts", 0, "normal", Gender.Genderless),
					RogueEssence.Dungeon.MonsterID("skitty", 0, "normal", Gender.Genderless),
					RogueEssence.Dungeon.MonsterID("turtwig", 0, "normal", Gender.Genderless),
					RogueEssence.Dungeon.MonsterID("chimchar", 0, "normal", Gender.Genderless),
					RogueEssence.Dungeon.MonsterID("piplup", 0, "normal", Gender.Genderless),
					RogueEssence.Dungeon.MonsterID("shinx", 0, "normal", Gender.Genderless),
					--RogueEssence.Dungeon.MonsterID("buizel", 0, "normal", Gender.Genderless),
					RogueEssence.Dungeon.MonsterID("munchlax", 0, "normal", Gender.Genderless),
					RogueEssence.Dungeon.MonsterID("riolu", 0, "normal", Gender.Genderless),
					RogueEssence.Dungeon.MonsterID("snivy", 0, "normal", Gender.Genderless),
					RogueEssence.Dungeon.MonsterID("oshawott", 0, "normal", Gender.Genderless),
					--RogueEssence.Dungeon.MonsterID("lillipup", 0, "normal", Gender.Genderless),
					RogueEssence.Dungeon.MonsterID("zorua", 0, "normal", Gender.Genderless),
					--RogueEssence.Dungeon.MonsterID("minccino", 0, "normal", Gender.Genderless),
					--RogueEssence.Dungeon.MonsterID("vanillite", 0, "normal", Gender.Genderless),
					--RogueEssence.Dungeon.MonsterID("mienfoo", 0, "normal", Gender.Genderless),
					RogueEssence.Dungeon.MonsterID("chespin", 0, "normal", Gender.Genderless),
					RogueEssence.Dungeon.MonsterID("fennekin", 0, "normal", Gender.Genderless),
					RogueEssence.Dungeon.MonsterID("froakie", 0, "normal", Gender.Genderless),
					RogueEssence.Dungeon.MonsterID("skiddo", 0, "normal", Gender.Genderless),
					--RogueEssence.Dungeon.MonsterID("espurr", 0, "normal", Gender.Genderless),
					--RogueEssence.Dungeon.MonsterID("amaura", 0, "normal", Gender.Genderless),
					--RogueEssence.Dungeon.MonsterID("noibat", 0, "normal", Gender.Genderless),
					RogueEssence.Dungeon.MonsterID("rowlet", 0, "normal", Gender.Genderless),
					RogueEssence.Dungeon.MonsterID("litten", 0, "normal", Gender.Genderless),
					RogueEssence.Dungeon.MonsterID("rockruff", 0, "normal", Gender.Genderless),
					--RogueEssence.Dungeon.MonsterID("fomantis", 0, "normal", Gender.Genderless),
					RogueEssence.Dungeon.MonsterID("scorbunny", 0, "normal", Gender.Genderless),
					--RogueEssence.Dungeon.MonsterID("wooloo", 0, "normal", Gender.Genderless),
					RogueEssence.Dungeon.MonsterID("yamper", 0, "normal", Gender.Genderless)}
					
	--not all moves listed are egg moves. Sometimes, egg move choices are too over or under powered and so something else had to be chosen				
	local egg_move_list = 
		{["bulbasaur"] = "sludge", --Sludge bulbasaur
		 ["charmander"] = "metal_claw", --metal claw, charmander 
		 ["squirtle"] = "icy_wind", --icy wind, squirtle		
		 ["pikachu"] = "disarming_voice", --disarming voice, pikachu
		 ["vulpix"] = "tail_slap", --tail slap, vulpix and vulpix-a
		 ["meowth"] = "foul_play", --foul play, meowth
		 ["machop"] = "bullet_punch", --bullet punch, machop
		 ["cubone"] = "double_kick", --double kick, cubone 
		 ["eevee"] = "double_kick", --double kick, eevee 
		 ["chikorita"] = "refresh", --refresh, chikorita
		 ["cyndaquil"] = "double_kick", --double kick, cyndaquil 
		 ["totodile"] = "aqua_jet", --aqua jet, totodile
		-- ["houndour"] = "thunder_fang", --thunder fang, houndour
		 ["phanpy"] = "ice_shard", --ice shard, phanpy
		-- ["magby"] = "thunder_punch", --thunder punch, magby
		 --["larvitar"] = "iron_head", --ironhead, larvitar
		 ["treecko"] = "dragon_breath",--dragon breath, treecko
		 ["torchic"] = "low_kick",--low kick, torchic
		 ["mudkip"] = "avalanche", --avalanche, mudkip
		 --["poochyena"] = "play_rough", --play rough, poochyena
		 --["ralts"] = "shadow_sneak", --shadow sneak, ralts
		 ["skitty"] = "zen_headbutt", --zen headbutt, skitty 
		 ["turtwig"] = "sand_tomb", --sand tomb, turtwig
		 ["chimchar"] = "thunder_punch", --thunder punch, chimchar
		 ["piplup"] = "icy_wind", --icy wind, piplup
		 ["shinx"] = "ice_fang", --icy fang, shinx 
		 --["buizel"] = "fury_cutter", --fury cutter, buizel 
		 ["munchlax"] = "zen_headbutt", --zen headbutt, munchlax
		 ["riolu"] = "bullet_punch", --bullet punch, riolu
		 ["snivy"] = "twister", --twister, snivy 
		 ["oshawott"] = "assurance", --assurance, oshawatt
		 --["lillipup"] = "fire_fang", --fire fang, lillipup
		 ["zorua"] = "copycat", --copycat, zorua 
		 --["minccino"] = "aqua_tail", --aqua tail, minccino
		 --["vanillite"] = "water_pulse", --water pulse, vanillite 
		 --["mienfoo"] = "knock_off", --knock off, mienfoo
		 ["chespin"] = "power_up_punch", --power up punch, chespin
		 ["fennekin"] = "wish", --wish, fennekin
		 ["froakie"] = "mud_sport", --mud sport froakie 
		 ["skiddo"] = "zen_headbutt", --zen headbutt, Skiddo
		 --["espurr"] = "assist", --assist, espurr (also bad egg moves)
		 --["amaura"] = "mirror_shot", --mirror coat, amaura (discharge is an absurdly busted option i could give it though)
		 --["noibat"] = "tailwind", --tailwind, noibat
		 ["rowlet"] = "confuse_ray", --Confuse Ray, rowlet
		 ["litten"] = "revenge", --revenge, litten 
		 ["rockruff"] = "thunder_fang", --thunder fang, rockruff
		 --["fomantis"] = "weather_ball", --weather ball, fomantis
		 ["scorbunny"] = "assurance", --assurance, scorbunny
		 --["wooloo"] = "counter", --counter, wooloo
		 ["yamper"] = "flame_charge"} --flame charge, yamper
		 
	
	local continue = false 
	local hero_choice = -1
	
	while not continue do
		UI:ChooseMonsterMenu(msg, choices)
		UI:WaitForChoice()	
		local result = UI:ChoiceResult()
		hero_choice = result
		UI:ChoiceMenuYesNo("Is " .. _DATA:GetMonster(hero_choice.Species):GetColoredName() .. " correct?")
		UI:WaitForChoice()
		continue = UI:ChoiceResult()
	end
		

	
	local gender = 0
	local gender_choices = {'Boy', 'Girl', "Non-Binary"}
	UI:BeginChoiceMenu("Are you a boy, girl, or non-binary?", gender_choices, 1, 1)
	UI:WaitForChoice()
	gender = UI:ChoiceResult()
	
	if gender == 1 then
		gender = Gender.Male
	elseif gender == 2 then
		gender = Gender.Female
	else --dunno if this will cause issues with sprites to use
		gender = Gender.Genderless
	end
	
	local monster = _DATA:GetMonster(hero_choice.Species).Forms[hero_choice.Form]
	local ability = monster.Intrinsic1
	if monster.Intrinsic2 ~= "none" then--if pokemon has 2 abilities, let player choose which to get
		UI:BeginChoiceMenu("Which ability would you like to have?", {_DATA:GetIntrinsic(monster.Intrinsic1):GetColoredName(), _DATA:GetIntrinsic(monster.Intrinsic2):GetColoredName()}, 1, 1)
		UI:WaitForChoice()
		local result = UI:ChoiceResult()
		if result == 2 then ability = monster.Intrinsic2 end
	end
	

	
	
	--create hero with a species specific egg move and specific ability
	local mon_id = hero_choice
	mon_id.Gender = gender
	_DATA.Save.ActiveTeam.Players:Add(_DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 5, ability, 0))
	if GAME:GetCharacterSkill(GAME:GetPlayerPartyMember(0), 3) ~= "" then 
		GAME:SetCharacterSkill(GAME:GetPlayerPartyMember(0), egg_move_list[mon_id.Species], 3)--override move in slot 4 if 4 moves are known. They can always go see slowpoke to get it back
	else 
		GAME:LearnSkill(GAME:GetPlayerPartyMember(0), egg_move_list[mon_id.Species])
	end
	GAME:SetTeamLeaderIndex(0)
	
		while not continue do
		UI:ChooseMonsterMenu(msg, choices)
		UI:WaitForChoice()	
		local result = UI:ChoiceResult()
		local hero_choice = result
		UI:ChoiceMenuYesNo("Is " .. _Data.GetMonster(hero_choice.Species):GetColoredName() .. " correct?")
		UI:WaitForChoice()
		continue = UI:ChoiceResult()
	end

	--Partner data
	result = hero_choice
	continue = false
	local type_warning = true
	local partner_choice = 0
	local hero_type = nil
	local partner_type = nil
	
	while result.Species == hero_choice.Species or not continue do --do not allow same species for partner and player
		UI:ChooseMonsterMenu("Your partner.", choices)
		type_warning = true
		UI:WaitForChoice()
		result = UI:ChoiceResult()
		partner_choice = result
		if result.Species == hero_choice.Species then
			UI:WaitShowDialogue("Player and partner may not be the same species.[pause=0] Please choose again.")
		else
			hero_type = _DATA:GetMonster(hero_choice.Species).Forms[hero_choice.Form].Element1
			partner_type = _DATA:GetMonster(partner_choice.Species).Forms[partner_choice.Form].Element1
			if hero_type == partner_type then --warn player if types match
				UI:WaitShowDialogue("Warning![pause=0] Your hero and partner choices share the same primary type.")
				UI:WaitShowDialogue("This may make your adventure more difficult than normal.")
				UI:ChoiceMenuYesNo("Are you sure you wish to continue with these choices?")
				UI:WaitForChoice()
				type_warning = UI:ChoiceResult()
			end
			if type_warning then--if they agreed to continue after the warning, or never got the warning, then make sure their choice is correct
				UI:ChoiceMenuYesNo("Is " .. _DATA:GetMonster(partner_choice.Species):GetColoredName() .. " correct?")
				UI:WaitForChoice()
				continue = UI:ChoiceResult()
			end
		end	
	end 
	
	UI:BeginChoiceMenu("Your partner, are they a boy, girl, or non-binary?", gender_choices, 1, 1)
	UI:WaitForChoice()
	gender = UI:ChoiceResult()
	
	if gender == 1 then
		gender = Gender.Male
	elseif gender == 2 then
		gender = Gender.Female
	else --dunno if this will cause issues with sprites to use
		gender = Gender.Genderless
	end

	local monster = _DATA:GetMonster(partner_choice.Species).Forms[partner_choice.Form]
	local ability = monster.Intrinsic1
	if monster.Intrinsic2 ~= "none" then--if pokemon has 2 abilities, let player choose which to get
		UI:BeginChoiceMenu("Which ability would you like your partner to have?", {_DATA:GetIntrinsic(monster.Intrinsic1):GetColoredName(), _DATA:GetIntrinsic(monster.Intrinsic2):GetColoredName()}, 1, 1)
		UI:WaitForChoice()
		result = UI:ChoiceResult()
		if result == 2 then ability = monster.Intrinsic2 end
	end
	
	mon_id = partner_choice
	mon_id.Gender = gender
	_DATA.Save.ActiveTeam.Players:Add(_DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 5, ability, 0))--dunno what the -1 and 0 are exactly...
	if GAME:GetCharacterSkill(GAME:GetPlayerPartyMember(1), 3) ~= "" then 
		GAME:SetCharacterSkill(GAME:GetPlayerPartyMember(1), egg_move_list[mon_id.Species], 3)--override move in slot 4 if 4 moves are known. They can always go see slowpoke to get it back
	else 
		GAME:LearnSkill(GAME:GetPlayerPartyMember(1), egg_move_list[mon_id.Species])
	end
	--set player and partner to founders so they cannot be released
	--set them as partner so they cannot be taken off the active team
    _DATA.Save:UpdateTeamProfile(true)
    _DATA.Save.ActiveTeam.Players[0].IsFounder = true
	_DATA.Save.ActiveTeam.Players[0].IsPartner = true

	_DATA.Save.ActiveTeam.Players[1].IsFounder = true
	_DATA.Save.ActiveTeam.Players[1].IsPartner = true

	--give the duo a small perma stat bonus
	--_DATA.Save.ActiveTeam.Players[0].MaxHPBonus = 1
	--_DATA.Save.ActiveTeam.Players[0].AtkBonus = 1
	--_DATA.Save.ActiveTeam.Players[0].DefBonus = 1
	--_DATA.Save.ActiveTeam.Players[0].MAtkBonus = 1
	--_DATA.Save.ActiveTeam.Players[0].MDefBonus = 1

	--_DATA.Save.ActiveTeam.Players[1].MaxHPBonus = 1
	--_DATA.Save.ActiveTeam.Players[1].AtkBonus = 1
	--_DATA.Save.ActiveTeam.Players[1].DefBonus = 1
	--_DATA.Save.ActiveTeam.Players[1].MAtkBonus = 1
	--_DATA.Save.ActiveTeam.Players[1].MDefBonus = 1
	--_DATA.Save.ActiveTeam.Players[1].SpeedBonus = 1
	
	_DATA.Save.ActiveTeam.Players[0]:FullRestore()--set hp/pp to full for player and partner
	_DATA.Save.ActiveTeam.Players[1]:FullRestore()
	
	
	--assign dungeon AIs
	--TODO: make the partner one more unique/original/detailed, basically just copying audino's for now
	local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("HeroInteract")
	_DATA.Save.ActiveTeam.Players[0].ActionEvents:Add(talk_evt)
	
	talk_evt = RogueEssence.Dungeon.BattleScriptEvent("PartnerInteract")
	_DATA.Save.ActiveTeam.Players[1].ActionEvents:Add(talk_evt)

  
	local yesnoResult = false 
	while not yesnoResult do
		UI:NameMenu("What is your partner's name?", "It is highly recommended to give a nickname.", 60)
		UI:WaitForChoice()
		result = UI:ChoiceResult()
		--if no name given, set name to species name
		if result == "" then result = _DATA:GetMonster(GAME:GetPlayerPartyMember(1).CurrentForm.Species).Name:ToLocal() end
		UI:ChoiceMenuYesNo("Is [color=#FFFF00]" .. result .. "[color] correct?")
		UI:WaitForChoice()
		yesnoResult = UI:ChoiceResult()
	end

	
	local partner = GAME:GetPlayerPartyMember(1)

	
	GAME:SetCharacterNickname(partner, result)
	GAME:SetTeamName(result) --set team name to partner's name temporarily
	COMMON.RespawnAllies()
	
	GAME:WaitFrames(60)
  
    local hero = CH('PLAYER')
	local marker = MRKR("WakeupLocation")
	GROUND:CharSetAnim(hero, 'Laying', true)
	GROUND:TeleportTo(hero, marker.Position.X, marker.Position.Y, Direction.Right)
	
	--assign custom variables to the hero and partner to mark them as hero and partner
	local hTbl = LTBL(hero)
	local pTbl = LTBL(partner)
	hTbl.Importance = 'Hero'
	pTbl.Importance = 'Partner'
	
	--for beta testing only: skip to another chapter?
	UI:ChoiceMenuYesNo("Would you like to skip to Chapter 2?", true)
	UI:WaitForChoice()
	yesnoResult = UI:ChoiceResult()
	if yesnoResult then 
		 yesnoResult = false
		while not yesnoResult do
			UI:NameMenu("What will your name be?", "", 60)
			UI:WaitForChoice()
			result = UI:ChoiceResult()
			GAME:SetCharacterNickname(GAME:GetPlayerPartyMember(0), result)
			UI:ChoiceMenuYesNo("Is " .. hero:GetDisplayName() .. " correct?")
			UI:WaitForChoice()
			yesnoResult = UI:ChoiceResult()
		end
		
		yesnoResult = false
		while not yesnoResult do
			UI:NameMenu("What will your team's name be?", "You don't need to put 'Team' in the name itself.", 60)
			UI:WaitForChoice()
			result = UI:ChoiceResult()
			GAME:SetTeamName(result)
			UI:ChoiceMenuYesNo("Is Team " .. GAME:GetTeamName() .. " correct?", true)
			UI:WaitForChoice()
			yesnoResult = UI:ChoiceResult()
		end
		--set chapter 1 flags to true, note that you can skip talking to guild NPCs but this will mark them as met already
		SV.Chapter1 = 
			{
				PlayedIntroCutscene = true,
				PartnerEnteredForest = true,--Did partner go into the forest yet?
				PartnerCompletedForest = true,--Did partner complete solo run of first dungeon?
				PartnerMetHero = true,--Finished partner meeting hero cutscene in the relic forest?
				TeamCompletedForest = true, --completed backtrack to town?
				TeamJoinedGuild = true,--team officially joined guild? this flag lets you walk around guild without triggering cutscenes to talk to different guildmates

				--these flags mark whether you've talked to your new guild buddies yet. Need to talk to them all to go to sleep and end the chapter.
				MetSnubbull = true,--talked to snubbull?
				MetZigzagoon = true,
				MetCranidosMareep = true,
				MetBreloomGirafarig = true,
				MetAudino = true,
				
				--partner dialogue flag on second floor
				PartnerSecondFloorDialogue = 0
			}
		SV.ChapterProgression.Chapter = 2
		GAME:GivePlayerItem("synergy_scarf", 2)--give 2 vibrant scarves
		_DATA.Save.ActiveTeam:SetRank("normal")
		GAME:CutsceneMode(false)
		SOUND:FadeOutBGM(120)
		GAME:WaitFrames(120)
		GAME:EnterGroundMap("guild_heros_room", "Main_Entrance_Marker")
		return
	end
	
	SOUND:FadeOutBGM(120)
	GAME:WaitFrames(120)
	
	GROUND:Hide('Teammate1')--hide partner
	
	
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
	UI:WaitShowDialogue("...[pause=0] No...[pause=0] Can't stay awake...")
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
	UI:WaitShowDialogue("I'll never understand why [color=#00FFFF]Erleuchtet[color] thinks the forest is so dangerous.")
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
	--todo: shake before getting up
	GAME:WaitFrames(60)
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
	UI:WaitShowDialogue("That's worrisome...[pause=0] How would a " .. hero_species .. " end up conked out here with no memory of it?")
	
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
	GeneralFunctions.HeroDialogue(hero, "(Wh-what!?[pause=0] I am a " .. hero_species .. "!)", "Surprised")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(This must be a dream![pause=0] There's no way I really turned into a " .. hero_species .. "!)", "Surprised")
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
	GeneralFunctions.HeroDialogue(hero, "(I can't believe this...[pause=0] I'm really a " .. hero_species .. "...)", "Worried")--at some point, should comment on how being a Pokémon is actually sick, just initially shocked and overwhelmed which is why they reacted like this
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
	UI:WaitShowDialogue("Huh?[pause=0] You say you're actually a human?")
	GAME:WaitFrames(20)
	--todo: a little hop
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
	UI:WaitShowDialogue("But um...[pause=0] It's getting late...")
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
	GeneralFunctions.HeroDialogue(hero, "(But " .. partner:GetDisplayName() .. " seems kind though.[pause=0] Sticking with " ..  GeneralFunctions.GetPronoun(partner, 'them') .. " for now seems like a good idea.)", "Normal")
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
	GROUND:CharPoseAnim(partner, 'Pose')
	GAME:WaitFrames(40)

	GeneralFunctions.Monologue(partner:GetDisplayName() .. " rubbed the ancient stone tablet.")
	UI:SetSpeaker(partner)
	GAME:WaitFrames(40)
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:AnimateToPosition(partner, "Walk", Direction.Up, 293, 218, 1, 1)
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(partner, Direction.DownLeft, 4)
	
	--ask hero to try
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("You should rub it for luck too,[pause=10] " .. hero:GetDisplayName() .. "!")
	
	--partner moves out of way, hero tries looking and touching
	coro1 = TASK:BranchCoroutine(function() GROUND:AnimateToPosition(partner, "Walk", Direction.Left, 317, 218, 1, 1) end)
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
	GROUND:CharPoseAnim(hero, 'Pose')
	
	GAME:WaitFrames(40)
	GeneralFunctions.Monologue(hero:GetDisplayName() .. " rubbed the ancient stone tablet.")
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(hero, "notice", 1)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(Nothing seems out of the ordinary here,[pause=10] but...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(Something about this tablet feels...[pause=30] strange to me.)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(But why?[pause=0] There doesn't seem to be anything outstanding about this tablet...)", "Worried")
	GAME:WaitFrames(20)

	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:AnimateToPosition(hero, "Walk", Direction.Up, 293, 218, 1, 1)
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(hero, Direction.Right, 4)
	GAME:WaitFrames(16)
	GeneralFunctions.HeroSpeak(hero, 60)

	--couldnt really learn anything meaningful from touching the tablet.
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("When you touched the tablet,[pause=10] you had some sort of strange feeling?")
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
	GAME:EnterDungeon("relic_forest", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, true)

end

--the duo wiped trying to make it back to town
function relic_forest_ch_1.WipedInForest()
	--reset party
	--GeneralFunctions.DefaultParty(true, false)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	GAME:MoveCamera(294, 520, 1, false)
	GROUND:TeleportTo(hero, 276, 512, Direction.Down)
	GROUND:TeleportTo(partner, 308, 512, Direction.Down)
	GROUND:CharSetAnim(partner, 'EventSleep', true)
	GROUND:CharSetAnim(hero, 'EventSleep', true)

	GAME:FadeIn(40)
	
	GAME:WaitFrames(120)
	local coro1 = TASK:BranchCoroutine(function () GeneralFunctions.DoAnimation(hero, 'Wake') end)
	local coro2 = TASK:BranchCoroutine(function () GeneralFunctions.DoAnimation(partner, 'Wake') end)
	TASK:JoinCoroutines({coro1, coro2})
	
	coro1 = TASK:BranchCoroutine(function () GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) end)
	coro2 = TASK:BranchCoroutine(function () GROUND:CharAnimateTurnTo(partner, Direction.Down, 4) end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(20)
	
	coro1 = TASK:BranchCoroutine(function () GeneralFunctions.LookAround(hero, 2, 4, false, false, false, Direction.Right) end)
	coro2 = TASK:BranchCoroutine(function () GAME:WaitFrames(10) GeneralFunctions.LookAround(partner, 2, 4, false, false, false, Direction.Left) end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(20)
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
	UI:WaitShowDialogue("Let's give it another shot,[pause=10] " .. hero:GetDisplayName() .. "!")
	--todo: do a little hop at the end of the dialogue
	GAME:WaitFrames(20)

	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 308, 612, false, 1) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.WaitThenMove(hero, 276, 612, false, 1, 20) end)
	GAME:WaitFrames(60)
	SOUND:FadeOutBGM()
	GAME:FadeOut(false, 40)
	TASK:JoinCoroutines({coro1, coro2})	
	
	GAME:CutsceneMode(false)

	--relic forest dungeon round 2
	GAME:EnterDungeon("relic_forest", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, true)
end
