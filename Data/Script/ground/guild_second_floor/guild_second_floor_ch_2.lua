require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

guild_second_floor_ch_2 = {}



function guild_second_floor_ch_2.SetupGround()
	
	if not SV.Chapter2.FinishedTraining then 
		--day 1: before training 
		
		local zangoose, seviper = 
			CharacterEssentials.MakeCharactersFromList({
				{'Zangoose', 'Right_Duo_1'},
				{'Seviper', 'Right_Duo_2'},
				{'Zigzagoon', 'Left_Solo'}
			})
			
		GROUND:CharSetAnim(zangoose, 'Idle', true)
		GROUND:CharSetAnim(seviper, 'Idle', true)


		AI:SetCharacterAI(zangoose, "ai.ground_talking", false, 240, 60, 210, false, 'Angry', {seviper})
		AI:SetCharacterAI(seviper, "ai.ground_talking", false, 240, 180, 110, false, 'Angry', {zangoose})

	elseif SV.Chapter2.FinishedNumelTantrum and not SV.Chapter2.FinishedFirstDay then 
		--day 1: after training
		local bagon, doduo, audino = 
			CharacterEssentials.MakeCharactersFromList({
				{'Doduo', 'Left_Duo_1'},
				{'Bagon', 'Left_Duo_2'},
				{'Audino', 'Generic_Spawn_6'}
			})

		AI:SetCharacterAI(bagon, "ai.ground_talking", false, 240, 60, 210, true, 'Default', {doduo})
		AI:SetCharacterAI(doduo, "ai.ground_talking", false, 240, 180, 110, true, 'Default', {bagon})
		
		AI:SetCharacterAI(audino, "ai.ground_default", RogueElements.Loc(432, 288), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)

	elseif SV.Chapter2.FinishedFirstDay then 
	--day 2 after getting the first job but before wiping in the dungeon
	
		local cleffa, aggron = 
			CharacterEssentials.MakeCharactersFromList({
				{'Cleffa', 'Right_Duo_1'},
				{'Aggron', 'Right_Duo_2'}
			})
		
		AI:SetCharacterAI(cleffa, "ai.ground_talking", true, 240, 60, 210, false, 'Angry', {aggron})
		AI:SetCharacterAI(aggron, "ai.ground_talking", false, 240, 120, 110, false, 'Scared', {cleffa})
	
	--(noctowl and camerupt would be moved to upstairs and her house respectively if you wipe)
		if SV.Chapter2.FinishedCameruptRequestScene and not SV.Chapter2.EnteredRiver then 
			local noctowl, camerupt = 
			CharacterEssentials.MakeCharactersFromList({
				{'Noctowl', 80, 224, Direction.Down},
				{'Camerupt', 112, 224, Direction.Down}
			})
		end
		

	end
	
	GAME:FadeIn(20)
	
end

