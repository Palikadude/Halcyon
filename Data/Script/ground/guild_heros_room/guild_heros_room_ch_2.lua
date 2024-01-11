require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'
require 'ground.guild_heros_room.guild_heros_room_helper'

guild_heros_room_ch_2 = {}




function guild_heros_room_ch_2.FirstMorning()
	GAME:FadeOut(false, 1)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	SOUND:StopBGM()
	GROUND:CharSetAnim(hero, 'EventSleep', true)
	GROUND:CharSetAnim(partner, 'EventSleep', true)
	GROUND:Hide('Bedroom_Exit')--disable map transition object
	GROUND:Hide("Save_Point")--disable bed saving
	local hero_bed = MRKR('Hero_Bed')
	local partner_bed = MRKR('Partner_Bed')
	GROUND:TeleportTo(CH('PLAYER'), hero_bed.Position.X, hero_bed.Position.Y, Direction.Left)
	GROUND:TeleportTo(CH('Teammate1'), partner_bed.Position.X, partner_bed.Position.Y, Direction.Right)
	GeneralFunctions.CenterCamera({hero, partner})
	SV.TemporaryFlags.JustWokeUp = true

	local audino =
		CharacterEssentials.MakeCharactersFromList({
			{"Audino", 120, 204, Direction.UpRight},
		})

	GAME:WaitFrames(80)
	local coro1 = TASK:BranchCoroutine(function() UI:WaitShowTitle("Chapter 2\n\nThe First Mission\n", 20)
												  GAME:WaitFrames(180)
												  UI:WaitHideTitle(20) end)
	local coro2 = TASK:BranchCoroutine(function() UI:WaitShowBG("Chapter_2", 180, 20)
												  GAME:WaitFrames(180)
												  UI:WaitHideBG(20) end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(120)

	UI:SetAutoFinish(true)
	UI:WaitShowVoiceOver("The next morning...\n\n", -1)
	UI:SetAutoFinish(false)
	
	GAME:WaitFrames(60)
	SOUND:PlayBattleSE("DUN_Heal_Bell")
	GAME:WaitFrames(90)
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	UI:WaitShowDialogue("Good morning![pause=0] It's time to get up!")
	GAME:FadeIn(40)
	
	--sleepyheads
	GAME:WaitFrames(20)
	UI:SetSpeaker('', true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	UI:WaitShowDialogue(".........")
	GAME:WaitFrames(40)
	
	UI:SetSpeaker(audino)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Wake up sleepyheads![pause=0] It's a bright new day!")
	GAME:WaitFrames(20)
	
	GROUND:CharAnimateTurnTo(audino, Direction.Down, 4)
	GAME:WaitFrames(10)
	SOUND:PlayBattleSE("DUN_Heal_Bell")
	GROUND:CharSetAction(audino, RogueEssence.Ground.PoseGroundAction(audino.Position, audino.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GAME:WaitFrames(100)
	GROUND:CharSetAnim(audino, 'None', true)
	GROUND:CharAnimateTurnTo(audino, Direction.UpRight, 4)
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner:GetDisplayName(), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	UI:WaitShowDialogue("Snorfle...[pause=0] Huh?")
	GAME:WaitFrames(20)
	GROUND:CharSetAnim(hero, "Laying", true)
	GROUND:CharSetAnim(partner, "Laying", true)
		
	coro1 = TASK:BranchCoroutine(function () GAME:WaitFrames(10)
											 GeneralFunctions.Shake(hero)
											 GAME:WaitFrames(20)
											 GeneralFunctions.DoAnimation(hero, 'Wake') 
											 GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) 
											 GAME:WaitFrames(20)
											 GeneralFunctions.LookAround(hero, 2, 4, false, false, false, Direction.DownLeft) end)
	coro2 = TASK:BranchCoroutine(function () GeneralFunctions.Shake(partner)
											 GAME:WaitFrames(20)
											 GeneralFunctions.DoAnimation(partner, 'Wake') 
											 GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
											 GAME:WaitFrames(20)
											 GeneralFunctions.LookAround(partner, 2, 4, false, false, false, Direction.DownLeft) end)
	TASK:JoinCoroutines({coro1, coro2})

	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(partner, "Notice", true)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("Oh,[pause=10] good morning,[pause=10] " .. audino:GetDisplayName() .."!")
	GAME:WaitFrames(20)
	
	SOUND:PlayBGM("Wigglytuff's Guild.ogg", true)
	UI:SetSpeaker(audino)
	UI:SetSpeakerEmotion("Happy")
	local move = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Skill]:Get("heal_bell")--healbell

	UI:WaitShowDialogue("Good morning![pause=0] Nothing like a " .. move:GetColoredName() .. " to w-wake you up,[pause=10] huh?")
	
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("It's time for the m-morning meeting![pause=0] Don't be late,[pause=10] especially on your first day!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.EmoteAndPause(partner, "Question", true)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Huh?[pause=0] Morning meeting?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(audino)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Yup![pause=0] The guild gathers for a briefing every morning!")
	UI:WaitShowDialogue("J-just come over to the lobby area and you'll see!")
	
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(audino, Direction.Left, 4)
	GAME:WaitFrames(40)
	GROUND:CharAnimateTurnTo(audino, Direction.UpRight, 4)
	
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Looks like the meeting is about to start![pause=0] D-don't dawdle too long!")
	GAME:WaitFrames(20)
	
	GROUND:CharAnimateTurnTo(audino, Direction.Left, 4)
	GROUND:MoveToPosition(audino, 0, 204, false, 2)
	GAME:GetCurrentGround():RemoveTempChar(audino)
	GAME:WaitFrames(20)
	
	--good morning, hero!
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GAME:WaitFrames(12)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Good morning,[pause=10] " .. hero:GetDisplayName() .. "![pause=0] Hope you slept well!")	
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("We'd better get over to the lobby before we miss the meeting![pause=0] C'mon!")
	
	GAME:WaitFrames(20)
	GeneralFunctions.PanCamera(208, 156)
	GAME:WaitFrames(20)
	GROUND:CharEndAnim(hero)
	GROUND:CharEndAnim(partner)
	GROUND:Unhide("Bedroom_Exit")
	GROUND:Unhide("Save_Point")
	SV.Chapter1.TeamJoinedGuild = true
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)

	GAME:CutsceneMode(false)
		

end

function guild_heros_room_ch_2.PostRiverBedtalk() 
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GAME:CutsceneMode(true)
	guild_heros_room_helper.Bedtime(false)
	UI:ResetSpeaker()
	GAME:FadeIn(40)
	
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("relic_forest")

	SOUND:PlayBGM('Goodnight.ogg', true)
	GAME:WaitFrames(40)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(hero:GetDisplayName() .. ",[pause=10] wasn't today great?[pause=0] I'm so happy with how the day turned out!")
	UI:WaitShowDialogue("Our first job as an adventuring team was a total success!")
	UI:WaitShowDialogue(CharacterEssentials.GetCharacterName("Camerupt") .. " looked so relieved to have her son returned to her.")
	UI:WaitShowDialogue("The reward she gave us was nice...[pause=0] But I'm just happy we were able to help them out.")
	GAME:WaitFrames(20)
	
	GeneralFunctions.HeroDialogue(hero, "(I'm glad we were able to help them too.[pause=0] I feel like some kind of hero!)", "Happy")
	GeneralFunctions.HeroDialogue(hero, "(Helping Pokémon in need is really fulfilling.[pause=0] I hope " .. partner:GetDisplayName() .. " and I can keep doing it.)", "Happy")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("What happened at the spring was pretty weird,[pause=10] though.[pause=0] I wonder why it wasn't working?")
	UI:WaitShowDialogue(CharacterEssentials.GetCharacterName("Noctowl") .. " said not to worry about it though,[pause=10] so I guess it's not a big deal.")
	GAME:WaitFrames(20)
	
	GeneralFunctions.HeroDialogue(hero, "(He did say not to worry,[pause=10] but I can't stop thinking about that strange feeling I had at the spring.)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(It was sickening,[pause=10] but so similar to how I felt in " .. zone:GetColoredName() .. "...[pause=0] Could those two places be connected?)", "Worried")
	GAME:WaitFrames(40)
	
	GeneralFunctions.HeroSpeak(hero, 60)
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Huh?[pause=0] Do I know if Luminous Spring is related at all to " .. zone:GetColoredName() .. "?")
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("Um...[pause=0] I wouldn't know,[pause=10] why do you ask?")
	
	GAME:WaitFrames(20)
	GeneralFunctions.HeroSpeak(hero, 60)
	
	GAME:WaitFrames(20)
	GeneralFunctions.Recoil(partner)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("The light of the spring made you feel like you did when you touched the tablet in " .. zone:GetColoredName() .. "?")
	UI:WaitShowDialogue("But this time you also felt sick?")
	
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(partner, "Sweating", true)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("That does seem like something significant...[pause=0] Maybe the two places are connected somehow.")
	UI:WaitShowDialogue("But a vague feeling isn't a lot to go off of right now though.")
	UI:WaitShowDialogue("We aren't even sure what that feeling meant back in " .. zone:GetColoredName() .. "!")

	--note: there is signficance in the feelings, as both the tablet and the spring are connected to the tree of life, to which the hero has significance as they were "summoned" here to save it 
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(That is true...[pause=0] I could be looking for meaning where there is none.)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(It's even possible that these feelings have just been the excitement of the situations I've been in.)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(It's hard to tell,[pause=10] given my whole situation...)", "Worried")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("I think we need something more concrete before we jump to any conclusions.")
	UI:WaitShowDialogue("For now,[pause=10] I think we shouldn't worry about it.[pause=0] I'm sure " .. CharacterEssentials.GetCharacterName("Noctowl") .. " knows what he's talking about!")
	UI:WaitShowDialogue("Let's stick to our guild training so we can keep helping Pokémon out like we did today.")
	
	--player is more interested in living pokemon life than figuring shit out? potentially? just an idea
	GAME:WaitFrames(20)
	GeneralFunctions.DoAnimation(hero, 'Nod')
	
	GAME:WaitFrames(40)
	GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
	GeneralFunctions.DoAnimation(partner, "DeepBreath")
	GAME:WaitFrames(10)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("Yawn...[pause=0] I'm feeling sleepy.")
	UI:WaitShowDialogue("Let's get some rest so we can make tomorrow just as great as today.")
	
	GAME:WaitFrames(20)
	GROUND:CharSetAnim(partner, "Laying", true)
	
	
	GAME:WaitFrames(60)
	
	GROUND:CharSetAnim(hero, "Laying", true)
	
	GAME:WaitFrames(40)
	UI:SetSpeaker(partner:GetDisplayName(), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	UI:WaitShowDialogue("Good night,[pause=10] " .. hero:GetDisplayName() .. ".")
	GAME:WaitFrames(40)
	GROUND:CharSetAnim(partner, "EventSleep", true)
	GAME:WaitFrames(40)
	GROUND:CharSetAnim(hero, "EventSleep", true)
	
	GAME:WaitFrames(180)
	SOUND:FadeOutBGM(120)
	GAME:FadeOut(false, 120)
	GAME:CutsceneMode(false)
	GAME:WaitFrames(60)
	GAME:EnterGroundMap("guild_guildmasters_room", "Main_Entrance_Marker")
	

	
	
	
	
	
end 

function guild_heros_room_ch_2.FirstNightBedtalk()
	GAME:FadeOut(false, 1)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GAME:CutsceneMode(true)
	guild_heros_room_helper.Bedtime(false)
	UI:ResetSpeaker()
	GROUND:CharSetAnim(hero, 'Laying', true)
	GROUND:CharSetAnim(partner, 'Laying', true)
	
	--wait a bit after the transition from dinner scene before starting this one
	GAME:WaitFrames(60)
	--characters commenting on the dinner they just had while the screen is still faded out
	UI:SetSpeaker(CharacterEssentials.GetCharacterName('Tropius'), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	UI:WaitShowDialogue("Great meal as always,[pause=10] " .. CharacterEssentials.GetCharacterName('Snubbull') .. "![pause=0] I can't eat another bite!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(CharacterEssentials.GetCharacterName('Breloom'), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	UI:WaitShowDialogue("Yeah,[pause=10] my stomach's so full of " .. '"art"' .. " you could call it a museum!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(CharacterEssentials.GetCharacterName('Mareep'), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	UI:WaitShowDialogue("Ba-a-a-a...[pause=0] It's getting late...[pause=0] Time to hit the\nha-a-a-ay![pause=0] Goodnight everyone!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(CharacterEssentials.GetCharacterName('Zigzagoon'), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	UI:WaitShowDialogue("Yup![pause=0] See you all in the morning!")
	GAME:WaitFrames(60)
	
	GAME:FadeIn(60)
	GAME:WaitFrames(20)
	SOUND:PlayBGM("Goodnight.ogg", true)
	--GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner:GetDisplayName(), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	UI:WaitShowDialogue("..." .. hero:GetDisplayName() .. ",[pause=10] still up?")
	GAME:WaitFrames(20)
	
	UI:WaitShowDialogue("Today wasn't as exciting as I would have liked,[pause=10] but I guess we have to start somewhere.")
	UI:WaitShowDialogue("We did get to learn a lot from Sensei " .. CharacterEssentials.GetCharacterName('Ledian') .. " though.")
	UI:WaitShowDialogue("I hope she can teach us more...[br]We need to learn and train as much as we can if we want to become great adventurers some day!")
	
	GAME:WaitFrames(40)
	UI:WaitShowDialogue("Yawn...[pause=0] Well,[pause=10] staying up all night isn't going to help with that.[pause=0] Let's get some rest.")
	UI:WaitShowDialogue("Here's hoping tomorrow is another great day.")
	UI:WaitShowDialogue("Good night,[pause=10] " .. hero:GetDisplayName() .. ".")
	
	GAME:WaitFrames(20)
	GROUND:CharSetAnim(partner, 'EventSleep', true)
	GAME:WaitFrames(10)
	GROUND:CharSetAnim(hero, 'EventSleep', true)
	GAME:WaitFrames(180)
	SOUND:FadeOutBGM(120)
	GAME:FadeOut(false, 120)
	GAME:WaitFrames(60)
	GAME:CutsceneMode(false)
	SV.Chapter2.FinishedFirstDay = true
	GeneralFunctions.EndOfDay()--reset daily flags and increment day counter by 1
	SV.TemporaryFlags.MorningWakeup = true
	SV.TemporaryFlags.MorningAddress = true
	GAME:EnterGroundMap("guild_heros_room", "Main_Entrance_Marker")
end
