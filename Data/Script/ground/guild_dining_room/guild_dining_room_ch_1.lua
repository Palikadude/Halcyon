
require 'common'
require 'PartnerEssentials'
require 'CharacterEssentials'

guild_dining_room_ch_1 = {}


function guild_dining_room_ch_1.SetupGround()
	local snubbull = CharacterEssentials.MakeCharactersFromList({
		{'Snubbull', 320, 160, Direction.Down}
	})
	
	AI:SetCharacterAI(snubbull, "ai.ground_default", RogueElements.Loc(320, 160), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)



end


function guild_dining_room_ch_1.Snubbull_Action(chara, activator)
	UI:SetSpeaker(chara)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Test.")
end

return guild_dining_room_ch_1