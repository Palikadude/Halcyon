require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_inn_ch_3 = {}

function metano_inn_ch_3.SetupGround()
	if SV.Chapter3.DefeatedBoss then
		
		local nidorina, nidoking, nidoran_m = 
		CharacterEssentials.MakeCharactersFromList({
			{'Nidorina', 'Innkeeper_Right'},
			{'Nidoking', 'Innkeeper_Left'},
			{'Nidoran_M', 280, 184, Direction.Down}

		})
		
		AI:SetCharacterAI(nidoran_m, "ai.ground_default", RogueElements.Loc(264, 168), RogueElements.Loc(32, 32), 1, 16, 64, 40, 180)

	else 
		GROUND:Hide('Innkeeper_Desk_Left')
		
		local nidoqueen, nidoran_m, seviper, zangoose = 
			CharacterEssentials.MakeCharactersFromList({
				{'Nidoqueen', 'Innkeeper_Right'},
				{'Nidoran_M', 168, 192, Direction.Down},
				{'Seviper', 317, 273, Direction.Up},
				{'Zangoose', 317, 210, Direction.Down}

			})
		
		AI:SetCharacterAI(nidoran_m, "ai.ground_default", RogueElements.Loc(152, 176), RogueElements.Loc(32, 32), 1, 16, 64, 40, 180)
	end

	GAME:FadeIn(20)
end



function metano_inn_ch_3.Nidoran_M_Action(chara, activator)
	if not SV.Chapter3.DefeatedBoss then 
		GeneralFunctions.StartConversation(chara, "Googoogagee!")
	else
		GeneralFunctions.StartConversation(chara, ".........")
		GROUND:CharSetEmote(chara, "question", 1)
		SOUND:PlayBattleSE('EVT_Emote_Confused')
		UI:WaitShowDialogue("...Nyuh?[pause=40]")
	end
	GeneralFunctions.EndConversation(chara)
end


function metano_inn_ch_3.Innkeeper_Desk_Left_Action(chara, activator)
	local nidoking = CH('Nidoking')
	GeneralFunctions.StartConversation(nidoking, "My daughter here is helpin' me man the front desk today!")
	UI:WaitShowDialogue("I'm hopin' to teach 'er some of the skills of the trade by sittin' up here wit' me!")
	GeneralFunctions.EndConversation(nidoking)
end

function metano_inn_ch_3.Innkeeper_Desk_Right_Action(chara, activator)
	if not SV.Chapter3.DefeatedBoss then 
		local nidoqueen = CH('Nidoqueen')
		GeneralFunctions.StartConversation(nidoqueen, "Seems like nothin' dangerous was afoot in town after all.[pause=0] That young'un had just wandered off was all!")
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("Guess I don't need to be worryin' 'bout no danger comin' to my youngsters then!")
		GeneralFunctions.EndConversation(nidoqueen)
	else 
		local nidorina = CH('Nidorina')
		GeneralFunctions.StartConversation(nidorina, ".........")
		UI:WaitShowDialogue("...Whatever.")
		GeneralFunctions.EndConversation(nidorina)
	end
end



function metano_inn_ch_3.Zangoose_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "This inn is one of the best places we've stayed at in our travels.[pause=0] Guess it's earned its reputation.")
	--too long with no nicknames
	UI:WaitShowDialogue("As nice as it is,[pause=10] I'd prefer if we were out getting work done instead of lollygagging like " .. CharacterEssentials.GetCharacterName("Seviper") .. " there wants to.")
	UI:WaitShowDialogue("Suppose that's what a professional like me gets for parterning up with a layabout like him.")
	GeneralFunctions.EndConversation(chara)
end

function metano_inn_ch_3.Seviper_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "There'ssss been a lot of outlaw activity in this region lately.")
	UI:WaitShowDialogue("Sssso " .. CharacterEssentials.GetCharacterName("Zangoose") .. " and I are sssstaying in this inn while we hunt bountiessss around here.")
	UI:WaitShowDialogue("Though he issss too keen to sssstay here at the inn,[pause=10] rather than go out and do our jobssss.")
	UI:WaitShowDialogue("He issss jusssst not a hard-worker like I am.")
	GeneralFunctions.EndConversation(chara)
end