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
	end
			
	AI:SetCharacterAI(floatzel, "ai.ground_default", RogueElements.Loc(104, 112), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
	
	GAME:FadeIn(20)
end


function metano_water_home_ch_4.Floatzel_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "I've gotta lay low after my masterful heist until the heat dies down a bit.")
	UI:WaitShowDialogue("Then I'll turn myself in for the bounty they're sure to put on me!")
	UI:WaitShowDialogue("Haha![pause=0] This plan is so perfect![pause=0] I'll be able to afford my dream castle in no time!")
	GeneralFunctions.EndConversation(chara)
end 