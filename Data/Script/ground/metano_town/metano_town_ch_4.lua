require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_town_ch_4 = {}

function metano_town_ch_4.SetupGround()
	GAME:FadeIn(20)
end



function metano_town_ch_4.SignpostIntroductionCutscene()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local audino = CharacterEssentials.MakeCharactersFromList({
		{"Audino", 1152, 608, Direction.Right}
	})
	
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:SetSpeaker(audino:GetDisplayName(), true, "", -1, "", RogueEssence.Data.Gender.Unknown)	
	
	local coro1 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue(parnter:GetDisplayName() .. "![pause=30] " .. hero:GetDisplayName() .. "![pause=30] W-wait up!", 60) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) GeneralFunctions.EmoteAndPause(partner, "Exclaim", true) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(30) GeneralFunctions.EmoteAndPause(hero, "Notice", true) end)

	TASK:JoinCoroutines({coro1, coro2, coro3})

	GAME:WaitFrames(20)
	
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(hero, 1336, 592, false, 1) 
											GROUND:CharAnimateTurnTo(hero, Direction.Left, 4) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, 1336, 624, false, 1) 
											GROUND:CharAnimateTurnTo(partner, Direction.Left, 4) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(audino, 1304, 608, false, 1) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	SOUND:PlayBattleSE('EVT_Emote_Sweating')
	GROUND:CharSetEmote(audino, "sweating", 1)
	UI:SetSpeaker(audino)
	UI:SetSpeakerEmotion("Pain")
	UI:WaitShowDialogue("Hurf...[pause=0] I c-caught up to you guys...[pause=0] Thank goodness...")
	GAME:WaitFrames(40)
	
	GeneralFunctions.ShakeHead(audino)
	GeneralFunctions.Hop(audino)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Phew![pause=0] I'm glad I made it to you two before you headed out for today!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("Hey " .. audino:GetDisplayName() .. "![pause=0] What's going on?[pause=0] Why are you in such a hurry to catch us?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(audino)
	UI:WaitShowDialogue("You know how I've opened up my Assembly again,[pause=10] r-right?")
	GROUND:EntTurn(audino, Direction.UpRight)
	UI:WaitShowDialogue("W-well,[pause=10] to go along with that,[pause=10] I've placed a signpost here by the way out of town!")
	
	GAME:WaitFrames(10)
	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4) end)
	TASK:JoinCoroutines({coro1, coro2})
	
	UI:WaitShowDialogue("You can ring the bell on it and I'll come running from the guild so you can use the Assembly here!")
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("M-my ears are really sensitive,[pause=10] so I'll hear it even all the way out here!")
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(audino, Direction.Right, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GROUND:CharAnimateTurnTo(partner, Direction.Left, 4) end)	
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(12) GROUND:CharAnimateTurnTo(hero, Direction.Left, 4) end)	
	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Just try not to overuse it,[pause=10] I do enough r-running around as it is!")
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
	GROUND:CharSetEmote(audino, "exclaim", 1)
	UI:WaitShowDialogue("Oh![pause=0] One more thing!")
	GAME:WaitFrames(20)
	
	GROUND:CharAnimateTurnTo(audino, Direction.UpLeft, 4)
	UI:WaitShowDialogue("I spoke to " .. CharacterEssentials.GetCharacterName("Shuckle") .. " at the café")

end