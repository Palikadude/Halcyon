require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

guild_second_floor_ch_4 = {}

function guild_second_floor_ch_4.SetupGround()
	if not SV.Chapter4.FinishedGrove then
		local spheal, jigglypuff, marill, mareep, cranidos, snubbull = 
			CharacterEssentials.MakeCharactersFromList({
				{'Spheal', 'Left_Trio_2'},
				{'Jigglypuff', 'Left_Trio_3'},
				{'Marill', 'Left_Trio_1'},
				{'Mareep', 'Generic_Spawn_Duo_1'},
				{'Cranidos', 'Generic_Spawn_Duo_2'},
				{'Snubbull', 'Generic_Spawn_2'}
			})
		
		
		AI:SetCharacterAI(jigglypuff, "ai.ground_talking", true, 240, 60, 60, false, 'Default', {marill, spheal})
		AI:SetCharacterAI(marill, "ai.ground_talking", true, 240, 60, 110, false, 'Default', {jigglypuff, spheal})
		AI:SetCharacterAI(spheal, "ai.ground_talking", true, 240, 60, 10, false, 'Default', {jigglypuff, marill})

		
		AI:SetCharacterAI(mareep, "ai.ground_talking", true, 240, 60, 90, false, 'Default', {cranidos})
		
		AI:SetCharacterAI(snubbull, "ai.ground_default", RogueElements.Loc(snubbull.Position.X - 16, snubbull.Position.Y - 16), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)

	else
		local silcoon, metapod = 
			CharacterEssentials.MakeCharactersFromList({
				{'Silcoon', 'Generic_Spawn_Duo_1'},
				{'Metapod', 'Generic_Spawn_Duo_2'},
				{'Zangoose', 'Right_Duo_1'},
				{'Seviper', 'Right_Duo_2'}
				
			})
	end
	
	--let the cutscene handle the fade in if one is needed
	if SV.Chapter4.FinishedAssemblyIntro then
		GAME:FadeIn(20)
	end
end 



function guild_second_floor_ch_4.Mareep_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "This expedition is gonna be a bla-a-a-ast![pause=0] I'm full of excitement from head to tail!", "Joyous")
		UI:WaitShowDialogue("I don't know how I'm gonna wait until we leave!")
		UI:WaitShowDialogue("I've gotta release this energy out on some\nba-a-a-addies or I won't sleep tonight!")
	else
	
	end
	GeneralFunctions.EndConversation(chara)
end


function guild_second_floor_ch_4.Cranidos_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "I'm surprised the Guildmaster is allowing greenhorns like you to come along on the expedition.")
		UI:SetSpeakerEmotion("Joyous")
		GROUND:CharSetEmote(chara, "glowing", 0)
		UI:WaitShowDialogue("It must be a really easy exploration if he's letting you rookies tag along![pause=0] Hahaha!")
		GROUND:CharSetEmote(chara, "", 0)
	else
	
	end
	GeneralFunctions.EndConversation(chara)
end


function guild_second_floor_ch_4.Snubbull_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "Apricorns are finally in stock at the Kecleon Shop,[pause=10] but that dish of mine will have to wait.")
		UI:SetSpeakerEmotion("Special0")
		UI:WaitShowDialogue("With the expedition coming up now,[pause=10] my culinary expertise will need to be applied elsewhere. " .. STRINGS:Format("\\u266A"))
	else
		--N/A
	end
	GeneralFunctions.EndConversation(chara)
end



function guild_second_floor_ch_4.Jigglypuff_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "Normally,[pause=10] if one of your team members faint,[pause=10] the entire team gets ejected from the dungeon.")
		UI:WaitShowDialogue("But if that team member was recruited with Apricorns,[pause=10] the rest of the team can still continue on.")
	else
		--N/A
	end
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_4.Marill_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "You can use Apricorns to recruit more members to your adventuring team,[pause=10] but we like ours just the way it is.")
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("The three of us work great as a team,[pause=10] we don't need any more members!")
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("Besides,[pause=10] it'd be hard to find someone that shares our team's unique talents!")
	else
		--N/A
	end
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_4.Spheal_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "Everyone's talking about Apricorns,[pause=10] but who cares about those!")
		UI:WaitShowDialogue("They smell nice,[pause=10] especially the blue ones,[pause=10] but they're completely inedible![pause=0] How worthless!")
	else
		--N/A
	end
	GeneralFunctions.EndConversation(chara)
end



