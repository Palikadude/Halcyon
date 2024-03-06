require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

guild_guildmasters_room_ch_5 = {}

function guild_guildmasters_room_ch_5.SetupGround()

	local tropius = CH('Tropius')
	GROUND:TeleportTo(tropius, 280, 168, Direction.DownRight)


	local noctowl, girafarig, breloom = 
		CharacterEssentials.MakeCharactersFromList({
			{"Noctowl", 296, 224, Direction.UpRight},
			{"Girafarig", 280, 208, Direction.Right},
			{"Breloom", 296, 200, Direction.Right}
		})
		
		
	GAME:FadeIn(20)
	
end


--expeditionTODO
function guild_guildmasters_room_ch_5.Tropius_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "i'm overseeing the discussion. Ready to go?")
	--Set flags needed for the expedition, and send home characters in slots 3/4.
	GAME:SetCanRecruit(false)--disable recruiting for duration of expedition
	SV.Chapter5.ReadyForExpedition = true
	GeneralFunctions.DefaultParty(false)
	GeneralFunctions.EndConversation(chara)
end

--expeditionTODO
function guild_guildmasters_room_ch_5.Noctowl_Action(chara, activator)
	
end

--expeditionTODO
function guild_guildmasters_room_ch_5.Breloom_Action(chara, activator)
	
end

--expeditionTODO
function guild_guildmasters_room_ch_5.Girafarig_Action(chara, activator)
	
end

return guild_guildmasters_room_ch_5