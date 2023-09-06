require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_town_ch_4 = {}

function metano_town_ch_4.SetupGround()
	GROUND:Hide('Swap_Owner')
	GROUND:Hide('Swap')
	
	--trigger for audino showing you the signpost/cafe stuff
	if not SV.Chapter4.FinishedSignpostCutscene then
		local signBlock = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1), 
															RogueElements.Rect(1368, 584, 8, 56),
															RogueElements.Loc(0, 0), 
															true, 
															"Event_Trigger_1")
		
		signBlock:ReloadEvents()
		GAME:GetCurrentGround():AddTempObject(signBlock)
	end
	
	if not SV.Chapter4.FinishedGrove then
		local spinda, ludicolo, roselia, nidorina, gloom, wooper_girl, wooper_boy,
			  electrike, medicham, camerupt, bellossom, manectric, furret, numel, sentret,
			  mawile, luxray, floatzel, oddish, zigzagoon = 
			CharacterEssentials.MakeCharactersFromList({
				{'Spinda', 1204, 1160, Direction.Up},
				{'Ludicolo', 1184, 1128, Direction.DownRight},
				{'Roselia', 1224, 1128, Direction.DownLeft},
				{'Nidorina', 512, 184, Direction.DownRight},
				{'Gloom', 536, 208, Direction.UpLeft},
				{'Wooper_Girl', 184, 896, Direction.Down},
				{'Wooper_Boy', 160, 840, Direction.UpLeft},
				{'Electrike', 232, 872, Direction.Left},
				{'Medicham', 624, 512, Direction.Up},
				{'Camerupt', 'Town_Seat_2'},
				{'Bellossom', 'Town_Seat_1'},
				{'Manectric', 1256, 360, Direction.DownLeft},
				{'Furret', 1144, 904, Direction.UpRight},
				{'Numel', 400, 432, Direction.Right},
				{'Sentret', 432, 432, Direction.Left},
				{'Mawile', 336, 1208, Direction.Left},
				{'Luxray', 320, 1016, Direction.UpRight},
				{'Floatzel', 992, 800, Direction.DownRight},
				{'Oddish', 872, 566, Direction.Up},
				{'Zigzagoon', 872, 566, Direction.Up}			
		
			})
			
		AI:SetCharacterAI(manectric, "ai.ground_default", RogueElements.Loc(1248, 344), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
		AI:SetCharacterAI(furret, "ai.ground_default", RogueElements.Loc(1128, 888), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
		AI:SetCharacterAI(mawile, "ai.ground_default", RogueElements.Loc(320, 1192), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
		AI:SetCharacterAI(luxray, "ai.ground_default", RogueElements.Loc(304, 1000), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
		AI:SetCharacterAI(zigzagoon, "ai.ground_default", RogueElements.Loc(856, 550), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)

	else
	
	end
	
	GAME:FadeIn(20)
	
end

function metano_town_ch_4.Event_Trigger_1_Touch(obj, activator)
	metano_town_ch_4.SignpostIntroductionCutscene()
end


function metano_town_ch_4.SignpostIntroductionCutscene()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local audino, cafe_dummy = CharacterEssentials.MakeCharactersFromList({
		{"Audino", 1152, 608, Direction.Right},
		{"Tail"},--dummy
	})
	
	GROUND:TeleportTo(cafe_dummy, 1118, 576, Direction.Down)
	--disable this cutscene's event trigger
	GROUND:Hide('Event_Trigger_1')
	
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:SetSpeaker(audino:GetDisplayName(), true, "", -1, "", RogueEssence.Data.Gender.Unknown)	
	
	local coro1 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue(partner:GetDisplayName() .. "![pause=30] " .. hero:GetDisplayName() .. "![pause=30] W-wait up!", 60) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) GeneralFunctions.EmoteAndPause(partner, "Exclaim", true) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(30) GeneralFunctions.EmoteAndPause(hero, "Notice", true) end)

	TASK:JoinCoroutines({coro1, coro2, coro3})

	GAME:WaitFrames(20)
	
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GeneralFunctions.EightWayMove(hero, 1336, 592, false, 1) 
											GROUND:CharAnimateTurnTo(hero, Direction.Left, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GeneralFunctions.EightWayMove(partner, 1336, 624, false, 1) 
											GROUND:CharAnimateTurnTo(partner, Direction.Left, 4) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(audino, 1304, 608, false, 2) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) 
												  GAME:MoveCamera(1328, 616, GeneralFunctions.CalculateCameraFrames(GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 1328, 616, 1), false) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	SOUND:PlayBattleSE('EVT_Emote_Sweating')
	GROUND:CharSetEmote(audino, "sweating", 1)
	UI:SetSpeaker(audino)
	UI:SetSpeakerEmotion("Pain")
	UI:WaitShowDialogue("Hurf...[pause=0] I c-caught up to you guys...[pause=0] Thank goodness...")
	GAME:WaitFrames(40)
	
	GeneralFunctions.ShakeHead(audino)
	GAME:WaitFrames(10)
	GeneralFunctions.Hop(audino)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Phew![pause=0] I'm glad I made it to you two before you headed out today!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("Hey " .. audino:GetDisplayName() .. "![pause=0] What's going on?[pause=0] Why are you in such a hurry to catch us?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(audino)
	UI:WaitShowDialogue("You know how I've opened up my Assembly again,[pause=10]\nr-right?")
	--GROUND:EntTurn(audino, Direction.UpRight)
	UI:WaitShowDialogue("W-well,[pause=10] to go along with that,[pause=10] I've placed a signpost here by the way out of town!")
	
	GAME:WaitFrames(10)
	
	
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(36) GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(40) GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) GROUND:CharAnimateTurnTo(hero, Direction.Right, 4) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(audino, 1390, 608, false, 1)
											GROUND:CharAnimateTurnTo(audino, Direction.Up, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(16)
											GAME:MoveCamera(1352, 616, GeneralFunctions.CalculateCameraFrames(GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 1352, 616, 1), false) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	UI:WaitShowDialogue("See?[pause=0] It's right here![script=0]", {function() return GeneralFunctions.Hop(audino) end})
	GAME:WaitFrames(10)
	GROUND:CharAnimateTurnTo(audino, Direction.Left, 4)
	UI:WaitShowDialogue("You can ring the bell on it and I'll come running from the guild so you can use the Assembly out here!")
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("M-my ears are really sensitive,[pause=10] so I'll hear it even all the way out here!")
	
	--GAME:WaitFrames(20)
	--coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(audino, Direction.Right, 4) end)
	--coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GROUND:CharAnimateTurnTo(partner, Direction.Left, 4) end)	
	--coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(12) GROUND:CharAnimateTurnTo(hero, Direction.Left, 4) end)	
	--TASK:JoinCoroutines({coro1, coro2, coro3})
	
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Just try not to overuse it,[pause=10] I do enough r-running around as it is!")
	GAME:WaitFrames(20)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
	GROUND:CharSetEmote(audino, "exclaim", 1)
	GAME:WaitFrames(40)
	UI:WaitShowDialogue("Oh![pause=0] One more thing!")
	GAME:WaitFrames(10)
	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Left, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:CharAnimateTurnTo(hero, Direction.Left, 4) end)
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.CenterCamera({cafe_dummy}, GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 3) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	UI:WaitShowDialogue("I spoke to " .. CharacterEssentials.GetCharacterName("Shuckle") .. " at the café earlier today.")
	UI:WaitShowDialogue("He said it was OK for teammates accompanying you on adventures to wait inside the café!")
	UI:WaitShowDialogue("So if y-you want to meet with your teammates before going out on an adventure,[pause=10] just visit the café!")
	
	GAME:WaitFrames(20)
	GROUND:EntTurn(hero, Direction.Right)
	GROUND:EntTurn(partner, Direction.Right)
	GROUND:EntTurn(audino, Direction.Left)
	GAME:MoveCamera(1352, 616, GeneralFunctions.CalculateCameraFrames(GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 1352, 616, 3), false)
	
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("That's all I had to share with you![pause=0] I hope this will all be u-useful for you two!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("It is![pause=0] Thank you for doing all this,[pause=10] it'll be a huge help for us!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(audino)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Oh![pause=0] It's no p-problem![pause=0] I'm just g-glad I can help out!")
	GAME:WaitFrames(20)
	
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("W-well,[pause=10] I'd better get back to the guild now.[pause=0] Good luck with your adventure today!")
	
	GAME:WaitFrames(10)
	
	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(audino, Direction.Left, 4)
											GROUND:MoveToPosition(audino, 1248, 608, false, 2) 
											GROUND:MoveToPosition(audino, 1152, 704, false, 2) 
											GAME:GetCurrentGround():RemoveTempChar(audino) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(26) GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) GROUND:CharAnimateTurnTo(partner, Direction.Left, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(30) GROUND:CharAnimateTurnTo(hero, Direction.Left, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)
	GeneralFunctions.PanCamera()
	SV.Chapter4.FinishedSignpostCutscene = true
	GAME:CutsceneMode(false)	
	
	
end


function metano_town_ch_4.Snubbull_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		--N/A
	else
		GeneralFunctions.StartConversation(chara, "With the expedition start getting closer,[pause=10] I'm wondering more and more what we'll find on it.")
		UI:WaitShowDialogue("I hope we find an exotic delicacy that I can use to make a fantastic new meal.[pause=0] That would be absolutely wonderful. " .. STRINGS:Format("\\u266A")))
	end
	GeneralFunctions.EndConversation(chara)
		
