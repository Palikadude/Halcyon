require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'
require 'ground.guild_third_floor_lobby.guild_third_floor_lobby_helper'


guild_third_floor_lobby_ch_5 = {}

function guild_third_floor_lobby_ch_5.SetupGround()
	
	if SV.Chapter5.FinishedExpeditionAddress then
		local noctowl = CharacterEssentials.MakeCharactersFromList({
			{'Noctowl', 'Noctowl'}
		})
		
		GAME:FadeIn(20)
	else
		
	end	
end



----------------
--NPC Scripts
----------------
function guild_third_floor_lobby_ch_5.Noctowl_Action(chara, activator)

end
	

------------------------
--Cutscene Scripts
------------------------
function guild_third_floor_lobby_ch_5.ExpeditionAddress()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')

	local tropius, noctowl, audino, snubbull, growlithe, zigzagoon, girafarig, 
		  breloom, mareep, cranidos = guild_third_floor_lobby_helper.SetupMorningAddress()

	local tail = CharacterEssentials.MakeCharactersFromList({{'Tail'}})
	
	GROUND:TeleportTo(breloom, 632, 280, Direction.Left)
	GROUND:TeleportTo(girafarig, 632, 312, Direction.Left)

	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Normal")
	GROUND:CharSetEmote(tropius, "happy", 0)
	UI:WaitShowDialogue("One for all...")
	GAME:WaitFrames(20)
	

	UI:SetSpeaker('[color=#00FFFF]Everyone[color]', true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	GROUND:CharSetEmote(tropius, "", 0)
	GROUND:CharSetEmote(growlithe, "happy", 0)
	GROUND:CharSetEmote(zigzagoon, "happy", 0)
	GROUND:CharSetEmote(mareep, "happy", 0)
	GROUND:CharSetEmote(audino, "happy", 0)
	GROUND:CharSetEmote(partner, "happy", 0)
	UI:WaitShowDialogue("AND ALL FOR ONE!")
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(growlithe, "", 0)
	GROUND:CharSetEmote(zigzagoon, "", 0)
	GROUND:CharSetEmote(mareep, "", 0)
	GROUND:CharSetEmote(audino, "", 0)
	GROUND:CharSetEmote(partner, "", 0)
	
	--kino interrupts
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	SOUND:FadeOutBGM(60)	
	local coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(22)
												  GeneralFunctions.EmoteAndPause(growlithe, "Exclaim", true) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(28)
												  GROUND:CharSetEmote(zigzagoon, "exclaim", 1) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(32)
												  GROUND:CharSetEmote(cranidos, "notice", 1) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
												  GROUND:CharSetEmote(mareep, "exclaim", 1) end)
	local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(26)
												  GROUND:CharSetEmote(audino, "exclaim", 1) end)
	local coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(24)
												   GROUND:CharSetEmote(snubbull, "notice", 1) end)	
	local coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(30)
												  GROUND:CharSetEmote(hero, "notice", 1) end)									 
	local coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
												  GROUND:CharSetEmote(partner, "exclaim", 1) end)
	local coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
												  GROUND:CharSetEmote(tropius, "exclaim", 1) end)
	local coro10 = TASK:BranchCoroutine(function() GAME:WaitFrames(30)
												   GROUND:CharSetEmote(noctowl, "exclaim", 1) end)
	local coro11 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue("Alright Pokémon,[pause=10] let's get to the day's adventures!\n(I've always wanted to say that part,[pause=10] heheh!)", 60) end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9, coro10, coro11})
	GAME:WaitFrames(10)
	
	--everyone looks around
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.LookAround(tropius, 3, 4, true, true, false, Direction.Down) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GeneralFunctions.LookAround(noctowl, 3, 4, true, false, false, Direction.Down) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(2) GeneralFunctions.LookAround(growlithe, 3, 4, true, false, false, Direction.UpLeft) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GeneralFunctions.LookAround(zigzagoon, 3, 4, true, false, false, Direction.UpLeft) end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(8) GeneralFunctions.LookAround(cranidos, 3, 4, true, false, false, Direction.Up) end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GeneralFunctions.LookAround(mareep, 3, 4, true, false, false, Direction.Up) end)
	coro7 = TASK:BranchCoroutine(function() GeneralFunctions.LookAround(audino, 3, 4, true, false, false, Direction.Up) end)
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GeneralFunctions.LookAround(snubbull, 3, 4, true, false, false, Direction.Up) end)
	coro9 = TASK:BranchCoroutine(function() GeneralFunctions.LookAround(partner, 3, 4, true, false, false, Direction.UpRight) end)
	coro10 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GeneralFunctions.LookAround(hero, 3, 4, true, false, false, Direction.UpRight) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9, coro10})

	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(audino, "Question", true)
	UI:SetSpeaker(audino)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("H-hey![pause=0] That w-wasn't the Guildmaster's voice![pause=0] W-who said that?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	UI:WaitShowDialogue("Aww,[pause=10] c'mon![pause=0] We haven't been gone that long![pause=0] Surely you haven't forgotten my sweet voice already!")
	UI:WaitShowDialogue("Look towards the bedrooms,[pause=10] you goofs!")
	
	GAME:WaitFrames(10)
	
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(2)
											GROUND:CharAnimateTurnTo(growlithe, Direction.Right, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.Right, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharAnimateTurnTo(cranidos, Direction.Right, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:CharAnimateTurnTo(mareep, Direction.Right, 4) end)
	coro5 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(audino, Direction.Right, 4) end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(snubbull, Direction.Right, 4) end)	
	coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(hero, Direction.Right, 4) end)									 
	coro8 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Right, 4) end)
	coro9 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(tropius, Direction.Right, 4) end)
	coro10 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
						                     GROUND:CharAnimateTurnTo(noctowl, Direction.Right, 4) end)
	coro11 = TASK:BranchCoroutine(function() GAME:MoveCamera(520, 268, 72, false) end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9, coro10, coro11})
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(zigzagoon)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("Oh![pause=0] It's " .. breloom:GetDisplayName() .. " and " .. girafarig:GetDisplayName() .. "![pause=0] They're back from their trip!")
	GAME:WaitFrames(20)
	
	SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true)
	
	--everyone crowds around as they walk over
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(breloom, 424, 252, false, 1)
											GROUND:CharAnimateTurnTo(breloom, Direction.Down, 4) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(girafarig, Direction.Up, 4)
											GROUND:MoveToPosition(girafarig, 632, 280, false, 1)
											GeneralFunctions.EightWayMove(girafarig, 456, 252, false, 1)
											GROUND:CharAnimateTurnTo(girafarig, Direction.Down, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(2)
											GeneralFunctions.FaceMovingCharacter(growlithe, breloom, 4, Direction.UpLeft)--done on 142
											GAME:WaitFrames(30)
											GROUND:MoveInDirection(growlithe, Direction.Left, 8, false, 1)
											GROUND:MoveInDirection(growlithe, Direction.UpLeft, 12, false, 1)
											GROUND:CharSetAnim(growlithe, "Idle", true) 
											end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GeneralFunctions.FaceMovingCharacter(zigzagoon, breloom, 4, Direction.UpLeft) --done on 155
											GAME:WaitFrames(20)
											GROUND:MoveInDirection(zigzagoon, Direction.UpLeft, 20, false, 1)
											GROUND:CharSetAnim(zigzagoon, "Idle", true) 
											end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GeneralFunctions.FaceMovingCharacter(cranidos, breloom, 4, Direction.Up) --done on 138
											GAME:WaitFrames(40)
											GROUND:MoveInDirection(cranidos, Direction.UpLeft, 10, false, 1)
											end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GeneralFunctions.FaceMovingCharacter(mareep, breloom, 4, Direction.Up)--done on 151
											GAME:WaitFrames(26)
											GROUND:MoveInDirection(mareep, Direction.UpLeft, 8, false, 1)
											GROUND:CharSetAnim(mareep, "Idle", true)
											end)
	coro7 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(audino, breloom, 4, Direction.Up)--done on 170
											GAME:WaitFrames(20)
											GROUND:MoveInDirection(audino, Direction.Up, 8, false, 1)
											GROUND:CharSetAnim(audino, "Idle", true) 
											end)
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GeneralFunctions.FaceMovingCharacter(snubbull, breloom, 4, Direction.Up)--done on 181
											GAME:WaitFrames(10)
											GROUND:MoveInDirection(snubbull, Direction.Up, 6, false, 1)
											end)	
	coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.FaceMovingCharacter(hero, breloom, 4, Direction.UpRight) 
											GAME:WaitFrames(60)
											GROUND:MoveInDirection(hero, Direction.Right, 22, false, 1)
											GROUND:MoveInDirection(hero, Direction.UpRight, 18, false, 1)
											end)									 
	coro10 = TASK:BranchCoroutine(function() GAME:WaitFrames(100)
											 GROUND:EntTurn(partner, Direction.UpRight)
											 GAME:WaitFrames(80)
											 GROUND:MoveInDirection(partner, Direction.Right, 30, false, 1)
											 GROUND:MoveInDirection(partner, Direction.UpRight, 10, false, 1)
											 GROUND:CharSetAnim(partner, "Idle", true)
											 end)
	coro11 = TASK:BranchCoroutine(function() GAME:WaitFrames(140)
											 GROUND:CharAnimateTurnTo(tropius, Direction.UpLeft, 4)
											 GeneralFunctions.EightWayMove(tropius, 392, 252, false, 1)
											 GROUND:CharAnimateTurnTo(tropius, Direction.Right, 4)
											 end)	
	local coro12 = TASK:BranchCoroutine(function() GAME:WaitFrames(136)
												   GROUND:CharAnimateTurnTo(noctowl, Direction.Up, 4)
												   GeneralFunctions.EightWayMove(noctowl, 400, 228, false, 1)
												   GROUND:CharAnimateTurnTo(noctowl, Direction.DownRight, 4)
												   end)
	local coro13 = TASK:BranchCoroutine(function() GAME:WaitFrames(90)
												   GeneralFunctions.CenterCamera({snubbull, tropius}, GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 1) end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9, coro10, coro11, coro12, coro13})

	GAME:WaitFrames(10)
	GeneralFunctions.DoubleHop(growlithe, 'None', 6, 6, true, true)
	GROUND:CharSetAnim(growlithe, "Idle", true)
	GROUND:CharSetEmote(growlithe, "happy", 0)
	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue(breloom:GetDisplayName() .. " and " .. girafarig:GetDisplayName() .. "![pause=0] What kind of places did you see on your adventure,[pause=10] ruff!?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Inspired")
	GROUND:CharSetEmote(partner, "happy", 0)
	UI:WaitShowDialogue("Did you find anything cool on your trip?[pause=0] Tell me tell me tell me!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(mareep)
	UI:SetSpeakerEmotion("Inspired")
	GROUND:CharSetEmote(mareep, "happy", 0)
	UI:WaitShowDialogue("You ha-a-a-ave to tell us about your adventure![pause=0] I can't wait any longer to hear about it!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(breloom)
	UI:SetSpeakerEmotion("Surprised")
	GROUND:CharSetEmote(breloom, "sweating", 1)
	UI:WaitShowDialogue("W-woah![pause=0] One at a time!")

	GAME:WaitFrames(20)
	GROUND:EntTurn(tropius, Direction.DownRight)
	UI:SetSpeaker(tropius)
	UI:WaitShowDialogue("Now,[pause=10] everyone,[pause=10] let's give them some space.[pause=0] They'll have plenty of time to tell you all about their adventure!")
	
	GAME:WaitFrames(20)
	GROUND:CharEndAnim(mareep)
	GROUND:CharEndAnim(audino)
	GROUND:CharEndAnim(growlithe)
	GROUND:CharEndAnim(zigzagoon)
	GROUND:CharSetEmote(partner, "", 0)
	GROUND:CharSetEmote(mareep, "", 0)
	GROUND:CharSetEmote(growlithe, "", 0)
	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharEndAnim(partner) 
											GROUND:CharSetEmote(partner, "", 0)
											GROUND:AnimateInDirection(partner, "Walk", Direction.UpRight, Direction.DownLeft, 8, 1, 1)
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:AnimateInDirection(hero, "Walk", Direction.UpRight, Direction.DownLeft, 8, 1, 1)
											end)	
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(2)
											GROUND:CharEndAnim(growlithe) 
											GROUND:CharSetEmote(growlithe, "", 0)
											GROUND:AnimateInDirection(growlithe, "Walk", Direction.UpLeft, Direction.DownRight, 8, 1, 1)
											end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharEndAnim(zigzagoon) 
											GROUND:AnimateInDirection(zigzagoon, "Walk", Direction.UpLeft, Direction.DownRight, 8, 1, 1)
											end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:AnimateInDirection(cranidos, "Walk", Direction.UpLeft, Direction.DownRight, 8, 1, 1)
											end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:CharEndAnim(mareep) 
											GROUND:CharSetEmote(mareep, "", 0)
											GROUND:AnimateInDirection(mareep, "Walk", Direction.UpLeft, Direction.DownRight, 8, 1, 1)
											end)
	coro7 = TASK:BranchCoroutine(function() GROUND:CharEndAnim(audino) 
											GROUND:AnimateInDirection(audino, "Walk", Direction.Up, Direction.Down, 8, 1, 1)
											end)
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:AnimateInDirection(snubbull, "Walk", Direction.Up, Direction.Down, 8, 1, 1)
											end)	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8})
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(breloom)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Phew![pause=0] That's better![pause=0] It was getting a bit claustrophobic there!")
	GAME:WaitFrames(20)
	
	
	
	GROUND:EntTurn(tropius, Direction.Right)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(breloom:GetDisplayName() .. "![pause=0] " .. girafarig:GetDisplayName() .. "![pause=0] It's great to have you both home!")
	UI:WaitShowDialogue("How did your exploration go?")
	GAME:WaitFrames(10)
	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(breloom, Direction.Left, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GROUND:CharAnimateTurnTo(girafarig, Direction.Left, 4) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(audino, Direction.UpLeft, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GROUND:CharAnimateTurnTo(snubbull, Direction.UpLeft, 4) end)
	coro5 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end)
	
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6})
	
	UI:SetSpeaker(breloom)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("It went great![pause=0] " .. girafarig:GetDisplayName() .. " and I saw all sorts of different places during our trip!")
	UI:WaitShowDialogue("Open plains,[pause=10] boiling hot caves,[pause=10] and windy cliffsides![pause=0] You name it,[pause=10] we saw it!")
	UI:WaitShowDialogue("The ruins themselves were interesting too![pause=0] I wish we could have spent more time investigating them.")
	GAME:WaitFrames(10)
	
	GeneralFunctions.DoubleHop(girafarig)
	UI:SetSpeaker(girafarig)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Yeah![pause=0] The three of us had a lot of fun on our trip!")
	UI:WaitShowDialogue("We also planned out a route to head on back there like you asked,[pause=10] Guildmaster!")
	UI:WaitShowDialogue(CharacterEssentials.GetCharacterName("Tail") .. "'s really good at figuring out how to backtrack!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(tail)
	UI:SetSpeakerEmotion("Special0")
	UI:WaitShowDialogue(".........")
	GAME:WaitFrames(20)
	
	--tropius doesn't miss a beat when it comes to Crum, and just continues on
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("Perfect![pause=0] I knew you'd be able to do it!")
	
	GAME:WaitFrames(10)
	GROUND:CharAnimateTurnTo(tropius, Direction.DownRight, 4)
	UI:SetSpeakerEmotion("Normal")
	GROUND:CharSetEmote(tropius, "happy", 0)
	UI:WaitShowDialogue("Alright Pokémon![pause=0] Change of plans![pause=0] We'll be leaving on our expedition to explore the northern ruins today!")
	GAME:WaitFrames(20)

	SOUND:FadeOutBGM(60)
	GROUND:CharSetEmote(tropius, '', 0)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.Recoil(breloom) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:CharSetEmote(girafarig, "shock", 1) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(2)
											GROUND:CharSetEmote(growlithe, "exclaim", 1) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharSetEmote(zigzagoon, "exclaim", 1) end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharSetEmote(cranidos, "exclaim", 1) end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:CharSetEmote(mareep, "exclaim", 1) end)
	coro7 = TASK:BranchCoroutine(function() GROUND:CharSetEmote(audino, "exclaim", 1) end)
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharSetEmote(snubbull, "exclaim", 1) end)	
	coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharSetEmote(hero, "exclaim", 1) end)									 
	coro10 = TASK:BranchCoroutine(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9, coro10})
	
	--What? like now?!
	GAME:WaitFrames(20)
	UI:SetSpeaker(breloom)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("W-what!?[pause=0] T-today!?[pause=0] You want us to leave today!?[script=0]", {function() return GeneralFunctions.DoubleHop(breloom) end})
	GAME:WaitFrames(16)
	
	GROUND:CharTurnToCharAnimated(tropius, breloom, 4)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Is that a problem?[pause=0] I know you two must be exhausted after your journey,[pause=10] but I'd like us to leave as soon as we can!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(breloom)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Well,[pause=10] you're right that it was an exhausting trip...[pause=0] All that traveling took a lot out of us!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(girafarig)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("We only got back late last night after everyone had gone to sleep![pause=10] We've barely had a chance to rest!")
	GAME:WaitFrames(30)
	
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("...But we're no pushovers![pause=0] I know " .. CharacterEssentials.GetCharacterName("Tail") .. " and I still have energy left in us!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(breloom)
	GeneralFunctions.Hop(breloom)
	UI:WaitShowDialogue("That goes for me too![pause=0] I've still got plenty more in me!")
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Guildmaster,[pause=10] we're ready to go whenever you need us to![pause=0] Just say the word!")
	GAME:WaitFrames(20)
	
	SOUND:PlayBGM("Wigglytuff's Guild.ogg", true)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Thank you![pause=0] I knew I could rely on the both of you!")
	GAME:WaitFrames(20)
	
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("But we won't be leaving right this moment.[pause=0] " .. noctowl:GetDisplayName() .. " and I will need to speak with you to figure out details.")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(breloom)
	UI:WaitShowDialogue("Of course![pause=0] We'll tell you everything we learned on our trip!")
	
	GAME:WaitFrames(16)
	UI:SetSpeaker(tropius)
	GROUND:CharAnimateTurnTo(tropius, Direction.DownRight, 4)
	UI:WaitShowDialogue("In the meantime,[pause=10] the rest of you should prepare for the long journey ahead.")
	UI:WaitShowDialogue("We won't return from this expedition for quite some time,[pause=10] so stock up on as many supplies as you can.") 
	UI:WaitShowDialogue("Just be aware that this expedition is for guild members only.")
	local audino_species = _DATA:GetMonster('audino'):GetColoredName()
	UI:WaitShowDialogue("That is to say,[pause=10] you won't be able to use the " .. audino_species .. " Assembly to add members to your party.")
	UI:WaitShowDialogue("We want to keep this expedition amongst ourselves,[pause=10] so non-guild members aren't allowed to come!")
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("Anyways,[pause=10] once you're finished making your preparations, report back to me in my office.")
	UI:WaitShowDialogue("Once everyone's ready,[pause=10] we'll go over the road ahead and then embark!")
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Alright Pokémon,[pause=10] let's all get a move on!")
	
	GAME:WaitFrames(20)
	
	--HURRAH!
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
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(growlithe, "", 0)
	GROUND:CharSetEmote(zigzagoon, "", 0)
	GROUND:CharSetEmote(mareep, "", 0)
	GROUND:CharSetEmote(breloom, "", 0)
	GROUND:CharSetEmote(audino, "", 0)	
	GROUND:CharSetEmote(partner, "", 0)
	GROUND:CharEndAnim(growlithe)
	GROUND:CharEndAnim(zigzagoon)
	GROUND:CharEndAnim(breloom)
	GROUND:CharEndAnim(girafarig)
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	GROUND:CharEndAnim(audino)
	GROUND:CharEndAnim(snubbull)
	GROUND:CharEndAnim(cranidos)
	GROUND:CharEndAnim(mareep)
	
	--penticus, phileas, kino and reinier go to penticus's office, everyone else gathers around
	
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(noctowl, 432, 228, false, 1)
											GROUND:MoveToPosition(noctowl, 440, 220, false, 1)
											GROUND:MoveToPosition(noctowl, 440, 216, false, 1) 	
											GAME:GetCurrentGround():RemoveTempChar(noctowl)
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(tropius, Direction.UpRight, 4)
											GeneralFunctions.EightWayMove(tropius, 440, 228, false, 1)
											GROUND:MoveToPosition(tropius, 440, 216, false, 1) 	
											GAME:GetCurrentGround():RemoveTempChar(tropius) 
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(breloom, Direction.UpLeft, 4)
											GAME:WaitFrames(20)
											GROUND:CharAnimateTurnTo(breloom, Direction.Up, 4)
											GeneralFunctions.EightWayMove(breloom, 440, 216, false, 1) 	
											GAME:GetCurrentGround():RemoveTempChar(breloom)
											end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(14)
											GROUND:CharAnimateTurnTo(girafarig, Direction.UpLeft, 4)
											GAME:WaitFrames(40)
											GROUND:CharAnimateTurnTo(girafarig, Direction.Up, 4)
											GeneralFunctions.EightWayMove(girafarig, 440, 216, false, 1) 	
											GAME:GetCurrentGround():RemoveTempChar(girafarig) 
											end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(76)
											GeneralFunctions.EightWayMove(snubbull, 428, 258, false, 1)
											GROUND:CharAnimateTurnTo(snubbull, Direction.Down, 4)
											end)	
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(72)
											GeneralFunctions.EightWayMove(partner, 404, 270, false, 1)
											GROUND:CharAnimateTurnTo(partner, Direction.DownRight, 4)
											end)
	coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(80)
											GeneralFunctions.EightWayMove(hero, 404, 298, false, 1)
											GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4)
											end)
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(84)
											GeneralFunctions.EightWayMove(audino, 428, 310, false, 1)
											GROUND:CharAnimateTurnTo(audino, Direction.Up, 4)
											end)	
	coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(78)
											GeneralFunctions.EightWayMove(cranidos, 452, 310, false, 1)
											GROUND:CharAnimateTurnTo(cranidos, Direction.Up, 4)
											end)
	coro10 = TASK:BranchCoroutine(function() GAME:WaitFrames(74)
											GeneralFunctions.EightWayMove(zigzagoon, 476, 298, false, 1)
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.UpLeft, 4)
											end)
	coro11 = TASK:BranchCoroutine(function() GAME:WaitFrames(80)
											GeneralFunctions.EightWayMove(growlithe, 476, 270, false, 1)
											GROUND:CharAnimateTurnTo(growlithe, Direction.DownLeft, 4)
											end)
	coro12 = TASK:BranchCoroutine(function() GAME:WaitFrames(76)
											GeneralFunctions.EightWayMove(mareep, 452, 258, false, 1)
											GROUND:CharAnimateTurnTo(mareep, Direction.Down, 4)
											end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9, coro10, coro11, coro12})
	
	GAME:WaitFrames(20)
	GeneralFunctions.DoubleHop(growlithe)
	--ZAMN!
	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("It's here![pause=0] The expedition is finally here,[pause=10] ruff!")
	UI:SetSpeakerEmotion("Joyous")
	UI:WaitShowDialogue("I'm so excited I feel like I'm gonna pass out,[pause=10] ruff,[pause=10] ruff!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(snubbull)
	UI:SetSpeakerEmotion("")
	UI:WaitShowDialogue(" ")



end

function guild_third_floor_lobby_ch_5.SecondExpeditionAddress()

	
	GAME:WaitFrames(10)
	GROUND:CharAnimateTurnTo(tropius, Direction.Left, 4)
	UI:WaitShowDialogue(noctowl:GetDisplayName() .. ",[pause=10] would you mind explaining the plan to everyone?")
	
	GAME:WaitFrames(10)
	GROUND:CharAnimateTurnTo(noctowl, Direction.Right, 4)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("Of course,[pause=10] Guildmaster.")
	
	
	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(breloom, Direction.Left, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:CharAnimateTurnTo(girafarig, Direction.Left, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(2) GROUND:CharAnimateTurnTo(growlithe, Direction.UpLeft, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GROUND:CharAnimateTurnTo(zigzagoon, Direction.UpLeft, 4) end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(8) GROUND:CharAnimateTurnTo(cranidos, Direction.UpLeft, 4) end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:CharAnimateTurnTo(mareep, Direction.UpLeft, 4) end)
	coro7 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(audino, Direction.UpLeft, 4) end)
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GROUND:CharAnimateTurnTo(snubbull, Direction.UpLeft, 4) end)
	coro9 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) end)
	coro10 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end)
	coro11 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:CharAnimateTurnTo(noctowl, Direction.Down, 4) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9, coro10, coro11})
	
	UI:WaitShowDialogue("As the Guildmaster explained the other day,[pause=10] ")
end