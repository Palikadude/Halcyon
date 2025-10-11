require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_normal_home_ch_5 = {}

function metano_normal_home_ch_5.SetupGround()
	local furret, linoone, sentret = 
		CharacterEssentials.MakeCharactersFromList({
			{'Furret', 104, 152, Direction.Right},
			{'Linoone', 104, 152, Direction.Right},
			{'Sentret', 104, 152, Direction.Right}
		})
			
end

--his family sees him off. Wishes him luck, tells him to stay safe, find something cool, etc.
function metano_normal_home_ch_5.Farewell_Cutscene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	
	local furret = CH('Furret')
	local linoone = CH('Linoone')
	local sentret = CH('Sentret')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	
	local zigzagoon = CharacterEssentials.MakeCharactersFromList({
			{'Zigzagoon', 172, 120, Direction.Up}
		})
	
	GROUND:TeleportTo(linoone, 172, 88, Direction.Down)
	GROUND:TeleportTo(furret, 148, 104, Direction.DownRight)
	GROUND:TeleportTo(sentret, 196, 104, Direction.DownLeft)
	
	GeneralFunctions.CenterCamera({hero, partner})
	
	GAME:FadeIn(20)
	
	GAME:WaitFrames(10)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("Oh,[pause=10] " .. hero:GetDisplayName() .. ",[pause=10] look!")
	GAME:WaitFrames(20)	
	
	SOUND:FadeOutBGM(60)
	GeneralFunctions.PanCamera(nil, nil, false, 1.5, 184, 112)
	GAME:WaitFrames(20)
	
	SOUND:PlayBGM("Sympathy.ogg", true)
	UI:SetSpeaker(linoone)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("...[pause=30]You're leaving on the expedition today?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(zigzagoon)
	UI:WaitShowDialogue("Yup.[pause=0] The Guildmaster announced we'd be departing later today.")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(furret)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("It's kinda sudden though,[pause=10] isn't it?[pause=0] You said the guild was going on an expedition,[pause=10] but we thought there'd be more warning!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(zigzagoon)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Yeah.[pause=0] The Guildmaster wants us to leave now that " .. CharacterEssentials.GetCharacterName("Breloom") .. " and " .. CharacterEssentials.GetCharacterName("Girafarig") .. " are back.")
	UI:WaitShowDialogue("I thought he'd give them a day or two to rest,[pause=10] but it seems he's eager to get going.")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(linoone)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("It's unfortunate you have to leave on such little notice,[pause=10] but...[pause=30] we understand.[pause=0] I'm sure your Guildmaster knows best.")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(furret)
	UI:SetSpeakerEmotion("Happy")
	GROUND:CharSetEmote(furret, "happy", 0)
	UI:WaitShowDialogue("Sounds more to me like he's just as excited as you are for this expedition,[pause=10] hehe!")
	GAME:WaitFrames(20)
	
	GROUND:CharSetEmote(furret, "", 0)
	UI:SetSpeaker(zigzagoon)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Hehe,[pause=10] maybe.[pause=0] It is all very exciting, after all!")
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("But...[pause=0] I'm feeling nervous too.[pause=0] This is my first expedition...[pause=30] it's daunting.")
	UI:WaitShowDialogue("I've studied and trained and prepared...[pause=0] But I'm still worried I might not pull my own weight.")
	UI:WaitShowDialogue("I don't want to let " .. CharacterEssentials.GetCharacterName("Growlithe") .. ",[pause=10] the Guildmaster,[pause=10] or anyone else down!")
	GAME:WaitFrames(20)
	
	GeneralFunctions.DoubleHop(sentret, nil, nil, nil, nil, true)
	UI:SetSpeaker(sentret)
	UI:WaitShowDialogue("No way![pause=0] You're an adventurer,[pause=10] and adventures are awesome!")
	UI:WaitShowDialogue("You're gonna do great, " .. zigzagoon:GetDisplayName() .. "![pause=0] And you'll find something really cool,[pause=10] or lots of treasure!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(zigzagoon)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(sentret:GetDisplayName() .. "...")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(linoone)
	UI:WaitShowDialogue("Your brother's right,[pause=10] " .. zigzagoon:GetDisplayName() .. ".")
	UI:WaitShowDialogue("I'm worried about all the trouble and dangers you'll face on your expedition...")
	UI:WaitShowDialogue("But you're a smart and capable Pokémon.[pause=0] I know you'll do great.")
	UI:WaitShowDialogue("Just stay safe,[pause=10] okay?[pause=0] We don't want to see you get hurt.[pause=0] Keep your wits about you!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(furret)
	UI:WaitShowDialogue("And don't push yourself too hard.[pause=0] Make sure you get plenty of rest!")
	UI:WaitShowDialogue("I know this expedition is very important and lots of work,[pause=10] but you have to take care of yourself too,[pause=10] you know?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(zigzagoon)
	UI:SetSpeakerEmotion("Teary-Eyed")
	UI:WaitShowDialogue("Mom...[pause=0] Dad...")
	GAME:WaitFrames(10)
	
	GeneralFunctions.Hop(zigzagoon)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("Yeah![pause=0] You're right![pause=0] I can do this!")
	UI:WaitShowDialogue("I'm gonna try my absolute hardest![pause=0] I'll learn and do everything I can!")
	UI:WaitShowDialogue("I'll make you and everyone else proud of me!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(linoone)
	UI:WaitShowDialogue("I know you will.[pause=0] And when you come back home...")
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("...[pause=30]Be sure to share with me all your writings.[pause=0] I'd love to read about your adventure!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(sentret)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("I'd love it if you brought home a really cool treasure![pause=0] Something shiny and awesome!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(furret)
	UI:WaitShowDialogue("Hey, you know what I'd love?")
	GAME:WaitFrames(20)
	
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("...A great big hug!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(zigzagoon)
	UI:SetSpeakerEmotion("Teary-Eyed")
	UI:WaitShowDialogue("Dad...")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(linoone)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("You know, I think I'd love one of those as well.")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(sentret)
	UI:WaitShowDialogue("Hey![pause=0] I want a hug too!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(zigzagoon)
	UI:SetSpeakerEmotion("Teary-Eyed")
	UI:WaitShowDialogue("Mom...[pause=0] " .. sentret:GetDisplayName() .. "...")
	GAME:WaitFrames(20)

	
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("...Well,[pause=10] I'd better get going.[pause=0] I still need to prepare with " .. CharacterEssentials.GetCharacterName("Growlithe") .. " for the long journey ahead.")
	GAME:WaitFrames(20)
	
	UI:WaitShowDialogue("Goodbye everyone.[pause=0] I'll...")
	GAME:WaitFrames(30)
	
	GeneralFunctions.DoubleHop(zigzagoon)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("I'll do my best!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(sentret)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Bye,[pause=10] " .. zigzagoon:GetDisplayName() .. "![pause=0] Hope you find lots of cool stuff!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(furret)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Good luck![pause=0] Make sure you take plenty of breaks!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(linoone)
	UI:WaitShowDialogue(zigzagoon:GetDisplayName() .. ".[pause=0] I know you'll do wonderfully on this expedition.")
	UI:WaitShowDialogue("But as your mother, I can't help but worry.[pause=0] So,[pause=10] please,[pause=10] just ensure you come back home safe.")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(zigzagoon)
	UI:WaitShowDialogue("I will,[pause=10] don't you worry![pause=0] I'll see you all again soon!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(zigzagoon)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("O-oh![pause=0] " .. hero:GetDisplayName() .. ",[pause=10] " .. partner:GetDisplayName() .. "![pause=0] H-how long have you been standing there?")
	GAME:WaitFrames(20)
	
	GROUND:CharSetEmote(partner, "sweating", 1)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("U-um, a little while, sorry.[pause=0] We didn't mean to intrude on you like this...")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(zigzagoon)
	UI:WaitShowDialogue("No,[pause=10] it's okay.[pause=0] It IS a little embarrasing,[pause=10] but...")
	UI:WaitShowDialogue("I care about my family a lot,[pause=10] so it doesn't bother me if other people know that.")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Aww,[pause=10] that's sweet,[pause=10] " .. zigzagoon:GetDisplayName() .. ".[pause=0] I can see that your family cares deeply about you too!")
	GAME:WaitFrames(20)
	
	--todo: blush for almotz if the portrait ever comes up
	UI:SetSpeaker(zigzagoon)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Eheheheh...")
	GAME:WaitFrames(30)
	
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Well,[pause=10] I'd better go prepare for the expedition.")
	UI:SetSpeakerEmotion("Sigh")
	UI:WaitShowDialogue("I know " .. CharacterEssentials.GetCharacterName("Growlithe") .. " probably hasn't gotten much done without me...")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(hero:GetDisplayName() .. " and I should go get ready too.[pause=0] Let's make this expedition a success,[pause=10] " .. zigzagoon:GetDisplayName() .. "!")
	GAME:WaitFrames(20)
	
	GeneralFunctions.Hop(zigzagoon)
	UI:SetSpeaker(zigzagoon)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("Yeah![pause=0] Let's all do our best!")
	
	GAME:WaitFrames(20)
	
	--sync this up better...
	local coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
												  GAME:WaitFrames(30)
												  GROUND:CharSetAction(partner, RogueEssence.Ground.PoseGroundAction(partner.Position, partner.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose"))) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
												  GAME:WaitFrames(20)
												  GROUND:CharSetAction(hero, RogueEssence.Ground.PoseGroundAction(hero.Position, hero.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose"))) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
												  GROUND:CharAnimateTurnTo(zigzagoon, Direction.Down, 4)
												  GAME:WaitFrames(24)
												  GROUND:CharSetAction(zigzagoon, RogueEssence.Ground.PoseGroundAction(zigzagoon.Position, zigzagoon.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose"))) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	GAME:WaitFrames(120)
	
	GROUND:CharEndAnim(hero)
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(zigzagoon)
	GAME:WaitFrames(40)

	--they leave, end cutscene.
	
	
	
--[[	
	
	second draft 
	Linoone: ...You're leaving on the expedition today?
	
	zigzagoon: Yup. The Guildmaster announced we'd be departing later today.
	
	Furret: It's kinda sudden though, isn't it? You said the guild was going on an expedition, but we thought there'd be more warning!
	
	zigzagoon: Yeah. The Guildmaster wants us to leave now that Kino and Reinier are back.
	I thought he'd give them a day or two to rest, but it seems he's eager to get going.
	
	Linoone: It's unfortunate you have to leave on such little notice, but... we understand. I'm sure your Guildmaster knows best.
	
	Furret: Sounds more to me like he's just as excited as you are for this expedition, hehe!
	
	zigzagoon: Hehe, maybe. It is all very exciting, but...
	I'm feeling nervous too. This is my first expedition... It's daunting.
	I've studied and trained and prepared but, I'm still worried I might not pull my weight...
	I don't want to let Hyko, the Guildmaster, or anyone else down!

	Sentret: No way! You're an adventurer, and adventurers are awesome!
	You're gonna do a great job, Almotz! And the expedition's gonna be a big success, and you're gonna find something really cool!

	zigzagoon: Timmi...
	
	Linoone: Your brother's right, Almotz.
	I'm worried about all the trouble and dangers you'll face on your journey ahead...
	But you're a smart and capable Pokemon. I know you'll do great.
	Just stay safe, okay? We don't want to see you hurt. Keep your wits about you!
	
	Furret: And don't push yourself too hard. Make sure you get plenty of rest!
	I know this expedition is very important and a lot of work, but you have to take care of yourself too, you know?
	
	zigzagoon: Mom... Dad...
	(nods)
	Yeah! You're right! I can do this!
	I'm gonna try my absolute hardest! I'll learn and do everything that I can!
	I'll make you and everyone else proud!
		
	Linoone: I know you will. And when you come back home...
	...Be sure to share with me all your writings. I'd love to read about your adventure!
		
	Timmi: Oh, I'd love it if you brought home a really cool treasure! Something really awesome!
		
	Furret: Hey, you know what I'd love...?
	
	*hugs his son*
	
	Furret: ...A hug!
	
	zigzagoon: Dad...
	
	Linoone: You know, I'd love one too.

	Sentret: Oh, me too!
	
	(her and timmi join in)
	
	Zigzagoon: Mom... Timmi...
	
	(pause, hug eventually ends)
	
	zigzagoon: ...Well, I'd better get going. I still need to prepare with Hyko for our long journey ahead.
	
	(slowly walks away while they watch him, then he turns back towards them)
	
	zigzagoon: Goodbye, everyone. I'll... I'll do my best!
	
	Timmi: Bye, Almotz! Hope you find lots of cool stuff!
		
	Furret: Good luck! Don't push yourself too hard!
	
	Linoone: Almotz... enjoy the expedition. I know how fulfilling adventuring is for you.
	Just... come back home safe.
	
	zigzagoon: (nods (or jumps because no nod anim)) I will! See you all again soon!

	(walks away, eventually finds you and the player just eavesdropping in)
	
	zigzagoon (surprised): O-oh! Player, partner! H-how long have you been standing there?
	
	Partner (Sweating): U-um, a little while, sorry. We didn't mean to intrude on you like this...
	
	zigzagoon: No, it's okay. It is a little embarrassing, but...
	I care about my family a lot, so it doesn't bother me if other people know that.
	
	Partner: Aww, that's sweet, Almotz. I can see your family cares about you deeply too.

	zigzagoon: Heheh...
	
	(pause)
	
	Zigzagoon: Well, I'd better go prepare for the expedition.
	(sigh) I know Hyko probably hasn't gotten much work done without me...
	
	Partner: Hero and I should go get ready too. Let's make this expedition a success, Almotz!
	
	zigzagoon (nod): Yeah! Let's all do our best! 
	
	(All turn towards the camera and strike a pose - afer a short pause, Almotz leaves, and you get control back)
	
	first draft
	UI:SetSpeaker(linoone)
	SOUND:PlayBattleSE('EVT_Emote_Shock_2')
	GeneralFunctions.EmoteAndPause(linoone, "Shock", false)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("You're leaving today?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(zigzagoon)
	UI:WaitShowDialogue("Yup![pause=0] The Guildmaster announced we'd be departing later today.")
	GAME:WaitFrames(20)
		
	UI:SetSpeaker(furret)
	UI:SetSpeakerEmotion("Worried")
	GROUND:CharSetEmote(furret, "sweating", 1)
	UI:WaitShowDialogue("That's kinda sudden,[pause=10] don't you think?[pause=0] We knew your guild was planning some sort of expedition,[pause=10] but...")
	UI:WaitShowDialogue("We thought we'd have a little more warning!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(zigzagoon)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Yeah.[pause=0] The Guildmaster said we had to wait for " .. CharacterEssentials.GetCharacterName("Breloom") .. " and " .. CharacterEssentials.GetCharacterName("Girafarig") .. " to return,[pause=10] but I didn't think we'd leave the minute they did!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(linoone)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("...So we won't see you for quite a while.")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(zigzagoon)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("Yeah...[pause=0] With this being my first expedition and all,[pause=10] I don't know how long I'll be gone exactly.")
	UI:WaitShowDialogue("I came to say goodbye before I started preparing with " .. CharacterEssentials.GetCharacterName("Growlithe") .. " for the road ahead.")
	GAME:WaitFrames(20)
	
	
	
	]]--
	
	SV.Chapter5.SawZigzagoonFamilyCutscene = true
	
end

--Have fun! Make sure to get plenty of rest!
function metano_normal_home_ch_5.Furret_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Oh, you two must be friends of my son!")
	GeneralFunctions.EndConversation(chara)
end

--woah an expedition is so cool! Adventurers are so cool! I want to be like my big brother one day!
function metano_normal_home_ch_5.Sentret_Action(chara, activator)

	GeneralFunctions.EndConversation(chara)
end

function metano_normal_home_ch_5.Linoone_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "You two are adventurers with the guild,[pause=10] aren't you?[pause=0] My son,[pause=10] " .. CharacterEssentials.GetCharacterName("Zigzagoon") .. ",[pause=10] has talked about you before.")
	UI:WaitShowDialogue("Please keep an eye out for him.[pause=0] He's careful and very knowledgable on the mystery dungeons you're sure to encounter on this expedition,[pause=10] but...")
	UI:WaitShowDialogue("As his mother,[pause=10] I worry for his safety.[pause=0] Make sure he stays safe,[pause=10] would you please?")
	GeneralFunctions.EndConversation(chara)
end 