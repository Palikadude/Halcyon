require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

guild_second_floor_ch_2 = {}



function guild_second_floor_ch_2.SetupGround()
	
	if not SV.Chapter2.FinishedTraining then 
		--day 1: before training 
		
		local zangoose, seviper = 
			CharacterEssentials.MakeCharactersFromList({
				{'Zangoose', 'Right_Duo_1'},
				{'Seviper', 'Right_Duo_2'},
				{'Zigzagoon', 'Left_Solo'}
			})
			
		GROUND:CharSetAnim(zangoose, 'Idle', true)
		GROUND:CharSetAnim(seviper, 'Idle', true)


		AI:SetCharacterAI(zangoose, "ai.ground_talking", false, 240, 60, 210, false, 'Angry', {seviper})
		AI:SetCharacterAI(seviper, "ai.ground_talking", false, 240, 180, 110, false, 'Angry', {zangoose})

	elseif SV.Chapter2.FinishedNumelTantrum and not SV.Chapter2.FinishedFirstDay then 
		--day 1: after training
		local bagon, doduo, audino = 
			CharacterEssentials.MakeCharactersFromList({
				{'Doduo', 'Left_Duo_1'},
				{'Bagon', 'Left_Duo_2'},
				{'Audino', 'Generic_Spawn_6'}
			})

		AI:SetCharacterAI(bagon, "ai.ground_talking", false, 240, 60, 210, true, 'default', {doduo})
		AI:SetCharacterAI(doduo, "ai.ground_talking", false, 240, 180, 110, true, 'default', {bagon})
		
		AI:SetCharacterAI(audino, "ai.ground_default", RogueElements.Loc(432, 288), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)


	end
	
	GAME:FadeIn(20)
end





function guild_second_floor_ch_2.Zangoose_Action(chara, activator)
	guild_second_floor_ch_2.Seviper_Action(chara, activator)
end 

function guild_second_floor_ch_2.Seviper_Action(chara, activator)
	local zangoose = CH('Zangoose')
	local seviper = CH('Seviper')
	--Set zangoose and seviper to interacting to pause their talking AI
	zangoose.IsInteracting = true
	seviper.IsInteracting = true
	UI:SetSpeaker(seviper)
	UI:WaitShowDialogue("What about thissss one?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(zangoose)
	UI:WaitShowDialogue("Too weak.")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(seviper)
	UI:WaitShowDialogue("Well,[pause=10] what about thissss one?")
	
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(zangoose, seviper, 4)
	UI:SetSpeaker(zangoose)
	UI:WaitShowDialogue("Not a real challenge.[pause=0] You scared of fighting a real outlaw or something?")

	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(seviper, zangoose, 4)
	UI:SetSpeaker(seviper)
	UI:WaitShowDialogue("Had to make ssssure to pick one you'd be able to handle.[pause=0] Sssseeing how you're sssso delicate and all...")
	
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(zangoose, Direction.Up, 4)
	GeneralFunctions.EmoteAndPause(zangoose, "Sweating", true)
	UI:SetSpeaker(zangoose)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("Tch...[pause=0] Convenient excuse...")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(seviper)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Yeah yeah yeah.[pause=0] Now sssstop being sssso picky.")
	UI:WaitShowDialogue("You're gonna get Team [color=#FFA5FF]tbd[color] a bad rep if you keep ussss here dawdling when we sssshould be out in the field catching outlawssss.")
	GROUND:CharAnimateTurnTo(seviper, Direction.Up, 4)
	zangoose.IsInteracting = false
	seviper.IsInteracting = false
end

function guild_second_floor_ch_2.Zigzagoon_Action(chara, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local zigzagoon = CH('Zigzagoon')
	
	GROUND:CharTurnToChar(zigzagoon, CH('PLAYER'))
	UI:SetSpeaker(zigzagoon)
	UI:WaitShowDialogue("Hey Team " .. GAME:GetTeamName() .. ",[pause=10] how's your first day going?")
	UI:WaitShowDialogue(".........")
	UI:WaitShowDialogue(CharacterEssentials.GetCharacterName("Noctowl") .. " is sending you over to Sensei " .. CharacterEssentials.GetCharacterName("Ledian") .. " for training,[pause=10] huh?")
	UI:WaitShowDialogue("She's definitely...[pause=0] Um...[pause=0] a character alright...")
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("She's a great teacher though.[pause=0] Make sure you do your best to learn from her!")
	--UI:WaitShowDialogue("I know that I learned a lot of stuff from her!")
	GROUND:EntTurn(zigzagoon, Direction.Up)
end

function guild_second_floor_ch_2.Bagon_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "We're Team [color=#FFA5FF]Flight[color]![pause=0] We're an adventuring team that loves the sky!")
	UI:WaitShowDialogue("I can't fly yet myself,[pause=10] but my partner " .. CharacterEssentials.GetCharacterName('Doduo') .. " is a master of flying!")
	UI:WaitShowDialogue("I can't wait to soar the skies like him one day!")
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_2.Doduo_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "We came here to get some jobs,[pause=10] but we got here a bit later than we'd have liked to.")
	UI:WaitShowDialogue("We would have flown us here in a jiffy,[pause=10] but,[pause=10] erm...")
	UI:SetSpeakerEmotion("Stunned")
	GROUND:CharSetEmote(chara, 5, 1)
	UI:WaitShowDialogue("Our...[pause=0] wings were too tired after flying around all day.[pause=0] So we and " .. CharacterEssentials.GetCharacterName("Bagon") .." had to walk.")
	GeneralFunctions.EndConversation(chara)
end

function guild_second_floor_ch_2.Audino_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "H-hey you two![pause=0] Hope your first day w-went well!", "Happy")
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("I'm almost finished updating the job boards.")
	UI:WaitShowDialogue("Just need that l-last team to leave so I can update that board.")
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Hopefully they don't take too long...[pause=0] It's almost dinner time,[pause=10] and I'm f-famished!")
	GeneralFunctions.EndConversation(chara)
	
end 	

return guild_second_floor_ch_2