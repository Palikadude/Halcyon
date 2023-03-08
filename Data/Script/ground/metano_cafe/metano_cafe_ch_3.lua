require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_cafe_ch_3 = {}

function metano_cafe_ch_3.SetupGround()
	if not SV.Chapter3.DefeatedBoss then
		local breloom, girafarig, gulpin, lickitung = 
			CharacterEssentials.MakeCharactersFromList({
				{'Breloom', 'Cafe_Table_9'},
				{'Girafarig', 'Cafe_Table_10'},
				{'Gulpin', 'Cafe_Table_2'},
				{'Lickitung', 'Cafe_Table_1'}
			})
	else
		local cleffa, aggron, gulpin, lickitung = 
			CharacterEssentials.MakeCharactersFromList({
				{'Cleffa', 'Cafe_Table_5'},
				{'Aggron', 'Cafe_Table_6'},
				{'Gulpin', 'Cafe_Table_2'},
				{'Lickitung', 'Cafe_Table_1'}
			})
	end
		
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
	UI:WaitShowDialogue("You'll get there some day![pause=0] You've got us and the rest of the guild behind you rearing for you!")
	
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
		GeneralFunctions.StartConversation(chara, "You'll get to our level some day![pause=0] You've got us and the rest of the guild behind you rearing for you!", "Happy")
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
	if not SV.Chapter3.DefeatedBoss then
		GeneralFunctions.StartConversation(chara, "With the café open again,[pause=10] me and " .. CharacterEssentials.GetCharacterName("Gulpin") .. " can get our daily drinks again.")
		UI:WaitShowDialogue("I'm a big fan of the drinks here,[pause=10] but " .. CharacterEssentials.GetCharacterName("Gulpin") .. " is a total fanatic compared to me.")
	else
		local item = RogueEssence.Dungeon.InvItem('cafe_domi_blend')
		GeneralFunctions.StartConversation(chara, item:GetDisplayName() .. " is " .. CharacterEssentials.GetCharacterName("Shuckle") .. "'s specialty.[pause=0] Despite the odd ingredients,[pause=10] it's very healthy for you.")
		UI:WaitShowDialogue("The taste,[pause=10] on the other hand,[pause=10] leaves something to be desired...")
	end
	GeneralFunctions.EndConversation(chara)
end 

function metano_cafe_ch_3.Gulpin_Action(chara, activator)
	if not SV.Chapter3.DefeatedBoss then
		GeneralFunctions.StartConversation(chara, "Hooray![pause=0] Precious drink,[pause=10] you are mine again to savor...!", "Happy")
	else
		GeneralFunctions.StartConversation(chara, "Mmmm...[pause=0] " .. STRINGS:Format('\\uE0A7').. "[color=#FFCEFF]Apple Cider[color]...[pause=0] So delicious and filling...", "Inspired")
	end
	GeneralFunctions.EndConversation(chara)
end 



function metano_cafe_ch_3.Cleffa_Action(chara, activator)
	local item = RogueEssence.Dungeon.InvItem('cafe_cheri_bomb')
	GeneralFunctions.StartConversation(chara, "You moron![pause=0] This is a café,[pause=10] " .. CharacterEssentials.GetCharacterName("Shuckle") .. " sells drinks![pause=0]\nOf course we're going to drink the " .. item:GetDisplayName() .. "!", "Determined", false)
	UI:WaitShowDialogue("If it's volatile,[pause=10] it'll give us an attack boost![pause=0]\nGive me it so I can carry your dead weight!")
	GeneralFunctions.EndConversation(chara)
end

function metano_cafe_ch_3.Aggron_Action(chara, activator)
	local item = RogueEssence.Dungeon.InvItem('cafe_cheri_bomb')
	GeneralFunctions.StartConversation(chara, "Hey boss...[pause=0] I got this " .. item:GetDisplayName() .. " from " .. CharacterEssentials.GetCharacterName("Shuckle") .. "...", "Normal", false)
	UI:WaitShowDialogue("He said not to drink it,[pause=10] since it's volatile...[pause=0] Maybe we could throw it instead of drinking it?")
	GeneralFunctions.EndConversation(chara)
end