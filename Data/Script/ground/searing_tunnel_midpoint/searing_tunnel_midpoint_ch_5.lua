require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

searing_tunnel_midpoint_ch_5 = {}

function searing_tunnel_midpoint_ch_5.SetupGround()
	local growlithe = CH('Teammate2')
	local zigzagoon = CH('Teammate3')
	
	if SV.Chapter5.TunnelMidpointState == 'FirstArrival' then
		GROUND:TeleportTo(zigzagoon, 216, 256, Direction.Up)
		GROUND:TeleportTo(growlithe, 236, 296, Direction.UpLeft)
		
	elseif SV.Chapter5.TunnelMidpointState == 'DeathArrival' then
		GROUND:TeleportTo(zigzagoon, 204, 208, Direction.Right)
		GROUND:TeleportTo(growlithe, 236, 208, Direction.Left)	
	elseif SV.Chapter5.TunnelMidpointState == 'RepeatArrival' then
		--use a more generic arrangement for them.
		GROUND:TeleportTo(zigzagoon, 172, 292, Direction.Up)
		GROUND:TeleportTo(growlithe, 172, 264, Direction.Down)	
	end
	
	GAME:FadeIn(20)
end




function searing_tunnel_midpoint_ch_5.Growlithe_Action(chara, activator)

end 

function searing_tunnel_midpoint_ch_5.Zigzagoon_Action(chara, activator)

end 

