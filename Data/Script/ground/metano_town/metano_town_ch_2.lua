require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_town_ch_2 = {}

function metano_town_ch_2.SetupGround()
	--objects/npcs that aren't for use in chapter 2 
	GROUND:Hide('Red_Merchant')
	GROUND:Hide('Green_Merchant')
	GROUND:Hide('Swap_Owner')
	GROUND:Hide('Swap')
	GROUND:Hide('Cafe_Entrance')
	

	if SV.Chapter2.FirstMorningMeetingDone and not SV.Chapter2.FinishedTraining then
		--these objects prevent the player from going into the rest of the town too soon, as they must go to the dojo first and complete training
		local stoneBlock = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1), 
														RogueElements.Rect(896, 880, 16, 40),
														RogueElements.Loc(0, 0), 
														true, 
														"Event_Trigger_1")
		
		local bridgeBlock = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1), 
														RogueElements.Rect(464, 1184, 16, 64),
														RogueElements.Loc(0, 0), 
														true, 
														"Event_Trigger_2")

		local marketBlock = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1), 
														RogueElements.Rect(968, 1000, 16, 240),
														RogueElements.Loc(0, 0), 
														true, 
														"Event_Trigger_3")
		stoneBlock:ReloadEvents()
		bridgeBlock:ReloadEvents()
		marketBlock:ReloadEvents()

		GAME:GetCurrentGround():AddTempObject(stoneBlock)
		GAME:GetCurrentGround():AddTempObject(bridgeBlock)
		GAME:GetCurrentGround():AddTempObject(marketBlock)
		
		GAME:FadeIn(20)
	elseif SV.Chapter2.FinishedTraining and not SV.Chapter2.FinishedFirstDay then 
		GROUND:AddMapStatus("dusk")--dusk
		local meditite, luxray, machamp, furret, wooper_girl, wooper_boy, electrike, lickitung, gulpin, nidorina, gloom, numel, 
			  oddish, bellossom, floatzel, roselia, spinda, ludicolo, mawile, azumarill = 
			CharacterEssentials.MakeCharactersFromList({
				{'Meditite', 552, 352, Direction.Down},
				{'Luxray', 'Town_Seat_1'},
				{'Machamp', 'Town_Seat_2'},
				{'Furret', 356, 764, Direction.Right},
				{'Wooper_Girl', 328, 1000, Direction.Right},
				{'Wooper_Boy', 360, 1000, Direction.Left},
				{'Electrike', 344, 976, Direction.Down},
				{'Lickitung', 1148, 604, Direction.Up},
				{'Gulpin', 1124, 628, Direction.UpRight},
				{'Nidorina', 536, 208, Direction.UpLeft},
				{'Gloom', 512, 184, Direction.DownRight},
				{'Numel', 192, 536, Direction.Left},
				{'Oddish', 408, 396, Direction.DownLeft},
				{'Bellossom', 472, 608, Direction.UpLeft},
				{'Floatzel', 714, 232, Direction.Up},
				{'Roselia', 1204, 1128, Direction.Down},
				{'Spinda', 1184, 1160, Direction.UpRight},
				{'Ludicolo', 1224, 1160, Direction.UpLeft},
				{'Mawile', 768, 600, Direction.Down},
				{'Azumarill', 272, 1208, Direction.Left},
				{'Mareep', 'Cafe_Seat_3'},
				{'Cranidos', 'Cafe_Seat_4'}
		})
		
		GROUND:CharSetAnim(furret, 'Sleep', true)
		AI:SetCharacterAI(mawile, "ai.ground_default", RogueElements.Loc(752, 584), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
		AI:SetCharacterAI(azumarill, "ai.ground_default", RogueElements.Loc(256, 1192), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
		
		AI:SetCharacterAI(roselia, "ai.ground_talking", false, 240, 60, 0, false, 'Default', {ludicolo, spinda})
		AI:SetCharacterAI(ludicolo, "ai.ground_talking", false, 240, 60, 60, false, 'Default', {roselia, spinda})
		AI:SetCharacterAI(spinda, "ai.ground_talking", false, 240, 60, 120, false, 'Default', {ludicolo, roselia})

		
		--place event trigger for numel's tantrum if he hasn't thrown it yet
		if not SV.Chapter2.FinishedNumelTantrum then
			local tantrumBlock = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1), 
												RogueElements.Rect(248, 472, 344, 120),
												RogueElements.Loc(0, 0), 
												true, 
												"Event_Trigger_4")
												
			tantrumBlock.Passable = true
												
			tantrumBlock:ReloadEvents()

			GAME:GetCurrentGround():AddTempObject(tantrumBlock)
			
			--place numel inside oddish for introductory cutscene, so their circles sync up well
			numel.CollisionDisabled = true
			GROUND:TeleportTo(numel, oddish.Position.X, oddish.Position.Y, Direction.DownLeft)
			
			if SV.Chapter2.FinishedTraining then --put a blockade in front of the guild if player has finished training but not numel scene
				local guildBlock = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1), 
												RogueElements.Rect(696, 896, 48, 8),
												RogueElements.Loc(0, 0), 
												true, 
												"Event_Trigger_5")												
				guildBlock:ReloadEvents()

				GAME:GetCurrentGround():AddTempObject(guildBlock)
			end
		end 
	
		--block player from leaving town north or east 
		local northBlock = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1), 
										RogueElements.Rect(232, 8, 40, 8),
										RogueElements.Loc(0, 0), 
										true, 
										"Event_Trigger_6")
										
		local eastBlock = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1), 
										RogueElements.Rect(1496, 592, 8, 144),
										RogueElements.Loc(0, 0), 
										true, 
										"Event_Trigger_7")	
											
		northBlock:ReloadEvents()
		eastBlock:ReloadEvents()

		GAME:GetCurrentGround():AddTempObject(northBlock)
		GAME:GetCurrentGround():AddTempObject(eastBlock)

		--let the cutscene handle the fade in if it hasnt played yet
		if SV.Chapter2.FinishedMarketIntro then 
			GAME:FadeIn(20)
		end 
	
	elseif SV.Chapter2.FinishedFirstDay then 
		local lickitung, gulpin, mawile, azumarill, quagsire, oddish, sentret, bellossom, linoone, medicham, machamp,
		meditite, manetric, marill, jigglypuff, spheal, wooper_boy, wooper_girl, vileplume, luxray = 
			CharacterEssentials.MakeCharactersFromList({
				{'Lickitung', 1148, 604, Direction.Up},
				{'Gulpin', 1124, 628, Direction.UpRight},
				{'Mawile', 648, 1272, Direction.Down},
				{'Azumarill', 272, 1208, Direction.Left},
				{'Quagsire', 714, 232, Direction.Up},
				{'Oddish', 312, 408, Direction.Down},--i wanted numel to play with us... 
				{'Sentret', 312, 440, Direction.Up},--its ok he'll be back soon, let's play just the two of us
				{'Bellossom', 478, 686, Direction.Down},
				{'Linoone', 'Town_Seat_1'},
				{'Medicham', 'Town_Seat_2'},
				{'Machamp', 1264, 352, Direction.Down},--i'll search around town to find the kid! i'll help however i can!
				{'Meditite', 556, 216, Direction.Down},--meditating is hard, i dont really get it
				{'Manectric', 1144, 904, Direction.Down},--i dont know what I would do if my kid went missing!
				{'Marill', 1184, 1160, Direction.UpRight},
				{'Jigglypuff', 1224, 1160, Direction.UpLeft},
				{'Spheal', 1204, 1128, Direction.Down},
				{'Wooper_Boy', 744, 1144, Direction.Right},
				{'Wooper_Girl', 776, 1144, Direction.Left},
				{'Vileplume', 388, 716, Direction.DownRight},
				{'Luxray', 304, 1024, Direction.Down}
		})
		
		AI:SetCharacterAI(machamp, "ai.ground_default", RogueElements.Loc(1248, 336), RogueElements.Loc(48, 48), 1, 16, 32, 40, 180)
		AI:SetCharacterAI(mawile, "ai.ground_default", RogueElements.Loc(624, 1248), RogueElements.Loc(48, 48), 1, 16, 32, 40, 180)
		AI:SetCharacterAI(manetric, "ai.ground_default", RogueElements.Loc(1104, 888), RogueElements.Loc(80, 32), 1, 16, 32, 40, 180)
		AI:SetCharacterAI(azumarill, "ai.ground_default", RogueElements.Loc(256, 1192), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
		AI:SetCharacterAI(luxray, "ai.ground_default", RogueElements.Loc(272, 1008), RogueElements.Loc(80, 32), 1, 16, 32, 40, 180)

		local eastBlock = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1), 
										RogueElements.Rect(1496, 592, 8, 144),
										RogueElements.Loc(0, 0), 
										true, 
										"Event_Trigger_8")	
										
		local northBlock = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1), 
										RogueElements.Rect(232, 8, 40, 8),
										RogueElements.Loc(0, 0), 
										true, 
										"Event_Trigger_9")
											
		eastBlock:ReloadEvents()
		northBlock:ReloadEvents()

		GAME:GetCurrentGround():AddTempObject(eastBlock)
		GAME:GetCurrentGround():AddTempObject(northBlock)
		
		GAME:FadeIn(20)
	else
		GAME:FadeIn(20)
	end
