require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_cave_ch_3 = {}

function metano_cave_ch_3.SetupGround()
	GAME:FadeIn(20)
end

function metano_cave_ch_3.Sunflora_Action(chara, activator)
	if not SV.Chapter3.DefeatedBoss then
		GeneralFunctions.StartConversation(chara, "...That child that went missing.[pause=0] Has he been rescued yet?", "Worried", true, false)
		UI:WaitShowDialogue(".........I see.[pause=0] At least there are adventurers like you two out there now.")
	else
		GeneralFunctions.StartConversation(chara, "...Outlaws,[pause=10] huh?", "Worried", true, false)
		UI:SetSpeakerEmotion("Pain")
		UI:WaitShowDialogue("...I don't really concern myself with that sort of stuff anymore.[pause=0] Please leave me be.")
	end
	GeneralFunctions.EndConversation(chara, false)
end 
