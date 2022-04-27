require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_grass_home_ch_2 = {}

function metano_grass_home_ch_2.SetupGround()
	local vileplume  = 
		CharacterEssentials.MakeCharactersFromList({
			{'Vileplume', 120, 192, Direction.Up}
		})
	
	
	GAME:FadeIn(20)
end

function metano_grass_home_ch_2.Vileplume_Action(chara, activator)
	UI:SetSpeaker(chara)
	local olddir = chara.Direction
	GROUND:CharTurnToChar(chara, CH('PLAYER'))
	UI:WaitShowDialogue("Placeholder.")
	GROUND:EntTurn(chara, olddir)
end 
