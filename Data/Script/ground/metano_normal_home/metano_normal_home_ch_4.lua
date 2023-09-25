require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_normal_home_ch_4 = {}

function metano_normal_home_ch_4.SetupGround()
	if not SV.Chapter4.FinishedGrove then 
		local furret = 
			CharacterEssentials.MakeCharactersFromList({
				{'Furret', 104, 152, Direction.Right}
			})
			
		AI:SetCharacterAI(furret, "ai.ground_default", RogueElements.Loc(88, 136), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)

	else 

	end
	
	GAME:FadeIn(20)
end

function metano_normal_home_ch_4.Furret_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "I have so many chores to take care of around the house today.", "Normal")
		UI:SetSpeakerEmotion("Sad")
		UI:WaitShowDialogue("This is seriously going to cut into my snoozing time...")
	else
		--N/A
	end
	GeneralFunctions.EndConversation(chara)
end