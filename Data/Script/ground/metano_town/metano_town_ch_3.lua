require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_town_ch_3 = {}

function metano_town_ch_3.SetupGround()
	if SV.Chapter3.DefeatedBoss then
		--hide NPCs not in use for chapter 3 part 2	
		GROUND:Hide('Swap_Owner')
		GROUND:Hide('Swap')
		GROUND:Hide('Assembly')
		
		local wooper_boy, wooper_girl, numel, nidoqueen, quagsire, zigzagoon, furret, sentret, 
			  snubbull, mareep, cranidos, mawile, azumarill, electrike, meditite, machamp, medicham, linoone, manectric,
			  bellossom, floatzel, gloom, oddish = 
			CharacterEssentials.MakeCharactersFromList({
				{'Wooper_Boy', 400, 880, Direction.Left},
				{'Wooper_Girl', 352, 952, Direction.DownRight},
				{'Numel', 192, 536, Direction.Left},
				{'Nidoqueen', 'Town_Seat_1'},
				{'Quagsire', 'Town_Seat_2'},
				{'Zigzagoon', 1232, 360, Direction.Up},
				{'Furret', 356, 764, Direction.Right},
				{'Sentret', 388, 716, Direction.Right},
				{'Snubbull', 1040, 864, Direction.UpRight},
				{'Mareep', 1120, 906, Direction.Right},
				{'Cranidos', 1160, 906, Direction.Left},
				{'Mawile', 1040, 1208, Direction.DownRight},
				{'Azumarill', 876, 1168, Direction.Up},
				{'Electrike', 400, 400, Direction.Right},
				{'Meditite', 440, 400, Direction.Left},
				{'Machamp', 760, 600, Direction.Down},
				{'Medicham', 536, 192, Direction.Down},
				{'Linoone', 891, 260, Direction.UpRight},
				{'Manectric', 1204, 1144, Direction.DownRight},
				{'Bellossom', 472, 608, Direction.UpLeft},
				{'Floatzel', 368, 1096, Direction.Up},	
				{'Gloom', 'Cafe_Seat_4'},	
				{'Oddish', 'Cafe_Seat_3'}	
			})

		GROUND:CharSetAnim(furret, 'Sleep', true)
		GROUND:CharSetAnim(sentret, 'Sleep', true)
		
		AI:SetCharacterAI(wooper_girl, "ai.ground_default", RogueElements.Loc(336, 936), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
		AI:SetCharacterAI(zigzagoon, "ai.ground_default", RogueElements.Loc(1216, 344), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
		AI:SetCharacterAI(mawile, "ai.ground_default", RogueElements.Loc(1024, 1192), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
		AI:SetCharacterAI(machamp, "ai.ground_default", RogueElements.Loc(744, 584), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
		AI:SetCharacterAI(manectric, "ai.ground_default", RogueElements.Loc(1176, 1112), RogueElements.Loc(64, 64), 1, 16, 32, 40, 180)

		
		--let the cutscene handle the fade in if it hasnt played yet		
		if SV.Chapter3.FinishedMerchantIntro then 
			GAME:FadeIn(20)
		end 
	else 
	
		--objects/npcs that aren't for use in chapter 3 part 1
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
			  linoone, electrike, wooper_girl, wooper_boy, audino, snubbull, meditite  = 
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
	
	--emitter for sparkle effect on pose
	--each frame will last 3 frames
	local emitter = RogueEssence.Content.SingleEmitter(RogueEssence.Content.AnimData("Moonlight_Sparkles_2", 3))
	emitter.LocHeight = 14
	
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(glameow, Direction.Down, 4)
											SOUND:PlayBattleSE("_UNK_EVT_046")
											GROUND:PlayVFX(emitter, glameow.Position.X, glameow.Position.Y)
											GROUND:CharSetAction(glameow, RogueEssence.Ground.PoseGroundAction(glameow.Position, glameow.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose"))) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(cacnea, Direction.Down, 3)
											GROUND:CharAnimateTurnTo(cacnea, Direction.UpRight, 3)
											GROUND:CharAnimateTurnTo(cacnea, Direction.UpLeft, 3)
											GROUND:CharAnimateTurnTo(cacnea, Direction.Down, 3)
											GeneralFunctions.Hop(cacnea)
											SOUND:PlayBattleSE("_UNK_EVT_014")
											GROUND:CharSetEmote(cacnea, "shock", 1) 
											GROUND:AnimateInDirection(cacnea, "Hurt", Direction.Down, Direction.Down, 4, 1, 2)
											GROUND:CharSetAction(cacnea, RogueEssence.Ground.PoseGroundAction(cacnea.Position, cacnea.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Hurt")))
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:PlayVFX(emitter, luxio.Position.X, luxio.Position.Y)
											GROUND:CharSetAction(luxio, RogueEssence.Ground.PoseGroundAction(luxio.Position, luxio.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))  end)
	coro4 = TASK:BranchCoroutine(function() UI:WaitShowDialogue("We're Team [color=#FFA5FF]Style[color]![pause=0] Everything we do,[pause=10] we do with style!") end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

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
	GROUND:CharEndAnim(luxio)
	GROUND:CharEndAnim(glameow)
	GROUND:CharEndAnim(cacnea)
	--put cacnea back where he was before he slid on his face like an idiot
	GROUND:TeleportTo(cacnea, 664, 1200, Direction.Down)
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
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(luxio, Direction.Down, 4) GAME:WaitFrames(20) GROUND:MoveInDirection(luxio, Direction.Down, 8, false, 1) end)
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
	UI:WaitShowDialogue("There isn't much point in dwelling on them,[pause=10] though.[pause=0] Let's just hope their change in attitude sticks.")
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



function metano_town_ch_3.MerchantIntro()
	--Player and partner walk from bridge to guild, merchants notice them
	--they both start trying to get their attention and to get their business
	--they start arguing with each other that the other blows
	--partner asks what's going on here
	--merchants explain they sell different kinds of items, while dogging the other merchants
	
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local stunky = CH('Red_Merchant')
	local farfetchd = CH('Green_Merchant')
	
		
	GAME:MoveCamera(648, 1264, 1, false)
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	GROUND:TeleportTo(hero, 624, 1096, Direction.Down)
	GROUND:TeleportTo(partner, 656, 1096, Direction.Down)

	--they are arguing 
	GROUND:EntTurn(stunky, Direction.Left)
	GROUND:EntTurn(farfetchd, Direction.Right)
	GROUND:CharSetEmote(stunky, "angry", 0)
	GROUND:CharSetEmote(farfetchd, "angry", 0)
	GROUND:CharSetAnim(stunky, "Idle", true)
	GROUND:CharSetAnim(farfetchd, "Idle", true)

	GAME:FadeIn(40)

	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 656, 1232, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:MoveToPosition(hero, 624, 1232, false, 1) end)	
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(90)
												  GROUND:CharEndAnim(farfetchd)
												  GeneralFunctions.EmoteAndPause(farfetchd, "Exclaim", true)
												  GROUND:CharTurnToCharAnimated(farfetchd, partner, 4) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(110)
												  GROUND:CharEndAnim(stunky)
												  GeneralFunctions.EmoteAndPause(stunky, "Notice", false)
												  GROUND:CharTurnToCharAnimated(stunky, partner, 4) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})	

	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, farfetchd.CurrentForm.Species, farfetchd.CurrentForm.Form, farfetchd.CurrentForm.Skin, farfetchd.CurrentForm.Gender)
	GeneralFunctions.DuoTurnTowardsCharWithDialogue(farfetchd, "Ah,[pause=10] adventurers![pause=0] Come to peruse my fine selection of merchandise,[pause=10] yes?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, stunky.CurrentForm.Species, stunky.CurrentForm.Form, stunky.CurrentForm.Skin, stunky.CurrentForm.Gender)
	GeneralFunctions.DuoTurnTowardsCharWithDialogue(stunky, "Are you crazy?[pause=0] Nobody wants your fancy,[pause=10] overpriced junk![pause=0] They're here for my great deals.")
	
	GROUND:CharTurnToCharAnimated(farfetchd, stunky, 4)
	GAME:WaitFrames(20)
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, farfetchd.CurrentForm.Species, farfetchd.CurrentForm.Form, farfetchd.CurrentForm.Skin, farfetchd.CurrentForm.Gender)
	UI:SetSpeakerEmotion("Angry")
	GeneralFunctions.Complain(farfetchd, true)
	GeneralFunctions.DuoTurnTowardsCharWithDialogue(farfetchd, "There isn't a single denizen of this fine town who would purchase your cheap rubbish!")
	UI:WaitShowDialogue("Where do you even source that garbage?[pause=0] From the Kecleon Shop's trash pile?")
	
	GROUND:CharTurnToCharAnimated(stunky, farfetchd, 4)
	GAME:WaitFrames(20)
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, stunky.CurrentForm.Species, stunky.CurrentForm.Form, stunky.CurrentForm.Skin, stunky.CurrentForm.Gender)
	UI:SetSpeakerEmotion("Angry")
	GeneralFunctions.Complain(stunky, true)
	GeneralFunctions.DuoTurnTowardsCharWithDialogue(stunky, "Keep on lying to everyone![pause=0] You and I both know my merch is top-shelf stuff!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Umm...[pause=0] What's going on here,[pause=10] exactly?")
	GAME:WaitFrames(20)
	
	
	GROUND:CharSetEmote(farfetchd, "", 0)
	GROUND:CharSetEmote(stunky, "", 0)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(farfetchd, partner, 4) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(stunky, partner, 4) end)
	TASK:JoinCoroutines({coro1, coro2})
	
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, farfetchd.CurrentForm.Species, farfetchd.CurrentForm.Form, farfetchd.CurrentForm.Skin, farfetchd.CurrentForm.Gender)
	UI:SetSpeakerEmotion("Happy")
	GeneralFunctions.DuoTurnTowardsCharWithDialogue(farfetchd, "Ah,[pause=10] forgive me,[pause=10] my friends![pause=0] I had forgotten my manners there!")
	UI:WaitShowDialogue("My name is " .. farfetchd:GetDisplayName() .. ",[pause=10] and I am purveyor of held items,[pause=10] perfect for adventurers such as yourselves!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, stunky.CurrentForm.Species, stunky.CurrentForm.Form, stunky.CurrentForm.Skin, stunky.CurrentForm.Gender)
	GeneralFunctions.DuoTurnTowardsCharWithDialogue(stunky, "I'm " .. stunky:GetDisplayName() .. ",[pause=10] and unlike that snob,[pause=10] I sell items that are actually useful.[pause=0] For cheap,[pause=10] too!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("Oh,[pause=10] that's right![pause=0] You're both merchants,[pause=10] correct?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(farfetchd)
	GeneralFunctions.DuoTurnTowardsCharWithDialogue(farfetchd, "Well observed,[pause=10] my friend![pause=0] I can see you're as sharp as my leek!")
	UI:WaitShowDialogue("With intuition like that,[pause=10] you must be wise enough to shop with me,[pause=10] rather than with that charlatan " .. stunky:GetDisplayName() .. "!")
	GAME:WaitFrames(20)
	
	GROUND:CharTurnToCharAnimated(stunky, farfetchd, 4)
	UI:SetSpeaker(stunky)
	GROUND:CharSetEmote(stunky, "angry", 0)
	UI:SetSpeakerEmotion("Determined")
	GeneralFunctions.DuoTurnTowardsCharWithDialogue(stunky, "I think you mean " .. GeneralFunctions.GetPronoun(partner, "they're") .. " smart enough to spend " .. GeneralFunctions.GetPronoun(partner, "their") .. " money wisely with my low prices.")
	GAME:WaitFrames(20)
	
	
	GROUND:CharTurnToCharAnimated(farfetchd, stunky, 4)
	UI:SetSpeaker(farfetchd)
	GROUND:CharSetEmote(farfetchd, "angry", 0)
	UI:SetSpeakerEmotion("Determined")
	GeneralFunctions.DuoTurnTowardsCharWithDialogue(farfetchd, "Whyever would I mean that?[pause=0] I said " .. GeneralFunctions.GetPronoun(partner, "they're") .. " wise,[pause=10] not foolish!")
	GAME:WaitFrames(40)
	
	
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(partner, "Sweatdrop", true) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(hero, "Sweatdrop", false) end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)

	local zigzagoon = CharacterEssentials.MakeCharactersFromList({
									{"Zigzagoon", 640, 1096, Direction.Down}
									})
	
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue("They're really going at it...", 60) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(zigzagoon, 640, 1208, false, 1) end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(zigzagoon)
	UI:WaitShowDialogue(farfetchd:GetDisplayName() .. " and " .. stunky:GetDisplayName() .. " are arguing with each other again,[pause=10] huh?")
	GAME:WaitFrames(10)
	
	GeneralFunctions.DuoTurnTowardsChar(zigzagoon)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Yup.[pause=0] I've seen them there bickering before,[pause=10] but I've never experienced it first-hand like this.")
		
	GAME:WaitFrames(20)
	UI:SetSpeaker(zigzagoon)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Yeah,[pause=10] they do this often.[pause=0] They really dislike each other for some reason.")
	UI:WaitShowDialogue("They won't even sell stuff to you if you bought something from the other one!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Wow,[pause=10] really!?[pause=0] They're that spiteful?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(zigzagoon)
	UI:WaitShowDialogue("Yeah.[pause=0] Fortunately,[pause=10] their memory isn't so good,[pause=10] so they'll forget their grudge against you after a day or so.")
	GROUND:CharSetEmote(zigzagoon, "glowing", 0)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("My memory isn't so good either,[pause=10] that's why I write stuff down in my almanacs!")
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(zigzagoon, "", 0)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("I've got to be on my way now,[pause=10] good luck buying something from those two!")
	GAME:WaitFrames(10)
	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(zigzagoon, Direction.Right, 4)
											GROUND:MoveToPosition(zigzagoon, 820, 1208, false, 1) end) 
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.FaceMovingCharacter(partner, zigzagoon, 4, Direction.UpRight) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.FaceMovingCharacter(hero, zigzagoon, 4, Direction.Right)
											GROUND:CharAnimateTurnTo(partner, Direction.Right, 4) end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3})
	GAME:WaitFrames(10)
	GAME:GetCurrentGround():RemoveTempChar(zigzagoon)

	
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Guess we should see if we can get a word in against those two,[pause=10] huh?")
	GAME:WaitFrames(20)
	
	GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
	GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
	UI:WaitShowDialogue("Erm...[pause=0] So you two sell items that are useful for adventurers,[pause=10] right?")
	GAME:WaitFrames(20)
	
	
	
	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharSetEmote(farfetchd, "", 0)
											GROUND:CharTurnToCharAnimated(farfetchd, partner, 4) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharSetEmote(stunky, "", 0)
											GROUND:CharTurnToCharAnimated(stunky, partner, 4) end)
	
	TASK:JoinCoroutines({coro1, coro2})

	
	UI:SetSpeaker(farfetchd)
	GeneralFunctions.DuoTurnTowardsCharWithDialogue(farfetchd, "That's correct.[pause=0] I have a rare held item for purchase each day.")
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("But if you buy from that charlatan over there,[pause=10] you won't get any more business out of me!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(stunky)
	GeneralFunctions.DuoTurnTowardsCharWithDialogue(stunky, "I sell all sorts of different items,[pause=10] and I only have one item per day as well.")
	UI:WaitShowDialogue("I'll give you a great deal though.[pause=0] Much cheaper than the Kecleon Shop would charge.")
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("But forget about getting any of my bargains if you buy from that snob!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	--UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("I see...[pause=0] Well,[pause=10] thanks for the info.")
	
	GAME:WaitFrames(10)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Psst,[pause=10] " .. hero:GetDisplayName() .. "...[pause=0] We should check in with these two daily to see what they have for sale.")
	UI:WaitShowDialogue("We can only buy from one of them each day,[pause=10] so we'll have to choose carefully.")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(farfetchd)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, farfetchd, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharTurnToCharAnimated(hero, farfetchd, 4) end)
	coro3 = TASK:BranchCoroutine(function() UI:WaitShowDialogue("Well,[pause=10] I know you two will make the correct choice![pause=0] As such,[pause=10] I look forward to serving you in the future!") end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3})
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(stunky)
	GeneralFunctions.DuoTurnTowardsCharWithDialogue(stunky, "They'll make the right choice,[pause=10] alright.[pause=0] That's why they'll be buying from me and not you!")
	
	GAME:WaitFrames(40)
	GeneralFunctions.PanCamera()
	SV.Chapter3.FinishedMerchantIntro = true
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

