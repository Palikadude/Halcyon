require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

searing_crucible_ch_5 = {}



function searing_crucible_ch_5.FirstPreBossScene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local growlithe = CH('Teammate2')
	local zigzagoon = CH('Teammate3')

	--prep the slugmas now, actually add them in later when the animations play for them
	local slugma_boy = RogueEssence.Dungeon.MonsterID('slugma', 0, 'normal', Gender.Male)
	local slugma_girl = RogueEssence.Dungeon.MonsterID('slugma', 0, 'normal', Gender.Female)
	
	local slugma_boy_1 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(104, 240), Direction.Down, 'Slugma', 'Slugma_Boy_1')
	local slugma_boy_2 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(104, 240), Direction.Down, 'Slugma', 'Slugma_Boy_2')
	local slugma_boy_3 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(104, 240), Direction.Down, 'Slugma', 'Slugma_Boy_3')
	local slugma_boy_4 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(104, 240), Direction.Down, 'Slugma', 'Slugma_Boy_4')

	local slugma_girl_1 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(104, 240), Direction.Down, 'Slugma', 'Slugma_Girl_1')
	local slugma_girl_2 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(104, 240), Direction.Down, 'Slugma', 'Slugma_Girl_2')
	local slugma_girl_3 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(104, 240), Direction.Down, 'Slugma', 'Slugma_Girl_3')
	local slugma_girl_4 = RogueEssence.Ground.GroundChar(slugma_boy, RogueElements.Loc(104, 240), Direction.Down, 'Slugma', 'Slugma_Girl_4')
	
	slugma_boy_1:ReloadEvents()
	slugma_boy_2:ReloadEvents()
	slugma_boy_3:ReloadEvents()
	slugma_boy_4:ReloadEvents()
	slugma_girl_1:ReloadEvents()
	slugma_girl_2:ReloadEvents()
	slugma_girl_3:ReloadEvents()
	slugma_girl_4:ReloadEvents()
	
	
	
	--GAME:GetCurrentGround():AddTempChar(client)
	
	local magcargo = 
		CharacterEssentials.MakeCharactersFromList({
			{'Magcargo', 336, 112, Direction.Left}
		})
	
	GAME:WaitFrames(60)
	AI:DisableCharacterAI(partner)
	SOUND:StopBGM()
	
	GROUND:TeleportTo(hero, 188, 272, Direction.Up)
	GROUND:TeleportTo(partner, 156, 272, Direction.Up)
	GROUND:TeleportTo(growlithe, 156, 272, Direction.Up)
	GROUND:TeleportTo(zigzagoon, 156, 272, Direction.Up)
	GAME:MoveCamera(264, 336, 1, false)
		
	GAME:CutsceneMode(true)
	UI:ResetSpeaker()
	UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
	GAME:WaitFrames(60)
	UI:WaitHideTitle(20)
	GAME:FadeIn(40)
	
	
	local coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
												  GROUND:MoveToPosition(hero, 244, 312, false, 1)
											      end)
	local coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 268, 312, false, 1)
											      end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(18) 
												  GeneralFunctions.EightWayMoveRS(growlithe, 240, 344, false, 1)
												  GROUND:EntTurn(growlithe, Direction.Up)
											      end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(14)
												  GeneralFunctions.EightWayMoveRS(zigzagoon, 272, 344, false, 1)
												  GROUND:EntTurn(zigzagoon, Direction.Up)
											      end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	GAME:WaitFrames(10)
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.LookAround(hero, 3, 4, false, false, false, Direction.Up)
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) 
											GeneralFunctions.LookAround(partner, 3, 4, false, false, true, Direction.Right)
											end)
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.LookAround(growlithe, 3, 4, false, false, false, Direction.Left) 
											end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GeneralFunctions.LookAround(zigzagoon, 3, 4, false, false, true, Direction.Down)
											end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	GAME:WaitFrames(10)

	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Down, 4) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4) end)
	coro4 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("We've made it pretty deep...")
	UI:WaitShowDialogue("Is this the deepest section of the tunnel?")
	
	UI:SetSpeaker(zigzagoon)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("I would think so,[pause=10] with how hot it's gotten.")
	UI:SetSpeakerEmotion("Pain")
	GROUND:CharSetEmote(zigzagoon, "sweating", 1)
	UI:WaitShowDialogue("Urf,[pause=10] I don't know how much more of this heat I can take...")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Ruff...[pause=0] It's starting to get to me too.[pause=0] I feel like I could melt!")
	
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("I've been feeling it too.[pause=0] But we don't have much further to go!")
	UI:WaitShowDialogue("Let's get through here quickly so we can get out of this heat.")
	GAME:WaitFrames(10)
	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
											GROUND:MoveInDirection(partner, Direction.Up, 72, false, 1) end)			
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
											GROUND:MoveInDirection(hero, Direction.Up, 72, false, 1) end)		
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(24)
											GROUND:MoveInDirection(growlithe, Direction.Up, 72, false, 1) end)			
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(30)
											GROUND:MoveInDirection(zigzagoon, Direction.Up, 72, false, 1) end)	
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	--they're interrupted by the ground shaking, and the lava flowing (magcargo doesn't have influence over these lava flows)
	--having the lava show up first also makes magcargo believe you're the one causing them (you showed up and it acted up)

	--takes about 20f to react to slugma materialization. each frame of materialization is 3 frames
end

function searing_crucible_ch_5.SecondPreBossScene()

end

function searing_crucible_ch_5.DefeatedBoss()
	--growlithe is the one to bail the team out; important as it shows keeping him on the sidelines is a selfish, paranoid choice on the guildmaster's behalf

end

