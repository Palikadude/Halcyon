require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_cafe_ch_4 = {}

function metano_cafe_ch_4.SetupGround()
	if not SV.Chapter4.FinishedGrove then
		local breloom, girafarig, gulpin, lickitung = 
			CharacterEssentials.MakeCharactersFromList({
				{'Gulpin', 'Cafe_Table_2'},
				{'Lickitung', 'Cafe_Table_1'},
				{'Linoone', 'Cafe_Table_14'}
			})
	else
		local cleffa, aggron, gulpin, lickitung = 
			CharacterEssentials.MakeCharactersFromList({
				{'Gulpin', 'Cafe_Table_2'},
				{'Lickitung', 'Cafe_Table_1'}
			})
	end
		
	GAME:FadeIn(20)
end



function metano_cafe_ch_4.Lickitung_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		local item = RogueEssence.Dungeon.InvItem('cafe_domi_blend')
		GeneralFunctions.StartConversation(chara, "You hear the news?[pause=0] " .. CharacterEssentials.GetCharacterName("Shuckle") .. " just added a new drink to the menu.")
		UI:WaitShowDialogue("He calls it " .. item:GetDisplayName() .. ".[pause=0] It's supposed to help with hanging on in tough situations,[pause=10] according to him.")
	else
		GeneralFunctions.StartConversation(chara, "Besides his special drinks,[pause=10] " .. CharacterEssentials.GetCharacterName("Shuckle") .. " also has a daily special he sells on the side.")
		UI:WaitShowDialogue("The special isn't always great,[pause=10] but sometimes he has something you won't be able to find anywhere else.")
	end
	GeneralFunctions.EndConversation(chara)
end 

function metano_cafe_ch_4.Gulpin_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		local item = RogueEssence.Dungeon.InvItem('cafe_domi_blend')
		GeneralFunctions.StartConversation(chara, "So tasty...[pause=0] When I drink " .. item:GetDisplayName() .. ",[pause=10] I feel like nothing can stop me...", "Inspired")
	else
		local item = RogueEssence.Dungeon.InvItem('food_apple_perfect')
		GeneralFunctions.StartConversation(chara, "One time,[pause=10] " .. CharacterEssentials.GetCharacterName("Shuckle") .. " had a " .. item:GetDisplayName() .. " as the side special for the day!", "Normal")
		UI:SetSpeakerEmotion("Inspired")
		UI:WaitShowDialogue("It was so tasty...[pause=0] Mmmm...[pause=0] I'm drooling just thinking about it...")
		UI:SetSpeakerEmotion("Sad")
		UI:WaitShowDialogue("But it's been so long since he's sold another...[pause=0] Oh,[pause=10] woe is me...")
	end
	GeneralFunctions.EndConversation(chara)
end 

function metano_cafe_ch_4.Linoone_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "I'm still reading this book on mystery dungeons.[pause=0] This chapter talks about the stairs within dungeons.")
		UI:WaitShowDialogue("It says that while all mystery dungeons have stairs that lead forward,[pause=10] some also have stairs that lead back.")
		UI:WaitShowDialogue("The type of stair that leads forward depends on whether it's an ascending or descending dungeon.")
		UI:WaitShowDialogue("...That doesn't make sense though.")
		UI:WaitShowDialogue("Mystery dungeons are in places such as caves and forests as far as I understand.")
		UI:WaitShowDialogue("What would stairs be doing in the middle of a place such as that?[pause=0] Mystery dungeons truly are a mystery.")
	else
		--N/A
	end
	GeneralFunctions.EndConversation(chara)
		
end

