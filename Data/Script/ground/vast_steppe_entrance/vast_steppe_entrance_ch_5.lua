require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

vast_steppe_entrance_ch_5 = {}

function vast_steppe_entrance_ch_5.SetupGround()	

	if not SV.Chapter5.EnteredSteppe then 
		local noctowl, tropius, mareep, cranidos, zigzagoon, growlithe, breloom, girafarig, tail = 
		CharacterEssentials.MakeCharactersFromList({
			{'Noctowl', 352, 280, Direction.DownLeft},
			{'Tropius', 272, 272, Direction.Right},
			{'Mareep', 86, 384, Direction.DownRight},
			{'Cranidos', 86, 420, Direction.UpRight},
			{'Zigzagoon', 122, 420, Direction.UpLeft},
			{'Growlithe', 122, 384, Direction.DownLeft},
			{'Breloom', 336, 408, Direction.Down},
			{'Girafarig', 336, 440, Direction.Up},
			{'Tail'}
		})
			
		--set rin and coco to spawn from the spawners, then spawn them
		GROUND:SpawnerSetSpawn("TEAMMATE_2", GAME:GetPlayerPartyMember(2))
		local snubbull = GROUND:SpawnerDoSpawn("TEAMMATE_2")
			
		GROUND:SpawnerSetSpawn("TEAMMATE_3", GAME:GetPlayerPartyMember(3))
		local audino = GROUND:SpawnerDoSpawn("TEAMMATE_3")
		
	else
		local noctowl, tropius = 
		CharacterEssentials.MakeCharactersFromList({
			{'Noctowl', 352, 280, Direction.DownRight},
			{'Tropius', 376, 304, Direction.UpLeft}
		})
			
		--set rin and coco to spawn from the spawners, then spawn them
		GROUND:SpawnerSetSpawn("TEAMMATE_2", GAME:GetPlayerPartyMember(2))
		local snubbull = GROUND:SpawnerDoSpawn("TEAMMATE_2")
			
		GROUND:SpawnerSetSpawn("TEAMMATE_3", GAME:GetPlayerPartyMember(3))
		local audino = GROUND:SpawnerDoSpawn("TEAMMATE_3")
		
		--teleport them to their new spot.
		GROUND:TeleportTo(snubbull, 224, 216, Direction.Right)
		GROUND:TeleportTo(audino, 272, 216, Direction.Left)
	end
end


