require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

altere_pond_ch_4 = {}


function altere_pond_ch_4.Relicanth_Action(chara, activator)
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local relicanth = CH('Relicanth')
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("relic_forest")
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, partner:GetDisplayName() .. ".[pause=0] I know I may come off as strict and grouchy,[pause=10] but that is not because I wish to drive you or others away.", "Normal", true, false)
		UI:WaitShowDialogue("In fact,[pause=10] I rather enjoy it when you come to visit.[pause=0] It gets quite lonely at the pond here.")
		
		GAME:WaitFrames(20)
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("And we're happy to visit![pause=0] I love to listen to your stories!")
		
		GAME:WaitFrames(20)
		UI:SetSpeaker(relicanth)
		UI:WaitShowDialogue("Thank you,[pause=10] " .. partner:GetDisplayName() .. ".[pause=0] That does cheer up this old heart a bit.[pause=0] Would you care for a story now?")
		
		GAME:WaitFrames(20)
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue("Sorry,[pause=10] " .. relicanth:GetDisplayName() .. "...[pause=0] Me and " .. hero:GetDisplayName() .. " have an important mission to do today!")
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("Maybe once we'll done we'll come by and hear one of your stories!")
		
		GAME:WaitFrames(20)
		UI:SetSpeaker(relicanth)
		UI:WaitShowDialogue("Hmmph.[pause=0] You young ones always seem to have something on your plate...")
		UI:WaitShowDialogue("Very well,[pause=10] come see me when you are finished and I'll tell you a story.")
	else
		--tell a story. Perhaps something alluding to the upcoming expedition
		GeneralFunctions.StartConversation(chara, "Placeholder. I need to figure out more details before he tells his story.", "Normal", true, false)
	end
	GeneralFunctions.EndConversation(chara, false)
end 
