require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

guild_second_floor_ch_1 = {}




function guild_second_floor_ch_1.MeetNoctowl()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	GeneralFunctions.CenterCamera({hero, partner})
	--swap the partner and hero's spawn points, as the partner is leading in this instance
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	--[[
	--set up background pokemon
	--team rollout
	local marker1 = MRKR("Left_Trio_1")
	local marker2 = MRKR("Left_Trio_2")
	local marker3 = MRKR("Left_Trio_3")
	
	--todo: turn into templates?
	local jigglypuff = GROUND:CreateCharacter("Jigglypuff", "Jigglypuff", marker1.Position.X, marker1.Position.Y, "", "")
	local spheal = GROUND:CreateCharacter("Spheal", "Spheal", marker2.Position.X, marker2.Position.Y, "", "")
	local marill = GROUND:CreateCharacter("Marill", "Marill", marker3.Position.X, marker3.Position.Y, "", "")

	--Team 
	marker1 = MRKR("Generic_Spawn_Duo_1")
	marker2 = MRKR("Generic_Spawn_Duo_2")
	
	local cleffa = GROUND:CreateCharacter("Cleffa", "Cleffa", marker1.Position.X, marker1.Position.Y, "", "")
	local aggron = GROUND:CreateCharacter("Aggron", "Aggron", marker2.Position.X, marker2.Position.Y, "", "")

	--Tsundere team
	marker1 = MRKR("Right_Duo_1")
	marker2 = MRKR("Right_Duo_2")
	
	local mareep = GROUND:CreateCharacter("Mareep", "Mareep", marker1.Position.X, marker1.Position.Y, "", "")
	local cranidos = GROUND:CreateCharacter("Cranidos", "Cranidos", marker2.Position.X, marker2.Position.Y, "", "")
	
	
	--team style. Spawn them and noctowl offscreen.
	local luxio = GROUND:CreateCharacter("GroundChar", "Luxio", 480, 280, "", "")
	local glameow = GROUND:CreateCharacter("GroundChar", "Glameow", 512, 280, "", "")
	local cacnea = GROUND:CreateCharacter("GroundChar", "Cacnea", 544, 280, "", "")
	local luxio = GROUND:CreateCharacter("GroundChar", "Noctowl", 480, 280, "", "")
	
	
	local spheal = CharacterEssentials.MakeCharacterAtMarker('Spheal', 'Left_Trio_1')
	local jigglypuff = CharacterEssentials.MakeCharacterAtMarker('Jigglypuff', 'Left_Trio_2')
	local marill = CharacterEssentials.MakeCharacterAtMarker('Marill', 'Left_Trio_3')

	local mareep = CharacterEssentials.MakeCharacterAtMarker('Mareep', 'Right_Duo_1')
	local cranidos = CharacterEssentials.MakeCharacterAtMarker('Cranidos', 'Right_Duo_2')
	
	local cleffa = CharacterEssentials.MakeCharacterAtMarker('Cleffa', 'Generic_Spawn_Duo_1')
	local aggron = CharacterEssentials.MakeCharacterAtMarker('Aggron', 'Generic_Spawn_Duo_2')
	]]--
	local spheal, jigglypuff, marill, mareep, cranidos, cleffa, aggron, cacnea, glameow, luxio, noctowl, growlithe, zigzagoon = 
		CharacterEssentials.MakeCharactersFromList({
			{'Spheal', 'Left_Trio_1'},
			{'Jigglypuff', 'Left_Trio_2'},
			{'Marill', 'Left_Trio_3'},
			{'Mareep', 'Right_Duo_1'},
			{'Cranidos', 'Right_Duo_2'},
			{'Cleffa', 'Generic_Spawn_Duo_1'},
			{'Aggron', 'Generic_Spawn_Duo_2'},
			{'Cacnea', 480, 280, Direction.Left},
			{"Glameow", 512, 280, Direction.Left},
			{"Luxio", 544, 280, Direction.Left},
			{"Noctowl", 440, 272, Direction.Left},
			{"Growlithe"},
			{"Zigzagoon", 336, 336, Direction.Down}
		})
	
	GROUND:CharSetAnim(marill, 'Idle', true)
	GROUND:CharSetAnim(jigglypuff, 'Idle', true)
	GROUND:CharSetAnim(spheal, 'Idle', true)
	
	GROUND:CharSetAnim(cleffa, 'Idle', true)
	GROUND:CharSetAnim(aggron, 'Idle', true)

	GROUND:CharSetAnim(mareep, 'Idle', true)
	GROUND:CharSetAnim(cranidos, 'Idle', true)

	GROUND:CharSetAnim(zigzagoon, 'Idle', true)


	GAME:FadeIn(20)
	
	AI:SetCharacterAI(jigglypuff, "ai.ground_talking", true, 240, 60, 130, false, 'Default', {marill, spheal})
	AI:SetCharacterAI(marill, "ai.ground_talking", true, 240, 60, 0, false, 'Default', {jigglypuff})
	
	AI:SetCharacterAI(cleffa, "ai.ground_talking", true, 240, 60, 210, false, 'Angry', {aggron})
	--AI:SetCharacterAI(aggron, "ai.ground_talking", true, 240, 120, 110, false, 'Scared', {cleffa})
	
	AI:SetCharacterAI(mareep, "ai.ground_talking", true, 240, 60, 90, false, 'Default', {cranidos})
	
	AI:SetCharacterAI(zigzagoon, "ai.ground_default", RogueElements.Loc(320, 320), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
	

	GAME:WaitFrames(20)

	--wow look at all these pokemon
	--hero lags behind a bit because of their amazement
	GeneralFunctions.EmoteAndPause(hero, "Exclaim", true)
	UI:SetSpeaker('', false, hero.CurrentForm.Species, hero.CurrentForm.Form, hero.CurrentForm.Skin, hero.CurrentForm.Gender)
	UI:SetSpeakerEmotion("Surprised")
	local coro1 = TASK:BranchCoroutine(function()  GROUND:MoveToPosition(partner, 232, 304, false, 1) end)
	UI:WaitShowTimedDialogue("(Woah![pause=20] This place is huge!)", 80)
	TASK:JoinCoroutines({coro1})
	
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.WaitThenMove(hero, 264, 304, false, 1, 20) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(5) GROUND:CharAnimateTurn(partner, Direction.Up, 4, true) GeneralFunctions.FaceMovingCharacter(partner, hero) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) GAME:MoveCamera(256, 300, 92, false) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GAME:WaitFrames(6)
	
	--they converse a bit while waiting for Noctowl
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	GROUND:CharSetEmote(partner, 4, 0)
	UI:WaitShowDialogue("Haha,[pause=10] I was astounded when I stepped inside the guild for the first time too!")
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Normal")
	GROUND:CharSetEmote(partner, -1, 0)
	
	
	--team style will be leaving in the background while some talking and thinking happens.
	--it's strangely comforting because you're meant to be in a guild 
	
	coro1 = TASK:BranchCoroutine(function () guild_second_floor_ch_1.TeamStyleLeaving(cacnea, false) end)
	coro2 = TASK:BranchCoroutine(function () guild_second_floor_ch_1.TeamStyleLeaving(glameow, false) end)
	coro3 = TASK:BranchCoroutine(function () guild_second_floor_ch_1.TeamStyleLeaving(luxio, true) end)

	UI:WaitShowDialogue("It's a lot to take in,[pause=10] isn't it?[pause=0] All these Pokémon inside of a hollowed out tree!")
	GAME:WaitFrames(20)
	GeneralFunctions.LookAround(hero, 2, 4, true, false, false, Direction.Left)
	GeneralFunctions.HeroDialogue(hero, "(It sure is a lot to take in...[pause=0] This certainly isn't what I was expecting...)", "Normal")
	GeneralFunctions.HeroDialogue(hero, "(I imagine most of these Pokémon are adventurers...)", "Normal")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(I have to say,[pause=10] the atmosphere here is strangely comforting for some reason though.)", "Normal")
	GeneralFunctions.HeroDialogue(hero, "(...I wonder why?)", "Worried")
	GAME:WaitFrames(40)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	GeneralFunctions.EmoteAndPause(partner, 'Sweating', true)
	
	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	UI:WaitShowDialogue("Hmm...[pause=0] I wonder where " .. noctowl:GetDisplayName() .. " is?[pause=0] I'm starting to get antsy...")
	GAME:WaitFrames(40)
	
	
	--noctowl conveniently arrives
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, -1, -1, -1, RogueEssence.Data.Gender.Unknown)
	coro1 = TASK:BranchCoroutine(function () GAME:WaitFrames(10) GeneralFunctions.EmoteAndPause(hero, "Exclaim", true) GROUND:CharAnimateTurnTo(hero, Direction.Right, 4) end)
	coro2 = TASK:BranchCoroutine(function () GAME:WaitFrames(10) GeneralFunctions.EmoteAndPause(partner, "Exclaim", false) end)
	UI:WaitShowTimedDialogue("You two![pause=20] Who just came in!", 60)
	
	TASK:JoinCoroutines({coro1, coro2})
	
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(hero, noctowl, 4, Direction.Up) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(partner, noctowl, 4, Direction.Up) end)
	coro3 = TASK:BranchCoroutine(function()  GROUND:MoveToPosition(noctowl, 248, 272, false, 1) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	GROUND:EntTurn(partner, Direction.Up)
	GROUND:CharAnimateTurnTo(noctowl, Direction.Down, 4)

	
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, noctowl.CurrentForm.Species, noctowl.CurrentForm.Form, noctowl.CurrentForm.Skin, noctowl.CurrentForm.Gender)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Greetings![pause=0] As you may already know,[pause=10] my name is " .. noctowl:GetDisplayName() .. ".")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(growlithe:GetDisplayName() .. " informed me that two Pokémon were coming in who required me.[pause=0] That's the pair of you,[pause=10] correct?")
	GAME:WaitFrames(20)

	--todo: do a little hop
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("Y-yes![pause=0] That would be us!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("I see.[pause=0] What can I assist the two of you with?")
	
	--partner is still nervous
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("The t-two of us are here to...")
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("T-to...")
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(partner, "Sweating", true)
	UI:SetSpeakerEmotion("Stunned")
	UI:WaitShowDialogue("Uh...")
	
	--UI:SetSpeakerEmotion("Pain")
	--UI:WaitShowDialogue("(C'mon![pause=0] I can't wuss out now![pause=0] Just ask!)")
	
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(hero, "Notice", true)
	
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GeneralFunctions.HeroDialogue(hero, "(" .. partner:GetDisplayName() .. " is all tensed up.[pause=0] " .. GeneralFunctions.GetPronoun(partner, "they're", true) .. " too nervous to speak.)", "Normal")
	GeneralFunctions.HeroDialogue(hero, "(I'd better say something...)", "Normal")
	
	
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	GAME:WaitFrames(20)
	GeneralFunctions.HeroSpeak(hero, 60)
	GAME:WaitFrames(20)
	
	--both are shocked by hero suddenly speaking up, though noctowl is because of the request rather than hero speaking
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(partner, "Exclaim", false) GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(noctowl, "Exclaim", true) end)
	TASK:JoinCoroutines({coro1, coro2})
	
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("Oh?[pause=0] You wish to apprentice here at the guild?")
	
	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	GAME:WaitFrames(12)
	
	--todo: do a little hop
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Y-yes![pause=0] T-that's right!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(noctowl)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Oh,[pause=10] I believe I recall.")
	GROUND:CharAnimateTurnTo(noctowl, Direction.DownLeft, 4)
	GAME:WaitFrames(16)
	
	UI:WaitShowDialogue("You've been here before haven't you?[pause=0] " .. partner:GetDisplayName() .. " wasn't it?")
	GeneralFunctions.EmoteAndPause(partner, 'Sweating', true)
	
	--yes ive been here before...
	GROUND:EntTurn(partner, Direction.UpRight)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion('Sad')
	UI:WaitShowDialogue("Y-yes sir...")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Aha,[pause=10] I remember now.[pause=0] You tried to apply here before but didn't have a partner.")
	
	GROUND:CharAnimateTurnTo(noctowl, Direction.DownRight, 4)
	GAME:WaitFrames(12)
	UI:WaitShowDialogue("Looks like you've managed to locate one though,[pause=10] hmm?")
	GAME:WaitFrames(20)
	GROUND:EntTurn(hero, Direction.UpLeft)
	UI:WaitShowDialogue("What would your name be?")
	
	--tell noctowl your name
	GAME:WaitFrames(20)
	GeneralFunctions.HeroSpeak(hero, 60)
	GAME:WaitFrames(20)
	
	UI:WaitShowDialogue("Ah...[pause=0] So " .. hero:GetDisplayName() .. " is your name...")
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("It is a pleasure to meet you,[pause=10] " .. hero:GetDisplayName() .. ".")
	GAME:WaitFrames(20)
	GROUND:EntTurn(noctowl, Direction.Down)	

	
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("On to business...[pause=0] As it so happens,[pause=10] we have one opening for a team to apprentice at the guild.")

	GROUND:EntTurn(hero, Direction.Up)
	GROUND:EntTurn(partner, Direction.Up)
	GROUND:EntTurn(noctowl, Direction.Down)	
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(partner, "Exclaim", false) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(hero, "Exclaim", true) end)	
	TASK:JoinCoroutines({coro1, coro2})

	--there's an opening!
	--todo: two hops
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Inspired")
	GROUND:CharSetAnim(partner, 'Idle', true)
	UI:WaitShowDialogue("R-really!?")
	GAME:WaitFrames(20)
	GROUND:CharSetAnim(partner, 'None', true)	
	--todo: maybe have noctowl question the duo a bit more?

	
	UI:SetSpeaker(noctowl)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Indeed.[pause=0] However it's not up to me to decide.")
	UI:WaitShowDialogue("You will have to speak with the Guildmaster.[pause=0] He is the one who decides who may study here.")
	
	--todo: two hops
	GAME:WaitFrames(20)
	GROUND:CharSetAnim(partner, "Idle", true)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("Please take us to meet the Guildmaster then![pause=0] Please please please!")
	GAME:WaitFrames(20)
	GROUND:CharSetAnim(partner, "None", true)

	--I will take you to the guildmaster
	GROUND:CharSetEmote(noctowl, 4, 0)
	UI:SetSpeaker(noctowl)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Ho ho ho![pause=0] Aren't we an eager one?")
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(noctowl, -1, 0)
	UI:WaitShowDialogue("The Guildmaster is not always at the guild,[pause=10] but fortunately for you he is in his chambers right now.")
	UI:WaitShowDialogue("I will take you to him.[pause=0] But do bear in mind...")
	UI:WaitShowDialogue("...no-one is to be on the uppermost level except those associated with the guild.")
	UI:WaitShowDialogue("So please stay nearby me at all times.")
	UI:WaitShowDialogue("Additionally,[pause=10] you must treat the Guildmaster with the utmost respect.")
	UI:WaitShowDialogue("There will be consequences if you do not obey.[pause=0] Do you understand?")
	
	
	--todo: two hops
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Yes![pause=0] Of course!")
	
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)

	UI:WaitShowDialogue("Right,[pause=10] " .. hero:GetDisplayName() .. "?")
	GAME:WaitFrames(20)
	GeneralFunctions.DoAnimation(hero, "Nod")
	GAME:WaitFrames(20)
	
	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("Wonderful.[pause=0] Now,[pause=10] please follow me to the Guildmaster's chambers.")
	
	GAME:WaitFrames(20)
	
	--[[
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(40) 
								AI:EnableCharacterAI(partner)
								AI:SetCharacterAI(partner, "ai.ground_partner", noctowl, partner.Position) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(40) 
								GROUND:CharSetEmote(hero, 8, 1)
								GeneralFunctions.FaceMovingCharacter(hero, partner, 4, Direction.UpRight)
								AI:SetCharacterAI(hero, "ai.ground_partner", partner, partner.Position) end)
	--]]
	
	
	
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(noctowl, 520, 272, false, 1) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(52)
								GROUND:MoveInDirection(hero, Direction.UpRight, 32, false, 1)
								GROUND:MoveToPosition(hero, 500, 272, false, 1)  end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(60) 
								GROUND:MoveInDirection(partner, Direction.UpRight, 32, false, 1)
								GROUND:MoveToPosition(partner, 500, 272, false, 1) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(160) GAME:FadeOut(false, 20) end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	GAME:CutsceneMode(false)
	GAME:EnterGroundMap("guild_third_floor_lobby", "Main_Entrance_Marker")
--TASK:BranchCoroutine(guild_second_floor_ch_1.MeetNoctowl)

end



function guild_second_floor_ch_1.TeamStyleLeaving(chara, isLeader)
	GROUND:MoveToPosition(chara, 312, 280, false, 1)
	GROUND:MoveToPosition(chara, 248, 216, false, 1)
	if isLeader then 
		GROUND:CharAnimateTurnTo(chara, Direction.Down, 4)
		GAME:WaitFrames(60)
		GROUND:CharAnimateTurnTo(chara, Direction.Up, 4)
	end 
	GROUND:MoveToPosition(chara, 248, 160, false, 1)
	GROUND:Hide(chara.EntName)

end