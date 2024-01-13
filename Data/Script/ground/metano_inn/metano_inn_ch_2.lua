require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_inn_ch_2 = {}

function metano_inn_ch_2.SetupGround()

	if not SV.Chapter2.FinishedFirstDay then 
		GROUND:Hide('Innkeeper_Desk_Right')
		
		local nidoking, nidoqueen, nidoran_m, makuhita = 
			CharacterEssentials.MakeCharactersFromList({
				{'Nidoking', 'Innkeeper_Left'},
				{'Nidoqueen', 168, 144, Direction.Right},
				{'Nidoran_M', 264, 152, Direction.UpLeft},
				{'Makuhita', 128, 248, Direction.DownRight}
			})
		
		AI:SetCharacterAI(nidoqueen, "ai.ground_default", RogueElements.Loc(152, 128), RogueElements.Loc(32, 32), 1, 16, 64, 40, 180)
		AI:SetCharacterAI(nidoran_m, "ai.ground_default", RogueElements.Loc(248, 136), RogueElements.Loc(32, 32), 1, 16, 64, 40, 180)
		AI:SetCharacterAI(makuhita, "ai.ground_default", RogueElements.Loc(112, 232), RogueElements.Loc(32, 32), 1, 16, 64, 40, 180)
		

	else
		local nidoking, nidoqueen, nidoran_m, nidorina, makuhita = 
		CharacterEssentials.MakeCharactersFromList({
			{'Nidoking', 'Innkeeper_Left'},
			{'Nidoqueen', 'Innkeeper_Right'},
			{'Nidoran_M', 316, 164, Direction.Left},
			{'Nidorina', 264, 152, Direction.Down},
			{'Makuhita', 293, 273, Direction.Up}
		})
		
		AI:SetCharacterAI(nidorina, "ai.ground_default", RogueElements.Loc(248, 136), RogueElements.Loc(32, 32), 1, 16, 64, 40, 180)
		GROUND:CharSetAnim(nidoran_m, "Sleep", true)
	end
	
	GAME:FadeIn(20)
end


function metano_inn_ch_2.Innkeeper_Desk_Left_Action(chara, activator)
	local nidoking = CH('Nidoking')
	if not SV.Chapter2.FinishedFirstDay then
		GeneralFunctions.StartConversation(nidoking, "Howdy y'all![pause=0] Welcome to the Metano Inn![pause=0] Can I get y'all a couple of beds for the evenin'?")
		UI:WaitShowDialogue("...What's that?[pause=0] Y'all live in the guild?")
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("Well,[pause=10] y'all still welcome here anytime ya like![pause=0] Don't be a stranger!")
	else 
		GeneralFunctions.StartConversation(nidoking, "Poor " .. CharacterEssentials.GetCharacterName('Camerupt') .. "'s young'un has gone missin'.")
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue("Always a shame to hear somethin' like this happenin' to townsfolk.")
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("Me and the missus need to pay her a visit later to see how she's holdin' up.")
	end
	GeneralFunctions.EndConversation(nidoking)
end

function metano_inn_ch_2.Nidoran_M_Action(chara, activator)
	if not SV.Chapter2.FinishedFirstDay then 
		GeneralFunctions.StartConversation(chara, "Goo...[pause=20] gaa!")
		GeneralFunctions.EndConversation(chara)
	else 
		UI:SetSpeaker(chara:GetDisplayName(),true, "", -1, "", RogueEssence.Data.Gender.Unknown)
		GeneralFunctions.StartConversation(chara, "ZZZzzz...", "Normal", false, false, false)
		GeneralFunctions.EndConversation(chara, false)
	end
end


--she isn't behind the desk on day 1
function metano_inn_ch_2.Nidoqueen_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "That's my hubby mannin' the front desk over yonder.")
	GROUND:CharSetEmote(chara, "happy", 0)
	UI:SetSpeakerEmotion("Special0")
	UI:WaitShowDialogue("He's a real catch,[pause=10] isn't he![pause=0] I'm real proud of him and our two kids!")
	GROUND:CharSetEmote(chara, "", 0)
	GeneralFunctions.EndConversation(chara)
end

--only active on day 2 
function metano_inn_ch_2.Innkeeper_Desk_Right_Action(chara, activator)
	local nidoqueen = CH('Nidoqueen')
	GeneralFunctions.StartConversation(nidoqueen, "We heard that one of the youngsters in town went missin' and now not a soul knows where he is.", "Worried")
	UI:WaitShowDialogue("We're keepin' a close eye on our young'uns until he's returned safely,[pause=10] just in case somethin' dangerous's afoot.")
	GeneralFunctions.EndConversation(nidoqueen)
end

function metano_inn_ch_2.Nidorina_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Can't believe I'm not allowed out until that stupid kid is found.", "Determined")
	UI:WaitShowDialogue("Just cause some dumb brat runs off doesn't mean I'm going to![pause=0] But of course my parents don't get that!")
	UI:SetSpeakerEmotion("Angry")
	UI:WaitShowDialogue("UGH![pause=0] This is so annoying![pause=0] And they're so annoying too!")
	GeneralFunctions.EndConversation(chara)
end


function metano_inn_ch_2.Passerby_1_Action(chara, activator)
	if not SV.Chapter2.FinishedFirstDay then 
		GeneralFunctions.StartConversation(chara, "I'm passing through this area and decided to rest for a while at the inn here.")
		UI:WaitShowDialogue("I've heard great things about the Metano Inn from others in my travels.[pause=0] I hope they were right!")
	else 
		GeneralFunctions.StartConversation(chara, "Last night's sleep was some of the best I've ever had.[pause=0] This really is a great inn!")
		UI:WaitShowDialogue("The continental breakfast leaves much to be desired though...[pause=0] These portions are way too little!") 
	end
	GeneralFunctions.EndConversation(chara)
end