require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

guild_storage_hallway_ch_1 = {}



--[[function guild_storage_hallway_ch_1.SetupGround()
	local groundObj = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1), 
														RogueElements.Rect(144, 88, 64, 16),
														RogueElements.Loc(0, 8), 
														true, 
														"Event_Trigger")
	  groundObj:ReloadEvents()
	  GAME:GetCurrentGround():AddTempObject(groundObj)
	  
	  GAME:FadeIn(20)
end]]--

function guild_storage_hallway_ch_1.MeetAudino()
	
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	
	local audino = CharacterEssentials.MakeCharactersFromList({
		{'Audino', -20, 172, Direction.Right}
	})
	--need to spawn the partner at same location as hero and wait 32 frames before moving rather than 32 behind partner
	--putting partner too far out of bounds breaks their talk to script for whatever reason until the map reloads
	GAME:CutsceneMode(true)
	GROUND:Hide("Top_Exit")
	AI:DisableCharacterAI(partner)
	GROUND:TeleportTo(hero, 168, -24, Direction.Down)
	GROUND:TeleportTo(partner, 168, -24, Direction.Down)
	GAME:MoveCamera(180, 148, 1, false)
	GAME:FadeIn(20)
	--GROUND:Hide("Event_Trigger")
	
	--UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	--UI:WaitShowDialogue("C-coming through!")

