require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_grass_home_ch_2 = {}

function metano_grass_home_ch_2.SetupGround()
	local vileplume  = 
		CharacterEssentials.MakeCharactersFromList({
			{'Vileplume', 120, 192, Direction.Up}
		})
	
	
	GAME:FadeIn(20)
end

function metano_grass_home_ch_2.Vileplume_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "I've been hearing that more and more of these mystery dungeons have been popping up as of late.", "Worried")
	UI:WaitShowDialogue("Strange thing is,[pause=10] nobody seems to know the actual reason why they've been appearing more...")
	UI:WaitShowDialogue("It seems as though the world is becoming a progressively more dangerous place by the day...[pause=0] These are scary times to live in...")
	GeneralFunctions.EndConversation(chara)
end 
