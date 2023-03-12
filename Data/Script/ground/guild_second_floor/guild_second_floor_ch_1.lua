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
	local spheal, jigglypuff, marill, mareep, cranidos, cleffa, aggron, cacnea, glameow, luxio, noctowl, zigzagoon = 
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


	GAME:FadeIn(40)
	
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
	UI:WaitShowTimedDialogue("(Woah![pause=30] This place is huge!)", 70)
	TASK:JoinCoroutines({coro1})
	
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.WaitThenMove(hero, 264, 304, false, 1, 20) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:CharAnimateTurn(partner, Direction.Up, 4, true) GeneralFunctions.FaceMovingCharacter(partner, hero) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) GAME:MoveCamera(256, 300, 84, false) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GAME:WaitFrames(6)
	
	--they converse a bit while waiting for Noctowl
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	GROUND:CharSetEmote(partner, "glowing", 0)
	UI:WaitShowDialogue("Haha,[pause=10] I was stunned when I stepped inside the guild for the first time too!")
	UI:WaitShowDialogue("It's surprising to see so many Pokémon inside this tree,[pause=10] right?")
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Normal")
	GROUND:CharSetEmote(partner, "", 0)
	
	
	--team style will be leaving in the background while some talking and thinking happens.
	--it's strangely comforting because you're meant to be in a guild 
	
	coro1 = TASK:BranchCoroutine(function () guild_second_floor_ch_1.TeamStyleLeaving(cacnea, false) end)
	coro2 = TASK:BranchCoroutine(function () guild_second_floor_ch_1.TeamStyleLeaving(glameow, false) end)
	coro3 = TASK:BranchCoroutine(function () guild_second_floor_ch_1.TeamStyleLeaving(luxio, true) end)

	GeneralFunctions.LookAround(hero, 2, 4, true, false, false, Direction.Left)
	GeneralFunctions.HeroDialogue(hero, "(It sure is a lot to take in...[pause=0] There's so many Pokémon...)", "Normal")
	GeneralFunctions.HeroDialogue(hero, "(I imagine most of these Pokémon are adventurers...)", "Normal")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(I have to say,[pause=10] I feel strangely comforted being here.)", "Normal")
	GeneralFunctions.HeroDialogue(hero, "(...I wonder why?)", "Worried")
	--GAME:WaitFrames(40)
	--UI:SetSpeaker(partner)
	--UI:SetSpeakerEmotion("Worried")
	--GeneralFunctions.EmoteAndPause(partner, 'Sweating', true)
	
	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	--UI:WaitShowDialogue("Hmm...[pause=0] I wonder where " .. noctowl:GetDisplayName() .. " is?")
	--UI:WaitShowDialogue("I'm getting anxious waiting to see him...")
	GAME:WaitFrames(40)
	
	
	--noctowl conveniently arrives
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	coro1 = TASK:BranchCoroutine(function () GAME:WaitFrames(10) GeneralFunctions.EmoteAndPause(hero, "Exclaim", true) GROUND:CharAnimateTurnTo(hero, Direction.Right, 4) end)
	coro2 = TASK:BranchCoroutine(function () GAME:WaitFrames(10) GeneralFunctions.EmoteAndPause(partner, "Exclaim", false) end)
	UI:WaitShowTimedDialogue("You two,[pause=20] who just came in!", 60)
	
	TASK:JoinCoroutines({coro1, coro2})
	
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(hero, noctowl, 4, Direction.Up) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(partner, noctowl, 4, Direction.Up) end)
	coro3 = TASK:BranchCoroutine(function()  GROUND:MoveToPosition(noctowl, 248, 272, false, 1) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	GROUND:EntTurn(partner, Direction.Up)
	GROUND:CharAnimateTurnTo(noctowl, Direction.Down, 4)

	
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, noctowl.CurrentForm.Species, noctowl.CurrentForm.Form, noctowl.CurrentForm.Skin, noctowl.CurrentForm.Gender)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Greetings.[pause=0] As you may already know,[pause=10] my name is " .. noctowl:GetDisplayName() .. ".")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue(CharacterEssentials.GetCharacterName("Growlithe") .. " informed me that two Pokémon were coming in who required me.[pause=0] That would be you two,[pause=10] correct?")
	GAME:WaitFrames(20)

	GeneralFunctions.Hop(partner)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("Y-yes![pause=0] That would be us!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("I see.[pause=0] What business do you have with the guild today?")
	
	--partner is still nervous
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("The t-two of us are here to...")
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("T-to...")
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(partner, "Sweating", true)
	UI:SetSpeakerEmotion("Stunned")
	UI:WaitShowDialogue("Um...")
	
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Pain")
	UI:WaitShowDialogue("(O-oh man,[pause=10] I'm t-too nervous to say anything...)")
	
	GAME:WaitFrames(40)
	GeneralFunctions.EmoteAndPause(hero, "Notice", true)
	
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GeneralFunctions.HeroDialogue(hero, "(" .. partner:GetDisplayName() .. " seems tensed up.[pause=0] " ..GeneralFunctions.GetPronoun(partner, "are", true) .. " " .. GeneralFunctions.GetPronoun(partner, "they", false) .. " too nervous to speak?)", "Normal")
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
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Surprised")
	GeneralFunctions.Hop(partner)
	UI:WaitShowDialogue("Y-yes![pause=0] T-that's right!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(noctowl)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Oh,[pause=10] I believe I recall now.")
	GROUND:CharAnimateTurnTo(noctowl, Direction.DownLeft, 4)
	GAME:WaitFrames(16)
	
	UI:WaitShowDialogue("You have been here before,[pause=10] have you not?[pause=0] " .. partner:GetDisplayName() .. " was it?")
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(partner, 'Sweating', true)
	
	--yes ive been here before...
	GROUND:EntTurn(partner, Direction.UpRight)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion('Sad')
	UI:WaitShowDialogue("Y-yes sir...")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Ahh,[pause=10] I remember now.[pause=0] You applied here before,[pause=10] but you didn't have a partner.")
	GAME:WaitFrames(10)
	
	GROUND:CharAnimateTurnTo(noctowl, Direction.DownRight, 4)
	GAME:WaitFrames(12)
	UI:WaitShowDialogue("Looks like you have managed to find one though,[pause=10] hmm?")
	GAME:WaitFrames(20)
	GROUND:EntTurn(hero, Direction.UpLeft)
	UI:WaitShowDialogue("What would your name be?")
	
	--tell noctowl your name
	GAME:WaitFrames(20)
	GeneralFunctions.HeroSpeak(hero, 60)
	GAME:WaitFrames(20)
	
	UI:WaitShowDialogue("Ah...[pause=0] So " .. hero:GetDisplayName() .. " is your name...")
	UI:WaitShowDialogue("A pleasure to make your acquaintance,[pause=10] " .. hero:GetDisplayName() .. ".")
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
	UI:WaitShowDialogue("Indeed.[pause=0] However,[pause=10] it is not up to me to decide.")
	UI:WaitShowDialogue("You would have to speak with the Guildmaster.[pause=0] He is the one who decides who may study here.")
	
	--todo: two hops
	GAME:WaitFrames(20)
	GROUND:CharSetAnim(partner, "Idle", true)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("Please let us speak with the Guildmaster then![pause=0] Please please please!")
	GAME:WaitFrames(20)
	GROUND:CharSetAnim(partner, "None", true)

	--I will take you to the guildmaster
	UI:SetSpeaker(noctowl)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Hmm...")
	GAME:WaitFrames(40)
	
	UI:WaitShowDialogue("Very well.[pause=0] I will take you to see the Guildmaster.")
	
	
	GAME:WaitFrames(20)
	GeneralFunctions.DoubleHop(partner)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Y-you will!?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("Yes.[pause=0] Now,[pause=10] please follow behind me to the Guildmaster's office.")
	
	GAME:WaitFrames(20)
	
	--[[
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(40) 
								AI:EnableCharacterAI(partner)
								AI:SetCharacterAI(partner, "ai.ground_partner", noctowl, partner.Position) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(40) 
								GROUND:CharSetEmote(hero, "shock", 1)
								GeneralFunctions.FaceMovingCharacter(hero, partner, 4, Direction.UpRight)
								AI:SetCharacterAI(hero, "ai.ground_partner", partner, partner.Position) end)
	--]]
	
	
	
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(noctowl, 520, 272, false, 1) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(54)
								GROUND:MoveInDirection(hero, Direction.UpRight, 32, false, 1)
								GROUND:MoveToPosition(hero, 500, 272, false, 1)  end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(58) 
								GROUND:MoveInDirection(partner, Direction.UpRight, 32, false, 1)
								GROUND:MoveToPosition(partner, 500, 272, false, 1) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(160) GAME:FadeOut(false, 40) end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	GAME:CutsceneMode(false)
	GAME:EnterGroundMap("guild_third_floor_lobby", "Main_Entrance_Marker")