end

function metano_town_ch_2.Event_Trigger_1_Touch(obj, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GeneralFunctions.StartPartnerConversation("That's the way to the market.[pause=0] I don't think Ledian Dojo is that way.")
	UI:WaitShowDialogue("I know you're curious about the town,[pause=10] but we should head to Ledian Dojo first!")
	UI:WaitShowDialogue(CharacterEssentials.GetCharacterName("Noctowl") .. " said that the dojo was down a ladder east of the bridge to the guild.")
	UI:WaitShowDialogue("I'm sure we'll have time after training to take a look around town!")

	GeneralFunctions.EndConversation(partner)

end

function metano_town_ch_2.Event_Trigger_2_Touch(obj, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GeneralFunctions.StartPartnerConversation("That's the way towards the housing area.[pause=0] I don't think Ledian Dojo is that way.")
	UI:WaitShowDialogue("I know you're curious about the town,[pause=10] but we should head to Ledian Dojo first!")
	UI:WaitShowDialogue(CharacterEssentials.GetCharacterName("Noctowl") .. " said that the dojo was down a ladder east of the bridge to the guild.")
	UI:WaitShowDialogue("I'm sure we'll have time after training to take a look around town!")
	GeneralFunctions.EndConversation(partner)

end

function metano_town_ch_2.Event_Trigger_3_Touch(obj, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GeneralFunctions.StartPartnerConversation("Hey,[pause=10] " .. hero:GetDisplayName() .. ",[pause=10] that must be the ladder to the dojo right over there!", "Normal", false)
	GeneralFunctions.TurnTowardsLocation(partner, 924, 1128)
	GeneralFunctions.TurnTowardsLocation(hero, 924, 1128)
	UI:WaitShowDialogue("Let's head on in![pause=0] We'll have time after our training to take a look around town!")

	GeneralFunctions.EndConversation(partner)
	
end




function metano_town_ch_2.Event_Trigger_4_Touch(obj, activator)
	metano_town_ch_2.NumelTantrumCutscene()
end

function metano_town_ch_2.Event_Trigger_5_Touch(obj, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GeneralFunctions.StartPartnerConversation("Hey,[pause=10] " .. hero:GetDisplayName() .. ",[pause=10] don't you want to look around town still?")
	UI:WaitShowDialogue("You should go meet some of the locals![pause=0] We still have a bit of time before dinner!")

	GeneralFunctions.EndConversation(partner)

end

function metano_town_ch_2.Event_Trigger_6_Touch(obj, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GeneralFunctions.StartPartnerConversation("This path leads out of town.[pause=0] There's no time to leave town before dinner!")
	UI:WaitShowDialogue("Let's turn around.[pause=0] We should head back to the guild whenever you're ready.")
	GeneralFunctions.EndConversation(partner)

end

function metano_town_ch_2.Event_Trigger_7_Touch(obj, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GeneralFunctions.StartPartnerConversation("This path leads out of town.[pause=0] There's no time to leave town before dinner!")

	if SV.Chapter2.FinishedNumelTantrum then 
		UI:WaitShowDialogue("Let's turn around.[pause=0] We should head back to the guild whenever you're ready.")
	else 
		UI:WaitShowDialogue("Let's turn around.[pause=0] We should head over to the residential area so you can meet some townspeople!")
	end
	GeneralFunctions.EndConversation(partner)

end

function metano_town_ch_2.Event_Trigger_8_Touch(obj, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("illuminant_riverbed") 
	GeneralFunctions.StartPartnerConversation("This isn't the way to " .. zone:GetColoredName() .. ".")
	UI:WaitShowDialogue(CharacterEssentials.GetCharacterName("Noctowl") .. " said it was to the north of town.[pause=0] We'll need to leave town through the north exit!")
	GeneralFunctions.EndConversation(partner)

end

function metano_town_ch_2.Event_Trigger_9_Touch(obj, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("illuminant_riverbed") 
	
	GeneralFunctions.StartPartnerConversation("This is the way towards " .. zone:GetColoredName() .. ".")
	UI:ChoiceMenuYesNo("Are you ready to head out?", true)
	UI:WaitForChoice()
	local result = UI:ChoiceResult()
	if result then 
		GAME:CutsceneMode(true)
		GROUND:Hide('Event_Trigger_9')
		GROUND:Hide('North_Exit')
	
		local coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, 232, 8, false, 1)
													  GROUND:CharAnimateTurnTo(partner, Direction.Right, 4) end)	
		local coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(hero, 256, 8, false, 1)
													  GROUND:CharAnimateTurnTo(hero, Direction.Left, 4) end) 		
		TASK:JoinCoroutines({coro1, coro2})
		
		UI:WaitShowDialogue("Alright,[pause=10] let's get a move on!")
		
		if SV.Chapter2.EnteredRiver then 
			UI:WaitShowDialogue("Come on![pause=0] Let's do this, " .. hero:GetDisplayName() .. "!")
		else 
			UI:WaitShowDialogue("This is our first mission![pause=0] We can do this,[pause=10] " .. hero:GetDisplayName() .. "!")
		end 
		
		GAME:WaitFrames(20)
		coro1 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(hero, "Nod") end)
		coro2 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(partner, "Nod") end)
		TASK:JoinCoroutines({coro1, coro2})
		
		GAME:WaitFrames(20)
		coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, 244, -4, false, 1)
												GROUND:MoveToPosition(partner, 244, -24, false, 1) end)	
		coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(24)
												GeneralFunctions.EightWayMove(hero, 244, -4, false, 1)
												GROUND:MoveToPosition(hero, 244, -24, false, 1) end)

		TASK:JoinCoroutines({coro1, coro2})	
		SOUND:FadeOutBGM(60)
		GAME:FadeOut(false, 60)
		
		GAME:WaitFrames(120)
		
		GAME:CutsceneMode(false)
		GeneralFunctions.EndConversation(partner)
		SV.partner.Spawn = "Default"
        GAME:EnterGroundMap("illuminant_riverbed_entrance", 'Main_Entrance_Marker')

		
	else
		UI:WaitShowDialogue("OK.[pause=0] Let's head back into town to prepare,[pause=10] and once we're ready we should head on out.")
		GeneralFunctions.EndConversation(partner)
	end

end



