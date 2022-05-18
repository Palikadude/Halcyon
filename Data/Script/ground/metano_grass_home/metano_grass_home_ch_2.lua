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
	GeneralFunctions.StartConversation(chara, "Placeholder.")
	GeneralFunctions.EndConversation(chara)
end 
