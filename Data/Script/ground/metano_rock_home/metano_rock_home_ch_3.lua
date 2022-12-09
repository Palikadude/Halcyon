require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_rock_home_ch_3 = {}

function metano_rock_home_ch_3.SetupGround()
	local machamp  = 
			CharacterEssentials.MakeCharactersFromList({
				{'Machamp', 98, 128, Direction.Down},

			})

	GAME:FadeIn(20)
end

function metano_rock_home_ch_3.Machamp_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "It's so great that wee " .. CharacterEssentials.GetCharacterName("Numel") .. " was found![pause=0] 'is mum mus' be so relieved.")
	UI:WaitShowDialogue("Nae if only we can figure out this shortage a' Apricorns...")
	GeneralFunctions.EndConversation(chara)
end 
