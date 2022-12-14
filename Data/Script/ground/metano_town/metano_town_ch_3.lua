require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_town_ch_3 = {}

function metano_town_ch_3.SetupGround()
	--objects/npcs that aren't for use in chapter 3 
	GROUND:Hide('Red_Merchant')
	GROUND:Hide('Green_Merchant')
	GROUND:Hide('Swap_Owner')
	GROUND:Hide('Swap')
	GROUND:Hide('Assembly')
	
	--trigger for partner pointing out cafe is open. only place if they havent done the cutscene for it yet
	if not SV.Chapter3.FinishedCafeCutscene then
		local cafeBlock = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1), 
															RogueElements.Rect(944, 584, 400, 160),
															RogueElements.Loc(0, 0), 
															true, 
															"Event_Trigger_1")
		
		cafeBlock:ReloadEvents()
		GAME:GetCurrentGround():AddTempObject(cafeBlock)
		--disable its collision so it doesn't displace other NPCs
		cafeBlock.Passable = true
	end
	
	
	
	local sentret, oddish, numel, camerupt, manectric, gloom, nidorina, mawile, furret, azumarill, nidoking, luxray,
		  linoone, electrike, wooper_girl, wooper_boy, audino, snubbull, meditite = 
		CharacterEssentials.MakeCharactersFromList({
			{'Sentret', 400, 424, Direction.DownRight},
			{'Oddish', 440, 424, Direction.DownLeft},
			{'Numel', 420, 456, Direction.Up},
			{'Camerupt', 'Town_Seat_1'},
			{'Manectric', 'Town_Seat_2'},
			{'Nidorina', 536, 208, Direction.UpLeft},
			{'Gloom', 512, 184, Direction.DownRight},
			{'Mawile', 1204, 1156, Direction.Down},
			{'Furret', 356, 764, Direction.Right},
			{'Azumarill', 888, 704, Direction.Down},
			{'Nidoking', 1160, 912, Direction.Left},
			{'Luxray', 624, 600, Direction.Down},
			{'Linoone', 'Cafe_Seat_2'},
			{'Electrike', 272, 1056, Direction.Right},
			{'Wooper_Girl', 306, 1036, Direction.DownLeft},
			{'Wooper_Boy', 306, 1076, Direction.UpLeft},
			{'Audino', 1264, 592, Direction.DownRight},
			{'Snubbull', 1040, 864, Direction.UpRight},
			{'Medicham', 888, 240, Direction.UpRight},			
			{'Meditite', 520, 384, Direction.DownLeft}			
			
		})
	
	
	GROUND:CharSetAnim(furret, 'Sleep', true)
	AI:SetCharacterAI(luxray, "ai.ground_default", RogueElements.Loc(608, 584), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
	AI:SetCharacterAI(mawile, "ai.ground_default", RogueElements.Loc(1188, 1140), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
	AI:SetCharacterAI(nidoking, "ai.ground_default", RogueElements.Loc(1144, 896), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
	AI:SetCharacterAI(audino, "ai.ground_default", RogueElements.Loc(1248, 576), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)

	
	
	
	
	
	
	
	--let the cutscene handle the fade in if it hasnt played yet		
	if SV.Chapter3.MetTeamStyle then 
		GAME:FadeIn(20)
	end
	
	--for debug purposes. makes it so the ground loads normally as long as i just set chapter to 3.
	if not SV.Chapter3.FinishedOutlawIntro then
		GAME:FadeIn(20)
	end

end


function metano_town_ch_3.Event_Trigger_1_Touch()
	metano_town_ch_3.CafeCutscene()
end


--partner points out that the cafe is open now
function metano_town_ch_3.CafeCutscene()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	
	--dummy is used to help coordinate character turning and camera movement. A bit of a hack tbh. It's crum because why not.
	local dummy = CharacterEssentials.MakeCharactersFromList({{'Tail'}})
	GROUND:TeleportTo(dummy, 1118, 576, Direction.Down)
	GROUND:Hide('Event_Trigger_1') --hide the trigger for the cutscene once it activates

	GeneralFunctions.StartPartnerConversation("Oh![pause=0] " .. hero:GetDisplayName() .. "![pause=0] Look!", "Normal", false)
	GAME:WaitFrames(20)
	local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, dummy, 4)
												  GROUND:CharTurnToCharAnimated(hero, dummy, 4) end)
	local coro2 = TASK:BranchCoroutine(function() GeneralFunctions.CenterCamera({dummy}, GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 3) end)
	
	TASK:JoinCoroutines({coro1, coro2})
	
	UI:WaitShowDialogue("Nobody's blocking the entrance anymore![pause=0] I bet that means the café is finally open!")
	GAME:WaitFrames(40)
	
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.CenterCamera({hero}, GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 3)
											GAME:MoveCamera(0, 0, 1, true) --return camera control
											end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, hero, 4)
											GROUND:CharTurnToCharAnimated(hero, partner, 4) end)

	TASK:JoinCoroutines({coro1, coro2})
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("They have all kinds of amazing treats and drinks,[pause=10] and there's all sorts of Pokémon to meet in there!")
	UI:WaitShowDialogue("I know we got a mission to do,[pause=10] but we should stop on in there before we head out!")
	UI:WaitShowDialogue("If you'd rather get on with the mission now,[pause=10] that's OK too![pause=0] But we should drop in there sometime soon!")
	
	SV.Chapter3.FinishedCafeCutscene = true
	GAME:GetCurrentGround():RemoveTempChar(dummy)
	GeneralFunctions.EndConversation(partner)