function guild_second_floor_ch_2.CameruptRequestCutscene()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("illuminant_riverbed")
	
	GAME:MoveCamera(160, 224, 1, false)
	
	local noctowl, cleffa, aggron = 
		CharacterEssentials.MakeCharactersFromList({
			{'Noctowl', 340, 280, Direction.Left},
			{'Cleffa', 'Right_Duo_1'},
			{'Aggron', 'Right_Duo_2'}
		})
	
	--set up cleffa and aggron like we do in setup ground so that they act properly after the cutscene and without leaving and coming back to refresh the
	AI:SetCharacterAI(cleffa, "ai.ground_talking", true, 240, 60, 210, false, 'Angry', {aggron})
	AI:SetCharacterAI(aggron, "ai.ground_talking", false, 240, 120, 110, false, 'Scared', {cleffa})
		
	GROUND:TeleportTo(partner, 340, 280, Direction.Left)
	GROUND:TeleportTo(hero, 340, 280, Direction.Left)
	SOUND:StopBGM()
	
	GAME:FadeIn(40)
	SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true)
	
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(noctowl, 192, 280, false, 1)
												  GROUND:MoveToPosition(noctowl, 136, 224, false, 1)
												  GROUND:MoveToPosition(noctowl, 80, 224, false, 1)
												  GeneralFunctions.FaceMovingCharacter(noctowl, partner, 4, Direction.Down) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(32)
												  GROUND:MoveToPosition(partner, 152, 280, false, 1)
												  GROUND:MoveToPosition(partner, 128, 256, false, 1)
												  GROUND:MoveToPosition(partner, 88, 256, false, 1)
												  GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) end)	
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(64)
												  GROUND:MoveToPosition(hero, 152, 280, false, 1)
												  GROUND:MoveToPosition(hero, 128, 256, false, 1)
												  GROUND:MoveToPosition(hero, 120, 256, false, 1)
  												  GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(236)
												  GAME:MoveCamera(112, 224, 48, false) end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	--local scarf_name = RogueEssence.Dungeon.InvItem("held_synergy_scarf"):GetDisplayName()
	--have to hardcode this so I can have it say scarves instead of scarf
	local scarf_name = STRINGS:Format('\\uE0AE')..'[color=#FFCEFF]Synergy Scarves[color]'
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("This here is the Job Bulletin Board.[pause=0] Requests from Pokémon from all over are posted here daily.")
	UI:WaitShowDialogue("These requests can include tasks such as rescuing,[pause=10] client escort,[pause=10] and item retrieval.")
	UI:WaitShowDialogue("You should know that almost all Job Bulletin Board tasks take place within mystery dungeons.")
	UI:WaitShowDialogue("In case you are unaware,[pause=10] mystery dungeons are special places that change each time you enter.")
	UI:WaitShowDialogue("The layout,[pause=10] items you find,[pause=10] and opponents you face differ each time you explore.")
	UI:WaitShowDialogue("They truly are wonderous locations to adventure in.[pause=0] But as fantastical as they are,[pause=10] they are also dangerous.")
	UI:WaitShowDialogue("Should either one of you be defeated in a dungeon,[pause=10] you will both be expelled from the dungeon.")
	UI:WaitShowDialogue("Furthermore,[pause=10] you will lose most of the money you are carrying and most items in your Treasure Bag.")
	UI:WaitShowDialogue("Some items,[pause=10] such as the " .. scarf_name .. " the Guildmaster gave you, are special and cannot be lost.")
	UI:WaitShowDialogue("Items you have equipped also cannot be lost,[pause=10] fortunately.")
	UI:WaitShowDialogue("Be sure to visit the proper facilities in town to safeguard any possessions you cannot bear to lose.")
	UI:WaitShowDialogue("Is that all clear to you?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	GROUND:CharSetEmote(partner, "sweating", 1)
	UI:WaitShowDialogue("Well,[pause=10] that is a lot to take in...")
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("But I'm sure we'll manage to remember all of that!")
	
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("Very good.[pause=0] Now,[pause=10] for your task today,[pause=10] I shall choose a job from the board for you to undertake.")
	UI:WaitShowDialogue("Since you are just beginners,[pause=10] let's select a simple task from the board.")
	GAME:WaitFrames(20)
	
	GROUND:CharAnimateTurnTo(noctowl, Direction.Up, 4)
	GROUND:CharSetAnim(noctowl, "Idle", true)
	UI:WaitShowDialogue("Let's see here...")
	
	--camerupt comes in in a panic
	GAME:WaitFrames(40)
	SOUND:FadeOutBGM(120)
	local camerupt = 
		CharacterEssentials.MakeCharactersFromList({
			{'Camerupt', 248, 208, Direction.Down}
		})	
	
	GAME:WaitFrames(40)
	GeneralFunctions.LookAround(camerupt, 3, 4, false, false, true, Direction.DownLeft)
	GeneralFunctions.EmoteAndPause(camerupt, "Exclaim", true)
	
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(camerupt, 112, 224, true, 2) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(32) 
											--SOUND:PlayBattleSE('EVT_Emote_Exclaim_2')
											GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4)
											GROUND:CharSetEmote(partner, "exclaim", 1) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(40) 
											GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4)
											GROUND:CharSetEmote(hero, "exclaim", 1) end)

	TASK:JoinCoroutines({coro1, coro2, coro3})
	GROUND:EntTurn(hero, Direction.Up)
	GROUND:EntTurn(partner, Direction.Up)
	
	UI:SetSpeaker(camerupt)
	UI:SetSpeakerEmotion("Teary-Eyed")
	UI:WaitShowDialogue("Excuse me,[pause=10] you work for the guild,[pause=10] right?[pause=0] You're that " .. noctowl:GetDisplayName() .. " fellow,[pause=10] aren't you?")
	
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(noctowl, "Notice", true)
	GROUND:CharEndAnim(noctowl)
	UI:SetSpeaker(noctowl)
	UI:SetSpeakerEmotion("Normal")
	GROUND:CharTurnToCharAnimated(noctowl, camerupt, 4)
	UI:WaitShowDialogue("Oh,[pause=10] apologies.[pause=0] I did not notice you there at first.")
	UI:WaitShowDialogue("Yes,[pause=10] I am " .. noctowl:GetDisplayName() .. ".[pause=0] What business do you have with the guild?") 
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(camerupt)
	UI:SetSpeakerEmotion("Teary-Eyed")
	UI:WaitShowDialogue("I need help![pause=0] " .. CharacterEssentials.GetCharacterName("Numel") .. ",[pause=10] my precious baby boy...[pause=0] He's gone missing!")
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(noctowl, "exclaim", 1)
	GROUND:CharSetEmote(partner, "shock", 1)
	SOUND:PlayBattleSE('EVT_Emote_Shock_2')
	GAME:WaitFrames(6)
	GROUND:CharSetEmote(hero, "shock", 1)
	GAME:WaitFrames(20)
	
	SOUND:PlayBGM('Growing Anxiety.ogg', false)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("Your son has gone missing?[pause=0] Are you sure?")
	
	GAME:WaitFrames(10)
	GeneralFunctions.Hop(camerupt)
	UI:SetSpeaker(camerupt)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Y-yes![pause=0] He was in bed when I went to sleep last night...[br]...But when I woke up this morning he was nowhere to be seen!")
	UI:WaitShowDialogue("I went all over town and asked anyone if they had seen him...[pause=0] Nobody has spotted him since yesterday!")
	UI:SetSpeakerEmotion("Teary-Eyed")
	UI:WaitShowDialogue("Oh,[pause=10] what if something happened to my baby boy...[pause=0]\nI don't think I'd be able to forgive myself...")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("I am sure nothing of the sort has happened to him.[pause=0] Perhaps he just wandered off.")
	UI:WaitShowDialogue("If he were to wander off,[pause=10] do you have any idea where he might go?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(camerupt)
	UI:SetSpeakerEmotion("Teary-Eyed")
	UI:WaitShowDialogue("No...[pause=0] He's never done something like this before...")
	UI:WaitShowDialogue("Oh...[pause=0] Where could he be...?")
	
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(This is the mother who was arguing with her son in the town yesterday.[pause=0] He seemed pretty upset afterwards...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(And now he's gone missing...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(.........)", "Worried")
	
	GAME:WaitFrames(20)
	SOUND:PlayBattleSE('EVT_Emote_Exclaim_Idea')
	GeneralFunctions.EmoteAndPause(hero, 'Exclaim', false)
	
	GeneralFunctions.HeroDialogue(hero, "(Wait![pause=0] That's it!)", "Surprised")
	GeneralFunctions.HeroDialogue(hero, "(Their fight must be the cause of his disappearance!)", "Surprised")

	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(hero, camerupt, 4)
	GAME:WaitFrames(10)
	GeneralFunctions.HeroSpeak(hero, 60)
	
	GAME:WaitFrames(20)
	
	--SOUND:PlayBattleSE('EVT_Emote_Exclaim_2')
	coro1 = TASK:BranchCoroutine(function() --GROUND:CharSetEmote(camerupt, "exclaim", 1)
											GROUND:CharTurnToCharAnimated(camerupt, hero, 4) end)	
	coro2 = TASK:BranchCoroutine(function() --GROUND:CharSetEmote(noctowl, "notice", 1)
											GROUND:CharTurnToCharAnimated(noctowl, hero, 4) end)	
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											--GROUND:CharSetEmote(partner, "exclaim", 1)
											GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3})

	UI:SetSpeaker(camerupt)
	UI:SetSpeakerEmotion("Teary-Eyed")
	UI:WaitShowDialogue("Huh?[pause=0] Do I think that he may have ran away?")
	
	GAME:WaitFrames(40)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(".........")
	UI:WaitShowDialogue("...It's possible...[pause=0] We had an...[pause=0] argument last evening,[pause=10] and he was very upset...")
	
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(noctowl, camerupt, 4)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("What was the argument about?")
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(camerupt, noctowl, 4) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) end)
	
	TASK:JoinCoroutines({coro1, coro2})
	
	UI:SetSpeaker(camerupt)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Well...[pause=0] He hadn't done his chores yet,[pause=10] and it was starting to get late.")
	UI:WaitShowDialogue("So I told him to stop playing with his friend and to go gather firewood for the fireplace.")
	UI:WaitShowDialogue("He refused,[pause=10] so I threatened to take away his dinner if he didn't do his chores.")
	UI:WaitShowDialogue("He told me that he wished he was grown up so he wouldn't have to listen to me...")
	UI:WaitShowDialogue("...Then he ran home and collected some wood outside of our home.")
	UI:WaitShowDialogue("I thought that was the end of it,[pause=10] but...[pause=0]\nI guess he ran off after I fell asleep.")
	UI:SetSpeakerEmotion("Teary-Eyed")
	UI:WaitShowDialogue("Oh,[pause=10] " .. CharacterEssentials.GetCharacterName('Numel') .. "...")
	
	GAME:WaitFrames(20)
	SOUND:FadeOutBGM(120)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue('Did you say that he wished to be "grown up"?')
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(camerupt)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Yes... But I don't see how that's important...")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue('If he wanted to grow up...[pause=0] I believe he may have ran off towards Luminous Spring.')
	
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(camerupt, "Exclaim", true)
	UI:SetSpeaker(camerupt)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Oh![pause=0] You might be right![pause=0] The Luminous Spring is just to the north of town,[pause=10] he could easily have gone there!")
	
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(partner, 'Question', true)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Luminous Spring?")
	
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(noctowl, partner, 4)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("Luminous Spring is the source of the Illuminant River,[pause=10] the river that runs through this very town.")
	UI:WaitShowDialogue("It is also the place that Pokémon go to evolve.")
	UI:WaitShowDialogue("If " .. CharacterEssentials.GetCharacterName('Numel') .. " wanted to grow up,[pause=10] evolving is,[pause=10] in a way,[pause=10] one way to do so.")
	UI:WaitShowDialogue("...Though I doubt he actually meets the requirements to evolve.")
	
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("The problem now is that...[pause=0] The Luminous Spring is located at the end of " .. zone:GetColoredName() .. "...")
	UI:WaitShowDialogue("A mystery dungeon.")
	
	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(camerupt, 'Shock', true)
	UI:SetSpeaker(camerupt)
	UI:SetSpeakerEmotion('Surprised')
	GeneralFunctions.Hop(camerupt)
	UI:WaitShowDialogue("You're saying my baby is in a place as dangerous as a mystery dungeon!?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	GROUND:CharTurnToCharAnimated(noctowl, camerupt, 4)
	UI:WaitShowDialogue("Potentially.[pause=0] We will need to organize a team to go and search for him.")
	UI:WaitShowDialogue("However,[pause=10] I fear that all of our experienced apprentices are already out on their tasks for the day.")
	UI:WaitShowDialogue("Which means that we have nobody available to go on such a search.")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GROUND:CharTurnToCharAnimated(partner, noctowl, 4)
	GeneralFunctions.DoubleHop(partner)
	UI:WaitShowDialogue("We'll do it![pause=0] We can rescue " .. CharacterEssentials.GetCharacterName("Numel") .. "!")
	
		
	GAME:WaitFrames(10)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(camerupt, partner, 4) end)	
	coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(noctowl, partner, 4) end)	
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
	
	
	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("You two are too inexperienced for such an undertaking.[pause=0] I would prefer we get a more practiced team.")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("C'mon![pause=0] We need to find " .. CharacterEssentials.GetCharacterName("Numel") .. " before anything happens to him!")
	UI:WaitShowDialogue("And you said it yourself,[pause=10] nobody else is available right now for the job!")
	UI:WaitShowDialogue("Plus,[pause=10] this " .. zone:GetColoredName() .. " is close to town.[pause=0] It can't be that dangerous!")
	UI:WaitShowDialogue("I know " .. hero:GetDisplayName() .. " and I can do it!")
	
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	
	UI:WaitShowDialogue("Right,[pause=10] " .. hero:GetDisplayName() .. "?")
	
	GAME:WaitFrames(10)
	GeneralFunctions.DoAnimation(hero, "Nod")
	GAME:WaitFrames(20)
	
	GROUND:CharTurnToCharAnimated(partner, noctowl, 4)
	GROUND:CharTurnToCharAnimated(hero, camerupt, 4)
	
	GAME:WaitFrames(10)
	UI:WaitShowDialogue("See?[pause=0] We can do this![pause=0] Please,[pause=10] just give us this chance and we will rescue " .. CharacterEssentials.GetCharacterName('Numel') .. "!")
	
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(noctowl, camerupt, 8)
	GAME:WaitFrames(60)
	GROUND:CharTurnToCharAnimated(noctowl, partner, 8)
	GAME:WaitFrames(60)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("...Very well.")
	
	GAME:WaitFrames(20)
	SOUND:PlayBGM("Wigglytuff's Guild.ogg", false)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("Really?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("Yes.[pause=0] There are no other options,[pause=10] and on second consideration,[pause=10] this seems like a job that you could handle.")
	UI:WaitShowDialogue("As such,[pause=10] in lieu of taking a mission from the Job Bulletin Board...")
	UI:WaitShowDialogue("...I will entrust the task of searching " .. zone:GetColoredName() .. " for " .. CharacterEssentials.GetCharacterName('Numel') .. " to the two of you.")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(camerupt)
	GROUND:CharAnimateTurnTo(camerupt, Direction.Down, 4)
	UI:SetSpeakerEmotion("Teary-Eyed")
	UI:WaitShowDialogue("You two will go looking for my baby?[pause=0] Thank you!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("Of course![pause=0] We won't let you down!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("You should get started on your search immediately.")
	UI:WaitShowDialogue("As I said earlier,[pause=10] " .. zone:GetColoredName() .. " is located to the north of town.")
	UI:WaitShowDialogue("You should prepare yourselves with the proper facilities in town,[pause=10] then head north to search for " .. CharacterEssentials.GetCharacterName("Numel") .. ".")
	UI:WaitShowDialogue("If you manage to find him,[pause=10] please bring him back to town immediately.")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("Got it![pause=0] We'll get right to it then!")
	
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:WaitShowDialogue("C'mon,[pause=10] " .. hero:GetDisplayName() .. "![pause=0] Let's get ready to save " .. CharacterEssentials.GetCharacterName("Numel") .. "!")
		

	GAME:WaitFrames(20)
	GROUND:CharEndAnim(hero)
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)
	GeneralFunctions.PanCamera()
	SV.Chapter2.FinishedCameruptRequestScene = true
	GAME:CutsceneMode(false)
	
	
	
	
end	



function guild_second_floor_ch_2.RescuedNumelCutscene()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	GAME:CutsceneMode(true)
	SOUND:StopBGM()
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("illuminant_riverbed")
	
	GAME:MoveCamera(112, 224, 1, false)
	
	local noctowl, numel, camerupt = 
		CharacterEssentials.MakeCharactersFromList({
			{'Noctowl', 152, 248, Direction.UpLeft},
			{'Numel', 88, 224, Direction.Right},
			{'Camerupt', 120, 224, Direction.Left}
		})
	
	GROUND:TeleportTo(partner, 88, 256, Direction.Up)
	GROUND:TeleportTo(hero, 120, 256, Direction.Up)
	GAME:FadeIn(40)
	SOUND:PlayBGM("Job Clear!.ogg", true)
	
	UI:SetSpeaker(camerupt)
	UI:SetSpeakerEmotion("Teary-Eyed")
	UI:WaitShowDialogue(numel:GetDisplayName() .. "![pause=0] My baby!")
	UI:WaitShowDialogue("You're back,[pause=10] safe and sound![pause=0] I was so scared I was going to lose you!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(numel)
	UI:SetSpeakerEmotion("Teary-Eyed")
	UI:WaitShowDialogue("Oh momma...[pause=0] I was afraid I was gonna be stuck there forever...")
	UI:WaitShowDialogue("I never should have ran away...[pause=0] I'm sorry...")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(camerupt)
	UI:SetSpeakerEmotion("Teary-Eyed")
	UI:WaitShowDialogue("I'm sorry too,[pause=10] sweetie.[pause=0] I know it's been hard now that I need you to do more around the house...")
	--UI:WaitShowDialogue("That's a lot of stress to put on you.[pause=0] But I only do it because I have to.")
	--too long with no nicknames
	UI:WaitShowDialogue("But all that matters now though is that you're safe.[pause=0] Just promise me you'll never do something like this again.")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(numel)
	UI:SetSpeakerEmotion("Teary-Eyed")
	UI:WaitShowDialogue("I promise...")
	
	GAME:WaitFrames(60)
	GROUND:CharAnimateTurnTo(camerupt, Direction.Down, 4)
	GROUND:CharAnimateTurnTo(numel, Direction.Down, 4)
	GROUND:CharTurnToChar(partner, camerupt)
	UI:SetSpeaker(camerupt)
	UI:WaitShowDialogue("I don't think I can ever thank you two enough for returning my baby boy to me.")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GROUND:CharSetEmote(partner, "sweating", 1)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("D-Don't worry about it![pause=0] That's what we're here for!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(camerupt)
	UI:WaitShowDialogue("Don't be so modest![pause=0] Please,[pause=10] take this as thanks for bringing him back home!")
	
	GAME:WaitFrames(20)
	
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(camerupt, 120, 240, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(partner, camerupt, 4, Direction.UpRight) end)
	
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(10)
	

	GeneralFunctions.RewardItem(GeneralFunctions.GetFavoriteGummi(hero))
	GeneralFunctions.RewardItem(GeneralFunctions.GetFavoriteGummi(partner))
	GeneralFunctions.RewardItem(350, true)
	
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(partner, "Exclaim", true)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Woah![pause=0] You're giving us all this?[pause=0] Are you sure?")
	
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(camerupt, partner, 4)
	UI:SetSpeaker(camerupt)
	UI:WaitShowDialogue("As sure as sure can be![pause=0] You saved my baby boy after all![pause=0] He's worth everything to me!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Inspired")
	GeneralFunctions.DoubleHop(partner)
	UI:WaitShowDialogue("Wow![pause=0] Thank you very much!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(camerupt)
	UI:WaitShowDialogue("Of course![pause=0] And again...[pause=0] Thank you,[pause=10] thank you so much!")
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(camerupt, Direction.Down, 4)
	GROUND:AnimateToPosition(camerupt, "Walk", Direction.Down, 120, 224, 1, 1, 0)
	GAME:WaitFrames(10)
	GROUND:CharTurnToCharAnimated(camerupt, numel, 4)
	GROUND:CharTurnToCharAnimated(numel, camerupt, 4)
	
	UI:WaitShowDialogue("Come on sweetie,[pause=10] let's go home and have dinner.")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(numel)
	UI:SetSpeakerEmotion("Happy")
	GROUND:CharSetEmote(numel, "happy", 0)
	UI:WaitShowDialogue("Hooray,[pause=10] dinner![pause=0] I'm starving!")
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(numel, "", 0)
	

	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(camerupt, Direction.Right, 4)
											GROUND:MoveToPosition(camerupt, 232, 224, false, 1)
											GROUND:MoveToPosition(camerupt, 280, 172, false, 1)
											GAME:GetCurrentGround():RemoveTempChar(camerupt) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:MoveToPosition(numel, 232, 224, false, 1)
											GROUND:MoveToPosition(numel, 280, 172, false, 1)
											GAME:GetCurrentGround():RemoveTempChar(numel) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
												  GeneralFunctions.FaceMovingCharacter(hero, camerupt, 4, Direction.UpRight) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
												  GeneralFunctions.FaceMovingCharacter(partner, camerupt, 4, Direction.UpRight) end)
	local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
												  GeneralFunctions.FaceMovingCharacter(noctowl, camerupt, 4, Direction.UpRight) end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Joyous")
	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, hero, 4)
											GeneralFunctions.DoubleHop(partner)
											GROUND:CharSetEmote(partner, "glowing", 0)
											GROUND:CharSetAnim(partner, "Idle", true)
											UI:WaitShowTimedDialogue("Haha,[pause=10] we really did it,[pause=10] " .. hero:GetDisplayName() .. "!", 60) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharTurnToCharAnimated(hero, partner, 4)
											GROUND:CharSetAnim(hero, "Idle", true)
											GROUND:CharSetEmote(hero, "glowing", 0) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(noctowl, Direction.UpLeft, 4)
											GeneralFunctions.EightWayMove(noctowl, 104, 224, false, 1)
											GROUND:CharAnimateTurnTo(noctowl, Direction.Down, 4) end)
											
	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("Indeed,[pause=10] you did it.[pause=0] Well done,[pause=10] Team " .. GAME:GetTeamName() .. ".")
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(partner, "", 0)
	GROUND:CharSetEmote(hero, "", 0)
	
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	
	UI:WaitShowDialogue("You did an excellent job bringing " .. numel:GetDisplayName() .. " back to his mother.")
	UI:WaitShowDialogue("To think that he was naïve enough to believe he was ready for evolution.") 
	--UI:WaitShowDialogue("Ah,[pause=10] the follies of youth...")
	
	GAME:WaitFrames(20)
	SOUND:FadeOutBGM(120)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("That reminds me...[pause=0] " .. noctowl:GetDisplayName() .. "...")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("Yes?[pause=0] What is it?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("The spring...[pause=0] Does it still do anything even if you're not ready for evolution?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("Indeed it does.[pause=0] It would let you know that you do not meet the requirements for evolution.")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("That's strange,[pause=10] because the spring wasn't doing anything at all for any of us.")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	GeneralFunctions.EmoteAndPause(noctowl, "Question", true)
	UI:WaitShowDialogue("What do you mean it did not do anything?")
	
	GAME:WaitFrames(10)
	--coro1 = TASK:BranchCoroutine(function() GeneralFunctions.Recoil(partner) end)
	--coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(hero, "Shock", false) end)	
	--coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(partner, "Sweating", true) end)
	--coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(hero, "Shock", false) end)
	
	--TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(10)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	GROUND:CharSetEmote(partner, "sweating", 1)
	UI:WaitShowDialogue("Well,[pause=10] " .. numel:GetDisplayName() .. ",[pause=10] " .. hero:GetDisplayName() .. ",[pause=10] and I all tried standing in the light of the spring.")
	UI:WaitShowDialogue("But no matter who tried,[pause=10] nothing happened.[pause=0] We didn't hear a voice or anything.")
	UI:WaitShowDialogue("Is something wrong with the spring?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(".........")
	UI:WaitShowDialogue("...[pause=0]No.[pause=0] It is nothing to be concerned about.[pause=0] The spring has...[pause=30] been known to do this before.")
	
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("OK.[pause=0] That's good to hear.[pause=0] I was worried for a bit there.")
	
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(I still can't shake this feeling that something was off back at the spring.)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(But " .. noctowl:GetDisplayName() .. " is telling us not to worry about it,[pause=10] so maybe it's not a big deal...)", "Worried")

	
	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("You two should head upstairs.[pause=0] Dinner should be ready any moment.[pause=0] I will be up shortly.")
	
	GAME:WaitFrames(20)
	SOUND:PlayBattleSE('DUN_Belly')
	GAME:WaitFrames(40)
	
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.EmoteAndPause(partner, "Exclaim", false) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(hero, "Exclaim", true) end)

	TASK:JoinCoroutines({coro1, coro2})

	GAME:WaitFrames(20)
	
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToChar(noctowl, hero)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Joyous")
	GROUND:CharSetEmote(partner, "glowing", 0)
	SOUND:PlayBGM('Heartwarming.ogg', true)
	UI:WaitShowDialogue("Sounds like " .. hero:GetDisplayName() .. " can't wait!")
	UI:WaitShowDialogue("C'mon,[pause=10] " .. hero:GetDisplayName() .. "![pause=0] Let's go get some dinner before your stomach barks at us again!")
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(partner, "", 0)
	
	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(hero, Direction.Right, 4)
											GROUND:MoveToPosition(hero, 300, 256, false, 1)
											SOUND:FadeOutBGM(120) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:MoveToPosition(partner, 300, 256, false, 1) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GeneralFunctions.FaceMovingCharacter(noctowl, hero, 4, Direction.Right) end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(".........")
	GAME:WaitFrames(60)
	

	GAME:FadeOut(false, 60)
	SV.TemporaryFlags.Dinnertime = true
	GAME:CutsceneMode(false)
	GAME:EnterGroundMap("guild_dining_room", "Main_Entrance_Marker")
