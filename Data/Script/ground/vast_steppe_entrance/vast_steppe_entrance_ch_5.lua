require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

vast_steppe_entrance_ch_5 = {}

function vast_steppe_entrance_ch_5.SetupGround()	

	if not SV.Chapter5.EnteredVastSteppe then 
		local noctowl, tropius, mareep, cranidos, zigzagoon, growlithe, breloom, girafarig = 
		CharacterEssentials.MakeCharactersFromList({
			{'Noctowl', 352, 280, Direction.DownLeft},
			{'Tropius', 272, 272, Direction.Right},
			{'Mareep', 86, 384, Direction.DownRight},
			{'Cranidos', 86, 420, Direction.UpRight},
			{'Zigzagoon', 122, 420, Direction.UpLeft},
			{'Growlithe', 122, 384, Direction.DownLeft},
			{'Breloom', 336, 408, Direction.Down},
			{'Girafarig', 336, 440, Direction.Up}
		})
	else
	
	end
	GAME:FadeIn(20)
end


--TASK:BranchCoroutine(vast_steppe_entrance_ch_5.ArrivalCutscene)
function vast_steppe_entrance_ch_5.ArrivalCutscene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
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
	
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowDialogue("Here we are,[pause=10] everyone![pause=0] We've made it to our first stop!")
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
	UI:WaitShowDialogue("Yup![pause=0] You can tell by the Kangaskhan Rock behind me![pause=0] It's a great landmark!")
	GAME:WaitFrames(10)
	
	GeneralFunctions.EmoteAndPause(partner, "Question", true)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("What's a Kangaskhan Rock?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(breloom)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("You don't know what a Kangaskhan Rock is?[pause=0] It really is your first expedition!")
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
	UI:WaitShowDialogue("They're super convenient![pause=0] Without them,[pause=10] this journey would be way tougher!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("Oh,[pause=10] neat![pause=0] We'll have to keep an eye out for them!")
	GAME:WaitFrames(30)
	
	UI:SetSpeaker(zigzagoon)
	--UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Hmm...[pause=0] " .. breloom:GetDisplayName() .. " and " .. girafarig:GetDisplayName() .. ",[pause=10] you've been through this mystery dungeon before,[pause=10] right?")
	UI:WaitShowDialogue("Is there anything you can tell us about it?[pause=0] I want to be prepared for what's ahead!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(girafarig)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("That's right![pause=0] Actually,[pause=10] we've conquered all the dungeons we're gonna be traveling through!")
	GAME:WaitFrames(20)
	
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("As for how this one is,[pause=10] let me remember...")
	GAME:WaitFrames(60)
	GeneralFunctions.EmoteAndPause(girafarig, "Sweating", true)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("Oh rear![pause=0] I can't seem to recall![script=0][pause=0] How embarassing...", {function() GROUND:CharAnimateTurnTo(tropius, Direction.Right, 4) end})
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
	UI:WaitShowDialogue("The Pokémon here also like to stay in packs.[script=0][pause=0] It'll be rare to find one fighting by itself.", {function() GROUND:MoveInDirection(tropius, Direction.Right, 24, false, 1) end})
	UI:WaitShowDialogue("Combine that with the open layout,[pause=10] and it's real easy to get swarmed by a bunch of enemies at once!")
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
	UI:WaitShowDialogue("Swarmed?[pause=0] I don't know if I can take on so many opponents at once!")
	GAME:WaitFrames(20)

	UI:SetSpeaker(cranidos)
	UI:WaitShowDialogue("I'm not scared.[pause=0] There's no way the Pokémon here are tougher than the outlaws I've fought!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(audino)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("But it sounds like t-things could go b-badly if we're not careful...")
	GAME:WaitFrames(30)

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
	coro7 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.UpLeft, 4) 
											GROUND:CharEndAnim(partner) end)
	coro8 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(breloom, Direction.Right, 4) end)
	coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
						                    GROUND:CharAnimateTurnTo(girafarig, Direction.DownRight, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9})	

	GAME:WaitFrames(10)
	UI:WaitShowDialogue("As explained back at the guild,[pause=10] we will be grouping up into larger teams.")
	UI:WaitShowDialogue("These larger teams should make overcoming the dungeon more managable.")
	UI:WaitShowDialogue("The Guildmaster simply needs to select the members for each group.[pause=0] [script=0]Guildmaster,[script=0][pause=10] if you would?", {function() GROUND:CharAnimateTurnTo(noctowl, Direction.Right, 4) end})
	GAME:WaitFrames(50)
	
	GeneralFunctions.EmoteAndPause(noctowl, "Question", true)
	UI:WaitShowDialogue("Guildmaster?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Worried")
	
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(30)
											UI:WaitShowDialogue(".........[pause=40]") end)
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
	GeneralFunctions.Recoil(tropius, "Hurt", 10, 10, true, false)
	GROUND:CharTurnToCharAnimated(tropius, noctowl, 4)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Y-yes,[pause=10] " .. noctowl:GetDisplayName() .. "![pause=0] What is it!?")
	GAME:WaitFrames(20)
	
	--todo: an emotion for noctowl here maybe? he never really shows emotion, but the guildmaster is acting odd here too.
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("You need to choose how to split up the guild members.")
	GAME:WaitFrames(20)
	
	--... Oh, right! Of course!	
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Stunned")
	UI:WaitShowDialogue("Oh,[pause=10] right![pause=0] Of course!")

	GAME:WaitFrames(4)	
	GROUND:CharAnimateTurnTo(tropius, Direction.Down, 4)
	GROUND:CharAnimateTurnTo(noctowl, Direction.Down, 4)
	
	
	--As you know our strat is to split up into teams. Kino and Reinier will stay as 2 and lead the way.
	--me and phileas will remain back and hand out supplies to anyone who's struggling to get through the dungeon.
	--Now, for the teams...
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Alright Pokémon![pause=0] Like we discussed back in the guild,[pause=10] we'll be splitting up into groups now!")
	UI:WaitShowDialogue(breloom:GetDisplayName() .. " and " .. girafarig:GetDisplayName() .. " will stay together and get a camp set up at our next destination.")
	UI:WaitShowDialogue(noctowl:GetDisplayName() .. " and I will remain here everyone has made it through the dungeon safely.")
	UI:WaitShowDialogue("If you're struggling,[pause=10] come see us by the supply bag and we'll give you some supplies to help!")
	
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("Without further ado,[pause=10] let me announce the first set of teams.")
	UI:WaitShowDialogue("Team one will be " .. snubbull:GetDisplayName() .. ",[pause=10] " .. audino:GetDisplayName() .. ",[pause=10] " .. partner:GetDisplayName() .. ",[pause=10] and " .. hero:GetDisplayName() .. ".")
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
	UI:WaitShowDialogue("H-hey![pause=0] We're on a team together![pause=0] Hopefully everything g-goes well!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("It'll be fun to adventure with the two of you![pause=0] Let's do our best!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(tropius)
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowDialogue("And team two will be " .. mareep:GetDisplayName() .. ",[pause=10] " .. cranidos:GetDisplayName() .. ",[pause=10] and " .. zigzagoon:GetDisplayName() .. "!")
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
											GROUND:CharAnimateTurnTo(audino, Direction.UpLeft, 4)
											end)	
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) 
											GROUND:CharAnimateTurnTo(partner, Direction.UpLeft, 4)
											end)	
	coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(30) 
											GROUND:CharAnimateTurnTo(hero, Direction.UpLeft, 4)
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
	
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.UpRight, 4)
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharAnimateTurnTo(cranidos, Direction.UpRight, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:CharAnimateTurnTo(mareep, Direction.UpRight, 4)
											end)
	coro5 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(audino, Direction.Up, 4) end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(snubbull, Direction.Up, 4) 
											end)							 
	coro7 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.UpLeft, 4) end)
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(hero, Direction.UpLeft, 4) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8})	
	
	GAME:WaitFrames(20)
	
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
	UI:WaitShowDialogue("You didn't call my name![pause=0] What team am I on?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(tropius)
	--UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(growlithe:GetDisplayName() .. ",[pause=10] you're with me,[pause=10] like usual.[pause=0] I figured you knew that!")
	GAME:WaitFrames(20)
		
	--...But... I want to adventure with Almotz! And everyone else!
	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("B-but...[pause=0] You said the rest of us would get split into two teams,[pause=10] ruff!")
	UI:WaitShowDialogue("I want to adventure with " .. zigzagoon:GetDisplayName() .. "![pause=0] And everyone else too,[pause=10] ruff!")
	UI:WaitShowDialogue("Why do I have to go with you,[pause=10] ruff?")
	GAME:WaitFrames(20)
	
	
	--you know how i worry...
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(growlithe:GetDisplayName() .. "...[pause=0] You know how I worry about you.")
	UI:WaitShowDialogue("It gives me peace of mind knowing you're with me,[pause=10] where I can protect you if something bad happens.")
	GAME:WaitFrames(20)
	
	--Penticus, please...
	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue(tropius:GetDisplayName() .. ",[pause=10] please! I was really looking forward to adventuring with everyone,[pause=10] ruff!")
	UI:WaitShowDialogue("I know you want to keep me safe,[pause=10] but I never get to go on any actual adventures,[pause=10] ruff!")
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Please,[pause=10] let me go with the others,[pause=10] ruff!")
	GAME:WaitFrames(20)
	
	--
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Pain")
	UI:WaitShowDialogue(".........")
	GAME:WaitFrames(40)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("...Alright.[pause=0] If that's what you really want.")
	
	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(growlithe, "Exclaim", true)
	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("R-really!?[pause=0] You mean it!?[script=0]", {function() GeneralFunctions.Hop(growlithe) end})
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Yes.[pause=0] I shouldn't coddle you so much,[pause=10] it isn't fair to you.")
	UI:WaitShowDialogue("Join " .. zigzagoon:GetDisplayName() .. "'s team for this mystery dungeon.[pause=0] Just...[pause=30] be careful,[pause=10] OK?")
	GAME:WaitFrames(20)
	UI:WaitShowDialogue(mareep:GetDisplayName() .. ",[pause=10] " .. cranidos:GetDisplayName() .. ",[pause=10] " .. zigzagoon:GetDisplayName() .. "...[pause=0] All of you...[pause=0] Stay safe,[pause=10] OK?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(zigzagoon)
	UI:WaitShowDialogue("You don't need to worry,[pause=10] Guildmaster![pause=0] We'll all do our best!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(mareep)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(" ")
	GAME:WaitFrames(30)
	
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("...Thank you.[pause=0] I really appreciate hearing that.")
	GAME:WaitFrames(60)
	
	SOUND:PlayBGM('Sky Peak Prairie.ogg', true)
	GROUND:CharAnimateTurnTo(tropius, Direction.Down, 4)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("...Well,[pause=10] that squares away the teams.[pause=0] We should all get ready to travel through the steppe!")
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
	GeneralFunctions.DefaultParty(false)
	
	--Setup Rin and Coco.
	local audino_id = RogueEssence.Dungeon.MonsterID("audino", 0, "normal", Gender.Female)
	local audino_monster = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, audino_id, SV.GuildSidequests.AudinoLevel, "regenerator", 0)
	audino_monster.Discriminator = _DATA.Save.Rand:Next()--tbh idk what this is lol
	audino_monster.Nickname = CharacterEssentials.GetCharacterName('Audino', true)
	audino_monster.MetAt = "Adventurer's Guild"
	audino_monster.IsPartner = true
	audino_monster.IsFounder = true
	
	audino_monster:ReplaceSkill("double_slap", 0, true)
	audino_monster:ReplaceSkill("heal_bell", 1, false)
	audino_monster:ReplaceSkill("disarming_voice", 2, true)
	audino_monster:ReplaceSkill("helping_hand", 3, false)
		
	GAME:AddPlayerTeam(audino_monster)
	audino_monster:FullRestore()
	local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("GuildmateInteract")
    audino_monster.ActionEvents:Add(talk_evt)
	audino_monster:RefreshTraits()
	
	local snubbull_id = RogueEssence.Dungeon.MonsterID("snubbull", 0, "normal", Gender.Female)
	local snubbull_monster = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, snubbull_id, SV.GuildSidequests.SnubbullLevel, "run_away", 0)
	snubbull_monster.Discriminator = _DATA.Save.Rand:Next()--tbh idk what this is lol
	snubbull_monster.Nickname = CharacterEssentials.GetCharacterName('Snubbull', true)
	snubbull_monster.MetAt = "Adventurer's Guild"
	snubbull_monster.IsPartner = true
	snubbull_monster.IsFounder = true
	
	--snubbull's stats are kinda dookie in comparison to audino, so boost her up a bit.
	snubbull_monster.MaxHPBonus = 3
	snubbull_monster.AtkBonus = 2
	snubbull_monster.SpeedBonus = 6
	
	snubbull_monster:ReplaceSkill("bite", 0, true)
	snubbull_monster:ReplaceSkill("lick", 1, true)
	snubbull_monster:ReplaceSkill("smelling_salts", 2, true)
	snubbull_monster:ReplaceSkill("charm", 3, false)
		
	GAME:AddPlayerTeam(snubbull_monster)
	snubbull_monster:FullRestore()
	local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("GuildmateInteract")
    snubbull_monster.ActionEvents:Add(talk_evt)
	snubbull_monster:RefreshTraits()
	
	GROUND:CharEndAnim(partner)	
	GROUND:CharEndAnim(hero)	
	GROUND:CharSetEmote(partner, "", 0)
	GAME:MoveCamera(0, 0, 1, true)
	

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
		
	vast_steppe_entrance_ch_5.SetupGround()
	
	--set rin and coco to spawn from the spawners, then spawn them
	GROUND:SpawnerSetSpawn("TEAMMATE_2", GAME:GetPlayerPartyMember(2))
	audino = GROUND:SpawnerDoSpawn("TEAMMATE_2")
		
	GROUND:SpawnerSetSpawn("TEAMMATE_3", GAME:GetPlayerPartyMember(3))
	snubbull = GROUND:SpawnerDoSpawn("TEAMMATE_3")
	  
	GAME:WaitFrames(20)
	GAME:FadeIn(60)

	SV.Chapter5.FinishedVastSteppeIntro = true
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)
	GAME:CutsceneMode(false)
	
