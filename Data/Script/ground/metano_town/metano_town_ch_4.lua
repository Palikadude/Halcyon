require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_town_ch_4 = {}

function metano_town_ch_4.SetupGround()
	
		--trigger for audino showing you the signpost/cafe stuff
		if not SV.Chapter4.FinishedSignpostCutscene then
			local signBlock = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1), 
																RogueElements.Rect(1368, 584, 8, 56),
																RogueElements.Loc(0, 0), 
																true, 
																"Event_Trigger_1")
			
			signBlock:ReloadEvents()
			GAME:GetCurrentGround():AddTempObject(signBlock)
		end
		
	GAME:FadeIn(20)
end

function metano_town_ch_4.Event_Trigger_1_Touch(obj, activator)
	metano_town_ch_4.SignpostIntroductionCutscene()
end


function metano_town_ch_4.SignpostIntroductionCutscene()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local audino, cafe_dummy = CharacterEssentials.MakeCharactersFromList({
		{"Audino", 1152, 608, Direction.Right},
		{"Tail"},--dummy
	})
	
	GROUND:TeleportTo(cafe_dummy, 1118, 576, Direction.Down)
	--disable this cutscene's event trigger
	GROUND:Hide('Event_Trigger_1')
	
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:SetSpeaker(audino:GetDisplayName(), true, "", -1, "", RogueEssence.Data.Gender.Unknown)	
	
	local coro1 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue(partner:GetDisplayName() .. "![pause=30] " .. hero:GetDisplayName() .. "![pause=30] W-wait up!", 60) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) GeneralFunctions.EmoteAndPause(partner, "Exclaim", true) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(30) GeneralFunctions.EmoteAndPause(hero, "Notice", true) end)

	TASK:JoinCoroutines({coro1, coro2, coro3})

	GAME:WaitFrames(20)
	
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GeneralFunctions.EightWayMove(hero, 1336, 592, false, 1) 
											GROUND:CharAnimateTurnTo(hero, Direction.Left, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GeneralFunctions.EightWayMove(partner, 1336, 624, false, 1) 
											GROUND:CharAnimateTurnTo(partner, Direction.Left, 4) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(audino, 1304, 608, false, 2) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) 
												  GAME:MoveCamera(1328, 616, GeneralFunctions.CalculateCameraFrames(GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 1328, 616, 1), false) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	SOUND:PlayBattleSE('EVT_Emote_Sweating')
	GROUND:CharSetEmote(audino, "sweating", 1)
	UI:SetSpeaker(audino)
	UI:SetSpeakerEmotion("Pain")
	UI:WaitShowDialogue("Hurf...[pause=0] I c-caught up to you guys...[pause=0] Thank goodness...")
	GAME:WaitFrames(40)
	
	GeneralFunctions.ShakeHead(audino)
	GAME:WaitFrames(10)
	GeneralFunctions.Hop(audino)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Phew![pause=0] I'm glad I made it to you two before you headed out for today!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("Hey " .. audino:GetDisplayName() .. "![pause=0] What's going on?[pause=0] Why are you in such a hurry to catch us?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(audino)
	UI:WaitShowDialogue("You know how I've opened up my Assembly again,[pause=10]\nr-right?")
	--GROUND:EntTurn(audino, Direction.UpRight)
	UI:WaitShowDialogue("W-well,[pause=10] to go along with that,[pause=10] I've placed a signpost here by the way out of town!")
	
	GAME:WaitFrames(10)
	
	
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(36) GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(40) GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) GROUND:CharAnimateTurnTo(hero, Direction.Right, 4) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(audino, 1390, 608, false, 1)
											GROUND:CharAnimateTurnTo(audino, Direction.Up, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(16)
											GAME:MoveCamera(1352, 616, GeneralFunctions.CalculateCameraFrames(GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 1352, 616, 1), false) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	--todo: a hop at the end of this sentence
	UI:WaitShowDialogue("See?[pause=0] It's right here!")
	GAME:WaitFrames(10)
	GROUND:CharAnimateTurnTo(audino, Direction.Left, 4)
	UI:WaitShowDialogue("You can ring the bell on it and I'll come running from the guild so you can use the Assembly out here!")
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("M-my ears are really sensitive,[pause=10] so I'll hear it even all the way out here!")
	
	--GAME:WaitFrames(20)
	--coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(audino, Direction.Right, 4) end)
	--coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GROUND:CharAnimateTurnTo(partner, Direction.Left, 4) end)	
	--coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(12) GROUND:CharAnimateTurnTo(hero, Direction.Left, 4) end)	
	--TASK:JoinCoroutines({coro1, coro2, coro3})
	
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Just try not to overuse it,[pause=10] I do enough r-running around as it is!")
	GAME:WaitFrames(20)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
	GROUND:CharSetEmote(audino, "exclaim", 1)
	GAME:WaitFrames(40)
	UI:WaitShowDialogue("Oh![pause=0] One more thing!")
	GAME:WaitFrames(10)
	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Left, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:CharAnimateTurnTo(hero, Direction.Left, 4) end)
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.CenterCamera({cafe_dummy}, GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 3) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	UI:WaitShowDialogue("I spoke to " .. CharacterEssentials.GetCharacterName("Shuckle") .. " at the café earlier today.")
	UI:WaitShowDialogue("He said it was OK for teammates accompanying you on adventures to wait inside the café!")
	UI:WaitShowDialogue("So if y-you want to meet with your teammates before going out on an adventure,[pause=10] just visit the café!")
	
	GAME:WaitFrames(10)
	GROUND:EntTurn(hero, Direction.Right)
	GROUND:EntTurn(partner, Direction.Right)
	GROUND:EntTurn(audino, Direction.Left)
	GAME:MoveCamera(1352, 616, GeneralFunctions.CalculateCameraFrames(GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 1352, 616, 3), false)
	
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("That's all I had to share with you![pause=0] I hope this will all be u-useful for you two!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("It is![pause=0] Thank you for doing all this,[pause=10] it'll be a huge help for us!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(audino)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Oh![pause=0] It's no p-problem![pause=0] I'm just g-glad I can help out!")
	GAME:WaitFrames(20)
	
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("W-well,[pause=10] I'd better get back to the guild now.[pause=0] Good luck with your adventure today!")
	
	GAME:WaitFrames(10)
	
	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(audino, Direction.Left, 4)
											GROUND:MoveToPosition(audino, 1152, 608, false, 1) 
											GAME:GetCurrentGround():RemoveTempChar(audino) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(48) GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) GROUND:CharAnimateTurnTo(partner, Direction.Left, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(56) GROUND:CharAnimateTurnTo(hero, Direction.Left, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)
	GeneralFunctions.PanCamera()
	SV.Chapter4.FinishedSignpostCutscene = true
	GAME:CutsceneMode(false)	
	
	
end



