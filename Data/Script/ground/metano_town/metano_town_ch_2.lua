require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_town_ch_2 = {}

function metano_town_ch_2.SetupGround()
	GROUND:Hide('Red_Merchant')
	GROUND:Hide('Green_Merchant')
	GROUND:Hide('Swap_Owner')
	GROUND:Hide('Swap')
	

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

		GAME:GetCurrentGround():AddObject(stoneBlock)
		GAME:GetCurrentGround():AddObject(bridgeBlock)
		GAME:GetCurrentGround():AddObject(marketBlock)
		
		GAME:FadeIn(20)
	elseif SV.Chapter2.FinishedTraining then 
		local meditite = 
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
				{'Numel', 432, 436, Direction.Left},
				{'Oddish', 404, 436, Direction.Right},
				{'Bellossom', 472, 608, Direction.UpLeft},
				{'Floatzel', 714, 232, Direction.Up},
				{'Roselia', 1204, 1128, Direction.Down},
				{'Spinda', 1184, 1160, Direction.UpRight},
				{'Ludicolo', 1224, 1160, Direction.UpLeft}
		})
		
		GROUND:CharSetAnim(CH('Furret'), 'Sleep', true)
	
		GAME:FadeIn(20)
	else
		GAME:FadeIn(20)
	end
end

function metano_town_ch_2.Event_Trigger_1_Touch(obj, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("That's the way to the market.[pause=0] I don't think Ledian Dojo is that way.")
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:WaitShowDialogue("I know I said I'd show you the town today,[pause=10] but we should head to Ledian Dojo first!")
	UI:WaitShowDialogue(CharacterEssentials.GetCharacterName("Noctowl") .. " said that the dojo was down a ladder east of the bridge to the guild.")
	UI:WaitShowDialogue("I'm sure we'll have time after training to take a look around town!")

end

function metano_town_ch_2.Event_Trigger_2_Touch(obj, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("That's the way towards the housing area.[pause=0] I don't think Ledian Dojo is that way.")
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:WaitShowDialogue("I know I said I'd show you the town today,[pause=10] but we should head to Ledian Dojo first!")
	UI:WaitShowDialogue(CharacterEssentials.GetCharacterName("Noctowl") .. " said that the dojo was down a ladder east of the bridge to the guild.")
	UI:WaitShowDialogue("I'm sure we'll have time after training to take a look around town!")
end

function metano_town_ch_2.Event_Trigger_3_Touch(obj, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Hey,[pause=10] " .. hero:GetDisplayName() .. ",[pause=10] that must be the ladder to the dojo right over there!")
	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	UI:WaitShowDialogue("Let's head on in![pause=0] We'll have time after our training to take a look around town!")

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
	UI:WaitShowDialogue("You know,[pause=10] it hasn't gotten too late in the day yet.[pause=0] We still have time before we have to go back to the guild!")
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
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
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
	UI:WaitShowDialogue("That over there is " .. _DATA:GetMonster(green_kec.CurrentForm.Species).Name:ToLocal() .. " Storage.[pause=0] " .. kangaskhan:GetDisplayName() .. " will watch over any items we leave with her.")
	UI:WaitShowDialogue("If there's any items we don't want to lose,[pause=10] we can store them there.")
	UI:WaitShowDialogue("This is also where Sensei " .. CharacterEssentials.GetCharacterName("Ledian") .. " sent the items we had on us when we started training.")
	UI:WaitShowDialogue("If we want to get those back,[pause=10] we'll need to speak with " .. kangaskhan:GetDisplayName() .. ".")
	
	GAME:WaitFrames(20)
	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, sneasel, 4)
											GROUND:CharTurnToCharAnimated(hero, sneasel, 4) end)
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
	GeneralFunctions.CenterCamera({hero, partner}, GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 2)
	UI:WaitShowDialogue("I think there's a few other businesses in town,[pause=10] but these are the main ones anyway.")
	UI:WaitShowDialogue("We should take a closer look at some of the stores here,[pause=10] then after let's head over to the west side of town.")
	UI:WaitShowDialogue("That's where all the houses are.[pause=0] Most townfolk live over there.")
	UI:WaitShowDialogue("We should have time to do this before we head back to the guild for dinner.")
	UI:WaitShowDialogue("Alright,[pause=10] let's shop around,[pause=10] then meet some of the townfolk who live here in Metano Town!")
	
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
	
	SV.Chapter2.FinishedMarketIntro = true
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)
	GAME:CutsceneMode(false)
	
	
