require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_inn_ch_4 = {}

function metano_inn_ch_4.SetupGround()
	
	if not SV.Chapter4.FinishedGrove then
		local smeargle = 
			CharacterEssentials.MakeCharactersFromList({
				{'Smeargle', 128, 128, Direction.Left},
				{'Nidoqueen', 256, 116, Direction.Right},
				{'Nidoran_M', 288, 116, Direction.Left},
				
			})
	
		AI:SetCharacterAI(smeargle, "ai.ground_default", RogueElements.Loc(112, 112), RogueElements.Loc(32, 32), 1, 16, 64, 40, 180)
	else
		local skorupi = 
			CharacterEssentials.MakeCharactersFromList({
				{'Skorupi', 317, 210, Direction.Down},
				{'Nidorina', 224, 164, Direction.DownLeft}
			})
	end

	GAME:FadeIn(20)
end


function metano_inn_ch_4.Passerby_1_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then 
		GeneralFunctions.StartConversation(chara, "I hope I didn't leave a paint stain on the bed while I was sleeping.")
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue("I don't want to pay an extra fee if I left a mark on the bed by accident...")
	else 
		GeneralFunctions.StartConversation(chara, "The inn's food is so good![pause=0] So much better than the slop back home!", "Inspired")
	end
	GeneralFunctions.EndConversation(chara)
end

function metano_inn_ch_4.Nidoqueen_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "C'mon " .. CharacterEssentials.GetCharacterName("Nidoran_M") .. "![pause=0] Say mama,[pause=10] say mama!", "Normal", false)
	else
	
	end
	GeneralFunctions.EndConversation(chara)	
end

function metano_inn_ch_4.Nidorina_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		--N/A
	else
		--this might be nidorina's calling? cooking, that is
		GeneralFunctions.StartConversation(chara, "Stupid dad making me work in the inn again...[pause=0] Making me prepare the food...", "Determined")
		UI:WaitShowDialogue("I don't want to work in his dumb inn![pause=0] But he doesn't get that,[pause=10] of course not!")
	end
	GeneralFunctions.EndConversation(chara)
end

function metano_inn_ch_4.Nidoran_M_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, ".........")
		UI:WaitShowDialogue(".........")
		UI:WaitShowDialogue("...Eeeuuuwuaawu?")
	else
		GeneralFunctions.StartConversation(chara, "Uhhyeee!")
	end
	GeneralFunctions.EndConversation(chara)
end


function metano_inn_ch_4.Innkeeper_Desk_Right_Action(chara, activator) 
	if not SV.Chapter4.FinishedGrove then
		--N/A
	else 
		local nidoqueen = CH('Nidoqueen')
		GeneralFunctions.StartConversation(nidoqueen, "I'm startin' to worry about my littlest one.", "Worried")
		UI:WaitShowDialogue("He shoulda said his first word by now...[pause=0] I'm hopin' he'll say his first real soon!")
		GeneralFunctions.EndConversation(nidoqueen)
	end
end

function metano_inn_ch_4.Innkeeper_Desk_Left_Action(chara, activator) 
	if not SV.Chapter4.FinishedGrove then
		local nidoking = CH('Nidoking')
		GeneralFunctions.StartConversation("Business been a bit slow as of late...[pause=0] Seems like we only get one or so guests a day!", "Worried")
		UI:WaitShowDialogue("I suppose less Pokémon are on the roads what with the mystery dungeons and outlaws and all...")
		GeneralFunctions.EndConversation(nidoking)	
	else 
	
	end
end