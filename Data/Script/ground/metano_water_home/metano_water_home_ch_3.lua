require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_water_home_ch_3 = {}

function metano_water_home_ch_3.SetupGround()
	
	if not SV.Chapter3.DefeatedBoss then
		local quagsire, floatzel  = 
			CharacterEssentials.MakeCharactersFromList({
				{'Quagsire', 232, 168, Direction.Up},
				{'Floatzel', 232, 120, Direction.Down}
			})
	end
		
	GAME:FadeIn(20)
end

function metano_water_home_ch_3.Quagsire_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "It's wonderful that " .. CharacterEssentials.GetCharacterName("Numel") .. " was rescued after wandering off,[pause=10] but...", "Worried")
	UI:WaitShowDialogue("It's got me worried about my own kids.[pause=0] They're quite prone to wandering themselves...")
	UI:WaitShowDialogue("I hope they won't go off somewhere where they would need rescuing...")
	GeneralFunctions.EndConversation(chara)
end 

function metano_water_home_ch_3.Floatzel_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "I'm not too worried if " .. CharacterEssentials.GetCharacterName("Wooper_Girl") .. " or " .. CharacterEssentials.GetCharacterName("Wooper_Boy") .. " wander off.")
	UI:WaitShowDialogue("They've wandered off plenty of times before and they always find their way back home safely.")
	UI:WaitShowDialogue("Worse comes to worse,[pause=10] the guild could rescue them like they rescued " .. CharacterEssentials.GetCharacterName("Numel") .. ",[pause=10] right?")
	GeneralFunctions.EndConversation(chara)
end 