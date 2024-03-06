require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

apricorn_glade_ch_4 = {}


--first time you reach the end
--This whole thing is a mess, honestly. This was a cursed idea from the beginning. Too many exceptions and bullshit to deal with.
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
	
	
	--Flag that the glade has been reached. This sort of stuff is usually done at the end of scripts, but it's wiser to put it up here.
	SV.Chapter4.ReachedGlade = true
	
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
	UI:WaitShowDialogue("Wow,[pause=10] this clearing is huge![pause=0] There's all kinds of different Apricorns here too!")
	GAME:WaitFrames(10)
		
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.MoveCamera(160, 432, 2) 
											GAME:WaitFrames(60)
											GeneralFunctions.MoveCamera(424, 432, 2)
											GAME:WaitFrames(60)
											GeneralFunctions.MoveCamera(292, 432, 2) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
											GAME:WaitFrames(170)
											GROUND:CharAnimateTurnTo(partner, Direction.Right, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(hero, Direction.Left, 4)
											GAME:WaitFrames(170)
											GROUND:CharAnimateTurnTo(hero, Direction.Right, 4) end)											
	coro4 = TASK:BranchCoroutine(function() if team2 ~= nil then
											GAME:WaitFrames(6)
											GROUND:CharAnimateTurnTo(team2, Direction.Left, 4)
											GAME:WaitFrames(170)
											GROUND:CharAnimateTurnTo(team2, Direction.Right, 4) end end)	
	local coro5 = TASK:BranchCoroutine(function() if team3 ~= nil then 
												  GAME:WaitFrames(10)
												  GROUND:CharAnimateTurnTo(team3, Direction.Left, 4)
												  GAME:WaitFrames(170)
												  GROUND:CharAnimateTurnTo(team3, Direction.Right, 4) end end)	
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	
	GAME:WaitFrames(10)
	
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
											GROUND:MoveToPosition(team3, 316, 392, false, 1) 
											GeneralFunctions.LookAround(team3, 3 , 4, true, false, false, Direction.DownLeft) end end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(partner, "Exclaim", true)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Wow![pause=0] " .. hero:GetDisplayName() .. ",[pause=10] look at that!")
	GAME:WaitFrames(20)
	
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.MoveCamera(292, 136, 2) 
											GAME:WaitFrames(120)
											GeneralFunctions.MoveCamera(292, 224, 2) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(220) 
											GROUND:MoveToPosition(partner, 300, 248, false, 1) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
											GAME:WaitFrames(220)
											GROUND:MoveToPosition(hero, 268, 248, false, 1) end)
	coro4 = TASK:BranchCoroutine(function() if team2 ~= nil then
											GAME:WaitFrames(2)
											GROUND:CharAnimateTurnTo(team2, Direction.Up, 4)
											GAME:WaitFrames(220)
											GROUND:MoveToPosition(team2, 284, 280, false, 1) end end)											
	coro5 = TASK:BranchCoroutine(function() if team3 ~= nil then 
											GAME:WaitFrames(6)
											GROUND:CharAnimateTurnTo(team3, Direction.Up, 4)
											GAME:WaitFrames(220)
											GROUND:MoveToPosition(team3, 316, 280, false, 1) end end)											
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	
	GAME:WaitFrames(10)
	UI:SetSpeakerEmotion("Inspired")
	GeneralFunctions.DoubleHop(partner)
	UI:WaitShowDialogue("This tree is huge![pause=0] And so are the Apricorns on it!")
	GAME:WaitFrames(10)
	
	GROUND:CharAnimateTurnTo(partner, hero, 4)
	GROUND:CharAnimateTurnTo(hero, partner, 4)
	
	UI:WaitShowDialogue("This is an amazing find,[pause=10] don't you think?[pause=0] We should take one of these Apricorns back to the Guildmaster!")
	
	GAME:WaitFrames(20)
	--coro1 = TASK:BranchCoroutine(function() GeneralFunctions.MoveCamera(292, 224, 1) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, 284, 212, false, 1) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end)									
	TASK:JoinCoroutines({coro2, coro3})
	
	
	GAME:WaitFrames(10)
	GROUND:CharSetEmote(partner, "exclaim", 1)
	SOUND:PlayBattleSE('EVT_Emote_Exclaim_2')
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Oh!")
	GROUND:CharSetAction(partner, RogueEssence.Ground.PoseGroundAction(partner.Position, partner.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("LookUp")))
	GAME:WaitFrames(120)
	
	GROUND:AnimateInDirection(partner, "Walk", Direction.Up, Direction.Down, 16, 1, 1) 
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(partner, "Sweatdrop", true)
	
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	
	GROUND:CharSetEmote(partner, "sweating", 1)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Um...[pause=0] I just realized...[pause=0] How exactly are we going to get an Apricorn down from up there?")
	GAME:WaitFrames(20)
	
	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	GROUND:EntTurn(hero, Direction.Up)
	GROUND:MoveToPosition(partner, 284, 204, false, 1) 
	GAME:WaitFrames(10)
	
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Maybe I can try to shake one loose?")
	GAME:WaitFrames(30)
	
	GROUND:CharSetAnim(partner, "Pull", true)
	GAME:WaitFrames(40)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("Hrrmph![pause=0] C'mon,[pause=10] Apricorn![pause=0] Get...[pause=30] down here!")
	GAME:WaitFrames(20)
	GROUND:CharEndAnim(partner)
	
	GAME:WaitFrames(10)
	GROUND:AnimateInDirection(partner, "Walk", Direction.Up, Direction.Down, 24, 1, 1) 
	UI:SetSpeakerEmotion("Pain")
	GeneralFunctions.EmoteAndPause(partner, "Sweating", true)
	UI:WaitShowDialogue("That didn't seem to do anything.[pause=0] I don't even think any of the Apricorns moved at all!")
	
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)	
	
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Those Apricorns are on there good.[pause=0] I think even if we somehow climbed or flew up there...[br]...We wouldn't be able to get a solid enough grip to get one loose!")
	UI:WaitShowDialogue("I bet we need our feet grounded to get a good enough grip to yank one free!")
	
	GAME:WaitFrames(60)
	GeneralFunctions.EmoteAndPause(partner, "Exclaim", true)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Oh,[pause=10] I have an idea!")
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(hero:GetDisplayName() .. ",[pause=10] could you step over to the tree and give me a boost?")
	
	GAME:WaitFrames(20)
	--hero walks up, partner jumps on their back, hero grunts in exertion. Partner gets closer to the apricorn, but still too far. Needs more in the tower of power
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 268, 224, false, 1)
											GeneralFunctions.EightWayMove(hero, 284, 204, false, 1)
											GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end)	
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(partner, hero, 4, Direction.Up) end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(20)
	--ActionPointTypes = Shadow, Center, Head, LeftHand, RightHand
	partner.CollisionDisabled = true
	--GROUND:AnimateInDirection(partner, "Walk", Direction.Up, Direction.Down, 12, 1, 1)
	--GAME:WaitFrames(10)
	GROUND:MoveInDirection(partner, Direction.Up, 3, false, 1)
	
	--LocHeight is the character's height relative to their shadow
	local partner_anim = RogueEssence.Content.GraphicsManager.GetAnimIndex("None")
	local frameAction = RogueEssence.Ground.IdleAnimGroundAction(partner.Position, 0, Direction.Up, partner_anim, false)
  
	local hero_center = GROUND:CharGetAnimPoint(hero, RogueEssence.Content.ActionPointType.Center)
	local hero_shadow = GROUND:CharGetAnimPoint(hero, RogueEssence.Content.ActionPointType.Shadow)
	local hero_shoulders = hero_shadow.Y - hero_center.Y + 6 -- an approximation of their "shoulders"
	coro1 = TASK:BranchCoroutine(function() SOUND:PlayBattleSE('_UNK_EVT_010')--jump sfx
											GROUND:AnimateInDirection(partner, "Hop", Direction.Up, Direction.Up, 15, 1, 1)
											frameAction = RogueEssence.Ground.IdleAnimGroundAction(partner.Position, 23, Direction.Up, partner_anim, false)
											--Mouth gives inconsistent results, center + an amount seems more consistent.
											GROUND:ActionToPosition(partner, frameAction, hero.MapLoc.X, hero.MapLoc.Y + 1, 1, 1, hero_shoulders)
											GROUND:CharSetEmote(hero, "shock", 1)
											--GROUND:CharSetAction(partner, RogueEssence.Ground.FrameGroundAction(partner.Position, partner.LocHeight, Direction.Up, partner_anim, 0))
											end)
	coro2 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue("Hup!", 30) end)
	TASK:JoinCoroutines({coro1, coro2})

	GAME:WaitFrames(60)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Hmm...[pause=0] It's still too far away.")
	
	GAME:WaitFrames(20)
	SOUND:PlayBattleSE('_UNK_EVT_010')
	--jumping off. Did my best to give it the look of a parabola, but...
	frameAction = RogueEssence.Ground.IdleAnimGroundAction(partner.Position, hero_shoulders, Direction.Up, partner_anim, false)
	GROUND:ActionToPosition(partner, frameAction, hero.MapLoc.X, hero.MapLoc.Y + 5, 1, 1, hero_shoulders + 6)
	frameAction = RogueEssence.Ground.IdleAnimGroundAction(partner.Position, hero_shoulders+6, Direction.Up, partner_anim, false)
	GROUND:ActionToPosition(partner, frameAction, hero.MapLoc.X, hero.MapLoc.Y + 9, 1, 1, hero_shoulders + 6)
	frameAction = RogueEssence.Ground.IdleAnimGroundAction(partner.Position, hero_shoulders+6, Direction.Up, partner_anim, false)
	GROUND:ActionToPosition(partner, frameAction, hero.MapLoc.X, hero.MapLoc.Y + 13, 1, 1, hero_shoulders)
	frameAction = RogueEssence.Ground.IdleAnimGroundAction(partner.Position, hero_shoulders, Direction.Up, partner_anim, false)
	GROUND:ActionToPosition(partner, frameAction, hero.MapLoc.X, hero.MapLoc.Y + 19, 1, 1, 0)

	coro1 = TASK:BranchCoroutine(function() GROUND:AnimateInDirection(partner, "Walk", Direction.Up, Direction.Down, 12, 1, 1) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
	TASK:JoinCoroutines({coro1, coro2})

	--GROUND:CharSetAction(partner, RogueEssence.Ground.HopGroundAction(partner.Position, partner.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex('None'), 16, 16))
	--GROUND:MoveToPosition(partner, 284, 188, false, 2)
	
	GAME:WaitFrames(10)
	UI:WaitShowDialogue("We'd need more than just the two of us if we want to reach that low-hanging Apricorn.")
	GAME:WaitFrames(20)
	apricorn_glade_ch_4.PartyCountCheck()			
	
	
	
	
end 

function apricorn_glade_ch_4.AnimationTest()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GAME:CutsceneMode(true)
	GROUND:TeleportTo(hero, 284, 204, Direction.Up)
	GROUND:TeleportTo(partner, 284, 228, Direction.Up)
	--ActionPointTypes = Shadow, Center, Head, LeftHand, RightHand
	partner.CollisionDisabled = true
	--GROUND:AnimateInDirection(partner, "Walk", Direction.Up, Direction.Down, 12, 1, 1)
	--GAME:WaitFrames(10)
	GROUND:MoveInDirection(partner, Direction.Up, 3, false, 1)
	
	--LocHeight is the character's height relative to their shadow
	local partner_anim = RogueEssence.Content.GraphicsManager.GetAnimIndex("None")
	local frameAction = RogueEssence.Ground.IdleAnimGroundAction(partner.Position, 0, Direction.Up, partner_anim, false)
  
	local hero_center = GROUND:CharGetAnimPoint(hero, RogueEssence.Content.ActionPointType.Center)
	local hero_shadow = GROUND:CharGetAnimPoint(hero, RogueEssence.Content.ActionPointType.Shadow)
	local hero_shoulders = hero_shadow.Y - hero_center.Y + 6 -- an approximation of their "shoulders"
	coro1 = TASK:BranchCoroutine(function() SOUND:PlayBattleSE('_UNK_EVT_010')--jump sfx
											GROUND:AnimateInDirection(partner, "Hop", Direction.Up, Direction.Up, 15, 1, 1)
											frameAction = RogueEssence.Ground.IdleAnimGroundAction(partner.Position, 23, Direction.Up, partner_anim, false)
											--Mouth gives inconsistent results, center + an amount seems more consistent.
											GROUND:ActionToPosition(partner, frameAction, hero.MapLoc.X, hero.MapLoc.Y + 1, 1, 1, hero_shoulders)
											--GROUND:CharSetAction(partner, RogueEssence.Ground.FrameGroundAction(partner.Position, partner.LocHeight, Direction.Up, partner_anim, 0))
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:CharSetEmote(hero, "shock", 1) end)
	coro3 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue("Hup!", 30) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	GAME:WaitFrames(20)
	
	--frameAction = RogueEssence.Ground.IdleAnimGroundAction(partner.Position, hero_shoulders, Direction.Up, partner_anim, false)
	--GROUND:ActionToPosition(partner, frameAction, hero.MapLoc.X, hero.MapLoc.Y + 1, 1, 1, hero_shadow.Y - hero_center.Y + 6)
	
	--jumping off. Did my best to give it the look of a parabola, but...
	frameAction = RogueEssence.Ground.IdleAnimGroundAction(partner.Position, hero_shoulders, Direction.Up, partner_anim, false)
	GROUND:ActionToPosition(partner, frameAction, hero.MapLoc.X, hero.MapLoc.Y + 5, 1, 1, hero_shoulders + 6)
	frameAction = RogueEssence.Ground.IdleAnimGroundAction(partner.Position, hero_shoulders+6, Direction.Up, partner_anim, false)
	GROUND:ActionToPosition(partner, frameAction, hero.MapLoc.X, hero.MapLoc.Y + 9, 1, 1, hero_shoulders + 6)
	frameAction = RogueEssence.Ground.IdleAnimGroundAction(partner.Position, hero_shoulders+6, Direction.Up, partner_anim, false)
	GROUND:ActionToPosition(partner, frameAction, hero.MapLoc.X, hero.MapLoc.Y + 13, 1, 1, hero_shoulders)
	frameAction = RogueEssence.Ground.IdleAnimGroundAction(partner.Position, hero_shoulders, Direction.Up, partner_anim, false)
	GROUND:ActionToPosition(partner, frameAction, hero.MapLoc.X, hero.MapLoc.Y + 19, 1, 1, 0)
  

end 


function apricorn_glade_ch_4.AnimationTest2()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GAME:CutsceneMode(true)
	--ActionPointTypes = Shadow, Center, Head, LeftHand, RightHand
	partner.CollisionDisabled = true
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local team2 = CH('Teammate2')
	local team3 = CH('Teammate3')
	local apricorn = OBJ('Apricorn_Scene')
	
	GAME:MoveCamera(292, 192, 1, false)
	AI:DisableCharacterAI(partner)
	GROUND:TeleportTo(partner, 276, 160, Direction.Up)
	GAME:WaitFrames(40)
	
	
	---Figure out if we this is an onix situation. If not, then order by weight, heaviest at the bottom. Partner is always at the top, however.
	local team2species = 'default'
	local team3species = 'default'
	local onix_teammate = nil
	
	if team2 ~= nil then team2species = team2.CurrentForm.Species end 
	if team3 ~= nil then team3species = team3.CurrentForm.Species end 
	
	if team2species == 'onix' then 
		onix_teammate = team2
	elseif team3species == 'onix' then
		onix_teammate = team3
	end
	
		
	
	--Determine the order of the bottom 3 of the stack. TODO: Improve by teleporting based on heights of characters
	local stack_order = {hero, team2, team3}
	table.sort(stack_order, apricorn_glade_ch_4.WeightCompare)
	GROUND:TeleportTo(stack_order[1], 276, 160, Direction.Up)
	GROUND:TeleportTo(stack_order[2], 276, 160, Direction.Up)
	GROUND:TeleportTo(stack_order[3], 276, 160, Direction.Up)
	
	local stack_1_head = GROUND:CharGetAnimPoint(stack_order[1], RogueEssence.Content.ActionPointType.Head)
	local stack_1_shadow = GROUND:CharGetAnimPoint(stack_order[1], RogueEssence.Content.ActionPointType.Shadow)
	local stack_1_center = GROUND:CharGetAnimPoint(stack_order[1], RogueEssence.Content.ActionPointType.Center)
	local stack_2_head = GROUND:CharGetAnimPoint(stack_order[2], RogueEssence.Content.ActionPointType.Head)
	local stack_2_shadow = GROUND:CharGetAnimPoint(stack_order[2], RogueEssence.Content.ActionPointType.Shadow)
	local stack_2_center = GROUND:CharGetAnimPoint(stack_order[2], RogueEssence.Content.ActionPointType.Center)
	local stack_3_head = GROUND:CharGetAnimPoint(stack_order[3], RogueEssence.Content.ActionPointType.Head)
	local stack_3_shadow = GROUND:CharGetAnimPoint(stack_order[3], RogueEssence.Content.ActionPointType.Shadow)		
	local stack_3_center = GROUND:CharGetAnimPoint(stack_order[3], RogueEssence.Content.ActionPointType.Center)		
	
	local stack_1_height = math.max(stack_1_shadow.Y - stack_1_head.Y, stack_1_shadow.Y - stack_1_center.Y + 6, 13)
	local stack_2_height = math.max(stack_2_shadow.Y - stack_2_head.Y, stack_2_shadow.Y - stack_2_center.Y + 6, 13)
	local stack_3_height = math.max(stack_3_shadow.Y - stack_3_head.Y, stack_3_shadow.Y - stack_3_center.Y + 6, 13)

	print(stack_1_height)
	print(stack_2_height)
	print(stack_3_height)
	--bottom member of totem
	GROUND:TeleportTo(stack_order[3], partner.Position.X, partner.Position.Y + stack_1_height + stack_2_height + stack_3_height, Direction.Up)
	  
	local animId = RogueEssence.Content.GraphicsManager.GetAnimIndex("None")
	local frameAction = RogueEssence.Ground.IdleAnimGroundAction(stack_order[2].Position, 0, Direction.Up, animId, false)
	GROUND:ActionToPosition(stack_order[2], frameAction, stack_order[3].MapLoc.X, stack_order[3].MapLoc.Y + 1, 1, 2, stack_3_height)

	frameAction = RogueEssence.Ground.IdleAnimGroundAction(stack_order[1].Position, 0, Direction.Up, animId, false)
	GROUND:ActionToPosition(stack_order[1], frameAction, stack_order[3].MapLoc.X, stack_order[3].MapLoc.Y + 2, 1, 2, stack_3_height + stack_2_height)
	
	frameAction = RogueEssence.Ground.IdleAnimGroundAction(partner.Position, 0, Direction.Up, animId, false)
	GROUND:ActionToPosition(partner, frameAction, stack_order[3].MapLoc.X, stack_order[3].MapLoc.Y + 3, 1, 2, stack_3_height + stack_2_height + stack_1_height)	

end

function apricorn_glade_ch_4.PartyCountCheck()
	local party_count = GAME:GetPlayerPartyCount()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local team2 = CH('Teammate2')
	local team3 = CH('Teammate3')
	local team2species = 'default'
	local team3species = 'default'
	local onix_teammate = nil
	
	if team2 ~= nil then team2species = team2.CurrentForm.Species end 
	if team3 ~= nil then team3species = team3.CurrentForm.Species end 
	
	if team2species == 'onix' then 
		onix_teammate = team2
	elseif team3species == 'onix' then
		onix_teammate = team3
	end
	
	local fail_condition = ""
	
	--check if any illegal mons/combos are here. Flying-onl and fish mons and diglett are not allowed, unless you also have an onix (as onix does all the work)
	--No way to check for "flying/fish" attribute for cutscenes. Hardcode check for mons that are like that that are available by now.
		
	if team2species == "goldeen" or team3species == "goldeen" then
		fail_condition = 'goldeen'
	elseif team2species == "barboach" or team3species == "barboach" then
		fail_condition = 'barboach'
	elseif team2species == "zubat" or team3species == "zubat" then
		fail_condition = 'zubat'
	elseif team2species == "diglett" or team3species == "diglett" then
		fail_condition = 'diglett'	
	end
	
	
	UI:SetSpeaker(partner)
	--having an onix, since they're so tall, lets you skip having a 4th member
	if onix_teammate ~= nil then
		local coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Down, 4) end)
		local coro2 = TASK:BranchCoroutine(function()
			GAME:WaitFrames(10)
			--hero should turn down as opposed to towards if team2 is onix because of the way this all works out.
			if team3species == 'onix' then
				GROUND:CharTurnToCharAnimated(hero, onix_teammate, 4)
			else
				GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
			end
		end)
		TASK:JoinCoroutines({coro1, coro2})
			
		--GROUND:CharTurnToCharAnimated(onix_teammate, partner, 4)
		UI:WaitShowDialogue("I think with a large teammate like " .. onix_teammate:GetDisplayName() .. ",[pause=10] we should be able to reach that Apricorn!")
		UI:WaitShowDialogue("Mind coming over here and giving me a boost,[pause=10] " .. onix_teammate:GetDisplayName() .. "?")
		GAME:WaitFrames(20)
		SOUND:FadeOutBGM(40)
		GAME:FadeOut(false, 40)
		apricorn_glade_ch_4.PickApricorn()
	elseif party_count == 1 then
		--should never happen
		UI:SetSpeakerEmotion("Surprised")
		UI:WaitShowDialogue("How'd you even manage this?[pause=0] Only one member in the party?")
		UI:WaitShowDialogue("Tell Palika how you managed this. Now enjoy your softlock :)")
	elseif party_count > 1 and party_count < 4 then		
		GROUND:CharTurnToCharAnimated(partner, hero, 4)
		GROUND:CharTurnToCharAnimated(hero, partner, 4)
		UI:SetSpeakerEmotion("Worried")
		if party_count == 2 then 
			UI:WaitShowDialogue("With just us two here,[pause=10] I don't think it'll be possible to get that Apricorn off the tree.")
			UI:WaitShowDialogue("We'll need a lot more help if we want to bring it back to the Guildmaster.")
		else
			UI:WaitShowDialogue("There's three of us here,[pause=10] but I still don't think that'll be enough.")
			UI:WaitShowDialogue("I think we'll need a full team if we want to bring that Apricorn back to the Guildmaster.")
			if fail_condition ~= '' then 
				UI:WaitShowDialogue("Besides,[pause=10] our teammate doesn't have an appropriate body type for this sort of thing.")
			end
		end
		GAME:WaitFrames(20)
		apricorn_glade_ch_4.TurnBack()
	elseif fail_condition ~= '' then	
		GROUND:CharTurnToCharAnimated(partner, hero, 4)
		GROUND:CharTurnToCharAnimated(hero, partner, 4)
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue("We have four of us here,[pause=10] but some of our teammates aren't suited to stacking up in a totem...")
		UI:WaitShowDialogue("We'll need Pokémon with more appropriate body types for laddering.")
		GAME:WaitFrames(20)
		apricorn_glade_ch_4.TurnBack()
	elseif party_count == 4 then
		GROUND:CharTurnToCharAnimated(partner, hero, 4)
		GROUND:CharTurnToCharAnimated(hero, partner, 4)
		UI:WaitShowDialogue("With the four of us here...[pause=0] We might actually be able to stack up to that Apricorn!")
		GAME:WaitFrames(10)
		GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
		GROUND:CharTurnToCharAnimated(hero, team2, 4)
		UI:WaitShowDialogue("Come on,[pause=10] everyone![pause=0] We'll need to stack up to get one of those Apricorns!")
		GAME:WaitFrames(20)
		SOUND:FadeOutBGM(40)
		GAME:FadeOut(false, 40)
		apricorn_glade_ch_4.PickApricorn()
	end