end

function metano_town_ch_4.Zigzagoon_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "This expedition sounds absolutely amazing![pause=0] I've never been on one before!", "Happy")
		UI:WaitShowDialogue("I hope I can learn a lot on it![pause=0] I'll be sure to write down everything I learn in my almanacs!")
	else
		--N/A
	end
	GeneralFunctions.EndConversation(chara)
		
end

function metano_town_ch_4.Roselia_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "Tah![pause=0] Apricorns allow you to recruit more Pokémon to your team! " .. STRINGS:Format("\\u266A"), "Normal", true, false)
		UI:WaitShowDialogue("The more Pokémon you have,[pause=10] the more dancing you all can do! ".. STRINGS:Format("\\u266A"))
	else

	end
	GeneralFunctions.EndConversation(chara)
		
end

function metano_town_ch_4.Ludicolo_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "Yah![pause=0] I'm going to hollow me out some Apricorns then fill them with pebbles!", "Normal", true, false)
		UI:WaitShowDialogue("They'll make fantastic maracas,[pause=10] cha cha cha!")
	else

	end
	GeneralFunctions.EndConversation(chara)
		
end

function metano_town_ch_4.Spinda_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "Lah![pause=0] I got to find some Apricorns,[pause=10] they're the perfect shape for juggling!", "Normal", true, false)
		UI:WaitShowDialogue("Dancing,[pause=10] juggling,[pause=10] dancing while juggling![pause=0] I will become a master of all three!")
	else

	end
	GeneralFunctions.EndConversation(chara)
		