function guild_second_floor_ch_4.Metapod_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		--N/A
	else
		local move = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Skill]:Get("poison_sting")
		local ability = _DATA:GetIntrinsic("shield_dust"):GetColoredName()
		local silcoon_species = _DATA:GetMonster('silcoon'):GetColoredName()
		local metapod_species = _DATA:GetMonster('metapod'):GetColoredName()
		GeneralFunctions.StartConversation(chara, "Secondary effects from attacks like " .. move:GetColoredName() .. " are more common than you think.")
		UI:WaitShowDialogue("Moves that do damage and cause other effects...[pause=0] How nasty.")
		UI:WaitShowDialogue("Before we evolved,[pause=10] our " .. ability .. " ability prevented secondary effects from working on us.")
		UI:WaitShowDialogue("But now that we're a " .. metapod_species .. " and " .. silcoon_species .. ",[pause=10] our abilities are completely different.")
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue("...Between that and our current lack of mobility,[pause=10] I'm starting to regret our choice to evolve...")
	end
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_4.Silcoon_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		--N/A
	else
		local focus = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Skill]:Get("focus_energy")
		local slash = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Skill]:Get("slash")
		local leaf_blade = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Skill]:Get("leaf_blade")

		GeneralFunctions.StartConversation(chara, "Adventurers like you must know about critical hits,[pause=10] right?")
		UI:WaitShowDialogue("What I bet you don't know is that only certain kinds of moves can critical hit!")
		UI:WaitShowDialogue("Moves like " .. slash:GetColoredName() .. " and " .. leaf_blade:GetColoredName() .. " are able to land critical hits.")
		UI:WaitShowDialogue("Other attacks can land critical hits too if you've used a move like " .. focus:GetColoredName() .. ".")
		UI:WaitShowDialogue("Not many adventurers know about this![pause=0] But at least you two know about it now!")
	end
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_4.Seviper_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		--N/A
	else
		GeneralFunctions.StartConversation(chara, "Word on the sssstreet issss that the guild issss leaving on an expedition quite ssssoon.")
		UI:WaitShowDialogue("Ssssounds intriguing...[pause=0] I would love to join in,[pause=10] but I undersssstand that it issss for guild memberssss only.")
		UI:WaitShowDialogue("Besidessss...[pause=0] The expedition would be too much given I would have to haul " .. CharacterEssentials.GetCharacterName("Zangoose") .. "'ssss dead weight around.")	
	end
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_4.Zangoose_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		--N/A
	else
		GeneralFunctions.StartConversation(chara, "An expedition...[pause=0] Seems interesting,[pause=10] but our skillset isn't well suited to exploring.")
		UI:WaitShowDialogue("I would do fine,[pause=10] but " .. CharacterEssentials.GetCharacterName("Seviper") .. "?[pause=0] He'd be completely hopeless on an exploration like that.")
	end
	GeneralFunctions.EndConversation(chara)
end


