require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_electric_home_ch_2 = {}

function metano_electric_home_ch_2.SetupGround()
	
	if not SV.Chapter2.FinishedFirstDay then
		local manectric  = 
			CharacterEssentials.MakeCharactersFromList({
				{'Manectric', 216, 136, Direction.Down}

			})
	else 
		local electrike = 
			CharacterEssentials.MakeCharactersFromList({
				{'Electrike', 144, 168, Direction.Right}
			})
			
		AI:SetCharacterAI(electrike, "ai.ground_default", RogueElements.Loc(112, 136), RogueElements.Loc(64, 64), 1, 16, 32, 40, 180)

	end
	

	
	GAME:FadeIn(20)
end

function metano_electric_home_ch_2.Manectric_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Placeholder.")
	GeneralFunctions.EndConversation(chara)
end 


function metano_electric_home_ch_2.Electrike_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Don't let anyone know I'm here![pause=0] I'm hiding inside today.")
	UI:WaitShowDialogue("If I go outside,[pause=10] I might get stuck doing nothing with the wonder twins again.")
	GeneralFunctions.EndConversation(chara)
end 