end

function guild_second_floor_ch_2.Zangoose_Action(chara, activator)
	guild_second_floor_ch_2.Seviper_Action(chara, activator)
end 

function guild_second_floor_ch_2.Seviper_Action(chara, activator)
	local zangoose = CH('Zangoose')
	local seviper = CH('Seviper')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	--Set zangoose and seviper to interacting to pause their talking AI
	zangoose.IsInteracting = true
	seviper.IsInteracting = true
	partner.IsInteracting = true
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharSetAnim(seviper, 'None', true)
	GROUND:CharSetAnim(zangoose, 'None', true)
	UI:SetSpeaker(seviper)
	GROUND:CharTurnToChar(hero, chara)
    local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)

	UI:WaitShowDialogue("What about thissss one?")
	TASK:JoinCoroutines({coro1})
	UI:WaitDialog()
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(zangoose)
	UI:WaitShowDialogue("Too weak.")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(seviper)
	UI:WaitShowDialogue("Well,[pause=10] what about thissss one?")
	
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(zangoose, seviper, 4)
	UI:SetSpeaker(zangoose)
	UI:WaitShowDialogue("Not a real challenge.[pause=0] You scared of fighting a real outlaw or something?")

	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(seviper, zangoose, 4)
	UI:SetSpeaker(seviper)
	UI:WaitShowDialogue("Had to make ssssure to pick one you'd be able to handle.[pause=0] Sssseeing how you're sssso delicate and all...")
	
	GAME:WaitFrames(20)
	--GeneralFunctions.EmoteAndPause(zangoose, "Sweating", true)
	GROUND:CharAnimateTurnTo(zangoose, Direction.Up, 4)
	UI:SetSpeaker(zangoose)
	--UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("Tch...[pause=0] Ain't that a convenient excuse...")
	
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(seviper, Direction.Up, 4)
	UI:SetSpeaker(seviper)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Yeah yeah.[pause=0] Now sssstop being sssso picky.")
	UI:WaitShowDialogue("Team [color=#FFA5FF]Rivalssss[color] will get a bad rep if you keep ussss here insssstead of in the field catching outlawssss.")
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	GROUND:CharEndAnim(seviper)
	GROUND:CharEndAnim(zangoose)
	zangoose.IsInteracting = false
	seviper.IsInteracting = false
	partner.IsInteracting = false
