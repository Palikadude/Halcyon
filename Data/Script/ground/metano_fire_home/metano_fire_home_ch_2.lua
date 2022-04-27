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
	UI:SetSpeaker(chara)
	local olddir = chara.Direction
	GROUND:CharTurnToChar(chara, CH('PLAYER'))
	UI:WaitShowDialogue("Placeholder.")
	GROUND:EntTurn(chara, olddir)
end 
