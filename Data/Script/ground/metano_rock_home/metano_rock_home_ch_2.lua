require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_rock_home_ch_2 = {}

function metano_rock_home_ch_2.SetupGround()
	if not SV.Chapter2.FinishedFirstDay then 
		local medicham  = 
			CharacterEssentials.MakeCharactersFromList({
				{'Medicham', 152, 152, Direction.Left},

			})
		
		AI:SetCharacterAI(medicham, "ai.ground_default", RogueElements.Loc(120, 120), RogueElements.Loc(64, 64), 1, 16, 64, 40, 180)
	end
	GAME:FadeIn(20)
end

function metano_rock_home_ch_2.Medicham_Action(chara, activator)
	UI:SetSpeaker(chara)
	local olddir = chara.Direction
	GROUND:CharTurnToChar(chara, CH('PLAYER'))
	UI:WaitShowDialogue("Placeholder.")
	GROUND:EntTurn(chara, olddir)
end 
