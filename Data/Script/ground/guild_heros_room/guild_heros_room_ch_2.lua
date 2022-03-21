require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

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
	GROUND:TeleportTo(CH('PLAYER'), hero_bed.Position.X, hero_bed.Position.Y, Direction.Down)
	GROUND:TeleportTo(CH('Teammate1'), partner_bed.Position.X, partner_bed.Position.Y, Direction.Down)
	GeneralFunctions.CenterCamera({hero, partner})
	SV.guild.JustWokeUp = true

	local audino =
		CharacterEssentials.MakeCharactersFromList({
			{"Audino", 120, 204, Direction.UpRight},
		})

	local coro1 = TASK:BranchCoroutine(function() UI:WaitShowTitle("Chapter 2\n\nTo be determined\n", 20)
												  GAME:WaitFrames(180)
												  UI:WaitHideTitle(20) end)
	local coro2 = TASK:BranchCoroutine(function() UI:WaitShowBG("Chapter_1", 180, 20)
												  GAME:WaitFrames(180)
												  UI:WaitHideBG(20) end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(180)

	UI:SetAutoFinish(true)
	UI:WaitShowVoiceOver("The next morning...\n\n", -1)
	UI:SetAutoFinish(false)
	
	GAME:WaitFrames(60)
	SOUND:PlayBattleSE("DUN_Heal_Bell")
	GAME:WaitFrames(90)
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, -1, -1, -1, RogueEssence.Data.Gender.Unknown)
	UI:WaitShowDialogue("Good morning![pause=0] It's time to get up!")
	GAME:FadeIn(20)
	
	--sleepyheads
	GAME:WaitFrames(20)
	UI:SetSpeaker('', true, -1, -1, -1, RogueEssence.Data.Gender.Unknown)
	UI:WaitShowDialogue(".........")
	GAME:WaitFrames(40)
	
	UI:SetSpeaker(audino)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Wake up sleepyheads![pause=0] It's a bright new day!")
	GAME:WaitFrames(20)
	
	GROUND:CharAnimateTurnTo(audino, Direction.Down, 4)
	GAME:WaitFrames(10)
	SOUND:PlayBattleSE("DUN_Heal_Bell")
	GROUND:CharPoseAnim(audino, "Pose")
	GAME:WaitFrames(100)
	GROUND:CharSetAnim(audino, 'None', true)
	GROUND:CharAnimateTurnTo(audino, Direction.UpRight, 4)
	
	--todo: add shakes
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner:GetDisplayName(), true, -1, -1, -1, RogueEssence.Data.Gender.Unknown)
	UI:WaitShowDialogue("Snorfle...[pause=0] Huh?")
	GAME:WaitFrames(20)
	
	coro1 = TASK:BranchCoroutine(function () GAME:WaitFrames(10)
											 GeneralFunctions.DoAnimation(hero, 'Wake') 
											 GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) 
											 GAME:WaitFrames(20)
											 GeneralFunctions.LookAround(hero, 2, 4, false, false, false, Direction.DownLeft) end)
	coro1 = TASK:BranchCoroutine(function () GeneralFunctions.DoAnimation(partner, 'Wake') 
											 GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
											 GAME:WaitFrames(20)
											 GeneralFunctions.LookAround(partner, 2, 4, false, false, false, Direction.DownLeft) end)
	TASK:JoinCoroutines({coro1, coro2})

	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(partner, "Notice", true)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("Oh,[pause=10] good morning,[pause=10] " .. audino:GetDisplayName() .."!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(audino)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Good morning![pause=0] Nothing like a Heal Bell to w-wake you up,[pause=10] huh?")
	
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("It's time for the m-morning meeting![pause=0] Don't be late,[pause=10] especially on your first day!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GeneralFunctions.EmoteAndPause(partner, "Question", true)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Morning meeting?")
	
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
	
	GROUND:MoveToPosition(audino, 0, 204, false, 2)
	GAME:GetCurrentGround():RemoveTempChar(audino)
	
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
	SOUND:PlayBGM("Wigglytuff's Guild.ogg", true)
	GROUND:Unhide("Bedroom_Exit")
	GROUND:Unhide("Save_Point")
	SV.Chapter1.TeamJoinedGuild = true
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)

	GAME:CutsceneMode(false)
	
	
	

end