require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_fire_home_ch_2 = {}

function metano_fire_home_ch_2.SetupGround()
	local camerupt  = 
		CharacterEssentials.MakeCharactersFromList({
			{'Camerupt', 144, 152, Direction.Right},

		})
	
	AI:SetCharacterAI(camerupt, "ai.ground_default", RogueElements.Loc(112, 120), RogueElements.Loc(64, 64), 1, 16, 64, 40, 180)

	
	GAME:FadeIn(20)
end

function metano_fire_home_ch_2.Camerupt_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "That son of mine...[pause=0] I love him to pieces,[pause=10] but...", "Sad")
	UI:WaitShowDialogue("He's been hard to handle lately...[pause=0] I don't know what to do with him...")
	GeneralFunctions.EndConversation(chara)
end 
