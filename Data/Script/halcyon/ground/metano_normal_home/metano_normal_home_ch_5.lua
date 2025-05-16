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
	GeneralFunctions.PanCamera(nil, nil, false, nil, 184, 112)
	GAME:WaitFrames(20)
	
	SOUND:PlayBGM("Sympathy.ogg", true)


--[[	
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
	Just stay safe, okay? We don't want to see you hurt. Keep your wits about you, OK?
	
	Furret: And don't push yourself too hard. Make sure you get plenty of rest!
	I know this expedition is very important and a lot of work, but you have to take care of yourself, you know?
	
	zigzagoon: Mom... Dad...
	(nods)
	Yeah! You're all right!
	
	
	]]--
	
	
	SV.Chapter5.SawZigzagoonFamilyCutscene = true
	
end

--Have fun! Make sure to get plenty of rest!
function metano_normal_home_ch_5.Furret_Action(chara, activator)

	GeneralFunctions.EndConversation(chara)
end

--woah an expedition is so cool! Adventurers are so cool! I want to be like my big brother one day!
function metano_normal_home_ch_5.Sentret_Action(chara, activator)

	GeneralFunctions.EndConversation(chara)
end

function metano_normal_home_ch_5.Linoone_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "You two are adventurers with the guild,[pause=10] aren't you?[pause=0] My son,[pause=10] " .. CharacterEssentials.GetCharacterName("Zigzagoon") .. ",[pause=10] has talked about you before.")
	UI:WaitShowDialogue("Please keep an eye out for him.[pause=0] He's careful and very knowledgable on the mystery dungeons you're sure to encounter on this expedition,[pause=10] but...")
	UI:WaitShowDialogue("As his mother,[pause=10] I can't help but worry for his safety.[pause=0] Make sure he stays safe,[pause=10] would you please?")
	GeneralFunctions.EndConversation(chara)
end 