function metano_town_ch_2.MarketIntro()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local green_kec = CH('Shop_Owner')
	local purple_kec = CH('TM_Owner')
	local kangaskhan = CH('Storage_Owner')
	local murkrow = CH('Bank_Owner')
	local sneasel = CH('Appraisal')
	local slowpoke = CH('Tutor_Owner')
	local ambipom = CH('Swap_Owner')
	
	GAME:CutsceneMode(true)
	GROUND:CharSetAnim(green_kec, 'Idle', true)
	GROUND:CharSetAnim(purple_kec, 'Idle', true)
	GROUND:CharSetAnim(slowpoke, 'Idle', true)
	GROUND:CharSetAnim(kangaskhan, 'Idle', true)
	GROUND:CharSetAnim(murkrow, 'Idle', true)
	GROUND:CharSetAnim(sneasel, 'Idle', true)
	GROUND:CharSetAnim(CH('Ludicolo'), 'Idle', true)
	GROUND:CharSetAnim(CH('Roselia'), 'Idle', true)
	GROUND:CharSetAnim(CH('Spinda'), 'Idle', true)
	GROUND:CharSetAnim(CH('Musician'), 'Idle', true)

	AI:DisableCharacterAI(partner)
	GeneralFunctions.CenterCamera({hero, partner})
	GAME:FadeIn(20)
	
	
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("That training wasn't so bad![pause=0] I feel like I learned a lot!")
	UI:WaitShowDialogue("We should go back there again soon to train more!")
	GAME:WaitFrames(20)
	
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("You know,[pause=10] it hasn't gotten too late in the day yet.[pause=0] There's time before we have to go back to the guild!")
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Now's the perfect opportunity to show you around Metano Town!")
	GAME:WaitFrames(20)
	
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Let's see,[pause=10] where to start...")
	
	GeneralFunctions.LookAround(partner, 4, 4, true, false, false, Direction.UpRight)
	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(partner, "Exclaim", true)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("Oh,[pause=10] of course![pause=0] The market![pause=0] There's tons of useful shops there!")
	
	GAME:WaitFrames(12)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("It's right over this way![pause=0] Follow me!")
	
	GAME:WaitFrames(20)
	local coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, 984, 1208, false, 1)
												  GeneralFunctions.EightWayMove(partner, 1032, 1208, false, 1)
												  GeneralFunctions.EightWayMove(partner, 1096, 1136, false, 1)
												  GeneralFunctions.EightWayMove(partner, 1096, 944, false, 1)
												  GeneralFunctions.EightWayMove(partner, 1152, 904, false, 1)
												  GROUND:CharAnimateTurnTo(partner, Direction.Left, 4) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(7)
												  GeneralFunctions.EightWayMove(hero, 984, 1208, false, 1)
												  GeneralFunctions.EightWayMove(hero, 1032, 1208, false, 1)
												  GeneralFunctions.EightWayMove(hero, 1096, 1136, false, 1)
												  GeneralFunctions.EightWayMove(hero, 1096, 944, false, 1)
												  GeneralFunctions.EightWayMove(hero, 1120, 904, false, 1)
												  GROUND:CharAnimateTurnTo(hero, Direction.Right, 4) end)
	local coro3 = TASK:BranchCoroutine(function() --GAME:WaitFrames(4)
												  GAME:MoveCamera(992, 1216, 56, false)
												  GAME:MoveCamera(1040, 1216, 48, false)
												  GAME:MoveCamera(1048, 1208, 8, false)
												  GAME:MoveCamera(1104, 1144, 64, false)
												  GAME:MoveCamera(1104, 952, 192, false)
												  GAME:MoveCamera(1128, 928, 24, false)
												  GAME:MoveCamera(1128, 912, 16, false)
												  GAME:MoveCamera(1144, 912, 16, false) end)


	TASK:JoinCoroutines({coro1, coro2, coro3})

	GAME:WaitFrames(20)
	UI:WaitShowDialogue("This here is the Metano Town Market![pause=0] There's all sorts of neat stores here!")
	
	GAME:WaitFrames(20)
	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, purple_kec, 4)
											GROUND:CharTurnToCharAnimated(hero, purple_kec, 4) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.CenterCamera({green_kec, purple_kec}, GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 2) end)

	TASK:JoinCoroutines({coro1, coro2})
	UI:WaitShowDialogue("This here is the " .. _DATA:GetMonster(green_kec.CurrentForm.Species).Name:ToLocal() .. " Shop.[pause=0] It's ran by a pair of brothers,[pause=10] " .. green_kec:GetDisplayName() .. " and " .. purple_kec:GetDisplayName() ..".")
	UI:WaitShowDialogue("They sell all sorts of great items there,[pause=10] especially for adventurers like us!")

	GAME:WaitFrames(20)
	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, kangaskhan, 4)
											GROUND:CharTurnToCharAnimated(hero, kangaskhan, 4) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.CenterCamera({kangaskhan}, GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 2) end)

	TASK:JoinCoroutines({coro1, coro2})
	UI:WaitShowDialogue("That over there is " .. _DATA:GetMonster(kangaskhan.CurrentForm.Species).Name:ToLocal() .. " Storage.[pause=0] " .. kangaskhan:GetDisplayName() .. " will watch over any items we leave with her.")
	UI:WaitShowDialogue("If there's any items we don't want to lose,[pause=10] we can store them there.")
	UI:WaitShowDialogue("This is also where Sensei " .. CharacterEssentials.GetCharacterName("Ledian") .. " sent the items we had on us when we started training.")
	UI:WaitShowDialogue("If we want to get those back,[pause=10] we'll need to speak with " .. kangaskhan:GetDisplayName() .. ".")
	
	GAME:WaitFrames(20)
	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, sneasel, 4)
											GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.CenterCamera({sneasel}, GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 2) end)

	TASK:JoinCoroutines({coro1, coro2})
	UI:WaitShowDialogue(sneasel:GetDisplayName() .. " there runs an appraisal service.[pause=0] She can open any locked boxes we may find on our adventures.")
	UI:WaitShowDialogue("If we ever need help opening up some locked up treasure,[pause=10] she's who we'll need to see.")
	
	GAME:WaitFrames(20)
	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, murkrow, 4)
											GROUND:CharTurnToCharAnimated(hero, murkrow, 4) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.CenterCamera({murkrow}, GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 2) end)

	TASK:JoinCoroutines({coro1, coro2})
	UI:WaitShowDialogue("Over here we have Krow Bank.")
	UI:WaitShowDialogue("We can save our money there with " .. murkrow:GetDisplayName() .. ".")
	
	GAME:WaitFrames(20)
	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, slowpoke, 4)
											GROUND:CharTurnToCharAnimated(hero, slowpoke, 4) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.CenterCamera({slowpoke}, GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 2) end)

	TASK:JoinCoroutines({coro1, coro2})
	UI:WaitShowDialogue("Over here we have " .. slowpoke:GetDisplayName() .. ".[pause=0] He's a bit absent-minded,[pause=10] but he can help us relearn and forget moves.")
	
	GAME:WaitFrames(20)
	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, ambipom, 4)
											GROUND:CharTurnToCharAnimated(hero, ambipom, 4) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.CenterCamera({ambipom}, GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 2) end)

	TASK:JoinCoroutines({coro1, coro2})
	UI:WaitShowDialogue("Lastly we have " .. ambipom:GetDisplayName() .. "'s Swap Shop.")
	UI:WaitShowDialogue("You can normally swap special items here with " .. ambipom:GetDisplayName() .. ",[pause=10] but it seems like he isn't in right now.")

	GAME:WaitFrames(20)
	GROUND:CharTurnToChar(partner, hero)
	GROUND:CharTurnToChar(hero, partner)
	GeneralFunctions.CenterCamera({hero, partner}, GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 3)
	UI:WaitShowDialogue("I think there's a few other businesses in town,[pause=10] but these are the main ones anyway.")
	UI:WaitShowDialogue("We should take a closer look at some of the stores here,[pause=10] then head over to the west side of town.")
	UI:WaitShowDialogue("That's where all the houses are.[pause=0] Most townfolk live over there.")
	UI:WaitShowDialogue("We should have time to do this before we head back to the guild for dinner.")
	UI:WaitShowDialogue("Alright,[pause=10] let's take a look around!")
	
	GAME:WaitFrames(20)
	GeneralFunctions.PanCamera()
	
	GROUND:CharEndAnim(green_kec)
	GROUND:CharEndAnim(purple_kec)
	GROUND:CharEndAnim(sneasel)
	GROUND:CharEndAnim(kangaskhan)
	GROUND:CharEndAnim(murkrow)
	GROUND:CharEndAnim(slowpoke)
	GROUND:CharEndAnim(CH('Ludicolo'))
	GROUND:CharEndAnim(CH('Roselia'))
	GROUND:CharEndAnim(CH('Spinda'))
	GROUND:CharEndAnim(CH('Musician'))
	
	SV.Chapter2.FinishedMarketIntro = true
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)
	GAME:CutsceneMode(false)
	
	
end


