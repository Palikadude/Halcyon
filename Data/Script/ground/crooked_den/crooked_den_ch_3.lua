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
	
	GAME:WaitFrames(30)
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, sandile.CurrentForm.Species, sandile.CurrentForm.Form, sandile.CurrentForm.Skin, sandile.CurrentForm.Gender)
	UI:SetSpeakerEmotion("Normal")
	UI:SetSpeakerEmotion("Pain")
	GeneralFunctions.EmoteAndPause(sandile, "Sweating", true)
	UI:WaitShowDialogue("Not good,[pause=10] not good,[pause=10] not good...")
	GAME:WaitFrames(20)
	GROUND:MoveInDirection(sandile, Direction.Left, 24, false, 1)
	GROUND:CharAnimateTurnTo(sandile, Direction.Right, 4)	
	GROUND:MoveInDirection(sandile, Direction.Right, 48, false, 1)
	GROUND:CharAnimateTurnTo(sandile, Direction.Left, 4)	
	GROUND:MoveInDirection(sandile, Direction.Left, 24, false, 1)
	GROUND:CharAnimateTurnTo(sandile, Direction.Up, 4)
	
	GeneralFunctions.EmoteAndPause(sandile, "Sweating", true)
	UI:WaitShowDialogue("Oh,[pause=10] what am I going to do?[pause=0] I should never have stolen it...")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner:GetDisplayName(), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
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
	GROUND:CharSetEmote(sandile, "sweating", 1)
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, sandile.CurrentForm.Species, sandile.CurrentForm.Form, sandile.CurrentForm.Skin, sandile.CurrentForm.Gender)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Um...[pause=0] Y-yes?[pause=0] W-who are you?")
	
	--partner has been rehearsing this in their head the whole trip
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("We're T-Team " .. GAME:GetTeamName() .. "![pause=0] We're an adventuring team!")
	UI:WaitShowDialogue("We're from the A-Adventurer's Guild and we're here to p-place you under arrest!")
	
	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(sandile, "Shock", true)
	UI:SetSpeaker(sandile)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("A-a-a-adventurers!?")
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(sandile, "sweating", 1)
	GeneralFunctions.DoubleHop(sandile)
	
	--todo: make sandile tremble
	SOUND:FadeOutBGM(60)
	UI:SetSpeakerEmotion("Crying")
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowDialogue("Waaaaaaaaah!!![pause=0] P-p-please don't h-hurt me!")
											UI:WaitShowDialogue("I'm s-s-sorry for stealing it![pause=0] I'll go p-p-peacefully![pause=0] I s-swear!")end)
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
	GROUND:CharSetEmote(partner, "sweating", 1)
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
	UI:SetSpeakerEmotion("Stunned")
	GROUND:CharSetEmote(sandile, "sweating", 1)
	UI:WaitShowDialogue("U-um,[pause=10] well,[pause=10] ever since I was young I've idolized those who are beautiful and majestic...") 
	UI:WaitShowDialogue("I've always wanted to be just like them...[pause=0] But it's hard to pull that off as a " .. _DATA:GetMonster("sandile"):GetColoredName() .. "...")
	UI:WaitShowDialogue("So I've tried to find things in my travels that could help me achieve my goal of becoming beautiful.")
	
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Well,[pause=10] one day I came across a shopkeeper who was selling the most beautiful scarf I had ever seen.")
	UI:WaitShowDialogue("I thought that maybe with a scarf like that,[pause=10] I could finally look how I've always wanted to...")
	UI:WaitShowDialogue("So I asked him how much they were.")
	
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("The price he told me was staggering...[pause=0] I didn't have that kind of money.")
	UI:WaitShowDialogue("But it was so beautiful,[pause=10] I just had to have it![pause=0]\nI couldn't help but steal it...")
	UI:WaitShowDialogue("I felt so bad for taking it afterwards...[pause=0] I knew what I did was wrong.")
	UI:WaitShowDialogue("But at that point I was afraid of the consequences...")
	UI:WaitShowDialogue("So I hid here hoping the bandits would deter others from looking for me...")
	UI:WaitShowDialogue("But it looks like that didn't work,[pause=10] huh?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Why couldn't you just give it back?[pause=0] Maybe the shopkeeper would have forgiven you?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(sandile)
	UI:SetSpeakerEmotion("Stunned")
	UI:WaitShowDialogue(".........")
	UI:WaitShowDialogue("Um...[pause=0] Because,[pause=10] deep down,[pause=10] I still want to keep the scarf.")
	UI:WaitShowDialogue("It's just so beautiful![pause=0] And it still makes me feel so beautiful too...")
	UI:WaitShowDialogue("So I haven't tried to give it back yet.")
	
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("But I think it's time that I face the music...")
	UI:WaitShowDialogue("I'll give back what I stole and take my punishment.[pause=0] It's only fair...")
	
	--partner is sympathetic towards thwait and doesn't really consider him bad/an outlaw at this point, but obviously he still needs to own up to what he did.
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("What you did was wrong,[pause=10] but I understand why you did it at least.")
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("I feel bad about having to arrest you now.[pause=0] Still,[pause=10] it's our job...")
	
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Well,[pause=10] I'm glad we were able to resolve this without a fight.[pause=0] I hope the law doesn't go hard on you.")
	
	GAME:WaitFrames(10)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:WaitShowTimedDialogue("C'mon,[pause=10] " .. hero:GetDisplayName() .. ".[pause=0] Let's-", 40)
	
	GAME:WaitFrames(20)
	SOUND:FadeOutBGM(120)
	local luxio, glameow, cacnea = CharacterEssentials.MakeCharactersFromList({
									{"Luxio", 172, 264, Direction.Up},
									{"Glameow", 156, 280, Direction.Up},
									{"Cacnea", 188, 280, Direction.Up}})
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
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
											GROUND:CharSetAction(partner, RogueEssence.Ground.PoseGroundAction(partner.Position, partner.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pain"))) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(12) 
											GROUND:AnimateInDirection(hero, "Pain", Direction.Left, Direction.Right, 12, 1, 2) 
											GROUND:CharSetAction(hero, RogueEssence.Ground.PoseGroundAction(hero.Position, hero.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pain"))) end)	
	local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(12) UI:WaitShowTimedDialogue("Urf!", 40) end)
	local coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) GeneralFunctions.EmoteAndPause(sandile, "Shock", false) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6})
	
	GAME:WaitFrames(10)
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(luxio, 172, 104, false, 1) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(40)
											GROUND:AnimateToPosition(sandile, "Walk", Direction.Down, 172, 72, 1, 1, 0)
											GROUND:CharSetEmote(sandile, "shock", 1) 
											GROUND:CharAnimateTurnTo(sandile, Direction.Left, 2)
											GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(sandile, Direction.Down, 2)
											GROUND:CharAnimateTurnTo(sandile, Direction.Right, 2)
											GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(sandile, Direction.Down, 2) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(glameow, Direction.UpLeft, 4) 
											GeneralFunctions.EightWayMove(glameow, 160, 120, false, 1)
											GeneralFunctions.EightWayMove(glameow, 144, 88, false, 1)
											GROUND:CharAnimateTurnTo(glameow, Direction.UpRight, 4) end)
	coro4 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(cacnea, Direction.UpRight, 4) 
											GeneralFunctions.EightWayMove(cacnea, 184, 120, false, 1)
											GeneralFunctions.EightWayMove(cacnea, 200, 88, false, 1)
											GROUND:CharAnimateTurnTo(cacnea, Direction.UpLeft, 4) end)
	coro5 = TASK:BranchCoroutine(function() GAME:MoveCamera(180, 120, 32, false) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	
	GAME:WaitFrames(10)
	UI:SetSpeaker(luxio)
	UI:WaitShowDialogue("So you're the outlaw this sorry excuse of an adventuring team was after...")
	UI:WaitShowDialogue("Well,[pause=10] you're ours now!")
	
	GeneralFunctions.EmoteAndPause(sandile, "Sweating", true)
	UI:SetSpeaker(sandile)
	UI:SetSpeakerEmotion("Pain")
	UI:WaitShowDialogue("Eeep!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Pain")
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.Shake(hero)
											GAME:WaitFrames(30)
											GROUND:CharWaitAnim(hero, "Wake")
											GROUND:CharSetAnim(hero, "None", true) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.Shake(partner)
											GAME:WaitFrames(30)
											GROUND:CharWaitAnim(partner, "Wake")
											GROUND:CharSetAnim(partner, "None", true) end)
	coro3 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue("Urgh...", 80) end)

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
	
	GAME:WaitFrames(10)
	GROUND:CharSetEmote(hero, "exclaim", 1)
	GeneralFunctions.Recoil(partner)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Wh-what!?[pause=0] What do you mean!?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(luxio)
	UI:WaitShowDialogue("When we spoke with you chumps earlier you mentioned you were headed off on your first outlaw job.")
	UI:WaitShowDialogue("That's when it occurred to me...")
	UI:WaitShowDialogue("How would it look if another team brought home that outlaw instead of you?")
	
	GAME:WaitFrames(10)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(partner, "Shock", true) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(hero, "Exclaim", false) end)
	TASK:JoinCoroutines({coro1, coro2})
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Y-you don't m-mean...")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(glameow)
	UI:WaitShowDialogue("That's right,[pause=10] darlings.[pause=0] Once " .. luxio:GetDisplayName() .. " came up with the idea,[pause=10] he told us the plan.")
	UI:WaitShowDialogue("We started to act like we had suddenly developed respect for you,[pause=10] then off we went.")
	UI:WaitShowDialogue("But really,[pause=10] we just started trailing you.[pause=0] You had no idea you were being followed,[pause=10] did you?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(luxio)
	UI:WaitShowDialogue("I can't believe you losers fell for it.[pause=0] Like we could ever have any respect for wimps like you.")
	
	--if player died before making it to the end at least once 
	if SV.Chapter3.FailedCavern then 
		UI:WaitShowDialogue("Especially with how many times you failed to even make it to the end of this place!")
	end
	
	UI:WaitShowDialogue("And now,[pause=10] we'll be claiming the bounty on this outlaw's head.[pause=0] Not you.")
	UI:WaitShowDialogue("I wonder how that's gonna reflect on you when you get back to your precious guild.")
	
	GAME:WaitFrames(10)
	GeneralFunctions.Complain(partner)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("I can't believe you jerks![pause=0] Don't you have anything better to do?")
	
	GAME:WaitFrames(10)
	UI:SetSpeaker(luxio)
	UI:SetSpeakerEmotion("Angry")
	GeneralFunctions.Complain(luxio, true)
	UI:WaitShowDialogue("Don't you have anything better to do than to play pretend!?")
	UI:WaitShowDialogue("Don't you get that you chumps are making us real adventuring teams look bad?")
	UI:WaitShowDialogue("Team [color=#FFA5FF]Style[color] can't become the glamorous team it's destined to be with jokers like you running around!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Angry")
	UI:WaitShowDialogue("Playing pretend!?[pause=0] Are you kidding me!?")
	UI:WaitShowDialogue("We're the real adventuring team![pause=0] You're the fakers who couldn't get into the guild!")
	
	SOUND:PlayBattleSE('EVT_Emote_Shock_2')
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(luxio, "Shock", false) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(glameow, "Exclaim", false) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GeneralFunctions.EmoteAndPause(cacnea, "Shock", false) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	UI:SetSpeaker(luxio)
	UI:SetSpeakerEmotion("Angry")
	UI:WaitShowDialogue("That is IT![pause=0] You wanna do this the hard way,[pause=10] that works for us!")
	
	GAME:WaitFrames(12)
	GROUND:CharTurnToCharAnimated(luxio, glameow, 4) 
	UI:WaitShowDialogue(glameow:GetDisplayName() .. "!")
	
	GAME:WaitFrames(12)
	GROUND:CharTurnToCharAnimated(luxio, cacnea, 4) 
	UI:WaitShowDialogue(cacnea:GetDisplayName() .. "!")
	
	GAME:WaitFrames(8)
	GROUND:CharAnimateTurnTo(luxio, Direction.Down, 4)
	UI:WaitShowDialogue("New plan![pause=0] We're no longer interested in bagging this outlaw!")
	UI:WaitShowDialogue("We're just gonna trounce these posers to stop THEM from doing it!")
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(sandile, "sweating", 1)
	UI:SetSpeaker(sandile)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Um,[pause=10] don't I get a say in this?")
	
	GAME:WaitFrames(12)
	GROUND:CharTurnToCharAnimated(luxio, sandile, 2)
	UI:SetSpeaker(luxio)
	UI:SetSpeakerEmotion("Angry")
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue("No!", 60) end)
	--todo: replace this with regular recoil if sandile ever gets a pain sprite
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GeneralFunctions.Recoil(sandile, "None") end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(8)
	GROUND:CharAnimateTurnTo(luxio, Direction.Down, 4)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("Now then...")
	
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(luxio, Direction.Down, 16, false, 1) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:MoveInDirection(glameow, Direction.Down, 16, false, 1) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:MoveInDirection(cacnea, Direction.Down, 16, false, 1) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:AnimateInDirection(hero, "Walk", Direction.Up, Direction.Down, 16, 1, 1) end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:AnimateInDirection(partner, "Walk", Direction.Up, Direction.Down, 16, 1, 1) end)
	coro6 = TASK:BranchCoroutine(function() GAME:MoveCamera(180, 152, 32, false) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6})
	GAME:WaitFrames(10)
	UI:SetSpeaker(glameow)
	UI:SetSpeakerEmotion("Special1")
	UI:WaitShowDialogue("You're really in for it now,[pause=10] darlings.")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(cacnea)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("The boss says you have to go!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(luxio)
	UI:SetSpeakerEmotion("Angry")
	UI:WaitShowDialogue("Get ready for your beatdown,[pause=10] you no-talent chumps!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("Get ready,[pause=10] " .. hero:GetDisplayName() .. "![pause=0] Here they come!")

	COMMON.BossTransition()
	GAME:CutsceneMode(false)
	SV.Chapter3.EncounteredBoss = true
	--enter fight
	GAME:ContinueDungeon("crooked_cavern", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
	
end

--player used escape orb. Note: Mysterious force prevents orbs, so this shouldn't actually get used.
function crooked_den_ch_3.EscapedBoss()

end 

--player was defeated.
function crooked_den_ch_3.DiedToBoss()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local sandile, luxio, glameow, cacnea = CharacterEssentials.MakeCharactersFromList({{"Sandile", 172, 72, Direction.Down},
																						{"Luxio", 172, 120, Direction.Down},
																						{"Glameow", 144, 104, Direction.Down},
																						{"Cacnea", 200, 104, Direction.Down}})
	
	GROUND:Hide(partner.EntName)
	GROUND:Hide(hero.EntName)
		
	AI:DisableCharacterAI(partner)
	SOUND:StopBGM()
	
	GAME:MoveCamera(180, 120, 1, false)		
	GAME:CutsceneMode(true)

	GAME:WaitFrames(60)
	GAME:FadeIn(40)
	
	GAME:WaitFrames(20)
	
	local coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(luxio, "Exclaim", true) end)
	local coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(glameow, "Exclaim", false) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GeneralFunctions.EmoteAndPause(cacnea, "Question", false) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.LookAround(luxio, 3, 4, true, false, false, Direction.Up) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.LookAround(glameow, 3, 4, true, false, false, Direction.DownRight) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) 
											GeneralFunctions.LookAround(cacnea, 3, 4, true, false, false, Direction.DownLeft) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	
	UI:SetSpeaker(cacnea)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Duh...[pause=0] Boss?[pause=0] Where did they go?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(luxio)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("They must have retreated.[pause=0] Those cowards...")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(glameow)
	UI:SetSpeakerEmotion("Happy")
	GROUND:CharSetAnim(glameow, "Idle", true)
	GROUND:CharSetEmote(glameow, "glowing", 0)
	UI:WaitShowDialogue("We really showed them who's boss,[pause=10] didn't we?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(cacnea)
	UI:SetSpeakerEmotion("Joyous")
	GROUND:CharSetAnim(cacnea, "Idle", true)
	GROUND:CharSetEmote(cacnea, "glowing", 0)
	UI:WaitShowDialogue("Huhuh,[pause=10] yeah,[pause=10] we sure did,[pause=10] huhuh!")	
	
	GAME:WaitFrames(40)
	GROUND:CharSetEmote(cacnea, "", 0)
	GROUND:CharSetEmote(glameow, "", 0)
	GROUND:CharEndAnim(cacnea)
	GROUND:CharEndAnim(glameow)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("But,[pause=10] duh...[pause=0] What do we do now,[pause=10] boss?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(luxio)
	UI:WaitShowDialogue("Those losers are gonna have to come back if they want to complete their mission.")
	UI:WaitShowDialogue("We're gonna wait here until they come back and embarrass them again with another beatdown!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(glameow)
	GROUND:CharSetEmote(glameow, "happy", 0)
	UI:SetSpeakerEmotion("Special1")
	UI:WaitShowDialogue("Oh,[pause=10] that's absolutely devilish,[pause=10] " .. luxio:GetDisplayName() .. "![pause=0] I love that plan!")
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(glameow, "", 0)
	GROUND:CharSetEmote(cacnea, "glowing", 0)
	UI:SetSpeaker(cacnea)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Huhuh,[pause=10] yup![pause=0] That's a great idea![pause=0] That's why you're the boss!")
	
	GAME:WaitFrames(40)
	GROUND:CharSetEmote(cacnea, "", 0)
	UI:SetSpeaker(luxio)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(luxio, Direction.Up, 4)
											UI:WaitShowDialogue("And as for you...[pause=0] You'll be staying put here too![pause=0] Don't even think of running away!") end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GROUND:CharAnimateTurnTo(glameow, Direction.Up, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) GROUND:CharAnimateTurnTo(cacnea, Direction.Up, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(sandile, "Sweating", true)
	UI:SetSpeaker(sandile)
	UI:SetSpeakerEmotion("Pain")
	UI:WaitShowDialogue("Eeep!")
	
	GAME:WaitFrames(30)
	GAME:FadeOut(false, 60)	
	GAME:WaitFrames(90)
	SV.Chapter3.LostToBoss = false--reset this flag
	--set generic flags
	SV.TemporaryFlags.Dinnertime = true
	SV.TemporaryFlags.Bedtime = true
	SV.TemporaryFlags.MorningWakeup = true
	SV.TemporaryFlags.MorningAddress = true
	
	GAME:CutsceneMode(false)
	GAME:EnterGroundMap("guild_dining_room", "Main_Entrance_Marker")
end 

--Player Defeated boss
function crooked_den_ch_3.DefeatedBoss()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local sandile, luxio, glameow, cacnea = CharacterEssentials.MakeCharactersFromList({{"Sandile", 172, 72, Direction.Down},
																						{"Luxio", 172, 128, Direction.Down},
																						{"Glameow", 120, 112, Direction.Down},
																						{"Cacnea", 224, 112, Direction.Down}})
	
	GROUND:CharSetAction(glameow, RogueEssence.Ground.PoseGroundAction(glameow.Position, glameow.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Faint")))
	GROUND:CharSetAction(cacnea, RogueEssence.Ground.PoseGroundAction(cacnea.Position, cacnea.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Sleep")))
	GROUND:CharSetAnim(luxio, "Charge", true)
	GROUND:TeleportTo(hero, 188, 160, Direction.Up)
	GROUND:TeleportTo(partner, 156, 160, Direction.Up)
	GAME:MoveCamera(180, 120, 1, false)
	AI:DisableCharacterAI(partner)
	SOUND:StopBGM()
	
	GAME:CutsceneMode(true)
	GAME:WaitFrames(60)
	GAME:FadeIn(40)
	
	GAME:WaitFrames(30)
	UI:SetSpeaker(luxio)
	UI:SetSpeakerEmotion("Pain")
	
	--special message if you completely shit on them
	if SV.MapTurnCounter ~= nil then --nil check as a failsafe
		if SV.MapTurnCounter <= 5 then
			UI:WaitShowDialogue("Th-that...[pause=0] was cheap...")
			GAME:WaitFrames(20)
		end
	end
	SV.MapTurnCounter = nil
	UI:WaitShowDialogue("Th-this...[pause=0] isn't o-over...")
	UI:WaitShowDialogue("Y-you haven't s-seen the last of...[pause=0] T-Team [color=#FFA5FF]Style[color]...[pause=0] Losers...")

	GAME:WaitFrames(20)
	SOUND:PlayBattleSE('EVT_CH03_Boss_Collapse')
	GROUND:CharSetEmote(luxio, "shock", 1)
	GROUND:CharSetAction(luxio, RogueEssence.Ground.PoseGroundAction(luxio.Position, luxio.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Faint")))
	GAME:WaitFrames(80)
	
	UI:SetSpeaker(partner)
	GeneralFunctions.Hop(partner)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("We did it![pause=0] We put those bullies in their place,[pause=10] " .. hero:GetDisplayName() .. "!")
	--UI:SetSpeakerEmotion("Normal")
	--UI:WaitShowDialogue("Now we can get back to our mission!")
	
	GAME:WaitFrames(20)
	SOUND:PlayBGM("In the Depths of the Pit.ogg", false)
	local coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, 142, 138, false, 1) 
												  GROUND:MoveToPosition(partner, 142, 122, false, 1)
												  GeneralFunctions.EightWayMove(partner, 156, 104, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
												  GeneralFunctions.EightWayMove(hero, 204, 138, false, 1) 
												  GROUND:MoveToPosition(hero, 204, 122, false, 1)
												  GeneralFunctions.EightWayMove(hero, 188, 104, false, 1) end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(10)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(sandile:GetDisplayName() .. ",[pause=10] are you okay?[pause=0] Did those jerks hurt you at all?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(sandile)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("I'm fine,[pause=10] but...")
	UI:WaitShowDialogue("You're wondering how I'm doing?[pause=0] Aren't I an outlaw here?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("Just because you're an outlaw doesn't mean I want to see you hurt!")
	UI:WaitShowDialogue("Besides,[pause=10] you're nicer than most of the Pokémon we've had to deal with recently.")
	
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(sandile, "Sweating", true)
	UI:SetSpeaker(sandile)
	UI:SetSpeakerEmotion("Teary-Eyed")
	UI:WaitShowDialogue("Sniff...[pause=0] I can't believe how nice you're being towards a criminal like me...")
	UI:WaitShowDialogue("Sniff...[pause=0] That means a lot to me...[pause=0] Thank you...")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Of course![pause=0] I'm just glad to hear you're unharmed!")
	
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("But...[pause=0] We still do need to bring you in now.[pause=0] I'm sorry...")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(sandile)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("It's OK.[pause=0] I understand...")
	
	GAME:WaitFrames(12)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Alright,[pause=10] " .. hero:GetDisplayName() .. ".[pause=0] Let's get a move on back to the guild.")
	
	GAME:WaitFrames(30)
	SOUND:FadeOutBGM(60)
	GAME:FadeOut(false, 60)	
	GAME:WaitFrames(90)
	GAME:CutsceneMode(false)
	GAME:EnterGroundMap("guild_second_floor", "Main_Entrance_Marker")
	
	--idea: Zhayn will go easy on Thwait because he knows that criminals can be reformed as he was himself a criminal once.
	--partner should also suggest they go easy on him he doesnt seem so bad
	--shuca will tell partner that finesse is needed sometimes, and they did the right thing.
end 

--player died to boss, came back: play a different scene to reflect this and get back into the fight faster.
function crooked_den_ch_3.SecondPreBossScene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local sandile, luxio, glameow, cacnea = CharacterEssentials.MakeCharactersFromList({{"Sandile", 172, 72, Direction.Down},
																						{"Luxio", 172, 120, Direction.Up},
																						{"Glameow", 144, 104, Direction.UpRight},
																						{"Cacnea", 200, 104, Direction.UpLeft}})
	
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	GeneralFunctions.StartTremble(sandile)
	GROUND:TeleportTo(hero, 188, 256, Direction.Up)
	GROUND:TeleportTo(partner, 156, 256, Direction.Up)
	GAME:MoveCamera(180, 120, 1, false)
	SOUND:StopBGM()
	GAME:WaitFrames(60)
	
	UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
	GAME:WaitFrames(60)
	UI:WaitHideTitle(20)
	GAME:FadeIn(40)	
	SOUND:PlayBGM('In The Depths of the Pit.ogg', false)
	
	GAME:WaitFrames(20)
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 156, 152, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:MoveToPosition(hero, 188, 152, false, 1) end)
	TASK:JoinCoroutines({coro1, coro2})
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Determined")
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowDialogue("Team [color=#FFA5FF]Style[color]!") end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) 
											SOUND:PlayBattleSE('EVT_Emote_Exclaim_2')
											GROUND:CharSetEmote(luxio, "exclaim", 1) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(24) 
												  GROUND:CharSetEmote(glameow, "exclaim", 1) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(28) 
												  GROUND:CharSetEmote(cacnea, "exclaim", 1) end)	
	local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
												  GeneralFunctions.StopTremble(sandile)
												  GROUND:CharSetEmote(sandile, "exclaim", 1) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(luxio, Direction.Down, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GROUND:CharAnimateTurnTo(glameow, Direction.Down, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(8) GROUND:CharAnimateTurnTo(cacnea, Direction.Down, 4) end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3})
	GAME:WaitFrames(20)

	UI:SetSpeaker(cacnea)
	UI:SetSpeakerEmotion("Stunned")
	UI:WaitShowDialogue("Wow,[pause=10] boss![pause=0] They really did come back,[pause=10] just like you said they would!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(luxio)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("Of course I was right,[pause=10] you idiot![pause=0] When am I ever wrong?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(glameow)
	UI:SetSpeakerEmotion("Joyous")
	UI:WaitShowDialogue("If they came back,[pause=10] they must really enjoy being humiliated.[pause=0] What a bunch of weirdos!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("We're here for " .. sandile:GetDisplayName() .. "![pause=0] We still have our mission to complete!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(glameow)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("That's strange,[pause=10] darlings,[pause=10] because the only thing you're going to find here...")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(luxio) 
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("...Is another beatdown![pause=0] Delivered by yours truly!")
	UI:WaitShowDialogue("Get ready![pause=0] We're going to remind you why you're not fit to be adventurers!")
	
	COMMON.BossTransition()
	GAME:CutsceneMode(false)
	--enter fight
	GAME:ContinueDungeon("crooked_cavern", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
	
end
	


return crooked_den_ch_3




