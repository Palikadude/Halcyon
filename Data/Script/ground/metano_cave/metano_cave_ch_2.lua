require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_cave_ch_2 = {}

function metano_cave_ch_2.SetupGround()
	GAME:FadeIn(20)
end

function metano_cave_ch_2.Sunflora_Action(chara, activator)
	UI:SetSpeaker(chara)
	local olddir = chara.Direction
	GROUND:CharTurnToChar(chara, CH('PLAYER'))
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Visitors...?")
	UI:WaitShowDialogue("Thanks for dropping by,[pause=10] but I'd prefer being alone.[pause=0] Sorry.")
	GROUND:EntTurn(chara, olddir)
end 
