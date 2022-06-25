require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_inn_ch_2 = {}

function metano_inn_ch_2.SetupGround()

	if not SV.Chapter2.FinishedFirstDay then 
		GROUND:Hide('Innkeeper_Desk_Right')
		
		local nidoking, nidoqueen, nidoran_m = 
			CharacterEssentials.MakeCharactersFromList({
				{'Nidoking', 'Innkeeper_Left'},
				{'Nidoqueen', 168, 144, Direction.Right},
				{'Nidoran_M', 264, 152, Direction.UpLeft}
			})
		
		AI:SetCharacterAI(nidoqueen, "ai.ground_default", RogueElements.Loc(152, 128), RogueElements.Loc(32, 32), 1, 16, 64, 40, 180)
		AI:SetCharacterAI(nidoran_m, "ai.ground_default", RogueElements.Loc(248, 136), RogueElements.Loc(32, 32), 1, 16, 64, 40, 180)

	else
	
	
	end
	
	GAME:FadeIn(20)
end


function metano_inn_ch_2.Innkeeper_Desk_Left_Action(chara, activator)
	local nidoking = CH('Nidoking')
	GeneralFunctions.StartConversation(nidoking, "Howdy y'all![pause=0] Welcome to the Metano Inn![pause=0] Can I get y'all a couple of beds for the evenin'?")
	UI:WaitShowDialogue("...What's that?[pause=0] Y'all live in the guild?")
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Well,[pause=10] y'all still welcome here anytime ya like![pause=0] Don't be a stranger!")
	GeneralFunctions.EndConversation(nidoking)
end

function metano_inn_ch_2.Nidoran_M_Action(chara, activator)
	if not SV.Chapter2.FinishedFirstDay then 
		GeneralFunctions.StartConversation(chara, "Goo...[pause=20] gaa!")
	else 
	
	end
	GeneralFunctions.EndConversation(chara)
end



function metano_inn_ch_2.Nidoqueen_Action(chara, activator)
	if not SV.Chapter2.FinishedFirstDay then 
		GeneralFunctions.StartConversation(chara, "Placeholder.")
	else 
	
	end 
	GeneralFunctions.EndConversation(Chara)
end