end

function guild_second_floor_ch_2.Zigzagoon_Action(chara, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local zigzagoon = CH('Zigzagoon')
	
	GeneralFunctions.StartConversation(zigzagoon, "Hey Team " .. GAME:GetTeamName() .. ",[pause=10] how's your first day going?")
	UI:WaitShowDialogue(".........")
	UI:WaitShowDialogue(CharacterEssentials.GetCharacterName("Noctowl") .. " is sending you over to Sensei " .. CharacterEssentials.GetCharacterName("Ledian") .. " for training,[pause=10] huh?")
	UI:WaitShowDialogue("She's definitely...[pause=0] Um...[pause=0] a character alright...")
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("She's a great teacher,[pause=10] though.[pause=0] Make sure you do your best to learn from her!")
	--UI:WaitShowDialogue("I know that I learned a lot of stuff from her!")
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_2.Bagon_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "We're Team [color=#FFA5FF]Flight[color]![pause=0] We're an adventuring team that loves the sky!")
	UI:WaitShowDialogue("I can't fly yet myself,[pause=10] but my partner " .. CharacterEssentials.GetCharacterName('Doduo') .. " is a master of flying!")
	UI:WaitShowDialogue("I can't wait to soar the skies like him one day!")
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_2.Doduo_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "We came here to get some jobs,[pause=10] but we got here a bit later than we'd have liked to.")
	UI:WaitShowDialogue("We would have flown us here in a jiffy,[pause=10] but,[pause=10] erm...")
	UI:SetSpeakerEmotion("Stunned")
	GROUND:CharSetEmote(chara, "sweating", 1)
	UI:WaitShowDialogue("Our...[pause=0] wings were too tired after flying around all day.[pause=0] So we and " .. CharacterEssentials.GetCharacterName("Bagon") .." had to walk.")
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_2.Audino_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "H-hey you two![pause=0] Hope your first day w-went well!", "Happy")
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("I'm almost finished updating the job boards.")
	UI:WaitShowDialogue("Just need that l-last team to leave so I can update that board.")
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Hopefully they don't take too long...[pause=0] It's almost dinner time,[pause=10] and I'm f-famished!")
	GeneralFunctions.EndConversation(chara)
	
