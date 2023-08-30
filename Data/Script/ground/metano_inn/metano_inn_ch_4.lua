require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_inn_ch_4 = {}

function metano_inn_ch_4.SetupGround()
	
	if not SV.Chapter4.FinishedGrove then
		local smeargle = 
			CharacterEssentials.MakeCharactersFromList({
				{'Smeargle', 128, 248, Direction.Left}
			})
	
		AI:SetCharacterAI(smeargle, "ai.ground_default", RogueElements.Loc(112, 232), RogueElements.Loc(32, 32), 1, 16, 64, 40, 180)
	else
		local skorupi = 
			CharacterEssentials.MakeCharactersFromList({
				{'Skorupi', 317, 210, Direction.Down}
			})
	end

	GAME:FadeIn(20)
end


function metano_inn_ch_4.Passerby_1_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then 
		GeneralFunctions.StartConversation(chara, "I hope I didn't leave a paint stain on the bed while I was sleeping.")
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue("I don't want to pay an extra fee if I left a mark on the bed by accident...")
	else 
		GeneralFunctions.StartConversation(chara, "The inn's food is so good![pause=0] So much better than the slop back home!", "Inspired")
	end
	GeneralFunctions.EndConversation(chara)
end