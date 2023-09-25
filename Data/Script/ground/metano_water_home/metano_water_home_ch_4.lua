require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_water_home_ch_4 = {}

function metano_water_home_ch_4.SetupGround()
	
	if not SV.Chapter4.FinishedGrove then
	
	else
		local floatzel  = 
			CharacterEssentials.MakeCharactersFromList({
				{'Floatzel', 120, 128, Direction.Down}
			})
		
		AI:SetCharacterAI(floatzel, "ai.ground_default", RogueElements.Loc(104, 112), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)

	end
			
	
	GAME:FadeIn(20)
end


function metano_water_home_ch_4.Floatzel_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "I've gotta lay low after my masterful heist until the heat dies down a bit.")
	UI:WaitShowDialogue("Then I'll turn myself in for the bounty they're sure to put on me!")
	UI:SetSpeakerEmotion("Joyous")
	GROUND:CharSetEmote(chara, "happy", 0)
	UI:WaitShowDialogue("Haha![pause=0] Dream castle,[pause=10] you will be mine!")
	GROUND:CharSetEmote(chara, "", 0)
	GeneralFunctions.EndConversation(chara)
end 