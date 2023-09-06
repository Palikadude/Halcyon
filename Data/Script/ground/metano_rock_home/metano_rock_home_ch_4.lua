require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_rock_home_ch_4 = {}

function metano_rock_home_ch_4.SetupGround()
	if not SV.Chapter4.FinishedGrove then
		local meditite  = 
			CharacterEssentials.MakeCharactersFromList({
				{'Meditite', 232, 184, Direction.Down}

			})
			
		AI:SetCharacterAI(meditite, "ai.ground_default", RogueElements.Loc(216, 168), RogueElements.Loc(32, 32), 1, 16, 64, 40, 180)

	end

	GAME:FadeIn(20)
end

function metano_rock_home_ch_4.Meditite_Action(chara, activator)
	--I'm trying, but I'm struggling to make friends... It's really getting me down...
	--But I can't give up, or I'll never have any friends! I have to keep trying!
	GeneralFunctions.StartConversation(chara, "I'm tryin',[pause=10] but struggling am I ta' friends make.[pause=0] Really gettin' down me,[pause=10] it is...", "Sad")
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("But I cannae give up,[pause=10] 'er I winnae ever friends make![pause=0] Hafta it must I keep at!")
	GeneralFunctions.EndConversation(chara)
end 