function metano_town_ch_3.Meditite_Electrike_Conversation(chara)
	local meditite = CH('Meditite')
	local electrike = CH('Electrike')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	
	partner.IsInteracting = true
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharSetAnim(meditite, 'None', true)
	GROUND:CharSetAnim(electrike, 'None', true)
	
	GROUND:CharTurnToChar(hero, chara)
	GROUND:CharTurnToChar(partner, chara)

	UI:SetSpeaker(electrike)
	UI:WaitShowDialogue("Hey,[pause=10] " .. meditite:GetDisplayName() .. ",[pause=10] let's play![pause=0] Wanna play adventurers and outlaws?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(meditite)
	--Yeah, I've never played that before, how do you play?
	UI:WaitShowDialogue("Oh![pause=0] Befor' I've never played that,[pause=10] play how do ya?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(electrike)
	GeneralFunctions.EmoteAndPause(electrike, "Question", true)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Um...[pause=0] What did you say?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(meditite)
	--I said I've never played that before, how do we play it?
	UI:WaitShowDialogue("Adventurers an' outlaws befor' never played I,[pause=10] do play how we?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(electrike)
	GeneralFunctions.EmoteAndPause(electrike, "Sweatdrop", true)
	UI:SetSpeakerEmotion("Stunned")
	UI:WaitShowDialogue("Err...[pause=0] Right...")
	UI:WaitShowDialogue("(I can't really understand her...[pause=0] I guess the twins aren't so bad after all...)")
	
	
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)	
	GROUND:CharEndAnim(electrike)
	GROUND:CharEndAnim(meditite)
	
	partner.IsInteracting = false
end

function metano_town_ch_3.Quagsire_Nidoqueen_Conversation(chara)
	local nidoqueen = CH('Nidoqueen')
	local quagsire = CH('Quagsire')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	
	partner.IsInteracting = true
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharSetAnim(nidoqueen, 'None', true)
	GROUND:CharSetAnim(quagsire, 'None', true)
	
	GROUND:CharTurnToChar(hero, chara)
	GROUND:CharTurnToChar(partner, chara)

	UI:SetSpeaker(quagsire)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("All this talk about outlaw activity lately has me concerned...[pause=0] What if one comes to town?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(nidoqueen)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("It's got me worried too hun.")
	UI:WaitShowDialogue("It'd tear me up somethin' awful to see anything happen to any of my young'uns or the folks in town...")
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("But I don't think we got any worryin' to do.[pause=0] We have the fine adventurers in the guild nearby after all!")
	UI:WaitShowDialogue("If any outlaws are foolish enough to come to town,[pause=10] them adventurers will send them packin'!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(quagsire)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Well,[pause=10] I suppose that's true.[pause=0] Still,[pause=10] as a mother,[pause=10] it's hard for me not to worry...")
	
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)	
	GROUND:CharEndAnim(nidoqueen)
	GROUND:CharEndAnim(quagsire)
	
	partner.IsInteracting = false
end

function metano_town_ch_3.Oddish_Gloom_Conversation(chara)
	local gloom = CH('Gloom')
	local oddish = CH('Oddish')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	
	partner.IsInteracting = true
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharSetAnim(gloom, 'None', true)
	GROUND:CharSetAnim(oddish, 'None', true)
	
	GROUND:CharTurnToChar(hero, chara)
	GROUND:CharTurnToChar(partner, chara)
	
	UI:SetSpeaker(gloom)
	UI:WaitShowDialogue("Do you like your drink,[pause=10] " .. oddish:GetDisplayName() .. "?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(oddish)
	UI:SetSpeakerEmotion("Joyous")
	UI:WaitShowDialogue("Yeah![pause=0] This drink is so yummy!")
	UI:WaitShowDialogue("Thanks for taking me to the café,[pause=10] " .. gloom:GetDisplayName() .. "!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(gloom)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Of course![pause=0] What's a big sister for,[pause=10] after all?[pause=0]\nI'm just happy you're enjoying your drink!")

	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)	
	GROUND:CharEndAnim(oddish)
	GROUND:CharEndAnim(gloom)
	
	partner.IsInteracting = false
end

function metano_town_ch_3.Quagsire_Action(chara, activator)
	metano_town_ch_3.Quagsire_Nidoqueen_Conversation(chara)
end

function metano_town_ch_3.Nidoqueen_Action(chara, activator)
	metano_town_ch_3.Quagsire_Nidoqueen_Conversation(chara)
end


function metano_town_ch_3.Electrike_Action(chara, activator)
	if not SV.Chapter3.DefeatedBoss then
		metano_town_ch_3.Wooper_Conversation(chara)
	else
		metano_town_ch_3.Meditite_Electrike_Conversation(chara)
	end
end

function metano_town_ch_3.Wooper_Boy_Action(chara, activator)
	if not SV.Chapter3.DefeatedBoss then
		metano_town_ch_3.Wooper_Conversation(chara)
	else
		GeneralFunctions.StartConversation(chara, CharacterEssentials.GetCharacterName("Wooper_Girl") .. " is never gonna find me here![pause=0] This hiding spot is the best!", "Happy")
		GeneralFunctions.EndConversation(chara)
	end
end

function metano_town_ch_3.Wooper_Girl_Action(chara, activator)
	if not SV.Chapter3.DefeatedBoss then
		metano_town_ch_3.Wooper_Conversation(chara)
	else
		GeneralFunctions.StartConversation(chara, "Me and " .. CharacterEssentials.GetCharacterName("Wooper_Boy") .. " are playing hide and seek!")
		UI:WaitShowDialogue("I've been looking for him,[pause=10] but I can't find him![pause=0] Where did he go?")
		GeneralFunctions.EndConversation(chara)
	end
end

function metano_town_ch_3.Floatzel_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "I've been hiding behind this bush for hours now and the twins still haven't found me!", "Happy")
	UI:SetSpeakerEmotion("Joyous")
	UI:WaitShowDialogue("Hahaha![pause=0] This spot is so good![pause=0] It's almost like they're not looking for me!")
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_3.Bellossom_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "It's a lovely day as always![pause=0] My flower garden is looking lovely today too!", "Happy")
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_3.Sentret_Action(chara, activator) 
	if not SV.Chapter3.DefeatedBoss then 
		GeneralFunctions.StartConversation(chara, "I'm glad you're back " .. CharacterEssentials.GetCharacterName("Numel") .. "![pause=0] Now we can all play together again!", "Happy", false)
		GeneralFunctions.EndConversation(chara)
	else 
		GeneralFunctions.StartConversation(chara, "I see why Dad always likes to snooze out here by the river now...[pause=0] This is nice...", "Happy",false, false)
		GeneralFunctions.EndConversation(chara, false)
	end 