end


function metano_town_ch_2.NumelCutscene()


end


--Growlithe himself is behind the desk, so there's an obj on the desk that we interact with to actually talk with him
function metano_town_ch_2.Growlithe_Desk_Action(chara, activator)
	local growlithe = CH('Growlithe')
	GROUND:CharTurnToChar(growlithe, CH('PLAYER'))
	UI:SetSpeaker(growlithe)
	UI:WaitShowDialogue("What's that,[pause=10] ruff?[pause=0] You're looking for Ledian Dojo?")
	GROUND:EntTurn(growlithe, Direction.DownRight)
	
	local coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.DownRight, 4) end)
	local coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.DownRight, 4) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:MoveCamera(928, 1120, 180, false) end)

	TASK:JoinCoroutines({coro1, coro2, coro3})
	UI:WaitShowDialogue("It's through the ladder by the river over there!")
	GAME:WaitFrames(20)
	GROUND:EntTurn(growlithe, Direction.Right)
	local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(CH('Teammate1'), growlithe, 4) end)
	local coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(CH('PLAYER'), growlithe, 4) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:MoveCamera(0, 0, 180, true) end)

	TASK:JoinCoroutines({coro1, coro2, coro3})
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Just cross the bridge,[pause=10] then head east,[pause=10] ruff!")
	GROUND:EntTurn(growlithe, Direction.Right)
end







