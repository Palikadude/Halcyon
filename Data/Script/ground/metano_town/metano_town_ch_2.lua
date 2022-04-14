require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_town_ch_2 = {}

function metano_town_ch_2.SetupGround()

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







function metano_town.Wooper_Siblings_Introduction()
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
	local dee = CH('Wooper_Girl')
	local dun = CH('Wooper_Boy')
	if SV.Chapter2.WooperIntro then
		UI:SetSpeaker(dee)
		UI:WaitShowDialogue("I dunno,[pause=10] what do you wanna do today,[pause=10] " .. dun:GetDisplayName() .. "?")
	else
		metano_town_ch_2.Wooper_Siblings_Introduction()
	end
end


--dun
function metano_town_ch_2.Wooper_Boy_Action(chara, activator)
	local dee = CH('Wooper_Girl')
	local dun = CH('Wooper_Boy')
	if SV.Chapter2.WooperIntro then
		UI:SetSpeaker(dun)
		UI:WaitShowDialogue("I dunno,[pause=10] what do you wanna do today,[pause=10] " .. dee:GetDisplayName() .. "?")
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
	local furret = CH('Furret')
	UI:SetSpeaker(furret)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Aaah...[pause=0] This is my favorite place to snooze~")
end 

function metano_town_ch_2.Meditite_Action(chara, activator)
	local meditite = CH('Meditite')
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
	UI:WaitShowDialogue("Normal")
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
	UI:WaitShowDialogue("Wow![pause=0] You two are adventurers?[pause=0] That's so...!")
	GROUND:CharSetEmote(chara, 5, 1)
	UI:WaitShowDialogue("Oh![pause=0] Erm...[pause=0] I mean...")
	UI:WaitShowDialogue("Pffft...[pause=0] Adventurers?[pause=0] That's...[pause=0] Uh...[pause=0] Stupid...")
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
