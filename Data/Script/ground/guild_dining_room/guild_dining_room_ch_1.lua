
require 'common'
require 'PartnerEssentials'
require 'CharacterEssentials'
require 'GeneralFunctions'

guild_dining_room_ch_1 = {}


function guild_dining_room_ch_1.SetupGround()
	local snubbull = CharacterEssentials.MakeCharactersFromList({
		{'Snubbull', 320, 160, Direction.Down}
	})
	
	AI:SetCharacterAI(snubbull, "ai.ground_default", RogueElements.Loc(320, 160), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)

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
		
		UI:SetSpeakerEmotion("Angry")
		GeneralFunctions.Hop(snubbull)
		GROUND:CharSetEmote(snubbull, 7, 1)
		SOUND:PlayBattleSE('EVT_Emote_Complain_2')
		UI:WaitShowDialogue("Ugh![pause=0] How many times do I have tell you!?[pause=0] Stop sneaking in here for snacks after dinner!")
		GAME:WaitFrames(20)
		
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue("Hold on...[pause=0] You're not " .. CharacterEssentials.GetCharacterName("Breloom") .. "...")
		UI:WaitShowDialogue("Who are you?[pause=0] The top floor is for guild members only,[pause=10] don't you know?")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion('Normal')
		GROUND:CharTurnToChar(snubbull, partner)
		UI:WaitShowDialogue("Yes,[pause=10] we know![pause=0] But we're allowed to be up here!")
		UI:WaitShowDialogue("We only just joined the guild a little while ago.")
		UI:WaitShowDialogue("We were exploring the different rooms to say hi to everyone,[pause=10] then we walked in here.")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, snubbull.CurrentForm.Species, snubbull.CurrentForm.Form, snubbull.CurrentForm.Skin, snubbull.CurrentForm.Gender)
		UI:WaitShowDialogue("Hmm...[pause=0] Alright.[pause=0] I didn't realize we had new recruits today.")
		UI:WaitShowDialogue("Well,[pause=10] welcome to the guild.[pause=0] You'd better not be here to steal snacks either!")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(partner)
		GROUND:CharSetEmote(partner, 5, 1)
		SOUND:PlayBattleSE('EVT_Emote_Sweating')
		UI:SetSpeakerEmotion("Surprised")
		UI:WaitShowDialogue("No no![pause=0] We didn't even know there was food in here!")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, snubbull.CurrentForm.Species, snubbull.CurrentForm.Form, snubbull.CurrentForm.Skin, snubbull.CurrentForm.Gender)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("Oh.[pause=0] Sorry.[pause=0] I'm a bit on edge because " .. CharacterEssentials.GetCharacterName("Breloom") .. " keeps trying to sneak food after dinner.")
		UI:SetSpeakerEmotion("Angry")
		GROUND:CharSetEmote(snubbull, 7, 0)
		UI:WaitShowDialogue("If he's so hungry,[pause=10] he should just eat more at dinner![pause=0] I can't stand him sometimes!")
		UI:WaitShowDialogue("Does he not like my meals or something!?")
		GROUND:CharSetEmote(snubbull, -1, 0)
		GAME:WaitFrames(20)
		
		UI:SetSpeakerEmotion("Sad")
		UI:WaitShowDialogue("Well,[pause=10] whatever.[pause=0] No use getting too worked up about it...")
		GAME:WaitFrames(40)
		
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("So uh...[pause=0] What room is this anyway?")
		GAME:WaitFrames(20)

		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, snubbull.CurrentForm.Species, snubbull.CurrentForm.Form, snubbull.CurrentForm.Skin, snubbull.CurrentForm.Gender)
		UI:WaitShowDialogue("This is the dining room.[pause=0] This is where we guild members have our meals.")
		UI:WaitShowDialogue("I'm Chef " .. snubbull:GetDisplayName() .. ".[pause=0] I cook all the delicious meals that the guild gets to enjoy.")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(snubbull)
		UI:WaitShowDialogue("I was so worked up before that I forgot to ask your names.[pause=0] What are they,[pause=10] my future connoisseurs?")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(partner)
		UI:WaitShowDialogue("My name is " .. partner:GetDisplayName() .. ",[pause=10] and my friend here is " .. hero:GetDisplayName() .. ".[pause=0] We're Team " .. GAME:GetTeamName() .. "!")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(snubbull)
		UI:WaitShowDialogue(partner:GetDisplayName() .. "...[pause=0] " .. hero:GetDisplayName() .. "...[pause=0]. It's good to have you in the guild.")
		GAME:WaitFrames(20)
		
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("You know...[pause=0] You're both very lucky to join a guild with such a great chef~")
		UI:WaitShowDialogue("Just wait until you get a taste of some of my specialties. " .. STRINGS:Format("\\u266A"))
		UI:WaitShowDialogue("Kebia pit covered in a Babiri paste...")
		UI:WaitShowDialogue("Pickled Chartis with a Wacan sauce...")
		UI:WaitShowDialogue("I've even been working on a dish using Jaboca and Rowap berries.[pause=0] Some real high-class delicacies~")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Stunned")
		GROUND:CharTurnToChar(hero, partner)
		GROUND:CharSetEmote(partner, 5, 1)
		UI:WaitShowDialogue("Err...[pause=0] Yeah,[pause=10] that sure does sound quite...[pause=0] appetizing...")
		UI:WaitShowDialogue("(None of those sound any good...[pause=0] Does she have any taste buds?)")
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
		GeneralFunctions.HeroDialogue(hero, "(Is that " .. GeneralFunctions.GetPronoun(hero, "their") .. " personal tastes,[pause=10] or are those meals just awful?)", "Worried")
		GeneralFunctions.HeroDialogue(hero, "(I don't really have any idea how the different foods in this world taste...", "Worried")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(snubbull)
		UI:SetSpeakerEmotion("Happy")
		GROUND:CharTurnToChar(hero, snubbull)
		UI:WaitShowDialogue("It's good to see you can recognize my talent as a chef. " .. STRINGS:Format("\\u266A"))
		GAME:WaitFrames(20)
		
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("Of course,[pause=10] the meals I'd like to prepare,[pause=10] like the ones I just told you,[pause=10] require exotic ingredients...")
		UI:SetSpeakerEmotion("Sad")	
		UI:WaitShowDialogue("The Guildmaster usually buys more basic provisions...[pause=0] So I typically only get to make more plebian meals...")
		GAME:WaitFrames(20)
		
		GeneralFunctions.Hop(snubbull)
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("Of course,[pause=10] I can still make excellent meals even with the basics.")
		UI:WaitShowDialogue("I can make all sorts of things with Orans,[pause=10] Leppas,[pause=10] and Apples.[pause=0] I'm just that good. " .. STRINGS:Format("\\u266A"))
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Sigh")
		UI:WaitShowDialogue("(Oh thank goodness...[pause=0] You can't go wrong with those at least.)")
		GAME:WaitFrames(20)
		
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("Sounds like you're a great chef![pause=0] Can't wait to have some of your food tomorrow!")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(snubbull)
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("Tomorrow's meal won't be my best work because of the ingredients...")
		UI:WaitShowDialogue("But I'm sure with my skill you'll enjoy it nonetheless. " .. STRINGS:Format("\\u266A"))
		UI:WaitShowDialogue("One day though you'll get to enjoy a truly exquisite meal using the finest ingredients.")
		UI:WaitShowDialogue("I'm looking forward to then. " .. STRINGS:Format("\\u266A"))
		SV.Chapter1.MetSnubbull = true
	else
		GROUND:CharTurnToChar(snubbull, hero)
		UI:SetSpeaker(snubbull)
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("Tomorrow's meal won't be my best work because of the ingredients...")
		UI:WaitShowDialogue("But I'm sure with my skill you'll enjoy it nonetheless. " .. STRINGS:Format("\\u266A"))
		UI:WaitShowDialogue("One day though you'll get to enjoy a truly exquisite meal using the finest ingredients.")
		UI:WaitShowDialogue("I'm looking forward to then. " .. STRINGS:Format("\\u266A"))
	end
	

end

return guild_dining_room_ch_1