function metano_town_ch_2.NumelTantrumCutscene()
	local numel = CH('Numel')
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local machamp = CH('Machamp')
	local luxray = CH('Luxray')
	local oddish = CH('Oddish')
	local meditite = CH('Meditite')
	local bellossom = CH('Bellossom')
	local camerupt = CharacterEssentials.MakeCharactersFromList({
				{'Camerupt', 0, 0, Direction.Right}
		})
	--Hide Camerupt until she is ready to pop into frame 
	GROUND:Hide('Camerupt')
	GROUND:TeleportTo(camerupt, 248, 536, Direction.Right)
	
	--remove trigger for the cutscene
	GROUND:Hide('Event_Trigger_4')

	GAME:CutsceneMode(true)
	GROUND:CharSetAnim(machamp, "Idle", true)
	GROUND:CharSetAnim(luxray, "Idle", true)
	GROUND:CharSetAnim(meditite, "Idle", true)
	GROUND:CharSetAnim(bellossom, "Idle", true)

	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("Hey,[pause=10] " .. hero:GetDisplayName() .. ",[pause=10] look over there!")
	SOUND:FadeOutBGM(60)
	GAME:WaitFrames(20)
	
	--set this to true to stop their running 
	local stopRunning = false
	
	--This flag is used to make numel do an extra lap if oddish hasn't stopped when numel tries to stop running. This is to prevent an issue where oddish would clip through numel if numel stopped before oddish did.
	local oddishStopped = false 
	
	--they play tag until numel's mama calls for him 
	local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, numel, 4)
												  GROUND:CharTurnToCharAnimated(hero, numel, 4) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(24)
												  while not stopRunning do 
													GeneralFunctions.RunInCircle(numel, 12, 2, false, false) end 
													if not oddishStopped then GeneralFunctions.RunInCircle(numel, 12, 2, false, false) end --do an extra lap to prevent clipping
													GeneralFunctions.EmoteAndPause(numel, "Exclaim", true) end)	
	local coro3 = TASK:BranchCoroutine(function() while not stopRunning do 
													GeneralFunctions.RunInCircle(oddish, 12, 2, false, false) end 
													oddishStopped = true
													GROUND:MoveInDirection(oddish, Direction.DownLeft, 12, false, 2) 
													GeneralFunctions.EmoteAndPause(oddish, "Exclaim", false) end)	
	local coro4 = TASK:BranchCoroutine(function() GAME:MoveCamera(428, 464, GeneralFunctions.CalculateCameraFrames(GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 428, 464, 3), false)
												  GAME:WaitFrames(20)
												  SOUND:PlayBGM('Heartwarming.ogg', false)
												  UI:SetSpeaker(oddish)
												  UI:SetSpeakerEmotion("Happy")
												  GROUND:CharSetEmote(oddish, "glowing", 0)
												  UI:WaitShowTimedDialogue("Haha,[pause=10] you'll never catch me,[pause=10] " .. numel:GetDisplayName() .. "!", 60)
												  GAME:WaitFrames(20)
												  GROUND:CharSetEmote(oddish, "", 0)
												  GROUND:CharSetEmote(numel, "glowing", 0)
												  UI:SetSpeaker(numel)
												  UI:SetSpeakerEmotion("Happy")
												  UI:WaitShowTimedDialogue("Yes I will![pause=30] I'm gonna getcha,[pause=10] " .. oddish:GetDisplayName() .. "!", 60)
												  GAME:WaitFrames(20)
												  GROUND:CharSetEmote(numel, "", 0)
												  UI:SetSpeaker(partner)
												  UI:SetSpeakerEmotion("Happy")
												  UI:WaitShowDialogue("Heh,[pause=10] some of the local children are playing tag.[pause=0] They're cute!")
												  GAME:WaitFrames(20)
												  GeneralFunctions.HeroDialogue(hero, "(Aww,[pause=10] that is pretty cute.[pause=0] They sure have a lot of energy!)", "Happy")
												  GAME:WaitFrames(40)
												  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
												  UI:WaitShowTimedDialogue(numel:GetDisplayName() .. "!", 60)
												  GROUND:Unhide("Camerupt")
												  stopRunning = true end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	GAME:WaitFrames(20)
	
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(camerupt, 288, 536, false, 1)
											GROUND:MoveToPosition(camerupt, 348, 476, false, 1)
											GROUND:MoveToPosition(camerupt, 396, 476, false, 1)
											GeneralFunctions.EightWayMove(camerupt, numel.Position.X, numel.Position.Y + 48, false, 1)
											end)
	
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(numel, camerupt, 4, Direction.Down) end)
	
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(oddish, camerupt, 4, Direction.DownRight) end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3})

	GAME:WaitFrames(20)
	UI:SetSpeaker(camerupt)
	UI:WaitShowDialogue(numel:GetDisplayName() .. ",[pause=10] it's almost time for dinner,[pause=10] sweetie.")
	UI:WaitShowDialogue("Did you finish all of your chores like I asked?")
	
	GAME:WaitFrames(10)
	UI:SetSpeaker(numel)
	GeneralFunctions.Hop(numel)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("No momma,[pause=10] I've been playing with " .. oddish:GetDisplayName() .. " all day.")
	
	GAME:WaitFrames(10)
	UI:SetSpeaker(camerupt)
	GeneralFunctions.EmoteAndPause(camerupt, "Notice", true)
	UI:WaitShowDialogue("You haven't done them yet?")
	UI:WaitShowDialogue("Well you better march home and take care of them right now,[pause=10] mister!")
	
	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(numel, "Exclaim", true)
	GeneralFunctions.ShakeHead(numel)
	UI:SetSpeaker(numel)
	UI:SetSpeakerEmotion("Sad")
	SOUND:FadeOutBGM(120)
	UI:WaitShowDialogue("But I don't wanna![pause=0] I hate doing my chores!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(camerupt)
	UI:SetSpeakerEmotion("Pain")
	UI:WaitShowDialogue(numel:GetDisplayName() .. ",[pause=10] you know you need to help out around the house now...")
	UI:WaitShowDialogue("Please don't make this difficult...")
	
	GAME:WaitFrames(10)
	GeneralFunctions.DoubleHop(numel)
	UI:SetSpeaker(numel)
	UI:SetSpeakerEmotion("Determined")
	GROUND:CharSetEmote(numel, "happy", 0)
	UI:WaitShowDialogue("I don't care![pause=0] I hate having to do all these chores all the time!")
	UI:WaitShowDialogue("I don't wanna do them anymore![pause=0] I wanna play with " .. oddish:GetDisplayName() .. "!")
	
	GAME:WaitFrames(20)
	GROUND:CharEndAnim(machamp)
	GROUND:CharEndAnim(luxray)
	
	
	coro1 = TASK:BranchCoroutine(function() --GeneralFunctions.EmoteAndPause(machamp, "Notice", false)
											GROUND:CharTurnToCharAnimated(machamp, numel, 4) end)
	coro2 = TASK:BranchCoroutine(function() --GeneralFunctions.EmoteAndPause(luxray, "Notice", false)
											GROUND:CharTurnToCharAnimated(luxray, numel, 4) end)
	
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(30)
	GeneralFunctions.EmoteAndPause(camerupt, "Exclaim", true)
	GROUND:CharAnimateTurnTo(camerupt, Direction.Down, 4)
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(camerupt, "Sweating", true)
	UI:SetSpeaker(camerupt)
	UI:SetSpeakerEmotion("Pain")
	UI:WaitShowDialogue("(" .. numel:GetDisplayName() .. " is making a scene...[pause=0] I don't want to look like a poor mother in front other the other parents...)")
	UI:WaitShowDialogue("(I need to do something...)")
	
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(camerupt, numel, 4)
	GAME:WaitFrames(10)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue(numel:GetDisplayName() .. ",[pause=10] if you don't go home right now and finish your chores...[br]There'll be no dinner for you tonight mister!")
	
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(numel, "Exclaim", true)
	UI:SetSpeaker(numel)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("B-but...![pause=0] B-but...!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(camerupt)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("No buts mister![pause=0] You head on home right now!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(numel)
	UI:SetSpeakerEmotion("Angry")
	UI:WaitShowDialogue("Not fair![pause=0] I'm sick of you telling me what to do all the time!")
	UI:WaitShowDialogue("I wish I was grown up so I didn't have to listen to you anymore!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(camerupt)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("Well,[pause=10] until that day,[pause=10] you have to do as I say![pause=0] Now march!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(numel)
	UI:SetSpeakerEmotion("Angry")
	UI:WaitShowDialogue("Hmmph!")
	
	GAME:WaitFrames(10)
	
	coro1 = TASK:BranchCoroutine(function() GROUND:AnimateInDirection(camerupt, "Walk", Direction.Left, Direction.Right, 12, 1, 2) 
											GeneralFunctions.FaceMovingCharacter(camerupt, numel, 4, Direction.DownLeft) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(oddish, numel, 4, Direction.DownLeft) end)
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(machamp, numel, 4, Direction.DownLeft) end)
	coro4 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(luxray, numel, 4, Direction.DownLeft) end)
	local coro5 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(numel, 408, 476, true, 3)
												  GROUND:MoveToPosition(numel, 348, 476, true, 3)
												  GROUND:MoveToPosition(numel, 288, 536, true, 3)
												  GROUND:MoveToPosition(numel, 248, 536, true, 3) end)
												  
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	
	GAME:WaitFrames(40)
	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(luxray, camerupt, 4) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(machamp, camerupt, 4) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(oddish, camerupt, 4) end)
	coro4 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(camerupt, Direction.Down, 4) end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	GAME:WaitFrames(40)
	GeneralFunctions.EmoteAndPause(camerupt, "Sweatdrop", true)
	UI:SetSpeaker(camerupt)
	UI:SetSpeakerEmotion("Sigh")
	UI:WaitShowDialogue("Haaah...[pause=0] I don't know what I'm going to do with that boy...")
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(camerupt, 400, 476, false, 1)
											GROUND:MoveToPosition(camerupt, 348, 476, false, 1)
											GROUND:MoveToPosition(camerupt, 288, 536, false, 1)
											GROUND:MoveToPosition(camerupt, 248, 536, false, 1) end)	
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(oddish, camerupt, 4, Direction.Down) end)
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(machamp, camerupt, 4, Direction.DownLeft) end)
	coro4 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(luxray, camerupt, 4, Direction.DownLeft) end)


	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	GROUND:TeleportTo(numel, 192, 536, Direction.Left)
	GAME:GetCurrentGround():RemoveTempChar(camerupt)
	
	GAME:WaitFrames(20)
	
	--player and partner lament on what they just saw, partner mentions they should head to the guild when player is ready to eat dinner
	SOUND:FadeOutBGM(120)
	GROUND:CharSetAnim(oddish, "Idle", true)
	GROUND:CharSetAnim(numel, "Idle", true)
	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(luxray, machamp, 4)
											GROUND:CharSetAnim(luxray, "Idle", true) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharSetAnim(machamp, "Idle", true) 
											GROUND:CharTurnToCharAnimated(machamp, luxray, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:MoveCamera(0, 0, GeneralFunctions.CalculateCameraFrames(GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, hero.Position.X + 8, hero.Position.Y + 8, 3), true) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	--resuming playing whatever song is selected for town.
	SOUND:PlayBGM(SV.metano_town.Song, true)
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("I never like to see families fight,[pause=10] but I guess it's something that's inevitable.")
	
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(I feel like there was more to that fight than a regular family squabble...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(But I guess it's not really any of our business,[pause=10] anyway...)", "Worried")
	
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	
	
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("Well,[pause=10] it can't be helped.[pause=0] I hope they're able to get along again soon.")
	UI:WaitShowDialogue("Anyways,[pause=10] this part of town is where most of the residents live.")
	UI:WaitShowDialogue("Pokémon here are pretty friendly and welcoming,[pause=10] scenes like that don't usually happen.")
	GAME:WaitFrames(20)
	
	UI:WaitShowDialogue("Oh,[pause=10] whenever you're done exploring town,[pause=10] we can head back to the guild.")
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("I'm sure it'll be time for dinner soon!")
	UI:WaitShowDialogue("I worked up at appetite at the dojo today,[pause=10] and I'm sure you did too!")
	
	GROUND:CharEndAnim(oddish)
	GROUND:CharEndAnim(luxray)
	GROUND:CharEndAnim(machamp)
	GROUND:CharEndAnim(bellossom)
	GROUND:CharEndAnim(meditite)
	GROUND:CharEndAnim(numel)
	GROUND:Hide('Event_Trigger_5')--remove event trigger blocking you from entering the guild
	SV.Chapter2.FinishedNumelTantrum = true
	numel.CollisionDisabled = false
	GAME:CutsceneMode(false)

	
end





--Growlithe himself is behind the desk, so there's an obj on the desk that we interact with to actually talk with him
function metano_town_ch_2.Growlithe_Desk_Action(chara, activator)
	local growlithe = CH('Growlithe')
	if not SV.Chapter2.FinishedTraining then 
		GeneralFunctions.StartConversation(growlithe, "What's that,[pause=10] ruff?[pause=0] You're looking for Ledian Dojo?")
		GAME:WaitFrames(20)
		GROUND:EntTurn(growlithe, Direction.DownRight)
		
		local coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.DownRight, 4) end)
		local coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.DownRight, 4) end)
		local coro3 = TASK:BranchCoroutine(function() GAME:MoveCamera(928, 1120, 120, false) end)

		TASK:JoinCoroutines({coro1, coro2, coro3})
		UI:WaitShowDialogue("It's through the ladder by the river over there!")
		GAME:WaitFrames(20)
		GAME:MoveCamera(0, 0, 120, true)

		GROUND:EntTurn(growlithe, Direction.Right)
		
		coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(CH('Teammate1'), growlithe, 4) end)
		coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(CH('PLAYER'), growlithe, 4) end)

		TASK:JoinCoroutines({coro1, coro2})
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("Just cross the bridge,[pause=10] then head east,[pause=10] ruff!")
	elseif not SV.Chapter2.FinishedNumelTantrum then
		GeneralFunctions.StartConversation(growlithe, "Hope your training went well,[pause=10] ruff!", "Happy")
		UI:WaitShowDialogue("We've got a bit of time until dinner![pause=0] I hope " .. CharacterEssentials.GetCharacterName('Snubbull') .. " makes something yummy,[pause=10] ruff!")
	elseif not SV.Chapter2.FinishedFirstDay then
		GeneralFunctions.StartConversation(growlithe, "Hope your training went well,[pause=10] ruff!", "Happy")
		UI:WaitShowDialogue("It's almost time for dinner,[pause=10] ruff![pause=0] Don't miss it or you'll go hungry!")
	elseif not SV.Chapter2.EnteredRiver then 
		GeneralFunctions.StartConversation(growlithe, CharacterEssentials.GetCharacterName("Camerupt") .. " passed by here earlier in a panic,[pause=10] ruff...[pause=0] I couldn't even stop her to ask what was wrong!", "Worried")
		UI:WaitShowDialogue("It's rare to see townfolk worked up like that...[pause=0] I hope everything is OK,[pause=10] ruff...")
	else
		GeneralFunctions.StartConversation(growlithe, "I found out about your mission to find " .. CharacterEssentials.GetCharacterName('Numel') ..".[br]His disappearance explains why " .. CharacterEssentials.GetCharacterName("Camerupt") .. " was so hysterical the other day,[pause=10] ruff.")
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("Anyways,[pause=10] good luck you two with the job![pause=0] I know you can do it,[pause=10] ruff!")
	end
	GeneralFunctions.EndConversation(growlithe)
