require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

apricorn_grove_entrance_ch_4 = {}


function apricorn_grove_entrance_ch_4.FirstAttemptCutscene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local team2 = CH('Teammate2')
	local team3 = CH('Teammate3')
	
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('apricorn_grove')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	GAME:MoveCamera(164, 184, 1, false)
	GROUND:TeleportTo(hero, 140, 320, Direction.Up)
	GROUND:TeleportTo(partner, 172, 320, Direction.Up)
	if team2 ~= nil then
		GROUND:TeleportTo(team2, 156, 352, Direction.Up)
	end
	if team3 ~= nil then
		GROUND:TeleportTo(team3, 188, 352, Direction.Up)
	end
	
	
	GAME:FadeIn(40)
	SOUND:PlayBGM('Star Cave.ogg', false)
	GAME:WaitFrames(20)
	--standard practice for teammates 2 and 3. Teammate 2 should be in the middle behind the two of them (or something else that's appropriate if needed)
	--teammate3 should be to the side of either player or partner, depending on what works best or is convenient.
	--exit a coroutine immediately if team2 or team3 doesn't exist.
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 172, 200, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:MoveToPosition(hero, 140, 200, false, 1) end)
	local coro3 = TASK:BranchCoroutine(function() if team2 ~= nil then GAME:WaitFrames(14) GROUND:MoveToPosition(team2, 156, 232, false, 1) end end)
	local coro4 = TASK:BranchCoroutine(function() if team3 ~= nil then GAME:WaitFrames(18) GROUND:MoveToPosition(team3, 188, 232, false, 1) end end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("This should be the forest that " .. CharacterEssentials.GetCharacterName("Tropius") .. " told us about.")
	UI:WaitShowDialogue("The opening here must be the entrance to the mystery dungeon.")
	
	GAME:WaitFrames(10)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	
	GeneralFunctions.Hop(partner)
	UI:SetSpeakerEmotion("Inspired")
	GROUND:CharSetAnim(partner, "Idle", true)
	GROUND:CharSetEmote(partner, "happy", 0)
	UI:WaitShowDialogue(hero:GetDisplayName() .. "![pause=0] Finally!")
	UI:WaitShowDialogue("A never before seen dungeon is right in front of us![pause=0] This is the kind of adventure I've been waiting for!")
	UI:WaitShowDialogue("I hope you're as excited about this as I am!")

	--should player comment on being excited about a new exploration opportunity? They already expressed this kind of sentiment with the expedition, which is probably more fitting anyway.
	--Probably should not comment, i think the happy and strange feelings about adventuring should stay ultimately related to the Anima Core stuff
	
	GAME:WaitFrames(20)
	GROUND:CharEndAnim(partner)
	GROUND:CharSetEmote(partner, "", 0)
	GeneralFunctions.DoubleHop(partner)
	UI:WaitShowDialogue("I can't wait any longer![pause=0] Let's go explore this forest right now!")
	UI:WaitShowDialogue("Let's do our best on this,[pause=10] " .. hero:GetDisplayName() .. "!")
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(hero, "Nod") end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(partner, "Nod") end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
											GROUND:MoveToPosition(partner, 172, 32, false, 1) end)	
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
											GROUND:MoveToPosition(hero, 140, 32, false, 1) end)
	coro3 = TASK:BranchCoroutine(function() if team2 ~= nil then GAME:WaitFrames(22) GROUND:MoveToPosition(team2, 156, 64, false, 1) end end)
	coro4 = TASK:BranchCoroutine(function() if team3 ~= nil then GAME:WaitFrames(26) GROUND:MoveToPosition(team3, 188, 64, false, 1) end end)
	
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(60) GAME:FadeOut(false, 40) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	GAME:CutsceneMode(false)
	SV.Chapter4.EnteredGrove = true 
	GAME:EnterDungeon("apricorn_grove", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end


--Came out the front end for the first time. Show them confused and to teach the player that the dungeon goes both ways
function apricorn_grove_entrance_ch_4.FirstComeOutFront()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local team2 = CH('Teammate2')
	local team3 = CH('Teammate3')
	local guest1 = CH('Guest1')
	local guest2 = CH('Guest2')
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('apricorn_grove')
	GAME:CutsceneMode(true)
	SOUND:StopBGM()
	AI:DisableCharacterAI(partner)
	GAME:MoveCamera(164, 184, 1, false)
	GROUND:TeleportTo(hero, 140, 40, Direction.Down)
	GROUND:TeleportTo(partner, 172, 40, Direction.Down)
	
	--Check if we have a guest. If we do, overwrite team2 or team3 accordingly based on party size so they take that slot in the cutscene.
	if guest1 ~= nil then
		if GAME:GetPlayerPartyCount() == 2 then 
			team2 = guest1 
		else
			team3 = guest1
		end
	end 
	
	if team2 ~= nil then
		GROUND:TeleportTo(team2, 156, 16, Direction.Down)
	end
	if team3 ~= nil then
		GROUND:TeleportTo(team3, 188, 16, Direction.Down)
	end
	
	GAME:WaitFrames(60)
	GAME:FadeIn(40)
	GAME:WaitFrames(20)
	
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 172, 144, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:MoveToPosition(hero, 140, 144, false, 1) end)
	local coro3 = TASK:BranchCoroutine(function() if team2 ~= nil then GAME:WaitFrames(14) GROUND:MoveToPosition(team2, 156, 120, false, 1) end end)
	local coro4 = TASK:BranchCoroutine(function() if team3 ~= nil then GAME:WaitFrames(18) GROUND:MoveToPosition(team3, 188, 120, false, 1) end end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	GROUND:CharSetEmote(partner, "question", 1)
	SOUND:PlayBattleSE('EVT_Emote_Confused')
	UI:WaitShowDialogue("Huh?")
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.LookAround(partner, 3, 4, true, false, false, Direction.Down)
											GAME:WaitFrames(10)
											GROUND:MoveToPosition(partner, 172, 200, false, 1) 
											GeneralFunctions.LookAround(partner, 3 , 4, true, true, false, Direction.Right) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.LookAround(hero, 3, 4, true, false, false, Direction.Down)
											GAME:WaitFrames(14)
											GROUND:MoveToPosition(hero, 140, 200, false, 1) 
											GeneralFunctions.LookAround(hero, 3 , 4, true, false, false, Direction.Left) end)
	coro3 = TASK:BranchCoroutine(function() if team2 ~= nil then 
											GAME:WaitFrames(6)
											GeneralFunctions.LookAround(team2, 3, 4, true, false, false, Direction.Down)
											GAME:WaitFrames(20)
											GROUND:MoveToPosition(team2, 156, 176, false, 1) 
											GeneralFunctions.LookAround(team2, 3 , 4, true, false, false, Direction.Down) end end)
	coro4 = TASK:BranchCoroutine(function() if team3 ~= nil then 
											GAME:WaitFrames(6)
											GeneralFunctions.LookAround(team3, 3, 4, true, false, false, Direction.Down)
											GAME:WaitFrames(20)
											GROUND:MoveToPosition(team3, 188, 176, false, 1) 
											GeneralFunctions.LookAround(team3, 3 , 4, true, false, false, Direction.DownLeft) end end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	GAME:WaitFrames(10)
	coro1 = TASK:BranchCoroutine(function()	GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(8) GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
	TASK:JoinCoroutines({coro1, coro2})

	
	UI:WaitShowDialogue("Isn't this...?")
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(partner, "Shock", true)
	UI:SetSpeakerEmotion("Surprised")
	SOUND:PlayBGM('Star Cave.ogg', false)
	UI:WaitShowDialogue("This is the entrance to the dungeon![pause=0] How did we end up back here!?") 
	GAME:WaitFrames(10)

	GeneralFunctions.EmoteAndPause(partner, "Sweating", true)
	UI:SetSpeakerEmotion("Pain")
	UI:WaitShowDialogue("Urk![pause=0] Seems like in this mystery dungeon,[pause=10] it's possible to go back the way we came.")
	UI:WaitShowDialogue("We'll have to be careful not to take the wrong way or we'll just end up back at the entrance!")

	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Well,[pause=10] we can't let this stop us.[pause=0] We'll just have to try again![script=0]", {function() return GeneralFunctions.Hop(partner) end})
	UI:WaitShowDialogue("Let's give it another shot,[pause=10] " .. hero:GetDisplayName() .. "!")
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(hero, "Nod") end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(partner, "Nod") end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(10)
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(12)
											GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
											GROUND:MoveToPosition(partner, 172, 32, false, 1) end)	
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
											GROUND:MoveToPosition(hero, 140, 32, false, 1) end)
	coro3 = TASK:BranchCoroutine(function() if team2 ~= nil then 
											GROUND:CharAnimateTurnTo(team2, Direction.Up, 4)
											GROUND:MoveToPosition(team2, 156, 8, false, 1) end end)
	coro4 = TASK:BranchCoroutine(function() if team3 ~= nil then 
											GROUND:CharAnimateTurnTo(team3, Direction.Up, 4)
											GROUND:MoveToPosition(team3, 188, 8, false, 1) end end)
	local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(60) GAME:FadeOut(false, 40) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	GAME:CutsceneMode(false)
	SV.Chapter4.BacktrackedOutGroveYet = true 
	GAME:ContinueDungeon("apricorn_grove", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

--died or escaped the previous time
function apricorn_grove_entrance_ch_4.SubsequentAttemptCutscene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local team2 = CH('Teammate2')
	local team3 = CH('Teammate3')
	
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('apricorn_grove')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	GAME:MoveCamera(164, 184, 1, false)
	GROUND:TeleportTo(hero, 140, 320, Direction.Up)
	GROUND:TeleportTo(partner, 172, 320, Direction.Up)
	if team2 ~= nil then
		GROUND:TeleportTo(team2, 156, 352, Direction.Up)
	end
	if team3 ~= nil then
		GROUND:TeleportTo(team3, 188, 352, Direction.Up)
	end
	
	
	GAME:FadeIn(40)
	SOUND:PlayBGM('Star Cave.ogg', false)
	GAME:WaitFrames(20)
	--standard practice for teammates 2 and 3. Teammate 2 should be in the middle behind the two of them (or something else that's appropriate if needed)
	--teammate3 should be to the side of either player or partner, depending on what works best or is convenient.
	--exit a coroutine immediately if team2 or team3 doesn't exist.
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 172, 200, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:MoveToPosition(hero, 140, 200, false, 1) end)
	local coro3 = TASK:BranchCoroutine(function() if team2 ~= nil then GAME:WaitFrames(14) GROUND:MoveToPosition(team2, 156, 232, false, 1) end end)
	local coro4 = TASK:BranchCoroutine(function() if team3 ~= nil then GAME:WaitFrames(18) GROUND:MoveToPosition(team3, 188, 232, false, 1) end end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("OK![pause=0] We're back at the dungeon's entrance.")
	
	GAME:WaitFrames(10)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Last time we were here,[pause=10] we couldn't find anything of interest...")

	--should player comment on being excited about a new exploration opportunity? They already expressed this kind of sentiment with the expedition, which is probably more fitting anyway.
	--Probably should not comment, i think the happy and strange feelings about adventuring should stay ultimately related to the Anima Core stuff
	
	GAME:WaitFrames(20)
	GeneralFunctions.DoubleHop(partner)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("But this time will be different![pause=0] I just know it!")
	UI:WaitShowDialogue("Let's make this adventure a success,[pause=10] " .. hero:GetDisplayName() .. "!")
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(hero, "Nod") end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(partner, "Nod") end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
											GROUND:MoveToPosition(partner, 172, 32, false, 1) end)	
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
											GROUND:MoveToPosition(hero, 140, 32, false, 1) end)
	coro3 = TASK:BranchCoroutine(function() if team2 ~= nil then GAME:WaitFrames(22) GROUND:MoveToPosition(team2, 156, 64, false, 1) end end)
	coro4 = TASK:BranchCoroutine(function() if team3 ~= nil then GAME:WaitFrames(26) GROUND:MoveToPosition(team3, 188, 64, false, 1) end end)
	
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(60) GAME:FadeOut(false, 40) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	GAME:CutsceneMode(false)
	GAME:EnterDungeon("apricorn_grove", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

--made it to the end, but didn't have enough mons to grab the treasure
function apricorn_grove_entrance_ch_4.FailedNoFullTeamReattempt()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local team2 = CH('Teammate2')
	local team3 = CH('Teammate3')
	
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('apricorn_grove')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	GAME:MoveCamera(164, 184, 1, false)
	GROUND:TeleportTo(hero, 140, 320, Direction.Up)
	GROUND:TeleportTo(partner, 172, 320, Direction.Up)
	if team2 ~= nil then
		GROUND:TeleportTo(team2, 156, 352, Direction.Up)
	end
	if team3 ~= nil then
		GROUND:TeleportTo(team3, 188, 352, Direction.Up)
	end
	
	
	GAME:FadeIn(40)
	SOUND:PlayBGM('Star Cave.ogg', false)
	GAME:WaitFrames(20)
	--standard practice for teammates 2 and 3. Teammate 2 should be in the middle behind the two of them (or something else that's appropriate if needed)
	--teammate3 should be to the side of either player or partner, depending on what works best or is convenient.
	--exit a coroutine immediately if team2 or team3 doesn't exist.
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 172, 200, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:MoveToPosition(hero, 140, 200, false, 1) end)
	local coro3 = TASK:BranchCoroutine(function() if team2 ~= nil then GAME:WaitFrames(14) GROUND:MoveToPosition(team2, 156, 232, false, 1) end end)
	local coro4 = TASK:BranchCoroutine(function() if team3 ~= nil then GAME:WaitFrames(18) GROUND:MoveToPosition(team3, 188, 232, false, 1) end end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("OK![pause=0] We're back at the dungeon's entrance.")
	
	GAME:WaitFrames(10)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Last time we were here,[pause=10] we couldn't get the huge Apricorn off the tree in depths of the dungeon...")

	--should player comment on being excited about a new exploration opportunity? They already expressed this kind of sentiment with the expedition, which is probably more fitting anyway.
	--Probably should not comment, i think the happy and strange feelings about adventuring should stay ultimately related to the Anima Core stuff
	
	GAME:WaitFrames(20)
	GeneralFunctions.DoubleHop(partner)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("This time,[pause=10] let's be sure to have a full team so we can grab the huge Apricorn!")
	UI:WaitShowDialogue("Let's bring it back this time,[pause=10] " .. hero:GetDisplayName() .. "!")
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(hero, "Nod") end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(partner, "Nod") end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
											GROUND:MoveToPosition(partner, 172, 32, false, 1) end)	
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
											GROUND:MoveToPosition(hero, 140, 32, false, 1) end)
	coro3 = TASK:BranchCoroutine(function() if team2 ~= nil then GAME:WaitFrames(22) GROUND:MoveToPosition(team2, 156, 64, false, 1) end end)
	coro4 = TASK:BranchCoroutine(function() if team3 ~= nil then GAME:WaitFrames(26) GROUND:MoveToPosition(team3, 188, 64, false, 1) end end)
	
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(60) GAME:FadeOut(false, 40) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	GAME:CutsceneMode(false)
	GAME:EnterDungeon("apricorn_grove", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

return apricorn_grove_entrance_ch_4




