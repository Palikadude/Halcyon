require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

crooked_cavern_entrance_ch_3 = {}


function crooked_cavern_entrance_ch_3.FirstAttemptCutscene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GAME:CutsceneMode(true)
	SOUND:PlayBGM('Mt. Horn.ogg', false)
	AI:DisableCharacterAI(partner)

	GROUND:TeleportTo(hero, 136, 256, Direction.Up)
	GROUND:TeleportTo(partner, 168, 256, Direction.Up)
	
	GAME:FadeIn(40)
	GAME:WaitFrames(20)
	
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 168, 168, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:MoveToPosition(hero, 136, 168, false, 1) end)
	
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("Looks like this is the place.")
	
	GAME:WaitFrames(10)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	
	UI:WaitShowDialogue("According to the wanted poster,[pause=10] that outlaw " ..  CharacterEssentials.GetCharacterName("Sandile") .. " is hiding in the depths of this dungeon.")
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(CharacterEssentials.GetCharacterName("Mareep") .. " said that other outlaws hide out here too.[pause=0] It'll probably be pretty dangerous...")
	GAME:WaitFrames(20)
	
	GeneralFunctions.DoubleHop(partner)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("But they won't stop us![pause=0] We'll prove to " .. CharacterEssentials.GetCharacterName('Cranidos') .. " that we're capable![pause=0] This outlaw is as good as caught!")
	UI:WaitShowDialogue("Let's give it our all as always,[pause=10] " .. hero:GetDisplayName() .. "!")
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(hero, "Nod") end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(partner, "Nod") end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(24)
											GROUND:MoveToPosition(partner, 152, 152, false, 1)
											GROUND:MoveToPosition(partner, 152, 72, false, 1) end)	
	coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 152, 152, false, 1)
											GROUND:MoveToPosition(hero, 152, 72, false, 1) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(40) GAME:FadeOut(false, 40) end)

	TASK:JoinCoroutines({coro1, coro2, coro3})
	GAME:CutsceneMode(false)
	SV.Chapter3.EnteredCavern = true 
	GAME:EnterDungeon(57, 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)

end 

return crooked_cavern_entrance_ch_3