function guild_second_floor_ch_4.AudinoAssemblyIntro()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local audino = CH('Assembly_Owner')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("apricorn_grove")
	
	GAME:MoveCamera(504, 208, 1, false)
	
	GROUND:Hide('Upwards_Stairs_Exit')
	
	GROUND:TeleportTo(partner, 552, 100, Direction.Left)
	GROUND:TeleportTo(hero, 552, 100, Direction.Left)
	GROUND:Hide(hero.EntName)
	GROUND:Hide("Teammate1")

	GAME:FadeIn(40)	
	GAME:WaitFrames(20)

	UI:SetSpeaker(audino)
    local coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(52)
												  GROUND:Unhide('Teammate1')
												  GAME:WaitFrames(20)
												  GROUND:MoveToPosition(partner, 524, 100, false, 1)
												  GeneralFunctions.EightWayMove(partner, 492, 132, false, 1)
												  GeneralFunctions.EightWayMove(partner, 492, 168, false, 1) 
												  GeneralFunctions.EmoteAndPause(partner, "Exclaim", false) end)
    local coro2 = TASK:BranchCoroutine(function() GROUND:Unhide(hero.EntName)
												  GAME:WaitFrames(20)
												  GROUND:MoveToPosition(hero, 524, 100, false, 1)
												  GeneralFunctions.EightWayMove(hero, 492, 132, false, 1)
												  GeneralFunctions.EightWayMove(hero, 492, 200, false, 1)
												  GeneralFunctions.EmoteAndPause(hero, "Exclaim", true) end)  
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(90)
												  GeneralFunctions.EmoteAndPause(audino, "Notice", false)
												  GROUND:CharAnimateTurnTo(audino, Direction.Left, 4)
												  GAME:WaitFrames(6)
												  GROUND:CharSetEmote(audino, "happy", 0)
												  UI:WaitShowTimedDialogue("H-hey![pause=30] " .. hero:GetDisplayName() .. "![pause=30] " .. partner:GetDisplayName() .. "!", 60) end)
	
	
	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(audino, "", 0)
	
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(hero, 580, 216, false, 1)
											GROUND:CharAnimateTurnTo(hero, Direction.Up) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:MoveToPosition(partner, 492, 200, false, 1)
											GeneralFunctions.EightWayMove(partner, 556, 216, false, 1)
											GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GeneralFunctions.FaceMovingCharacter(audino, hero, 4, Direction.Down) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(16) GAME:MoveCamera(576, 208, 72, false) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	GAME:WaitFrames(10)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("Hi,[pause=10] " .. audino:GetDisplayName() .. "![pause=0] What are you up to over here?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(audino)
	local audino_species = _DATA:GetMonster('audino'):GetColoredName()
	UI:WaitShowDialogue("W-well,[pause=10] since Apricorns aren't so rare anymore,[pause=10] I've decided to open up the " .. audino_species ..  " Assembly again!")
	GAME:WaitFrames(10)
	
	GeneralFunctions.EmoteAndPause(partner, "Question", true)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(audino_species .. " Assembly?[pause=0] What's that?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(audino)
	UI:WaitShowDialogue("It's a place where you can assemble your teammates for adventures!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Assemble my teammates?[pause=0] But...")
	
	GAME:WaitFrames(10)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	
	UI:WaitShowDialogue(hero:GetDisplayName() .. " is right here![pause=0] And we always go on adventures together anyway!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(audino)
	--too long with no nicknames
	UI:WaitShowDialogue("No no![pause=0] I m-meant recruits to your team![pause=0] Surely you've thought about adding more Pokémon to your team,[pause=10] r-right?")

	GAME:WaitFrames(10)
	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Other Pokémon?[pause=0] I hadn't really given it much thought...")
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("But,[pause=10] having other Pokémon with us could be helpful for adventures!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(audino)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Yeah![pause=0] I think so too![pause=0] The more the m-merrier after all!")
	
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Of course,[pause=10] you'll need to recruit other Pokémon first before you can bring them on adventures!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("Oh,[pause=10] right![pause=0] How would we do that?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(audino)
	UI:WaitShowDialogue("With Apricorns,[pause=10] of course!")
	UI:WaitShowDialogue("If you see a Pokémon you're interested in recruiting while out on an adventure...")
	UI:WaitShowDialogue("...Throw an Apricorn at them and they may j-join your team!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Woah![pause=0] Is it really that simple?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(audino)
	GROUND:CharSetEmote(audino, "sweating", 1)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("U-um,[pause=10] well,[pause=10] no...[pause=0] It's a bit more complicated than that...")
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("For example,[pause=10] some Apricorns are better at recruiting certain types of Pokémon!")
	UI:WaitShowDialogue("Also,[pause=10] Pokémon won't join you if they're way stronger than you![pause=0] And some Pokémon won't join no matter what!")
	UI:WaitShowDialogue("Pokémon are also more willing to join your team if they've been weakened!")
	UI:WaitShowDialogue("Of course,[pause=10] a Pokémon won't always join your team when you t-throw an Apricorn at them...")
	UI:WaitShowDialogue("But you should be able to tell how willing a Pokémon is to join you based on their reaction to the Apricorn!")
	--too long with no nicknames
	UI:WaitShowDialogue("Anyways,[pause=10] once you've r-recruited some Pokémon,[pause=10] come see me and I'll help you manage who goes on adventures!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("Wow![pause=0] Thanks,[pause=10] " .. audino:GetDisplayName() .. "![pause=0] This is all really helpful!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(audino)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("G-glad I could help![pause=0] Be sure to come see me anytime you'd like to change your team members around!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("We will![pause=0] Thank you again,[pause=10] " .. audino:GetDisplayName() .. "!")
	GAME:WaitFrames(10)
	
	--GeneralFunctions.Hop(partner)
	UI:SetSpeakerEmotion("Inspired")
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:WaitShowDialogue(hero:GetDisplayName() .. "![pause=0] Let's try to recruit as many new team members as we can!")
	UI:WaitShowDialogue("I'm sure we can find plenty of Apricorns in " .. zone:GetColoredName() .. " to help us with that!")
	
	GAME:WaitFrames(20)
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)
	partner.CollisionDisabled = true--redisable partner's collision. Something is causing this to be set to false earlier in the script...
	GeneralFunctions.PanCamera()
	GROUND:Unhide('Upwards_Stairs_Exit')
	SV.Chapter4.FinishedAssemblyIntro = true
	GAME:CutsceneMode(false)	


end  
