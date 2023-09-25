require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_fire_home_ch_4 = {}

function metano_fire_home_ch_4.SetupGround()

	if SV.Chapter4.FinishedGrove then 
		local camerupt, numel  = 
			CharacterEssentials.MakeCharactersFromList({
				{'Camerupt', 176, 80, Direction.Up},
				{'Numel', 152, 80, Direction.UpRight}
			})
		
	end 
	
	GAME:FadeIn(20)
end

function metano_fire_home_ch_4.Camerupt_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Now,[pause=10] " .. CH('Numel'):GetDisplayName() .. ",[pause=10] you need to have patience![pause=0] Lava Cakes take time to come out just right!", "Happy", false)
	UI:WaitShowDialogue("You've earned one with all your hard work,[pause=10] you just have to wait a little while longer!")
	GeneralFunctions.EndConversation(chara)
end 

function metano_fire_home_ch_4.Numel_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Ohhh,[pause=10] I can't wait any longer![pause=0] I want a Lava Cake so bad!", "Worried", false)
	GeneralFunctions.EndConversation(chara)
end 