end


--coming back if you failed to have 4 mons
function apricorn_glade_ch_4.SubsequentArrivalCutscene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local team2 = CH('Teammate2')
	local team3 = CH('Teammate3')
	
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('apricorn_grove')
	
	GAME:WaitFrames(60)
	AI:DisableCharacterAI(partner)
	SOUND:StopBGM()
	
	GAME:MoveCamera(292, 224, 1, false)
	GROUND:TeleportTo(hero, 268, 368, Direction.Up)
	GROUND:TeleportTo(partner, 300, 368, Direction.Up)
	if team2 ~= nil then
		GROUND:TeleportTo(team2, 284, 400, Direction.Up)
	end
	if team3 ~= nil then
		GROUND:TeleportTo(team3, 316, 400, Direction.Up)
	end
	
	GAME:CutsceneMode(true)
	UI:ResetSpeaker()
	UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
	GAME:WaitFrames(60)
	UI:WaitHideTitle(20)
	GAME:FadeIn(40)
	SOUND:PlayBGM('In The Depths of the Pit.ogg', false)

	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 300, 248, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:MoveToPosition(hero, 268, 248, false, 1) end)
	local coro3 = TASK:BranchCoroutine(function() if team2 ~= nil then GAME:WaitFrames(14) GROUND:MoveToPosition(team2, 284, 280, false, 1) end end)
	local coro4 = TASK:BranchCoroutine(function() if team3 ~= nil then GAME:WaitFrames(18) GROUND:MoveToPosition(team3, 316, 280, false, 1) end end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	--GeneralFunctions.EmoteAndPause(partner, "Exclaim", true)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("Alright![pause=0] We've made it back to the big Apricorn tree.")
	GAME:WaitFrames(10)
	
	apricorn_glade_ch_4.PartyCountCheck()
		
	
end



--subscene of picking the apricorn off the tree 
--BEWARE OF ONIX!
--TODO: Order based on weight, base of the tower and the spacing of the characters based on height of the sprite, change render order of pokemon in the stack so it looks right
--hero should comment depending on where they end up in the totem, AND if the partner is heavier they should comment on that too
function apricorn_glade_ch_4.PickApricorn()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local team2 = CH('Teammate2')
	local team3 = CH('Teammate3')
	local apricorn = OBJ('Apricorn_Scene')
	GAME:CutsceneMode(true)
	
	GAME:MoveCamera(292, 192, 1, false)
	GROUND:TeleportTo(partner, 276, 158, Direction.Up)
	AI:DisableCharacterAI(partner)
	GAME:WaitFrames(60)
	
	
	---Figure out if we this is an onix situation. If not, then order by weight, heaviest at the bottom. Partner is always at the top, however.
	local team2species = 'default'
	local team3species = 'default'
	local onix_teammate = nil
	local other_teammate = nil
	
	if team2 ~= nil then team2species = team2.CurrentForm.Species end 
	if team3 ~= nil then team3species = team3.CurrentForm.Species end 
	
	
	if team2species == 'onix' then 
		onix_teammate = team2
		other_teammate = team3
	elseif team3species == 'onix' then
		onix_teammate = team3
		other_teammate = team2
	end
	
	--Onix Teammate? if so, play a special scene where the one onix helps the partner up
	if onix_teammate ~= nil then

		GROUND:TeleportTo(hero, 252, 239, Direction.UpRight)
		GROUND:TeleportTo(other_teammate, 300, 239, Direction.UpLeft)
		
		local onix_head = GROUND:CharGetAnimPoint(onix_teammate, RogueEssence.Content.ActionPointType.Head)
		local onix_shadow = GROUND:CharGetAnimPoint(onix_teammate, RogueEssence.Content.ActionPointType.Shadow)		
		
		
		--used to cast the shadow, as our onix's true position is going to be super offscreen with a huge height. this is to handle rendering shenanigans.
		local onix_clone_monster = RogueEssence.Dungeon.MonsterID("onix", 0, "normal", Gender.Male)
		local onix_clone = RogueEssence.Ground.GroundChar(onix_clone_monster, RogueElements.Loc(392, 240), Direction.Up, "The Backstreet Boys", onix_clone_monster.Species)
		onix_clone:ReloadEvents()
		GAME:GetCurrentGround():AddTempChar(onix_clone)
		
		--This is the appropriate way to "move to a position with a height". The one in the generic version of this scene was before i realized teleport to took a height.
		GROUND:TeleportTo(onix_clone, 276, 158 + onix_shadow.Y - onix_head.Y, Direction.Up, 200)
		GROUND:TeleportTo(onix_teammate, 276, 8 + onix_shadow.Y - onix_head.Y, Direction.Up, -150)
		GROUND:TeleportTo(partner, onix_clone.Position.X, onix_clone.Position.Y + 1, Direction.Up, onix_shadow.Y - onix_head.Y)
		
		UI:SetSpeaker(partner)
		UI:WaitShowDialogue("Alright,[pause=0] I'll just climb up along your back then.")
		SOUND:PlayBattleSE("_UNK_EVT_089")
		GAME:WaitFrames(60)

		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue("Almost...[pause=0] to...[pause=0] the top...")
		GAME:WaitFrames(20)
		
		SOUND:PlayBattleSE("_UNK_EVT_023")
		GAME:WaitFrames(60)
		
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("And...[pause=0] there!")
		
		GAME:FadeIn(40)
		GAME:WaitFrames(20)
		UI:WaitShowDialogue("Yeah![pause=0] I can get a good grip on this Apricorn now!")
		UI:WaitShowDialogue("Here goes nothing!")
		GAME:WaitFrames(20)
		
		GROUND:CharSetAnim(partner, "Pull", true)
		GAME:WaitFrames(40)
		
		UI:SetSpeakerEmotion("Determined")
		UI:WaitShowDialogue("Arrrrgh![pause=0] It's stuck on there good!")
		GAME:WaitFrames(40)

		GeneralFunctions.EmoteAndPause(partner, "Exclaim", true)
		UI:SetSpeakerEmotion("Inspired")
		UI:WaitShowDialogue("Oh,[pause=10] I think it's coming loose![pause=0] Just a little more!")
		
		GAME:WaitFrames(20)
		UI:SetSpeakerEmotion("Inspired")
		UI:WaitShowDialogue("Yes![pause=0] I think I've got it!")
		
		GAME:WaitFrames(30)
		--NOTE: The shadow of the partner shifts a decent amount and it's a bit awkward if you pay close attention, but it's because the tumble animation shifts the shadow around itself. Not worth worrying about i think...
		SOUND:PlayBattleSE('EVT_CH05_Tumble_Behind_Waterfall')
		UI:SetSpeakerEmotion("Shouting")
		local coro1 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue("Waaaaaaah!", 60) end)
		local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
													  GROUND:MoveObjectToPosition(apricorn, apricorn.Position.X, onix_clone.Position.Y + 16, 2)
													  end)
		local coro3 = TASK:BranchCoroutine(function() local partner_anim = RogueEssence.Content.GraphicsManager.GetAnimIndex("Tumble")
													  local frameActionPartner = RogueEssence.Ground.ReverseGroundAction(partner.Position, partner.LocHeight, Direction.Left, partner_anim)
													  GROUND:ActionToPosition(partner, frameActionPartner, 276, onix_clone.Position.Y + 1, 1, 2, 0)
													  frameActionPartner = RogueEssence.Ground.ReverseGroundAction(partner.Position, partner.LocHeight, Direction.Left, partner_anim)
													  GROUND:ActionToPosition(partner, frameActionPartner, 276, onix_clone.Position.Y + 36, 1, 3, 0)
													  GROUND:CharSetAction(partner, RogueEssence.Ground.PoseGroundAction(partner.Position, partner.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pain")))
													  GROUND:EntTurn(partner, Direction.Left)
													  end)
		local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
													  GROUND:CharSetEmote(hero, "shock", 1)
													  GAME:WaitFrames(12)
													  GROUND:EntTurn(hero, Direction.Right) 
													  GAME:WaitFrames(60)
													  --GROUND:MoveToPosition(hero, hero.Position.X + 4, hero.Position.Y, false, 1)
													  --GAME:WaitFrames(10)
													  GeneralFunctions.EmoteAndPause(hero, "Sweating", false) end)
		local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(14)
													  GROUND:CharSetEmote(other_teammate, "exclaim", 1)
													  GAME:WaitFrames(12)
													  GROUND:EntTurn(other_teammate, Direction.Left) end)
        local coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(18)
													  GROUND:CharSetEmote(onix_teammate, "exclaim", 1) end)
		TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6})
		
		GROUND:CharAnimateTurnTo(onix_teammate, Direction.Down, 4)
		GAME:WaitFrames(10)
		UI:SetSpeakerEmotion("Pain")
		UI:WaitShowDialogue("Owowowowow...")
			
		
		
		GAME:WaitFrames(30)
		GeneralFunctions.DoAnimation(partner, "Wake") 
		GeneralFunctions.ShakeHead(partner) 		
		GAME:WaitFrames(30)

		
		UI:SetSpeakerEmotion("Normal")
		SOUND:PlayBGM('In The Depths of the Pit.ogg', false)
		UI:WaitShowDialogue("Urgh...[pause=0] Don't worry,[pause=10] I'm alright.")
		--GAME:WaitFrames(20)
		--GROUND:AnimateToPosition(hero, "Walk", Direction.Right, hero.Position.X - 4, hero.Position.Y, 1, 1, 0)
		GAME:WaitFrames(30)
		
		GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
		GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4)
		GROUND:EntTurn(other_teammate, Direction.UpLeft)
		GeneralFunctions.EmoteAndPause(partner, "Exclaim", true)
		UI:SetSpeakerEmotion("Inspired")
		UI:WaitShowDialogue("Oh![pause=0] The Apricorn![pause=0] We managed to get it off the tree!")
		
		GAME:WaitFrames(20)
		GROUND:MoveInDirection(partner, Direction.Up, 4, false, 1)
		GROUND:Hide(apricorn.EntName)
		SOUND:PlaySE("Event Item Pickup")
		GeneralFunctions.Monologue(partner:GetDisplayName() .. " picked up the huge Apricorn.")
		
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Inspired")
		GAME:WaitFrames(30)
		GROUND:CharTurnToCharAnimated(partner, hero, 4)
		GROUND:CharTurnToCharAnimated(hero, partner, 4)
		--GeneralFunctions.DoubleHop(partner)
		GROUND:CharSetEmote(partner, "glowing", 0)
		UI:WaitShowDialogue("We did it,[pause=10] " .. hero:GetDisplayName() .. "! Everyone![pause=0] We got the big Apricorn!")
		GROUND:CharSetEmote(partner, "", 0)
		UI:WaitShowDialogue("Let's bring it back to the Guildmaster![pause=0] He'll be amazed by the size of this thing!")
		
		
		
		SV.ApricornGrove.InDungeon = false
		SV.Chapter4.FinishedGrove = true
		GAME:WaitFrames(30)
		SOUND:FadeOutBGM(60)
		GAME:FadeOut(false, 60)	
		GAME:WaitFrames(90)
		GAME:CutsceneMode(false)	
		GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared, "master_zone", -1, 8, 0, false, false)
		
		
		
	else		
		--Determine the order of the bottom 3 of the stack.
		local stack_order = {hero, team2, team3}
		table.sort(stack_order, apricorn_glade_ch_4.WeightCompare)

		
		--Addresses the rendering order when characters are stacked on top of each other. This will help with their shadows.
		stack_order[3].EntOrder = 1
		stack_order[2].EntOrder = 3
		stack_order[1].EntOrder = 4
		partner.EntOrder = 5
		apricorn.EntOrder = 2
				

		GROUND:TeleportTo(stack_order[1], 276, 160, Direction.Up)
		GROUND:TeleportTo(stack_order[2], 276, 160, Direction.Up)
		GROUND:TeleportTo(stack_order[3], 276, 160, Direction.Up)

		local stack_1_head = GROUND:CharGetAnimPoint(stack_order[1], RogueEssence.Content.ActionPointType.Head)
		local stack_1_shadow = GROUND:CharGetAnimPoint(stack_order[1], RogueEssence.Content.ActionPointType.Shadow)
		local stack_1_center = GROUND:CharGetAnimPoint(stack_order[1], RogueEssence.Content.ActionPointType.Center)
		local stack_2_head = GROUND:CharGetAnimPoint(stack_order[2], RogueEssence.Content.ActionPointType.Head)
		local stack_2_shadow = GROUND:CharGetAnimPoint(stack_order[2], RogueEssence.Content.ActionPointType.Shadow)
		local stack_2_center = GROUND:CharGetAnimPoint(stack_order[2], RogueEssence.Content.ActionPointType.Center)
		local stack_3_head = GROUND:CharGetAnimPoint(stack_order[3], RogueEssence.Content.ActionPointType.Head)
		local stack_3_shadow = GROUND:CharGetAnimPoint(stack_order[3], RogueEssence.Content.ActionPointType.Shadow)		
		local stack_3_center = GROUND:CharGetAnimPoint(stack_order[3], RogueEssence.Content.ActionPointType.Center)		
		
		local stack_1_height = math.max(stack_1_shadow.Y - stack_1_head.Y, stack_1_shadow.Y - stack_1_center.Y + 6, 14)
		local stack_2_height = math.max(stack_2_shadow.Y - stack_2_head.Y, stack_2_shadow.Y - stack_2_center.Y + 6, 14)
		local stack_3_height = math.max(stack_3_shadow.Y - stack_3_head.Y, stack_3_shadow.Y - stack_3_center.Y + 6, 14)


		--bottom member of totem
		GROUND:TeleportTo(stack_order[3], partner.Position.X, partner.Position.Y + stack_1_height + stack_2_height + stack_3_height, Direction.Up)
		local totem_base = stack_order[3].Position.Y

		GROUND:TeleportTo(stack_order[2], partner.Position.X, totem_base, Direction.Up, stack_3_height)
		GROUND:TeleportTo(stack_order[1], partner.Position.X, totem_base, Direction.Up, stack_3_height + stack_2_height)
		GROUND:TeleportTo(partner, partner.Position.X, totem_base, Direction.Up, stack_3_height + stack_2_height + stack_1_height)
		  
		local animId = RogueEssence.Content.GraphicsManager.GetAnimIndex("None")
		UI:SetSpeaker(partner)
		UI:WaitShowDialogue("OK![pause=0] So I guess you get on top of you,[pause=10] and...")
		
		SOUND:PlayBattleSE("_UNK_EVT_089")
		GAME:WaitFrames(60)
		UI:SetSpeaker(partner)
		UI:WaitShowDialogue("OK,[pause=10] you can stand there and...[pause=10] Alright!")
		UI:WaitShowDialogue("Now,[pause=10] I'll just climb up...")

		SOUND:PlayBattleSE("_UNK_EVT_014")
		GAME:WaitFrames(20)
		GeneralFunctions.HeroDialogue(hero, "(Urf!)", "Pain")
		
		GAME:WaitFrames(20)
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Surprised")
		UI:WaitShowDialogue("Whoops![pause=10] Sorry,[pause=10] " .. hero:GetDisplayName() .. "!")
		
		GAME:WaitFrames(20)
		SOUND:PlayBattleSE("_UNK_EVT_023")
		GAME:WaitFrames(40)
		
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue("Almost...[pause=0] in...[pause=0] position...")
		GAME:WaitFrames(20)
		
		SOUND:PlayBattleSE("_UNK_EVT_023")
		GAME:WaitFrames(60)
		
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("And...[pause=0] there!")
		
		GAME:FadeIn(40)
		GAME:WaitFrames(20)
		
		UI:WaitShowDialogue("Yeah![pause=0] I can get a good grip on this Apricorn now!")
		GAME:WaitFrames(20)
		
		apricorn_glade_ch_4.TowerWobble(partner, stack_order)
		GAME:WaitFrames(20)
		GeneralFunctions.EmoteAndPause(partner, "Exclaim", true)
		UI:SetSpeakerEmotion("Surprised")
		UI:WaitShowDialogue("Careful,[pause=10] everyone![pause=0] Just try to hold steady!")
		GAME:WaitFrames(20)
		

		--different comment depending on where the hero is in the stack
		if LTBL(stack_order[1]).Importance == "Hero" then 
			GeneralFunctions.HeroDialogue(hero, "(It's not too hard for me this high up on the totem...)", "Worried")
			GeneralFunctions.HeroDialogue(hero, "(I just hope everyone below me is doing alright.)", "Worried")
		elseif LTBL(stack_order[2]).Importance == "Hero" then
			GeneralFunctions.HeroDialogue(hero, "(Urgh...[pause=0] This is tough...)", "Pain")
			GeneralFunctions.HeroDialogue(hero, "(I just hope we can hold out long enough for " .. partner:GetDisplayName() .. " to grab that Apricorn...)", "Pain")
		else
			GeneralFunctions.HeroDialogue(hero, "(Easy for you to say...[pause=0] You're not on the bottom of the totem...)", "Dizzy")
		end
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(partner)
		UI:WaitShowDialogue("Here goes nothing!")
		GAME:WaitFrames(20)
		
		GROUND:CharSetAnim(partner, "Pull", true)
		GAME:WaitFrames(40)
		
		UI:SetSpeakerEmotion("Determined")
		UI:WaitShowDialogue("Arrrrgh![pause=0] It's stuck on there good!")
		GAME:WaitFrames(20)
		apricorn_glade_ch_4.TowerWobble(partner, stack_order)
		apricorn_glade_ch_4.TowerWobble(partner, stack_order)

		GeneralFunctions.EmoteAndPause(partner, "Exclaim", true)
		UI:SetSpeakerEmotion("Inspired")
		UI:WaitShowDialogue("Oh,[pause=10] I think it's coming loose![pause=0] Just hang tight a little longer,[pause=10] everyone!")
		
		GAME:WaitFrames(10)
		GROUND:CharSetDrawEffect(partner, DrawEffect.Trembling)
		GROUND:CharSetDrawEffect(stack_order[1], DrawEffect.Trembling)
		GROUND:CharSetDrawEffect(stack_order[2], DrawEffect.Trembling)
		GROUND:CharSetDrawEffect(stack_order[3], DrawEffect.Trembling)
		
		GAME:WaitFrames(40)
		--different comment depending on where the hero is in the stack
		if LTBL(stack_order[1]).Importance == "Hero" then 
			GeneralFunctions.HeroDialogue(hero, "(Woah![pause=0] It's getting wobbly!)", "Surprised")
			GeneralFunctions.HeroDialogue(hero, "(I don't think our totem is going to last much longer!)", "Surprised")
		elseif LTBL(stack_order[2]).Importance == "Hero" then
			GeneralFunctions.HeroDialogue(hero, "(Urf...[pause=0] It's getting tough to keep balanced...)", "Pain")
			GeneralFunctions.HeroDialogue(hero, "(I don't think I can hold my spot on the totem much longer...)", "Pain")
		else
			GeneralFunctions.HeroDialogue(hero, "(I can't hold everyone up anymore...[pause=0] We're...[pause=0] going to fall over...)", "Dizzy")
		end
		
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Inspired")
		
		GAME:WaitFrames(20)
		UI:WaitShowDialogue("Yes![pause=0] I think I've got it!")
		
		--london bridge is falling! TODO: IMPROVE
		
		
		--number to name mapping for an animation
		--print(RogueEssence.Content.GraphicsManager.Actions[52].Name)
		--print(RogueEssence.Content.GraphicsManager.Actions[67].Name)
		--print(RogueEssence.Content.GraphicsManager.Actions[59].Name)
		--print(RogueEssence.Content.GraphicsManager.Actions[47].Name)
		--print(RogueEssence.Content.GraphicsManager.Actions[56].Name)
		
		local mon_id_1 = RogueEssence.Dungeon.MonsterID(stack_order[1].CurrentForm.Species, stack_order[1].CurrentForm.Form, stack_order[1].CurrentForm.Skin, stack_order[1].CurrentForm.Gender)
		local mon_id_2 = RogueEssence.Dungeon.MonsterID(stack_order[2].CurrentForm.Species, stack_order[2].CurrentForm.Form, stack_order[2].CurrentForm.Skin, stack_order[2].CurrentForm.Gender)
		local mon_id_3 = RogueEssence.Dungeon.MonsterID(stack_order[3].CurrentForm.Species, stack_order[3].CurrentForm.Form, stack_order[3].CurrentForm.Skin, stack_order[3].CurrentForm.Gender)


		--see which mons have pain sprites. If they dont have pain animation, use hurt
		--In the Future, use GROUND:CharGetAnimFallback in conjunction with gfxparams.xml to do this.
		anim1 = "Hurt"
		if RogueEssence.Content.GraphicsManager.GetChara(mon_id_1:ToCharID()).AnimData:ContainsKey(52) then
			anim1 = "Pain"
		end

		anim2 = 'Hurt'
		if RogueEssence.Content.GraphicsManager.GetChara(mon_id_2:ToCharID()).AnimData:ContainsKey(52) then
			anim2 = 'Pain'
		end
			
		anim3 = 'Hurt'
		if RogueEssence.Content.GraphicsManager.GetChara(mon_id_3:ToCharID()).AnimData:ContainsKey(59) then
			anim3 = 'Trip'
		end
		
		--secondary animation for the "sitting" portion of the fall for the non-bottoms.
		local second_anim1 = RogueEssence.Content.GraphicsManager.GetAnimIndex("None")
		if RogueEssence.Content.GraphicsManager.GetChara(mon_id_1:ToCharID()).AnimData:ContainsKey(56) then
			second_anim1 = RogueEssence.Content.GraphicsManager.GetAnimIndex("Sit")
		end

		local second_anim2 = RogueEssence.Content.GraphicsManager.GetAnimIndex("None")
		if RogueEssence.Content.GraphicsManager.GetChara(mon_id_2:ToCharID()).AnimData:ContainsKey(56) then
			second_anim2 = RogueEssence.Content.GraphicsManager.GetAnimIndex("Sit")
		end

		
		--Hack. Like, very hacky. Keep three invisible Apricorn that replaces the one we see as it falls down. The 
		--clones have a disjoint on their vertical position so that the layering works so that the bottom totem mon has it render over them as it moves past
		--without rendering over the partner as they fall through the totem.
		
		local apriclone = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Apricorn_Big", 1), --anim data. Don't set that number to 0 for valid anims
								 				 RogueElements.Rect(apricorn.Position.X, apricorn.Position.Y + 24 + 24, 16, 16),--xy coords, then size
								  				 RogueElements.Loc(0, 24), --offset
												 true, 
												 "Apricorn_Clone")--object entity name	
				
		apriclone:ReloadEvents()
		GAME:GetCurrentGround():AddTempObject(apriclone)
		GROUND:Hide(apriclone.EntName)
		
		local apriclone2 = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Apricorn_Big", 1), --anim data. Don't set that number to 0 for valid anims
								 				 RogueElements.Rect(apricorn.Position.X, totem_base + 24, 16, 16),--xy coords, then size
								  				 RogueElements.Loc(0, 15), --offset
												 true, 
												 "Apricorn_Clone_2")--object entity name	
				
		apriclone2:ReloadEvents()
		GAME:GetCurrentGround():AddTempObject(apriclone2)
		GROUND:Hide(apriclone2.EntName)
		
		local apriclone3 = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Apricorn_Big", 1), --anim data. Don't set that number to 0 for valid anims
														 RogueElements.Rect(apricorn.Position.X, totem_base + 28, 16, 16),--xy coords, then size
														 RogueElements.Loc(0, 12), --offset
														 true, 
														 "Apricorn_Clone_3")--object entity name	
				
		apriclone3:ReloadEvents()
		GAME:GetCurrentGround():AddTempObject(apriclone3)
		GROUND:Hide(apriclone3.EntName)
	
	
	
		GAME:WaitFrames(20)
		UI:SetSpeakerEmotion("Shouting")
		SOUND:PlayBattleSE('_UNK_EVT_038')
		local coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(18) UI:WaitShowTimedDialogue("Waaaaaaah!", 60) end)
		local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(18)
													  GROUND:MoveObjectToPosition(apricorn, apricorn.Position.X, apricorn.Position.Y + 24, 3) 
													  GROUND:Hide(apricorn.EntName)
													  GROUND:Unhide(apriclone.EntName)
													  GROUND:MoveObjectToPosition(apriclone, apriclone.Position.X, totem_base + 31, 3) 
												      GROUND:Hide(apriclone.EntName)
													  GROUND:Unhide(apriclone2.EntName)
													  GROUND:MoveObjectToPosition(apriclone2, apriclone2.Position.X, totem_base + 31, 3) 
													  GROUND:Hide(apriclone2.EntName)
													  GROUND:Unhide(apriclone3.EntName)
													  GROUND:MoveObjectToPosition(apriclone3, apriclone3.Position.X, totem_base + 4, 3) 
													  GROUND:MoveObjectToPosition(apriclone3, apriclone3.Position.X, totem_base + 28, 3) end)
		local coro3 = TASK:BranchCoroutine(function() GROUND:CharEndDrawEffect(stack_order[3], DrawEffect.Trembling)													  
													  GROUND:CharSetAction(stack_order[3], RogueEssence.Ground.PoseGroundAction(stack_order[3].Position, stack_order[3].Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex(anim3))) end)
		local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
													  GROUND:CharEndDrawEffect(stack_order[2], DrawEffect.Trembling)
													  
													  local frameAction2 = RogueEssence.Ground.IdleAnimGroundAction(stack_order[2].Position, stack_order[2].LocHeight, Direction.Left, second_anim2, false)
													  --GROUND:ActionToPosition(stack_order[2], frameAction2, 252, totem_base + 12, 1, 1, stack_order[2].LocHeight)
													  --frameAction2 = RogueEssence.Ground.IdleAnimGroundAction(stack_order[2].Position, stack_order[2].LocHeight, Direction.Left, second_anim2, false)
												      GROUND:ActionToPosition(stack_order[2], frameAction2, 252, totem_base + 12, 1, 2, 0)
													  SOUND:PlaySE('Hit Ground out of Fall')
													  GeneralFunctions.Recoil(stack_order[2], "Hurt", 10, 10, false, false)
													  GROUND:CharSetAction(stack_order[2], RogueEssence.Ground.PoseGroundAction(stack_order[2].Position, stack_order[2].Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex(anim2)))
													  end)
		local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(12)
													  GROUND:CharEndDrawEffect(stack_order[1], DrawEffect.Trembling)
													  local frameAction1 = RogueEssence.Ground.IdleAnimGroundAction(stack_order[1].Position, stack_order[1].LocHeight, Direction.Right, second_anim1, false)
													  --GROUND:ActionToPosition(stack_order[1], frameAction1, 300, totem_base + 16, 1,1, stack_order[1].LocHeight)
													  --frameAction1 = RogueEssence.Ground.IdleAnimGroundAction(stack_order[1].Position, stack_order[1].LocHeight, Direction.Right, second_anim1, false)
													  GROUND:ActionToPosition(stack_order[1], frameAction1, 300, totem_base + 16, 1, 2, 0)
													  GeneralFunctions.Recoil(stack_order[1], "Hurt", 10, 10, false, false)
													  GROUND:CharSetAction(stack_order[1], RogueEssence.Ground.PoseGroundAction(stack_order[1].Position, stack_order[1].Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex(anim1)))
													  end)
		local coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(18)
													  GROUND:CharEndDrawEffect(partner, DrawEffect.Trembling)
													  local partner_anim = RogueEssence.Content.GraphicsManager.GetAnimIndex("Sit")
													  local frameActionPartner = RogueEssence.Ground.IdleAnimGroundAction(partner.Position, partner.LocHeight, Direction.Left, partner_anim, false)
													  GROUND:ActionToPosition(partner, frameActionPartner, 276, totem_base + 32, 1, 2, 0)
													  GeneralFunctions.Recoil(partner, "Hurt", 10, 10, false, false)
													  GROUND:CharSetAction(partner, RogueEssence.Ground.PoseGroundAction(partner.Position, partner.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pain")))
													  end)
		TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6})
		
		GAME:WaitFrames(50)
		UI:SetSpeakerEmotion("Pain")
		UI:WaitShowDialogue("Owowowowow...")
		
		
		--see which mons have wake sprites. If they dont have sit animation, use idle
		anim1 = 'None'
		if RogueEssence.Content.GraphicsManager.GetChara(mon_id_1:ToCharID()).AnimData:ContainsKey(47) then
			anim1 = 'Wake'
		end

		anim2 = 'None'
		if RogueEssence.Content.GraphicsManager.GetChara(mon_id_2:ToCharID()).AnimData:ContainsKey(47) then
			anim2 = 'Wake'
		end
			
		anim3 = 'None'
		if RogueEssence.Content.GraphicsManager.GetChara(mon_id_3:ToCharID()).AnimData:ContainsKey(47) then
			anim3 = 'Wake'
		end
		
		
		
		GAME:WaitFrames(20)
		coro1 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(partner, "Wake") 
												GeneralFunctions.ShakeHead(partner) end)
		coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
												GeneralFunctions.DoAnimation(stack_order[3], anim3) 
												GeneralFunctions.ShakeHead(stack_order[3]) end)
		coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(12)
												GeneralFunctions.DoAnimation(stack_order[2], anim2) 
												GeneralFunctions.ShakeHead(stack_order[2]) end)
		coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(18)
												GeneralFunctions.DoAnimation(stack_order[1], anim1) 
												GeneralFunctions.ShakeHead(stack_order[1]) end)												
		TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
		
		GAME:WaitFrames(10)
		
		coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
												GROUND:CharAnimateTurnTo(partner, Direction.UpLeft, 4) 
												GAME:WaitFrames(20)
												GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4) 
												GAME:WaitFrames(20)
												GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) 
												GAME:WaitFrames(20)
												end)
		coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(2) GROUND:CharAnimateTurnTo(stack_order[3], Direction.Down, 4) end)
		coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GROUND:CharAnimateTurnTo(stack_order[2], Direction.Right, 4) end)
		coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:CharAnimateTurnTo(stack_order[1], Direction.Left, 4) end)
		TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
		
		UI:SetSpeakerEmotion("Sigh")
		SOUND:PlayBGM('In The Depths of the Pit.ogg', false)
		UI:WaitShowDialogue("Looks like everyone's okay after that tumble.[pause=0] That's a relief.")
		
		GAME:WaitFrames(20)
		GeneralFunctions.EmoteAndPause(partner, "Exclaim", true)
		UI:SetSpeakerEmotion("Inspired")
		UI:WaitShowDialogue("Oh![pause=0] The Apricorn![pause=0] We managed to get it off the tree!")
		
		GAME:WaitFrames(20)
		GROUND:MoveInDirection(partner, Direction.Up, 4, false, 1)
		GROUND:Hide(apriclone3.EntName)
		SOUND:PlaySE("Event Item Pickup")
		GeneralFunctions.Monologue(partner:GetDisplayName() .. " picked up the huge Apricorn.")
		
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Inspired")
		GAME:WaitFrames(30)
		GROUND:CharTurnToCharAnimated(partner, hero, 4)
		GROUND:CharTurnToCharAnimated(hero, partner, 4)
		--GeneralFunctions.DoubleHop(partner)
		GROUND:CharSetEmote(partner, "glowing", 0)
		UI:WaitShowDialogue("We did it,[pause=10] " .. hero:GetDisplayName() .. "! Everyone![pause=0] We got the big Apricorn!")
		GROUND:CharSetEmote(partner, "", 0)
		UI:WaitShowDialogue("Let's bring it back to the Guildmaster![pause=0] He'll be amazed by the size of this thing!")

		SV.ApricornGrove.InDungeon = false
		SV.Chapter4.FinishedGrove = true
		GAME:WaitFrames(30)
		SOUND:FadeOutBGM(60)
		GAME:FadeOut(false, 60)	
		GAME:WaitFrames(90)
		GAME:CutsceneMode(false)	
		GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared, "master_zone", -1, 8, 0, false, false)
	end
	