end







function metano_town_ch_2.Wooper_Siblings_Introduction(chara)
	local dee = CH('Wooper_Girl')
	local dun = CH('Wooper_Boy')
	local electrike = CH('Electrike')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	
	partner.IsInteracting = true
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharSetAnim(dee, 'None', true)
	GROUND:CharSetAnim(electrike, 'None', true)
	GROUND:CharSetAnim(dun, 'None', true)
	
	GROUND:CharTurnToChar(hero, chara)
	GROUND:CharTurnToChar(partner, chara)
	
	UI:SetSpeaker(dee)
    --local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, dee, 4) end)
    --local coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(hero, dee, 4) end)

    UI:WaitShowDialogue("What do you wanna do today,[pause=10] " .. dun:GetDisplayName() .. "?")

    --TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(dun)
   -- coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, dun, 4) end)
   -- coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(hero, dun, 4) end)
	UI:WaitShowDialogue("I dunno,[pause=10] what do you wanna do today,[pause=10] " .. dee:GetDisplayName() .. "?")
	--TASK:JoinCoroutines({coro1, coro2})

	GAME:WaitFrames(20)
	
	UI:SetSpeaker(dee)
   -- coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, dee, 4) end)
    --coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(hero, dee, 4) end)
	UI:WaitShowDialogue("I dunno,[pause=10] what do you wanna do today,[pause=10] " .. dun:GetDisplayName() .. "?")
	--TASK:JoinCoroutines({coro1, coro2})	
	
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(dun)
    --coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, dun, 4) end)
   --coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(hero, dun, 4) end)
	UI:WaitShowDialogue("I dunno,[pause=10] what do you wanna do today,[pause=10] " .. dee:GetDisplayName() .. "?")
	--TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(dee)
  --  coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, dee, 4) end)
   -- coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(hero, dee, 4) end)
	UI:WaitShowTimedDialogue("I dunno,[pause=10] what do-", 40)
	--TASK:JoinCoroutines({coro1, coro2})
	
	UI:SetSpeaker(electrike)
	GeneralFunctions.EmoteAndPause(electrike, "Angry", true)
   -- coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, electrike, 4) end)
   -- coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(hero, electrike, 4) end)
	UI:SetSpeakerEmotion("Angry")
	UI:WaitShowDialogue("Would you two STOP.")
	--TASK:JoinCoroutines({coro1, coro2})
	UI:WaitShowDialogue("We've been here for hours already trying to figure out what we're doing and now the day's almost over!")
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Can't you just pick something,[pause=10] PLEASE?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(dee)
   -- coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, dee, 4) end)
   -- coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(hero, dee, 4) end)	
	UI:WaitShowDialogue("But I just wanna know what " .. dun:GetDisplayName() .. " wants to do today!")
	--TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(dun)
    --coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, dun, 4) end)
   -- coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(hero, dun, 4) end)
	UI:WaitShowDialogue("And I just wanna know what " .. dee:GetDisplayName() .. " wants to do today!")
	--TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(dee)
    --coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, dee, 4) end)
    --coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(hero, dee, 4) end)
	UI:WaitShowDialogue("What do you wanna do today,[pause=10] " .. dun:GetDisplayName() .. "?")
	--TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(dun)
    --coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, dun, 4) end)
    --coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(hero, dun, 4) end)
	UI:WaitShowDialogue("I dunno,[pause=10] what do you wanna do today,[pause=10] " .. dee:GetDisplayName() .. "?")
	--TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(electrike)
	UI:SetSpeakerEmotion('Pain')
	GeneralFunctions.EmoteAndPause(electrike, "Sweatdrop", true)
    --coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, electrike, 4) end)
    --coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(hero, electrike, 4) end)
	UI:WaitShowDialogue("Ugh...")
	--TASK:JoinCoroutines({coro1, coro2})
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)	
	GROUND:CharEndAnim(electrike)
	GROUND:CharEndAnim(dun)
	GROUND:CharEndAnim(dee)
	
	partner.IsInteracting = false
	SV.Chapter2.WooperIntro = true

