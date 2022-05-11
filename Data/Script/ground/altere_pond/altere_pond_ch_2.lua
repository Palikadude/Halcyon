require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

altere_pond_ch_2 = {}

function altere_pond_ch_2.SetupGround()
	GAME:FadeIn(20)
end

function altere_pond_ch_2.Relicanth_Action(chara, activator)
	UI:SetSpeaker(chara)
	local olddir = chara.Direction
	GROUND:CharTurnToChar(chara, CH('PLAYER'))
	UI:WaitShowDialogue("Placeholder.")
	GROUND:EntTurn(chara, olddir)
end 