end


function metano_town_ch_3.Oddish_Action(chara, activator) 
	if not SV.Chapter3.DefeatedBoss then 
		GeneralFunctions.StartConversation(chara, "Hooray![pause=0] Playing will be more fun now that " .. CharacterEssentials.GetCharacterName("Numel") .. " is back!", "Happy", false)
		GeneralFunctions.EndConversation(chara)
	else 
		metano_town_ch_3.Oddish_Gloom_Conversation(chara)
	end
end

function metano_town_ch_3.Numel_Action(chara, activator)
	if not SV.Chapter3.DefeatedBoss then 
		GeneralFunctions.StartConversation(chara, "Let's all play tag![pause=0] I can start as " .. '"it"!', "Happy", false)
	else 
		GeneralFunctions.StartConversation(chara, "I can't play with the other kids today because I have to do my chores...", "Worried")
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("...That's OK though.[pause=0] My momma needs my help,[pause=10] after all!")
	end
	GeneralFunctions.EndConversation(chara)
end


function metano_town_ch_3.Mawile_Action(chara, activator)
	if not SV.Chapter3.DefeatedBoss then 
		GeneralFunctions.StartConversation(chara, "Word around the town is that you two managed to save the missing kid![pause=0] That's wonderful!", "Happy")
		UI:WaitShowDialogue("I just knew you two were gonna do great in the guild!")
	else
		local partner = CH('Teammate1')
		local hero = CH('PLAYER')
		GeneralFunctions.StartConversation(chara, partner:GetDisplayName() .. "![pause=0] " .. hero:GetDisplayName() .. "![pause=0] Have you guys heard?[pause=0] Those two merchants that hang out south of the guild are back!")
		UI:WaitShowDialogue("They're pretty strange,[pause=10] but I bet they'll have some useful items for adventurers like you!")
	end	
	GeneralFunctions.EndConversation(chara)