end



function metano_town_ch_4.Linoone_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		--N/A
	else
		GeneralFunctions.StartConversation(chara, "I've just finished this book detailing mystery dungeons.[pause=0] It was an excellent and informative read overall.")
		UI:WaitShowDialogue("The last thing the book covered is how mystery dungeons typically change the further you go in them.")
		UI:WaitShowDialogue("The way they tend to structure themselves,[pause=10] the strength and type of enemies within,[pause=10] the visibility...")
		UI:WaitShowDialogue("All these and more can change as you progress within a dungeon,[pause=10] typically in a way that makes the dungeon more difficult.")
		UI:WaitShowDialogue("How interesting.[pause=0] With design like that,[pause=10] it makes me wonder just how natural these dungeons are.")
	end
	GeneralFunctions.EndConversation(chara)
		
end


function metano_town_ch_4.Mawile_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "Hey,[pause=10] it's you two![pause=0] What are my favorite adventurers up to today?", "Happy")
		GAME:WaitFrames(20)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("...You're going to explore that forest full of Apricorns?")
		UI:WaitShowDialogue("I've heard that place was discovered recently.[pause=0] Nobody's gone inside it yet,[pause=10] right?")
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("Sounds like it'll be a great adventure![pause=0] Good luck,[pause=10] I'm rooting for the both of you!")
	else
		GeneralFunctions.StartConversation(chara, "I overheard that the guild is going on an expedition soon![pause=0] That sounds like it'll be a lot of fun for you two!")
		UI:WaitShowDialogue("But an expedition means I won't see either of you for a while,[pause=10] doesn't it?")
		UI:SetSpeakerEmotion("Sad")
		UI:WaitShowDialogue("I'll miss seeing you around town...")
		GAME:WaitFrames(20)
		UI:SetSpeakerEmotion("Joyous")
		GROUND:CharSetEmote(chara, "glowing", 0)
		UI:WaitShowDialogue("You'll just have to make that up to me by finding something fantastic on that expedition,[pause=10] got it?")
		GROUND:CharSetEmote(chara, "", 0)
	end
	GeneralFunctions.EndConversation(chara)
		
