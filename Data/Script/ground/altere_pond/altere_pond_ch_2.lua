require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

altere_pond_ch_2 = {}

function altere_pond_ch_2.SetupGround()
	--prevent player from going into relic forest on first day
	if not SV.Chapter2.FinishedFirstDay then 
		local forestBlock = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1), 
							RogueElements.Rect(904, 256, 8, 88),
							RogueElements.Loc(0, 0), 
							true, 
							"Event_Trigger_1")
																						
		forestBlock:ReloadEvents()

		GAME:GetCurrentGround():AddObject(forestBlock)
		
		GROUND:AddMapStatus(51)
		
		GAME:FadeIn(20)
	else
		GAME:FadeIn(20)
	end
end

function altere_pond_ch_2.Relicanth_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Placeholder.")
	GeneralFunctions.EndConversation(chara)
end 

function altere_pond_ch_2.Event_Trigger_1_Touch(obj, activator)
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone].Entries[50]

	if SV.Chapter2.FinishedTraining and not SV.Chapter2.FinishedFirstDay then
		local partner = CH('Teammate1')
		local hero = CH('PLAYER')
		UI:SetSpeaker(partner)
		GROUND:CharTurnToCharAnimated(partner, hero, 4)
		UI:WaitShowDialogue("I don't think we have time to go into " .. zone:GetColoredName() .. " before dinner.")
		GROUND:CharTurnToCharAnimated(hero, partner, 4)
		UI:WaitShowDialogue("Let's some back when we have some free time to explore!")
	end
end