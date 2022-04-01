require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

guild_second_floor_ch_2 = {}



function guild_second_floor_ch_2.SetupGround()
	
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
end





function guild_second_floor_ch_2.Zangoose_Action(chara, activator)
	guild_second_floor_ch_2.Seviper_Action(chara, activator)
end 

function guild_second_floor_ch_2.Seviper_Action(chara, activator)
	local zangoose = CH('Zangoose')
	local seviper = CH('Seviper')
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
end

function guild_second_floor_ch_2.Zigzagoon_Action(chara, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local zigzagoon = CH('Zigzagoon')
	
	GROUND:CharTurnToChar(zigzagoon, CH('PLAYER'))
	UI:SetSpeaker(zigzagoon)
	UI:WaitShowDialogue("Hey Team " .. GAME:GetTeamName() .. ",[pause=10] how's your first day going?")
	UI:WaitShowDialogue(".........")
	UI:WaitShowDialogue(CharacterEssentials.GetCharacterName(noctowl) .. " is sending you over to " .. CharacterEssentials.GetCharacterName(ledian) .. " for training,[pause=10] huh?")
	UI:WaitShowDialogue("She's definitely...[pause=0] Um...[pause=0] a character alright...")
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("She's a great teacher though.[pause=0] Make sure you do your best to learn from her!")
	--UI:WaitShowDialogue("I know that I learned a lot of stuff from her!")
	GROUND:EntTurn(zigzagoon, Direction.Up)
end



	

return guild_second_floor_ch_2