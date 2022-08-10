require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

guild_second_floor_ch_3 = {}



function guild_second_floor_ch_3.SetupGround()
	
	
	GAME:FadeIn(20)
	
end

function guild_second_floor_ch_3.OutlawTutorialScene()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone].Entries[57]
	
	GAME:MoveCamera(400, 176, 1, false)
	
	local cranidos, mareep = 
		CharacterEssentials.MakeCharactersFromList({
			{'Cranidos', 576, 100, Direction.Down},
			{'Mareep', 576, 100, Direction.Down}
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
	UI:SetSpeakerEmotion("Sad")
	GROUND:CharSetEmote(partner, 5, 1)
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
	--GROUND:CharSetEmote(cranidos, 1, 0)

	--this is the extent of ganlon's "outbursts" because he's very clearly in shuca's attention
	coro1 = TASK:BranchCoroutine(function() --GeneralFunctions.Hop(cranidos)
								-- GeneralFunctions.Hop(cranidos)			
								 UI:WaitShowDialogue("Isn't it obvious?[pause=0] You knock 'em out and bring 'em back to town!") 
								 --GROUND:CharSetEmote(cranidos, -1, 0) 
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
	UI:WaitShowDialogue("If they won't go willingly,[pause=10] you'll need knock them out!")
	--todo: perhaps add shuca going bang! zoom! pow! and acting out the scene of her beating up an outlaw
	UI:WaitShowDialogue("Once you ma-a-a-anage to bring them back to town,[pause=10] " .. CharacterEssentials.GetCharacterName("Bisharp") .. " will take care of the rest.")
	
	GAME:WaitFrames(20)
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
	GROUND:CharSetEmote(cranidos, 4, 0)
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
	
	GROUND:CharSetEmote(cranidos, -1, 0)
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
	
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone].Entries[57]
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("According to the wanted poster,[pause=10] this " .. _DATA:GetMonster(551):GetColoredName() .. " goes by " .. CharacterEssentials.GetCharacterName("Sandile") .. ".")
	UI:WaitShowDialogue("He's wanted for theft and is hiding out in " .. zone:GetColoredName() .. ".")
	
	GAME:WaitFrames(20)
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
	
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(partner, "Question", true)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("What's " .. zone:GetColoredName() .. "?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(mareep)
	GROUND:CharEndAnim(mareep)
	UI:WaitShowDialogue("It's a mystery dungeon that ba-a-a-andits turned into a hideout.")
	UI:WaitShowDialogue("The bandits that hide there are weak,[pause=10] so they group together to get a numbers advantage.")
	UI:WaitShowDialogue("Anyone who goes there should be prepared to get ambushed by whole group of them!")
	
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
	GROUND:CharSetEmote(cranidos, 4, 0)
	UI:SetSpeakerEmotion("Joyous")
	UI:WaitShowDialogue("Haha![pause=0] Yup![pause=0] That's true![pause=0] I would never pick a job our newbies couldn't handle!")
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(partner, "Sweatdrop", true) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.EmoteAndPause(hero, "Sweatdrop", false) end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(30)
	GROUND:CharSetEmote(cranidos, -1, 0)
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
	UI:WaitShowDialogue("Heheheh![pause=0] Is that so!")
	
	
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(cranidos, "Exclaim", true)
	GAME:WaitFrames(10)
	SOUND:PlayBattleSE("EVT_Emote_Sweating")
	GROUND:CharSetEmote(cranidos, 5, 1)
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
	GROUND:CharSetEmote(mareep, 1, 0)
	UI:SetSpeakerEmotion("Joyous")
	UI:WaitShowDialogue("Yeah![pause=0] You guys got this!")
	
	GAME:WaitFrames(20)
	GeneralFunctions.DuoTurnTowardsChar(mareep)
	GROUND:CharSetEmote(mareep, -1, 0)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("You should head into town now to prepa-a-a-are.")
	UI:WaitShowDialogue("Even if the outlaws are weak,[pause=10] you shouldn't underestimate them!")
	UI:WaitShowDialogue("Once you're ready,[pause=10] you should head east out of town towards the dungeon.")
	UI:WaitShowDialogue("The eastern path is the main wa-a-a-ay out of town.")
	UI:WaitShowDialogue("Anytime you want to adventure into a dungeon in the future,[pause=10] be sure to leave town to the east!")
	UI:WaitShowDialogue("Once you've caught this " ..CharacterEssentials.GetCharacterName('Sandile') .. " guy,[pause=10] bring them back here for your rewa-a-a-ard!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("OK![pause=0] We'll get ready then head out east!")
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
	GeneralFunctions.PanCamera()
	GROUND:Unhide('Upwards_Stairs_Exit')
	SV.Chapter3.FinishedOutlawIntro = true
	GAME:CutsceneMode(false)	

	
	--i wasn't scared i was merely cold! they were a snorunt!!
end