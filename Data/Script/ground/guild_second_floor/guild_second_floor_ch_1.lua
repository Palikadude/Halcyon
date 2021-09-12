require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

guild_second_floor_ch_1 = {}




function guild_second_floor_ch_1.MeetNoctowl()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	GeneralFunctions.CenterCamera({hero, partner})
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
	
	AI:SetCharacterAI(cleffa, "ai.ground_talking", false, 240, 60, 210, false, 'Angry', {aggron})
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
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:CharAnimateTurn(partner, Direction.Up, 4, true) GeneralFunctions.FaceMovingCharacter(partner, hero) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) GAME:MoveCamera(256, 300, 92, false) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GAME:WaitFrames(6)
	
	--they converse a bit while waiting for Noctowl
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	GROUND:CharSetEmote(partner, 4, 0)
	UI:WaitShowDialogue("Haha,[pause=10] I was surprised when I stepped inside the guild for the first time too!")
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
	GeneralFunctions.HeroDialogue(hero, "(I have to say,[pause=10] this place is strangely comforting for some reason though.)", "Normal")
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
	UI:WaitShowDialogue("Looks like you've managed to find one though,[pause=10] hmm?")
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


function guild_second_floor_ch_1.SetupGround()
	local spheal, jigglypuff, marill, mareep, cranidos, cleffa, aggron, zigzagoon = 
		CharacterEssentials.MakeCharactersFromList({
			{'Spheal', 'Left_Trio_1'},
			{'Jigglypuff', 'Left_Trio_2'},
			{'Marill', 'Left_Trio_3'},
			{'Mareep', 'Right_Duo_1'},
			{'Cranidos', 'Right_Duo_2'},
			{'Cleffa', 'Generic_Spawn_Duo_1'},
			{'Aggron', 'Generic_Spawn_Duo_2'},
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
	
	AI:SetCharacterAI(jigglypuff, "ai.ground_talking", true, 240, 60, 130, false, 'Default', {marill, spheal})
	AI:SetCharacterAI(marill, "ai.ground_talking", true, 240, 60, 0, false, 'Default', {jigglypuff, spheal})
	AI:SetCharacterAI(spheal, "ai.ground_talking", true, 240, 60, 50, false, 'Default', {jigglypuff, marill})

	AI:SetCharacterAI(cleffa, "ai.ground_talking", false, 240, 60, 210, false, 'Angry', {aggron})
	--AI:SetCharacterAI(aggron, "ai.ground_talking", true, 240, 120, 110, false, 'Scared', {cleffa})
	
	AI:SetCharacterAI(mareep, "ai.ground_talking", true, 240, 60, 90, false, 'Default', {cranidos})
	
	AI:SetCharacterAI(zigzagoon, "ai.ground_default", RogueElements.Loc(320, 320), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
	
	GAME:FadeIn(20)
end




function guild_second_floor_ch_1.Cleffa_Action(chara, activator)
	UI:SetSpeaker(chara)
	UI:SetSpeakerEmotion('Angry')
	UI:WaitShowDialogue("You dolt![pause=0] We fainted back there because you aren't doing your job to protect me!")
	UI:WaitShowDialogue("How is Team ??? ever going to make a name for itself if you don't pick up the slack!")
end

function guild_second_floor_ch_1.Aggron_Action(chara, activator)
	UI:SetSpeaker(chara)
	UI:SetSpeakerEmotion('Sad')
	print(GAME:GetTeamName())
	UI:WaitShowDialogue("Sorry boss...[pause=0] I'll try to do better next time...")
end


function guild_second_floor_ch_1.Marill_Action(chara, activator)
	UI:SetSpeaker(chara)
	UI:SetSpeakerEmotion('Normal')
	local olddir = chara.Direction
	GROUND:CharTurnToChar(chara, CH('PLAYER'))
	UI:WaitShowDialogue("We're Team [color=#FFA5FF]Round[color]![pause=0] We're called that because we our signature attack is the move Round!")
	GROUND:EntTurn(chara, olddir)
end

function guild_second_floor_ch_1.Jigglypuff_Action(chara, activator)
	UI:SetSpeaker(chara)
	UI:SetSpeakerEmotion('Normal')
	local olddir = chara.Direction
	GROUND:CharTurnToChar(chara, CH('PLAYER'))
	UI:WaitShowDialogue("It's too late to go on a mission now,[pause=10] so we're figuring out which might be good to go on tomorrow.")
	GROUND:EntTurn(chara, olddir)
end

function guild_second_floor_ch_1.Spheal_Action(chara, activator)
	UI:SetSpeaker(chara)
	UI:SetSpeakerEmotion('Normal')
	local olddir = chara.Direction
	GROUND:CharTurnToChar(chara, CH('PLAYER'))
	UI:WaitShowDialogue("Not every team works directly for the guild.")
	UI:WaitShowDialogue("A lot of teams,[pause=10] like mine,[pause=10] come to the guild to take jobs from the boards here.")
	GROUND:EntTurn(chara, olddir)
end


function guild_second_floor_ch_1.Zigzagoon_Action(chara, activator)
	local zigzagoon = chara
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	
	UI:SetSpeaker(zigzagoon)
	UI:SetSpeakerEmotion("Normal")
	

	if not SV.Chapter1.MetZigzagoon then
		GROUND:CharTurnToCharAnimated(hero, zigzagoon, 4)
		GROUND:CharTurnToCharAnimated(zigzagoon, hero, 4)
		GROUND:CharTurnToChar(partner, zigzagoon)
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, zigzagoon.CurrentForm.Species, zigzagoon.CurrentForm.Form, zigzagoon.CurrentForm.Skin, zigzagoon.CurrentForm.Gender)
		UI:WaitShowDialogue("Um...[pause=0] I don't think I've seen you around before.[pause=0] Are you guys a new adventuring team?")
		
		GAME:WaitFrames(20)
		UI:SetSpeakerEmotion("Happy")
		UI:SetSpeaker(partner)
		UI:WaitShowDialogue("Yes![pause=0] We're Team " .. GAME:GetTeamName() .. "![pause=0] We just joined the guild today!")
		
		GROUND:CharTurnToCharAnimated(zigzagoon, partner)
		GAME:WaitFrames(10)
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, zigzagoon.CurrentForm.Species, zigzagoon.CurrentForm.Form, zigzagoon.CurrentForm.Skin, zigzagoon.CurrentForm.Gender)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("Oh,[pause=10] good.[pause=0] I was worried I had forgotten someone I'd met before.[pause=0] I'm pretty bad with faces.")
		GAME:WaitFrames(40)
		GeneralFunctions.EmoteAndPause(zigzagoon, "Exclaim", true)
		UI:SetSpeakerEmotion("Surprised")
		UI:WaitShowDialogue("Wait,[pause=10] did you just say you signed up with the guild?")
		
		GAME:WaitFrames(20)
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("That's right!")
		
		GAME:WaitFrames(20)
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, zigzagoon.CurrentForm.Species, zigzagoon.CurrentForm.Form, zigzagoon.CurrentForm.Skin, zigzagoon.CurrentForm.Gender)
		UI:WaitShowDialogue("That means we're guildmates![pause=0] I'm " .. zigzagoon:GetDisplayName() .. "![pause=0] I was the newest member at the guild until you two joined.")
		UI:SetSpeaker(zigzagoon)
		UI:SetSpeakerEmotion("Inspired")
		UI:WaitShowDialogue("It'll be nice not being the biggest rookie anymore...[pause=0] " .. CH('Cranidos'):GetDisplayName() .. " might not pick on me as much now...")
		GAME:WaitFrames(20)
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue("I hope he doesn't start bullying you now...[pause=0] He's a real jerk sometimes...")
		GAME:WaitFrames(20)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("Enough about him though...[pause=0] What are your names?")
		
		GAME:WaitFrames(20)
		UI:SetSpeaker(partner)
		UI:WaitShowDialogue("My name's " .. partner:GetDisplayName() .. ",[pause=10] and my partner here is " .. hero:GetDisplayName() ..".")
		
		
		GAME:WaitFrames(20)
		UI:SetSpeaker(zigzagoon)
		UI:WaitShowDialogue(partner:GetDisplayName() .." and " .. hero:GetDisplayName() .. ".[pause=0] OK,[pause=10] got it.[pause=0] I'll be real careful not to forget those names!")
		SV.Chapter1.MetZigzagoon = true
	end
	GROUND:CharTurnToChar(zigzagoon, hero)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("I'm looking forward to training at the guild here with you,[pause=10] Team " .. GAME:GetTeamName() .. "!")
	UI:WaitShowDialogue("We're all gonna learn how to be great adventurers!")
	