--TASK:BranchCoroutine(vast_steppe_entrance_ch_5.ArrivalCutscene)
function vast_steppe_entrance_ch_5.ArrivalCutscene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GROUND:Hide('Supply_Bag')
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('vast_steppe')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	SOUND:StopBGM()
	GAME:MoveCamera(256, 296, 1, false)	

	local tropius, noctowl, audino, snubbull, growlithe, zigzagoon, girafarig, breloom, mareep, cranidos = 
	CharacterEssentials.MakeCharactersFromList({
		{'Tropius', 248, 452, Direction.Up},
		{'Noctowl', 216, 452, Direction.Up},
		{'Audino', 268, 524, Direction.Up},
		{'Snubbull', 260, 484, Direction.Up},
		{'Growlithe', 204, 484, Direction.Up},
		{'Zigzagoon', 196, 516, Direction.Up},
		{'Girafarig', 264, 444, Direction.Up},
		{'Breloom', 232, 452, Direction.Up},
		{'Mareep', 236, 476, Direction.Up},
		{'Cranidos', 228, 524, Direction.Up}})
	
	GROUND:TeleportTo(hero, 300, 508, Direction.Up)
	GROUND:TeleportTo(partner, 292, 476, Direction.Up)



	GAME:FadeIn(40)
	SOUND:PlayBGM('Sky Peak Prairie.ogg', true)
	GAME:WaitFrames(40)
	
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(girafarig, Direction.Up, 172, false, 1) 
												  GROUND:CharAnimateTurnTo(girafarig, Direction.Down, 4)
												  end)
	local coro2 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(breloom, Direction.Up, 180, false, 1) 
												  GROUND:CharAnimateTurnTo(breloom, Direction.Down, 4)
												  end)	
	TASK:JoinCoroutines({coro1, coro2})
	GeneralFunctions.DoubleHop(breloom)
	
	UI:SetSpeaker(breloom)
	UI:SetSpeakerEmotion("Happy")
	GROUND:CharSetEmote(breloom, "happy", 0)
	UI:WaitShowDialogue("C'mon,[pause=10] slowpokes![pause=0] The entrance is right over here!")
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(breloom, "", 0)
	
	--everyone comes walking in
	SOUND:LoopSE("Guild's Feet Pitterpatter")
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(tropius, Direction.Up, 180, false, 1)
											GROUND:CharAnimateTurnTo(tropius, Direction.Down, 4)
											end)	
	coro2 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(noctowl, Direction.Up, 188, false, 1) 
											GROUND:CharAnimateTurnTo(noctowl, Direction.Down, 4)
											end)		
	local coro3 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(audino, Direction.Up, 196, false, 1) 
												  end)	
	local coro4 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(snubbull, Direction.Up, 184, false, 1) 
												  end)	
	local coro5 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(growlithe, Direction.Up, 180, false, 1) 
												  GROUND:MoveInDirection(growlithe, Direction.UpRight, 8, false, 1) 
												  GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4)
												  end)	
	local coro6 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(zigzagoon, Direction.Up, 188, false, 1) 
												  GROUND:MoveInDirection(zigzagoon, Direction.UpRight, 8, false, 1) 
												  GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4)
												  end)	
	local coro7 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(mareep, Direction.Up, 176, false, 1) 
												  end)	
	local coro8 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(cranidos, Direction.Up, 196, false, 1) 
												  end)	
	local coro9 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMoveRS(partner, 284, 296, false, 1) 
											      GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
												  end)	
	local coro10 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMoveRS(hero, 292, 324, false, 1) 
												   GROUND:CharAnimateTurnTo(hero, Direction.UpLeft, 4)
												   end)	
    local coro11 = TASK:BranchCoroutine(function() GAME:WaitFrames(80)
												   GROUND:CharAnimateTurnTo(breloom, Direction.Left, 4)
												   GeneralFunctions.EightWayMoveRS(breloom, 184, 272, false, 1)
												   GROUND:CharAnimateTurnTo(breloom, Direction.DownRight, 4)
												   end)		
	local coro12 = TASK:BranchCoroutine(function() GAME:WaitFrames(86)
												   GROUND:CharAnimateTurnTo(girafarig, Direction.Left, 4)
												   GeneralFunctions.EightWayMoveRS(girafarig, 192, 248, false, 1)
												   GROUND:CharAnimateTurnTo(girafarig, Direction.DownRight, 4)
												   end)	
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9, coro10, coro11, coro12})
	SOUND:StopSE("Guild's Feet Pitterpatter")
	
	--phileas, reinier, and kino discuss a bit while penticus is distracted by the unmoving flower
	GAME:WaitFrames(30)
	UI:SetSpeakerEmotion("Normal")
	
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowDialogue("Here we are,[pause=10] everyone.[pause=0] We've made it to our first stop!")
								 end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(12) 
											GROUND:CharAnimateTurnTo(growlithe, Direction.UpLeft, 4)										
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(14) 
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.UpLeft, 4)										
											end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(18) 
											GROUND:CharAnimateTurnTo(cranidos, Direction.UpLeft, 4)
											end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(16) 
											GROUND:CharAnimateTurnTo(mareep, Direction.UpLeft, 4)
											end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(22) 
											GROUND:CharAnimateTurnTo(snubbull, Direction.UpLeft, 4)
											end)	
	coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) 
											GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
											end)
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(14) 
											GROUND:CharAnimateTurnTo(audino, Direction.UpLeft, 4)
											end)		
	coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(18) 
											GROUND:CharAnimateTurnTo(tropius, Direction.Left, 4)
											end)	
	coro10 = TASK:BranchCoroutine(function() GAME:WaitFrames(24) 
											GROUND:CharAnimateTurnTo(noctowl, Direction.Left, 4)
											end)	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9, coro10})

	--GeneralFunctions.DoubleHop(growlithe, 'None', 6, 6, true, true)
	--UI:SetSpeaker(growlithe)
	--UI:SetSpeakerEmotion("Joyous")
	--UI:WaitShowDialogue("Ruff![pause=0] We're finally here![pause=0] I can't wait for this adventure,[pause=10] ruff!")

	GAME:WaitFrames(20)	
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("Based on our surroundings,[pause=10] this must be the entrance to " .. zone:GetColoredName() .. ",[pause=10] correct?")
	
	GAME:WaitFrames(12)
	GROUND:CharAnimateTurnTo(breloom, Direction.Right, 4)
	GROUND:CharAnimateTurnTo(girafarig, Direction.Right, 4)
	
	UI:SetSpeaker(breloom)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Yup![pause=0] You can tell by the Kangaskhan Rock behind me.[pause=0] It's a great landmark!")
	GAME:WaitFrames(10)
	
	GeneralFunctions.EmoteAndPause(partner, "Question", true)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("What's a Kangaskhan Rock?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(breloom)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("You don't know what a Kangaskhan Rock is?[pause=0] Wow,[pause=10] it really is your first expedition,[pause=10] isn't it?")
	GAME:WaitFrames(10)
	
	GROUND:CharAnimateTurnTo(breloom, Direction.Left, 4)
	GROUND:CharAnimateTurnTo(girafarig, Direction.Left, 4)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("See this statue here?[pause=0] That's a Kangaskhan Rock.[pause=0] They're a big help for adventurers on the go!")
	UI:WaitShowDialogue("You can use them to store and take out items,[pause=10] deposit and withdraw your money,[pause=10] and record your progress.")
	UI:WaitShowDialogue("They're typically found outside mystery dungeons,[pause=10] and sometimes even inside!")
	GROUND:CharAnimateTurnTo(breloom, Direction.DownRight, 4)
	GROUND:CharAnimateTurnTo(girafarig, Direction.DownRight, 4)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("They're super convenient![pause=0] Without them,[pause=10] this journey would be way tougher![pause=0] We're lucky to have them around!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("Oh,[pause=10] neat![pause=0] We'll have to make good use of them!")
	GAME:WaitFrames(30)
	
	UI:SetSpeaker(zigzagoon)
	--UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Hmm...[pause=0] " .. breloom:GetDisplayName() .. " and " .. girafarig:GetDisplayName() .. ",[pause=10] you've been through this mystery dungeon before,[pause=10] right?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(girafarig)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("That's right![pause=0] In fact,[pause=10] we've conked all the dungeons we're gonna be traveling through!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(zigzagoon)
	UI:WaitShowDialogue("Is there anything you can tell us about this dungeon?[pause=0] I want to be prepared for what's ahead!")
	GAME:WaitFrames(20)

	UI:SetSpeaker(girafarig)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Hmm,[pause=10] let me think...")
	GAME:WaitFrames(60)
	GeneralFunctions.EmoteAndPause(girafarig, "Sweating", true)
	UI:SetSpeakerEmotion("Sad")
	--wrap in a branch coroutine so the script = 0 tag does not make you wait for the action to finish. Do not need to join the coroutine back in.
	UI:WaitShowDialogue("Oh rear![pause=0] I can't seem to recall what this dungeon's like![pause=0][script=0] How embarassing...", {function() TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(tropius, Direction.Right, 4) end) end})
	GAME:WaitFrames(12)
	
	GROUND:CharAnimateTurnTo(breloom, Direction.Up, 4)
	UI:SetSpeaker(breloom)
	UI:WaitShowDialogue("What's wrong,[pause=10] " .. girafarig:GetDisplayName() .. "?[pause=0] Did your brain migrate to your tail and join " .. CharacterEssentials.GetCharacterName("Tail") .. "?")
	GAME:WaitFrames(20)
	
	GROUND:CharAnimateTurnTo(girafarig, Direction.Down, 4)
	GeneralFunctions.Complain(girafarig, true)
	UI:SetSpeaker(girafarig)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("H-hey![pause=0] We went through so many dungeons on our trip,[pause=10] it's tough to keep track of what one had which!")
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(girafarig, "", 0)
	
	UI:SetSpeaker(breloom)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Alright,[pause=10] alright,[pause=10] fair enough![pause=0] You know I love to give you a hard time,[pause=10] heheh!")
	
	GAME:WaitFrames(10)
	GROUND:CharAnimateTurnTo(breloom, Direction.DownRight, 4)
	GROUND:CharAnimateTurnTo(girafarig, Direction.DownRight, 4)
	
	--tropius wanders over to the still flower
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("My memory's a bit sharper than " .. girafarig:GetDisplayName() .. "'s,[pause=10] so I can tell you all about " .. zone:GetColoredName() .. "!")
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("The layout is a lot more open than most mystery dungeons.[pause=0] It's unlike any I've seen before!")
	--wrap in a branch coroutine so the script = 0 tag does not make you wait for the action to finish. Do not need to join the coroutine back in.
	UI:WaitShowDialogue("The Pokémon here also like to stay in packs.[pause=0][script=0] It'll be rare to find one fighting by itself.", {function() TASK:BranchCoroutine(function() GROUND:MoveInDirection(tropius, Direction.Right, 24, false, 1) end) end})
	UI:WaitShowDialogue("Combine that with the open layout,[pause=10] and it's real easy to get swarmed by a bunch of enemies at the same time!")
	GAME:WaitFrames(20)
	
	--seems like it could be dangerous...
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(2)
											GROUND:CharAnimateTurnTo(growlithe, Direction.DownRight, 4)
											GROUND:CharSetAnim(growlithe, "Idle", true) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4)
											GROUND:CharSetAnim(zigzagoon, "Idle", true) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharAnimateTurnTo(cranidos, Direction.Up, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:CharAnimateTurnTo(mareep, Direction.Down, 4)
											GROUND:CharSetAnim(mareep, "Idle", true) end)
	coro5 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(audino, Direction.UpRight, 4)
											GROUND:CharSetAnim(audino, "Idle", true) end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(snubbull, Direction.DownRight, 4)
											GROUND:CharSetAnim(snubbull, "Idle", true) end)								 
	coro7 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
											 GROUND:CharSetAnim(partner, "Idle", true) end)	
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8})		

	UI:SetSpeaker(snubbull)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Swarmed?[pause=0] I can't take on that many opponents at once!")
	GAME:WaitFrames(20)

	UI:SetSpeaker(cranidos)
	UI:WaitShowDialogue("I'm not scared.[pause=0] There's no way the Pokémon here are tougher than the outlaws I've fought!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(audino)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("But it sounds like t-things could go b-badly if we're not careful...")
	GAME:WaitFrames(22)

	--Worry not says phileas. That's why we have our strategy of larger teams after all. Guildmaster? Guildmaster??	
	GROUND:CharAnimateTurnTo(noctowl, Direction.Down, 4)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("Not to worry,[pause=10] everyone.")
	GAME:WaitFrames(10)
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(2)
											GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4)
											GROUND:CharEndAnim(growlithe) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4)
											GROUND:CharEndAnim(zigzagoon) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharAnimateTurnTo(cranidos, Direction.Up, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:CharEndAnim(mareep)
											GROUND:CharAnimateTurnTo(mareep, Direction.Up, 4)
											end)
	coro5 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(audino, Direction.UpLeft, 4) 
											GROUND:CharEndAnim(audino)
											end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharEndAnim(snubbull)
											GROUND:CharAnimateTurnTo(snubbull, Direction.UpLeft, 4) 
											end)							 
	coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(hero, Direction.UpLeft, 4) end)	
	coro8 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.UpLeft, 4) 
											GROUND:CharEndAnim(partner) end)
	coro9 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(breloom, Direction.Right, 4) end)
	coro10 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
						                    GROUND:CharAnimateTurnTo(girafarig, Direction.DownRight, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9})	

	GAME:WaitFrames(10)
	UI:WaitShowDialogue("As explained back at the guild,[pause=10] we will be grouping up into larger teams.")
	UI:WaitShowDialogue("These larger teams should make overcoming the dungeon more managable.")
	UI:WaitShowDialogue("All we need is for the Guildmaster to select the group members.[pause=0][script=0] Guildmaster,[pause=10] if you would?", {function() TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(noctowl, Direction.Right, 4) end) end})--wrap in a branch coroutine so the script = 0 tag does not make you wait for the action to finish. Do not need to join the coroutine back in.
	GAME:WaitFrames(50)
	
	GeneralFunctions.EmoteAndPause(noctowl, "Question", true)
	UI:WaitShowDialogue("Guildmaster?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Worried")
	
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(50)
											UI:WaitShowDialogue(".........") end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(noctowl, Direction.Right, 4) 
											GROUND:MoveInDirection(noctowl, Direction.Right, 24, false, 1) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(2)
											GeneralFunctions.FaceMovingCharacter(growlithe, noctowl, 4, Direction.UpRight)
											end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GeneralFunctions.FaceMovingCharacter(zigzagoon, noctowl, 4, Direction.UpRight)
											end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GeneralFunctions.FaceMovingCharacter(cranidos, noctowl, 4, Direction.UpRight)
											end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GeneralFunctions.FaceMovingCharacter(mareep, noctowl, 4, Direction.UpRight)
											end)
	coro7 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(audino, noctowl, 4, Direction.Up)
											end)
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GeneralFunctions.FaceMovingCharacter(snubbull, noctowl, 4, Direction.Up)
											end)	
	coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.FaceMovingCharacter(hero, noctowl, 4, Direction.UpLeft) 
											end)									 
	coro10 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(partner, noctowl, 4, Direction.UpLeft) 	
											 end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9, coro10})
	
	GAME:WaitFrames(10)
	GeneralFunctions.Complain(noctowl)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("Guildmaster!")
	
	GAME:WaitFrames(10)
	--GeneralFunctions.Recoil(tropius, "Hurt", 10, 10, true, false)
	--GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(tropius, "Exclaim", true)
	GROUND:CharTurnToCharAnimated(tropius, noctowl, 4)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Y-yes,[pause=10] " .. noctowl:GetDisplayName() .. "![pause=0] What is it!?")
	GAME:WaitFrames(20)
	
	--todo: an emotion for noctowl here maybe? he never really shows emotion, but the guildmaster is acting odd here too.
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("We need you to decide how to split up the guild members.")
	GAME:WaitFrames(20)
	
	--... Oh, right! Of course!	
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Stunned")
	UI:WaitShowDialogue("Oh,[pause=10] right![pause=0] Of course!")

	GAME:WaitFrames(10)	
	GROUND:CharAnimateTurnTo(tropius, Direction.Down, 4)
	GROUND:CharAnimateTurnTo(noctowl, Direction.Down, 4)
	
	
	--As you know our strat is to split up into teams. Kino and Reinier will stay as 2 and lead the way.
	--me and phileas will remain back and hand out supplies to anyone who's struggling to get through the dungeon.
	--Now, for the teams...
	UI:SetSpeakerEmotion("Normal")
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowDialogue("Alright Pokémon![pause=0] Like we discussed back in the guild,[pause=10] we'll be splitting up into groups now!")
											UI:WaitShowDialogue(breloom:GetDisplayName() .. " and " .. girafarig:GetDisplayName() .. " will stay as a pair and get a camp set up at our next destination.")
											UI:WaitShowDialogue(noctowl:GetDisplayName() .. " and I will remain here until everyone has made it through the dungeon safely.")
											UI:WaitShowDialogue("If you're struggling,[pause=10] come see us by the supply bag and we'll give you some supplies to help!")
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(12) 
											GROUND:CharAnimateTurnTo(growlithe, Direction.UpRight, 4)										
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(14) 
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.UpRight, 4)										
											end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(18) 
											GROUND:CharAnimateTurnTo(cranidos, Direction.UpRight, 4)
											end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(16) 
											GROUND:CharAnimateTurnTo(mareep, Direction.UpRight, 4)
											end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(22) 
											GROUND:CharAnimateTurnTo(snubbull, Direction.Up, 4)
											end)	
	coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(14) 
											GROUND:CharAnimateTurnTo(audino, Direction.Up, 4)
											end)	
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) 
											GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
											end)	
	coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(30) 
											GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
											end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9})

	
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("Without further ado,[pause=10] let me announce the teams!")
	UI:WaitShowDialogue("For team one,[pause=10] we have " .. snubbull:GetDisplayName() .. ",[pause=10] " .. audino:GetDisplayName() .. ",[pause=10] " .. partner:GetDisplayName() .. ",[pause=10] and " .. hero:GetDisplayName() .. ".")
	GAME:WaitFrames(10)
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(2)
											GROUND:CharAnimateTurnTo(growlithe, Direction.Right, 4)
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.Right, 4)
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharAnimateTurnTo(cranidos, Direction.Right, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:CharAnimateTurnTo(mareep, Direction.Right, 4)
											end)
	coro5 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(audino, Direction.UpRight, 4) end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(snubbull, Direction.Right, 4) 
											end)							 
	coro7 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.DownLeft, 4) end)
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(hero, Direction.Left, 4) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8})	
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(audino)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Hey![pause=0] We're on a team together![pause=0] I hope everything g-goes well for us!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("It's gonna be fun adventuring with both of you![pause=0] Let's do our best!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(tropius)
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowDialogue("And for team two,[pause=10] we have " .. mareep:GetDisplayName() .. ",[pause=10] " .. cranidos:GetDisplayName() .. ",[pause=10] and " .. zigzagoon:GetDisplayName() .. "!")
								 end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(12) 
											GROUND:CharAnimateTurnTo(growlithe, Direction.UpRight, 4)										
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(14) 
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.UpRight, 4)										
											end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(18) 
											GROUND:CharAnimateTurnTo(cranidos, Direction.UpRight, 4)
											end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(16) 
											GROUND:CharAnimateTurnTo(mareep, Direction.UpRight, 4)
											end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(22) 
											GROUND:CharAnimateTurnTo(snubbull, Direction.Up, 4)
											end)	
	coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(14) 
											GROUND:CharAnimateTurnTo(audino, Direction.Up, 4)
											end)	
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) 
											GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
											end)	
	coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(30) 
											GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
											end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9})
	GAME:WaitFrames(10)
		
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(2)
											GROUND:CharAnimateTurnTo(growlithe, Direction.DownRight, 4)
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.Right, 4)
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharAnimateTurnTo(cranidos, Direction.Left, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:CharAnimateTurnTo(mareep, Direction.DownLeft, 4)
											end)
	coro5 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(audino, Direction.Left, 4) end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(snubbull, Direction.Left, 4) 
											end)							 
	coro7 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Left, 4) 
											GROUND:CharEndAnim(partner) end)
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(hero, Direction.Left, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8})
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(zigzagoon)
	UI:WaitShowDialogue("Hmm![pause=0] I think we've got a strong team here!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(mareep)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Sa-a-a-ame![pause=0] We'll have this dungeon beat in no time!")
	GAME:WaitFrames(40)
	
	--Ruff, Penticus... What about me? You didn't call my name! What team am I on?
	GROUND:CharAnimateTurnTo(growlithe, Direction.UpRight, 4)
	SOUND:FadeOutBGM(120)
	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Um,[pause=10] " .. tropius:GetDisplayName() .. "...[pause=0] What about me,[pause=10] ruff?")
	GAME:WaitFrames(10)
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.UpRight, 4)
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharAnimateTurnTo(cranidos, Direction.UpRight, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:CharAnimateTurnTo(mareep, Direction.UpRight, 4)
											end)
	coro4 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(audino, Direction.Up, 4) end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(snubbull, Direction.Up, 4) 
											end)							 
	coro6 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) end)
	coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7})	
	
	GAME:WaitFrames(10)
	
	--UI:SetSpeaker(zigzagoon)
	--UI:SetSpeakerEmotion("Worried")
	--UI:WaitShowDialogue("Hey,[pause=10] you're right,[pause=10] " .. growlithe:GetDisplayName() .. "![pause=0] You forgot to call his name out with mine,[pause=10] Guildmaster!")
	--GAME:WaitFrames(20)
	
	--O-oh! You're on my team of course!
	GROUND:CharAnimateTurnTo(tropius, Direction.DownLeft, 4)
	UI:SetSpeaker(tropius)
	GeneralFunctions.EmoteAndPause(tropius, "Question", true)
	UI:WaitShowDialogue("What do you mean?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("You didn't call my name![pause=0] Shouldn't I be on team two,[pause=10] with " .. zigzagoon:GetDisplayName() .. "?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(tropius)
	--UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(growlithe:GetDisplayName() .. ",[pause=10] you're with me,[pause=10] like usual.[pause=0] I figured you knew that!")
	GAME:WaitFrames(20)
		
	--...But... I want to adventure with Almotz! And everyone else!
	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("B-but...[pause=0] You said the rest of us would get split into two teams!")
	UI:WaitShowDialogue("I want to adventure with " .. zigzagoon:GetDisplayName() .. "![pause=0] And everyone else too,[pause=10] ruff!")
	UI:WaitShowDialogue("Why do I have to go with you?")
	GAME:WaitFrames(20)
	
	
	--you know how i worry...
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(growlithe:GetDisplayName() .. "...[pause=0] You know how I worry about you.")
	UI:WaitShowDialogue("It gives me peace of mind knowing you're with me,[pause=10] where I can protect you if something happens.")
	GAME:WaitFrames(20)
	
	--Penticus, please...
	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("But I was really looking forward to adventuring with everyone,[pause=10] ruff!")
	UI:WaitShowDialogue("I know you want to keep me safe,[pause=10] but I never get to go on any actual adventures!")
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Please,[pause=10] let me go with the others,[pause=10] ruff!")
	GAME:WaitFrames(20)
	
	--
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Pain")
	UI:WaitShowDialogue("...[pause=30]This is something you really want,[pause=10] huh?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Ruff![pause=0] More than anything!")

	GAME:WaitFrames(40)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("...Alright.[pause=0] If that's what you really want.")
	
	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(growlithe, "Exclaim", true)
	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Inspired")
	GROUND:CharSetAnim(growlithe, "Idle", true)
	UI:WaitShowDialogue("R-really!?[pause=0] You mean it!?[script=0]", {function() GeneralFunctions.Hop(growlithe) end})
	GAME:WaitFrames(20)
	
	GROUND:CharEndAnim(growlithe)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Yes.[pause=0] I shouldn't coddle you so much,[pause=10] it's not fair to you.")
	UI:WaitShowDialogue("Join " .. zigzagoon:GetDisplayName() .. "'s team for this mystery dungeon.[pause=0] Just...[pause=30] be careful,[pause=10] OK?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Ruff![pause=0] Thank you " .. tropius:GetDisplayName() .. "![pause=0] I'll be careful,[pause=10] I promise,[pause=10] ruff!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(mareep:GetDisplayName() .. ",[pause=10] " .. cranidos:GetDisplayName() .. ",[pause=10] " .. zigzagoon:GetDisplayName() .. "...[pause=0] This goes for you too.[pause=0] Keep each other safe,[pause=10] OK?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(zigzagoon)
	UI:WaitShowDialogue("You don't need to worry,[pause=10] Guildmaster![pause=0] We'll all protect each other!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(mareep)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Yeah![pause=0] We'll all keep each other sa-a-a-a-afe![pause=0] You've got nothing to worry about!")
	GAME:WaitFrames(30)
	
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("...Thank you.[pause=0] I really appreciate hearing that.")
	GAME:WaitFrames(60)
	
	SOUND:PlayBGM('Sky Peak Prairie.ogg', true)
	GROUND:CharAnimateTurnTo(tropius, Direction.Down, 4)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("...Well,[pause=10] the teams are squared away now.[pause=0] Let's not dawdle here any more.")
	UI:WaitShowDialogue("Everyone should take a moment now to prepare themselves for the dungeon ahead.")
	UI:WaitShowDialogue("Once your group feels ready,[pause=10] proceed through the steppe towards the next stop.")
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Alright Pokémon,[pause=10] let's get to it!")
	
	GAME:WaitFrames(20)
		
	--well we have our team. Let's get ready and roll out.
	--hero is distracted with that feeling. Been getting a little bit stronger as they get further out. WHAT DOES IT MEAN???
	--snap out of it hero! -- ACTUALLY DO THIS NEXT DUNGEON OR DURING THE NIGHT. THIS SCENE'S A BIT DENSE AS IT IS.
	GROUND:CharSetEmote(growlithe, "happy", 0)
	GROUND:CharSetEmote(zigzagoon, "happy", 0)
	GROUND:CharSetEmote(mareep, "happy", 0)
	GROUND:CharSetEmote(breloom, "happy", 0)
	GROUND:CharSetEmote(audino, "happy", 0)	
	GROUND:CharSetEmote(partner, "happy", 0)

	--turn pokemon so pose is appropriate
	GROUND:EntTurn(growlithe, Direction.Up)
	GROUND:EntTurn(zigzagoon, Direction.Up)
	GROUND:EntTurn(snubbull, Direction.Up)
	GROUND:EntTurn(audino, Direction.Up)
	GROUND:EntTurn(mareep, Direction.Up)
	GROUND:EntTurn(cranidos, Direction.Up)
	GROUND:EntTurn(breloom, Direction.Down)
	GROUND:EntTurn(girafarig, Direction.Down)
	GROUND:EntTurn(partner, Direction.Up)
	GROUND:EntTurn(hero, Direction.Up)
	
	GROUND:CharSetAction(growlithe, RogueEssence.Ground.PoseGroundAction(growlithe.Position, growlithe.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(zigzagoon, RogueEssence.Ground.PoseGroundAction(zigzagoon.Position, zigzagoon.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(breloom, RogueEssence.Ground.PoseGroundAction(breloom.Position, breloom.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(girafarig, RogueEssence.Ground.PoseGroundAction(girafarig.Position, girafarig.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(cranidos, RogueEssence.Ground.PoseGroundAction(cranidos.Position, cranidos.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(mareep, RogueEssence.Ground.PoseGroundAction(mareep.Position, mareep.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(audino, RogueEssence.Ground.PoseGroundAction(audino.Position, audino.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(snubbull, RogueEssence.Ground.PoseGroundAction(snubbull.Position, snubbull.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))	
	GROUND:CharSetAction(partner, RogueEssence.Ground.PoseGroundAction(partner.Position, partner.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))	
	GROUND:CharSetAction(hero, RogueEssence.Ground.PoseGroundAction(hero.Position, hero.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))	
	UI:SetSpeaker('[color=#00FFFF]Everyone[color]', true, "", -1, "", RogueEssence.Data.Gender.Unknown)	
	UI:WaitShowDialogue("HURRAH!")
	
	GAME:WaitFrames(60)
	GAME:FadeOut(false, 60)
	
	--Clean up the existing spawns, then call SetupGround to spawn them in.
	--GeneralFunctions.DefaultParty(false)
	--reinitialize the hero and partner variables after respawning the party.
	--Failing to do this has later functions try to teleport the "old" versions of them, causing a phantom glitch.
	--hero = CH('PLAYER')
	--partner = CH('Teammate1')
	--partner.CollisionDisabled = true
	
	--Setup Coco and Rin.
	local snubbull_id = RogueEssence.Dungeon.MonsterID("snubbull", 0, "normal", Gender.Female)
	local snubbull_monster = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, snubbull_id, SV.GuildSidequests.SnubbullLevel, "run_away", 0)
	snubbull_monster.Discriminator = _DATA.Save.Rand:Next()--tbh idk what this is lol
	snubbull_monster.Nickname = CharacterEssentials.GetCharacterName('Snubbull', true)
	snubbull_monster.MetAt = "Adventurer's Guild"
	snubbull_monster.IsPartner = true
	snubbull_monster.IsFounder = true
	
	--snubbull's stats are kinda dookie in comparison to audino, so boost her up a bit.
	snubbull_monster.MaxHPBonus = 1
	snubbull_monster.SpeedBonus = 5
	
	snubbull_monster:ReplaceSkill("bite", 0, true)
	snubbull_monster:ReplaceSkill("lick", 1, true)
	snubbull_monster:ReplaceSkill("smelling_salts", 2, true)
	snubbull_monster:ReplaceSkill("charm", 3, false)
		
	GAME:AddPlayerTeam(snubbull_monster)
	snubbull_monster:FullRestore()
	local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("GuildmateInteract")
    snubbull_monster.ActionEvents:Add(talk_evt)
	snubbull_monster:RefreshTraits()

	local audino_id = RogueEssence.Dungeon.MonsterID("audino", 0, "normal", Gender.Female)
	local audino_monster = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, audino_id, SV.GuildSidequests.AudinoLevel, "regenerator", 0)
	audino_monster.Discriminator = _DATA.Save.Rand:Next()--tbh idk what this is lol
	audino_monster.Nickname = CharacterEssentials.GetCharacterName('Audino', true)
	audino_monster.MetAt = "Adventurer's Guild"
	audino_monster.IsPartner = true
	audino_monster.IsFounder = true
	
	audino_monster:ReplaceSkill("double_slap", 0, true)
	audino_monster:ReplaceSkill("heal_bell", 1, true)
	audino_monster:ReplaceSkill("disarming_voice", 2, true)
	audino_monster:ReplaceSkill("helping_hand", 3, false)
	
		
	GAME:AddPlayerTeam(audino_monster)
	audino_monster:FullRestore()
	local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("GuildmateInteract")
    audino_monster.ActionEvents:Add(talk_evt)
	audino_monster:RefreshTraits()
	
	--prevent heal bell from being unlearned.
	GAME:LockSkill(GAME:GetPlayerPartyMember(3), 1)


	GAME:GetCurrentGround():RemoveTempChar(breloom)
	GAME:GetCurrentGround():RemoveTempChar(girafarig)
	GAME:GetCurrentGround():RemoveTempChar(tropius)
	GAME:GetCurrentGround():RemoveTempChar(noctowl)
	GAME:GetCurrentGround():RemoveTempChar(snubbull)
	GAME:GetCurrentGround():RemoveTempChar(audino)
	GAME:GetCurrentGround():RemoveTempChar(growlithe)
	GAME:GetCurrentGround():RemoveTempChar(zigzagoon)
	GAME:GetCurrentGround():RemoveTempChar(cranidos)
	GAME:GetCurrentGround():RemoveTempChar(mareep)
		
	noctowl, tropius, mareep, cranidos, zigzagoon, growlithe, breloom, girafarig, tail = 
	CharacterEssentials.MakeCharactersFromList({
		{'Noctowl', 352, 280, Direction.DownLeft},
		{'Tropius', 272, 272, Direction.Right},
		{'Mareep', 86, 384, Direction.DownRight},
		{'Cranidos', 86, 420, Direction.UpRight},
		{'Zigzagoon', 122, 420, Direction.UpLeft},
		{'Growlithe', 122, 384, Direction.DownLeft},
		{'Breloom', 336, 408, Direction.Down},
		{'Girafarig', 336, 440, Direction.Up},
		{'Tail'}
	})
		
	--set rin and coco to spawn from the spawners, then spawn them
	GROUND:SpawnerSetSpawn("TEAMMATE_2", GAME:GetPlayerPartyMember(2))
	snubbull = GROUND:SpawnerDoSpawn("TEAMMATE_2")
		
	GROUND:SpawnerSetSpawn("TEAMMATE_3", GAME:GetPlayerPartyMember(3))
	audino = GROUND:SpawnerDoSpawn("TEAMMATE_3")

	GROUND:Unhide('Supply_Bag')
	  	
	GROUND:CharEndAnim(partner)	
	GROUND:CharEndAnim(hero)	
	GROUND:CharSetEmote(partner, "", 0)
	GROUND:TeleportTo(hero, 240, 344, Direction.Down)
	GROUND:TeleportTo(partner, 240, 312, Direction.Down)
	GAME:MoveCamera(0, 0, 1, true)
	
	
	GAME:WaitFrames(20)
	GAME:FadeIn(60)
	
	partner.CollisionDisabled = true--redisable partner's collision. Something is causing this to be set to false earlier in the script...
	SV.Chapter5.FinishedSteppeIntro = true
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)
	GAME:CutsceneMode(false)
	
end 


function vast_steppe_entrance_ch_5.Tropius_Action(chara, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	if SV.Chapter5.NeedGiveSupplies then
		GeneralFunctions.StartConversation(chara, "Struggling with the dungeon?[pause=0] " .. CharacterEssentials.GetCharacterName("Noctowl") .. " can get the four of you back on your way with some supplies!")
	elseif SV.Chapter5.EnteredSteppe then
		GeneralFunctions.StartConversation(chara, "Tough dungeon,[pause=10] huh?[pause=0] Don't worry,[pause=10] I know all of you can do it!")
		UI:WaitShowDialogue("I recommend coordinating with each other whenever you're in a tough spot.")
		UI:WaitShowDialogue("I'm sure no matter what bind you get into,[pause=10] you'll be able to work together to get out of it!")
	elseif not SV.Chapter5.SpokeToTropiusSteppe then
		--hints as his relationship with growlithe, as well as the larger issue here. Should also have a small sense of urgency.
		--May be a bit of a tell don't show here with regards to how the expedition's been going so far...
		GeneralFunctions.StartConversation(chara, "Howdy,[pause=10] Team " .. GAME:GetTeamName() .. "![pause=0] How have you been enjoying the expedition so far?")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("Traveling's been tiring,[pause=10] but it's been great![pause=0] I'm really happy we were able to come along!")
		GAME:WaitFrames(20)
		
		GROUND:CharTurnToChar(chara, partner)
		UI:SetSpeaker(chara)
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("Why wouldn't you?[pause=0] You've both been doing so well since you've joined the guild!")
		UI:WaitShowDialogue("There's no way we wouldn't let you come along!")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Inspired")
		UI:WaitShowDialogue("O-oh,[pause=10] really?[pause=0] Thank you,[pause=10] Guildmaster![pause=0] That means a lot coming from you!")
		
		GAME:WaitFrames(40)
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue("Um,[pause=10] Guildmaster?[pause=0] Could I ask you something?")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(chara)
		UI:WaitShowDialogue("Of course![pause=0] What do you want to know?")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue("Is everything alright with " .. CharacterEssentials.GetCharacterName("Growlithe") .. "?[pause=0] That scene before seemed pretty serious...")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(chara)
		UI:WaitShowDialogue("Oh,[pause=10] that?[pause=0] I just worry about him.[pause=0] He's too reckless for his own good.")
		UI:WaitShowDialogue("It's nothing you should worry yourselves over.")
		GAME:WaitFrames(20)
		
		GROUND:CharAnimateTurnTo(chara, Direction.Right, 4)
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue("There's plenty of other things to worry about,[pause=10] after all...")
		GAME:WaitFrames(40)
		
		GROUND:CharTurnToCharAnimated(chara, hero, 4)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("Anyways...[pause=0] You two,[pause=10] " .. CharacterEssentials.GetCharacterName("Audino") .. ",[pause=10] and " .. CharacterEssentials.GetCharacterName("Snubbull") .. " should get a move on.[pause=0] There's no time to waste!")
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("Good luck,[pause=10] and enjoy the adventure!")
		SV.Chapter5.SpokeToTropiusSteppe = true
	else
		GeneralFunctions.StartConversation(chara, "You two,[pause=10] " .. CharacterEssentials.GetCharacterName("Audino") .. ",[pause=10] and " .. CharacterEssentials.GetCharacterName("Snubbull") .. " should get a move on.[pause=0] There's no time to waste!", "Normal")
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("Good luck,[pause=10] and enjoy the adventure!")
	end 
	GeneralFunctions.EndConversation(chara)
end 

function vast_steppe_entrance_ch_5.Noctowl_Action(chara, activator)
	if SV.Chapter5.NeedGiveSupplies then
		GeneralFunctions.StartConversation(chara, "Encountered some trouble I see.[pause=0] Take these,[pause=10] they should help.")
		GAME:WaitFrames(20)
		GeneralFunctions.RewardItem("food_apple")
		GeneralFunctions.RewardItem("berry_oran")
		GeneralFunctions.RewardItem("berry_leppa")
		GAME:WaitFrames(20)
		UI:SetSpeaker(chara)
		UI:WaitShowDialogue("I trust that these supplies will aid you on your next attempt.[pause=0] Safe travels.")
		SV.Chapter5.NeedGiveSupplies = false
	elseif SV.Chapter5.EnteredSteppe then
		GeneralFunctions.StartConversation(chara, "I trust those supplies will aid you on your next attempt.[pause=0] Safe travels.")	
	else
		GeneralFunctions.StartConversation(chara, "If you find yourself struggling with the mystery dungeon,[pause=10] come see me.")
		UI:WaitShowDialogue("I will get you back on your way with some supplies to assist.")
	end 
	GeneralFunctions.EndConversation(chara)
end 

function vast_steppe_entrance_ch_5.Breloom_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Good luck with the steppe![pause=0] If you're not careful,[pause=10] things can go south quickly!")
	UI:WaitShowDialogue("My advice would be to stick together and coordinate with your team to avoid getting singled out.")
	UI:WaitShowDialogue("Me and " .. CharacterEssentials.GetCharacterName("Girafarig") .. " stayed close during our adventure,[pause=10] and things went smoothly for us!")
	GeneralFunctions.EndConversation(chara)
end 

function vast_steppe_entrance_ch_5.Girafarig_Action(chara, activator)
	local tail = CH('Tail')
	GeneralFunctions.StartConversation(chara, "I may not remember what dungeon had what,[pause=10] but I do remember they all had Kecleon Shops!")
	UI:WaitShowDialogue("Kecleon Shops are handy if you're low on supplies out in the field.[pause=0] Their convenience is unbeaten!")
	UI:WaitShowDialogue("You should carry some money with you on in case they have something you hind useful.")
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("Because if you walk out of a Kecleon Shop without the money to pay for the goods you're taking...[pause=0] Urk!")
	--UI:WaitShowDialogue("Because believe me,[pause=10] you do NOT want to steal from a Kecleon Shop.")
	UI:SetSpeakerEmotion("Pain")
	UI:WaitShowDialogue("Just...[pause=30] trust me on that one.[pause=0] " .. tail:GetDisplayName() .. "'s too sneaky for his own good...")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(tail)
	UI:SetSpeakerEmotion("Special0")
	UI:WaitShowDialogue(".........")
	GeneralFunctions.EndConversation(chara)
end 

function vast_steppe_entrance_ch_5.Growlithe_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "We gotta be real careful,[pause=10] like " .. CharacterEssentials.GetCharacterName("Tropius") .. " asked.", "Normal", false)
	UI:SetSpeakerEmotion("Joyous")
	UI:WaitShowDialogue("Even so,[pause=10] this is gonna be so much fun,[pause=10] ruff![pause=0] Let's finish getting ready and get going!")
	GeneralFunctions.EndConversation(chara)
end 

function vast_steppe_entrance_ch_5.Zigzagoon_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "I'm glad the Guildmaster let you on our team,[pause=10] " .. CharacterEssentials.GetCharacterName("Growlithe") .. ".", "Normal", false)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("My heart sank when I realized you might not be joining us...")
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("So I'm glad we're gonna get to adventure together after all!")
	GeneralFunctions.EndConversation(chara)
end 

function vast_steppe_entrance_ch_5.Audino_Action(chara, activator)
	if SV.Chapter5.NeedGiveSupplies then
		GeneralFunctions.StartConversation(chara, "You should go and grab some stuff from " .. CharacterEssentials.GetCharacterName("Noctowl") .. "![pause=0] We could use the help for our next try!")

	elseif SV.Chapter5.EnteredSteppe then
		GeneralFunctions.StartConversation(chara, "Oh,[pause=10] you have the supplies from " .. CharacterEssentials.GetCharacterName("Noctowl") .. "![pause=0] Wonderful!", "Happy")
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("When you're both ready,[pause=10] we should get moving.[pause=0] We'll do it for s-sure this time!")
	else
		GeneralFunctions.StartConversation(chara, CharacterEssentials.GetCharacterName("Snubbull") .. " and I are ready to go whenever you two are![pause=0] Just let us know!")
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("Let's do our best to get through this m-mystery dungeon together!")
	end 
	GeneralFunctions.EndConversation(chara)
end 

function vast_steppe_entrance_ch_5.Snubbull_Action(chara, activator)
	if SV.Chapter5.NeedGiveSupplies then
		GeneralFunctions.StartConversation(chara, "You two should go check in with " .. CharacterEssentials.GetCharacterName("Noctowl") .. ".[pause=0] He should have some supplies for us.")
		UI:SetSpeakerEmotion("Special0")
		UI:WaitShowDialogue("I wonder what sort of things he has for us?[pause=0] I hope he has something delectable I can cook with. " .. STRINGS:Format("\\u266A"))
	elseif SV.Chapter5.EnteredSteppe then
		GeneralFunctions.StartConversation(chara, "Hmmrh...[pause=0] You can't make anything special with those supplies.[pause=0] How drab!", "Sad")	
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("Oh well...[pause=0] When you're both ready,[pause=10] let's give it another go.")
	else
		GeneralFunctions.StartConversation(chara, "You should prepare yourselves for the dungeon ahead with the Kangaskhan Rock next to me.")
		UI:SetSpeakerEmotion("Special0")
		UI:WaitShowDialogue("I hope you have some delicacies you can bring with you from storage...")
		UI:WaitShowDialogue("Perhaps I could cook you up something special on the fly. " .. STRINGS:Format("\\u266A"))
	end
	GeneralFunctions.EndConversation(chara)
end 

function vast_steppe_entrance_ch_5.Mareep_Action(chara, activator)
	vast_steppe_entrance_ch_5.Mareep_Cranidos_Conversation(chara, activator)
end 

function vast_steppe_entrance_ch_5.Cranidos_Action(chara, activator)
	vast_steppe_entrance_ch_5.Mareep_Cranidos_Conversation(chara, activator)
end 

function vast_steppe_entrance_ch_5.Mareep_Cranidos_Conversation(chara, activator)
	local cranidos = CH('Cranidos')
	local mareep = CH('Mareep')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	
	partner.IsInteracting = true
	GROUND:CharSetAnim(mareep, 'None', true)
	GROUND:CharSetAnim(cranidos, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharSetAnim(partner, 'None', true)
	
	GROUND:CharTurnToChar(hero, chara)
    local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)

	UI:SetSpeaker(cranidos)
	UI:WaitShowDialogue("You two better buck up and and try your hardest.[pause=0] I don't want to see you two messing up!")
    TASK:JoinCoroutines({coro1})
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(mareep)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Oh " .. cranidos:GetDisplayName() .. ",[pause=10] we'll all do grea-a-a-at![pause=0] You worry too much!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(cranidos)
	UI:SetSpeakerEmotion("Stunned")
	GROUND:CharSetEmote(cranidos, "sweating", 1)
	UI:WaitShowDialogue("M-maybe...[pause=0] But I still think we should take this seriously.")
	UI:WaitShowDialogue("Especially since " .. CharacterEssentials.GetCharacterName("Growlithe") .. " is with us.[pause=0] If something were to happen to him...")
	UI:WaitShowDialogue("I don't even want to think about how the Guildmaster would react!")

	GROUND:CharEndAnim(mareep)
	GROUND:CharEndAnim(cranidos)
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	partner.IsInteracting = false
end




function vast_steppe_entrance_ch_5.FailedCutscene()

	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local snubbull = CH('Teammate2')
	local audino = CH('Teammate3')
	local tropius = CH('Tropius')
	local noctowl = CH('Noctowl')
	local coro1, coro2, coro3
	
	GAME:CutsceneMode(true)
	SOUND:StopBGM()
	AI:DisableCharacterAI(partner)
	GROUND:TeleportTo(partner, 264, 184, Direction.Right)
	GROUND:TeleportTo(hero, 232, 184, Direction.Left)
	
	GROUND:EntTurn(snubbull, Direction.Up)
	GROUND:EntTurn(audino, Direction.Up)

	GROUND:CharSetAnim(tropius, "Idle", true)	
	GROUND:CharSetAnim(noctowl, "Idle", true)
	GAME:MoveCamera(256, 192, 1, false)
		
	if SV.Chapter5.DiedSteppe then 
		GROUND:CharSetAnim(partner, "EventSleep", true)
		GROUND:CharSetAnim(hero, "EventSleep", true)
				
		GAME:FadeIn(40)
		SOUND:PlayBGM('Sky Peak Prairie.ogg', true)
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
		TASK:JoinCoroutines({coro1, coro2})
				
		GAME:WaitFrames(30)
		
		coro1 = TASK:BranchCoroutine(function () GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) end)
		coro2 = TASK:BranchCoroutine(function () GROUND:CharAnimateTurnTo(partner, Direction.Down, 4) end)
		TASK:JoinCoroutines({coro1, coro2})
	elseif SV.Chapter5.EscapedSteppe then
		GROUND:EntTurn(hero, Direction.Down)
		GROUND:EntTurn(partner, Direction.Down)

		GAME:FadeIn(40)
		SOUND:PlayBGM('Sky Peak Prairie.ogg', true)
		GAME:WaitFrames(20)
	end

	--todo: if snubbull gets eventsleep/wake animations, use them here.
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion('Pain')
	GROUND:CharSetEmote(partner, 'sweating', 1)		
	UI:WaitShowDialogue("Ugh...[pause=0] This steppe is no joke!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(snubbull)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("It's definitely as difficult as " .. CharacterEssentials.GetCharacterName("Breloom") .. " made it out to be!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	--UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("We can't give up though![pause=0] We just have to try again![script=0]", {function() TASK:BranchCoroutine(function() GeneralFunctions.Hop(partner) end) end})
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(audino)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Y-yeah![pause=0] The supplies " .. CharacterEssentials.GetCharacterName("Noctowl") .. " has should make our next try easier too!")
	UI:WaitShowDialogue("Let's grab those and we'll do it for sure this time!")
	
	GAME:WaitFrames(20)
	GeneralFunctions.PanCamera()

	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(audino, snubbull, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:CharTurnToCharAnimated(snubbull, audino, 4) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	GROUND:CharEndAnim(tropius)
	GROUND:CharEndAnim(noctowl)
	SV.Chapter5.DiedSteppe = false
	SV.Chapter5.EscapedSteppe = false
	SV.Chapter5.NeedGiveSupplies = true

	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)
	GROUND:CharTurnToChar(partner, hero)
	GAME:CutsceneMode(false)
	
end



function vast_steppe_entrance_ch_5.Dungeon_Entrance_Touch(obj, activator)

	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local snubbull = CH('Teammate2')
	local audino = CH('Teammate3')
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("vast_steppe") 
	
	local result = false
	
	GROUND:CharSetAnim(partner, "None", true)
	GROUND:CharSetAnim(hero, "None", true)
	local coro1 = TASK:BranchCoroutine(function() result = GeneralFunctions.StartPartnerYesNo("Are we all set to head out,[pause=10] " .. hero:GetDisplayName() .. "?") end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GROUND:CharTurnToCharAnimated(audino, hero, 4) GROUND:CharSetAnim(audino, "None", true) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(16) GROUND:CharTurnToCharAnimated(snubbull, hero, 4) GROUND:CharSetAnim(snubbull, "None", true) end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3})
	GAME:WaitFrames(10)		
	if result then 
		GROUND:Hide('Dungeon_Entrance')

		coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, 264, 184, false, 1)
												GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
												GROUND:CharSetAnim(partner, "None", true) end)	
		coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(hero, 232, 184, false, 1)
												GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
												GROUND:CharSetAnim(hero, "None", true) end) 
		coro3 = TASK:BranchCoroutine(function() GeneralFunctions.PanCamera(nil, nil, false, nil, 256, 192) end)
		TASK:JoinCoroutines({coro1, coro2, coro3})
		
		coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(audino, 272, 216, false, 1)
												GROUND:CharAnimateTurnTo(audino, Direction.Up, 4) 
												GROUND:CharSetAnim(audino, "None", true) end)
		coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
												GeneralFunctions.EightWayMove(snubbull, 224, 216, false, 1)
												GROUND:CharAnimateTurnTo(snubbull, Direction.Up, 4)
												GROUND:CharSetAnim(snubbull, "None", true) end)
		TASK:JoinCoroutines({coro1, coro2})
		
		
		UI:SetSpeaker(snubbull)
	
		
		if not SV.Chapter5.EnteredSteppe then 
			UI:WaitShowDialogue("All prepared you two?[pause=0] Perfect. " .. STRINGS:Format("\\u266A") .. "[pause=0]\nLet us be off!")
		else 
			UI:WaitShowDialogue("All prepared you two?[pause=0] Perfect. " .. STRINGS:Format("\\u266A") .. "[pause=0]\nNo failing this time!")
		end 
		
		
		GAME:WaitFrames(10)
		
		coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
												GROUND:MoveInDirection(partner, Direction.Up, 100, false, 1) end)			
		coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
												GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
												GROUND:MoveInDirection(hero, Direction.Up, 100, false, 1) end)		
		coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(24)
												GROUND:MoveInDirection(audino, Direction.Up, 90, false, 1) end)			
		local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(26)
													  GROUND:MoveInDirection(snubbull, Direction.Up, 90, false, 1) end)	
		local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(60) GAME:FadeOut(false, 40) end)


		TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})	
		
		GeneralFunctions.EndConversation(partner)
		SV.Chapter5.EnteredSteppe = true
		--Reset this flag if you go in case you go in without taking anything.
		SV.Chapter5.NeedGiveSupplies = false
		GAME:EnterDungeon("vast_steppe", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)

		
	else
		UI:WaitShowDialogue("OK.[pause=0] Let's get ourselves ready,[pause=10] and we'll move out then!")
		coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EndConversation(partner) end)
		coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(snubbull, audino, 4) GROUND:CharEndAnim(snubbull) end)
		coro3 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(audino, snubbull, 4) GROUND:CharEndAnim(audino) end)
		TASK:JoinCoroutines({coro1, coro2, coro3})
	end

end
--[[
function vast_steppe_entrance_ch_5.Oddish_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Hi weird lady![pause=0] I hope you're doing OK in here![pause=0]\nI brought you some flowers to cheer you up!", "Happy", false)
	UI:WaitShowDialogue("You should come outside and see my mom's garden sometime!")
	UI:WaitShowDialogue("There's all kinds of pretty flowers I think would make you feel happy there!")
	GeneralFunctions.EndConversation(chara)
end
]]--