end 
function metano_town_ch_3.Nidorina_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Can you believe my parents kept me inside while that brat was missing?", "Determined", false)
	UI:WaitShowDialogue("Obviously the dumb kid had just ran off![pause=0] This town is so boring,[pause=10] there's nothing dangerous anywhere near here!")
	GeneralFunctions.EndConversation(chara)
end 

function metano_town_ch_3.Gloom_Action(chara, activator)
	if not SV.Chapter3.DefeatedBoss then
		GeneralFunctions.StartConversation(chara, "Maybe your parents were just worried...[pause=0] My dad worries a lot.", "Worried", false)
		UI:WaitShowDialogue("He says the world's becoming more dangerous,[pause=10] with all the mystery dungeons appearing lately.")
		GeneralFunctions.EndConversation(chara)
	else
		metano_town_ch_3.Oddish_Gloom_Conversation(chara)
	end
end


function metano_town_ch_3.Azumarill_Action(chara, activator)
	if not SV.Chapter3.DefeatedBoss then 
		GeneralFunctions.StartConversation(chara, chara:GetDisplayName() .. " knows where child is now![pause=0] That makes " .. chara:GetDisplayName() .. " happy!", "Happy")
		UI:WaitShowDialogue("The water looks happy too![pause=0] It must know child is home now,[pause=10] just like " .. chara:GetDisplayName() .. "!")
	else 
		GeneralFunctions.StartConversation(chara, chara:GetDisplayName() .. " hears about scary outlaws all the time now...[pause=0] " .. chara:GetDisplayName() .. " not want outlaws to beat " .. chara:GetDisplayName() .. " up!", "Worried")
		UI:WaitShowDialogue(chara:GetDisplayName() .. " wonders if he should train at dojo so " .. chara:GetDisplayName() .. " can be stronger to defend " .. chara:GetDisplayName() .. " from bad Pokémon...")
	end
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_3.Manectric_Action(chara, activator)
	if not SV.Chapter3.DefeatedBoss then 
		GeneralFunctions.StartConversation(chara, "So you were the ones who rescued " .. CharacterEssentials.GetCharacterName("Camerupt") .. "'s little boy?")
		UI:WaitShowDialogue("How amazing![pause=0] I can have peace of mind knowing that adventurers like you live in town!")
	else
		GeneralFunctions.StartConversation(chara, "The extra outlaw activity lately is supposedly linked with the increase in mystery dungeons popping up.")
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue("I don't know if that's true or not,[pause=10] but the increase in outlaw activity has me worried.")
		UI:WaitShowDialogue("What if outlaws go after me and my family?[pause=0]\nI wouldn't want anything bad to happen to any of us!")
		--UI:SetSpeakerEmotion("Normal")
		--UI:WaitShowDialogue("But I know that you adventurers will keep us safe![pause=0] We're all counting on you!")
	end
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_3.Camerupt_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "I still cannot thank you too enough for saving my baby boy!", "Happy")
	UI:WaitShowDialogue(CharacterEssentials.GetCharacterName("Numel") .. " and I will always be grateful for what you've done for us!")
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_3.Furret_Action(chara, activator)
	if not SV.Chapter3.DefeatedBoss then 
		GeneralFunctions.StartConversation(chara , "Ah,[pause=10] I can relax again now that " .. CharacterEssentials.GetCharacterName("Numel") .. " is back safe and sound!", "Happy", false, false)
	else  
		GeneralFunctions.StartConversation(chara , "The only thing better than sleeping in my favorite spot...", "Normal", false, false)
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("...Is sleeping in my favorite spot next to my son!")
	end
	GeneralFunctions.EndConversation(chara, false)
