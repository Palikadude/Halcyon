require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_electric_home_ch_4 = {}

function metano_electric_home_ch_4.SetupGround()
	
	if SV.Chapter4.FinishedGrove then
		local luxray  = 
			CharacterEssentials.MakeCharactersFromList({
				{'Luxray', 216, 130, Direction.Down}
			})

	end
	
	GAME:FadeIn(20)
end

--perhaps change? two dogging on his sons in a row is a bit iffy perhaps
function metano_electric_home_ch_4.Luxray_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Associating with those hooligans...[pause=0] I truly do not understand my son.")
	UI:WaitShowDialogue("I'm disappointed in him.[pause=0] He should be better,[pause=10] but his behavior and his fruitless results are no surprise to me.")
	GeneralFunctions.EndConversation(chara)
end 


