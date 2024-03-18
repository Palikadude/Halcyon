require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_cafe_ch_4 = {}

function metano_cafe_ch_4.SetupGround()
	if not SV.Chapter4.FinishedGrove then
		local gulpin, lickitung, linoone = 
			CharacterEssentials.MakeCharactersFromList({
				{'Gulpin', 'Cafe_Table_2'},
				{'Lickitung', 'Cafe_Table_1'},
				{'Linoone', 'Cafe_Table_14'}
			})
	else
		local gulpin, lickitung, mareep, cranidos = 
			CharacterEssentials.MakeCharactersFromList({
				{'Gulpin', 'Cafe_Table_2'},
				{'Lickitung', 'Cafe_Table_1'},
				{'Mareep', 'Cafe_Table_9'},
				{'Cranidos', 'Cafe_Table_10'}
			})
	end
		
	GAME:FadeIn(20)
end



function metano_cafe_ch_4.Lickitung_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		local item = RogueEssence.Dungeon.InvItem('cafe_endurance_tonic')
		GeneralFunctions.StartConversation(chara, "You hear the news?[pause=0] " .. CharacterEssentials.GetCharacterName("Shuckle") .. " just added a new drink to the menu.")
		UI:WaitShowDialogue("He calls it " .. item:GetDisplayName() .. ".[pause=0] He says that it helps with hanging on in tough situations.")
	else
		GeneralFunctions.StartConversation(chara, "Besides his drinks,[pause=10] " .. CharacterEssentials.GetCharacterName("Shuckle") .. " also has a daily special he sells on the side.")
		UI:WaitShowDialogue("The special isn't always great,[pause=10] but sometimes he has something you won't be able to find anywhere else.")
	end
	GeneralFunctions.EndConversation(chara)
end 

function metano_cafe_ch_4.Gulpin_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		local item = RogueEssence.Dungeon.InvItem('cafe_endurance_tonic')
		GeneralFunctions.StartConversation(chara, "So tasty...[pause=0] When I drink " .. item:GetDisplayName() .. ",[pause=10] I feel like nothing can stop me...", "Inspired")
	else
		local item = RogueEssence.Dungeon.InvItem('food_apple_perfect')
		GeneralFunctions.StartConversation(chara, "One time,[pause=10] " .. CharacterEssentials.GetCharacterName("Shuckle") .. " had a " .. item:GetDisplayName() .. " as the side special for the day!", "Normal")
		UI:SetSpeakerEmotion("Inspired")
		UI:WaitShowDialogue("It was so tasty...[pause=0] Mmmm...[pause=0] I'm drooling just thinking about it...")
		UI:SetSpeakerEmotion("Sad")
		UI:WaitShowDialogue("But he hasn't sold another for some time now...[pause=0] Oh,[pause=10] woe is me...")
	end
	GeneralFunctions.EndConversation(chara)
end 

function metano_cafe_ch_4.Linoone_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "I'm still reading this book on mystery dungeons.[pause=0] This chapter talks about the stairs within dungeons.")
		UI:WaitShowDialogue("It says that while all mystery dungeons have stairs that lead forward,[pause=10] some also have stairs that lead back.")
		UI:WaitShowDialogue("The type of stairs that leads forward depends on whether it's an ascending or descending dungeon.")
		UI:WaitShowDialogue("...That doesn't make sense though.")
		UI:WaitShowDialogue("Mystery dungeons are in places such as caves and forests as far as I understand.")
		UI:WaitShowDialogue("What would stairs be doing in the middle of a place such as that?[pause=0] Mystery dungeons truly are strange.")
	else
		--N/A
	end
	GeneralFunctions.EndConversation(chara)
		
end


function metano_cafe_ch_4.Cranidos_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		--N/A
	else
		if not SV.Chapter4.CranidosBlush then
			GeneralFunctions.StartConversation(chara, "Even with the expedition approaching,[pause=10] I'd rather continue nabbing outlaws than rest here.")
			UI:WaitShowDialogue("But this is what " .. CharacterEssentials.GetCharacterName("Mareep") .. " wants to do.[pause=0] And spending time with her like this is nice too...")
			GAME:WaitFrames(40)
			GeneralFunctions.EmoteAndPause(chara, "Exclaim", true)
			GROUND:CharSetEmote(cranidos, "sweating", 1)
			UI:SetSpeakerEmotion("Surprised")
			UI:WaitShowDialogue("U-umm![pause=0] I m-mean...")
			GAME:WaitFrames(20)
			UI:SetSpeakerEmotion("Special0")
			UI:WaitShowDialogue("D-don't you rookies have anything better to do than laze around here?[pause=0] Go do something productive for once!")
			SV.Chapter4.CranidosBlush = true
		else 
			GeneralFunctions.StartConversation(chara, "H-hey...[pause=0] Please don't tell her what I said earlier...", "Special0")
		end
	end
	GeneralFunctions.EndConversation(chara)
		
end

function metano_cafe_ch_4.Mareep_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		--N/A
	else
		GeneralFunctions.StartConversation(chara, "Hi you two![pause=0] Me and " .. CharacterEssentials.GetCharacterName("Cranidos") .. " are relaxing here until the expedition sta-a-a-arts!", "Happy")
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("Once we leave,[pause=10] it'll be a long time before we can come back to town,[pause=10] so we gotta relax while we still can!")
	end
	GeneralFunctions.EndConversation(chara)
		
end
