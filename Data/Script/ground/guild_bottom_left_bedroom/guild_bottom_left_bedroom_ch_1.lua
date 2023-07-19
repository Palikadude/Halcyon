require 'common'
require 'PartnerEssentials'
require 'CharacterEssentials'
require 'GeneralFunctions'

guild_bottom_left_bedroom_ch_1 = {}


function guild_bottom_left_bedroom_ch_1.SetupGround()
	local breloom, girafarig, tail = CharacterEssentials.MakeCharactersFromList({
		{'Breloom', 188, 210, Direction.Left},
		{'Girafarig', 156, 210, Direction.Right},
		{'Tail'}
	})

	GAME:FadeIn(20)

end

function guild_bottom_left_bedroom_ch_1.Girafarig_Action(chara, activator)
	if not SV.Chapter1.MetBreloomGirafarig then
		guild_bottom_left_bedroom_ch_1.Breloom_Action(chara, activator)
	else 
		local girafarig = CH('Girafarig')
		local tail = CH('Tail')
		local hero = CH('PLAYER')
		GeneralFunctions.StartConversation(chara, "We're the most senior appetizers here,[pause=10] so come to us if you need advice or help!", "Happy")
		UI:WaitShowDialogue(tail:GetDisplayName() .. " and I would be glad to tutor you anytime!")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(tail)
		UI:SetSpeakerEmotion('Special0')
		UI:WaitShowDialogue('.........')
		
		GeneralFunctions.EndConversation(chara)
		
	end
end