function searing_tunnel_midpoint_ch_5.ContinueScene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local growlithe = CH('Teammate2')
	local zigzagoon = CH('Teammate3')
	local coro1, coro2, coro3, coro4

	GROUND:Hide('North_Exit')
		
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(hero, 208, 120, false, 1)
											GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
											GROUND:CharSetAnim(hero, "None", true) end)	
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, 232, 120, false, 1)
											GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
											GROUND:CharSetAnim(partner, "None", true) end) 
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.PanCamera(nil, nil, false, nil, 228, 128) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	--different movement pattern depending on where they are
	if SV.Chapter5.TunnelMidpointState == 'FirstArrival' then
		coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4)
												GeneralFunctions.EightWayMove(growlithe, 244, 256, false, 1)
												GeneralFunctions.EightWayMoveRS(growlithe, 236, 152, false, 1)
												GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4) 
												GROUND:CharSetAnim(growlithe, "None", true) end)
		
		coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(zigzagoon, Direction.Left, 4)
												GeneralFunctions.EightWayMoveRS(zigzagoon, 196, 248, false, 1)
												GeneralFunctions.EightWayMoveRS(zigzagoon, 204, 152, false, 1)
												GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4)
												GROUND:CharSetAnim(zigzagoon, "None", true) end)
	
		coro3 = TASK:BranchCoroutine(function() GeneralFunctions.PanCamera(nil, nil, false, nil, 228, 160)
												GAME:WaitFrames(76)--time the wait so the second pan's end coincides with growlithe getting to his spot. (he gets there last) 
												GeneralFunctions.PanCamera(nil, nil, false, nil, 228, 120)
												end)
												
		TASK:JoinCoroutines({coro1, coro2, coro3})

	elseif SV.Chapter5.TunnelMidpointState == 'DeathArrival' then
		coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4)
												GeneralFunctions.EightWayMoveRS(growlithe, 236, 152, false, 1)
												GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4) 
												GROUND:CharSetAnim(growlithe, "None", true) end)
		
		coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) 
												GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4)
												GeneralFunctions.EightWayMoveRS(zigzagoon, 204, 152, false, 1)
												GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4)
												GROUND:CharSetAnim(zigzagoon, "None", true) end)
		TASK:JoinCoroutines({coro1, coro2})
	
	else--RepeatArrival
		coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMoveRS(growlithe, 236, 152, false, 1)
												GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4) 
												GROUND:CharSetAnim(growlithe, "None", true) end)
	
		coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) 
												GeneralFunctions.EightWayMoveRS(zigzagoon, 188, 200, false, 1)
												GeneralFunctions.EightWayMove(zigzagoon, 204, 152, false, 1)
												GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4)
												GROUND:CharSetAnim(zigzagoon, "None", true) end)

		coro3 = TASK:BranchCoroutine(function() GeneralFunctions.PanCamera(nil, nil, false, nil, 228, 160)
												GAME:WaitFrames(72)--time the wait so the second pan's end coincides with zigzagoon getting to his spot. (he gets there last) 
												GeneralFunctions.PanCamera(nil, nil, false, nil, 228, 120)
												end)
		TASK:JoinCoroutines({coro1, coro2, coro3})

	end
	
	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Happy")
	
	if SV.Chapter5.TunnelMidpointState == 'FirstArrival' then
		UI:WaitShowDialogue("All set,[pause=10] ruff?[pause=0] Alright![pause=0] This tunnel is as good as done!")
	elseif SV.Chapter5.TunnelMidpointState == 'DeathArrival' then
		UI:WaitShowDialogue("All set,[pause=10] ruff?[pause=0] Alright![pause=0] We'll get it done this time!")
	else--RepeatArrival
		UI:WaitShowDialogue("All set,[pause=10] ruff?[pause=0] Alright![pause=0] We'll go the right way this time!")
	end 
	
	
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
	local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(40) GAME:FadeOut(false, 40) end)


	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})	
	
	GAME:EnterDungeon("searing_tunnel", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end


--TASK:BranchCoroutine(searing_tunnel_midpoint_ch_5.FirstArrival)
function searing_tunnel_midpoint_ch_5.FirstArrival()
	--We've made it pretty far...
	--Ugh, this heat is sweltering! I hope we don't have too much farther to go.
	--Almotz explains it can't be far now, since they've hit a midpoint
	--A midpoint? 
	--Yeah, it's a rest area some dungeons have. We can use the Kanga rock here to get ready for the last stretch of the dungeon
	--The last bit will be pretty tough though, so let's make sure we're ready before we continue on.
	
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local growlithe = CH('Teammate2')
	local zigzagoon = CH('Teammate3')
	
	GAME:CutsceneMode(true)
	GROUND:Hide('South_Exit')
	SOUND:StopBGM()
	AI:DisableCharacterAI(partner)
	GROUND:TeleportTo(hero, 208, 416, Direction.Up)
	GROUND:TeleportTo(partner, 232, 416, Direction.Up)
	GROUND:TeleportTo(growlithe, 236, 432, Direction.Up)
	GROUND:TeleportTo(zigzagoon, 204, 432, Direction.Up)
	
	GAME:MoveCamera(228, 264, 1, false)
	
	GAME:FadeIn(40)
	SOUND:PlayBGM('Lower Spring Cave.ogg', true)
	GAME:WaitFrames(20)
	
	local coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) 
												  GROUND:MoveToPosition(hero, 208, 264, false, 1) 
												  GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) end)
	local coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 232, 264, false, 1)
												  GROUND:CharAnimateTurnTo(partner, Direction.Down, 4) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(14)
												  GROUND:MoveToPosition(zigzagoon, 204, 296, false, 1) 
												  GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(18) 
												  GROUND:MoveToPosition(growlithe, 236, 296, false, 1)
												  GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4) end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(growlithe)
	UI:WaitShowDialogue("We've made it pretty far,[pause=10] ruff!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(zigzagoon)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Yes,[pause=10] we have,[pause=10] but...")

	GeneralFunctions.EmoteAndPause(zigzagoon, "Sweating", true)
	UI:SetSpeakerEmotion("Pain")
	UI:WaitShowDialogue("Hahh,[pause=10] this heat is sweltering![pause=0] It's been getting hotter and hotter as we go deeper!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	GROUND:CharSetEmote(partner, "sweating", 1)
	GROUND:CharTurnToChar(partner, zigzagoon)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("I noticed that too.[pause=0] It's no surprise,[pause=10] given the type of place we're in.")
	UI:WaitShowDialogue("Are you gonna be alright,[pause=10] " .. zigzagoon:GetDisplayName() .. "?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(zigzagoon)
	GROUND:CharTurnToChar(zigzagoon, partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("I'll manage...[pause=0] Thankfully,[pause=10] we made it to the midpoint,[pause=10] so there shouldn't be much left to go.")
	GAME:WaitFrames(10)
	
	GeneralFunctions.EmoteAndPause(partner, "Question", true)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Midpoint?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(zigzagoon)
	UI:WaitShowDialogue("Yeah![pause=0] They're a rest area some mystery dungeons have.")
	GAME:WaitFrames(10)
	
	coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
											GeneralFunctions.EightWayMoveRS(partner, 248, 276, false, 1)
											GROUND:CharAnimateTurnTo(partner, Direction.UpLeft, 4)
											end)	
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(hero, Direction.Left, 4)
											GeneralFunctions.EightWayMoveRS(hero, 192, 276, false, 1)
											GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4)
											end)	
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.EightWayMove(zigzagoon, 216, 256, false, 1)
											end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.FaceMovingCharacter(growlithe, zigzagoon) 
											end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	UI:WaitShowDialogue("You can tell by the Kangaskhan Rock here.[pause=0] We can use it to get ready for the last stretch ahead of us!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Oh,[pause=10] wow![pause=0] I didn't know mystery dungeons could have a place like this in them!")
	GAME:WaitFrames(12)
		
	GROUND:CharTurnToCharAnimated(zigzagoon, partner, 4)
	UI:SetSpeaker(zigzagoon)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Yeah,[pause=10] they're really helpful![pause=0] We're lucky this tunnel has one.")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(growlithe)
	UI:WaitShowDialogue("I'm sure the last section is gonna be really tough,[pause=10] ruff!")
	UI:WaitShowDialogue("Let's make sure we're ready before we keep going!")
	GAME:WaitFrames(10)
	
	GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4)
	--GeneralFunctions.EightWayMoveRS(growlithe, 224, 272, false, 1)
	--GROUND:EntTurn(growlithe, Direction.Up)

	GROUND:Unhide('South_Exit')
	SV.Chapter5.PlayedMidpointIntro = true
	GeneralFunctions.PanCamera()	
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)
	GAME:CutsceneMode(false)
	