end

function metano_town_ch_2.Wooper_Day_2_Conversation(chara)
	local dee = CH('Wooper_Girl')
	local dun = CH('Wooper_Boy')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	
	partner.IsInteracting = true
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharSetAnim(dee, 'None', true)
	GROUND:CharSetAnim(dun, 'None', true)
	
	--turn towards whoever we chose to interact with 
	GROUND:CharTurnToChar(hero, chara)
	GROUND:CharTurnToChar(partner, chara)
	
	
	UI:SetSpeaker(dee)
	UI:WaitShowDialogue("Hey " .. dun:GetDisplayName() .. ",[pause=10] have you seen " .. CharacterEssentials.GetCharacterName('Electrike') .. " anywhere today?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(dun)
	UI:WaitShowDialogue("No " .. dee:GetDisplayName() .. "...[pause=0] I haven't seen him at all today!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(dee)
	UI:WaitShowDialogue("I wonder where he could be?[pause=0] We need him so we can figure out what we're doing today!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(dun)
	UI:WaitShowDialogue("I dunno...[pause=0] I hope he turns up soon though so we can start thinking about it though!")
	
	GROUND:CharEndAnim(dee)
	GROUND:CharEndAnim(dun)
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	partner.IsInteracting = false

end

--dee
function metano_town_ch_2.Wooper_Girl_Action(chara, activator)
	local dee = chara
	if SV.Chapter2.FinishedFirstDay then 
		metano_town_ch_2.Wooper_Day_2_Conversation(dee)
	elseif SV.Chapter2.WooperIntro then
		GeneralFunctions.StartConversation(dee, "I dunno,[pause=10] what do you wanna do today,[pause=10] " .. CharacterEssentials.GetCharacterName("Wooper_Boy") .. "?", "Normal", false)
		GeneralFunctions.EndConversation(dee)
	else
		metano_town_ch_2.Wooper_Siblings_Introduction(chara)
	end
end


--dun
function metano_town_ch_2.Wooper_Boy_Action(chara, activator)
	local dun = chara
	if SV.Chapter2.FinishedFirstDay then 
		metano_town_ch_2.Wooper_Day_2_Conversation(dun)
	elseif SV.Chapter2.WooperIntro then
		GeneralFunctions.StartConversation(dun, "I dunno,[pause=10] what do you wanna do today,[pause=10] " .. CharacterEssentials.GetCharacterName("Wooper_Girl") .. "?", "Normal", false)
		GeneralFunctions.EndConversation(dun)
	else
		metano_town_ch_2.Wooper_Siblings_Introduction(chara)
	end
end

function metano_town_ch_2.Electrike_Action(chara, activator)
	local hero = CH('PLAYER')
	local electrike = chara
	if SV.Chapter2.WooperIntro then
		GeneralFunctions.StartConversation(electrike, "Help.[pause=0] ME.", "Pain")
		GeneralFunctions.EndConversation(electrike)
	else
		metano_town_ch_2.Wooper_Siblings_Introduction(chara)
	end
end 
		

function metano_town_ch_2.Furret_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Aaah...[pause=0] This is my favorite place to snooze~", "Happy", false, false)
	GeneralFunctions.EndConversation(chara, false)
end 

function metano_town_ch_2.Meditite_Action(chara, activator)
	local meditite = chara
	if not SV.Chapter2.FinishedFirstDay then--first day dialogue
		GeneralFunctions.StartConversation(meditite, "..........", "Normal", false, false)
		UI:WaitShowDialogue("..........")
		UI:WaitShowDialogue("...ZZZzzz...")
		UI:ResetSpeaker()
		SOUND:PlayBattleSE('EVT_Emote_Sweatdrop')
		GROUND:CharSetEmote(CH('PLAYER'), "sweatdrop", 1)
		GROUND:CharSetEmote(CH('Teammate1'), "sweatdrop", 1)
		UI:WaitShowDialogue("She appears to have fallen asleep while meditating.")
	else --second day dialogue 
		GeneralFunctions.StartConversation(meditite, "My mum's tryin' been to teach me" .. ' about "inner peace" and "meditation" and all that...')
		UI:WaitShowDialogue("But think I don't that it's really fa' me...[pause=0] Just click it doesn't really...")
	end
	GeneralFunctions.EndConversation(meditite)
end 


function metano_town_ch_2.Lickitung_Action(chara, activator)
	if not SV.Chapter2.FinishedFirstDay then--first day dialogue
		GeneralFunctions.StartConversation(chara, "Apparently,[pause=10] the café is closed for a few days...")
		UI:SetSpeakerEmotion("Sad")
		UI:WaitShowDialogue("We came all this way from out of town for nothing,[pause=10] then?")
		GeneralFunctions.EndConversation(chara)
	else --second day dialogue 
		GeneralFunctions.StartConversation(chara, "Since the café is going to open again soon,[pause=10] we figured we would just camp out here until it opens.")
		UI:WaitShowDialogue("Hopefully won't be too much longer.")
		GeneralFunctions.EndConversation(chara)
	end
end 


function metano_town_ch_2.Gulpin_Action(chara, activator)
	if not SV.Chapter2.FinishedFirstDay then--first day dialogue
		GeneralFunctions.StartConversation(chara, "...Huh?[pause=0] The café is closed...?")
		UI:SetSpeakerEmotion("Sad")
		UI:WaitShowDialogue("...Oh...[pause=0] I won't have my precious drink today...")
		GeneralFunctions.EndConversation(chara)
	else --second day dialogue 
		GeneralFunctions.StartConversation(chara, "...Just how long will I need to wait to have my precious drink?", "Worried")
		UI:WaitShowDialogue("...Oh...[pause=0] I'm wasting away over here...")
		GeneralFunctions.EndConversation(chara)
	end
end 


function metano_town_ch_2.Machamp_Luxray_Dialogue(chara)
	local machamp = CH('Machamp')
	local luxray = CH('Luxray')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	
	partner.IsInteracting = true
	GROUND:CharSetAnim(luxray, 'None', true)
	GROUND:CharSetAnim(machamp, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharSetAnim(partner, 'None', true)
	UI:SetSpeaker(machamp)
    GROUND:CharTurnToChar(hero, chara)
    local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)
	UI:WaitShowDialogue("Hoo...[pause=0] I tell ya,[pause=10] that's gotta be real rough fer " .. CharacterEssentials.GetCharacterName('Camerupt') .. ".")
    TASK:JoinCoroutines({coro1})

	UI:WaitShowDialogue("After...[pause=0] Well,[pause=10] y'know...")
	UI:WaitShowDialogue("And now she's havin' trouble with " .. CharacterEssentials.GetCharacterName('Numel') .. "...")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(luxray)
	UI:WaitShowDialogue("Hmmph...[pause=0] It doesn't matter what's happened.")
	UI:WaitShowDialogue("If her son acts like that towards her,[pause=10] that's her own fault.")
	GAME:WaitFrames(20)
	
	GROUND:CharSetEmote(machamp, "sweating", 1)
	UI:SetSpeaker(machamp)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("I don't think it's that simple in this case,[pause=10] mate...")
	
	GROUND:CharEndAnim(luxray)
	GROUND:CharEndAnim(machamp)
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	partner.IsInteracting = false

end

function metano_town_ch_2.Machamp_Action(chara, activator)
	if not SV.Chapter2.FinishedFirstDay then --first day
		metano_town_ch_2.Machamp_Luxray_Dialogue(chara)
	else --second day
		GeneralFunctions.StartConversation(chara, "Wee " .. CharacterEssentials.GetCharacterName("Numel") .. " wandered off and nobody knows where 'e might be.[pause=0] His poor mum is worried ta' pieces.")
		UI:WaitShowDialogue("That poor Pokémon has been through so much as a' late...[pause=0] We as a town gotta do all that we can ta' find 'im!")
		GeneralFunctions.EndConversation(chara)
	end
end

function metano_town_ch_2.Luxray_Action(chara, activator)
	if SV.Chapter2.FinishedFirstDay then 
		local numel_species = _DATA:GetMonster('numel'):GetColoredName()
		GeneralFunctions.StartConversation(chara, "I've caught word that the " .. numel_species .. " child has gone missing.[pause=0] This does not surprise me.")
		UI:WaitShowDialogue(CharacterEssentials.GetCharacterName("Camerupt") .. " was too soft.[pause=0] So of course her child doesn't obey her and ends up running off.")
		UI:WaitShowDialogue("If your child doesn't respect you,[pause=10] they'll do whatever they want.") 
		GeneralFunctions.EndConversation(chara)
	else
		metano_town_ch_2.Machamp_Luxray_Dialogue(chara)
	end
end
	

function metano_town_ch_2.Nidorina_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "........Are you two in an adventuring team?")
	UI:WaitShowDialogue("........Lame.")
	GeneralFunctions.EndConversation(chara)
end
		
function metano_town_ch_2.Gloom_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Wow![pause=0] Are you two adventurers?[pause=0] That's so...!")
	GROUND:CharSetEmote(chara, "sweating", 1)
	UI:WaitShowDialogue("Oh![pause=0] Erm...[pause=0] I mean...")
	UI:WaitShowDialogue("Pffft...[pause=0] Adventurers?[pause=0] That's...[pause=0] um...[pause=0] stupid!")
	GeneralFunctions.EndConversation(chara)
end 	
	

function metano_town_ch_2.Oddish_Action(chara, activator)
	if not SV.Chapter2.FinishedFirstDay then-- first day dialogue 
		GeneralFunctions.StartConversation(chara, "I wish " .. CharacterEssentials.GetCharacterName('Numel') .. " didn't have to go do his chores...", "Sad")
		UI:WaitShowDialogue("He's had to do a lot of chores lately...[pause=0] We don't get to play as much as we used to...")
	else 
		GeneralFunctions.StartConversation(chara, "Where is " .. CharacterEssentials.GetCharacterName('Numel') .. " this morning?[pause=0] I thought he was going to play with us today!", "Sad", false)
	end
	
	GeneralFunctions.EndConversation(chara)

end

function metano_town_ch_2.Numel_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Stupid chores...[pause=0] I hate collecting firewood.[pause=0] This stinks.", "Determined", false)
	UI:WaitShowDialogue("If I was big and grown up I wouldn't have to do these stupid chores anymore...")
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_2.Floatzel_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "This here is the famous Metano Wishing Well.")
	UI:WaitShowDialogue("They say that if you throw in a " .. STRINGS:Format("\\uE024") .. " and make a wish,[pause=10] it comes true every time!")
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("But I'm starting to think that I was fed a fib...")
	UI:WaitShowDialogue("I've been here all day throwing " .. STRINGS:Format("\\uE024") .. " in and nothing's happened!")
	UI:WaitShowDialogue("Where's my big castle with a huge moat?[pause=0] Am I doing something wrong?")
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_2.Bellossom_Action(chara, activator)
	if not SV.Chapter2.FinishedFirstDay then 
		GeneralFunctions.StartConversation(chara, "Tra-la-la " .. STRINGS:Format("\\u266A"), "Happy")
		UI:WaitShowDialogue("Pretty flowers make everything better![pause=0] Tending to them is rewarding on its own too!")
	elseif not SV.Chapter2.EnteredRiver then 
		GeneralFunctions.StartConversation(chara, CharacterEssentials.GetCharacterName("Camerupt") .. " asked me if I've seen " .. CharacterEssentials.GetCharacterName("Numel") .. " this morning.[pause=0] Apparently,[pause=10] he's gone missing...", "Worried")
		UI:WaitShowDialogue("She seemed sad.[pause=0] I hope " .. CharacterEssentials.GetCharacterName("Numel") .. " is found soon!")
		UI:SetSpeakerEmotion("Normal")
		--too long with no nicknames
		UI:WaitShowDialogue("I'm going to take some flowers over to " .. CharacterEssentials.GetCharacterName("Camerupt") .. "'s house later to cheer her up.[pause=0] Flowers always cheer me up!")
	else
		GeneralFunctions.StartConversation(chara, CharacterEssentials.GetCharacterName("Camerupt") .. " appreciated the flowers I brought her,[pause=10] but she still seemed down.")
		UI:WaitShowDialogue("Hopefully " .. CharacterEssentials.GetCharacterName("Numel") .. " comes home soon so everyone can be happy again!")
	end
	GeneralFunctions.EndConversation(chara)
end 

function metano_town_ch_2.Azumarill_Action(chara, activator)
	if not SV.Chapter2.FinishedFirstDay then 
		GeneralFunctions.StartConversation(chara, chara:GetDisplayName() .. " says that it is beautiful day outside!", "Happy")
		UI:WaitShowDialogue(chara:GetDisplayName() .. " may take swim in river after dinner![pause=0] " .. chara:GetDisplayName() .. " enjoys cool water!")
	else 
		GeneralFunctions.StartConversation(chara, chara:GetDisplayName() .. " heard that child went missing.[pause=0] " .. chara:GetDisplayName() .. ' asks,[pause=10] "where could child be?"')
		UI:SetSpeakerEmotion("Sad")
		UI:WaitShowDialogue(chara:GetDisplayName() .. " not know answer...[pause=0] But " .. chara:GetDisplayName() .. " hopes answer is known soon!")
	end
	GeneralFunctions.EndConversation(chara)
end 

function metano_town_ch_2.Mawile_Action(chara, activator)
	
	--[[
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, chara.CurrentForm.Species, chara.CurrentForm.Form, chara.CurrentForm.Skin, chara.CurrentForm.Gender)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local olddir = chara.Direction
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharSetAnim(chara, 'None', true)
	GROUND:CharTurnToChar(chara, partner)
	GROUND:CharTurnToChar(partner, chara)
	GROUND:CharTurnToChar(hero, chara)
	
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Hey,[pause=10] " .. partner:GetDisplayName() .. "![pause=0] How's it going?")
	GROUND:CharSetEmote(chara, "glowing", 0)
	UI:SetSpeakerEmotion("Joyous")
	UI:WaitShowDialogue("I heard the good news![pause=0] Congrats on getting into the guild!")
	
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(chara, "", 0)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Thanks " .. chara:GetDisplayName() .. "![pause=0] I'm very excited about it!")
	
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("How'd you manage to find out so quickly,[pause=10] anyway?")

	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Joyous")
	GROUND:CharSetEmote(chara, "glowing", 0)
	UI:WaitShowDialogue("Oh,[pause=10] you know me,[pause=10] I have my ways![pause=0] News doesn't stay from my ears for long!")

	GROUND:CharTurnToCharAnimated(chara, hero, 4)
	UI:SetSpeaker("Normal")
	UI:WaitShowDialogue("This must be your partner then![pause=0]")
	--]]


	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	
	if not SV.Chapter2.FinishedFirstDay then --first day dialogue 
		GeneralFunctions.StartConversation(chara, "Hey,[pause=10] " .. partner:GetDisplayName() .. "![pause=0] How's it going?", "Happy")
		GROUND:CharSetEmote(chara, "glowing", 0)
		UI:SetSpeakerEmotion("Joyous")
		UI:WaitShowDialogue("I heard the good news![pause=0] Congratulations on getting into the guild,[pause=10] the both of you!")
		
		GAME:WaitFrames(20)
		GROUND:CharSetEmote(chara, "", 0)
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("Thanks,[pause=10] " .. chara:GetDisplayName() .. "![pause=0] I'm very excited about it!")
		
		GAME:WaitFrames(20)
		UI:SetSpeaker(chara)
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("I'm excited for you too![pause=0] Apprenticing at the guild is a wonderful opportunity!")
		UI:WaitShowDialogue("Good luck with your future adventures![pause=0] Be sure to tell me all about them!")
		
	else --second day dialogue 
		GeneralFunctions.StartConversation(chara, "I heard about the missing child.[pause=0] Everyone's been talking about it.", "Worried")
		UI:WaitShowDialogue("In a town this small and close-knit,[pause=10] news like that spreads like wildfire.")
	end 
	GeneralFunctions.EndConversation(chara)

