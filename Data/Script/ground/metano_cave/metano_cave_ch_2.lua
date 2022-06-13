require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_cave_ch_2 = {}

function metano_cave_ch_2.SetupGround()
	GAME:FadeIn(20)
end

function metano_cave_ch_2.Sunflora_Action(chara, activator)
	if not SV.Chapter2.FinishedFirstDay then 
		GeneralFunctions.StartConversation(chara, "Visitors...?", "Worried", true, false)
		UI:WaitShowDialogue("Thanks for dropping by,[pause=10] but I'd prefer to be alone.[pause=0] Sorry.")
	else 
		GeneralFunctions.StartConversation(chara, "...One of the town children has gone missing?", "Worried", true, false)
		UI:WaitShowDialogue("...That isn't really my thing anymore.[pause=0] Find someone else to help you.")
	end 
	GeneralFunctions.EndConversation(chara, false)
end 