function guild_bottom_left_bedroom_ch_1.Breloom_Action(chara, activator)
	local breloom = CH('Breloom')
	local girafarig = CH('Girafarig')
	local tail = CH('Tail')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	
	if not SV.Chapter1.MetBreloomGirafarig then 
		GAME:FadeOut(false, 40)
		GROUND:TeleportTo(partner, 188, 178, Direction.Down)
		GROUND:TeleportTo(hero, 156, 178, Direction.Down)
		AI:DisableCharacterAI(partner)
		GAME:CutsceneMode(true)
		GAME:MoveCamera(180, 188, 1, false)
		GAME:FadeIn(40)


		GROUND:CharTurnToChar(partner, breloom)
		GROUND:CharTurnToChar(hero, breloom)
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, breloom.CurrentForm.Species, breloom.CurrentForm.Form, breloom.CurrentForm.Skin, breloom.CurrentForm.Gender)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("...Previous scouting missions only found ruins dotted around.")
		GAME:WaitFrames(20)
		
		GROUND:CharTurnToChar(partner, girafarig)
		GROUND:CharTurnToChar(hero, girafarig)
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, girafarig.CurrentForm.Species, girafarig.CurrentForm.Form, girafarig.CurrentForm.Skin, girafarig.CurrentForm.Gender)
		UI:WaitShowDialogue("How large are we talking here?")
		GAME:WaitFrames(20)
		
		GROUND:CharTurnToChar(partner, breloom)
		GROUND:CharTurnToChar(hero, breloom)		
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, breloom.CurrentForm.Species, breloom.CurrentForm.Form, breloom.CurrentForm.Skin, breloom.CurrentForm.Gender)
		UI:WaitShowDialogue("Nothing big.[pause=0] Just broken pieces of small statues,[pause=10] pillar bases,[pause=10] that sort of thing.")
		UI:WaitShowDialogue("But they were scattered all about.[pause=0] They weren't confined to a single part of the mountain range.")
		GAME:WaitFrames(20)
		
		GROUND:CharTurnToChar(partner, girafarig)
		GROUND:CharTurnToChar(hero, girafarig)
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, girafarig.CurrentForm.Species, girafarig.CurrentForm.Form, girafarig.CurrentForm.Skin, girafarig.CurrentForm.Gender)
		UI:WaitShowDialogue("That does make finding the entrance difficult...[pause=0] Maybe we can figure out if there's any pattern to the ruins?")
		GAME:WaitFrames(20)

		GROUND:CharTurnToChar(partner, breloom)
		GROUND:CharTurnToChar(hero, breloom)		
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, breloom.CurrentForm.Species, breloom.CurrentForm.Form, breloom.CurrentForm.Skin, breloom.CurrentForm.Gender)
		UI:WaitShowDialogue("I hope so.[pause=0] Or it's gonna be a real pain in the tail to find the place...")
		GAME:WaitFrames(20)
		
		GROUND:CharTurnToChar(partner, girafarig)
		GROUND:CharTurnToChar(hero, girafarig)
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, girafarig.CurrentForm.Species, girafarig.CurrentForm.Form, girafarig.CurrentForm.Skin, girafarig.CurrentForm.Gender)
		UI:WaitShowDialogue("Like you would know what a brain in the tail is.")
		UI:SetSpeakerEmotion("Sad")
		UI:WaitShowDialogue(tail:GetDisplayName() .. " has been so rude lately![pause=0] Every time I talk to him he's in a mood!")--change the reason crum is a pain in the tail? maybe something better
		UI:WaitShowDialogue("We always end up bickering because he won't be civil!")
		GAME:WaitFrames(20)
		
		--UI:SetSpeaker(tail)
		--UI:SetSpeakerEmotion('Special0')
		--UI:WaitShowDialogue(".........")
		--GAME:WaitFrames(20)

		GROUND:CharTurnToChar(partner, breloom)
		GROUND:CharTurnToChar(hero, breloom)		
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, breloom.CurrentForm.Species, breloom.CurrentForm.Form, breloom.CurrentForm.Skin, breloom.CurrentForm.Gender)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("Guess you could say that " .. tail:GetDisplayName() .. " and you have been butting heads recently.")
		GAME:WaitFrames(20)

		GROUND:CharTurnToChar(partner, girafarig)
		GROUND:CharTurnToChar(hero, girafarig)
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, girafarig.CurrentForm.Species, girafarig.CurrentForm.Form, girafarig.CurrentForm.Skin, girafarig.CurrentForm.Gender)
		UI:SetSpeakerEmotion("Sad")
		UI:WaitShowTimedDialogue("Yeah,[pause=10] he's just been so rumpy la-", 40)
		GeneralFunctions.EmoteAndPause(girafarig, "Exclaim", true)
		UI:SetSpeakerEmotion("Determined")
		UI:WaitShowDialogue("Oh,[pause=10] very funny.[pause=0] Bet you're real proud of that one.")
		GAME:WaitFrames(10)

		GROUND:CharTurnToChar(partner, breloom)
		GROUND:CharTurnToChar(hero, breloom)		
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, breloom.CurrentForm.Species, breloom.CurrentForm.Form, breloom.CurrentForm.Skin, breloom.CurrentForm.Gender)
		UI:SetSpeakerEmotion("Joyous")
		GROUND:CharSetEmote(breloom, "glowing", 0)
		SOUND:PlayBattleSE('EVT_Emote_Startled_2')
		GeneralFunctions.DoubleHop(breloom)
		UI:WaitShowDialogue("You know it!")
		GAME:WaitFrames(20)
		GROUND:CharSetEmote(breloom, "", 0)

		GROUND:CharTurnToChar(partner, breloom)
		GROUND:CharTurnToChar(hero, breloom)		
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("Anyway...[pause=0] We should be prepared for the long haul for this trek.[pause=0] We have no idea how long...")
		GAME:WaitFrames(20)
		GeneralFunctions.EmoteAndPause(breloom, "Notice", true)
		--GAME:WaitFrames(20)
		GROUND:CharTurnToCharAnimated(breloom, partner, 4)
		GAME:WaitFrames(20)
		
		UI:WaitShowDialogue("Hey,[pause=10] look,[pause=10] we have some company.")
		GROUND:CharTurnToCharAnimated(girafarig, partner, 4)
		GAME:WaitFrames(12)
		
		UI:WaitShowDialogue("I don't think I've seen you around the guild before.[pause=0] Are you guys new recruits?")
		GAME:WaitFrames(10)
		
		GROUND:CharSetEmote(hero, "exclaim", 1)
		GeneralFunctions.Recoil(partner)
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Surprised")
		UI:WaitShowDialogue("Huh?[pause=0] How'd you know?")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, breloom.CurrentForm.Species, breloom.CurrentForm.Form, breloom.CurrentForm.Skin, breloom.CurrentForm.Gender)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("Usually when a pair of Pokémon we don't know show up uninvited in our room...")
		UI:WaitShowDialogue("...It's the newest rookies looking around the place.")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Sad")
		--GROUND:CharSetEmote(hero, "sweating", 1)
		GeneralFunctions.EmoteAndPause(partner, 'Sweating', true)
		UI:WaitShowDialogue("Oh.[pause=0] Sorry,[pause=10] we didn't mean to intrude...")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, breloom.CurrentForm.Species, breloom.CurrentForm.Form, breloom.CurrentForm.Skin, breloom.CurrentForm.Gender)
		UI:SetSpeakerEmotion("Happy")
		GROUND:CharSetEmote(breloom, "glowing", 0)
		UI:WaitShowDialogue("Hehe,[pause=10] don't worry about it.[pause=0] Not like anyone else in the guild respects privacy.")
		UI:WaitShowDialogue("So don't be surprised later when I'm in your room later rummaging through your stuff.")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue(".........")
		GAME:WaitFrames(20)
		
		GROUND:CharTurnToChar(partner, girafarig)
		GROUND:CharTurnToChar(hero, girafarig)		
		GROUND:CharTurnToCharAnimated(girafarig, breloom, 4)
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, girafarig.CurrentForm.Species, girafarig.CurrentForm.Form, girafarig.CurrentForm.Skin, girafarig.CurrentForm.Gender)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("C'mon,[pause=10] don't freak out the rookies.[pause=0] They haven't found out yet that you're not funny.")
		GAME:WaitFrames(20)
		
		GROUND:CharSetEmote(breloom, "", 0)
		GROUND:CharTurnToCharAnimated(breloom, girafarig, 4)
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, breloom.CurrentForm.Species, breloom.CurrentForm.Form, breloom.CurrentForm.Skin, breloom.CurrentForm.Gender)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("Hey,[pause=10] I just haven't broken out my best material yet!")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, girafarig.CurrentForm.Species, girafarig.CurrentForm.Form, girafarig.CurrentForm.Skin, girafarig.CurrentForm.Gender)
		UI:SetSpeakerEmotion("Sigh")
		UI:WaitShowDialogue("Like all your material,[pause=10] I've heard that one before...")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, breloom.CurrentForm.Species, breloom.CurrentForm.Form, breloom.CurrentForm.Skin, breloom.CurrentForm.Gender)
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue("Aww...[pause=0] Don't be so cold...")
		GAME:WaitFrames(20)

		
		UI:SetSpeaker(STRINGS:Format("\\uE040"), true, girafarig.CurrentForm.Species, girafarig.CurrentForm.Form, girafarig.CurrentForm.Skin, girafarig.CurrentForm.Gender)
		UI:SetSpeakerEmotion("Normal")
		GROUND:CharTurnToChar(girafarig, partner)
		GROUND:CharTurnToCharAnimated(breloom, partner, 4)
		UI:WaitShowDialogue("Anyways,[pause=10] ignore " .. breloom:GetDisplayName() .. " here and his bad jokes.")
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("My name is " .. girafarig:GetDisplayName() .. ".[pause=0] It's meat to grate the two of you!")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("It's meet to gre-[pause=30] Err...[pause=0] It's great to meet you too.")
		UI:WaitShowDialogue("I'm " .. partner:GetDisplayName() .. ",[pause=10] and my partner here is " .. hero:GetDisplayName() .. ".")
		GAME:WaitFrames(20)
		
		GROUND:CharTurnToChar(partner, breloom)
		GROUND:CharTurnToChar(hero, breloom)
		UI:SetSpeaker(breloom)
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("Glad to have you both here in the guild![pause=0] Name's " .. breloom:GetDisplayName() .. ",[pause=10] by the way.")
		GAME:WaitFrames(20)

		GROUND:CharTurnToChar(partner, girafarig)
		GROUND:CharTurnToChar(hero, girafarig)
		UI:SetSpeaker(girafarig)
		UI:SetSpeakerEmotion("Surprised")
		UI:WaitShowDialogue("Woah![pause=0] I rearly forgot!")
		GAME:WaitFrames(20)
					
		GROUND:CharAnimateTurnTo(girafarig, partner.Direction, 4)
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("This is " .. tail:GetDisplayName() .. ".[pause=0] Nearly slipped my hind to introduce him.")
		GAME:WaitFrames(20)
		
		UI:WaitShowDialogue("Say hello,[pause=10] " .. tail:GetDisplayName() .. "!")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(tail)
		UI:SetSpeakerEmotion('Special0')
		UI:WaitShowDialogue(".........")
		GAME:WaitFrames(20)
		
		GROUND:CharSetEmote(partner, "sweatdrop", 1)
		GeneralFunctions.EmoteAndPause(hero, 'Sweatdrop', true)
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Stunned")
		UI:WaitShowDialogue(".........")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(breloom)
		UI:SetSpeakerEmotion("Pain")
		UI:WaitShowDialogue("(Pssst![pause=0] New guys.[pause=0] Listen to me for a sec.)")
		GAME:WaitFrames(20)
		
		GROUND:CharTurnToCharAnimated(partner, breloom, 4)
		GROUND:CharTurnToCharAnimated(hero, breloom, 4)
		UI:WaitShowDialogue("(I don't know if you can tell,[pause=10] but " .. girafarig:GetDisplayName() .. " is...[pause=0] A bit on the odd side.)")
		UI:WaitShowDialogue("(I mean,[pause=10] I love the guy,[pause=10] but...[pause=0] He's definitely a little...[pause=10] off.)")
		UI:WaitShowDialogue("(Anyway,[pause=10] he thinks his tail is alive or something.[pause=0] He gave it a name and everything.)")
		UI:WaitShowDialogue("(I know it's weird...[pause=0] But it's best if you just play along.[pause=0] Trust me.)")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue("(Alright,[pause=10] we'll play along...[pause=0] This is pretty strange though...)")
		GAME:WaitFrames(20)
		
		GROUND:CharTurnToCharAnimated(partner, girafarig, 4)
		GROUND:CharTurnToCharAnimated(hero, girafarig, 4)
		UI:WaitShowDialogue("Um...[pause=0] It's a pleasure to meet you,[pause=10] " .. tail:GetDisplayName() .. ".")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(tail)
		UI:SetSpeakerEmotion('Special0')
		UI:WaitShowDialogue('.........')
		GAME:WaitFrames(20)
		
		GROUND:CharTurnToCharAnimated(girafarig, partner, 4)
		UI:SetSpeaker(girafarig)
		UI:SetSpeakerEmotion("Happy")
		GeneralFunctions.Hop(girafarig)
		GROUND:CharSetEmote(girafarig, "glowing", 0)
		UI:WaitShowDialogue("Wow![pause=0] I've never seen " .. tail:GetDisplayName() .. " be so nice to someone he just met!")
		UI:WaitShowDialogue("You two might be something special!")
		GAME:WaitFrames(20)
		GROUND:CharSetEmote(girafarig, "", 0)
		
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("Aw,[pause=10] thanks![pause=0] (I think...?)")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(breloom)
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("Look at you guys,[pause=10] getting all chummy with " .. tail:GetDisplayName() .. "-my![pause=0] Heheheh!")
		GAME:WaitFrames(20)
		
		GROUND:CharTurnToChar(partner, breloom)
		GROUND:CharTurnToChar(hero, breloom)
		--too long with no nicknames
		UI:WaitShowDialogue("By the way,[pause=10] if you gatecrashers ever need help with anything,[pause=10] especially exploring,[pause=10] come see me or " .. girafarig:GetDisplayName() .. "!")
		UI:WaitShowDialogue("We're the best explorers at this guild![pause=0] After the Guildmaster,[pause=10] of course.")
		GAME:WaitFrames(20)
		
		GROUND:CharTurnToChar(partner, girafarig)
		GROUND:CharTurnToChar(hero, girafarig)
		UI:SetSpeaker(girafarig)
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("Yeah![pause=0] We're the most senior appetizers here,[pause=10] so come to us if you need advice or help!")
		UI:WaitShowDialogue(tail:GetDisplayName() .. " and I would be glad to tutor you anytime!")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(tail)
		UI:SetSpeakerEmotion('Special0')
		UI:WaitShowDialogue('.........')
		GAME:WaitFrames(20)

		GeneralFunctions.PanCamera(180, 188)		
		GROUND:CharTurnToChar(girafarig, breloom)
		GROUND:CharTurnToCharAnimated(breloom, girafarig)
		GROUND:CharSetAnim(breloom, "Idle", true)
		GROUND:CharSetAnim(girafarig, "Idle",true)
		SV.Chapter1.MetBreloomGirafarig = true
		--every guildmate is talked to, signal player that they can go sleep now
		if SV.Chapter1.MetSnubbull and SV.Chapter1.MetZigzagoon and SV.Chapter1.MetCranidosMareep and SV.Chapter1.MetBreloomGirafarig and SV.Chapter1.MetAudino then
			GAME:WaitFrames(60)
			GROUND:CharTurnToCharAnimated(partner, hero, 4)
			UI:SetSpeaker(partner)
			UI:SetSpeakerEmotion("Normal")
			UI:WaitShowDialogue("Hey " .. hero:GetDisplayName() .. "...[pause=0] It's getting pretty late...")
			GROUND:CharTurnToCharAnimated(hero, partner, 4)
			GAME:WaitFrames(12)
			UI:WaitShowDialogue("We should probably head back to our room and hit the hay for the night.")
			UI:WaitShowDialogue("Let's head there whenever you're ready,[pause=10] " .. hero:GetDisplayName() .. ".")
		end
		AI:EnableCharacterAI(partner)
		AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)
		GAME:CutsceneMode(false)
	else 
		GeneralFunctions.StartConversation(chara, "By the way,[pause=10] if you gatecrashers ever need help with anything,[pause=10] especially exploring,[pause=10] come see me or " .. girafarig:GetDisplayName() .. "!", "Happy")
		UI:WaitShowDialogue("We're the best explorers at this guild![pause=0] After the Guildmaster,[pause=10] of course.")
		GeneralFunctions.EndConversation(chara)
	end
end

return guild_bottom_left_bedroom_ch_1