--TASK:BranchCoroutine(guild_second_floor_ch_1.MeetNoctowl)

end



function guild_second_floor_ch_1.TeamStyleLeaving(chara, isLeader)
	GROUND:MoveToPosition(chara, 336, 280, false, 1)
	GROUND:MoveToPosition(chara, 272, 216, false, 1)
	if isLeader then 
		GROUND:CharAnimateTurnTo(chara, Direction.Down, 4)
		GAME:WaitFrames(60)
		GROUND:CharAnimateTurnTo(chara, Direction.Up, 4)
	end 
	GROUND:MoveToPosition(chara, 272, 160, false, 1)
	GROUND:Hide(chara.EntName)

end


function guild_second_floor_ch_1.SetupGround()
	local groundObj = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1), 
													RogueElements.Rect(184, 192, 144, 16),
													RogueElements.Loc(0, 0), 
													true, 
													"Event_Trigger_1")
	groundObj:ReloadEvents()
	GAME:GetCurrentGround():AddTempObject(groundObj)
	
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




function guild_second_floor_ch_1.Event_Trigger_1_Touch(obj, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GeneralFunctions.StartPartnerConversation("Hey,[pause=10] " .. hero:GetDisplayName() .. ",[pause=10] where are you going?")
	GAME:WaitFrames(10)
	UI:WaitShowDialogue("I know you might want to look around town...")
	UI:WaitShowDialogue("But since we just joined,[pause=10] I don't think we should leave the tree tonight.")
	if SV.Chapter1.MetSnubbull and SV.Chapter1.MetZigzagoon and SV.Chapter1.MetCranidosMareep and SV.Chapter1.MetBreloomGirafarig and SV.Chapter1.MetAudino then
		UI:WaitShowDialogue("Plus it's getting late...[pause=0] We should probably head to bed now actually.")
		UI:WaitShowDialogue("But we can look around a bit more if you want!")
	else 
		UI:WaitShowDialogue("Let's go look around the guild some more.[pause=0] I think there's more guildmates for us to meet!")
	end
	GAME:WaitFrames(20)
	GeneralFunctions.EndConversation(partner)
end



function guild_second_floor_ch_1.Cleffa_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "You dolt![pause=0] We couldn't reach the end because you aren't doing your part!", "Angry", false)
	UI:WaitShowDialogue("How is Team [color=#FFA5FF]Starlight[color] ever going to make a name for itself if you don't pick up the slack!")
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_1.Aggron_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Sorry boss...[pause=0] I'll try to do better next time...", "Sad", false)
	GeneralFunctions.EndConversation(chara)
