require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_water_home_ch_2 = {}

function metano_water_home_ch_2.SetupGround()
	local quagsire  = 
		CharacterEssentials.MakeCharactersFromList({
			{'Quagsire', 216, 120, Direction.Down}
		})
	
	--AI:SetCharacterAI(floatzel, "ai.ground_default", RogueElements.Loc(148, 136), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)

	
	GAME:FadeIn(20)
end

function metano_water_home_ch_2.Quagsire_Action(chara, activator)
	UI:SetSpeaker(chara)
	local olddir = chara.Direction
	GROUND:CharTurnToChar(chara, CH('PLAYER'))
	UI:WaitShowDialogue(CharacterEssentials.GetCharacterName("Wooper_Girl") .. ' and ' .. CharacterEssentials.GetCharacterName('Wooper_Boy') .. " are still out there trying to figure out their plans for the day.")
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Those kids of mine...[pause=0] They're sweet,[pause=10] but they're not the brighest.")
	UI:WaitShowDialogue("I wonder where they get it from?")
	GROUND:EntTurn(chara, olddir)
end 