end

function metano_town_ch_3.Linoone_Action(chara, activator)
	if not SV.Chapter3.DefeatedBoss then 
		GeneralFunctions.StartConversation(chara, "Now that things are back to normal,[pause=10] I can focus on getting through this book " .. CharacterEssentials.GetCharacterName("Medicham") .. " recommended to me.")
		UI:WaitShowDialogue("I can enjoy a refreshing drink with it too,[pause=10] now that the café is open again.")
	else
		GeneralFunctions.StartConversation(chara, "This spot by the river is a great place to read.")
		UI:WaitShowDialogue("Right now,[pause=10] I'm reading a book recommended to me by my son about mystery dungeons.")
		UI:WaitShowDialogue("Did you know that if you stay on one floor for too long,[pause=10] a mysterious force will eject you from the dungeon?")
		UI:WaitShowDialogue("The author notes that nobody knows the source of the mysterious force.[pause=0] How strange!")
	end	
	GeneralFunctions.EndConversation(chara)
end


function metano_town_ch_3.Luxray_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Hmmph.[pause=0] " .. CharacterEssentials.GetCharacterName("Camerupt") .. "'s son runs away,[pause=10] and now that he's been returned to her,[pause=10] she gives him no punishment?")
	UI:WaitShowDialogue("The way she parents her child is appalling.[pause=0] With no discipline,[pause=10] that child will grow up to be a troublemaker.")
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_3.Nidoking_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "It's wonderful that " .. CharacterEssentials.GetCharacterName('Camerupt') .. "'s young'un was rescued safe an' sound.")
	UI:WaitShowDialogue("The adventurers at that there guild sure do some right proper work!")
	GeneralFunctions.EndConversation(chara)