end 

function guild_second_floor_ch_2.Noctowl_Action(chara, activator)
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("illuminant_riverbed")
	GeneralFunctions.StartConversation(chara, "As I said earlier,[pause=10] " .. zone:GetColoredName() .. " is located to the north of town.")
	UI:WaitShowDialogue("You should prepare yourselves with the proper facilities in town,[pause=10] then head north to search for " .. CharacterEssentials.GetCharacterName("Numel") .. ".")
	UI:WaitShowDialogue("If you manage to find him,[pause=10] please bring him back to town immediately.")
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_2.Camerupt_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, 'Please,[pause=10] find my baby boy![pause=0] He means the world to me!', 'Teary-Eyed')
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_2.Cleffa_Aggron_Conversation(chara)
	local cleffa = CH('Cleffa')
	local aggron = CH('Aggron')
	
	UI:SetSpeaker(cleffa)
	GROUND:CharSetAnim(cleffa, 'None', true)
	GROUND:CharSetAnim(aggron, 'None', true)
	cleffa.IsInteracting = true
	aggron.IsInteracting = true
	GeneralFunctions.StartConversation(chara, "We need a high bounty outlaw here to make up for your blunder the other day.[pause=0] See anything decent?", "Determined", false, true, false)
	SV.TemporaryFlags.OldDirection = Direction.None--hack to prevent target chara from turning back at the end of the conversation.
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(aggron)
	UI:SetSpeakerEmotion("Worried")
	GROUND:CharTurnToCharAnimated(aggron, cleffa, 4)
	UI:WaitShowDialogue("But boss...[pause=0] Aren't higher bountied criminals more dangerous?[pause=0] Are you sure we can handle it?")
	
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(cleffa, aggron, 4)
	UI:SetSpeaker(cleffa)
	UI:SetSpeakerEmotion("Angry")
	UI:WaitShowDialogue("I can handle anything![pause=0] If you pull your own weight for once,[pause=10] it'll be a cinch!")
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(aggron, "sweating", 1)
	UI:SetSpeaker(aggron)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("Y-yes boss...")
	GROUND:CharAnimateTurnTo(cleffa, Direction.Up, 4)
	GROUND:CharAnimateTurnTo(aggron, Direction.Up, 4)
	GeneralFunctions.EndConversation(chara)
	GROUND:CharEndAnim(aggron)
	GROUND:CharEndAnim(cleffa)
	cleffa.IsInteracting = false 
	aggron.IsInteracting = false 
end
	
function guild_second_floor_ch_2.Cleffa_Action(chara, activator)
	guild_second_floor_ch_2.Cleffa_Aggron_Conversation(chara)
end

function guild_second_floor_ch_2.Aggron_Action(chara, activator)
	guild_second_floor_ch_2.Cleffa_Aggron_Conversation(chara)
end



return guild_second_floor_ch_2