end


function metano_town_ch_2.Roselia_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Tah![pause=0] We're Team [color=#FFA5FF]Cadence[color]![pause=0] We love to dance!", "Normal", true, false)
	UI:WaitShowDialogue('I like to think of "cadence" as "can-ya-dance"![pause=0] So,[pause=10] can-ya-dance with me? ' .. STRINGS:Format("\\u266A"))
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_2.Spinda_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Lah![pause=0] Come and strike a pose with me!", "Normal", true, false)
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_2.Ludicolo_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Yah![pause=0] This is the best spot in town to dance!", "Normal", true, false)
	UI:WaitShowDialogue("There's lots of open space and " .. CharacterEssentials.GetCharacterName("Chatot") .. " by the tree there plays the best music![pause=0] I can't get enough of his tunes!")
	GeneralFunctions.EndConversation(chara)
end


function metano_town_ch_2.Mareep_Action(chara, activator) 
	GeneralFunctions.StartConversation(chara, "Hey you two![pause=0] Hope your first day was grea-a-a-t!", "Happy")
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Me and " .. CharacterEssentials.GetCharacterName("Cranidos") .. " are resting here after catching the day's ba-a-a-addies!")
	UI:WaitShowDialogue("We're gonna head to the guild in a little bit though.[pause=0] See you at dinner!")
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_2.Cranidos_Action(chara, activator) 
	GeneralFunctions.StartConversation(chara, "What do you two greenhorns want now?[pause=0] Can't a Pokémon unwind after a long day's work?", "Determined")
	UI:WaitShowDialogue("Not that you would know anything about a long day's work!")
	GeneralFunctions.EndConversation(chara)