end

function metano_town_ch_4.Electrike_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "You know I can see the both of you,[pause=10] right?", "Normal", false)
		UI:WaitShowDialogue("It's not dark,[pause=10] hiding like that isn't going to work unless it's dark...")
		GAME:WaitFrames(20)
		UI:WaitShowDialogue("(...Actually,[pause=10] it's better if I don't let them know I've found them.[pause=0] They won't bother me that way.)")
		UI:WaitShowDialogue("I mean...[pause=0] Where could " .. CharacterEssentials.GetCharacterName("Wooper_Girl") .. " and " .. CharacterEssentials.GetCharacterName("Wooper_Boy") .. " be?[pause=0] I'm never going to be able to find them!")
	else
		GeneralFunctions.StartConversation(chara, "")
	end
	GeneralFunctions.EndConversation(chara)
		
end



function metano_town_ch_4.Wooper_Boy_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then 
		GeneralFunctions.StartConversation(chara, "Hehe![pause=0] I'm the best at hide and seek!", "Happy", false)
		UI:WaitShowDialogue(CharacterEssentials.GetCharacterName("Wooper_Girl") .. " couldn't find me when we played,[pause=10] and now " .. CharacterEssentials.GetCharacterName("Electrike") .. " can't find me,[pause=10] hehe!")
		GeneralFunctions.EndConversation(chara)
	else
		if not SV.Chapter4.WoopersMedititeConvo then
			metano_town_ch_4.Meditite_Woopers_Dialogue(chara)	
		else
			GeneralFunctions.StartConversation(chara, "I'm gonna win at sumo wrestlers![pause=0] Nobody's gonna push me away!", "Happy", false) 
			GeneralFunctions.EndConversation(chara)
		end
	end
end

function metano_town_ch_4.Wooper_Girl_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then 
		GeneralFunctions.StartConversation(chara, "This spot is even better than " .. CharacterEssentials.GetCharacterName("Wooper_Boy") .. "'s![pause=0] There's no way " .. CharacterEssentials.GetCharacterName("Electrike") .. " is gonna see me here!", "Happy", false)
		GeneralFunctions.EndConversation(chara)
	else
		if not SV.Chapter4.WoopersMedititeConvo then
			metano_town_ch_4.Meditite_Woopers_Dialogue(chara)	
		else
			GeneralFunctions.StartConversation(chara, "We've never played sumo wrestlers before![pause=0] It sounds like a lot of fun!", "Happy", false) 
			GeneralFunctions.EndConversation(chara)
		end	
	end
end

