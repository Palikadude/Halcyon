require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

altere_pond_ch_3 = {}


function altere_pond_ch_3.Relicanth_Action(chara, activator)
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("relic_forest")
	if not SV.Chapter3.DefeatedBoss then


		GeneralFunctions.StartConversation(chara, "Who's there?", "Normal", true, false)
		
		GAME:WaitFrames(20)
		UI:SetSpeaker(partner)
		UI:WaitShowDialogue("Hi " .. chara:GetDisplayName() .. ".[pause=0] It's me,[pause=10] " .. partner:GetDisplayName() .. ".")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(chara)
		UI:WaitShowDialogue(partner:GetDisplayName() .. ".[pause=0] Have you come to hear another story?")
		GAME:WaitFrames(20)
			
		UI:SetSpeaker(partner)
		UI:WaitShowDialogue("I'd love to listen to one of your stories right now,[pause=10] but me and " .. hero:GetDisplayName() .. " have a job to get to!")
		UI:WaitShowDialogue("We'll come back to listen another time,[pause=10] OK?")
		
		GAME:WaitFrames(20)
		UI:SetSpeaker(chara)
		UI:WaitShowDialogue("Hmmph.[pause=0] Very well.[pause=0] Make sure you keep out of trouble in the meanwhile.")
	else
		GeneralFunctions.StartConversation(chara, partner:GetDisplayName() .. ".[pause=0] I hope you and your friend there continue to keep out of trouble.", "Normal", true, false)
		UI:WaitShowDialogue("Just because my eyes aren't what they used to be doesn't mean I won't know if you're up to something!")
	end
	GeneralFunctions.EndConversation(chara, false)
end 