end 

function metano_town_ch_3.Medicham_Action(chara, activator)
	if not SV.Chapter3.DefeatedBoss then 
		--My mind is clear and I can meditate again now that Nubbor's rescued.
		GeneralFunctions.StartConversation(chara, "Clear my mind is and again meditate can I with thanks to rescue of " .. CharacterEssentials.GetCharacterName("Numel") .. ".")
	else
		--This is the best place in town to meditate. Usually some older kids hang out here, but they're not here today.
		GeneralFunctions.StartConversation(chara, "Find I that meditation is done best in this town's spot.")
		UI:WaitShowDialogue("Usually hang here older children,[pause=10] but today here not are they.")
	end	
	GeneralFunctions.EndConversation(chara)

end

function metano_town_ch_3.Meditite_Action(chara, activator)
	if not SV.Chapter3.DefeatedBoss then 
		GeneralFunctions.StartConversation(chara, "Wish play coul' I wit' the other kids...")
		UI:WaitShowDialogue("It's hard fa' me friends to make...[pause=0] The other kids trouble have talkin' wit' me...")
		UI:WaitShowDialogue("I don' get it...[pause=0] What am I sayin' hard that's ta' understand?")
	else 
		metano_town_ch_3.Meditite_Electrike_Conversation(chara)
	end
	GeneralFunctions.EndConversation(chara)

