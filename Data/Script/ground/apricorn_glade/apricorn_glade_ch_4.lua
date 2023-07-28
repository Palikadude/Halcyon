require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

apricorn_glade_ch_4 = {}


--first time you reach the end
--BEWARE ONIX
function apricorn_glade_ch_4.FirstArrivalCutscene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local team2 = CH('Teammate2')
	local team3 = CH('Teammate3')
	
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('apricorn_grove')
	
	GAME:WaitFrames(60)
	AI:DisableCharacterAI(partner)
	SOUND:StopBGM()
	
	GAME:MoveCamera(292, 432, 1, false)
	GROUND:TeleportTo(hero, 268, 576, Direction.Up)
	GROUND:TeleportTo(partner, 300, 576, Direction.Up)
	if team2 ~= nil then
		GROUND:TeleportTo(team2, 284, 608, Direction.Up)
	end
	if team3 ~= nil then
		GROUND:TeleportTo(team3, 316, 608, Direction.Up)
	end
	
	GAME:CutsceneMode(true)
	UI:ResetSpeaker()
	UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
	GAME:WaitFrames(60)
	UI:WaitHideTitle(20)
	GAME:FadeIn(40)
	SOUND:PlayBGM('In The Depths of the Pit.ogg', false)

	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 300, 456, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:MoveToPosition(hero, 268, 456, false, 1) end)
	local coro3 = TASK:BranchCoroutine(function() if team2 ~= nil then GAME:WaitFrames(14) GROUND:MoveToPosition(team2, 284, 488, false, 1) end end)
	local coro4 = TASK:BranchCoroutine(function() if team3 ~= nil then GAME:WaitFrames(18) GROUND:MoveToPosition(team3, 316, 488, false, 1) end end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	--GeneralFunctions.EmoteAndPause(partner, "Exclaim", true)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("Wow,[pause=10] this clearing is huge![pause=0] There's all kinds of different kinds of Apricorns here too!")
	GAME:WaitFrames(10)
		
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.MoveCamera(160, 432, 2) 
											GAME:WaitFrames(60)
											GeneralFunctions.MoveCamera(424, 432, 2)
											GAME:WaitFrames(60)
											GeneralFunctions.MoveCamera(292, 432, 2) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
											GAME:WaitFrames(182)
											GROUND:CharAnimateTurnTo(partner, Direction.Right, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(hero, Direction.Left, 4)
											GAME:WaitFrames(182)
											GROUND:CharAnimateTurnTo(hero, Direction.Right, 4) end)											
	coro4 = TASK:BranchCoroutine(function() if team2 ~= nil then
											GAME:WaitFrames(6)
											GROUND:CharAnimateTurnTo(team2, Direction.Left, 4)
											GAME:WaitFrames(182)
											GROUND:CharAnimateTurnTo(team2, Direction.Right, 4) end end)	
	local coro5 = TASK:BranchCoroutine(function() if team3 ~= nil then 
												  GAME:WaitFrames(10)
												  GROUND:CharAnimateTurnTo(team3, Direction.Left, 4)
												  GAME:WaitFrames(182)
												  GROUND:CharAnimateTurnTo(team3, Direction.Right, 4) end end)	
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	
	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
	coro2 = TASK:BranchCoroutine(function() if team2 ~= nil then  GROUND:CharAnimateTurnTo(team2, Direction.Up, 4) end end)
	coro3 = TASK:BranchCoroutine(function() if team3 ~= nil then GROUND:CharAnimateTurnTo(team3, Direction.UpLeft, 4) end end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	
	GeneralFunctions.Hop(partner)
	GROUND:CharSetAnim(partner, "Idle", true)
	GROUND:CharSetEmote(partner, "happy", 0)
	UI:WaitShowDialogue("This must be the deepest section of " .. zone:GetColoredName() .. "!")
	UI:WaitShowDialogue(hero:GetDisplayName() .. "![pause=0] Let's take a look around![pause=0] Maybe we'll find something special around here!")
	
	GAME:WaitFrames(20)
	GROUND:CharEndAnim(partner)
	GROUND:CharSetEmote(partner, "", 0)
	
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(32)
											GeneralFunctions.MoveCamera(292, 368, 1) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
											GROUND:MoveToPosition(partner, 300, 360, false, 1)
											GeneralFunctions.LookAround(partner, 3, 4, true, false, false, Direction.Right) end)								
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
											GROUND:MoveToPosition(hero, 268, 360, false, 1) 
											GeneralFunctions.LookAround(hero, 3 , 4, true, false, false, Direction.Left) end)
	coro4 = TASK:BranchCoroutine(function() if team2 ~= nil then 
											GAME:WaitFrames(22)
											GROUND:MoveToPosition(team2, 284, 392, false, 1) 
											GeneralFunctions.LookAround(team2, 3 , 4, true, false, false, Direction.Down) end end)
	coro5 = TASK:BranchCoroutine(function() if team3 ~= nil then 
											GAME:WaitFrames(26)
											GROUND:MoveToPosition(team3, 316, 392, 1) 
											GeneralFunctions.LookAround(team3, 3 , 4, true, false, false, Direction.DownLeft) end end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	GeneralFunctions.EmoteAndPause(partner, "Exclaim", true)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Wow![pause=0] " .. hero:GetDisplayName() .. ",[pause=10] look at that!")
	GAME:WaitFrames(20)
	
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.MoveCamera(292, 136, 2) 
											GAME:WaitFrames(120)
											GeneralFunctions.MoveCamera(292, 224, 2) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(240) 
											GROUND:MoveToPosition(partner, 300, 248, false, 1) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
											GAME:WaitFrames(240)
											GROUND:MoveToPosition(hero, 268, 248, false, 1) end)
	coro4 = TASK:BranchCoroutine(function() if team2 ~= nil then
											GAME:WaitFrames(2)
											GROUND:CharAnimateTurnTo(team2, Direction.Up, 4)
											GAME:WaitFrames(240)
											GROUND:MoveToPosition(team2, 284, 280, false, 1) end end)											
	coro5 = TASK:BranchCoroutine(function() if team3 ~= nil then 
											GAME:WaitFrames(6)
											GROUND:CharAnimateTurnTo(team3, Direction.Up, 4)
											GAME:WaitFrames(240)
											GROUND:MoveToPosition(team3, 316, 280, false, 1) end end)											
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	
	GAME:WaitFrames(10)
	UI:SetSpeakerEmotion("Inspired")
	GeneralFunctions.DoubleHop(partner)
	UI:WaitShowDialogue("This tree is huge![pause=0] And so are the Apricorns on it!")
	GAME:WaitFrames(10)
	
	GROUND:CharAnimateTurnTo(partner, hero, 4)
	GROUND:CharAnimateTurnTo(hero, partner, 4)
	
	UI:WaitShowDialogue("This is an amazing find,[pause=10] don't you think?[pause=0] We should take one of these back to the Guildmaster!")
	
	GAME:WaitFrames(20)
	--coro1 = TASK:BranchCoroutine(function() GeneralFunctions.MoveCamera(292, 224, 1) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, 284, 212, false, 1) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end)									
	TASK:JoinCoroutines({coro2, coro3})
	
	
	GROUND:CharSetEmote(partner, "exclaim", 1)
	SOUND:PlayBattleSE('EVT_Emote_Exclaim_2")
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Oh!")
	GROUND:CharSetAction(partner, RogueEssence.Ground.PoseGroundAction(partner.Position, partner.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("LookUp")))
	GAME:WaitFrames(40)
	
	GROUND:GROUND:AnimateInDirection(partner, "Walk", Direction.Up, Direction.Down, 16, 1, 1) 
	GeneralFunctions.EmoteAndPause(partner, "Sweatdrop", true)
	
	GROUND:CharAnimateTurnTo(partner, hero, 4)
	GROUND:CharAnimateTurnTo(hero, partner, 4)
	
	GROUND:CharSetEmote(partner, "sweating", 1)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Um...[pause=0] I just realized...[pause=0] How exactly are we going to get the Apricorn down from up there?")
	

end 


--coming back if you failed to have 4 mons
function apricorn_glade_ch_4.SubsequentArrivalCutscene()

end

--subscene of picking the apricorn off the tree 
--BEWARE OF ONIX!
--TODO: Order based on weight, base of the tower and the spacing of the characters based on height of the sprite, change render order of pokemon in the stack so it looks right
function apricorn_glade_ch_4.PickApricorn()

end 

--subscene: you dont have enough mons to get the apricorn and must turn back. Either to leave the dungeon or go back in at floor 8
function apricorn_glade_ch_4.TurnBack()

end







return apricorn_glade_ch_4