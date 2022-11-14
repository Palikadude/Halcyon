require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

altere_pond_ch_3 = {}


function altere_pond_ch_3.Relicanth_Action(chara, activator)
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("relic_forest")

	GeneralFunctions.StartConversation(chara, "Who's there?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("Hi " .. chara:GetDisplayName() .. ".[pause=0] It's me,[pause=10] " .. chara:GetDisplayName() .. ".")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(chara)
	UI:WaitShowDialogue(partner:GetDisplayName() .. ".[pause=0] Have you come to hear another story?")
	GAME:WaitFrames(20)
		
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("I'd love to listen to one of your stories right now,[pause=10] but we have a mission to get to!")
	UI:WaitShowDialogue("We'll come back to listen another time,[pause=10] OK?")
	
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("Hmmph.[pause=0] Very well.[pause=0] Make sure you keep out of trouble in the meanwhile.")
	GeneralFunctions.EndConversation(chara)
end 