function metano_town_ch_2.Wooper_Siblings_Introduction()
	local dee = CH('Wooper_Girl')
	local dun = CH('Wooper_Boy')
	local electrike = CH('Electrike')
	local hero = CH('PLAYER')
	
	UI:SetSpeaker(dee)
	GROUND:CharTurnToCharAnimated(hero, dee, 4)
	UI:WaitShowDialogue("What do you wanna do today,[pause=10] " .. dun:GetDisplayName() .. "?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(dun)
	GROUND:CharTurnToCharAnimated(hero, dun, 4)
	UI:WaitShowDialogue("I dunno,[pause=10] what do you wanna do today,[pause=10] " .. dee:GetDisplayName() .. "?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(dee)
	GROUND:CharTurnToCharAnimated(hero, dee, 4)
	UI:WaitShowDialogue("I dunno,[pause=10] what do you wanna do today,[pause=10] " .. dun:GetDisplayName() .. "?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(dun)
	GROUND:CharTurnToCharAnimated(hero, dun, 4)
	UI:WaitShowDialogue("I dunno,[pause=10] what do you wanna do today,[pause=10] " .. dee:GetDisplayName() .. "?")
	GAME:WaitFrames(20)
	
	
	UI:SetSpeaker(dee)
	GROUND:CharTurnToCharAnimated(hero, dee, 4)
	UI:WaitShowTimedDialogue("I dunno,[pause=10] what do-", 40)
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(electrike)
	GeneralFunctions.EmoteAndPause(electrike, "Angry", true)
	GROUND:CharTurnToCharAnimated(hero, electrike, 4)
	UI:SetSpeakerEmotion("Angry")
	UI:WaitShowDialogue("Would you two PLEASE STOP.")
	UI:WaitShowDialogue("We've been here for hours already trying to figure out what we're doing today!")
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Can't you just pick something?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(dee)
	GROUND:CharTurnToCharAnimated(hero, dee, 4)
	UI:WaitShowDialogue("But I just wanna know what " .. dun:GetDisplayName() .. " wants to do today!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(dun)
	GROUND:CharTurnToCharAnimated(hero, dun, 4)
	UI:WaitShowDialogue("And I just wanna know what " .. dee:GetDisplayName() .. " wants to do today!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(dee)
	GROUND:CharTurnToCharAnimated(hero, dee, 4)
	UI:WaitShowDialogue("What do you wanna do today,[pause=10] " .. dun:GetDisplayName() .. "?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(dun)
	GROUND:CharTurnToCharAnimated(hero, dun, 4)
	UI:WaitShowDialogue("I dunno,[pause=10] what do you wanna do today,[pause=10] " .. dee:GetDisplayName() .. "?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(electrike)
	UI:SetSpeakerEmotion('Pain')
	GeneralFunctions.EmoteAndPause(electrike, "Sweatdrop", true)
	GROUND:CharTurnToCharAnimated(player, electrike, 4)
	UI:WaitShowDialogue("Ugh...")

	SV.Chapter2.WooperIntro = true

end

--dee
function metano_town_ch_2.Wooper_Girl_Action(chara, activator)
	local dee = chara
	if SV.Chapter2.WooperIntro then
		UI:SetSpeaker(dee)
		UI:WaitShowDialogue("I dunno,[pause=10] what do you wanna do today,[pause=10] " .. CharacterEssentials.GetCharacterName("Wooper_Boy") .. "?")
	else
		metano_town_ch_2.Wooper_Siblings_Introduction()
	end
end


--dun
function metano_town_ch_2.Wooper_Boy_Action(chara, activator)
	local dun = chara
	if SV.Chapter2.WooperIntro then
		UI:SetSpeaker(dun)
		UI:WaitShowDialogue("I dunno,[pause=10] what do you wanna do today,[pause=10] " .. CharacterEssentials.GetCharacterName("Wooper_Girl") .. "?")
	else
		metano_town_ch_2.Wooper_Siblings_Introduction()
	end
end

function metano_town_ch_2.Electrike_Action(chara, activator)
	local hero = CH('PLAYER')
	local electrike = chara
	local olddir = electrike.Direction
	if SV.Chapter2.WooperIntro then
		GROUND:CharTurnToChar(electrike, hero)
		UI:SetSpeaker(electrike)
		UI:SetSpeakerEmotion("Pain")
		UI:WaitShowDialogue("Help.")
		GROUND:EntTurn(electrike, olddir)
	else
		metano_town_ch_2.Wooper_Siblings_Introduction()
	end
end 
		

function metano_town_ch_2.Furret_Action(chara, activator)
	local furret = chara
	UI:SetSpeaker(furret)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Aaah...[pause=0] This is my favorite place to snooze~")
end 

function metano_town_ch_2.Meditite_Action(chara, activator)
	local meditite = chara
	UI:SetSpeaker(meditite)
	UI:WaitShowDialogue("..........")
	UI:WaitShowDialogue("..........")
	UI:WaitShowDialogue("...ZZZzzz...")
	UI:ResetSpeaker()
	SOUND:PlayBattleSE('EVT_Emote_Sweatdrop')
	GROUND:CharSetEmote(CH('PLAYER'), 9, 1)
	GROUND:CharSetEmote(CH('Teammate1'), 9, 1)
	UI:WaitShowDialogue("She appears to have fallen asleep while meditating.")
end 


function metano_town_ch_2.Lickitung_Action(chara, activator)
	local lickitung = chara
	local olddir = lickitung.Direction
	GROUND:CharTurnToChar(lickitung, CH('PLAYER'))
	UI:SetSpeaker(lickitung)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Apparently,[pause=10] the café is closed today...")
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("We came all this way from out of town for nothing,[pause=10] then?")
	GROUND:EntTurn(lickitung, olddir)
end 


function metano_town_ch_2.Gulpin_Action(chara, activator)
	local gulpin = chara
	local olddir = gulpin.Direction
	GROUND:CharTurnToChar(gulpin, CH('PLAYER'))
	UI:SetSpeaker(gulpin)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("...Huh?[pause=0] The café is closed...?")
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("...Oh...[pause=0] I won't have my precious smoothie today...")
	GROUND:EntTurn(gulpin, olddir)
end 


function metano_town_ch_2.Machamp_Luxray_Dialogue()
	local machamp = CH('Machamp')
	local luxray = CH('Luxray')
	local hero = CH('PLAYER')
	
	UI:SetSpeaker(machamp)
	UI:WaitShowDialogue("Hoo...[pause=0] I tell ya,[pause=10] that's gotta be real rough for " .. CharacterEssentials.GetCharacterName('Camerupt') .. ".")
	UI:WaitShowDialogue("After...[pause=0] Well,[pause=10] y'know...")
	UI:WaitShowDialogue("And now she's havin' trouble with " .. CharacterEssentials.GetCharacterName('Numel') .. "...")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(luxray)
	UI:WaitShowDialogue("Hmmph...[pause=0] It doesn't matter what's happened.")
	UI:WaitShowDialogue("If her son acts like that towards her,[pause=10] that's her own fault.")
	GAME:WaitFrames(20)
	
	GROUND:CharSetEmote(machamp, 5, 1)
	UI:SetSpeaker(machamp)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("I don't think it's that simple in this case,[pause=10] mate...")

end

function metano_town_ch_2.Machamp_Action(chara, activator)
	metano_town_ch_2.Machamp_Luxray_Dialogue()
end

function metano_town_ch_2.Luxray_Action(chara, activator)
	metano_town_ch_2.Machamp_Luxray_Dialogue()
end
	

function metano_town_ch_2.Nidorina_Action(chara, activator)
	UI:SetSpeaker(chara)
	local olddir = chara.Direction
	GROUND:CharTurnToChar(chara, CH('PLAYER'))
	UI:WaitShowDialogue("........Are you two in an adventuring team?")
	UI:WaitShowDialogue("........Lame.")
	GROUND:EntTurn(chara, olddir)
end
		
function metano_town_ch_2.Gloom_Action(chara, activator)
	UI:SetSpeaker(chara)
	local olddir = chara.Direction
	GROUND:CharTurnToChar(chara, CH('PLAYER'))
	UI:WaitShowDialogue("Wow![pause=0] Are you two adventurers?[pause=0] That's so...!")
	GROUND:CharSetEmote(chara, 5, 1)
	UI:WaitShowDialogue("Oh![pause=0] Erm...[pause=0] I mean...")
	UI:WaitShowDialogue("Pffft...[pause=0] Adventurers?[pause=0] That's...[pause=0] um...[pause=0] stupid!")
	GROUND:EntTurn(chara, olddir)
end 	
	

function metano_town_ch_2.Oddish_Action(chara, activator)
	UI:SetSpeaker(chara)
	local olddir = chara.Direction
	GROUND:CharTurnToChar(chara, CH('PLAYER'))
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("I wish " .. CharacterEssentials.GetCharacterName('Numel') .. " didn't have to go...")
	UI:WaitShowDialogue("I wanted to keep playing with him...")
	GROUND:EntTurn(chara, olddir)
end


function metano_town_ch_2.Floatzel_Action(chara, activator)
	UI:SetSpeaker(chara)
	local olddir = chara.Direction
	GROUND:CharTurnToChar(chara, CH('PLAYER'))
	UI:WaitShowDialogue("This here is the famous Metano Wishing Well.")
	UI:WaitShowDialogue("They say that if you throw in a " .. STRINGS:Format("\\uE024") .. " and make a wish,[pause=10] it comes true every time!")
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("But I'm starting to think that I was fed a fib...")
	UI:WaitShowDialogue("I've been here all day throwing " .. STRINGS:Format("\\uE024") .. " in and nothing's happened!")
	UI:WaitShowDialogue("Where's my big castle with a huge moat?[pause=0] Am I doing something wrong?")
	GROUND:EntTurn(chara, olddir)
end

function metano_town_ch_2.Azumarill_Action(chara, activator)
	UI:SetSpeaker(chara)
	local olddir = chara.Direction
	GROUND:CharTurnToChar(chara, CH('PLAYER'))
	UI:WaitShowDialogue(chara:GetDisplayName() .. " says that it is a beautiful day outside!")
	UI:WaitShowDialogue(chara:GetDisplayName() .. " may even take a swim in the river later![pause=0] " .. chara:GetDisplayName() .. " enjoys the cool water!")
	GROUND:EntTurn(chara, olddir)
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
	GROUND:CharSetEmote(chara, 4, 0)
	UI:SetSpeakerEmotion("Joyous")
	UI:WaitShowDialogue("I heard the good news![pause=0] Congrats on getting into the guild!")
	
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(chara, -1, 0)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Thanks " .. chara:GetDisplayName() .. "![pause=0] I'm very excited about it!")
	
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("How'd you manage to find out so quickly,[pause=10] anyway?")

	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Joyous")
	GROUND:CharSetEmote(chara, 4, 0)
	UI:WaitShowDialogue("Oh,[pause=10] you know me,[pause=10] I have my ways![pause=0] News doesn't stay from my ears for long!")

	GROUND:CharTurnToCharAnimated(chara, hero, 4)
	UI:SetSpeaker("Normal")
	UI:WaitShowDialogue("This must be your partner then![pause=0]")
	--]]
	UI:SetSpeaker(chara)
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
	GROUND:CharSetEmote(chara, 4, 0)
	UI:SetSpeakerEmotion("Joyous")
	UI:WaitShowDialogue("I heard the good news![pause=0] Congratulations on getting into the guild!")
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(chara, -1, 0)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Thanks,[pause=10] " .. chara:GetDisplayName() .. "![pause=0] I'm very excited about it!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(chara)
	UI:WaitShowDialogue("I'm excited for you too![pause=0] Apprenticing at the guild is a wonderful opportunity!")
	UI:WaitShowDialogue("Good luck with your future adventures![pause=0] Be sure to tell me all about them!")
	
	GROUND:CharEndAnim(chara)
	GROUND:CharEndAnim(hero)
	GROUND:CharEndAnim(partner)
	GROUND:EntTurn(chara, olddir)
end


function metano_town_ch_2.Roselia_Action(chara, activator)
	UI:SetSpeaker(chara)
	local olddir = chara.Direction
	GROUND:CharTurnToChar(chara, CH('PLAYER'))
	UI:WaitShowDialogue("Tah![pause=0] We're Team [color=#FFA5FF]Cadence[color]![pause=0] We love to dance!")
	UI:WaitShowDialogue('I like to think of "cadence" as "can-ya-dance"![pause=0] So,[pause=10] can-ya-dance with me? ' .. STRINGS:Format("\\u266A"))
	GROUND:EntTurn(chara, olddir)
end

function metano_town_ch_2.Spinda_Action(chara, activator)
	UI:SetSpeaker(chara)
	local olddir = chara.Direction
	GROUND:CharTurnToChar(chara, CH('PLAYER'))
	UI:WaitShowDialogue("Lah![pause=0] Come and strike a pose with me!")
	GROUND:EntTurn(chara, olddir)
end

function metano_town_ch_2.Ludicolo_Action(chara, activator)
	UI:SetSpeaker(chara)
	local olddir = chara.Direction
	GROUND:CharTurnToChar(chara, CH('PLAYER'))
	UI:WaitShowDialogue("Yah![pause=0] This is the best spot in town to dance!")
	UI:WaitShowDialogue("There's lots of open space and " .. CharacterEssentials.GetCharacterName("Chatot") .. " by the tree there plays the best music![pause=0] I can't get enough of his tunes!")
	GROUND:EntTurn(chara, olddir)
end
