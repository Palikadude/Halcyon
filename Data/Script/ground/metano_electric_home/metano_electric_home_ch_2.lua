require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_electric_home_ch_2 = {}

function metano_electric_home_ch_2.SetupGround()
	local manectric  = 
		CharacterEssentials.MakeCharactersFromList({
			{'Manectric', 216, 136, Direction.Down},

		})
	

	
	GAME:FadeIn(20)
end

function metano_electric_home_ch_2.Manectric_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Placeholder.")
	GeneralFunctions.EndConversation(chara)
end 