--[[	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(hero, "Question", true)
											GROUND:CharAnimateTurnTo(hero, Direction.Right, 4)
											GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(hero, Direction.Left, 4)
											GROUND:CharSetEmote(hero, "shock", 1) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) 
												  GeneralFunctions.EmoteAndPause(partner, "Question", false)
												  GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
												  GAME:WaitFrames(10)
											      GROUND:CharAnimateTurnTo(partner, Direction.Down, 4) end) ]]--
					
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 168, 172, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(32)
												  GROUND:MoveToPosition(partner, 168, 140, false, 1) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(153) 
												  GROUND:MoveToPosition(audino, 152, 172, true, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, audino.CurrentForm.Species, audino.CurrentForm.Form, audino.CurrentForm.Skin, audino.CurrentForm.Gender)
	UI:SetSpeakerEmotion("Pain")
	SOUND:StopBGM()
	
	--you two dopes run into each other
	SOUND:PlayBattleSE('EVT_Tackle')
	coro1 = TASK:BranchCoroutine(function() GROUND:AnimateInDirection(hero, "Pain", Direction.Left, Direction.Right, 4, 1, 4) 
											GROUND:CharSetAction(hero, RogueEssence.Ground.PoseGroundAction(hero.Position, hero.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pain"))) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:AnimateInDirection(audino, "Hurt", Direction.Right, Direction.Left, 4, 1, 2) 
											GROUND:CharSetAnim(audino, "Hurt", true) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.EmoteAndPause(partner, 'Shock', false) end)
	local coro4 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue("Urf!", 60) end)
	--local coro5 = TASK:BranchCoroutine(function() GROUND:AnimateInDirection(partner, "Walk", Direction.Left, Direction.Right, 4, 1, 3) end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	
	--GROUND:CharTurnToChar(partner, audino)
	GROUND:CharSetAnim(audino, "None", true)
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Dizzy")
	UI:WaitShowDialogue("Why yes " .. CharacterEssentials.GetCharacterName("Snubbull") .. "...[pause=0] I'd love another Candied Oran...")
	GAME:WaitFrames(20)
	
	
	GeneralFunctions.ShakeHead(audino, 4, true)
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(audino, "Exclaim", true)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Goodness![pause=0] Are you alright?")
	GAME:WaitFrames(20)
	
	UI:WaitShowDialogue("Oh no,[pause=10] d-did I h-hurt you?")
	UI:SetSpeakerEmotion("Teary-Eyed")
	GeneralFunctions.EmoteAndPause(audino, "Sweating", true)
	UI:WaitShowDialogue("I'm s-so sorry![pause=0] I d-didn't m-mean to!")
	UI:WaitShowDialogue("It was an a-accident...[pause=0] I'm sorry...")
	GAME:WaitFrames(20)
	
	--GROUND:CharTurnToChar(partner, hero)
	GeneralFunctions.HeroDialogue(hero, "(Urgh...[pause=0] That bonk was enough to give me a second case of amnesia...)", "Dizzy")
	GAME:WaitFrames(20)
	
	--if you got hurt... I'd...
	GeneralFunctions.Shake(hero)
	GAME:WaitFrames(20)
	GROUND:CharWaitAnim(hero, "Wake")
	GROUND:CharSetAnim(hero, "None", true)
	GAME:WaitFrames(20)
	
	--GROUND:CharTurnToChar(partner, audino)
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, audino.CurrentForm.Species, audino.CurrentForm.Form, audino.CurrentForm.Skin, audino.CurrentForm.Gender)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Are you o-okay?[pause=0] I'm sorry,[pause=10] I didn't mean to b-barge into you like that...")
	GAME:WaitFrames(20)
	
	--GROUND:CharTurnToChar(partner, hero)
	GeneralFunctions.DoAnimation(hero, "Nod", false)
	GAME:WaitFrames(20)
	
	--GROUND:CharTurnToChar(partner, audino)
	SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true)
	UI:SetSpeakerEmotion("Sigh")
	UI:WaitShowDialogue("Oh thank goodness.[pause=0] I'm glad you're not hurt.")
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("I hate even the idea of hurting others....")
	UI:SetSpeakerEmotion("Teary-Eyed")
	GeneralFunctions.StartTremble(audino)
	UI:WaitShowDialogue("If I had h-hurt you...[pause=0] I'd...[pause=0] I'd...")
	GAME:WaitFrames(20)
	
	GROUND:CharSetEmote(audino, "glowing", 0)
	UI:SetSpeakerEmotion("Joyous")
	GeneralFunctions.StopTremble(audino)
	UI:WaitShowDialogue("But you're okay![pause=10] Hooray!")
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(audino, "", 0)
	
	GROUND:CharTurnToChar(partner, audino)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("What had you in such a hurry anyway?")
	GAME:WaitFrames(20)
	
	GROUND:CharTurnToChar(audino, partner)
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, audino.CurrentForm.Species, audino.CurrentForm.Form, audino.CurrentForm.Skin, audino.CurrentForm.Gender)
	UI:WaitShowDialogue("Oh,[pause=10] I'm just taking care of the chores around the guild.")
	UI:WaitShowDialogue("I have so much to do tonight that I have to run to get them all done before bedtime.")
	GAME:WaitFrames(20)
	
	GeneralFunctions.EmoteAndPause(audino, "Exclaim", true)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Hey...[pause=0] I just realized I've never seen either of you before...[pause=0] Who are you guys?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Right,[pause=10] we haven't introduced ourselves.")
	UI:WaitShowDialogue("I'm " .. partner:GetDisplayName() .. ",[pause=10] my partner you bumped into is " .. hero:GetDisplayName() .. ".[pause=0] We're a new adventuring team!")
	UI:WaitShowDialogue("We just joined the guild a little while ago.")
	GAME:WaitFrames(20)
	
	GROUND:EntTurn(audino, Direction.DownRight)
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, audino.CurrentForm.Species, audino.CurrentForm.Form, audino.CurrentForm.Skin, audino.CurrentForm.Gender)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("New guild members?[pause=0] That's more work to add to my chore list...")
	GAME:WaitFrames(20)
	
	GeneralFunctions.EmoteAndPause(audino, 'Exclaim', true)
	GROUND:CharAnimateTurnTo(audino, Direction.Right, 4)
	GROUND:CharSetEmote(audino, "sweating", 1)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("B-but don't worry about that![pause=0] It's no t-trouble at all!")
	UI:SetSpeakerEmotion("Normal")
	--UI:WaitShowDialogue("With the messes that " .. CharacterEssentials.GetCharacterName("Cranidos") .. " makes,[pause=10] you'd have to try to be give me more work than he does!")
	UI:WaitShowDialogue("It's not that m-much more work![pause=0] It's part of my job,[pause=10] so it's no problem!")
	GAME:WaitFrames(20)
	
	UI:WaitShowDialogue("I'm " .. audino:GetDisplayName() .. "![pause=0] I'm an apprentice here at the guild too!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Glad to meet you,[pause=10] " .. audino:GetDisplayName() .. "!")
	GAME:WaitFrames(20)
	
	--what were you doing here rin? oh i was in the guldmasters room tidying up, dont go in there though
	GROUND:CharTurnToChar(audino, partner)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("What were you up to in that room behind you anyway?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(audino)
	UI:WaitShowDialogue("That's the Guildmaster's quarters.[pause=0] I was tidying up in there for him.")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("The Guildmaster's quarters,[pause=10] huh?[pause=0] I figured that the room we spoke to him in was his quarters.")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(audino)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("You must have been in his office.[pause=0] His actual bedroom is right down this hall.[pause=0] But...")
	--too long with no nicknames
	UI:WaitShowDialogue("The Guildmaster doesn't like anyone going into his room.[pause=0] He only allows me to so I can take care of the chores.")
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("S-so please don't go in his room.[pause=0] I don't w-want to see you guys getting in trouble.")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Oh,[pause=10] alright.[pause=0] We'll stay away from that room then.")
	GAME:WaitFrames(20)
	
	
	UI:SetSpeaker(audino)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Thank you![pause=0] I'm glad I caught you before you wandered in there by accident.")
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("I-If you ever need help with anything,[pause=10] let me know,[pause=10] OK?")
	UI:WaitShowDialogue("I promise I won't r-ram into you again like earlier![pause=0]\nS-Sorry again!")
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("I have to get back to my chores before it gets any later.[pause=0] Stay safe!")
	GAME:WaitFrames(20)
	
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(40)
											GROUND:MoveToPosition(audino, 168, audino.Position.Y, false, 2)
											GROUND:MoveToPosition(audino, 168, -20, false, 2) 
											GROUND:Hide("Audino") end)
	coro2 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(partner, Direction.Right, 24, false, 1) 
											GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
											GAME:WaitFrames(26)
											GeneralFunctions.FaceMovingCharacter(partner, audino, 4, Direction.UpLeft) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:AnimateInDirection(hero, "Walk", Direction.Left, Direction.Right, 8, 1, 1)
											GAME:WaitFrames(42)
											GeneralFunctions.FaceMovingCharacter(hero, audino, 4, Direction.Up) end)

	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	SOUND:PlayBGM("Wigglytuff's Guild.ogg", true)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Well,[pause=10] that was something.[pause=0] I wonder how often she bumps into others like that...")
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("She seemed nice enough though.")
	GAME:WaitFrames(40)
	
	GROUND:CharAnimateTurnTo(partner, Direction.DownLeft, 4)
	GAME:WaitFrames(60)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("I bet there's really cool trinkets and treasures in the Guildmaster's room.")
	UI:WaitShowDialogue("Surely a world class adventurer would have found a lot of cool stuff!")
	GAME:WaitFrames(20)
	
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("We can't go in there though...[pause=0] I'd like to see some of his treasure some day though.")
	GAME:WaitFrames(20)
	
	GROUND:CharEndAnim(hero)
	GeneralFunctions.PanCamera(180, 148)
	GROUND:Unhide("Top_Exit")
	GAME:GetCurrentGround():RemoveTempChar(audino)
	SV.Chapter1.MetAudino = true

	--every guildmate is talked to, signal player that they can go sleep now
	if SV.Chapter1.MetSnubbull and SV.Chapter1.MetZigzagoon and SV.Chapter1.MetCranidosMareep and SV.Chapter1.MetBreloomGirafarig and SV.Chapter1.MetAudino then
		GAME:WaitFrames(60)
		GROUND:CharTurnToCharAnimated(partner, hero, 4)
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("Hey " .. hero:GetDisplayName() .. "...[pause=0] It's getting pretty late...")
		GROUND:CharTurnToCharAnimated(hero, partner, 4)
		GAME:WaitFrames(12)
		UI:WaitShowDialogue("We should head back to our room and hit the hay for the night.")
		UI:WaitShowDialogue("Let's head there whenever you're ready,[pause=10] " .. hero:GetDisplayName() .. ".")
	end


	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)

	GAME:CutsceneMode(false)
	
	
	
end