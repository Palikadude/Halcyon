require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

guild_second_floor_ch_1 = {}




function guild_second_floor_ch_1.MeetNoctowl()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	--GeneralFunctions.CenterCamera({hero, partner})
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
	local spheal, jigglypuff, marill, mareep, cranidos, cleffa, aggron = 
		CharacterEssentials.MakeCharactersFromList({
			{'Spheal', 'Left_Trio_1'},
			{'Jigglypuff', 'Left_Trio_2'},
			{'Marill', 'Left_Trio_3'},
			{'Mareep', 'Right_Duo_1'},
			{'Cranidos', 'Right_Duo_2'},
			{'Cleffa', 'Generic_Spawn_Duo_1'},
			{'Aggron', 'Generic_Spawn_Duo_2'},
			{'Luxio', 480, 280, Direction.Left},
			{"Glameow", 512, 280, Direction.Left},
			{"Cacnea", 544, 280, Direction.Left},
			{"Noctowl", 480, 280, Direction.Left}
		})
		
	GROUND:CharSetAnim(marill, 'Appeal', true)
		
	GAME:FadeIn(20)



end