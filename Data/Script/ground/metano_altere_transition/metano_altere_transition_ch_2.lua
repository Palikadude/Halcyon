require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'

metano_altere_transition_ch_2 = {}


	
function metano_altere_transition_ch_2.SetupGround()
	--make it dusk if we're on the first day
	if not SV.Chapter2.FinishedFirstDay then 
		GROUND:AddMapStatus("dusk")
	end
	
	GAME:FadeIn(20)
end