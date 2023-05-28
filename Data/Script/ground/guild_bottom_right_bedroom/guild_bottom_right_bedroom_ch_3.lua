require 'common'
require 'PartnerEssentials'
require 'CharacterEssentials'
require 'GeneralFunctions'

guild_bottom_right_bedroom_ch_3 = {}


function guild_bottom_right_bedroom_ch_3.SetupGround()
	if not SV.Chapter3.DefeatedBoss then
		local zigzagoon = CharacterEssentials.MakeCharactersFromList({
			{'Zigzagoon', 88, 256, Direction.Down}
		})
	end
	
	GAME:FadeIn(20)

end

function guild_bottom_right_bedroom_ch_3.Zigzagoon_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Hey,[pause=10] Team " .. GAME:GetTeamName() .. ",[pause=10] what's up!")
	UI:WaitShowDialogue("...What am I doing right now?")
	UI:WaitShowDialogue("Hmm.[pause=0] I'm just reviewing some of my almanacs before I head out for the day!")
	UI:WaitShowDialogue("You can take a look too if you think it'll help you!")	
	GeneralFunctions.EndConversation(chara)
end


return guild_bottom_right_bedroom_ch_3