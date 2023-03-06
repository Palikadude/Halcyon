require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_electric_home_ch_3 = {}

function metano_electric_home_ch_3.SetupGround()
	
	if SV.Chapter3.DefeatedBoss then
		local luxray  = 
			CharacterEssentials.MakeCharactersFromList({
				{'Luxray', 216, 130, Direction.Down}
			})

	end
	
	GAME:FadeIn(20)
end

function metano_electric_home_ch_3.Luxray_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Outlaws?[pause=0] What fear need I of them?")
	UI:WaitShowDialogue("Should any outlaws present themselves to me,[pause=10] I would easily defeat them myself.")
	UI:WaitShowDialogue("The other Pokémon in town should do the same,[pause=10] but they've become soft living close to the guild.")
	GeneralFunctions.EndConversation(chara)
end 


