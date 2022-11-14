require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_cafe_ch_3 = {}

function metano_cafe_ch_3.SetupGround()
	local breloom, girafarig, gulpin, lickitung = 
		CharacterEssentials.MakeCharactersFromList({
			{'Breloom', 'Cafe_Table_9'},
			{'Girafarig', 'Cafe_Table_10'},
			{'Gulpin', 'Cafe_Table_2'},
			{'Lickitung', 'Cafe_Table_1'}
		})
		
	GAME:FadeIn(20)
end

function metano_cafe_ch_3.Initial_Girafarig_Breloom_Conversation(chara, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local breloom = CH('Breloom')
	local girafarig = CH('Girafarig')
	
	GROUND:CharSetAnim(girafarig, 'None', true)
	GROUND:CharSetAnim(breloom, 'None', true)
	
	GROUND:CharTurnToChar(breloom, hero)
	GROUND:CharTurnToChar(girafarig, hero)
	
	GROUND:CharSetEmote(breloom, "happy", 0)
	GeneralFunctions.StartConversation(breloom, "Hey you two,[pause=10] figures I'd catch you two slackers at the café now that it's open again,[pause=10] heheh!", "Happy")
	GROUND:CharSetEmote(breloom, "", 0)
	UI:WaitShowDialogue("Just kidding![pause=0] What brings you two here?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("Me and " .. hero:GetDisplayName() .. " wanted to check out the café now that it's open for business again.")
	UI:WaitShowDialogue("What are you doing here?")
	
	
	GAME:WaitFrames(20)
	GROUND:CharTurnToChar(partner, girafarig)
	GROUND:CharTurnToChar(hero, girafarig)
	UI:SetSpeaker(girafarig)
	UI:WaitShowDialogue("The three of us wanted to relax before we set out on our expedition.")
	
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(partner, "Question", true)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Expedition?")
	
	GAME:WaitFrames(20)
	GROUND:CharTurnToChar(partner, breloom)
	GROUND:CharTurnToChar(hero, breloom)	
	UI:SetSpeaker(breloom)
	UI:WaitShowDialogue("Yup.[pause=0] We've been planning to explore some ruins up in a far-off mountain range for some time now.")
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("Rumor has it that some amazing secret lies in the ruins there!")
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("But so far,[pause=10] nobody's been able to find anything beyond some old broken structures that don't do anything.")
	UI:WaitShowDialogue("Since " .. girafarig:GetDisplayName() .. " and I are more experienced adventurers than most,[pause=10] we figured we'd take a crack at it.")
	UI:WaitShowDialogue("Originally,[pause=10] we weren't going to leave on our expedition for a couple more weeks...")
	UI:WaitShowDialogue("...But the Guildmaster just requested us to leave on it as soon as we could.")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Inspired")
	GROUND:CharSetEmote(partner, "happy", 0)
	UI:WaitShowDialogue("Wow![pause=0] That's so cool![pause=0] That's the kind of adventuring I want to do!")
	UI:WaitShowDialogue("I can't wait until me and " .. hero:GetDisplayName() .. " can go on adventures like that!")
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(partner, "", 0)
	UI:SetSpeaker(girafarig)
	GROUND:CharTurnToChar(partner, girafarig)
	GROUND:CharTurnToChar(hero, girafarig)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("You'll get there some day![pause=0] You've got us and the rest of the guild behind you rooting for you!")
	
	GAME:WaitFrames(20)
	GROUND:CharTurnToChar(partner, breloom)
	GROUND:CharTurnToChar(hero, breloom)
	UI:SetSpeaker(breloom)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Good luck with your guild work until then![pause=0] " .. girafarig:GetDisplayName() .. " and I are going to be relaxing here until we leave for our trip.")
	
	
	GeneralFunctions.EndConversation(breloom)
	GROUND:CharTurnToChar(breloom, girafarig)
	GROUND:CharTurnToChar(girafarig, breloom)
	GROUND:CharEndAnim(breloom)
	GROUND:CharEndAnim(girafarig)
	SV.Chapter3.BreloomGirafarigConvo = true
end 


function metano_cafe_ch_3.Girafarig_Action(chara, activator)
	if SV.Chapter3.BreloomGirafarigConvo then 
		GeneralFunctions.StartConversation(chara, "You'll get to our level some day![pause=0] You've got us and the rest of the guild behind you rooting for you!", "Happy")
		GeneralFunctions.EndConversation(chara)
	else 
		metano_cafe_ch_3.Initial_Girafarig_Breloom_Conversation(chara, activator)
	end
end 

function metano_cafe_ch_3.Breloom_Action(chara, activator)
	if SV.Chapter3.BreloomGirafarigConvo then 
		GeneralFunctions.StartConversation(chara, "Good luck with your guild work![pause=0] " .. CharacterEssentials.GetCharacterName("Girafarig") .. " and I are going to be relaxing here until we leave for our trip.", "Happy")
		GeneralFunctions.EndConversation(chara)
	else 
		metano_cafe_ch_3.Initial_Girafarig_Breloom_Conversation(chara, activator)
	end
end 


function metano_cafe_ch_3.Lickitung_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "With the café open again,[pause=10] me and " .. CharacterEssentials.GetCharacterName("Gulpin") .. " can get our daily drinks again.")
	UI:WaitShowDialogue("I'm a big fan of the drinks here,[pause=10] but " .. CharacterEssentials.GetCharacterName("Gulpin") .. " is a total fanatic compared to me.")
	GeneralFunctions.EndConversation(chara)
end 

function metano_cafe_ch_3.Gulpin_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Hooray![pause=0] Precious drink,[pause=10] you are mine again to savior...!", "Happy")
	GeneralFunctions.EndConversation(chara)
end 