end

function metano_town_ch_3.Machamp_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Oi![pause=0] Didja hear the news?")
	UI:WaitShowDialogue("A whole forest chock full o' Apricorn trees were just found!")
	UI:WaitShowDialogue("That'll surely solve the Apricorn shortage we were havin'!")
	GeneralFunctions.EndConversation(chara)
end


function metano_town_ch_3.Growlithe_Desk_Action(chara, activator)
	local growlithe = CH('Growlithe')
	if not SV.Chapter3.DefeatedBoss then 
		GeneralFunctions.StartConversation(growlithe, "I heard you two rescued " .. CharacterEssentials.GetCharacterName("Numel") .. ",[pause=10] ruff!", "Happy")
		UI:WaitShowDialogue("That's amazing![pause=0] I knew you could do it,[pause=10] ruff!")
	else 
		GeneralFunctions.StartConversation(growlithe, "Great job on arresting that outlaw " .. CharacterEssentials.GetCharacterName("Sandile") .. " you guys![pause=0] You've been on a roll lately,[pause=10] ruff!", "Happy")
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue("I hope I can go on some missions soon too,[pause=10] ruff.")
		UI:WaitShowDialogue("I'm always on sentry duty,[pause=10] so I haven't gone on an adventure with " .. CharacterEssentials.GetCharacterName("Zigzagoon") .. " in a while,[pause=10] ruff...")
	end
	GeneralFunctions.EndConversation(growlithe)
