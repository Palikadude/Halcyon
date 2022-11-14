require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_grass_home_ch_3 = {}

function metano_grass_home_ch_3.SetupGround()
	local vileplume, bellossom  = 
			CharacterEssentials.MakeCharactersFromList({
				{'Vileplume', 96, 192, Direction.Up},
				{'Bellossom', 96, 136, Direction.Down}
			})

	
	GAME:FadeIn(20)
end

function metano_grass_home_ch_3.Vileplume_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "The world may a dangerous place,[pause=10] but at least there are adventurers out there that help those in trouble.", "Worried")
	UI:WaitShowDialogue("...Still,[pause=10] I wonder if they'll be enough to tackle all the problems the future holds...")
	GeneralFunctions.EndConversation(chara)
end 

function metano_grass_home_ch_3.Bellossom_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "My husband is such a worrywart.[pause=0] He would be a lot happier if he stopped thinking so much!")
	GeneralFunctions.EndConversation(chara)
end 