function metano_town_ch_4.Meditite_Woopers_Dialogue(chara)
	--local electrike = CH('Electrike')
	local meditite = CH('Meditite')
	local wooper_boy = CH('Wooper_Boy')
	local wooper_girl = CH('Wooper_Girl')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	
	partner.IsInteracting = true
	GROUND:CharSetAnim(meditite, 'None', true)
	--GROUND:CharSetAnim(electrike, 'None', true)
	GROUND:CharSetAnim(wooper_boy, 'None', true)
	GROUND:CharSetAnim(wooper_girl, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharSetAnim(partner, 'None', true)
	UI:SetSpeaker(electrike)
    GROUND:CharTurnToChar(hero, chara)
    local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)
	UI:WaitShowDialogue("What should we all play today?")
    TASK:JoinCoroutines({coro1})
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(wooper_girl)
	UI:WaitShowDialogue(meditite:GetDisplayName() .. " should pick![pause=0] I'm sure she would know something fun for us to play!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(meditite)
	UI:WaitShowDialogue("Ya want me ta' pick?[pause=0] Erm...")
	UI:WaitShowDialogue("Sumo wrestlin' how about?[pause=0] Game it is where we shov' to try each other outta a ring!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(wooper_boy)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("That sounds like a lot of fun![pause=0] Let's play that!")
	GAME:WaitFrames(20)

	UI:SetSpeaker(wooper_girl)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Yeah![pause=0] Let's play sumo wrestlers!")
	GAME:WaitFrames(10)
	
	GeneralFunctions.EmoteAndPause(meditite, "Shock", true)
	UI:SetSpeaker(meditite)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("W-wait![pause=0] Y-you understand me can!?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(wooper_boy)
	UI:WaitShowDialogue("Of course we can![pause=0] I understand you easily!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(wooper_girl)
	UI:WaitShowDialogue("Yeah![pause=0] Why wouldn't we be able to?")
	GAME:WaitFrames(10)
	
	GeneralFunctions.EmoteAndPause(meditite, "Sweating", true)
	UI:SetSpeaker(meditite)
	UI:SetSpeakerEmotion("Stunned")
	UI:WaitShowDialogue("I suppose I'm not it used to all is...")

	--GROUND:CharEndAnim(electrike)
	SV.Chapter4.WoopersMedititeConvo = true
	GROUND:CharEndAnim(meditite)
	GROUND:CharEndAnim(wooper_boy)
	GROUND:CharEndAnim(wooper_girl)
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	partner.IsInteracting = false
end


function metano_town_ch_4.Oddish_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "This is where that weird lady lives...", "Worried")
		UI:WaitShowDialogue("Isn't she a Grass-type like me?[pause=0] The sun is so nice to be in!")
		UI:WaitShowDialogue("Why does she stay in the cave all day?[pause=0] She must be sad being in there all the time!")
	else
		--N/a
	end
	GeneralFunctions.EndConversation(chara)
		
end

function metano_town_ch_4.Meditite_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		--N/A
	else
		if not SV.Chapter4.WoopersMedititeConvo then
			metano_town_ch_4.Meditite_Woopers_Dialogue(chara)	
		else
			GeneralFunctions.StartConversation(chara, "I cannae believe it...[pause=0] Understandin' other me kids...", "Normal", false) 
			GeneralFunctions.EndConversation(chara)
		end	
	end
end

function metano_town_ch_4.Medicham_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then 
		--This mailbox my husband cherishes is garish. I wish I could get rid of it, but I don't want to upset him.
		GeneralFunctions.StartConversation(chara, "Garish is this mailbox that cherishes my husband.", "Worried")
		UI:WaitShowDialogue("Get rid of it wish could I,[pause=10] but upset him do not want I.")
		GeneralFunctions.EndConversation(chara)
	else
		if not SV.Chapter4.MedichamMachampArgument then
			metano_town_ch_4.Machamp_Medicham_Dialogue(chara)	
		else 
			GeneralFunctions.StartConversation(chara, "Put it like that when you,[pause=10] suppose I that the mailbox pretty funny is!", "Happy", false)
			GeneralFunctions.EndConversation(chara)
		end
	end 
end

function metano_town_ch_4.Machamp_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "That forest full o' Apricorns...[pause=0] Turns out it's housin' a mystery dungeon!")
		UI:WaitShowDialogue("But nary a soul has gone inside to explore it yet,[pause=10] far as I know.")
		UI:WaitShowDialogue("Somebody needs ta' get in there and cover the place from top ta' bottom![pause=0] We need them Apricorns!")
		GeneralFunctions.EndConversation(chara)
	else
		if not SV.Chapter4.MedichamMachampArgument then
			metano_town_ch_4.Machamp_Medicham_Dialogue(chara)	
		else 
			GeneralFunctions.StartConversation(chara, "Hoohoo![pause=0] I'm glad ye can see why I like the mailbox,[pause=10] dearest!", "Normal", false)
			GeneralFunctions.EndConversation(chara)
		end
	end
end

function metano_town_ch_4.Machamp_Medicham_Dialogue(chara)
	local machamp = CH('Machamp')
	local medicham = CH('Medicham')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local machamp_species = _DATA:GetMonster('machamp'):GetColoredName()
	
	partner.IsInteracting = true
	GROUND:CharSetAnim(medicham, 'None', true)
	GROUND:CharSetAnim(machamp, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharSetAnim(partner, 'None', true)
	UI:SetSpeaker(machamp)
    GROUND:CharTurnToChar(hero, chara)
    local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)
	SOUND:PlayBattleSE("EVT_Emote_Shock_Bad")
	GeneralFunctions.EmoteAndPause(machamp, "Shock", false)
	UI:WaitShowDialogue("Whaddya mean ya dinnae like the mailbox!?")
    TASK:JoinCoroutines({coro1})

	GAME:WaitFrames(20)
	UI:SetSpeaker(medicham)
	UI:SetSpeakerEmotion("Worried")
	--Don't you think it's gaudy?
	UI:WaitShowDialogue("Think not do you gaudy that it is?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(machamp)
	UI:WaitShowDialogue("A' course it is![pause=0] But that's what's so great about it!")
	UI:WaitShowDialogue("I mean,[pause=10] think about it![pause=0] A " .. machamp_species .. " feelin' the need ta' flex his muscles even on 'is mailbox?")
	GROUND:CharSetEmote(machamp, "glowing", 0)
	UI:WaitShowDialogue("Hoohoo,[pause=10] what a riot!")
	GAME:WaitFrames(20)
	
	GROUND:CharSetEmote(machamp, "", 0)
	UI:SetSpeaker(medicham)
	UI:SetSpeakerEmotion("Happy")
	--When you put it like that, I guess it is pretty funny!
	UI:WaitShowDialogue("Put it like that when you,[pause=10] suppose I that the mailbox pretty funny is!")
	GAME:WaitFrames(20)

	UI:SetSpeaker(machamp)
	UI:WaitShowDialogue("Hoohoo![pause=0] I'm glad ye can see it my way,[pause=10] dearest!")

	GROUND:CharEndAnim(medicham)
	GROUND:CharEndAnim(machamp)
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	partner.IsInteracting = false
end

function metano_town_ch_4.Growlithe_Desk_Action(chara, activator)
	local growlithe = CH('Growlithe')
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(growlithe, "Wow![pause=0] An expedition with everyone here at the guild![pause=0] I'm so excited,[pause=10] ruff!", "Inspired")
		UI:SetSpeakerEmotion("Joyous")
		UI:WaitShowDialogue("It's been so long since I've gone on an adventure,[pause=10] let alone an expedition![pause=0] It's gonna be great,[pause=10] ruff!")
	else
		GeneralFunctions.StartConversation(growlithe, CharacterEssentials.GetCharacterName("Breloom") .. " and " .. CharacterEssentials.GetCharacterName("Girafarig") .. " better hurry on back,[pause=10] ruff!", "Happy")
		UI:SetSpeakerEmotion("Inspired")
		UI:WaitShowDialogue("They shouldn't be much longer,[pause=10] but I can't wait anymore![pause=0] This expedition is gonna be so much fun,[pause=10] ruff!")
	end
	GeneralFunctions.EndConversation(growlithe)	
end

function metano_town_ch_4.Manectric_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "I've got this letter I want to send to a distant friend of mine.")
		UI:WaitShowDialogue("It's been too long since we last saw each other and I wanted to write her to see how she and her family are doing!")
		UI:WaitShowDialogue("But apparently the post office here is for handling rescue requests between adventuring teams.")
		UI:WaitShowDialogue("Hmm...[pause=0] I wonder how I'm going to get this letter sent out now...")
	else
		GeneralFunctions.StartConversation(chara, "I spoke more with the post office workers,[pause=10] and they agreed to take my letter to my friend!")
		UI:WaitShowDialogue("They normally only handle rescue requests from adventuring teams,[pause=10] but they said they'd handle any mail between my friend and I!")
		UI:WaitShowDialogue("Wait a moment,[pause=10] you two are those wonderful adventurers that saved " .. CharacterEssentials.GetCharacterName("Numel") .. "!")
		UI:WaitShowDialogue("You should check out the post office,[pause=10] I'm sure great adventurers like you would be able to help other adventurers in need!")
		
	end
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_4.Sentret_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "")
	else
	
	end
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_4.Numel_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "")
	else
	
	end
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_4.Floatzel_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "With all the outlaws running around lately,[pause=10] I had a great idea!")
		UI:WaitShowDialogue("Outlaws all have a bounty on their head,[pause=10] right?")
		UI:WaitShowDialogue("If I take some stuff from the Kecleon Shop during the night,[pause=10] the authorities will put a bounty on me!")
		UI:WaitShowDialogue("Then,[pause=10] if I turn myself in,[pause=10] I can get the bounty!")
		UI:WaitShowDialogue("Of course,[pause=10] I'll have to leave some money to pay for the items I take...[pause=0] I don't wanna steal after all!")
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("This plan is foolproof![pause=0] I'll be able to afford my castle in no time!")
	else
		--N/A
	end
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_4.Quagsire_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		--N/A
	else
		metano_town_ch_4.Quagsire_Kecleon_Dialogue(chara)
	end