end

function metano_town_ch_3.Audino_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Oh,[pause=10] are you two headed out for the day?")
	UI:WaitShowDialogue("Make sure you leave town to the east,[pause=10] r-right over there!")
	UI:WaitShowDialogue("That's where you should go whenever you want to go out on an adventure!")
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_3.Snubbull_Action(chara, activator)
	if not SV.Chapter3.DefeatedBoss then
		GeneralFunctions.StartConversation(chara, "Oh,[pause=10] the Kecleon Shop is out of Apricorns...", "Worried")
		UI:WaitShowDialogue("Apparently there's been a shortage of Apricorns lately.")
		UI:WaitShowDialogue("Without Apricorns,[pause=10] recruiting new team members is impossible!")
		UI:SetSpeakerEmotion("Sad")
		UI:WaitShowDialogue("More importantly,[pause=10] I can't make this special dish I've been working on without Apricorns![pause=0] Now what will I cook?")
	else
		GeneralFunctions.StartConversation(chara, CharacterEssentials.GetCharacterName("Kecleon") .. " says that the Kecleon Shop will be getting a fresh shipment of Apricorns soon.")
		UI:WaitShowDialogue("With Apricorns,[pause=10] adventuring teams will be able to recruit new team members again.")
		UI:SetSpeakerEmotion("Special0")
		UI:WaitShowDialogue("More importantly,[pause=10] I'll be able to work on this new dish of mine with those Apricorns. " .. STRINGS:Format("\\u266A"))
	end
	GeneralFunctions.EndConversation(chara)
		
end

function metano_town_ch_3.Zigzagoon_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Did you know you can check your active jobs while you're in a dungeon?[pause=0] It's perfect for someone like me!")
	UI:WaitShowDialogue("Just press " .. STRINGS:LocalKeyString(9) .. ",[pause=10] go to the Others menu,[pause=10] then choose Mission Objectives!")
	UI:WaitShowDialogue("It's really useful if you forget what jobs you've taken for that dungeon,[pause=10] or what floors your jobs are on!")
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_3.Mareep_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Fa-a-a-antastic you two![pause=0] I knew you could na-a-a-ab that baddie!", "Joyous")
	UI:WaitShowDialogue("You both have a real ta-a-a-alent for capturing outlaws![pause=0] I'm so proud of you!")
	GeneralFunctions.EndConversation(chara)
end


function metano_town_ch_3.Cranidos_Action(chara, activator)
	local sandile_species = _DATA:GetMonster('sandile'):GetColoredName()
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("crooked_cavern")
	GeneralFunctions.StartConversation(chara, "What,[pause=10] am I supposed to be impressed you captured that " .. sandile_species .. "?")
	UI:WaitShowDialogue("He was an easy mark![pause=0] That's why I chose him for you,[pause=10] even if he was in a place like " .. zone:GetColoredName() .. ".")
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("You can speak to me when you take down an outlaw that's worth my notice.")
	GeneralFunctions.EndConversation(chara)
end


function metano_town_ch_3.TrailerCameraPan()
	GROUND:Hide('Green_Merchant')
	GROUND:Hide('Red_Merchant')
	GAME:FadeOut(false, 1)
	GAME:WaitFrames(40)
	GAME:FadeIn(1)
	GAME:MoveCamera(436, 120, 1, false) 
	GAME:MoveCamera(436, 1020, 450, false)
	
	GAME:FadeOut(false, 1)
	GAME:WaitFrames(40)
	
	GAME:MoveCamera(1130, 552, 1, false) 
	GAME:FadeIn(1)
	GAME:MoveCamera(1130, 1252, 350, false) 
	GAME:FadeOut(false, 1)
	GAME:WaitFrames(40)
	
	
	GAME:MoveCamera(666, 1200, 1, false) 
	GAME:FadeIn(1)
	GAME:MoveCamera(666, 1040, 80, false) 
	GAME:MoveCamera(746, 960, 40, false) 
	GAME:MoveCamera(746, 792, 84, false) 
	GAME:WaitFrames(120)
	GAME:FadeOut(false, 1)
	GAME:WaitFrames(40)
	
	GAME:WaitFrames(60)
	GAME:MoveCamera(0,0,1, true)
	GAME:FadeIn(1)


end