end


function guild_second_floor_ch_1.Marill_Action(chara, activator)
	local move = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Skill]:Get("round")--healbell
	GeneralFunctions.StartConversation(chara, "We're Team [color=#FFA5FF]Round[color]![pause=0] We're called that because our signature attack is the move " .. move:GetColoredName() .. "!")
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_1.Jigglypuff_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Not all adventuring teams work for the guild.")
	UI:WaitShowDialogue("Some teams,[pause=10] like ours,[pause=10] come here to find jobs posted on the boards.")
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_1.Spheal_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Let's hurry up and find tomorrow's job,[pause=10] guys...")
	UI:WaitShowDialogue("It's getting late and I wanna eeeeeaaatttt![pause=0] I'm starving!")
	GeneralFunctions.EndConversation(chara)
end


function guild_second_floor_ch_1.Zigzagoon_Action(chara, activator)
	local zigzagoon = chara
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	

	if not SV.Chapter1.MetZigzagoon then
	

		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, zigzagoon.CurrentForm.Species, zigzagoon.CurrentForm.Form, zigzagoon.CurrentForm.Skin, zigzagoon.CurrentForm.Gender)
		GeneralFunctions.StartConversation(zigzagoon, "Um...[pause=0] I don't think I've seen you around before.[pause=0] Are you guys a new adventuring team?", "Normal", true, true, false)
		
		GAME:WaitFrames(20)
		UI:SetSpeakerEmotion("Happy")
		UI:SetSpeaker(partner)
		UI:WaitShowDialogue("Yeah![pause=0] We're Team " .. GAME:GetTeamName() .. "![pause=0] We just joined the guild today!")
		
		GROUND:CharTurnToCharAnimated(zigzagoon, partner)
		GAME:WaitFrames(10)
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, zigzagoon.CurrentForm.Species, zigzagoon.CurrentForm.Form, zigzagoon.CurrentForm.Skin, zigzagoon.CurrentForm.Gender)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("Hmm,[pause=10] OK.[pause=0] I was worried there was a local team I hadn't documented in my almanac.")
		UI:WaitShowDialogue("I didn't recognize your faces,[pause=10] so I thought maybe I missed a team.")
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
		GeneralFunctions.DoubleHop(zigzagoon)
		GROUND:CharSetAnim(zigzagoon, "None", true)--we're not in cutscene mode so this needs to be set again after hopping
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("Then that means we're guildmates![pause=0] I'm " .. zigzagoon:GetDisplayName() .. "![pause=0] I was the newest member at the guild before you two came along.")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(zigzagoon)
		UI:SetSpeakerEmotion("Inspired")
		UI:WaitShowDialogue("This is great![pause=0] I finally have juniors that I can teach stuff to!")
		UI:WaitShowDialogue("I'll have to show you guys my almanac,[pause=10] I think maybe you could learn a lot from it!")
		GAME:WaitFrames(20)
		
		GeneralFunctions.EmoteAndPause(partner, "Question", true)
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue("Almanac?")
		GAME:WaitFrames(20)
	
		UI:SetSpeaker(zigzagoon)
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("Yeah![pause=0] Everything I learn about adventuring I write down in my almanac!")--todo: hop at the end of this
		UI:WaitShowDialogue("Adventuring teams,[pause=10] expedition discoveries,[pause=10] and dungeoneering techniques and knowledge!")
		UI:WaitShowDialogue("It's all in my almanac so that myself and others can all learn everything there is to know about adventuring!")
		GAME:WaitFrames(20)
	
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Inspired")
		UI:WaitShowDialogue("Wow,[pause=10] that's amazing!")
		UI:WaitShowDialogue("I bet me and " .. hero:GetDisplayName() .. " could learn a lot of useful things from something like that!")
		GAME:WaitFrames(20)
		
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("When do you think we could look at your almanac?")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(zigzagoon)
		UI:SetSpeakerEmotion("Joyous")
		--GeneralFunctions.DoubleHop(zigzagoon)
		GROUND:CharSetEmote(zigzagoon, "glowing", 0)
		--SOUND:PlayBattleSE('EVT_Emote_Startled_2')
		UI:WaitShowDialogue("Anytime you want![pause=0] I'm always happy to share everything I've documented!")
		GAME:WaitFrames(20)
		GROUND:CharSetEmote(zigzagoon, "", 0)
		
		UI:SetSpeakerEmotion('Normal')
		UI:WaitShowDialogue("But just so you know,[pause=10] there's actually a few books I write stuff in.")
		UI:WaitShowDialogue("It helps me keep the information more organized.[pause=0] Each book is for a different topic!")		
		UI:WaitShowDialogue("Since I'm still kinda new,[pause=10] there isn't too much in them yet...")
		UI:WaitShowDialogue("But I add to them as I learn![pause=0] So I'm sure soon enough there'll be more pages than you can count!")
		GAME:WaitFrames(20)
		
		UI:WaitShowDialogue("Anyway,[pause=10] I keep them in my room.[pause=0] Feel free to read through them anytime...[pause=0] Err...")
		GeneralFunctions.EmoteAndPause(zigzagoon, 'Sweatdrop', true)
		UI:WaitShowDialogue("Hmm.[pause=0] I,[pause=10] um,[pause=10] never got your names.")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(partner)
		UI:WaitShowDialogue("My name's " .. partner:GetDisplayName() .. ",[pause=10] and my partner over there is " .. hero:GetDisplayName() ..".")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(zigzagoon)
		UI:WaitShowDialogue(partner:GetDisplayName() .." and " .. hero:GetDisplayName() .. ".[pause=0] OK,[pause=10] I'll have to make a note of that!")
		SV.Chapter1.MetZigzagoon = true
	
		GROUND:CharTurnToChar(zigzagoon, hero)
		GAME:WaitFrames(10)
		GeneralFunctions.Hop(zigzagoon)
		GROUND:CharSetAnim(zigzagoon, "None", true)--we're not in cutscene mode so this needs to be set again after hopping
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("I'm looking forward to learning and training at the guild here with you,[pause=10] Team " .. GAME:GetTeamName() .. "!")
		UI:WaitShowDialogue("We're all gonna learn how to be great adventurers![pause=0] I just know it!")
		
		
		--every guildmate is talked to, signal player that they can go sleep now
		if SV.Chapter1.MetSnubbull and SV.Chapter1.MetZigzagoon and SV.Chapter1.MetCranidosMareep and SV.Chapter1.MetBreloomGirafarig and SV.Chapter1.MetAudino then
			GAME:WaitFrames(60)
			GROUND:CharTurnToCharAnimated(partner, hero, 4)
			UI:SetSpeaker(partner)
			UI:SetSpeakerEmotion("Normal")
			UI:WaitShowDialogue("Hey " .. hero:GetDisplayName() .. "...[pause=0] It's getting pretty late...")
			GROUND:CharTurnToCharAnimated(hero, partner, 4)
			GAME:WaitFrames(12)
			UI:WaitShowDialogue("We should probably head back to our room and hit the hay for the night.")
			UI:WaitShowDialogue("Let's head there whenever you're ready,[pause=10] " .. hero:GetDisplayName() .. ".")
		end
		
		GeneralFunctions.EndConversation(zigzagoon)
	else
		GeneralFunctions.StartConversation(chara, "I'm looking forward to training at the guild here with you,[pause=10] Team " .. GAME:GetTeamName() .. "!", "Happy")
		UI:WaitShowDialogue("We're all gonna learn how to be great adventurers![pause=0] I just know it!")
		GeneralFunctions.EndConversation(chara)
	end
	
	