end


function metano_town_ch_3.MeetTeamStyle()	
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("crooked_cavern") 
	local luxio, glameow, cacnea = CharacterEssentials.MakeCharactersFromList({
		{"Luxio", 464, 1208, Direction.Right},
		{"Glameow", 432, 1224, Direction.Right},
		{"Cacnea", 432, 1192, Direction.Right}})
		
	GAME:MoveCamera(648, 1232, 1, false)
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	GROUND:TeleportTo(hero, 624, 1064, Direction.Down)
	GROUND:TeleportTo(partner, 656, 1064, Direction.Down)

	GAME:FadeIn(40)

	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 656, 1248, false, 1)
												  GROUND:CharAnimateTurnTo(partner, Direction.Left, 4) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:MoveToPosition(hero, 624, 1248, false, 1)
												  GROUND:CharAnimateTurnTo(hero, Direction.Right, 4) end)	

	TASK:JoinCoroutines({coro1, coro2})	

	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Well,[pause=10] " .. hero:GetDisplayName() .. ",[pause=10] I guess we have to go catch this " .. CharacterEssentials.GetCharacterName("Sandile") .. " guy.")
	UI:WaitShowDialogue("To be honest,[pause=10] I think " .. CharacterEssentials.GetCharacterName("Cranidos") .. " chose this mission because he thinks we can't do it...")
	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(partner, "Sweating", true)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("I would be lying if I said I wasn't scared...")
	UI:WaitShowDialogue("Especially with all those bandits hiding out in " .. zone:GetColoredName() .. "...")
	UI:WaitShowDialogue("It seems like it could go really badly...")
	GAME:WaitFrames(20)
	GeneralFunctions.DoubleHop(partner)
	UI:SetSpeakerEmotion("Inspired")
	GROUND:CharSetEmote(partner, "happy", 0)
	GROUND:CharSetAnim(partner, "Idle", true)
	UI:WaitShowDialogue("It'll be scary,[pause=10] but together I know we can do it!")
	UI:WaitShowDialogue("We're gonna catch this outlaw![pause=0] And we're gonna prove that bully " .. CharacterEssentials.GetCharacterName("Cranidos") .. " wrong!")
	GAME:WaitFrames(20)
	
	GeneralFunctions.DoAnimation(hero, "Nod")
	GeneralFunctions.DoAnimation(hero, "Nod")
	
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("Yeah yeah yeah![pause=0] That's the spirit!")	
	
	GAME:WaitFrames(20)
	GROUND:CharEndAnim(partner)
	GROUND:CharSetEmote(partner, "", 0)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowTimedDialogue("C'mon,[pause=10] " .. hero:GetDisplayName() .. "![pause=30] Let's head to the market to prepare for-", 40)
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	
	SOUND:FadeOutBGM(120)
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue("Well well well![pause=30] What do we have here?", 40) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(30) GeneralFunctions.EmoteAndPause(partner, "Exclaim", true) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(40) GeneralFunctions.EmoteAndPause(partner, "Notice", false) end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	GAME:WaitFrames(20)
	SOUND:PlayBGM('Team Skull.ogg', true)
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(luxio, 640, 1208, false, 1) 
											GROUND:CharAnimateTurnTo(luxio, Direction.Down, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:MoveToPosition(glameow, 592, 1224, false, 1) 
											GROUND:MoveToPosition(glameow, 616, 1200, false, 1) 
											GROUND:CharAnimateTurnTo(glameow, Direction.Down, 4) end)	
	coro3 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(cacnea, 656, 1192, false, 1) 
											GROUND:MoveToPosition(cacnea, 664, 1200, false, 1) 
											GROUND:CharAnimateTurnTo(cacnea, Direction.Down, 4) end)
	local coro4 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.UpLeft, 4) 
												  GAME:WaitFrames(120)
												  GeneralFunctions.FaceMovingCharacter(partner, luxio, 4, Direction.Up) end)
	local coro5 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(hero, Direction.UpLeft, 4) 
												  GAME:WaitFrames(120)
												  GeneralFunctions.FaceMovingCharacter(hero, luxio, 4, Direction.Up) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})

	GAME:WaitFrames(20)
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, glameow.CurrentForm.Species, glameow.CurrentForm.Form, glameow.CurrentForm.Skin, glameow.CurrentForm.Gender)
	UI:WaitShowDialogue("Looks to me like the newest guild losers,[pause=10] " .. luxio:GetDisplayName() .. ".")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(luxio)
	UI:WaitShowDialogue("Sure looks that way,[pause=10] " .. glameow:GetDisplayName() .. ".[pause=0] Seems like they only let chumps in these days.")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, cacnea.CurrentForm.Species, cacnea.CurrentForm.Form, cacnea.CurrentForm.Skin, cacnea.CurrentForm.Gender)
	UI:WaitShowDialogue("Huhuh,[pause=10] yeah boss.[pause=0] We got a couple of champs right here,[pause=10] huhuh.")
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(luxio, cacnea, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:CharTurnToCharAnimated(glameow, cacnea, 4) end)
	TASK:JoinCoroutines({coro1, coro2})
	
	UI:SetSpeaker(luxio)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue(cacnea:GetDisplayName() .. ',[pause=10] did you just call them "champs"?')
	
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(cacnea, luxio, 4)
	UI:SetSpeaker(cacnea)
	UI:WaitShowDialogue("Duh...[pause=0] Yeah,[pause=10] champs,[pause=10] just like you said,[pause=10] boss.")
	
	GAME:WaitFrames(10)
	GeneralFunctions.Complain(luxio, true)
	UI:SetSpeaker(luxio)
	UI:SetSpeakerEmotion("Angry")
	UI:WaitShowDialogue('Chumps,[pause=10] not champs,[pause=10] you moron!')	
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	GROUND:CharSetEmote(partner, "sweating", 1)
	UI:WaitShowDialogue("Um...[pause=0] Who are you guys exactly?")
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(luxio, "", 0)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(luxio, partner, 4) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(glameow, hero, 4) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(cacnea, partner, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	GAME:WaitFrames(10)
	UI:SetSpeaker(glameow)
	UI:WaitShowDialogue("Oh?[pause=0] You haven't heard of us?")
	UI:WaitShowDialogue("You really are a bunch of know-nothing nobodies.")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(luxio)
	UI:WaitShowDialogue("That's a real shame.[pause=0] Anybody who doesn't know about us must lead such sad lives.")
	
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(cacnea, luxio, 4)
	UI:SetSpeaker(cacnea)
	UI:WaitShowDialogue("Should we tell 'em who we are,[pause=10] boss?")	

	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(glameow, luxio, 4)
	UI:SetSpeaker(glameow)
	UI:SetSpeakerEmotion('Special1')
	UI:WaitShowDialogue("Oh,[pause=10] " .. cacnea:GetDisplayName() .. ",[pause=10] I don't know if we can let such lowly peons know something like that.")	
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(luxio)
	UI:WaitShowDialogue("No,[pause=10] no.[pause=0] I think we can grace them,[pause=10] this one time.")
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(glameow, Direction.Down, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:CharAnimateTurnTo(cacnea, Direction.Down, 4) end)
	coro3 = TASK:BranchCoroutine(function() UI:WaitShowDialogue("We're Team [color=#FFA5FF]Style[color]![pause=0] Everything we do,[pause=10] we do with style!") end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	GAME:WaitFrames(20)
	UI:SetSpeaker(glameow)
	UI:SetSpeakerEmotion("Special1")
	UI:WaitShowDialogue("We're an adventuring team with fame and fortune in our sights!")
	
	GAME:WaitFrames(10)
	coro1 = TASK:BranchCoroutine(function() SOUND:PlayBattleSE('EVT_Emote_Shock_2')
											GeneralFunctions.EmoteAndPause(partner, "Shock", false) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.EmoteAndPause(hero, "Exclaim", false) end)
	TASK:JoinCoroutines({coro1, coro2})
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("What!?[pause=10] You're all an adventuring team!?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(luxio)
	UI:WaitShowDialogue("That's right,[pause=10] loser.[pause=0] And soon everyone's gonna know the name Team [color=#FFA5FF]Style[color]!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("But adventuring isn't about money or being famous!")
	UI:WaitShowDialogue("It's about making discoveries and helping Pokémon in need![pause=0] Every adventurer knows that!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(glameow)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Yuck.[pause=0] You sound like that wash-up " .. CharacterEssentials.GetCharacterName("Tropius") .. ".[pause=0]\nHe's so self-righteous it disgusts me!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(luxio)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("That has-been told us the same thing when he turned us away.[pause=0] He simply couldn't see our greatness!")
	UI:WaitShowDialogue("That blind jerk wouldn't even notice if we stole the fruit off his neck!")

	GAME:WaitFrames(10)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Determined")
	GROUND:CharSetEmote(hero, "exclaim", 1)
	GeneralFunctions.Complain(partner)
	UI:WaitShowDialogue("How can you say such rude things about the Guildmaster!?[pause=0] It's no wonder he turned you all away!")
	
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(glameow)
	UI:WaitShowDialogue("Oh,[pause=10] we kept it cordial our entire time with him...")
	UI:WaitShowDialogue("Even still,[pause=10] he wouldn't allow us into that stupid guild of his.")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(luxio)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("And for some reason...[pause=0] That wash-up let you two in the guild.[pause=0] What's so special about you?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowTimedDialogue("Um...[pause=30] I don't really-", 40)
	
	GAME:WaitFrames(20)
	GROUND:MoveInDirection(luxio, Direction.Down, 8, false, 1)
	UI:SetSpeaker(luxio)
	UI:SetSpeakerEmotion("Angry")
	GeneralFunctions.Complain(luxio, true)
	UI:WaitShowDialogue("Well!?[pause=0] What makes you losers better than us,[pause=10] huh!?[pause=0] Huh!?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Shouting")
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue("I don't know!!![pause=30] OK!?[pause=30] I don't know!", 60) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) GeneralFunctions.EmoteAndPause(luxio, "Exclaim", true) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) GROUND:CharSetEmote(hero, "exclaim", 1) GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(25) GeneralFunctions.EmoteAndPause(glameow, "Notice", false) end)
	local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(30) GeneralFunctions.EmoteAndPause(cacnea, "Exclaim", false) end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	
	GAME:WaitFrames(20)
	GROUND:AnimateInDirection(luxio, "Walk", Direction.Down, Direction.Up, 8, 1, 1) 
	GAME:WaitFrames(20)
	
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("I don't know why he chose to let us apprentice at the guild...")

	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Determined")
	GeneralFunctions.DoubleHop(partner)
	UI:WaitShowDialogue("But it doesn't matter why " .. CharacterEssentials.GetCharacterName("Tropius") .. " took us in!")
	UI:WaitShowDialogue("All that matters is that me and " .. hero:GetDisplayName() .. " are in the guild and we're learning to become adventurers!")
	UI:WaitShowDialogue("It's not hard to see why he didn't want you guys in the guild!")
	
	SOUND:PlayBattleSE('EVT_Emote_Shock_2')
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(luxio, "Shock", false) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(glameow, "Shock", false) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GeneralFunctions.EmoteAndPause(cacnea, "Exclaim", false) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	UI:SetSpeaker(luxio)
	UI:SetSpeakerEmotion("Angry")
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end)
	coro2 = TASK:BranchCoroutine(function() UI:WaitShowDialogue("Tch![pause=0] Big talk for a newbie team![pause=0] What kind of adventures have you even gone on?")
											UI:WaitShowDialogue("Probably none![pause=0] I bet all you've done so far is scrub the floors!")	end)
	TASK:JoinCoroutines({coro1, coro2})

	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("That's not true![pause=0] We've already rescued someone who got lost in a mystery dungeon!")
	UI:WaitShowDialogue("And right now we're getting ready to capture our first outlaw!")
	
	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(luxio, "Exclaim", true)
	UI:SetSpeaker(luxio)
	--UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Oh?[pause=0] Is that so?")
	
	
	GAME:WaitFrames(30)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(luxio, Direction.Up, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) GROUND:CharAnimateTurnTo(glameow, Direction.Right, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(30) GROUND:CharAnimateTurnTo(cacnea, Direction.Left, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	GAME:WaitFrames(20)
	--UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Psst...[pause=0] Whisper whisper...")
	GAME:WaitFrames(10)
	
	SOUND:PlayBattleSE('EVT_Emote_Exclaim')
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(glameow, "Exclaim", false) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GeneralFunctions.EmoteAndPause(cacnea, "Notice", false) end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(glameow)
	UI:WaitShowDialogue("Psst...[pause=0] Murmur murmur...")	
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(cacnea)
	UI:WaitShowDialogue("Psst...[pause=0] Mumble mumble...")
	
	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(partner, "Question", true)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("What are they talking about?[pause=0] I can't make out what they're saying...")
	
	GAME:WaitFrames(30)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(luxio, Direction.Down, 4) GAME:WaitFrames(8) GROUND:MoveInDirection(luxio, Direction.Down, 8, false, 1) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GROUND:CharAnimateTurnTo(glameow, Direction.Down, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) GROUND:CharAnimateTurnTo(cacnea, Direction.Down, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})	
	
	UI:SetSpeaker(luxio)
	UI:WaitShowDialogue("If you're going after an outlaw,[pause=10] you may be real adventurers after all.")
	UI:WaitShowDialogue("Perhaps we got the wrong impression of you.[pause=0] You might just be a team worthy of our respect.")
	
	GAME:WaitFrames(12)
	GROUND:CharAnimateTurnTo(luxio, Direction.Up, 4)
	GROUND:CharAnimateTurnTo(glameow, Direction.DownRight, 4)
	GROUND:CharAnimateTurnTo(cacnea, Direction.DownLeft, 4)
	UI:WaitShowDialogue("Let's roll out of here, you two.[pause=0] We've got...[pause=30] adventuring work to attend to.")
	
	GAME:WaitFrames(20)
	
	--cacnea will later forget that this was just a temporary lie and think he's supposed to be nice to you still.
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(luxio, Direction.Right, 4) 
											GROUND:MoveInDirection(luxio, Direction.Right, 200, false, 1) 
											GAME:GetCurrentGround():RemoveTempChar(luxio) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:MoveInDirection(glameow, Direction.Down, 16, false, 1) 
											GROUND:CharTurnToChar(partner, glameow)
											GROUND:CharTurnToChar(hero, glameow)
											UI:SetSpeaker(glameow)
											UI:WaitShowTimedDialogue("We'll be keeping an eye on you,[pause=10] darlings.[pause=30] I hope you keep an eye out for us as well.", 60)
											GAME:WaitFrames(20)
											GROUND:CharAnimateTurnTo(glameow, Direction.Right, 4)
											GROUND:MoveInDirection(glameow, Direction.Right, 200, false, 1) 
											GAME:GetCurrentGround():RemoveTempChar(glameow) end)
	coro3 = TASK:BranchCoroutine(function()	GAME:WaitFrames(310)
											GROUND:MoveInDirection(cacnea, Direction.Down, 16, false, 1) 
											GROUND:CharTurnToChar(partner, cacnea)
											GROUND:CharTurnToChar(hero, cacnea)
											UI:SetSpeaker(cacnea)
											UI:SetSpeakerEmotion("Happy")
											UI:WaitShowTimedDialogue("Duh...[pause=30] If the boss say your team's alright,[pause=10] then you're alright with me too,[pause=10] huhuh.", 60)
											GAME:WaitFrames(20)
											GROUND:CharAnimateTurnTo(cacnea, Direction.Right, 4)
											GROUND:MoveInDirection(cacnea, Direction.Right, 100, false, 1) 
											SOUND:FadeOutBGM(120)
											GROUND:MoveInDirection(cacnea, Direction.Right, 100, false, 1) 
											GAME:GetCurrentGround():RemoveTempChar(cacnea) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(250) 
											GeneralFunctions.FaceMovingCharacter(partner, glameow, 4, Direction.UpRight) 
											GAME:WaitFrames(50)
											GROUND:CharTurnToCharAnimated(partner, cacnea, 4)
											GAME:WaitFrames(200)
											GeneralFunctions.FaceMovingCharacter(partner, cacnea, 4, Direction.UpRight)  end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(250) 
											GeneralFunctions.FaceMovingCharacter(hero, glameow, 4, Direction.UpRight) 
											GAME:WaitFrames(50)
											GeneralFunctions.FaceMovingCharacter(hero, cacnea, 4, Direction.UpRight)  end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	
	GAME:WaitFrames(20)
	
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Well,[pause=10] that was certainly strange...[pause=0] I wonder what their deal was?")
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("Between this Team [color=#FFA5FF]Style[color] and " .. CharacterEssentials.GetCharacterName("Cranidos") .. ",[pause=10] I've certainly had my fill of bullies for the day...")
	
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(We sure have been dealing with a lot of rude Pokémon today.[pause=0] All adventurers,[pause=10] too...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(Even if most of them seem to be nice,[pause=10] I guess not all adventurers are kind Pokémon.)", "Worried")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("That Team [color=#FFA5FF]Style[color] though...[pause=0] They sure had a change of attitude just now,[pause=10] don't you think?")
	UI:WaitShowDialogue("The way they started whispering to each other was pretty odd too...")
	
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(They were acting hostile the entire time until the end there...[pause=0] What could have caused the sudden change?)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(What exactly were they whispering about,[pause=10] anyway?)", "Worried")
	
	GAME:WaitFrames(20)
	SOUND:PlayBGM('Treasure Town.ogg', true)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("There isn't much point in dwelling on them though.[pause=0] Let's just hope their change in attitude sticks.")
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("For now,[pause=10] let's forget about them.[pause=0] We have a mission to get to after all!")
	UI:WaitShowDialogue("Let's head into town to get ready.")
	UI:WaitShowDialogue("Once we're set,[pause=10] we should leave town to the east towards " .. zone:GetColoredName() .. ",[pause=10] like " .. CharacterEssentials.GetCharacterName("Mareep") .. " said to.")
	
	GAME:WaitFrames(20)
	GeneralFunctions.PanCamera()
	SV.Chapter3.MetTeamStyle = true
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)
	GAME:CutsceneMode(false)

	
end 


function metano_town_ch_3.Wooper_Conversation(chara)
	local dee = CH('Wooper_Girl')
	local dun = CH('Wooper_Boy')
	local electrike = CH('Electrike')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	
	partner.IsInteracting = true
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharSetAnim(dee, 'None', true)
	GROUND:CharSetAnim(electrike, 'None', true)
	GROUND:CharSetAnim(dun, 'None', true)
	
	GROUND:CharTurnToChar(hero, chara)
	GROUND:CharTurnToChar(partner, chara)

	UI:SetSpeaker(electrike)
	UI:WaitShowDialogue("Did you two hear that " .. CharacterEssentials.GetCharacterName("Numel") .. " ran off to a spring and had to get rescued by some adventurers?")
	
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(dee, "Question", true)
	UI:SetSpeaker(dee)
	UI:WaitShowDialogue("Huh?[pause=0] How do you run off to spring?[pause=0] I thought that's the time of year after winter?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(dun)
	GROUND:CharTurnToChar(dun, dee)
	UI:WaitShowDialogue("Nuh uh![pause=0] A spring is something you bounce off of!")
	UI:WaitShowDialogue("I bet he ran off to some place with a ton of bouncy things!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(electrike)
	UI:WaitShowDialogue("No,[pause=10] he ran off to a water spring.[pause=0] You know,[pause=10] a place where water comes up from the ground?")
	--UI:WaitShowDialogue("I think my mom said the spring is where the water in the river in town comes from.")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(dee)
	GROUND:CharTurnToChar(dun, electrike)
	UI:WaitShowDialogue("That can't be right![pause=0] Why would that be called a spring?[pause=0] It has nothing to do with the time after winter!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(dun)
	UI:WaitShowDialogue("Yeah![pause=0] And it's got nothing to do with bouncy things either!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(electrike)
	GeneralFunctions.EmoteAndPause(electrike, "Sweatdrop", true)
	UI:WaitShowDialogue("Groan...")
	
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)	
	GROUND:CharEndAnim(electrike)
	GROUND:CharEndAnim(dun)
	GROUND:CharEndAnim(dee)
	
	partner.IsInteracting = false
end

function metano_town_ch_3.Electrike_Action(chara, activator)
	metano_town_ch_3.Wooper_Conversation(chara)
end

function metano_town_ch_3.Wooper_Boy_Action(chara, activator)
	metano_town_ch_3.Wooper_Conversation(chara)
end

function metano_town_ch_3.Wooper_Girl_Action(chara, activator)
	metano_town_ch_3.Wooper_Conversation(chara)
end


function metano_town_ch_3.Sentret_Action(chara, activator) 
	GeneralFunctions.StartConversation(chara, "I'm glad you're back " .. CharacterEssentials.GetCharacterName("Numel") .. "![pause=0] Now we can all play together again!", "Happy", false)
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_3.Oddish_Action(chara, activator) 
	GeneralFunctions.StartConversation(chara, "Hooray![pause=0] Playing will be more fun now that " .. CharacterEssentials.GetCharacterName("Numel") .. " is back!", "Happy", false)
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_3.Numel_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Let's all play tag![pause=0] I can start as " .. '"it"!', "Happy", false)
	GeneralFunctions.EndConversation(chara)
end


function metano_town_ch_3.Mawile_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Word around the town is that you two managed to save the missing kid![pause=0] That's wonderful!", "Happy")
	UI:WaitShowDialogue("I just knew you two were gonna do great in the guild!")
	GeneralFunctions.EndConversation(chara)
end 
function metano_town_ch_3.Nidorina_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Can you believe my parents kept me inside while that brat was missing?", "Determined", false)
	UI:WaitShowDialogue("Obviously the dumb kid had just ran off![pause=0] This town is so boring,[pause=10] there's nothing dangerous anywhere near here!")
	GeneralFunctions.EndConversation(chara)
end 

function metano_town_ch_3.Gloom_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Maybe your parents were just worried...[pause=0] My dad worries a lot.", "Worried", false)
	UI:WaitShowDialogue("He says the world's becoming more dangerous,[pause=10] with all the mystery dungeons appearing lately.")
	GeneralFunctions.EndConversation(chara)
end


function metano_town_ch_3.Azumarill_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, chara:GetDisplayName() .. " knows where child is now![pause=0] That makes " .. chara:GetDisplayName() .. " happy!", "Happy")
	UI:WaitShowDialogue("The water looks happy too![pause=0] It must know child is home now,[pause=10] just like " .. chara:GetDisplayName() .. "!")
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_3.Manectric_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "So you were the ones who rescued " .. CharacterEssentials.GetCharacterName("Camerupt") .. "'s little boy?")
	UI:WaitShowDialogue("How amazing![pause=0] I can have peace of mind knowing that adventurers like you live in town!")
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_3.Camerupt_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "I still cannot thank you too enough for saving my baby boy!", "Happy")
	UI:WaitShowDialogue(CharacterEssentials.GetCharacterName("Numel") .. " and I will always be grateful for what you've done for us!")
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_3.Furret_Action(chara, activator)
	GeneralFunctions.StartConversation(chara , "Ah,[pause=10] I can relax again now that " .. CharacterEssentials.GetCharacterName("Numel") .. " is back safe and sound!", "Happy", false, false)
	GeneralFunctions.EndConversation(chara, false)
end

function metano_town_ch_3.Linoone_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Now that things are back to normal,[pause=10] I can focus on getting through this book " .. CharacterEssentials.GetCharacterName("Medicham") .. " recommended to me.")
	UI:WaitShowDialogue("I can enjoy a refreshing drink with it too,[pause=10] now that the café is open again.")
	GeneralFunctions.EndConversation(chara)
end


function metano_town_ch_3.Luxray_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Hmmph.[pause=0] " .. CharacterEssentials.GetCharacterName("Camerupt") .. "'s son runs away,[pause=10] and now that he's been returned to her she gives him no punishment?")
	UI:WaitShowDialogue("The way she parents her child is appalling.[pause=0] With no discipline,[pause=10] that child will grow up to be a troublemaker.")
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_3.Nidoking_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "It's wonderful that " .. CharacterEssentials.GetCharacterName('Camerupt') .. "'s young'un was rescued safe an' sound.")
	UI:WaitShowDialogue("The adventurers at that there guild sure do some right proper work!")
	GeneralFunctions.EndConversation(chara)
end 

function metano_town_ch_3.Medicham_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Clear my mind is and again meditate can I with thanks to rescue of " .. CharacterEssentials.GetCharacterName("Numel") .. ".")
	GeneralFunctions.EndConversation(chara)

end

function metano_town_ch_3.Meditite_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Wish play coul' I wit' the other kids...")
	UI:WaitShowDialogue("It's hard fa' me friends to make...[pause=0] The other kids trouble have talkin' wit' me...")
	UI:WaitShowDialogue("I don' get it...[pause=0] What am I sayin' hard that's ta' understand?")
	GeneralFunctions.EndConversation(chara)

end


function metano_town_ch_3.Growlithe_Desk_Action(chara, activator)
	local growlithe = CH('Growlithe')
	GeneralFunctions.StartConversation(growlithe, "I heard you two rescued " .. CharacterEssentials.GetCharacterName("Numel") .. ",[pause=10] ruff!", "Happy")
	UI:WaitShowDialogue("That's amazing![pause=0] I knew you could do it,[pause=10] ruff!")
	GeneralFunctions.EndConversation(growlithe)
end

function metano_town_ch_3.Audino_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Oh,[pause=10] are you t-two headed out for the day?")
	UI:WaitShowDialogue("Make sure you leave town to the east,[pause=10] r-right over there!")
	UI:WaitShowDialogue("That's where you should go whenever you want to go out on an adventure!")
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_3.Snubbull_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Oh,[pause=10] the Kecleon Shop is out of Apricorns...", "Worried")
	UI:WaitShowDialogue("Apparently there's been a shortage of Apricorns lately.")
	UI:WaitShowDialogue("Without Apricorns,[pause=10] recruiting new team members is impossible!")
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("More importantly,[pause=10] I can't make this special dish I've been working on without Apricorns![pause=0] Now what will I cook?")
	GeneralFunctions.EndConversation(chara)
end

