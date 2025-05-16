require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_cafe_ch_5 = {}

function metano_cafe_ch_5.SetupGround()
	local gulpin, lickitung, cleffa, aggron = 
		CharacterEssentials.MakeCharactersFromList({
			{'Gulpin', 'Cafe_Table_2'},
			{'Lickitung', 'Cafe_Table_1'},
			{'Cleffa', 'Cafe_Table_13'},
			{'Aggron', 'Cafe_Table_15'}
		})
	
		
	GAME:FadeIn(20)
end


function metano_cafe_ch_5.Lickitung_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "It was kind of " .. CharacterEssentials.GetCharacterName("Shuckle") .. " to give out free drinks today,[pause=10] but...")
	--GROUND:CharSetEmote(chara, "sweating", 1)
	UI:WaitShowDialogue("With flavor like this,[pause=10] I think he's just getting rid of his extra inventory...")
	GeneralFunctions.EndConversation(chara)
end 

function metano_cafe_ch_5.Gulpin_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "A free drink from " .. CharacterEssentials.GetCharacterName("Shuckle") .. "...[pause=0] It's a dream come true!", "Inspired")
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("...But...[pause=0] Woe is me...[pause=0] It tastes like muddy roots...")
	UI:SetSpeakerEmotion("Pain")
	UI:WaitShowDialogue("...Oh...[pause=0] Luck can be so cruel...")
	GeneralFunctions.EndConversation(chara)
end 

function metano_cafe_ch_5.Cleffa_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "alo")
	GeneralFunctions.EndConversation(chara)
end 

function metano_cafe_ch_5.Aggron_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "alo")
	GeneralFunctions.EndConversation(chara)
end 
--[[
	GeneralFunctions.StartConversation(chara, "You two are leaving on some sort of expedition today,[pause=10] aren't you?[pause=0] You should take some of " .. CharacterEssentials.GetCharacterName("Shuckle") .. "'s drinks along with you.")
	UI:WaitShowDialogue("You never know what might happen on a trip like that.[pause=0] His drinks could come in handy in a pinch.")
	GeneralFunctions.EndConversation(chara)
	
	GeneralFunctions.StartConversation(chara, "Bring as many of " .. CharacterEssentials.GetCharacterName("Shuckle") .. "'s drinks along as you can on your expedition...")
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("They're so tasty...[pause=0] It's important to keep your spirits up on a long journey,[pause=10] after all!")
	GeneralFunctions.EndConversation(chara)
]]--

