require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

crooked_den_ch_3 = {}


function crooked_den_ch_3.FirstPreBossScene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local sandile = CharacterEssentials.MakeCharactersFromList({{"Sandile", 172, 104, Direction.Up}})

	
	
	GAME:WaitFrames(60)
	AI:DisableCharacterAI(partner)
	SOUND:StopBGM()
	
	GROUND:TeleportTo(hero, 188, 272, Direction.Up)
	GROUND:TeleportTo(partner, 156, 272, Direction.Up)
	GAME:MoveCamera(180, 120, 1, false)
		
	GAME:CutsceneMode(true)
	UI:ResetSpeaker()
	UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
	GAME:WaitFrames(60)
	UI:WaitHideTitle(20)
	GAME:FadeIn(40)
	
	SOUND:PlayBGM('In The Depths of the Pit.ogg', false)
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(sandile)
	UI:SetSpeakerEmotion("Pain")
	GeneralFunctions.EmoteAndPause(sandile, "Sweating", true)
	UI:WaitShowDialogue("Not good,[pause=10] not good,[pause=10] not good...")
	GROUND:MoveInDirection(sandile, Direction.Left, 24, false, 1)
	GROUND:CharAnimateTurnTo(sandile, Direction.Right, 4)	
	GROUND:MoveInDirection(sandile, Direction.Right, 48, false, 1)
	GROUND:CharAnimateTurnTo(sandile, Direction.Left, 4)	
	GROUND:MoveInDirection(sandile, Direction.Left, 24, false, 1)
	GROUND:CharAnimateTurnTo(sandile, Direction.Up, 4)
	
	GeneralFunctions.EmoteAndPause(sandile, "Sweating", true)
	UI:WaitShowDialogue("Oh,[pause=10] what am I going to do?[pause=0] I should never have stolen all that stuff...")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner:GetDisplayName(), true, -1, -1, -1, RogueEssence.Data.Gender.Unknown)
	SOUND:FadeOutBGM(120)
	local coro1 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue("Hey you![pause=30] H-hold it right there!", 40) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) GeneralFunctions.EmoteAndPause(sandile, "Exclaim", true) end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(sandile, Direction.Down, 4) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.CenterCamera({hero, partner}, GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 2) end)
	TASK:JoinCoroutines({coro1, coro2})

	GAME:WaitFrames(40)
	SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", false)
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 156, 136, false, 1) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GROUND:MoveToPosition(hero, 188, 136, false, 1) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:MoveCamera(180, 120, 160, false) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("A-are you " .. sandile:GetDisplayName() .. "?")
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(sandile, 5, 1)
	UI:SetSpeaker(sandile)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Um...[pause=0] Y-yes?[pause=0] W-who are you?")
	
	--partner has been rehearsing this in their head the whole trip
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("We're T-Team " .. GAME:GetTeamName() .. "!")
	UI:WaitShowDialogue("We're from the A-Adventurer's Guild and we're here to p-place you under arrest!")
	
	GeneralFunctions.EmoteAndPause(sandile, "Shock", true)
	UI:SetSpeaker(sandile)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("A-a-a-adventurers!?")
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(sandile, 5, 1)
	GeneralFunctions.DoubleHop(sandile)
	
	--todo: make sandile tremble
	SOUND:FadeOutBGM(40)
	UI:SetSpeakerEmotion("Crying")
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowDialogue("Waaaaaaaaah!!![pause=0] P-p-please don't h-hurt me!")
											UI:WaitShowDialogue("I'm s-s-sorry for stealing all that stuff![pause=0] I'll go p-p-peacefully![pause=0] I s-swear!")end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) GeneralFunctions.EmoteAndPause(partner, "Exclaim", true) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(30) GeneralFunctions.EmoteAndPause(hero, "Exclaim", false) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(partner, "Sweatdrop", true) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(hero, "Sweatdrop", false) end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(10)
	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Stunned")
	GROUND:CharSetEmote(partner, 5, 1)
	UI:WaitShowDialogue("H-hey,[pause=10] you don't have to be scared![pause=0] We won't hurt you!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(sandile)
	UI:SetSpeakerEmotion("Special2")
	UI:WaitShowDialogue("Sniff...[pause=0] R-r-really?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	SOUND:PlayBGM('In The Depths of the Pit.ogg', true)
	UI:WaitShowDialogue("Yup.[pause=0] But you're going to have to come with us.")
	UI:WaitShowDialogue("We've got this wanted poster here with your name on it,[pause=10] so we need to bring you in.")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(sandile)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("O-oh.[pause=0] Well...[pause=0] OK.[pause=0] I guess I can't run away forever...")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Hmm...[pause=0] You don't seem all that bad to me...[pause=0] How'd you end up with a bounty,[pause=10] anyway?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(sandile)
	UI:SetSpeakerEmotion("Sad")
	GROUND:CharSetEmote(sandile, 5, 1)
	UI:WaitShowDialogue("U-um,[pause=10] well,[pause=10] I stole some expensive scarves from a shopkeeper...")
	UI:WaitShowDialogue("I always wanted to have fashionable things to wear,[pause=10] and the ones he had were just so beautiful...")
	UI:WaitShowDialogue("But I didn't have the money for them,[pause=10] and so I couldn't help but steal them...")
	UI:WaitShowDialogue("I felt so bad for taking them afterwards...[pause=0] I knew what I did was wrong.")
	UI:WaitShowDialogue("But I didn't want to face up to the consequences...")
	UI:WaitShowDialogue("So I hid here hoping the bandits would deter others from looking for me...")
	UI:WaitShowDialogue("But it looks like that didn't work,[pause=10] huh?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Why couldn't you just give them back?[pause=0] Maybe the shopkeeper would have forgiven you?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(sandile)
	UI:SetSpeakerEmotion("Stunned")
	UI:WaitShowDialogue(".........")
	UI:WaitShowDialogue("Um...[pause=0] Because,[pause=10] deep down,[pause=10] I still wanted to keep them all.")
	UI:WaitShowDialogue("They're just so beautiful,[pause=10] and they make me feel beautiful...")
	UI:WaitShowDialogue("So I haven't tried to give them back yet.")
	
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("But I think it's time that I face the music...")
	UI:WaitShowDialogue("I'll give back what I stole and take my punishment.[pause=0] It's only fair...")
	
	--partner is sympathetic towards thwait and doesn't really consider him bad/an outlaw at this point, but obviously he still needs to own up to what he did.
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("I feel a little bad about arresting you now.[pause=0] Still,[pause=10] it's our job...")
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Well,[pause=10] I'm glad we were able to resolve this without a fight.[pause=0] I hope the law goes easy on you.")
	
	GAME:WaitFrames(10)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:WaitShowTimedDialogue("C'mon " .. hero:GetDisplayName() .. ".[pause=0] Let's-", 40)
	
	GAME:WaitFrames(20)
	SOUND:FadeOutBGM(120)
	local luxio, glameow, cacnea = CharacterEssentials.MakeCharactersFromList({
									{"Luxio", 172, 264, Direction.Up},
									{"Glameow", 156, 280, Direction.Up},
									{"Cacnea", 188, 280, Direction.Up}})
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, -1, -1, -1, RogueEssence.Data.Gender.Unknown)
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue("Well well well![pause=30] What do we have here?", 40) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) GeneralFunctions.EmoteAndPause(partner, "Exclaim", true) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(26) GeneralFunctions.EmoteAndPause(sandile, "Exclaim", false) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(32) GeneralFunctions.EmoteAndPause(hero, "Notice", false) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	GAME:WaitFrames(10)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.CenterCamera({luxio}, GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 2) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Down, 4) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(sandile, Direction.Down, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	SOUND:PlayBGM('Team Skull.ogg', false)
	GeneralFunctions.EmoteAndPause(partner, 'Shock', true)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Team [color=#FFA5FF]Style[color]!?")
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(luxio, 172, 176, false, 1) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(8) GROUND:MoveToPosition(glameow, 156, 192, false, 1) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(12) GROUND:MoveToPosition(cacnea, 188, 192, false, 1) end)
	coro4 = TASK:BranchCoroutine(function() GAME:MoveCamera(180, 152, 120, false) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	GAME:WaitFrames(20)
	UI:SetSpeaker(luxio)
	UI:WaitShowDialogue("Move these losers out of the way!")
	
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(cacnea)
	UI:WaitShowDialogue("Right away,[pause=10] boss!")
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(glameow, 156, 156, false, 1) 
											GROUND:MoveToPosition(glameow, 160, 152, false, 1) 
											GROUND:CharAnimateTurnTo(glameow, Direction.UpLeft, 4)
											GROUND:CharAnimateTurnTo(partner, Direction.Right, 4) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(cacnea, 188, 156, false, 1) 
											GROUND:MoveToPosition(cacnea, 184, 152, false, 1) 
											GROUND:CharAnimateTurnTo(cacnea, Direction.UpRight, 4)
											GROUND:CharAnimateTurnTo(hero, Direction.Left, 4) end)
	TASK:JoinCoroutines({coro1, coro2})

	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Pain")
	coro1 = TASK:BranchCoroutine(function() GROUND:CharWaitAnim(glameow, "Shoot") end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharWaitAnim(cacnea, "Shoot") end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(12) 
											SOUND:PlayBattleSE('EVT_Tackle')
											GROUND:AnimateInDirection(partner, "Pain", Direction.Right, Direction.Left, 12, 1, 2) 
											GROUND:CharPoseAnim(partner, "Pain") end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(12) 
											GROUND:AnimateInDirection(hero, "Pain", Direction.Left, Direction.Right, 12, 1, 2) 
											GROUND:CharPoseAnim(hero, "Pain") end)	
	local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(12) UI:WaitShowTimedDialogue("Urf!", 40) end)
	local coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) GeneralFunctions.EmoteAndPause(sandile, "Shock", false) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6})
	
	GAME:WaitFrames(10)
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(luxio, 172, 104, false, 1) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(40)
											GROUND:AnimateToPosition(sandile, "Walk", Direction.Down, 172, 72, 1, 1)
											GROUND:CharSetEmote(sandile, 8, 1) 
											GROUND:CharAnimateTurnTo(sandile, Direction.Left, 2)
											GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(sandile, Direction.Down, 2)
											GROUND:CharAnimateTurnTo(sandile, Direction.Right, 2)
											GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(sandile, Direction.Down, 2) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(glameow, Direction.UpLeft, 4) 
											GeneralFunctions.EightWayMove(glameow, 144, 88, false, 1)
											GROUND:CharAnimateTurnTo(glameow, Direction.UpRight, 4) end)
	coro4 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(cacnea, Direction.UpRight, 4) 
											GeneralFunctions.EightWayMove(cacnea, 200, 88, false, 1)
											GROUND:CharAnimateTurnTo(cacnea, Direction.UpLeft, 4) end)
	coro5 = TASK:BranchCoroutine(function() GROUND:MoveCamera(180, 120, 32, false) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	
	GAME:WaitFrames(10)
	UI:SetSpeaker(luxio)
	UI:WaitShowDialogue("So you're the outlaw this sad sack of an adventuring team was after...")
	UI:WaitShowDialogue("Well,[pause=10] you're ours now!")
	
	GeneralFunctions.EmoteAndPause(sandile, "Sweating", true)
	UI:SetSpeaker(sandile)
	UI:SetSpeakerEmotion("Pain")
	UI:WaitShowDialogue("Eeep!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Pain")
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharWaitAnim(hero, "Wake")
											GROUND:CharSetAnim(hero, "None", true)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharWaitAnim(partner, "Wake")
											GROUND:CharSetAnim(partner, "None", true)
	coro3 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue("Urgh...", 40) end)

	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(partner, "Exclaim", true) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(hero, "Exclaim", false) end)
	--coro3 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) end)
	--coro4 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end)
	
	TASK:JoinCoroutines({coro1, coro2})
	
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 156, 136, false, 2) 
											GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 188, 136, false, 2) 
											GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end)	
	TASK:JoinCoroutines({coro1, coro2})

	GeneralFunctions.Hop(partner)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("Team [color=#FFA5FF]Style[color]![pause=0] What are you doing here!?")

	GAME:WaitFrames(10)
	UI:SetSpeaker(luxio)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(luxio, Direction.Down, 4)
											UI:WaitShowDialogue("Isn't it obvious?[pause=0] We're here to humiliate you!") end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(glameow, Direction.Down, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) 
											GROUND:CharAnimateTurnTo(cacnea, Direction.Down, 4) end)
	
	TASK:JoinCoroutines({coro1, coro2})
	
	GROUND:CharSetEmote(hero, 3, 1)
	GeneralFunctions.Recoil(partner)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Wh-what!?[pause=0] What do you mean!?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(luxio)
	UI:WaitShowDialogue("When we spoke with you chumps earlier you mentioned you were headed off on your first outlaw job.")
	UI:WaitShowDialogue("That's when it occurred to me...")
	UI:WaitShowDialogue("How would it look if another team brought home that outlaw instead of you?")
	
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(partner, "Shock", true) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(hero, "Exclaim", false) end)
	TASK:JoinCoroutines({coro1, coro2})
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Y-you don't m-mean...")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(glameow)
	UI:WaitShowDialogue("That's right darlings.[pause=0] Once " .. luxio:GetDisplayName() .. " came up with the idea,[pause=10] he told us the plan.")
	UI:WaitShowDialogue("We started to act like we had suddenly developed respect for you,[pause=10] then off we went like we had something to do.")
	UI:WaitShowDialogue("But really,[pause=10] we just started trailing you.[pause=0] You had no idea you were being followed,[pause=10] did you?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(luxio)
	UI:WaitShowDialogue("I can't believe you losers fell for it.[pause=0] Like we could ever have any respect for wimps like you.")
	
	--if player died before making it to the end at least once 
	if SV.Chapter3.FailedCavern then 
		UI:WaitShowDialogue("Especially with how many times you failed to even make it to the end of this place!")
	end
	
	UI:WaitShowDialogue("But now,[pause=10] we'll be claiming the bounty on this outlaw's head.[pause=0] Not you.")
	
	GAME:WaitFrames(20)
	GeneralFunctions.Complain(partner, true)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("I can't believe you jerks![pause=0] Don't you have anything better to do?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(luxio)
	UI:SetSpeakerEmotion("Angry")


end
	


return crooked_den_ch_3




