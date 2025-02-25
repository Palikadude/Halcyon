require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_inn_ch_5 = {}

function metano_inn_ch_5.SetupGround()
	local corvisquire, nidoqueen, nidoran_m, nidoking = 
		CharacterEssentials.MakeCharactersFromList({
			{'Corvisquire', 152, 200, Direction.UpLeft},
			{'Nidoqueen', 'Innkeeper_Right'},--Nidoqueen's spot 
			{'Nidoran_M', 240, 128, Direction.DownRight},
			{'Nidoking', 'Innkeeper_Left'}--Nidoking's spot
		})
	
	AI:SetCharacterAI(corvisquire, "halcyon.ai.ground_default", RogueElements.Loc(136, 184), RogueElements.Loc(32, 32), 1, 16, 64, 40, 180)
	AI:SetCharacterAI(nidoran_m, "halcyon.ai.ground_default", RogueElements.Loc(224, 112), RogueElements.Loc(32, 32), 1, 16, 64, 40, 180)

	GAME:FadeIn(20)
end

--Cory cracking lame jokes
function metano_inn_ch_5.Passerby_1_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Seems like everyone in town is CROW-ing about some sort of guild expedition.", "Happy")
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("Those adventurers better proceed with CAW-tion on their trip!")
	UI:SetSpeakerEmotion("Joyous")
	UI:WaitShowDialogue("I'm sure they'll find something pretty FLY![pause=0] They're a TALON-ted bunch after all!")
	--GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("...[pause=30]Why are you looking at me like that?")
	GeneralFunctions.EndConversation(chara)
	--The whole town seems extra busy today! What's everyone CROWING about?
	--Hmm, looks like nobody's INN
	--proceed with caw tion on the expedition
	--Hope they find something pretty FLY!
	--Birds of a feather?
	--They seem talon-ted
end



function metano_inn_ch_5.Nidoran_M_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Inneeways!")
	GeneralFunctions.EndConversation(chara)
end


function metano_inn_ch_5.Innkeeper_Desk_Right_Action(chara, activator) 
	local nidoqueen = CH('Nidoqueen')
	GeneralFunctions.StartConversation(nidoqueen, "I'm startin' to worry about my littlest one.", "Worried")
	UI:WaitShowDialogue("He shoulda said his first word by now...[pause=0] I'm hopin' he'll say his first real soon!")
	GeneralFunctions.EndConversation(nidoqueen)
end

function metano_inn_ch_5.Innkeeper_Desk_Left_Action(chara, activator) 
	local nidoking = CH('Nidoking')
	GeneralFunctions.StartConversation(nidoking, "Business been a bit slow as of late...[pause=0] Seems like we only get one 'er so guests a day!", "Worried")
	UI:WaitShowDialogue("I reckon less Pokémon are on the roads what with the mystery dungeons and outlaws 'n all...")
	GeneralFunctions.EndConversation(nidoking)	
end