end 

function vast_steppe_entrance_ch_5.DiedCutscene()

end

function vast_steppe_entrance_ch_5.EscapedCutscene()

end




function vast_steppe_entrance_ch_5.Tropius_Action(chara, activator)

end 

function vast_steppe_entrance_ch_5.Noctowl_Action(chara, activator)

end 

function vast_steppe_entrance_ch_5.Breloom_Action(chara, activator)

end 

function vast_steppe_entrance_ch_5.Girafarig_Action(chara, activator)

end 

function vast_steppe_entrance_ch_5.Growlithe_Action(chara, activator)

end 

function vast_steppe_entrance_ch_5.Zigzagoon_Action(chara, activator)

end 

function vast_steppe_entrance_ch_5.Audino_Action(chara, activator)
	
end 

function vast_steppe_entrance_ch_5.Snubbull_Action(chara, activator)

end 

function vast_steppe_entrance_ch_5.Mareep_Action(chara, activator)

end 

function vast_steppe_entrance_ch_5.Cranidos_Action(chara, activator)

end 
--[[
function vast_steppe_entrance_ch_5.Oddish_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Hi weird lady![pause=0] I hope you're doing OK in here![pause=0]\nI brought you some flowers to cheer you up!", "Happy", false)
	UI:WaitShowDialogue("You should come outside and see my mom's garden sometime!")
	UI:WaitShowDialogue("There's all kinds of pretty flowers I think would make you feel happy there!")
	GeneralFunctions.EndConversation(chara)
end
]]--