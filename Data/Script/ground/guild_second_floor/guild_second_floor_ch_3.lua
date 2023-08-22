require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

guild_second_floor_ch_3 = {}



function guild_second_floor_ch_3.SetupGround()

	if not SV.Chapter3.DefeatedBoss then
	

		local mareep, cranidos, silcoon, metapod = 
			CharacterEssentials.MakeCharactersFromList({
				{'Mareep', 360, 224, Direction.UpRight},
				{'Cranidos', 424, 224, Direction.UpLeft},
				{'Silcoon', 'Left_Duo_2'},
				{'Metapod', 'Left_Duo_1'}
			})
	else
		local spheal, jigglypuff, marill, doduo, bagon, audino = 
			CharacterEssentials.MakeCharactersFromList({
				{'Spheal', 'Left_Trio_1'},
				{'Jigglypuff', 'Left_Trio_2'},
				{'Marill', 'Left_Trio_3'},
				{'Doduo', 'Right_Duo_1'},
				{'Bagon', 'Right_Duo_2'},
				{'Audino', 'Generic_Spawn_1'}
			})
			
		AI:SetCharacterAI(jigglypuff, "ai.ground_talking", true, 240, 60, 130, false, 'Default', {marill, spheal})
		AI:SetCharacterAI(marill, "ai.ground_talking", true, 240, 60, 0, false, 'Default', {jigglypuff, spheal})
		AI:SetCharacterAI(spheal, "ai.ground_talking", true, 240, 60, 50, false, 'Default', {jigglypuff, marill})
		
		AI:SetCharacterAI(bagon, "ai.ground_talking", true, 240, 60, 80, false, 'Default', {doduo})
		AI:SetCharacterAI(doduo, "ai.ground_talking", true, 240, 60, 0, false, 'Default', {bagon})

		AI:SetCharacterAI(audino, "ai.ground_default", RogueElements.Loc(176, 264), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
	
		
	end
			
	
	GAME:FadeIn(20)
	
end

function guild_second_floor_ch_3.Spheal_Action(chara, activator)
	local item = RogueEssence.Dungeon.InvItem('gummi_blue')
	GeneralFunctions.StartConversation(chara, "Let's do this job![pause=0] The reward is a " .. item:GetDisplayName() .. "![pause=0] They're too yummy to pass up!", "Normal", false)
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_3.Jigglypuff_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Some jobs are harder than others.[pause=0] The difficulty of a job depends on the location and the type of mission.")
	UI:WaitShowDialogue("Escort and outlaw missions are tougher than other types of missions for example.")
	--too long with no nicknames
	UI:WaitShowDialogue("Harder jobs give more Adventurer Rank Points and usually have better rewards though,[pause=10] so they're worth doing!")
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_3.Marill_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Our team doesn't like to do outlaw missions.[pause=0] They're too scary!", "Worried")
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("We prefer doing rescue missions.[pause=0] They're easier and we still get to help Pokémon in need!")
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_3.Doduo_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "We've heard that some outlaws will use other Pokémon to defend themself from adventuring teams.", "Normal")
	UI:WaitShowDialogue("When the outlaw gets found,[pause=10] they spring a trap and an entire group of Pokémon will attack you!")
	UI:WaitShowDialogue("We can personally attest to the power of numbers.[pause=0] You should be prepared for these sorts of outlaws!")
	GeneralFunctions.EndConversation(chara)

end

function guild_second_floor_ch_3.Bagon_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Some outlaws run for it when they see an adventuring team!")
	UI:WaitShowDialogue("If they make it to the stairs,[pause=10] then they'll get away!")
	UI:WaitShowDialogue("It's a good thing " .. CharacterEssentials.GetCharacterName("Doduo") .. " can fly![pause=0] It'll make it much easier to catch up to those outlaws!")
	GeneralFunctions.EndConversation(chara)

end

function guild_second_floor_ch_3.Audino_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "New jobs come in on the boards here each day![pause=0]\nI would know,[pause=10] as it's my j-job to keep the boards updated!")
	UI:WaitShowDialogue("You can check the boards whenever you like to see what jobs are available for the taking.")
	UI:WaitShowDialogue("You can hold onto jobs as long as you want,[pause=10] but know that you can only have up to eight jobs at a time!")
	UI:WaitShowDialogue("To check your taken jobs,[pause=10] you can use the boards here or press " .. STRINGS:LocalKeyString(9) .. " and choose Job List.")
	--too long with no nicknames
	UI:WaitShowDialogue("When you take a job from the board,[pause=10] it'll be activated automatically.[pause=0] Only jobs that are activated can be done!")
	UI:WaitShowDialogue("Y-you can suspend an activated job to save for later.[pause=0] Just choose Take Job on it to reactivate it!")
	UI:WaitShowDialogue("A-anyways,[pause=10] as long as a job is activated,[pause=10] you can just go to the mystery dungeon it's in to do it.")
	UI:WaitShowDialogue("You can even activate multiple jobs in the same dungeon and do them all at once if you want!")
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("And that's all there is to it![pause=0] G-good luck with your missions!")
	GeneralFunctions.EndConversation(chara)
