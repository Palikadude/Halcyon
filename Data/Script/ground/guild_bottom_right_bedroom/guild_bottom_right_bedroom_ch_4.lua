require 'common'
require 'PartnerEssentials'
require 'CharacterEssentials'
require 'GeneralFunctions'

guild_bottom_right_bedroom_ch_4 = {}


function guild_bottom_right_bedroom_ch_4.SetupGround()
	if SV.Chapter4.FinishedGrove then
		local zigzagoon = CharacterEssentials.MakeCharactersFromList({
			{'Zigzagoon', 224, 248, Direction.DownLeft}
		})
	end
	
	GAME:FadeIn(20)

end

function guild_bottom_right_bedroom_ch_4.Zigzagoon_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "I'm getting some last minute review in before the expedition!")
	UI:WaitShowDialogue("I want to make sure I'm as ready as I can be,[pause=10] so I have to study up while I still can!")
	GeneralFunctions.EndConversation(chara)
end


return guild_bottom_right_bedroom_ch_4