end




--npcs that only appear on day 2
function metano_town_ch_2.Quagsire_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "My husband has been throwing lots of "  .. STRINGS:Format("\\uE024") .. " into this well thinking it would actually grant him wishes.")
	UI:WaitShowDialogue("I've been coming to the well afterwards to fish the "  .. STRINGS:Format("\\uE024") .. " back out.")
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("I've tried explaining to him wishing wells aren't actually magic,[pause=10] but I don't think he understands.")
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_2.Sentret_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "I'm not sure where " .. CharacterEssentials.GetCharacterName("Numel") .. " is...[pause=0] Guess we'll have to play without him today.", "Worried", false)
	GeneralFunctions.EndConversation(chara)
end



function metano_town_ch_2.Medicham_Linoone_Conversation(chara, activator)
	local linoone = CH('Linoone')
	local medicham = CH('Medicham')
	
	UI:SetSpeaker(medicham)
	GROUND:CharSetAnim(medicham, 'None', true)
	GROUND:CharSetAnim(linoone, 'None', true)
	--How's the book I suggested to you?
	GeneralFunctions.StartConversation(chara, "Book I suggested to you how is?", "Normal", false, true, false)
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(linoone)
	UI:WaitShowDialogue("Oh,[pause=10] it's great.[pause=0] I've been able to apply some methods it talks about to achieve a more peaceful state of mind.")
	GROUND:CharSetEmote(linoone, "sweating", 1)
	UI:SetSpeakerEmotion("Pain")
	UI:WaitShowDialogue("Though it's been more difficult to keep a level head as of late...")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(medicham)
	UI:SetSpeakerEmotion("Worried")
	--It's been harder for me too lately. It'll be even harder now with Nubbor's disappearance weighing on my being...
	UI:WaitShowDialogue("Me too harder it lately is.[pause=0] Now especially weighing on my mind disappearance of " .. CharacterEssentials.GetCharacterName("Numel") .. "...")
	GeneralFunctions.EndConversation(chara)
	
	GROUND:CharEndAnim(linoone)
	GROUND:CharEndAnim(medicham)
	
end 

function metano_town_ch_2.Medicham_Action(chara, activator)
	metano_town_ch_2.Medicham_Linoone_Conversation(chara, activator)
end

function metano_town_ch_2.Linoone_Action(chara, activator)
	metano_town_ch_2.Medicham_Linoone_Conversation(chara, activator)
end

function metano_town_ch_2.Manectric_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Little " .. CharacterEssentials.GetCharacterName("Numel") .. " has gone missing...[pause=0] I can't imagine what his mother is going through.", "Worried")
	UI:WaitShowDialogue("If something happened to my precious " .. CharacterEssentials.GetCharacterName("Electrike") .. "...[pause=0]\nI don't know what I would do!")
	GeneralFunctions.EndConversation(chara)
end 


function metano_town_ch_2.Vileplume_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, CharacterEssentials.GetCharacterName("Numel") .. " has disappeared...[pause=0] Poor child...", "Sad")
	UI:WaitShowDialogue("The world really is becoming a more dangerous place...[pause=0] What can we even do about that?")
	GeneralFunctions.EndConversation(chara)
end 

function metano_town_ch_2.Marill_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "We would help find the missing child...[pause=0] But unfortunately we have other jobs we need to do.", "Worried")
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("I hope that kid is brought back home soon,[pause=10] though!")
	GeneralFunctions.EndConversation(chara)
end 

function metano_town_ch_2.Spheal_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "I hope that missing kid had a big meal before he disappeared...", "Worried")
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("I know all too well the woes of an empty stomach.")
	GeneralFunctions.EndConversation(chara)
end 

function metano_town_ch_2.Jigglypuff_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Another missing Pokémon...[pause=0] There's been more of those kinds of jobs lately.", "Sad")
	UI:WaitShowDialogue("It seems like there's never enough adventurers to do all the work in the world,[pause=10] does it?")
	GeneralFunctions.EndConversation(chara)
end 

