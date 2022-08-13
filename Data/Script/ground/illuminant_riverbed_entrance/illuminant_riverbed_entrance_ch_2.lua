require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

illuminant_riverbed_entrance_ch_2 = {}


function illuminant_riverbed_entrance_ch_2.FirstAttemptCutscene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GAME:CutsceneMode(true)
	SOUND:PlayBGM('Craggy Coast.ogg', false)
	AI:DisableCharacterAI(partner)

	GROUND:TeleportTo(hero, 148, 256, Direction.Up)
	GROUND:TeleportTo(partner, 116, 256, Direction.Up)
	
	GAME:FadeIn(40)
	GAME:WaitFrames(20)
	
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 116, 152, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:MoveToPosition(hero, 148, 152, false, 1) end)
	
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(10)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("I think the dungeon's entrance is ahead,[pause=10] just over this stretch of river.")
	UI:WaitShowDialogue(CharacterEssentials.GetCharacterName("Noctowl") .. " said that " .. CharacterEssentials.GetCharacterName("Numel") .. " probably headed for Luminous Spring at the end of the dungeon.")
	UI:WaitShowDialogue("We should aim to get to Luminous Spring as fast as possible so we can find him.")
	GAME:WaitFrames(20)
	
	UI:WaitShowDialogue("We can't let " .. CharacterEssentials.GetCharacterName("Camerupt") .. " or " .. CharacterEssentials.GetCharacterName("Numel") .. " down!")
	UI:WaitShowDialogue("Let's do our best,[pause=10] " .. hero:GetDisplayName() .. "!")
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(hero, "Nod") end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(partner, "Nod") end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, 128, 140, false, 1)
											GROUND:MoveToPosition(partner, 128, -24, false, 1) end)	
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(24)
											GeneralFunctions.EightWayMove(hero, 140, 152, false, 1)
											GeneralFunctions.EightWayMove(hero, 128, 140, false, 1)
											GROUND:MoveToPosition(hero, 128, -24, false, 1) end)

	TASK:JoinCoroutines({coro1, coro2})
	GAME:FadeOut(false, 40)
	GAME:CutsceneMode(false)
	SV.Chapter2.EnteredRiver = true 
	GAME:EnterDungeon("illuminant_riverbed", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)

end 

--a slightly different cutscene plays if you come back after failing to rescue numel
function illuminant_riverbed_entrance_ch_2.SubsequentAttemptCutscene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GAME:CutsceneMode(true)
	SOUND:PlayBGM('Craggy Coast.ogg', false)
	AI:DisableCharacterAI(partner)
	
	GROUND:TeleportTo(hero, 148, 256, Direction.Up)
	GROUND:TeleportTo(partner, 116, 256, Direction.Up)
	
	GAME:FadeIn(40)
	GAME:WaitFrames(20)
	
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 116, 152, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:MoveToPosition(hero, 148, 152, false, 1) end)
	
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(10)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("The dungeon's entrance is ahead,[pause=10] just over this stretch of river.")
	UI:WaitShowDialogue(CharacterEssentials.GetCharacterName("Noctowl") .. " said that " .. CharacterEssentials.GetCharacterName("Numel") .. " probably headed for Luminous Spring at the end of the dungeon.")
	UI:WaitShowDialogue("We have to make it to Luminous Spring this time so we can find him.")
	GAME:WaitFrames(20)
	
	UI:WaitShowDialogue("We can't let " .. CharacterEssentials.GetCharacterName("Camerupt") .. " or " .. CharacterEssentials.GetCharacterName("Numel") .. " down!")
	UI:WaitShowDialogue("Let's do it this time,[pause=10] " .. hero:GetDisplayName() .. "!")
	
	--GAME:WaitFrames(20)
	--coro1 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(hero, "Nod") end)
	--coro2 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(partner, "Nod") end)
	--TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, 128, 140, false, 1)
											GROUND:MoveToPosition(partner, 128, -24, false, 1) end)	
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(24)
											GeneralFunctions.EightWayMove(hero, 140, 152, false, 1)
											GeneralFunctions.EightWayMove(hero, 128, 140, false, 1)
											GROUND:MoveToPosition(hero, 128, -24, false, 1) end)

	TASK:JoinCoroutines({coro1, coro2})
	GAME:FadeOut(false, 40)
	GAME:CutsceneMode(false)
	GAME:EnterDungeon("illuminant_riverbed", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)

end 

return illuminant_riverbed_entrance_ch_2




