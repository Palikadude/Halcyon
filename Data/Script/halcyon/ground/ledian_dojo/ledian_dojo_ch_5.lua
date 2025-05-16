require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

ledian_dojo_ch_5 = {}

--NOTE: Gible and Ledian appear on the map without needing to be spawned in.
function ledian_dojo_ch_5.SetupGround()
	if not SV.Chapter4.FinishedGrove then
		GROUND:TeleportTo(CH('Gible'), 144, 160, Direction.Up)
		
		local azumarill = 
			CharacterEssentials.MakeCharactersFromList({
				{'Azumarill', 144, 128, Direction.Down}
			})

	else 
		GROUND:TeleportTo(CH('Gible'), 224, 224, Direction.UpRight)
		
		local azumarill = 
			CharacterEssentials.MakeCharactersFromList({
				{'Azumarill', 256, 192, Direction.DownLeft}
			})

	end

end

function ledian_dojo_ch_5.Gible_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "alo ")
	GeneralFunctions.EndConversation(chara)
end

	