end

function metano_town_ch_4.Quagsire_Kecleon_Dialogue(chara)
	local kecleon = CH('Shop_Owner')
	local quagsire = CH('Quagsire')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	
	partner.IsInteracting = true
	GROUND:CharSetAnim(quagsire, 'None', true)
	GROUND:CharSetAnim(kecleon, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:EntTurn(kecleon, Direction.DownLeft)
	
	UI:SetSpeaker(quagsire)
	UI:SetSpeakerEmotion("Worried")
    GROUND:CharTurnToChar(hero, chara)
    local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)
	UI:WaitShowDialogue("Here's all the stuff he took.[pause=0] Sorry again about all this.[pause=0] I don't know what's gotten into my husband lately.")
    TASK:JoinCoroutines({coro1})
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(kecleon)
	UI:WaitShowDialogue("It's no problem at all my dear. " .. STRINGS:Format("\\u266A"))
	UI:WaitShowDialogue("Your husband actually left proper payment for all the goods he took,[pause=10] so you're free to keep whatever you'd like." .. STRINGS:Format("\\u266A"))
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(quagsire)
	UI:WaitShowDialogue("Thank you.[pause=0] I think I'll just hold on to what he took in that case.")
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Though I wish I could figure out what's going on that head of his...[pause=0] I'm not sure how he thought this would turn out...")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(kecleon)
	UI:WaitShowDialogue("I can't answer that,[pause=10] but given that he paid for my brother and I's goods,[pause=10] he must have a good heart at least.")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(quagsire)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("His heart is usually in the right place...[pause=0] If only his head could be in the right place,[pause=10] too.")
	


	GROUND:CharEndAnim(quagsire)
	GROUND:CharEndAnim(kecleon)
	GROUND:EntTurn(kecleon, Direction.Down)
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	partner.IsInteracting = false
end

function metano_town_ch_4.Camerupt_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "")
	else
	
	end
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_4.Luxray_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		local wooper_species = _DATA:GetMonster('wooper'):GetColoredName()
		GeneralFunctions.StartConversation(chara, CharacterEssentials.GetCharacterName("Electrike") .. " needs to learn that those clueless " .. wooper_species .. " twins aren't worth his time.")
		UI:WaitShowDialogue("But I suppose he is still quite young...[pause=0] He will learn his lesson soon enough.[pause=0] I trust that he will.")
	else
	
	end
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_4.Furret_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "I have so many errands to take care of in town today.", "Normal")
		UI:SetSpeakerEmotion("Sad")
		UI:WaitShowDialogue("This is seriously going to cut into my snoozing time...")
	else
		GeneralFunctions.StartConversation(chara, "With all those chores taken care of,[pause=10] it's back to what I enjoy doing the most~", "Happy", false, false)
	end
	GeneralFunctions.EndConversation(chara)
end
