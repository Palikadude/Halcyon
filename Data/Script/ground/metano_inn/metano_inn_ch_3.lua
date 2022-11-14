require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_inn_ch_3 = {}

function metano_inn_ch_3.SetupGround()

	GROUND:Hide('Innkeeper_Desk_Left')
	
	local nidoking, nidoqueen, nidoran_m, snorlax = 
		CharacterEssentials.MakeCharactersFromList({
			{'Nidoqueen', 'Innkeeper_Right'},
			{'Nidoran_M', 168, 192, Direction.Down}
		})
	
	AI:SetCharacterAI(nidoran_m, "ai.ground_default", RogueElements.Loc(152, 176), RogueElements.Loc(32, 32), 1, 16, 64, 40, 180)
	

	GAME:FadeIn(20)
end



function metano_inn_ch_3.Nidoran_M_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Googoogagee!")
	GeneralFunctions.EndConversation(chara)
end


function metano_inn_ch_3.Innkeeper_Desk_Right_Action(chara, activator)
	local nidoqueen = CH('Nidoqueen')
	GeneralFunctions.StartConversation(nidoqueen, "Seems like nothin' dangerous was afoot in town after all.[pause=0] That young'un had just wandered off was all!")
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Guess I don't need to be worryin' 'bout no danger comin' to my youngsters then!")
	GeneralFunctions.EndConversation(nidoqueen)
end

