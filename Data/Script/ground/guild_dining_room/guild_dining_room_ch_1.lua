
require 'common'
require 'PartnerEssentials'
require 'CharacterEssentials'
require 'GeneralFunctions'

guild_dining_room_ch_1 = {}


function guild_dining_room_ch_1.SetupGround()
	local snubbull = CharacterEssentials.MakeCharactersFromList({
		{'Snubbull', 288, 144, Direction.Down}
	})
	
	AI:SetCharacterAI(snubbull, "ai.ground_default", RogueElements.Loc(272, 128), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)

	GAME:FadeIn(20)

end


function guild_dining_room_ch_1.Snubbull_Action(chara, activator)
	local snubbull = chara
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	
	if not SV.Chapter1.MetSnubbull then
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, snubbull.CurrentForm.Species, snubbull.CurrentForm.Form, snubbull.CurrentForm.Skin, snubbull.CurrentForm.Gender)
		GROUND:CharTurnToCharAnimated(hero, snubbull, 4)
		GROUND:CharTurnToCharAnimated(snubbull, hero, 4)
		GROUND:CharTurnToChar(partner, snubbull)	
		

		GeneralFunctions.Hop(snubbull)
		GROUND:CharSetEmote(snubbull, "angry", 1)
		SOUND:PlayBattleSE('EVT_Emote_Complain_2')
		GeneralFunctions.StartConversation(snubbull, "Ugh![pause=0] How many times do I have tell you!?[pause=0] Stop sneaking in here for snacks after dinner!", "Angry", true, true, false)
		GAME:WaitFrames(20)
		
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue("Hold on...[pause=0] You're not " .. CharacterEssentials.GetCharacterName("Breloom") .. "...")
		UI:WaitShowDialogue("Who are you?[pause=0] Only guild members are supposed to be up here on the top floor.")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion('Normal')
		GROUND:CharTurnToChar(snubbull, partner)
		UI:WaitShowDialogue("Oh,[pause=10] really?[pause=0] We didn't know that.")
		UI:WaitShowDialogue("But either way,[pause=10] we're allowed to be up here!")
		UI:WaitShowDialogue("We just joined the guild earlier today!")
		UI:WaitShowDialogue("We're exploring different rooms to say hello to everyone.")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, snubbull.CurrentForm.Species, snubbull.CurrentForm.Form, snubbull.CurrentForm.Skin, snubbull.CurrentForm.Gender)
		UI:WaitShowDialogue("Oh,[pause=10] alright.[pause=0] I didn't realize we had new recruits today.")
		UI:WaitShowDialogue("Well,[pause=10] welcome to the guild.[pause=0] You'd better not be here to steal snacks either!")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(partner)
		GROUND:CharSetEmote(partner, "sweating", 1)
		--SOUND:PlayBattleSE('EVT_Emote_Sweating')
		UI:SetSpeakerEmotion("Surprised")
		UI:WaitShowDialogue("No no![pause=0] We didn't even know there was food in here before we walked in!")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, snubbull.CurrentForm.Species, snubbull.CurrentForm.Form, snubbull.CurrentForm.Skin, snubbull.CurrentForm.Gender)
		UI:SetSpeakerEmotion("Sad")
		UI:WaitShowDialogue("Oh.[pause=0] Sorry.[pause=0] I'm a bit on edge because " .. CharacterEssentials.GetCharacterName("Breloom") .. " keeps trying to sneak food after dinner.")
		UI:SetSpeakerEmotion("Angry")
		GROUND:CharSetEmote(snubbull, "angry", 0)
		UI:WaitShowDialogue("If he's so hungry,[pause=10] he should just eat more at dinner![pause=0] I can't stand him sometimes!")
		UI:WaitShowDialogue("Does he not like my meals or something!?")
		GROUND:CharSetEmote(snubbull, "", 0)
		GAME:WaitFrames(20)
		
		UI:SetSpeakerEmotion("Sad")
		UI:WaitShowDialogue("Well,[pause=10] whatever.[pause=0] No use getting too worked up about it...")
		GAME:WaitFrames(40)
		
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("So,[pause=10] um...[pause=0] Is this the dining room?")
		GAME:WaitFrames(20)

		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, snubbull.CurrentForm.Species, snubbull.CurrentForm.Form, snubbull.CurrentForm.Skin, snubbull.CurrentForm.Gender)
		UI:WaitShowDialogue("That's right.[pause=0] This is where we guild members have our meals.")
		UI:WaitShowDialogue("I'm the chef,[pause=10] " .. snubbull:GetDisplayName() .. ".[pause=0] I cook all the delicious meals that the guild gets to enjoy.")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(snubbull)
		UI:WaitShowDialogue("I was so worked up before that I forgot to ask your names.[pause=0] What are they,[pause=10] my future connoisseurs?")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(partner)
		UI:WaitShowDialogue("My name is " .. partner:GetDisplayName() .. ",[pause=10] and my friend here is " .. hero:GetDisplayName() .. ".")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(snubbull)
		UI:WaitShowDialogue(partner:GetDisplayName() .. "...[pause=0] " .. hero:GetDisplayName() .. "...[pause=0]. Welcome again to the guild.")
		GAME:WaitFrames(20)
		
		UI:SetSpeakerEmotion("Special0")
		UI:WaitShowDialogue("You know...[pause=0] You're both very lucky to join a guild with such a great chef~")
		UI:WaitShowDialogue("Just wait until you get a taste of some of my specialties. " .. STRINGS:Format("\\u266A"))
		UI:WaitShowDialogue("Kebia pit covered in a Babiri paste...")
		UI:WaitShowDialogue("Pickled Chartis with a Wacan sauce...")
		UI:WaitShowDialogue("I've even been working on a dish using Jaboca and Rowap berries.[pause=0] Some real high-class delicacies~")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Stunned")
		GROUND:CharTurnToChar(hero, partner)
		GROUND:CharSetEmote(partner, "sweating", 1)
		UI:WaitShowDialogue("Err...[pause=0] Yeah,[pause=10] those do sound quite...[pause=0] appetizing...")
		UI:WaitShowDialogue("(None of those sound any good...[pause=0] I don't even think I've heard of some of those berries before...)")
		GAME:WaitFrames(20)
		
		--hero knows things mechanics wise because the player does, but a player wouldn't actually know anything about how pokemon berries taste (besides basic ones maybe like pecha)
		--hero is also from a different world rather than living in the pokemon world and turning human. small distinction
	--	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	--	GAME:WaitFrames(20)
		--GROUND:CharTurnToCharAnimated(hero, snubbull, 4)
		--GAME:WaitFrames(20)
		--GROUND:CharTurnToCharAnimated(hero, partner, 4)
		--GAME:WaitFrames(20)
		--GROUND:CharTurnToCharAnimated(hero, snubbull, 4)
	--	GAME:WaitFrames(20)

		--GeneralFunctions.EmoteAndPause(hero, "Question", true)
		GeneralFunctions.HeroDialogue(hero, "(" .. partner:GetDisplayName() .. " doesn't seem too thrilled by those dishes.)", "Worried")
		GeneralFunctions.HeroDialogue(hero, "(Is that " .. GeneralFunctions.GetPronoun(partner, "their") .. " personal tastes,[pause=10] or are those meals just awful?)", "Worried")
		GeneralFunctions.HeroDialogue(hero, "(I don't really know how foods taste as a Pokémon...)", "Worried")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(snubbull)
		UI:SetSpeakerEmotion("Special0")
		GROUND:CharTurnToChar(hero, snubbull)
		UI:WaitShowDialogue("It's good to see you can recognize my talent as a chef. " .. STRINGS:Format("\\u266A"))
		GAME:WaitFrames(20)
		
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("Of course,[pause=10] the meals I'd like to prepare,[pause=10] like the ones I just told you,[pause=10] require exotic ingredients...")
		--UI:WaitShowDialogue("The kind of ingredients that only a skilled adventurer would be able to procure!")		
		UI:SetSpeakerEmotion("Sad")	
		UI:WaitShowDialogue("But it's hard to find those sorts of delicacies,[pause=10] and the Guildmaster only stocks basic provisions...")
		UI:WaitShowDialogue("So I typically only get to make more plebian meals...")
		GAME:WaitFrames(20)
		
		GeneralFunctions.Hop(snubbull)
		GROUND:CharSetAnim(snubbull, "None", true)--not in cutscene mode so this needs to be set back
		UI:SetSpeakerEmotion("Special0")
		UI:WaitShowDialogue("Of course,[pause=10] I can still make excellent meals even with the basics.")
		UI:WaitShowDialogue("I can make all sorts of things with Orans,[pause=10] Leppas,[pause=10] and Apples.[pause=0] I'm just that talented. " .. STRINGS:Format("\\u266A"))
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Sigh")
		UI:WaitShowDialogue("(Oh thank goodness...[pause=0] You can't go wrong with those at least.)")
		GAME:WaitFrames(20)
		
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("Sounds like you're a great chef![pause=0] I can't wait to have some of your food tomorrow!")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(snubbull)
		UI:SetSpeakerEmotion("Special0")
		UI:WaitShowDialogue("Tomorrow's meal won't be my best work because of the ingredients...")
		UI:WaitShowDialogue("But I'm sure with my skill and talent you'll enjoy it nonetheless. " .. STRINGS:Format("\\u266A"))
		UI:WaitShowDialogue("I'm looking forward to the day you get to enjoy a truly exquisite meal using the finest ingredients. " .. STRINGS:Format("\\u266A"))
		SV.Chapter1.MetSnubbull = true
		--every guildmate is talked to, signal player that they can go sleep now
		if SV.Chapter1.MetSnubbull and SV.Chapter1.MetZigzagoon and SV.Chapter1.MetCranidosMareep and SV.Chapter1.MetBreloomGirafarig and SV.Chapter1.MetAudino then
			GAME:WaitFrames(60)
			GROUND:CharTurnToCharAnimated(partner, hero, 4)
			UI:SetSpeaker(partner)
			UI:SetSpeakerEmotion("Normal")
			UI:WaitShowDialogue("Hey " .. hero:GetDisplayName() .. "...[pause=0] It's getting pretty late...")
			GROUND:CharTurnToCharAnimated(hero, partner, 4)
			GAME:WaitFrames(12)
			UI:WaitShowDialogue("We should head back to our room and hit the hay for the night.")
			UI:WaitShowDialogue("Let's head there whenever you're ready,[pause=10] " .. hero:GetDisplayName() .. ".")
		end
	else
		GROUND:CharTurnToChar(snubbull, hero)
		GeneralFunctions.StartConversation(snubbull, "Tomorrow's meal won't be my best work because of the ingredients...", "Happy")
		UI:WaitShowDialogue("But I'm sure with my skill and talent you'll enjoy it nonetheless. " .. STRINGS:Format("\\u266A"))
		UI:WaitShowDialogue("I'm looking forward to the day you get to enjoy a truly exquisite meal using the finest ingredients. " .. STRINGS:Format("\\u266A"))
	end
	
	GeneralFunctions.EndConversation(snubbull)

end

return guild_dining_room_ch_1