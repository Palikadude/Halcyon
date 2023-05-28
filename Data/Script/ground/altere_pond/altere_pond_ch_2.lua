require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

altere_pond_ch_2 = {}

function altere_pond_ch_2.SetupGround()
	--prevent player from going into relic forest during chapter 2
	if not SV.Chapter2.FinishedFirstDay then 
		GROUND:AddMapStatus("dusk")--set dusk if first day
	end
	
	local forestBlock = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1), 
						RogueElements.Rect(904, 256, 8, 88),
						RogueElements.Loc(0, 0), 
						true, 
						"Event_Trigger_1")
																					
	forestBlock:ReloadEvents()

	GAME:GetCurrentGround():AddTempObject(forestBlock)
		
	GAME:FadeIn(20)
end

function altere_pond_ch_2.Relicanth_Action(chara, activator)
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("relic_forest")

	GeneralFunctions.StartConversation(chara, partner:GetDisplayName() .. ",[pause=10] is that you?[pause=0] You are keeping out of trouble,[pause=10] I trust?", "Normal", true, false)
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GROUND:CharSetEmote(partner, "sweating", 1)
	UI:WaitShowDialogue("Yes " .. chara:GetDisplayName() .. ",[pause=10] it's me.[pause=0] And naturally I'm keeping out of trouble!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(chara)
	UI:WaitShowDialogue("Hmmph.[pause=0] You better be.[pause=0] I don't want to catch you going into " .. zone:GetColoredName() .. " again.")
	GAME:WaitFrames(20)
	
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(partner, "Sweatdrop", true)
	
	GROUND:CharTurnToCharAnimated(partner, chara, 4)
	GROUND:CharTurnToCharAnimated(hero, chara, 4)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Stunned")
	UI:WaitShowDialogue("Of course![pause=0] You know I would never do something as irresponsible as that...")
	GeneralFunctions.EndConversation(chara, false)
end 

function altere_pond_ch_2.Event_Trigger_1_Touch(obj, activator)
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("relic_forest")
	local zone2 = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("illuminant_riverbed")


	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	
	
	if SV.Chapter2.FinishedTraining and not SV.Chapter2.FinishedFirstDay then
		
		GeneralFunctions.StartPartnerConversation("I don't think we have time to go into " .. zone:GetColoredName() .. " before dinner.")
		UI:WaitShowDialogue("Let's come back when we have some free time to explore!")

	else 
		
		GeneralFunctions.StartPartnerConversation("We can't go exploring " .. zone:GetColoredName() .. " now!")
		UI:WaitShowDialogue("We need to rescue " .. CharacterEssentials.GetCharacterName('Numel') .. "![pause=0] Quickly,[pause=10] to " .. zone2:GetColoredName() .. "!")
	end
	
	GeneralFunctions.EndConversation(partner)

end