end	



function guild_second_floor_ch_1.Cranidos_Action(chara, activator)
	local cranidos = chara
	local mareep = CH('Mareep')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	
	
	if not SV.Chapter1.MetCranidosMareep then 
		GAME:FadeOut(false, 20)
		AI:DisableCharacterAI(partner)
		AI:DisableCharacterAI(mareep)
		GROUND:TeleportTo(hero, 408, 280, Direction.Up)
		GROUND:TeleportTo(partner, 376, 280, Direction.UpRight)
		GAME:CutsceneMode(true)
		GROUND:EntTurn(mareep, Direction.Up)
		GROUND:CharSetEmote(mareep, -1, 0)
		GROUND:CharSetAnim(cranidos, 'None', true)--cutscene mode wasn't changing their anims for some reason automatically
		GROUND:CharSetAnim(mareep, 'None', true)
		GAME:FadeIn(20)
		
		
		UI:SetSpeaker(cranidos)
		UI:SetSpeakerEmotion("Normal")
		--GROUND:CharTurnToCharAnimated(hero, cranidos, 4)
		GROUND:CharTurnToCharAnimated(cranidos, hero, 4)
		--GROUND:CharTurnToCharAnimated(partner, cranidos, 4)
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, cranidos.CurrentForm.Species, cranidos.CurrentForm.Form, cranidos.CurrentForm.Skin, cranidos.CurrentForm.Gender)

		UI:WaitShowDialogue("What do you want?[pause=0] Can't you see I'm doing something here?")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(partner)
		UI:WaitShowTimedDialogue(hero:GetDisplayName() .. " here and I just joined the guild,[pause=10] so we're-", 40)
		GAME:WaitFrames(20)

		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, cranidos.CurrentForm.Species, cranidos.CurrentForm.Form, cranidos.CurrentForm.Skin, cranidos.CurrentForm.Gender)
		GROUND:CharTurnToCharAnimated(cranidos, partner, 4)
		UI:WaitShowDialogue("Wait,[pause=10] YOU guys were allowed into the guild?[pause=0] What a laugh!")
		UI:WaitShowDialogue("The Guildmaster's just letting anyone in,[pause=10] isn't he?")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue("Huh?")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, cranidos.CurrentForm.Species, cranidos.CurrentForm.Form, cranidos.CurrentForm.Skin, cranidos.CurrentForm.Gender)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("I mean,[pause=10] look at you![pause=0] Total rookies![pause=0] Have you even done any adventuring?")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Determined")
		GeneralFunctions.Hop(partner)
		UI:WaitShowDialogue("O-Of course we have!")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, cranidos.CurrentForm.Species, cranidos.CurrentForm.Form, cranidos.CurrentForm.Skin, cranidos.CurrentForm.Gender)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("Ha![pause=0] Like I believe that![pause=0] I can just tell that you're complete and total rookies!")
		GROUND:CharSetEmote(cranidos, 4, 0)
		UI:SetSpeakerEmotion("Joyous")
		UI:WaitShowDialogue("And that look on your face![pause=0] You're all flustered![pause=0] Hahaha!")
		GROUND:CharSetEmote(cranidos, -1, 0)
		GAME:WaitFrames(20)
		
		GROUND:CharSetEmote(hero, 3, 1)
		GAME:WaitFrames(10)
		GeneralFunctions.EmoteAndPause(partner, 'Angry', true)
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Determined")
		UI:WaitShowDialogue("W-what's your deal?[pause=0] We're just trying to say h-hello to you!")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, cranidos.CurrentForm.Species, cranidos.CurrentForm.Form, cranidos.CurrentForm.Skin, cranidos.CurrentForm.Gender)
		UI:SetSpeakerEmotion("Angry")
		GROUND:CharSetEmote(cranidos, 7, 0)
		UI:WaitShowDialogue("My DEAL is that I have no respect for a bunch of greenhorns like you!")
		UI:WaitShowDialogue("Especially when they waltz in here and bother me while I'm scouting outlaws!")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Angry")
		GROUND:CharSetEmote(partner, 7, 0)
		UI:WaitShowDialogue("Are you serious?[pause=0] Being this rude just because we're new?")
		GAME:WaitFrames(40)
		
		AI:DisableCharacterAI(mareep)
		GROUND:CharSetAnim(mareep, "None", true)
		GeneralFunctions.EmoteAndPause(mareep, "Exclaim", true)
		GROUND:CharTurnToCharAnimated(mareep, cranidos, 4)
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, mareep.CurrentForm.Species, mareep.CurrentForm.Form, mareep.CurrentForm.Skin, mareep.CurrentForm.Gender)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("Is something the maaaaaatter, " .. cranidos:GetDisplayName() .. "?")
		GAME:WaitFrames(20)
		
		GROUND:CharSetEmote(partner, -1, 0)
		GeneralFunctions.EmoteAndPause(cranidos, "Exclaim", true)
		GROUND:CharSetEmote(cranidos, 5, 1)
		UI:SetSpeaker(cranidos)
		UI:SetSpeakerEmotion("Surprised")
		GROUND:CharTurnToCharAnimated(cranidos, mareep, 4)
		UI:WaitShowDialogue("N-nope![pause=0] I was just having a conversation with the guild's newest recruits!")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, mareep.CurrentForm.Species, mareep.CurrentForm.Form, mareep.CurrentForm.Skin, mareep.CurrentForm.Gender)
		UI:SetSpeakerEmotion("Inspired")
		GROUND:CharSetAnim(mareep, "Idle", true)
		UI:WaitShowDialogue("Oooh![pause=0] There's new recruits!?[pause=0] Where are they?")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(cranidos)
		UI:SetSpeakerEmotion("Stunned")
		UI:WaitShowDialogue("Err...")
		GROUND:CharTurnToCharAnimated(cranidos, hero, 4)
		UI:WaitShowDialogue("They're right here.")
		GAME:WaitFrames(20)
		
		GROUND:CharSetAnim(mareep, "None", true)
		GROUND:CharTurnToCharAnimated(mareep, hero, 4)
		GROUND:CharTurnToChar(hero, mareep)
		GROUND:CharTurnToChar(partner, mareep)
		GeneralFunctions.Hop(mareep)
		GeneralFunctions.Hop(mareep)
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, mareep.CurrentForm.Species, mareep.CurrentForm.Form, mareep.CurrentForm.Skin, mareep.CurrentForm.Gender)
		UI:SetSpeakerEmotion("Happy")
		GROUND:CharSetEmote(mareep, 1, 0)
		UI:WaitShowDialogue("You're the new recruits?[pause=0] Hi hi hi![pause=0] It's greaaaaaat to meet you![pause=0] My name's " .. mareep:GetDisplayName() .. "!")
		GAME:WaitFrames(20)
		GROUND:CharSetEmote(mareep, -1, 0)
		
		GROUND:CharTurnToCharAnimated(mareep, cranidos, 4)
		UI:SetSpeaker(mareep)
		UI:WaitShowDialogue("And this sweetie is " .. cranidos:GetDisplayName() .. "!")
		GAME:WaitFrames(40)
		
		GROUND:CharSetEmote(partner, 9, 1)
		GeneralFunctions.EmoteAndPause(hero, 'Sweatdrop', true)
		GeneralFunctions.HeroDialogue(hero, "(Sweetie?)", "Stunned")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(mareep)
		UI:SetSpeakerEmotion("Normal")
		GROUND:CharTurnToCharAnimated(mareep, partner, 4)
		UI:WaitShowDialogue("What are your names?[pause=0] Ooooooh,[pause=10] I bet you have a cool team name!")
		GAME:WaitFrames(20)
		
		
		GROUND:CharTurnToCharAnimated(partner, mareep, 4)
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Stunned")
		UI:WaitShowDialogue("Err...[pause=0] My name is " .. partner:GetDisplayName() .. " and my friend here is " .. hero:GetDisplayName() .. ".[pause=0] We're Team " .. GAME:GetTeamName() ..".")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(mareep)
		GeneralFunctions.Hop(mareep)
		UI:SetSpeakerEmotion("Happy")
		GROUND:CharSetEmote(mareep, 1, 0)
		UI:WaitShowDialogue("Greaaaaaat to meet the both of you![pause=0] And I like your team name!")
		UI:WaitShowDialogue(GAME:GetTeamName() .. "![pause=0] Just rolls off the tongue!")
		GROUND:CharSetEmote(mareep, -1, 0)
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(partner)
		GeneralFunctions.Hop(partner)
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("Oh,[pause=10] thank you![pause=0] I'm happy to meet you too!")
		GAME:WaitFrames(60)
		
		GeneralFunctions.EmoteAndPause(mareep, "Notice", true)
		GROUND:CharTurnToCharAnimated(mareep, cranidos, 4)
		UI:SetSpeaker(mareep)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue(cranidos:GetDisplayName() .. "?[pause=0] Aren't you going to say something to our new friends?")
		GAME:WaitFrames(20)
		
		GeneralFunctions.EmoteAndPause(cranidos, "Exclaim", true)
		GROUND:CharTurnToCharAnimated(cranidos, mareep, 4)
		UI:SetSpeaker(cranidos)
		UI:SetSpeakerEmotion("Surprised")
		UI:WaitShowDialogue("O-of course!")
		GAME:WaitFrames(20)
		
		GROUND:CharTurnToCharAnimated(cranidos, hero)
		GROUND:CharTurnToChar(hero, cranidos)
		GROUND:CharTurnToChar(partner, cranidos)
		UI:SetSpeakerEmotion("Pain")
		UI:WaitShowDialogue(".........[pause=0] It's...")
		GROUND:EntTurn(cranidos, Direction.DownRight)
		UI:WaitShowDialogue("...nice to meet the both of you.")
		GAME:WaitFrames(20)
		
		GROUND:CharSetEmote(partner, 9, 1)
		GeneralFunctions.EmoteAndPause(hero, 'Sweatdrop', true)
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Stunned")
		UI:WaitShowDialogue("...[pause=0] Likewise...")
		GAME:WaitFrames(20)
		
		GROUND:CharTurnToCharAnimated(mareep, partner, 4)
		GAME:WaitFrames(20)
		GROUND:CharTurnToCharAnimated(mareep, cranidos, 4)
		GAME:WaitFrames(20)
		GROUND:CharTurnToCharAnimated(mareep, partner, 4)
		GAME:WaitFrames(20)
		GROUND:CharTurnToCharAnimated(mareep, cranidos, 4)		
		GAME:WaitFrames(20)
		GROUND:CharTurnToCharAnimated(mareep, partner, 4)
		GAME:WaitFrames(20)
		GeneralFunctions.EmoteAndPause(mareep, "Question", true)
		UI:SetSpeaker(mareep)
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue("Is something wrong?")
		GAME:WaitFrames(20)
		GROUND:CharTurnToCharAnimated(mareep, cranidos, 4)
		GROUND:CharTurnToChar(hero, mareep)
		GROUND:CharTurnToChar(partner, mareep)
		UI:WaitShowDialogue(cranidos:GetDisplayName() .. " wasn't being a meaaaaaanie again,[pause=10] was he?")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Stunned")
		GROUND:CharSetEmote(partner, 5, 1)
		UI:WaitShowDialogue("Oh,[pause=10] uh,[pause=10] no![pause=0] Everything's fine!")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(mareep)
		UI:SetSpeakerEmotion("Happy")
		GROUND:CharTurnToCharAnimated(mareep, partner, 4)
		UI:WaitShowDialogue("Oh,[pause=10] good![pause=0] I was afraid he was being a big meaaaaaanie again!")
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("He can get really grumpy whenever we have trouble bringing in a crook.[pause=0] Today's was a slippery one!")
		GROUND:CharTurnToCharAnimated(mareep, cranidos, 4)
		UI:WaitShowDialogue("Isn't that right,[pause=10] " .. cranidos:GetDisplayName() .. "?")
		GAME:WaitFrames(20)
		
		GROUND:CharTurnToChar(hero, cranidos)
		GROUND:CharTurnToChar(partner, cranidos)
		GeneralFunctions.EmoteAndPause(cranidos, "Sweating", true)
		GROUND:CharAnimateTurnTo(cranidos, Direction.Up, 2)
		UI:SetSpeaker(cranidos)
		UI:SetSpeakerEmotion("Stunned")
		UI:WaitShowDialogue(".........")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(mareep)
		GROUND:CharTurnToCharAnimated(mareep, partner, 4)
		GROUND:CharTurnToChar(hero, mareep)
		GROUND:CharTurnToChar(partner, mareep)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("Well,[pause=10] don't mind him.[pause=0] He gets real shy sometimes.")
		GAME:WaitFrames(20)
		
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("Aaaaaanyway...[pause=0] You're gonna have a lot of fun working with the guild!")
		UI:WaitShowDialogue("We're gonna do all sorts of fun stuff together now that you've joined!")
		UI:WaitShowDialogue("Me and " .. cranidos:GetDisplayName() .. " can even show you some ways to take down bad guys sometime![pause=0] We'll have a blaaaaaast!")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("That sounds great " .. mareep:GetDisplayName() .. "![pause=0] I can't wait!")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(mareep)
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("Good luck you two![pause=0] It's back to finding tomorrow's baaaaaaddie to beat for me now!")
		GAME:WaitFrames(20)
		
		GROUND:CharAnimateTurnTo(mareep, Direction.Up, 4)
		GAME:CutsceneMode(false)
		GROUND:CharSetAnim(cranidos, 'Idle', true)
		GROUND:CharSetAnim(mareep, 'Idle', true)
		AI:EnableCharacterAI(partner)
		AI:EnableCharacterAI(mareep)
		SV.Chapter1.MetCranidosMareep = true
	else
		UI:SetSpeaker(cranidos)
		UI:SetSpeakerEmotion("Determined")
		UI:WaitShowDialogue(".........")
		GAME:WaitFrames(20)
	
		GeneralFunctions.Monologue("(" .. cranidos:GetDisplayName() .. " is ignoring you.)")
	end
end

function guild_second_floor_ch_1.Mareep_Action(chara, activator)
	local mareep = chara
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	if not SV.Chapter1.MetCranidosMareep then
		UI:SetSpeaker(mareep)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("Ooh,[pause=10] what about this job?[pause=0] This outlaaaaaaw seems like a real jerk![pause=0] Let's bring 'em in!")
		GAME:WaitFrames(20)
		GeneralFunctions.Monologue("(She's too invested in the job board to notice you.)")
	else 
		UI:SetSpeaker(mareep)
		UI:SetSpeakerEmotion("Happy")
		GROUND:CharTurnToChar(mareep, hero)
		UI:WaitShowDialogue("You're gonna have a lot of fun working with the guild!")
		UI:WaitShowDialogue("We're gonna do all sorts of fun stuff together now that you've joined!")
		UI:WaitShowDialogue("Me and " .. CH('Cranidos'):GetDisplayName() .. " can even show you some ways to take down bad guys sometime![pause=0] We'll have a blaaaaaast!")
		GROUND:EntTurn(mareep, Direction.Up)
	end
end
	

return guild_second_floor_ch_1