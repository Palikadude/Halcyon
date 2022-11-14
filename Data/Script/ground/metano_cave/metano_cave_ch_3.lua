require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_cave_ch_3 = {}

function metano_cave_ch_3.SetupGround()
	GAME:FadeIn(20)
end

function metano_cave_ch_3.Sunflora_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "...That child that went missing.[pause=0] Has he been rescued yet?", "Worried", true, false)
	UI:WaitShowDialogue(".........I see.[pause=0] At least there are adventurers like you two out there now.")
	GeneralFunctions.EndConversation(chara, false)
end 