end 
--TRIPPING SOUND:	SOUND:PlayBattleSE("_UNK_EVT_014")
--Impact on ground SOUND:	SOUND:PlayBattleSE("_UNK_EVT_018")
--shuffling = 23?
--falling + impact = 25
--falling  =38
--shuffling = 89
--landing? = 10/11

function apricorn_glade_ch_4.WeightCompare(a, b)
	local monster = _DATA:GetMonster(a.CurrentForm.Species)
	local weight1 = monster.Forms[a.CurrentForm.Form].Weight
	print(weight1)
	local monster = _DATA:GetMonster(b.CurrentForm.Species)
	local weight2 = monster.Forms[b.CurrentForm.Form].Weight
	
	return weight1 < weight2
end

function apricorn_glade_ch_4.TowerWobble(partner, tower)
	local coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(12) GeneralFunctions.Shake(partner) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(8) GeneralFunctions.Shake(tower[1]) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GeneralFunctions.Shake(tower[2]) end)
	local coro4 = TASK:BranchCoroutine(function() GeneralFunctions.Shake(tower[3]) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
end


--subscene: you dont have enough mons to get the apricorn and must turn back. Either to leave the dungeon or go back in at floor 8
function apricorn_glade_ch_4.TurnBack()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local team2 = CH('Teammate2')
	local team3 = CH('Teammate3')
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("With that in mind...[pause=0] We can either head back into the dungeon,[pause=10] or we can call it a day.")
	UI:BeginChoiceMenu(hero:GetDisplayName() .. ",[pause=10] which do you think we should do?", {"Go back in", "Head home"}, 1, 2)
	UI:WaitForChoice()
	local result = UI:ChoiceResult()
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Normal")
	if result == 1 then
		UI:WaitShowDialogue("OK,[pause=10] we'll go back into the dungeon then.")
		UI:WaitShowDialogue("Let's get back in there,[pause=10] " .. hero:GetDisplayName() .. "!")
		GAME:WaitFrames(20)
		--coro1 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(hero, "Nod") end)
		--coro2 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(partner, "Nod") end)
		--TASK:JoinCoroutines({coro1, coro2})
		
		--GAME:WaitFrames(10)
		coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
												if hero.Direction == Direction.Down then GAME:WaitFrames(16) end --wait extra if we're already facing down to give the partner a chance to do so as well
												GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
												GROUND:MoveInDirection(hero, Direction.Down, 120, false, 1) end)	
		coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(12)
												GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
												GROUND:MoveInDirection(partner, Direction.Down, 120, false, 1) end)
		coro3 = TASK:BranchCoroutine(function() if team2 ~= nil then 
												GROUND:CharAnimateTurnTo(team2, Direction.Down, 4)
												GROUND:MoveInDirection(team2, Direction.Down, 120, false, 1) end end)
		coro4 = TASK:BranchCoroutine(function() if team3 ~= nil then 
												GAME:WaitFrames(4)
												GROUND:CharAnimateTurnTo(team3, Direction.Down, 4)
												GROUND:MoveInDirection(team3, Direction.Down, 120, false, 1) end end)
		local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(60) SOUND:FadeOutBGM(40) GAME:FadeOut(false, 40) end)

		TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
		GAME:CutsceneMode(false)
		GAME:WaitFrames(20)
		--go back in at floor 8
		GAME:ContinueDungeon("apricorn_grove", 0, 7, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
	else 
		UI:WaitShowDialogue("OK,[pause=10] we'll go back to the guild then.")
		UI:WaitShowDialogue("Alright.[pause=0] Let's head home!")
		GAME:WaitFrames(40)
		SOUND:FadeOutBGM(40)
		GAME:FadeOut(false, 40)	
		SV.ApricornGrove.InDungeon = false
		GAME:CutsceneMode(false)
		GAME:WaitFrames(90)

		--set generic flags for generic end of day / start of next day.
		SV.TemporaryFlags.Dinnertime = true 
		SV.TemporaryFlags.Bedtime = true
		SV.TemporaryFlags.MorningWakeup = true 
		SV.TemporaryFlags.MorningAddress = true 

		GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Escaped, "master_zone", -1, 6, 0, true, true)
	
	end
end







return apricorn_glade_ch_4