end


function guild_second_floor_ch_3.Silcoon_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, CharacterEssentials.GetCharacterName("Metapod") .. " and I make up Team [color=#FFA5FF]Flutter[color]!")
	UI:WaitShowDialogue("I know that name may seem a bit odd,[pause=10] but when we evolve again that name will make perfect sense!")
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_3.Metapod_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Me and " .. CharacterEssentials.GetCharacterName("Silcoon") .. " evolved recently.")
	--too long with no nicknames
	UI:WaitShowDialogue("We're hoping to evolve again as soon as we can.[pause=0] Our current forms are...[pause=30] pretty inconvenient,[pause=10] to say the least.")
	UI:WaitShowDialogue("It took us a lot longer than I'd like to admit to make it up the ramp to get here...")
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_3.Mareep_Action(chara, activator)
	if SV.Chapter3.EnteredCavern then
		GeneralFunctions.StartConversation(chara, "Hey you two![pause=0] Having trouble catching the\nba-a-a-addie?")
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("That's OK![pause=0] It can be rea-a-a-ally tough sometimes!")
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("I find that whenever I'm struggling to catch an outlaw,[pause=10] using items helps a lot!")
		UI:WaitShowDialogue("The right item can really make all the difference!")
		UI:WaitShowDialogue("Just know that orbs don't work at the end of dungeons,[pause=10] where ba-a-a-addies usually hide!")
		UI:WaitShowDialogue("Oh![pause=0] And if an outla-a-a-aw is using moves on you from far away,[pause=10] move out of their line of sight!")
		UI:WaitShowDialogue("That way they can't use those moves on you anymore![pause=0] They'll have to try something else instead!")
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("I hope that helps![pause=0] Good luck,[pause=10] I know you two\nca-a-a-an do it!")
	else 
		GeneralFunctions.StartConversation(chara, "Good luck you two![pause=0] Come back and speak to us if you ha-a-a-ave any trouble!")	
	end
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_3.Cranidos_Action(chara, activator)
	local hero = CH("PLAYER")
	local partner = CH('Teammate1')
	if SV.Chapter3.EnteredCavern then
		GeneralFunctions.StartConversation(chara, "You two still haven't caught that outlaw yet?")
		UI:SetSpeakerEmotion("Joyous")
		GROUND:CharSetEmote(chara, "glowing", 0)
		UI:WaitShowDialogue("Hahaha![pause=0] I knew you two couldn't do it![pause=0] Hahaha!")
		
		GAME:WaitFrames(20)
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Determined")
		UI:WaitShowDialogue("Grr...")
		
		GROUND:CharTurnToCharAnimated(partner, hero, 4)
		GROUND:CharTurnToCharAnimated(hero, partner, 4)
		UI:WaitShowDialogue("Talking to " .. chara:GetDisplayName() .. " is pointless.[pause=0] If we need advice,[pause=10] we should try asking " .. CharacterEssentials.GetCharacterName("Mareep") .. ".")	
		GROUND:CharSetEmote(chara, "", 0)
		GROUND:CharAnimateTurnTo(chara, Direction.UpLeft, 4)
	else 
		GeneralFunctions.StartConversation(chara, "Don't you two have an outlaw to catch?[pause=0] What are you doing here talking to me?", "Determined")
	end
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_3.OutlawRewardScene() 
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("crooked_cavern")
	
	GAME:MoveCamera(400, 240, 1, false) 
	
	local sandile, pawniard_boy, pawniard_girl, bisharp, noctowl = 
		CharacterEssentials.MakeCharactersFromList({
			{'Sandile', 392, 224, Direction.Down},
			{'Pawniard_Boy', 368, 224, Direction.Down},
			{'Pawniard_Girl', 416, 224, Direction.Down},
			{'Bisharp', 392, 248, Direction.Down}, 
		--	{'Cranidos', 576, 100, Direction.Down},
		--	{'Mareep', 576, 100, Direction.Down},
			{'Noctowl', 448, 264, Direction.UpLeft}
		})
	
	--change his form from scarved to regular
	sandile.Data.BaseForm = RogueEssence.Dungeon.MonsterID("sandile", 0, "normal", Gender.Male)
	
	GROUND:Hide('Downwards_Stairs_Exit')
	
	GROUND:TeleportTo(partner, 376, 272, Direction.Up)
	GROUND:TeleportTo(hero, 408, 272, Direction.Up)
	SOUND:StopBGM()

	
	GAME:FadeIn(40)
	SOUND:PlayBGM("Job Clear!.ogg", true)
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(bisharp)
	UI:WaitShowDialogue("'Ello there.[pause=0] Name's " .. bisharp:GetDisplayName() .. ",[pause=10] and I'm the head officer 'round these parts.")
	UI:WaitShowDialogue("Thanks to your help,[pause=10] we managed to bag us here a wanted criminal.")
	UI:WaitShowDialogue("For that,[pause=10] my deputies and I thank the two of ya.")
	
	--pose!
	GROUND:CharSetEmote(pawniard_boy, "happy", 0)
	GROUND:CharSetEmote(pawniard_girl, "happy", 0)
	local coro1 = TASK:BranchCoroutine(function() GROUND:CharSetAction(bisharp, RogueEssence.Ground.PoseGroundAction(bisharp.Position, bisharp.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose"))) end)
	local coro2 = TASK:BranchCoroutine(function() GROUND:CharSetAction(pawniard_boy, RogueEssence.Ground.PoseGroundAction(pawniard_boy.Position, pawniard_boy.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose"))) end)
	local coro3 = TASK:BranchCoroutine(function() GROUND:CharSetAction(pawniard_girl, RogueEssence.Ground.PoseGroundAction(pawniard_girl.Position, pawniard_girl.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose"))) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(12) SOUND:PlayBattleSE('DUN_Fury_Cutter') end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	GAME:WaitFrames(60)
	
	--UI:SetSpeaker(partner)
	--UI:SetSpeakerEmotion("Sad")
	--UI:WaitShowDialogue(".........")
	--GAME:WaitFrames(20)
	
	GROUND:CharEndAnim(bisharp)
	GROUND:CharEndAnim(pawniard_boy)
	GROUND:CharEndAnim(pawniard_girl)
	GROUND:CharSetEmote(pawniard_boy, "", 0)
	GROUND:CharSetEmote(pawniard_girl, "", 0)
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(bisharp)
	UI:WaitShowDialogue("I've already given the bounty on this here criminal's head to your superior over there.")
	UI:WaitShowDialogue("Make sure to pick it up from him.[pause=0] Thank ya again for lendin' a hand.")
	
	GAME:WaitFrames(4)
	GROUND:CharTurnToCharAnimated(bisharp, sandile, 4)
	UI:WaitShowDialogue("As for you...[pause=0] It's time to go.[pause=0] Come with us,[pause=10] and don't try nothin' funny.")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(sandile)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("Oh...[pause=0] OK...")
	
	GAME:WaitFrames(30)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Surprised")
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(bisharp, Direction.Left, 4) 
											GROUND:MoveInDirection(bisharp, Direction.Left, 56, false, 1) 
											GeneralFunctions.EmoteAndPause(bisharp, "Exclaim", true) end)
	
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(2)
											GROUND:CharAnimateTurnTo(pawniard_boy, Direction.Left, 4) 
											GROUND:MoveInDirection(pawniard_boy, Direction.Left, 56, false, 1) 
											GeneralFunctions.EmoteAndPause(pawniard_boy, "Exclaim", false) end)
											
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:CharAnimateTurnTo(pawniard_girl, Direction.Left, 4) 
											GROUND:MoveInDirection(pawniard_girl, Direction.Left, 56, false, 1)
											GeneralFunctions.EmoteAndPause(pawniard_girl, "Exclaim", false) end)
											
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(sandile, Direction.Left, 4) 
											GROUND:MoveInDirection(sandile, Direction.Left, 56, false, 1) 
											GeneralFunctions.EmoteAndPause(sandile, "Shock", false) end)
												  
	local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
												  GeneralFunctions.FaceMovingCharacter(partner, bisharp, 4, Direction.UpLeft)
											      SOUND:FadeOutBGM(120)
												  UI:WaitShowTimedDialogue("Wait!", 60) end)
											
	local coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
												  GeneralFunctions.FaceMovingCharacter(hero, bisharp, 4, Direction.UpLeft)
												  GAME:WaitFrames(50) 
												  GeneralFunctions.EmoteAndPause(hero, "Exclaim", false) end)
	local coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(70) GeneralFunctions.EmoteAndPause(noctowl, "Notice", false) end)
	--local coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(60) GeneralFunctions.EmoteAndPause(mareep, "Exclaim", false) end)
	--local coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(66) GeneralFunctions.EmoteAndPause(cranidos, "Exclaim", false) end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7})
	GAME:WaitFrames(20)
	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(bisharp, partner, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:CharTurnToCharAnimated(pawniard_boy, partner, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GROUND:CharAnimateTurnTo(pawniard_girl, Direction.DownRight, 4) end)
	coro4 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GROUND:CharTurnToCharAnimated(sandile, partner, 4) end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GROUND:CharTurnToCharAnimated(noctowl, partner, 4) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6})
	UI:SetSpeaker(bisharp)
	UI:WaitShowDialogue("Hmm?[pause=0] What's up?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("Um...[pause=0] I just wanted to say that I don't think " .. sandile:GetDisplayName() .. " is a bad Pokémon...")
	UI:WaitShowDialogue("I know he's an outlaw and he needs to be arrested and all...")
	UI:WaitShowDialogue("But I think he's just someone who made a poor decision.[pause=0] He isn't wicked or anything...")
	UI:WaitShowDialogue("So,[pause=10] um...[pause=0] Would it be possible for you to go easy on him,[pause=10] please?")
	
	GAME:WaitFrames(40)
	GROUND:EntTurn(hero, Direction.UpLeft)
	GROUND:EntTurn(noctowl, Direction.UpLeft)
	UI:SetSpeaker(bisharp)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(".........")
	UI:WaitShowDialogue("...Sorry mate...[pause=0] Rules 'er rules.")
	UI:WaitShowDialogue("Even if he deserves some leniency,[pause=10] and from what you're sayin',[pause=10] maybe he does...")
	UI:WaitShowDialogue("I have to be consistent or the law wouldn't be fair.")
	UI:WaitShowDialogue("That's just the way it's gotta be.[pause=0] I'm sorry.")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue(".........")
	UI:WaitShowDialogue("...OK.[pause=0] I understand...")
	
	GAME:WaitFrames(30)
	GROUND:CharAnimateTurnTo(bisharp, Direction.Left, 4) 
	UI:SetSpeaker(bisharp)
	UI:WaitShowDialogue("...Alright.[pause=0] Let's not dawdle here any longer.[pause=0] Get a move on you lot.")
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharAnimateTurnTo(sandile, Direction.Left, 4) 
											GROUND:MoveToPosition(sandile, 288, 224, false, 1) 
											GROUND:MoveToPosition(sandile, 272, 208, false, 1)
											GROUND:MoveToPosition(sandile, 272, 184, false, 1)
											GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(sandile, Direction.DownRight, 4)
											GAME:WaitFrames(20)
											GeneralFunctions.EmoteAndPause(sandile, "Shock", false)
											GROUND:CharAnimateTurnTo(sandile, Direction.Up, 4)
											GROUND:MoveToPosition(sandile, 272, 168, false, 1)
											GAME:GetCurrentGround():RemoveTempChar(sandile)	end)
	coro2 = TASK:BranchCoroutine(function() --GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(pawniard_boy, Direction.Left, 4)
											GROUND:MoveToPosition(pawniard_boy, 288, 224, false, 1) 
											GROUND:MoveToPosition(pawniard_boy, 272, 208, false, 1)
											GROUND:MoveToPosition(pawniard_boy, 272, 168, false, 1)	
											GAME:GetCurrentGround():RemoveTempChar(pawniard_boy) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:CharAnimateTurnTo(pawniard_girl, Direction.Left, 4)
											GROUND:MoveToPosition(pawniard_girl, 288, 224, false, 1) 
											GROUND:MoveToPosition(pawniard_girl, 272, 208, false, 1)
											GROUND:CharAnimateTurnTo(pawniard_girl, Direction.Up, 4)
											GAME:WaitFrames(28)
											GROUND:MoveToPosition(pawniard_girl, 272, 200, false, 1)
											GAME:WaitFrames(60)
											GROUND:MoveToPosition(pawniard_girl, 272, 168, false, 1)
											GAME:GetCurrentGround():RemoveTempChar(pawniard_girl) end)
	
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:MoveToPosition(bisharp, 280, 248, false, 1)
											GROUND:MoveToPosition(bisharp, 272, 240, false, 1)
											GROUND:CharAnimateTurnTo(bisharp, Direction.Up, 4)
											GAME:WaitFrames(130)
											GROUND:MoveToPosition(bisharp, 272, 168, false, 1)
											GAME:GetCurrentGround():RemoveTempChar(bisharp) end)
	

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Sad")
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, hero, 4)
											UI:WaitShowTimedDialogue("Oh...[pause=30] Poor " .. CharacterEssentials.GetCharacterName("Sandile") .. "...", 60) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(noctowl, 392, 240, false, 1)
											GROUND:CharAnimateTurnTo(noctowl, Direction.Down, 4) end)
											
	TASK:JoinCoroutines({coro1, coro2, coro3})

	--im surprised to see you stick up for an outlaw... that's unusual. But it does seem to me as though he was an unusual outlaw.
	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end)
	coro3 = TASK:BranchCoroutine(function() UI:WaitShowDialogue("It is most unusual to see one sticking up for an outlaw they have just apprehended...") 
											UI:WaitShowDialogue("...But it seems to me as though he was a most unusual outlaw.")
											UI:WaitShowDialogue("Regardless,[pause=10] you've captured the outlaw successfully.[pause=0] Congratulations.")
											UI:WaitShowDialogue("Here is the bounty that " .. CharacterEssentials.GetCharacterName("Bisharp") .. " gave to me.[pause=0] You have earned it.") end)
											
	TASK:JoinCoroutines({coro1, coro2, coro3})

	GAME:WaitFrames(10)
	GeneralFunctions.RewardItem(500, true)
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("Now then,[pause=10] I believe " .. CharacterEssentials.GetCharacterName("Snubbull") .. " should have dinner ready right about now.[pause=0] Will you accompany me upstairs?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("...[pause=0]OK.")
	
	GAME:WaitFrames(60)
	GAME:FadeOut(false, 60)
	SV.TemporaryFlags.Dinnertime = true
	GAME:CutsceneMode(false)
	GAME:EnterGroundMap("guild_dining_room", "Main_Entrance_Marker")

end


function guild_second_floor_ch_3.OutlawTutorialScene()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("crooked_cavern")
	
	GAME:MoveCamera(400, 176, 1, false)
	
	local cranidos, mareep = 
		CharacterEssentials.MakeCharactersFromList({
			{'Cranidos', 576, 100, Direction.Down},
			{'Mareep', 576, 100, Direction.Down},
			{'Silcoon', 'Left_Duo_2'},
			{'Metapod', 'Left_Duo_1'}
	})
	GROUND:Hide('Upwards_Stairs_Exit')
	
	GROUND:TeleportTo(partner, 576, 100, Direction.Down)
	GROUND:TeleportTo(hero, 576, 100, Direction.Down)
	SOUND:StopBGM()
	GROUND:Hide(hero.EntName)
	GROUND:Hide("Teammate1")
	GROUND:Hide("Mareep")
	GROUND:Hide("Cranidos")
	
	GAME:FadeIn(40)
	SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true)
	
	GAME:WaitFrames(20)

	local coro1 = TASK:BranchCoroutine(function() GROUND:Unhide("Mareep")
												  GAME:WaitFrames(20)
												  GROUND:MoveToPosition(mareep, 524, 100, false, 1)
												  GeneralFunctions.EightWayMove(mareep, 492, 184, false, 1)
												  GeneralFunctions.EightWayMove(mareep, 360, 224, false, 1)
												  GeneralFunctions.FaceMovingCharacter(mareep, partner, 4, Direction.Down)
												  GROUND:CharAnimateTurnTo(mareep, Direction.DownRight, 4) end)
    local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(52)
												  GROUND:Unhide("Teammate1")
												  GAME:WaitFrames(20)
												  GROUND:MoveToPosition(partner, 524, 100, false, 1)
												  GeneralFunctions.EightWayMove(partner, 492, 184, false, 1)
												  GeneralFunctions.EightWayMove(partner, 376, 256, false, 1)
												  GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) end)
    local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(104)
												  GROUND:Unhide(hero.EntName)
												  GAME:WaitFrames(20)
												  GROUND:MoveToPosition(hero, 524, 100, false, 1)
												  GeneralFunctions.EightWayMove(hero, 492, 184, false, 1)
												  GeneralFunctions.EightWayMove(hero, 408, 256, false, 1)
												  GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end)   
    local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(156)
												  GROUND:Unhide("Cranidos")
												  GAME:WaitFrames(20)
												  GROUND:MoveToPosition(cranidos, 524, 100, false, 1)
												  GeneralFunctions.EightWayMove(cranidos, 492, 184, false, 1)
												  GeneralFunctions.EightWayMove(cranidos, 424, 224, false, 1)
												  GROUND:CharAnimateTurnTo(cranidos, Direction.DownLeft, 4) end)
	local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(260)
												  GAME:MoveCamera(400, 224, 48, false) end)
												  
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(mareep)
	UI:WaitShowDialogue("Here we are![pause=0] The Outlaw Notice Board!")
	
	GAME:WaitFrames(12)
	GeneralFunctions.DuoTurnTowardsChar(mareep)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("What's so different about this board compared to the one " .. CharacterEssentials.GetCharacterName("Noctowl") .. " showed us the other day?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(mareep)
	UI:WaitShowDialogue(CharacterEssentials.GetCharacterName("Noctowl") .. " showed you the board on the other side,[pause=10] right?")
	UI:WaitShowDialogue("Tha-a-a-at was the Job Bulletin Board.[pause=0] It has all sorts of regular jobs posted on it!")
	
	GAME:WaitFrames(12)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(mareep, Direction.UpRight, 4)
											GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
											GROUND:EntTurn(hero, Direction.Up) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharAnimateTurnTo(cranidos, Direction.UpLeft, 4) end)
	TASK:JoinCoroutines({coro1, coro2})
	
	UI:WaitShowDialogue("This is the Outlaw Notice Board.[pause=0] Pokémon on the wrong side of the la-a-a-aw are posted here.")
	UI:WaitShowDialogue("They all have a bounty on their head for one reason or another.[pause=0] They're a real na-a-a-asty bunch!")
	UI:WaitShowDialogue("Outlaws hide out in different mystery dungeons all over the pla-a-a-ace!")
	UI:WaitShowDialogue("It'll be your job to go into those dungeons to bring these ba-a-a-addies to justice!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Surprised")
	GROUND:CharSetEmote(partner, "sweating", 1)
	UI:WaitShowDialogue("These outlaws are dangerous,[pause=10] lawless Pokémon,[pause=10] aren't they?[pause=0] Are we really ready to take one on?")

	GAME:WaitFrames(12)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(mareep, Direction.DownRight, 4)
											GeneralFunctions.DuoTurnTowardsChar(mareep) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(cranidos, mareep, 4) end)
	TASK:JoinCoroutines({coro1, coro2})

	UI:SetSpeaker(mareep)
	UI:WaitShowDialogue("No need to worry![pause=0] Just because a Pokémon is an outla-a-a-aw doesn't mean they're that tough!")
	UI:WaitShowDialogue("Outlaws range from criminal masterminds to petty thieves...[pause=0] We'll pick a ba-a-a-addie that's right for you!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("Well,[pause=10] I guess that doesn't sound so bad then.")
	GAME:WaitFrames(10)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("But...[pause=0] What exactly are we supposed to do once we find the outlaw?")
	
	GAME:WaitFrames(16)
	GROUND:CharAnimateTurnTo(cranidos, Direction.DownLeft, 4)
	UI:SetSpeaker(cranidos)
	UI:SetSpeakerEmotion("Determined")
	--GROUND:CharSetEmote(cranidos, "happy", 0)

	--this is the extent of ganlon's "outbursts" because he's very clearly in shuca's attention
	coro1 = TASK:BranchCoroutine(function() --GeneralFunctions.Hop(cranidos)
								-- GeneralFunctions.Hop(cranidos)			
								 UI:WaitShowDialogue("Isn't it obvious?[pause=0] You knock 'em out and bring 'em back to town!") 
								 --GROUND:CharSetEmote(cranidos, "", 0) 
								 end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) 
								 GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4) end)	
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(12) 
								 GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4) end)	
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(14) 
								 GROUND:CharAnimateTurnTo(mareep, Direction.Right, 4) end)
	 
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	GAME:WaitFrames(16)
	GROUND:CharAnimateTurnTo(mareep, Direction.DownRight)
	UI:SetSpeaker(mareep)
	UI:WaitShowDialogue("Yup![pause=0] Tha-a-a-at's right!")
	
	GAME:WaitFrames(12)
	GeneralFunctions.DuoTurnTowardsChar(mareep)
	
	UI:WaitShowDialogue("Most outla-a-a-aws won't go peacefully![pause=0] They'll either try to fight you or make a run for it!")
	UI:WaitShowDialogue("If they won't go willingly,[pause=10] you'll need to knock them out!")
	--todo: perhaps add shuca going bang! zoom! pow! and acting out the scene of her beating up an outlaw
	UI:WaitShowDialogue("Once you ma-a-a-anage to bring them back to town,[pause=10] " .. CharacterEssentials.GetCharacterName("Bisharp") .. " will take care of the rest.")
	
	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(partner, "Question", true)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(CharacterEssentials.GetCharacterName("Bisharp") .. "?[pause=0] Who's that?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(mareep)
	UI:WaitShowDialogue(CharacterEssentials.GetCharacterName("Bisharp") .. " is the main officer for the region.[pause=0] He handles booking and bounties for outla-a-a-aws!")
	UI:WaitShowDialogue("He'll meet you at the board here if you have any outla-a-a-aws to turn over.")
	UI:WaitShowDialogue("Then,[pause=10] he'll pa-a-a-ay out the bounty and take them away!")
	
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("And that's the ba-a-a-asics![pause=0] Now,[pause=10] let's pick out an outlaw for you!")

	GAME:WaitFrames(12)
	GROUND:CharTurnToCharAnimated(mareep, cranidos, 4)
	GROUND:CharTurnToCharAnimated(cranidos, mareep, 4)
	UI:WaitShowDialogue(cranidos:GetDisplayName() .. ",[pause=10] can you help me pick out a good outla-a-a-aw for them?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(cranidos)
	UI:WaitShowDialogue("Sure thing,[pause=10] " .. mareep:GetDisplayName() .. ".")
	
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(cranidos, hero, 4)
	GeneralFunctions.DuoTurnTowardsChar(cranidos)
	UI:SetSpeakerEmotion("Joyous")
	GROUND:CharSetEmote(cranidos, "glowing", 0)
	UI:WaitShowDialogue("I'll be sure to choose one that's weak and pitiful enough for a couple of greenhorns like them to handle.")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("Grrr...")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(mareep)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Tha-a-a-at would be perfect![pause=0] Thank you,[pause=10] " .. cranidos:GetDisplayName() .. "!")
	
	GAME:WaitFrames(20)
	
	GROUND:CharSetEmote(cranidos, "", 0)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(cranidos, Direction.UpLeft, 4) 
								 GROUND:CharSetAnim(cranidos, "Idle", true) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) 
								 GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) end)	
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(14) 
								 GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end)	
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(18) 
								 GROUND:CharAnimateTurnTo(mareep, Direction.UpRight, 4) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(cranidos)
	UI:WaitShowDialogue("Alright,[pause=10] let's see here...")
	
	GAME:WaitFrames(80)
	GROUND:CharEndAnim(cranidos)
	SOUND:PlayBattleSE('EVT_Emote_Exclaim')
	GeneralFunctions.EmoteAndPause(cranidos, "Exclaim", false)
	UI:WaitShowDialogue("Aha!")
	
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(cranidos, hero, 4)
	GROUND:CharTurnToCharAnimated(mareep, partner, 4)
	UI:WaitShowDialogue("This one should be weak enough for you newbies.")
	GAME:WaitFrames(20)

	SOUND:PlayBattleSE("_UNK_EVT_028") -- paper crumpling
	GAME:FadeOut(false, 20)
	UI:WaitShowBG("Wanted_Poster", 180, 20)
	GAME:WaitFrames(180)
	SOUND:PlayBattleSE("_UNK_EVT_028") -- paper crumpling
	UI:WaitHideBG(20)
	GAME:FadeIn(20)
	
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("crooked_cavern")
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("According to the wanted poster,[pause=10] this " .. _DATA:GetMonster("sandile"):GetColoredName() .. " goes by " .. CharacterEssentials.GetCharacterName("Sandile") .. ".")
	UI:WaitShowDialogue("He's wanted for theft and is hiding out in " .. zone:GetColoredName() .. ".")
	
	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(mareep, "Exclaim", true)
	GROUND:CharTurnToCharAnimated(mareep, cranidos, 4)
	UI:SetSpeaker(mareep)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue(zone:GetColoredName() .. "!?[pause=0] Wow!")
	
	GAME:WaitFrames(16)
	GROUND:CharAnimateTurnTo(mareep, Direction.DownRight, 4)
	GeneralFunctions.DuoTurnTowardsChar(mareep)
	GROUND:CharSetAnim(mareep, "Idle", true)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Looks like " .. cranidos:GetDisplayName() .. " picked out a fun one for your first job![pause=0] Hehehe!")
	
	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(partner, "Question", true)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("What's " .. zone:GetColoredName() .. "?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(mareep)
	GROUND:CharEndAnim(mareep)
	UI:WaitShowDialogue("It's a mystery dungeon that ba-a-a-andits turned into a hideout.")
	UI:WaitShowDialogue("The bandits that hide there are relatively weak,[pause=10] so they group together to get a numbers advantage.")
	UI:WaitShowDialogue("Anyone who goes there should be prepared to get ambushed by a whole group of them!")
	
	GAME:WaitFrames(10)
	
	SOUND:StopBGM()
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(partner, "Shock", true) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.EmoteAndPause(hero, "Exclaim", false) end)
	
	TASK:JoinCoroutines({coro1, coro2})
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("What!?[pause=0] You're saying we're gonna get mugged by bandits if we go after this outlaw!?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(mareep)
	UI:WaitShowDialogue("Oh,[pause=10] they're all a bunch of pushovers![pause=0] I'm sure you can handle it!")
	UI:WaitShowDialogue(cranidos:GetDisplayName() .. " wouldn't have picked it out if he thought you couldn't!")
	
	GAME:WaitFrames(20)
	GeneralFunctions.DuoTurnTowardsChar(cranidos)
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(cranidos)
	GROUND:CharSetEmote(cranidos, "glowing", 0)
	UI:SetSpeakerEmotion("Joyous")
	UI:WaitShowDialogue("Haha![pause=0] Yup![pause=0] That's true![pause=0] I would never pick a job our newbies couldn't handle!")
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(partner, "Sweatdrop", true) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.EmoteAndPause(hero, "Sweatdrop", false) end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(30)
	GROUND:CharSetEmote(cranidos, "", 0)
	GeneralFunctions.DuoTurnTowardsChar(mareep)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("...Well...[pause=0] I'm still not sure...[pause=0] It seems so dangerous...")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(mareep)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Don't be so worried![pause=0] I know your first outlaw job may seem sca-a-a-ary...")
	UI:WaitShowDialogue("I know " .. cranidos:GetDisplayName() .. " and I were sca-a-a-ared on our first job!")

	GAME:WaitFrames(20)
	GeneralFunctions.DuoTurnTowardsChar(cranidos)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Heheheh![pause=0] Is that so?")
	
	
	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(cranidos, "Exclaim", true)
	GAME:WaitFrames(10)
	SOUND:PlayBattleSE("EVT_Emote_Sweating")
	GROUND:CharSetEmote(cranidos, "sweating", 1)
	GROUND:CharAnimateTurnTo(cranidos, Direction.DownRight, 2)
	GAME:WaitFrames(20)
	UI:SetSpeaker(cranidos)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue(".........")
	
	GAME:WaitFrames(30)
	GeneralFunctions.DuoTurnTowardsChar(mareep)
	UI:SetSpeaker(mareep)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Yup![pause=0] But even though we were afraid of the\nda-a-a-anger...[pause=0] We caught that outlaw!")
	UI:WaitShowDialogue("I know it's sca-a-a-ary for you too...[pause=0] But I know you two can do it!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	SOUND:PlayBGM("Wigglytuff's Guild.ogg", true)
	UI:WaitShowDialogue("Well,[pause=10] if you believe that we can do it,[pause=10] then I'm sure we'll be able to handle it!")
	
	GAME:WaitFrames(12)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:WaitShowDialogue("We got this,[pause=10] right,[pause=10] " .. hero:GetDisplayName() .. "?")
	
	GAME:WaitFrames(20)
	GeneralFunctions.DoAnimation(hero, "Nod")
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(mareep)
	GROUND:CharSetEmote(mareep, "happy", 0)
	UI:SetSpeakerEmotion("Joyous")
	GROUND:CharSetAnim(mareep, "Idle", true)
	UI:WaitShowDialogue("Yeah![pause=0] You guys got this!")
	
	GAME:WaitFrames(20)
	GROUND:CharEndAnim(mareep)
	GeneralFunctions.DuoTurnTowardsChar(mareep)
	GROUND:CharSetEmote(mareep, "", 0)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("You should head into town now to prepa-a-a-are.")
	UI:WaitShowDialogue("Even if the bandits are weak,[pause=10] you shouldn't underestimate them!")
	UI:WaitShowDialogue("Once you're ready,[pause=10] you should head east out of town towards the dungeon.")
	UI:WaitShowDialogue("The eastern path is the main wa-a-a-ay out of town.")
	UI:WaitShowDialogue("Anytime you want to adventure into a dungeon in the future,[pause=10] be sure to leave town to the east!")
	UI:WaitShowDialogue("Once you've caught this " ..CharacterEssentials.GetCharacterName('Sandile') .. " guy,[pause=10] bring him back here for your rewa-a-a-ard!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("OK![pause=0] We'll get ready,[pause=10] then head out east!")
	UI:WaitShowDialogue("Thank you,[pause=10] " .. mareep:GetDisplayName() .. ",[pause=10] for the help!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(mareep)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("A-a-a-anytime![pause=0] Me and " .. cranidos:GetDisplayName() .. " are happy to help!")
	UI:WaitShowDialogue("We need to find some jobs for ourselves now,[pause=10] so we'll be here a while.")
	UI:WaitShowDialogue("Come speak to us here if you ha-a-a-ave any trouble![pause=0] Good luck!")	
	
	GAME:WaitFrames(10)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Understood![pause=0] Thank you again!")
	
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Let's go get ready to take down our first outlaw,[pause=10] " .. hero:GetDisplayName() .. "!")
	
	GAME:WaitFrames(20)
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)
	partner.CollisionDisabled = true--redisable partner's collision. Something is causing this to be set to false earlier in the script...
	GeneralFunctions.PanCamera()
	GROUND:Unhide('Upwards_Stairs_Exit')
	SV.Chapter3.FinishedOutlawIntro = true
	GAME:CutsceneMode(false)	

	
	--i wasn't scared i was merely cold! they were a snorunt!!
end