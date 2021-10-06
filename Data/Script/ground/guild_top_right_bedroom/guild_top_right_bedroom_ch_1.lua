require 'common'
require 'PartnerEssentials'
require 'CharacterEssentials'
require 'GeneralFunctions'

guild_top_right_bedroom_ch_1 = {}


function guild_top_right_bedroom_ch_1.SetupGround()
	local audino = CharacterEssentials.MakeCharactersFromList({
		{'Audino', 'Audino_Bed'}
	})
	
	GROUND:CharSetAnim(audino, "Sleep", true)

	GAME:FadeIn(20)

end

function guild_top_right_bedroom_ch_1.Audino_Action(chara, activator)
	local audino = CH('Audino')
	GeneralFunctions.Monologue("(" .. audino:GetDisplayName() .. " is sleeping.)\n (Best to let her rest.)")
end



return guild_top_right_bedroom_ch_1