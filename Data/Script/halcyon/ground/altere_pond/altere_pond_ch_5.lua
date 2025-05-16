require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

altere_pond_ch_5 = {}

function altere_pond_ch_5.SetupGround()
	--prevent player from going into relic forest before the expedition
	local forestBlock = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1), 
						RogueElements.Rect(904, 256, 8, 88),
						RogueElements.Loc(0, 0), 
						true, 
						"Event_Trigger_1")
																					
	forestBlock:ReloadEvents()

	GAME:GetCurrentGround():AddTempObject(forestBlock)
		
	GAME:FadeIn(20)
end

function altere_pond_ch_5.Relicanth_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Placeholder.", "Normal", true, false)
	GeneralFunctions.EndConversation(chara, false)
end 


function altere_pond_ch_5.Event_Trigger_1_Touch(obj, activator)
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("relic_forest")

	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	
	GeneralFunctions.StartPartnerConversation("There's no time for any adventures in " .. zone:GetColoredName() .. "![pause=0] We have to prepare for the expedition!")
	UI:WaitShowDialogue("When you feel we're ready,[pause=10] we need to go see the Guildmaster in his office.")
	UI:WaitShowDialogue("After that we'll be on the road in no time!")
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("Ooooh,[pause=10] it's so exciting![pause=0] Let's go finish preparing,[pause=10] " .. hero:GetDisplayName() .. "!")	
	GeneralFunctions.EndConversation(partner)

end