end 

--TASK:BranchCoroutine(searing_tunnel_midpoint_ch_5.WipedCutscene)
function searing_tunnel_midpoint_ch_5.WipedCutscene()
	--Urf... Where are we?
	--Looks like we're back at the midpoint... If any of us faint past the midway point, looks like we get sent back here instead of the entrance.
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local growlithe = CH('Teammate2')
	local zigzagoon = CH('Teammate3')
	local coro1, coro2, coro3, coro4
	
	GAME:CutsceneMode(true)
	SOUND:StopBGM()
	AI:DisableCharacterAI(partner)
	GROUND:TeleportTo(hero, 208, 176, Direction.Left)
	GROUND:TeleportTo(partner, 232, 176, Direction.Right)
	GROUND:TeleportTo(zigzagoon, 204, 208, Direction.Right)
	GROUND:TeleportTo(growlithe, 236, 208, Direction.Left)
	
	--todo: if growlithe gets eventsleep/wake animations, use them here.
	GROUND:CharSetAnim(partner, "EventSleep", true)
	GROUND:CharSetAnim(hero, "EventSleep", true)
	GAME:WaitFrames(10)--to offset their breathing cycles
	GROUND:CharSetAnim(growlithe, "Sleep", true)
	GROUND:CharSetAnim(zigzagoon, "EventSleep", true)
	
	GAME:MoveCamera(228, 200, 1, false)
	
	GAME:FadeIn(40)
	SOUND:PlayBGM('Lower Spring Cave.ogg', true)
	GAME:WaitFrames(110)--slightly less than 120 frames so that the sleep animation doesnt barely start another frame before waking
	
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(hero, 'Wake')
											GAME:WaitFrames(10) 
											GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
											GAME:WaitFrames(40)
											GeneralFunctions.LookAround(hero, 3, 4, false, false, false, Direction.Left)
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.DoAnimation(partner, 'Wake')
											GAME:WaitFrames(15) 
											GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
											GAME:WaitFrames(40)
											GeneralFunctions.LookAround(partner, 3, 4, false, false, true, Direction.Right)
											end)	
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GeneralFunctions.DoAnimation(zigzagoon, 'Wake')
											GAME:WaitFrames(10) 
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.Down, 4)
											GAME:WaitFrames(40)
											GeneralFunctions.LookAround(zigzagoon, 3, 4, false, false, true, Direction.Down)
											end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(26) 
										    GeneralFunctions.DoAnimation(growlithe, 'Rumble')
											GAME:WaitFrames(12)
											GROUND:CharAnimateTurnTo(growlithe, Direction.Down, 4)
											GAME:WaitFrames(40)
											GeneralFunctions.LookAround(growlithe, 3, 4, false, false, false, Direction.Down) 
											end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	GAME:WaitFrames(30)
	
	coro1 = TASK:BranchCoroutine(function () GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) end)
	coro2 = TASK:BranchCoroutine(function () GROUND:CharAnimateTurnTo(partner, Direction.Down, 4) end)
	coro3 = TASK:BranchCoroutine(function () GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4) end)
	coro4 = TASK:BranchCoroutine(function () GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Pain")
	UI:WaitShowDialogue("Urf...[pause=0] Where are we?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Pain")
	UI:WaitShowDialogue("It looks like we're back at the midpoint,[pause=10] ruff...")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(zigzagoon)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("We have to be more careful.[pause=0] If any of us faint,[pause=10] we'll all get sent back here!")
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	--Death was due to boss
	if SV.Chapter5.JustDiedToBoss then
		GAME:WaitFrames(10)
		GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
		GAME:WaitFrames(40)
		GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
		UI:WaitShowDialogue("The crucible seems to be the only way out of the tunnel.")
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue("But I'm worried that tribe of " .. _DATA:GetMonster('slugma'):GetColoredName() .. " will attack us again if we try to pass through.")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(zigzagoon)
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue("It seems likely...")
		UI:SetSpeakerEmotion("Pain")
		UI:WaitShowDialogue("I'd hate to get beat by them again.[pause=0] My fur's still singed!")
		GAME:WaitFrames(20)
		
		
		UI:SetSpeaker(growlithe)
		UI:WaitShowDialogue("...But we can't give up![pause=0] We'll just have to try to get through there again,[pause=10] ruff!")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(partner)
		UI:WaitShowDialogue(growlithe:GetDisplayName() .. "'s right.[pause=0] We're so close,[pause=10] we can't stop now!")
		UI:WaitShowDialogue("Let's give it another try![pause=0] I know we can get through this time!")
	else
		UI:WaitShowDialogue("Yeah.[pause=0] We need to work harder next time.[pause=0] But we can do this!")
		--UI:WaitShowDialogue("We've got to be close to the end,[pause=10] we can't give up now!")
		UI:WaitShowDialogue("C'mon,[pause=10] everyone,[pause=10] let's give it another shot!")
	end
	GAME:WaitFrames(10)
	GROUND:CharAnimateTurnTo(growlithe, zigzagoon, 4)
	GROUND:CharAnimateTurnTo(zigzagoon, growlithe, 4)

	--clear flags related to signaling this scene.
	SV.Chapter5.JustDiedToBoss = false
	SV.SearingTunnel.DiedPastCheckpoint = false
	GeneralFunctions.PanCamera()	
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)
	GAME:CutsceneMode(false)

end