end	



function guild_second_floor_ch_1.Cranidos_Action(chara, activator)
	local cranidos = chara
	local mareep = CH('Mareep')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	
	if not SV.Chapter1.MetCranidosMareep then 
		GAME:FadeOut(false, 40)
		AI:DisableCharacterAI(partner)
		AI:DisableCharacterAI(mareep)
		GROUND:TeleportTo(hero, 408, 280, Direction.Up)
		GROUND:TeleportTo(partner, 376, 280, Direction.UpRight)
		GAME:MoveCamera(400, 272, 1, false)
		GAME:CutsceneMode(true)
		GROUND:EntTurn(mareep, Direction.Up)
		GROUND:CharSetEmote(mareep, "", 0)
		GROUND:CharSetAnim(cranidos, 'None', true)
		GROUND:CharSetAnim(mareep, 'None', true)--cutscene mode wasn't changing their anims for some reason automatically
		GROUND:CharSetAnim(CH('Zigzagoon'), "Idle", true)

		partner.IsInteracting = true
		GAME:FadeIn(40)
		
		
		UI:SetSpeaker(cranidos)
		UI:SetSpeakerEmotion("Normal")
		--GROUND:CharTurnToCharAnimated(hero, cranidos, 4)
		GROUND:CharTurnToCharAnimated(cranidos, hero, 4)
		--GROUND:CharTurnToCharAnimated(partner, cranidos, 4)
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, cranidos.CurrentForm.Species, cranidos.CurrentForm.Form, cranidos.CurrentForm.Skin, cranidos.CurrentForm.Gender)

		UI:WaitShowDialogue("What do you want?[pause=0] Can't you see I'm doing something here?")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(partner)
		UI:WaitShowTimedDialogue("My partner here and I just joined the guild,[pause=10] so we're-", 40)
		GAME:WaitFrames(20)

		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, cranidos.CurrentForm.Species, cranidos.CurrentForm.Form, cranidos.CurrentForm.Skin, cranidos.CurrentForm.Gender)
		GROUND:CharTurnToCharAnimated(cranidos, partner, 4)
		SOUND:FadeOutBGM(120)
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
		UI:SetSpeakerEmotion("Sad")
		UI:WaitShowTimedDialogue("Only a little,[pause=10] but-", 60)
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, cranidos.CurrentForm.Species, cranidos.CurrentForm.Form, cranidos.CurrentForm.Skin, cranidos.CurrentForm.Gender)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("A little?[pause=0] Ha![pause=0] I knew it![pause=0] I could just tell that you're complete and total rookies!")
		GROUND:CharSetEmote(cranidos, "glowing", 0)
		UI:SetSpeakerEmotion("Joyous")
		UI:WaitShowDialogue("And that look on your face![pause=0] You're all flustered![pause=0] Hahaha!")
		GROUND:CharSetEmote(cranidos, "", 0)
		GAME:WaitFrames(10)
		
		GROUND:CharSetEmote(hero, "exclaim", 1)
		GAME:WaitFrames(10)
		GROUND:CharSetEmote(partner, "angry", 1)
		SOUND:PlayBattleSE('EVT_Emote_Complain_2')
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Determined")
		GeneralFunctions.DoubleHop(partner)
		UI:WaitShowDialogue("What's your deal?[pause=0] We just wanted to say hello to you!")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, cranidos.CurrentForm.Species, cranidos.CurrentForm.Form, cranidos.CurrentForm.Skin, cranidos.CurrentForm.Gender)
		UI:SetSpeakerEmotion("Angry")
		SOUND:PlayBattleSE('EVT_Emote_Complain_2')
		GROUND:CharSetEmote(cranidos, "angry", 0)
		UI:WaitShowDialogue("My DEAL is that I have no respect for a bunch of greenhorns like you!")
		UI:WaitShowDialogue("Especially when they waltz in here and bother me while I'm scouting outlaws![pause=0] It's unbelievable!")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Angry")
		GROUND:CharSetEmote(partner, "angry", 0)
		UI:WaitShowDialogue("Are you for real?[pause=0] What's unbelievable is how big a jerk you are!")
		GAME:WaitFrames(40)
		
		AI:DisableCharacterAI(mareep)
		GROUND:CharSetAnim(mareep, "None", true)
		GeneralFunctions.EmoteAndPause(mareep, "Exclaim", true)
		GROUND:CharTurnToCharAnimated(mareep, cranidos, 4)
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, mareep.CurrentForm.Species, mareep.CurrentForm.Form, mareep.CurrentForm.Skin, mareep.CurrentForm.Gender)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("Is something the ma-a-a-atter, " .. cranidos:GetDisplayName() .. "?")
		GAME:WaitFrames(20)
		
		GROUND:CharSetEmote(partner, "", 0)
		GeneralFunctions.EmoteAndPause(cranidos, "Exclaim", true)
		GROUND:CharSetEmote(cranidos, "sweating", 1)
		UI:SetSpeaker(cranidos)
		UI:SetSpeakerEmotion("Surprised")
		SOUND:PlayBGM('Guildmaster Wigglytuff.ogg', false)
		GROUND:CharTurnToCharAnimated(cranidos, mareep, 4)
		UI:WaitShowDialogue("Wh-what?[pause=0] Uh,[pause=10] n-nope![pause=0] I was just having a conversation with the guild's newest recruits!")
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
		UI:WaitShowDialogue("They're right there...")
		GAME:WaitFrames(20)
		
		GROUND:CharSetAnim(mareep, "None", true)
		GROUND:CharTurnToCharAnimated(mareep, hero, 4)
		GROUND:CharTurnToChar(hero, mareep)
		GROUND:CharTurnToChar(partner, mareep)
		GeneralFunctions.Hop(mareep)
		GeneralFunctions.Hop(mareep)
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, mareep.CurrentForm.Species, mareep.CurrentForm.Form, mareep.CurrentForm.Skin, mareep.CurrentForm.Gender)
		UI:SetSpeakerEmotion("Happy")
		GROUND:CharSetEmote(mareep, "happy", 0)
		UI:WaitShowDialogue("You're the new recruits?[pause=0] Hi hi hi![pause=0] It's grea-a-a-at to meet you![pause=0] My name's " .. mareep:GetDisplayName() .. "!")
		GAME:WaitFrames(20)
		GROUND:CharSetEmote(mareep, "", 0)
		
		GROUND:CharTurnToCharAnimated(mareep, cranidos, 4)
		UI:SetSpeaker(mareep)
		UI:WaitShowDialogue("And this sweetie is " .. cranidos:GetDisplayName() .. "!")
		GAME:WaitFrames(40)
		
		GROUND:CharSetEmote(partner, "sweatdrop", 1)
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
		UI:WaitShowDialogue("Um...[pause=0] My name is " .. partner:GetDisplayName() .. ",[pause=10] and my partner there is " .. hero:GetDisplayName() .. ".[pause=0] We're Team " .. GAME:GetTeamName() .."...")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(mareep)
		GeneralFunctions.Hop(mareep)
		UI:SetSpeakerEmotion("Happy")
		GROUND:CharSetEmote(mareep, "happy", 0)
		UI:WaitShowDialogue("Grea-a-a-at to meet the both of you![pause=0] And I love your team name!")
		UI:WaitShowDialogue(GAME:GetTeamName() .. "![pause=0] Rolls right off the tongue!")
		GROUND:CharSetEmote(mareep, "", 0)
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
		
		GROUND:CharSetEmote(cranidos, "shock", 1)
		SOUND:PlayBattleSE('EVT_Emote_Shock_Bad')
		GAME:WaitFrames(40)
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
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue("...nice to meet the both of you.")
		GAME:WaitFrames(20)
		
		GROUND:CharSetEmote(partner, "sweatdrop", 1)
		GeneralFunctions.EmoteAndPause(hero, 'Sweatdrop', true)
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Stunned")
		UI:WaitShowDialogue("...[pause=0]Likewise...")
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
		UI:WaitShowDialogue("Huh?[pause=0] Is something wrong?")
		GAME:WaitFrames(20)
		GROUND:CharTurnToCharAnimated(mareep, cranidos, 4)
		GROUND:CharTurnToChar(hero, mareep)
		GROUND:CharTurnToChar(partner, mareep)
		UI:WaitShowDialogue(cranidos:GetDisplayName() .. " wasn't being a mea-a-a-anie again,[pause=10] was he?")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Stunned")
		GROUND:CharSetEmote(partner, "sweating", 1)
		UI:WaitShowDialogue("Oh,[pause=10] uh,[pause=10] no![pause=0] Everything's fine!")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(mareep)
		UI:SetSpeakerEmotion("Happy")
		GROUND:CharTurnToCharAnimated(mareep, partner, 4)
		UI:WaitShowDialogue("Oh,[pause=10] good![pause=0] I was afraid he was being a big\nmea-a-a-anie again!")
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("He can get really grumpy whenever we have trouble bringing in an outlaw.[pause=0] Today's was a slippery one!")
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
		UI:WaitShowDialogue("Well,[pause=10] don't mind him.[pause=0] He gets really bashful sometimes.")
		GAME:WaitFrames(20)
		
		--fade back in normal guild music
		SOUND:PlayBGM("Wigglytuff's Guild.ogg", true)
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("Anywa-a-a-ay...[pause=0] You're gonna have a lot of fun working with the guild!")
		UI:WaitShowDialogue("We're gonna do all sorts of fun stuff together now that you've joined!")
		UI:WaitShowDialogue("Me and " .. cranidos:GetDisplayName() .. " can even show you some ways to take down bad guys sometime![pause=0] We'll have a bla-a-a-ast!")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("That sounds great,[pause=10] " .. mareep:GetDisplayName() .. "![pause=0] I can't wait!")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(mareep)
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("Good luck,[pause=10] you two![pause=0] It's back to finding tomorrow's ba-a-a-addie to beat for me now!")
		GAME:WaitFrames(20)
		
		GROUND:CharAnimateTurnTo(mareep, Direction.Up, 4)
		GROUND:CharSetAnim(cranidos, 'Idle', true)
		GROUND:CharSetAnim(mareep, 'Idle', true)
		GROUND:CharSetAnim(CH('Zigzagoon'), 'Idle', true)
		AI:EnableCharacterAI(mareep)
		SV.Chapter1.MetCranidosMareep = true
		GeneralFunctions.PanCamera(400, 272)
		
		--every guildmate is talked to, signal player that they can go sleep now
		if SV.Chapter1.MetSnubbull and SV.Chapter1.MetZigzagoon and SV.Chapter1.MetCranidosMareep and SV.Chapter1.MetBreloomGirafarig and SV.Chapter1.MetAudino then
			GAME:WaitFrames(60)
			GROUND:CharTurnToCharAnimated(partner, hero, 4)
			UI:SetSpeaker(partner)
			UI:SetSpeakerEmotion("Normal")
			UI:WaitShowDialogue("Hey " .. hero:GetDisplayName() .. "...[pause=0] It's getting pretty late...")
			GROUND:CharTurnToCharAnimated(hero, partner, 4)
			GAME:WaitFrames(12)
			UI:WaitShowDialogue("We should probably head back to our room and hit the hay for the night.")
			UI:WaitShowDialogue("Let's head there whenever you're ready,[pause=10] " .. hero:GetDisplayName() .. ".")
		end
		GROUND:CharEndAnim(cranidos)
		GROUND:CharEndAnim(mareep)
		GROUND:CharEndAnim(CH('Zigzagoon'))
		partner.IsInteracting = false
		AI:EnableCharacterAI(partner)
		AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)
		

		GAME:CutsceneMode(false)

	else

		GeneralFunctions.StartConversation(chara, ".........", "Determined", false)
		GAME:WaitFrames(20)
	
		GeneralFunctions.Monologue("(" .. cranidos:GetDisplayName() .. " is ignoring you.)")
		GeneralFunctions.EndConversation(chara)
	end
