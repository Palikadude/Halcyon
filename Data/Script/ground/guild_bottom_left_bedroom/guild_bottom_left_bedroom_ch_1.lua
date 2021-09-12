require 'common'
require 'PartnerEssentials'
require 'CharacterEssentials'
require 'GeneralFunctions'

guild_bottom_left_bedroom_ch_1 = {}


function guild_bottom_left_bedroom_ch_1.SetupGround()
	local snubbull = CharacterEssentials.MakeCharactersFromList({
		{'Snubbull', 320, 160, Direction.Down},
		{'Breloom', 188, 210, Direction.Left},
		{'Girafarig', 156, 210, Direction.Right},
		{'Tail'}
	})
	
	GAME:FadeIn(20)


end

function guild_bottom_left_bedroom_ch_1.Girafarig_action(chara, activator)
	guild_bottom_left_bedroom_ch_1.Breloom_Action(chara, activator)
end


function guild_bottom_left_bedroom_ch_1.Breloom_Action(chara, activator)
	local breloom = CH('Breloom')
	local girafarig = CH('Girafarig')
	local tail = CH('Tail')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	
	GAME:FadeOut(false, 20)
	AI:DisableCharacterAI(partner)
	GAME:CutsceneMode(true)
	GAME:FadeIn(20)

	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, breloom.CurrentForm.Species, breloom.CurrentForm.Form, breloom.CurrentForm.Skin, breloom.CurrentForm.Gender)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("...Previous scouting missions only found relics dotted around.")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, girafarig.CurrentForm.Species, girafarig.CurrentForm.Form, girafarig.CurrentForm.Skin, girafarig.CurrentForm.Gender)
	UI:WaitShowDialogue("How large are we stalking here?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, breloom.CurrentForm.Species, breloom.CurrentForm.Form, breloom.CurrentForm.Skin, breloom.CurrentForm.Gender)
	UI:WaitShowDialogue("Nothing big.[pause=0] Just broken pieces of small statues,[pause=10] pillar bases,[pause=10] that sort of thing.")
	UI:WaitShowDialogue("But they were scattered all about,[pause=10] they weren't confined to a single part of the mountain range.")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, girafarig.CurrentForm.Species, girafarig.CurrentForm.Form, girafarig.CurrentForm.Skin, girafarig.CurrentForm.Gender)
	UI:WaitShowDialogue("That does make finding the place harder...[pause=0] Maybe we can figure out if there's any splattern to the ruins?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, breloom.CurrentForm.Species, breloom.CurrentForm.Form, breloom.CurrentForm.Skin, breloom.CurrentForm.Gender)
	UI:WaitShowDialogue("I hope so.[pause=0] Or it's gonna be a real pain in the tail to find the entrance...")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, girafarig.CurrentForm.Species, girafarig.CurrentForm.Form, girafarig.CurrentForm.Skin, girafarig.CurrentForm.Gender)
	UI:WaitShowDialogue("Like you would know what a pain in the tail is.")
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue(tail:GetDisplayName() .. " won't stop making fun of me no matter how many times I axe him not to!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(tail)
	UI:SetSpeakerEmotion('Special0')
	UI:WaitShowDialogue(".........")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, breloom.CurrentForm.Species, breloom.CurrentForm.Form, breloom.CurrentForm.Skin, breloom.CurrentForm.Gender)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("You and " .. tail:GetDisplayName() .. " sure are butting heads a lot recently.")
	GAME:WaitFrames(20)

	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, girafarig.CurrentForm.Species, girafarig.CurrentForm.Form, girafarig.CurrentForm.Skin, girafarig.CurrentForm.Gender)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowTimedDialogue("Yeah,[pause=10] he's been very grumpy la-", 40)
	GeneralFunctions.EmoteAndPause(girafarig, "Exclaim", true)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("Oh,[pause=10] very funny.[pause=0] Bet you're real plowed of that one.")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, breloom.CurrentForm.Species, breloom.CurrentForm.Form, breloom.CurrentForm.Skin, breloom.CurrentForm.Gender)
	UI:SetSpeakerEmotion("Joyous")
	GROUND:CharSetEmote(breloom, 4, 0)
	SOUND:PlayBattleSE('EVT_Emote_Startled_2')
	GeneralFunctions.Hop(breloom)
	GeneralFunctions.Hop(breloom)
	UI:WaitShowDialogue("You know it!")
	GAME:WaitFrames(40)
	GROUND:CharSetEmote(breloom, -1, 0)
	
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Anyway...[pause=0] We should be prepared for the long haul for this trip.[pause=0] We have no idea how long...")
	GeneralFunctions.EmoteAndPause(breloom, "Notice", true)
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(breloom, partner, 4)
	GAME:WaitFrames(20)
	
	UI:WaitShowDialogue("Oh,[pause=10] I didn't realize we had company.")
	GROUND:CharTurnToCharAnimated(girafarig, partner, 4)
	GAME:WaitFrames(12)
	
	UI:WaitShowDialogue("I don't think I've seen you around the guild before.[pause=0] Are you guys new recruits?")
	GAME:WaitFrames(20)
	
	GROUND:CharSetEmote(hero, 3, 1)
	GeneralFunctions.Recoil(partner)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Huh?[pause=0] How'd you know!?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, breloom.CurrentForm.Species, breloom.CurrentForm.Form, breloom.CurrentForm.Skin, breloom.CurrentForm.Gender)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Usually when a pair of Pokémon we don't know show up in our room,[pause=10] it's the new rookies looking around the place.")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Sad")
	GROUND:CharSetEmote(partner, 5, 1)
	GeneralFunctions.EmoteAndPause(hero, 'Sweating', true)
	UI:WaitShowDialogue("Oh.[pause=0] Sorry,[pause=10] we didn't mean to barge into your bedroom...")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, breloom.CurrentForm.Species, breloom.CurrentForm.Form, breloom.CurrentForm.Skin, breloom.CurrentForm.Gender)
	UI:SetSpeakerEmotion("Happy")
	GROUND:CharSetEmote(breloom, 4, 0)
	UI:WaitShowDialogue("Hehe,[pause=10] don't worry about it.[pause=0] Not like anyone else in the guild respects privacy.")
	UI:WaitShowDialogue("So don't be surprised when you see me in your room later rummaging through your stuff.")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(".........")
	GAME:WaitFrames(20)
	
	GROUND:CharTurnToCharAnimated(girafarig, breloom, 4)
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, girafarig.CurrentForm.Species, girafarig.CurrentForm.Form, girafarig.CurrentForm.Skin, girafarig.CurrentForm.Gender)
	UI:SetSpeakerEmotion("Sigh")
	UI:WaitShowDialogue("C'mon,[pause=10] don't freak out the cookies.[pause=0] They don't know you're not funny yet.")
	GAME:WaitFrames(20)
	
	GROUND:CharSetEmote(breloom, -1, 0)
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, breloom.CurrentForm.Species, breloom.CurrentForm.Form, breloom.CurrentForm.Skin, breloom.CurrentForm.Gender)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("That's just 'cause I haven't broken out my best material yet!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, girafarig.CurrentForm.Species, girafarig.CurrentForm.Form, girafarig.CurrentForm.Skin, girafarig.CurrentForm.Gender)
	UI:SetSpeakerEmotion("Sigh")
	UI:WaitShowDialogue("Like all your cereal,[pause=10] I've heard that one before...")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, breloom.CurrentForm.Species, breloom.CurrentForm.Form, breloom.CurrentForm.Skin, breloom.CurrentForm.Gender)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Aww...[pause=0] Don't be so cold.")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, girafarig.CurrentForm.Species, girafarig.CurrentForm.Form, girafarig.CurrentForm.Skin, girafarig.CurrentForm.Gender)
	UI:SetSpeakerEmotion("Normal")
	GROUND:CharTurnToCharAnimated(girafarig, partner, 4)
	UI:WaitShowDialogue("Anyways,[pause=10] ignore " .. breloom:GetDisplayName() .. " here and his bad chokes.")
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("My name is " .. girafarig:GetDisplayName() .. ".[pause=0] It's meat to grate the two of you!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("It's meet to gre-[pause=30] Err...[pause=0] It's great to meet you too.")
	UI:WaitShowDialogue("I'm " .. partner:GetDisplayName() .. " and my friend here is " .. hero:GetDisplayName() .. ".")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(breloom)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Glad to have you both here in the guild![pause=0] Name's " .. breloom:GetDisplayName() .. " by the way.")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(girafarig)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Woah![pause=0] I almost forgot!")
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
	
	GROUND:CharSetEmote(partner, 9, 1)
	GeneralFunctions.EmoteAndPause(hero, 'Sweatdrop', true)
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Stunned")
	UI:WaitShowDialogue(".........")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(breloom)
	UI:SetSpeakerEmotion("Pain")
	UI:WaitShowDialogue("(Pssst.[pause=0] You guys.[pause=0] Listen to me for a sec.)")
	GAME:WaitFrames(20)
	
	GROUND:CharTurnToCharAnimated(partner, breloom, 4)
	GROUND:CharTurnToCharAnimated(hero, breloom, 4)
	UI:WaitShowDialogue("(I don't know if you can tell,[pause=10] but " .. girafarig:GetDisplayName() .. " isn't quite all there.")
	UI:WaitShowDialogue("(I mean I love the guy but,[pause=10] he's definitely a little kookie.)")
	UI:WaitShowDialogue("(He thinks his tail is alive.[pause=0] It's honestly easiest if you just play along with it.)")
	UI:WaitShowDialogue("(I know it's weird...[pause=0] But trust me on this.)")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	GROUND:CharTurnToCharAnimated(partner, girafarig, 4)
	GROUND:CharTurnToCharAnimated(hero, girafarig, 4)
	UI:WaitShowDialogue("Pleasure to meet you,[pause=10] " .. tail:GetDisplayName() .. ".")
	GAME:WaitFrames(20)
	
	GROUND:CharTurnToCharAnimated(girafarig, partner, 4)
	UI:SetSpeaker(girafarig)
	UI:SetSpeakerEmotion("Happy")
	GeneralFunctions.Hop(girafarig)
	GROUND:CharSetEmote(girafarig, 4, 0)
	UI:WaitShowDialogue("Wow![pause=0] I've never seen " .. tail:GetDisplayName() .. " be so nice to someone he just pet!")
	UI:WaitShowDialogue("You two might be something special!")
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(girafarig, -1, 0)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Thank you![pause=0] (I think...?)")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(breloom)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Anyway,[pause=10] if you ever need help with anything,[pause=10] especially with exploring,[pause=10] let me or " .. girafarig:GetDisplayName() .. " know.")
	UI:WaitShowDialogue("We're the best explorers at this guild![pause=0] After the Guildmaster,[pause=10] of course.")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(girafarig)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Yeah![pause=0] We're the most senior apprentices here,[pause=10] so hum to us if you need yelp!")
	UI:WaitShowDialogue(tail:GetDisplayName() .. " and I would be glad to tutor you anytime!")
	
	GAME:CutsceneMode(false)
end

return guild_bottom_left_bedroom_ch_1