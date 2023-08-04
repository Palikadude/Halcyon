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
	--TODO: IMPROVE WHEN ABLE TO
	
	coro1 = TASK:BranchCoroutine(function() SOUND:PlayBattleSE('_UNK_EVT_010')--jump sfx. Maybe find a better one if possible?
											GROUND:AnimateInDirection(partner, "LeapForth", Direction.Up, Direction.Up, 13, 1, 2)
											GROUND:TeleportTo(partner, 284, 188, Direction.Up) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(14)
											GROUND:CharSetEmote(hero, "shock", 1) end)
	coro3 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue("Hup!", 30) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	GAME:WaitFrames(60)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Hmm...[pause=0] It's still too far away.")
	
	--todo: improve
	GAME:WaitFrames(20)
	SOUND:PlayBattleSE('_UNK_EVT_010')
	GROUND:AnimateInDirection(partner, "Walk", Direction.Up, Direction.Down, 24, 1, 2)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	
	--GROUND:CharSetAction(partner, RogueEssence.Ground.HopGroundAction(partner.Position, partner.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex('None'), 16, 16))
	--GROUND:MoveToPosition(partner, 284, 188, false, 2)
	
	UI:WaitShowDialogue("We'd need more than just the two of us if we want to reach that low-hanging Apricorn.")
	GAME:WaitFrames(20)
	apricorn_glade_ch_4.PartyCountCheck()			
	
	
	
	
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
	
	UI:SetSpeaker(partner)
	--having an onix, since they're so tall, lets you skip having a 4th member
	if onix_teammate ~= nil then
		GROUND:CharAnimateTurnTo(partner, onix_teammate, 4)
		GROUND:CharAnimateTurnTo(onix_teammate, partner, 4)
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
		UI:SetSpeakerEmotion("Worried")
		if party_count == 2 then 
			UI:WaitShowDialogue("With just us two here,[pause=10] I don't think it'll be possible to get that Apricorn off the tree.")
			UI:WaitShowDialogue("We'll need a lot more help if we want to bring it back to the Guildmaster.")
		else
			UI:WaitShowDialogue("There's three of us here,[pause=10] but I still don't think that'll be enough.")
			UI:WaitShowDialogue("I think we'll need a full team if we want to bring that Apricorn back to the Guildmaster.")
		end
		GAME:WaitFrames(20)
		apricorn_glade_ch_4.TurnBack()
	elseif party_count == 4 then
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
	
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	
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
	
	GAME:MoveCamera(292, 192, 1, false)
	GROUND:TeleportTo(partner, 276, 144, Direction.Up)
	
	GAME:WaitFrames(60)
	
	
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
	
	--Onix Teammate? if so, play a special scene where the one onix helps the partner up
	if onix_teammate ~= nil then
	
		--TODO!!!!!!!!!!!!
		
	
	else
		--Determine the order of the bottom 3 of the stack. TODO: Improve by teleporting based on heights of characters
		local stack_order = {hero, team2, team3}
		table.sort(stack_order, apricorn_glade_ch_4.WeightCompare)
		
		GROUND:TeleportTo(stack_order[1], 276, 164, Direction.Up)
		GROUND:TeleportTo(stack_order[2], 276, 184, Direction.Up)
		GROUND:TeleportTo(stack_order[3], 276, 204, Direction.Up)
	
		UI:SetSpeaker(partner)
		UI:WaitShowDialogue("OK![pause=0] So I guess you get on top of you,[pause=10] and...")
		
		SOUND:PlayBattleSE("_UNK_EVT_089")
		GAME:WaitFrames(60)
		GAME:WaitFrames(20)
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
		
		UI:WaitShowDialogue("Alright![pause=0] I can get a good grip on this Apricorn now!")
		GAME:WaitFrames(20)
		
		apricorn_glade_ch_4.TowerWobble(partner, stack_order)
		GAME:WaitFrames(20)
		GeneralFunctions.EmoteAndPause(partner, "Exclaim", true)
		UI:SetSpeakerEmotion("Surprised")
		UI:WaitShowDialogue("Woah![pause=0] Careful,[pause=10] everyone![pause=0] Just try to hold steady!")
		GAME:WaitFrames(20)
		

		--different comment depending on where the hero is in the stack
		if LTBL(stack_order[1]).Importance == "Hero" then 
			GeneralFunctions.HeroDialogue(hero, "(It's not too hard for me this high up on the totem...)", "Worried")
			GeneralFunctions.HeroDialogue(hero, "(I just hope everyone below me is doing alright.)", "Worried")
		elseif LTBL(stack_order[2]).Importance == "Hero" then
			GeneralFunctions.HeroDialogue(hero, "(Urgh...[pause=0] This is tough...)", "Pain")
			GeneralFunctions.HeroDialogue(hero, "(I just hope we can hold out long enough for " .. partner:GetDisplayName() .. " to grab one of those Apricorns...)", "Pain")
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
		GeneralFunctions.StartTremble(stack_order[1])
		GeneralFunctions.StartTremble(stack_order[2])
		GeneralFunctions.StartTremble(stack_order[3])
		GROUND:CharSetDrawEffect(partner, DrawEffect.Trembling)
		
		GAME:WaitFrames(40)
		--different comment depending on where the hero is in the stack
		if LTBL(stack_order[1]).Importance == "Hero" then 
			GeneralFunctions.HeroDialogue(hero, "(Woah![pause=0] It's getting wobbly!)", "Surprised")
			GeneralFunctions.HeroDialogue(hero, "(I don't think our totem is going to last much longer!)", "Surprised")
		elseif LTBL(stack_order[2]).Importance == "Hero" then
			GeneralFunctions.HeroDialogue(hero, "(Urf...[pause=0] It's getting tough to keep balanced...)", "Pain")
			GeneralFunctions.HeroDialogue(hero, "(I don't think I can hold my spot on the totem much longer...)", "Pain")
		else
			GeneralFunctions.HeroDialogue(hero, "(I can't hold everyone up anymore...[pause=0] We're...[pause=0] about to fall over...)", "Dizzy")
		end
		
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Inspired")
		
		GAME:WaitFrames(20)
		UI:WaitShowDialogue("Yes![pause=0] I think I've got it!")
		
		--london bridge is falling! TODO: IMPROVE
		--TODO: Falling / rustling sounds from Apple Woods scene.
		local totem_base = stack_order[3].Position.Y
		
		
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
		anim1 = 'Hurt'
		if RogueEssence.Content.GraphicsManager.GetChara(mon_id_1:ToCharID()).AnimData:ContainsKey(52) then
			anim1 = 'Pain'
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
		local second_anim1 = 'None'
		if RogueEssence.Content.GraphicsManager.GetChara(mon_id_1:ToCharID()).AnimData:ContainsKey(56) then
			second_anim1 = 'Sit'
		end

		local second_anim2 = 'None'
		if RogueEssence.Content.GraphicsManager.GetChara(mon_id_2:ToCharID()).AnimData:ContainsKey(56) then
			second_anim2 = 'Sit'
		end

		
		GAME:WaitFrames(20)
		UI:SetSpeakerEmotion("Shouting")
		SOUND:PlayBattleSE('_UNK_EVT_038')
		local coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(18) UI:WaitShowTimedDialogue("Waaaaaaah!", 60) end)
		local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(18)
													  GROUND:MoveObjectToPosition(apricorn, apricorn.Position.X, 216, 3) 
													  GROUND:MoveObjectToPosition(apricorn, apricorn.Position.X, 192, 3) 
													  GROUND:MoveObjectToPosition(apricorn, apricorn.Position.X, 216, 3) end)
		local coro3 = TASK:BranchCoroutine(function() GROUND:CharEndDrawEffect(stack_order[3], DrawEffect.Trembling)
													  GROUND:CharSetAction(stack_order[3], RogueEssence.Ground.PoseGroundAction(stack_order[3].Position, stack_order[3].Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex(anim3))) end)
		local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
													  GROUND:CharEndDrawEffect(stack_order[2], DrawEffect.Trembling)
													  GROUND:AnimateToPosition(stack_order[2], second_anim2, Direction.Left, 252, stack_order[2].Y + 8, 1, 3)
													  GROUND:AnimateToPosition(stack_order[2], second_anim2, Direction.Left, 252, totem_base + 12, 1, 3)
													  SOUND:PlaySE('Hit Ground out of Fall')
													  GeneralFunctions.Recoil(stack_order[2], "Hurt", 10, 10, false)
													  GROUND:CharSetAction(stack_order[2], RogueEssence.Ground.PoseGroundAction(stack_order[2].Position, stack_order[2].Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex(anim2)))
													  end)
		local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(12)
													  GROUND:CharEndDrawEffect(stack_order[1], DrawEffect.Trembling)
													  GROUND:AnimateToPosition(stack_order[1], second_anim1, Direction.Right, 300, stack_order[1].Y + 8, 1, 3)
													  GROUND:AnimateToPosition(stack_order[1], second_anim1, Direction.Right, 300, totem_base + 16, 1, 3)
													  GeneralFunctions.Recoil(stack_order[1], "Hurt", 10, 10, false)
													  GROUND:CharSetAction(stack_order[1], RogueEssence.Ground.PoseGroundAction(stack_order[1].Position, stack_order[1].Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex(anim1)))
													  end)
		local coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(18)
													  GROUND:CharEndDrawEffect(partner, DrawEffect.Trembling)
													  GROUND:AnimateToPosition(partner, "Sit", Direction.Left, 276, 232, 1, 3)
													  GeneralFunctions.Recoil(partner, "Hurt", 10, 10, false)
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
		UI:WaitShowDialogue("Phew![pause=0] Looks like everyone's okay after that tumble.")
		
		GAME:WaitFrames(20)
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
		GROUND:CharSetEmote(partner, "glowing", 0)
		UI:WaitShowDialogue("We did it,[pause=10] " .. hero:GetDisplayName() .. "! Everyone![pause=0] We got the Apricorn!")
		GROUND:CharSetEmote(partner, "", 0)
		UI:WaitShowDialogue("Let's bring it back to the Guildmaster![pause=0] I bet he'll be so impressed by the size of this thing!")

		SV.Chapter4.FinishedGrove = true
		GAME:WaitFrames(30)
		SOUND:FadeOutBGM(60)
		GAME:FadeOut(false, 60)	
		GAME:WaitFrames(90)
		GAME:CutsceneMode(false)	
		GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 8, 0, false, false)
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
	UI:WaitShowDialogue("That being said...[pause=0] We can either head back into the dungeon,[pause=10] or we can call it a day.")
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
												GROUND:CharAnimateTurnTo(team3, Direction.Down, 4)
												GROUND:MoveToPosition(team3, Direction.Down, 120, false, 1) end end)
		local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(60) SOUND:FadeOutBGM(40) GAME:FadeOut(false, 40) end)

		TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
		GAME:CutsceneMode(false)
		GAME:WaitFrames(20)
		GAME:ContinueDungeon("apricorn_grove", 0, 7, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
	else 
		UI:WaitShowDialogue("OK,[pause=10] we'll go back to the guild then.")
		UI:WaitShowDialogue("Alright.[pause=0] Let's get back home!")
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