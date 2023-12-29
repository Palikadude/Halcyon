require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

ledian_dojo_ch_4 = {}

--NOTE: Gible and Ledian appear on the map without needing to be spawned in.
function ledian_dojo_ch_4.SetupGround()
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

--todo: depending on when the first trial is added, perhaps replace dialogue here with info on trials?
function ledian_dojo_ch_4.Gible_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "Of course![pause=0] Sensei " .. CharacterEssentials.GetCharacterName("Ledian") .. " and I would be happy to help you train!", "Normal", false)
	else
		GeneralFunctions.StartConversation(chara, "No problem![pause=0] I'm glad we were able to help you become stronger and more confident!", "Happy", false)
	end
	GeneralFunctions.EndConversation(chara)
end

	

function ledian_dojo_ch_4.Azumarill_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "Can you help " .. chara:GetDisplayName() .. " get strong so that outlaws won't hurt " .. chara:GetDisplayName() .. "?", "Worried", false)
	else
		GeneralFunctions.StartConversation(chara, "Thank you so much for helping " .. chara:GetDisplayName() .. " train in the dojo!", "Happy", false)
		UI:WaitShowDialogue(chara:GetDisplayName() .. " feels much less afraid now that " .. chara:GetDisplayName() .. " has gotten stronger!")
	end
	GeneralFunctions.EndConversation(chara)
end
