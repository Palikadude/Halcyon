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
		if not SV.Chapter4.SpokeToRelicanthDayOne then 
			GeneralFunctions.StartConversation(chara, partner:GetDisplayName() .. ",[pause=10] is that you?[pause=0] Trying to sneak into " .. zone:GetColoredName() .. " again,[pause=10] hmm?", "Normal", true, false)
			
			GAME:WaitFrames(20)
			UI:SetSpeaker(partner)
			UI:WaitShowDialogue("No,[pause=10] " .. CharacterEssentials.GetCharacterName("Relicanth") .. ".[pause=0] We came by to visit!")
			UI:WaitShowDialogue("It must get lonely out here,[pause=10] being all by yourself,[pause=10] so we wanted to come say hello!")
			
			GAME:WaitFrames(20)
			UI:SetSpeaker(relicanth)
			UI:WaitShowDialogue("Hmmph.[pause=0] There is no need for that.[pause=0] I'm perfectly fine being here alone.")
			UI:WaitShowDialogue("But,[pause=10] since you are here...[pause=0] Would you care to listen to a story?")
			
			GAME:WaitFrames(20)
			UI:SetSpeaker(partner)
			UI:SetSpeakerEmotion("Worried")
			UI:WaitShowDialogue("Sorry,[pause=10] " .. relicanth:GetDisplayName() .. "...[pause=0] Me and " .. hero:GetDisplayName() .. " have an important mission to do today!")
			UI:SetSpeakerEmotion("Normal")
			UI:WaitShowDialogue("Maybe once we're done we'll come by and hear your story!")
			
			GAME:WaitFrames(20)
			UI:SetSpeaker(relicanth)
			UI:WaitShowDialogue("Hmmph.[pause=0] You young ones always seem to have something on your plate...")
			UI:WaitShowDialogue("Very well,[pause=10] come see me when you are finished and I'll tell you a story.")
			SV.Chapter4.SpokeToRelicanthDayOne = true
		else 
			GeneralFunctions.StartConversation(chara, "Hmmph.[pause=0] You young ones always seem to have something on your plate...", "Normal", true, false)
			UI:WaitShowDialogue("Very well,[pause=10] come see me when you are finished and I'll tell you a story.")
		end
	else
		--tell a story. Perhaps something alluding to the upcoming expedition
		GeneralFunctions.StartConversation(chara, "Placeholder. I need to figure out more details before he tells his story. Sorry! :v)", "Normal", true, false)
	end
	GeneralFunctions.EndConversation(chara, false)
end 