end

function guild_second_floor_ch_1.Mareep_Action(chara, activator)
	local mareep = chara
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	if not SV.Chapter1.MetCranidosMareep then
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, mareep.CurrentForm.Species, mareep.CurrentForm.Form, mareep.CurrentForm.Skin, mareep.CurrentForm.Gender)
		mareep.IsInteracting = true 
		GeneralFunctions.StartConversation(chara, "Ooh,[pause=10] what about this job?[pause=0] This outla-a-a-aw seems like a real jerk![pause=0] Let's bring 'em in!", "Normal", false, false, false)
		GAME:WaitFrames(20)
		UI:ResetSpeaker(false)
		UI:SetCenter(true)
		UI:WaitShowDialogue("(She's too invested in the job board to notice you.)")
		UI:SetCenter(false)
		GeneralFunctions.EndConversation(chara, false)
		mareep.IsInteracting = false
	else 
		GeneralFunctions.StartConversation(chara, "You're gonna have a lot of fun working with the guild!", "Happy")
		UI:WaitShowDialogue("We're gonna do all sorts of fun stuff together now that you've joined!")
		UI:WaitShowDialogue("Me and " .. CH('Cranidos'):GetDisplayName() .. " can even show you some ways to take down bad guys sometime![pause=0] We'll have a bla-a-a-ast!")
		GeneralFunctions.EndConversation(chara)
	end
end
	

return guild_second_floor_ch_1