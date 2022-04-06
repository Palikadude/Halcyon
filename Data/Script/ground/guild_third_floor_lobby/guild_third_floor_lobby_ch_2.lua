require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

guild_third_floor_lobby_ch_2 = {}

function guild_third_floor_lobby_ch_2.SetupGround()
	local board = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1), 
													RogueElements.Rect(264, 216, 48, 8),
													RogueElements.Loc(0, 0), 
													false, 
													"Event_Object_1")
	
	board:ReloadEvents()
	GAME:GetCurrentGround():AddObject(board)
	
	local noctowl = CharacterEssentials.MakeCharactersFromList({
		{'Noctowl', 'Noctowl'}
	})
	GROUND:CharSetAnim(noctowl, 'Idle', true)
	GAME:FadeIn(20)	
end


function guild_third_floor_lobby_ch_2.Event_Object_1_Action(obj, activator)
	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue("(There are a number of internal guild postings here...)")
	UI:WaitShowDialogue("(...But you're not really sure what to make of them yet.)")
	UI:SetCenter(false)
end

----------------
--NPC Scripts
----------------
function guild_third_floor_lobby_ch_2.Noctowl_Action(chara, activator)
	local dir = chara.Direction
	GROUND:CharTurnToChar(chara, CH('PLAYER'))
	UI:SetSpeaker(chara)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Go to Ledian Dojo and take the basic lesson with Sensei " .. CharacterEssentials.GetCharacterName('Ledian') .. ".")
	UI:WaitShowDialogue("She will teach you the basics of adventuring and dungeoneering.")
	UI:WaitShowDialogue("Once you leave the guild,[pause=10] go over the bridge and head east.")
	UI:WaitShowDialogue("There is a ladder that will lead down into a cave,[pause=10] where the dojo is located.")
	GROUND:EntTurn(chara, dir)
end
	


------------------------
--Cutscene Scripts
------------------------



function guild_third_floor_lobby_ch_2.FirstMorningMeeting()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	--create characters
	local tropius, noctowl, audino, snubbull, growlithe, zigzagoon, girafarig, breloom, mareep, cranidos = 
		CharacterEssentials.MakeCharactersFromList({
			{'Tropius', 'Tropius'},
			{'Noctowl', 'Noctowl'},
			{'Audino', 'Audino'},
			{'Snubbull', 'Snubbull'},
			{'Growlithe', 'Growlithe'},
			{'Zigzagoon', 'Zigzagoon'},
			{'Girafarig', 'Girafarig'},
			{'Breloom', 'Breloom'},
			{'Mareep', 'Mareep'},
			{'Cranidos', 'Cranidos'}})
	
	GeneralFunctions.CenterCamera({snubbull, tropius})
	GROUND:TeleportTo(partner, 632, 336, Direction.Left)
	GROUND:TeleportTo(hero, 680, 336, Direction.Left)
	GAME:FadeIn(20)
	GAME:WaitFrames(40)
	
	--hero and partner rush in
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 400, 336, true, 3)
												  GeneralFunctions.EightWayMove(partner, MRKR("Partner").X, MRKR("Partner").Y, true, 3)
												  GROUND:CharAnimateTurnTo(partner, MRKR("Partner").Direction, 4) end)
	local coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 400, 336, true, 3)
												  GeneralFunctions.EightWayMove(hero, MRKR("Hero").X, MRKR("Hero").Y, true, 3)
												  GROUND:CharAnimateTurnTo(hero, MRKR("Hero").Direction, 4) end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(40)
	
	--tropius looks around, looks like everyone's here
	GROUND:CharAnimateTurnTo(tropius, Direction.DownLeft, 8)
	GAME:WaitFrames(40)
	GROUND:CharAnimateTurnTo(tropius, Direction.DownRight, 8)
	GAME:WaitFrames(40)
	GROUND:CharAnimateTurnTo(tropius, Direction.Down, 8)
	GAME:WaitFrames(20)
	UI:SetSpeaker(tropius)
	UI:WaitShowDialogue("Alright,[pause=10] looks like we have everyone now.")
	GAME:WaitFrames(20)
	
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Howdy Pokémon![pause=0] If you don't already know,[pause=10] we have new recruits!")
	GAME:WaitFrames(20)
	
	GROUND:CharAnimateTurnTo(tropius, Direction.DownLeft, 4)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Everyone,[pause=10] please give a warm welcome to Team " .. GAME:GetTeamName() .. ",[pause=10] " .. hero:GetDisplayName() .. " and " .. partner:GetDisplayName() .. "!")
	GAME:WaitFrames(20)
	
	--everyone cheers!
	SOUND:LoopBattleSE('EVT_Applause_Cheer')
	UI:SetSpeaker('[color=#00FFFF]Everyone[color]', false, -1, -1, -1, RogueEssence.Data.Gender.Unknown)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(tropius, hero, 4) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(noctowl, hero, 4) end)
	local coro3 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(growlithe, Direction.Left, 4)
												  GROUND:CharSetEmote(growlithe, 1, 0)
												  GROUND:CharSetAnim(growlithe, "Idle", true) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
												  GROUND:CharAnimateTurnTo(zigzagoon, Direction.Left, 4)
												  GROUND:CharSetEmote(zigzagoon, 4, 0)
												  GROUND:CharSetAnim(zigzagoon, "Idle", true) end)
	local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(30)
												  GROUND:CharAnimateTurnTo(cranidos, Direction.Left, 4) end)
	local coro6 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(mareep, Direction.Left, 4) 
												  GROUND:CharSetEmote(mareep, 1, 0)
												  GROUND:CharSetAnim(mareep, "Twirl", true) end)
	local coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:CharAnimateTurnTo(breloom, Direction.Left, 4)
												  GROUND:CharSetAnim(breloom, "Idle", true) end)
	local coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
												  GROUND:CharAnimateTurnTo(girafarig, Direction.Left, 4)
												  GROUND:CharSetEmote(girafarig, 1, 0)
												  GROUND:CharSetAnim(girafarig, "Idle", true) end)
	local coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											      GROUND:CharAnimateTurnTo(audino, Direction.Left, 4)
												  GROUND:CharSetEmote(audino, 4, 0) 
												  GROUND:CharSetAnim(audino, "Idle", true) end)
	local coro10 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												   GROUND:CharAnimateTurnTo(snubbull, Direction.Left, 4) end)
	local coro11 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												   GROUND:CharAnimateTurnTo(hero, Direction.Right, 4) end)
	local coro12 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Right, 4) end)
	local coro13 = TASK:BranchCoroutine(function() UI:WaitShowDialogue("WELCOME!!!") end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9, coro10, coro11, coro12, coro13})
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Joyous")
	GROUND:CharSetEmote(partner, 1, 0)
	GROUND:CharSetAnim(partner, "Idle", true)
	UI:WaitShowDialogue("Oh![pause=0] Thank you everyone!")
	GAME:WaitFrames(40)
	GROUND:CharEndAnim(partner)
	SOUND:StopBattleSE('EVT_Applause_Cheer')
	
	--turn back towards guildmaster
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(tropius, Direction.Down, 4) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(noctowl, Direction.Down, 4) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:CharSetEmote(growlithe, -1, 0)
											GROUND:CharEndAnim(growlithe) end)
											GROUND:CharAnimateTurnTo(growlithe, Direction.UpLeft, 4)
	coro4 = TASK:BranchCoroutine(function() --GAME:WaitFrames(20)
											GROUND:CharSetEmote(zigzagoon, -1, 0)
											GROUND:CharEndAnim(zigzagoon) 
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.UpLeft, 4) end)
	coro5 = TASK:BranchCoroutine(function() --GAME:WaitFrames(30)
											GROUND:CharAnimateTurnTo(cranidos, Direction.Up, 4) end)
	coro6 = TASK:BranchCoroutine(function() GROUND:CharSetEmote(mareep, -1, 0)
											GROUND:CharEndAnim(mareep)
											GROUND:CharAnimateTurnTo(mareep, Direction.Up, 4) end)
	coro7 = TASK:BranchCoroutine(function() --GAME:WaitFrames(10)
											GROUND:CharEndAnim(breloom)
											GROUND:CharAnimateTurnTo(breloom, Direction.Up, 4) end)
	coro8 = TASK:BranchCoroutine(function() --GAME:WaitFrames(20)
											GROUND:CharSetEmote(girafarig, -1, 0)
											GROUND:CharEndAnim(girafarig)
											GROUND:CharAnimateTurnTo(girafarig, Direction.Up, 4) end)
	coro9 = TASK:BranchCoroutine(function() --GAME:WaitFrames(10)
											GROUND:CharSetEmote(audino, -1, 0) 
											GROUND:CharEndAnim(audino) 
											GROUND:CharAnimateTurnTo(audino, Direction.Up, 4) end)
	coro10 = TASK:BranchCoroutine(function() --GAME:WaitFrames(10)
											 GROUND:CharAnimateTurnTo(snubbull, Direction.Up, 4) end)
	coro11 = TASK:BranchCoroutine(function() --GAME:WaitFrames(10)
										     GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4) end)
	coro12 = TASK:BranchCoroutine(function() GROUND:CharSetEmote(partner, -1, 0)
											 GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9, coro10, coro11, coro12})
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Be sure to treat them with the same respect and kindness you'd treat any other apprentice with!")
	UI:WaitShowDialogue("But that goes without saying of course!")
	GAME:WaitFrames(20)
	
	--morning cheer
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Well,[pause=10] there's nothing else on the docket.[pause=0] That's the only announcement for today!")
	UI:WaitShowDialogue("But before we start today's work,[pause=10] what do we always say?")
	GROUND:CharSetEmote(tropius, 1, 0)
	UI:WaitShowDialogue("One for all...")
	GAME:WaitFrames(20)
	

	UI:SetSpeaker('[color=#00FFFF]Everyone[color]', false, -1, -1, -1, RogueEssence.Data.Gender.Unknown)
	GROUND:CharSetEmote(tropius, -1, 0)
	GROUND:CharSetEmote(growlithe, 1, 0)
	GROUND:CharSetEmote(zigzagoon, 1, 0)
	GROUND:CharSetEmote(mareep, 1, 0)
	GROUND:CharSetEmote(breloom, 1, 0)
	GROUND:CharSetEmote(audino, 1, 0)
	UI:WaitShowDialogue("AND ALL FOR ONE!")
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(growlithe, -1, 0)
	GROUND:CharSetEmote(zigzagoon, -1, 0)
	GROUND:CharSetEmote(mareep, -1, 0)
	GROUND:CharSetEmote(breloom, -1, 0)
	GROUND:CharSetEmote(audino, -1, 0)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Alright Pokémon,[pause=10] let's get to the day's adventures!")
	GAME:WaitFrames(20)
	
	--HURRAH!
	GROUND:CharSetEmote(growlithe, 1, 0)
	GROUND:CharSetEmote(zigzagoon, 1, 0)
	GROUND:CharSetEmote(mareep, 1, 0)
	GROUND:CharSetEmote(breloom, 1, 0)
	GROUND:CharSetEmote(audino, 1, 0)	
	--todo: replace with poses when the animations for them exist
	GROUND:CharPoseAnim(growlithe, "SpAttack")
	GROUND:CharPoseAnim(zigzagoon, "SpAttack")
	GROUND:CharPoseAnim(breloom, "SpAttack")
	GROUND:CharPoseAnim(girafarig, "SpAttack")
	GROUND:CharPoseAnim(cranidos, "SpAttack")
	GROUND:CharPoseAnim(mareep, "SpAttack")
	GROUND:CharPoseAnim(audino, "SpAttack")
	GROUND:CharPoseAnim(snubbull, "SpAttack")	
	UI:SetSpeaker('[color=#00FFFF]Everyone[color]', false, -1, -1, -1, RogueEssence.Data.Gender.Unknown)	
	UI:WaitShowDialogue("HURRAH!")
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(growlithe, -1, 0)
	GROUND:CharSetEmote(zigzagoon, -1, 0)
	GROUND:CharSetEmote(mareep, -1, 0)
	GROUND:CharSetEmote(breloom, -1, 0)
	GROUND:CharSetEmote(audino, -1, 0)
	GROUND:CharEndAnim(growlithe)
	GROUND:CharEndAnim(zigzagoon)
	GROUND:CharEndAnim(breloom)
	GROUND:CharEndAnim(girafarig)
	GROUND:CharEndAnim(cranidos)
	GROUND:CharEndAnim(mareep)
	GROUND:CharEndAnim(audino)
	GROUND:CharEndAnim(snubbull)	
	
	--everyone leaves
	GAME:WaitFrames(40)
	coro1 = TASK:BranchCoroutine(function() guild_third_floor_lobby_ch_2.ApprenticeLeave(growlithe) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(32) 
											guild_third_floor_lobby_ch_2.ApprenticeLeave(zigzagoon) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(60)
											guild_third_floor_lobby_ch_2.ApprenticeLeave(mareep) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(92)
											guild_third_floor_lobby_ch_2.ApprenticeLeave(cranidos) end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(120)
											guild_third_floor_lobby_ch_2.ApprenticeLeave(snubbull) end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(152)
											guild_third_floor_lobby_ch_2.ApprenticeLeave(audino) end)
	coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(180)
											guild_third_floor_lobby_ch_2.ApprenticeLeave(breloom) end)
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(212)
											guild_third_floor_lobby_ch_2.ApprenticeLeave(girafarig) end)
	coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) 
											GROUND:CharAnimateTurnTo(partner, Direction.Right, 4) end)
	coro10 = TASK:BranchCoroutine(function() GAME:WaitFrames(30) 
											 GROUND:CharAnimateTurnTo(hero, Direction.Right, 4) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9, coro10})

	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(tropius, Direction.DownLeft, 4)
	GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4)
	GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Team " .. GAME:GetTeamName() .. ",[pause=10] would you come speak with me for a moment please?")
	GAME:WaitFrames(20)
	
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, 456, 272, false, 1) 
											GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(30)
											GeneralFunctions.EightWayMove(hero, 424, 272, false, 1) 
											GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end)
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(tropius, partner, 4, Direction.Down) end)
	coro4 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(noctowl, partner, 4, Direction.DownRight) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	--tropius's little intro and check-in
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("How are you two doing?[pause=0] Sleep well last night?[pause=0] Get acquainted with any of the apprentices yet?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Yup![pause=0] The room and beds you gave us are great!")
	UI:WaitShowDialogue("We went around yesterday and introduced ourselves to all the other apprentices too!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("I'm glad to hear that![pause=0] Seems like you're settling in fine then!")
	
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("On to business...[pause=0] As it's your first day,[pause=10] allow me to explain to you how guild training will work.")
	UI:WaitShowDialogue("Every morning,[pause=10] after the daily meeting,[pause=10] " .. noctowl:GetDisplayName() .. " will give you an assignment for the day.")
	UI:WaitShowDialogue("This could be taking requests from the boards downstairs or tasks " .. noctowl:GetDisplayName() .. " comes up with for you.")
	UI:WaitShowDialogue("Make sure to speak with him before you leave for the day and that you do whatever he asks of you!")
	UI:WaitShowDialogue("If you have any trouble,[pause=10] you can always ask any of your fellow guild members for help...[pause=0] Including me!")
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Oh,[pause=10] and we have dinner around sunset,[pause=10] so make it back by then if you want to have " .. snubbull:GetDisplayName() .. "'s cooking!")
	UI:SetSpeakerEmotion("Normal")
	
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(tropius, noctowl, 4)
	GROUND:CharTurnToCharAnimated(noctowl, tropius, 4)
	UI:WaitShowDialogue("Now,[pause=10] " .. noctowl:GetDisplayName() .. ",[pause=10] if you would?[pause=0] I have some work to attend to in my office.")

	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("Of course Guildmaster.")
	
	--tropius takes his leave
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(84)
											GeneralFunctions.EightWayMove(noctowl, 440, 240, false, 1)
											GROUND:CharAnimateTurnTo(noctowl, Direction.Down, 4) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(tropius, Direction.Up, 4)
											GROUND:MoveInDirection(tropius, Direction.Up, 24, false, 1)
											GAME:GetCurrentGround():RemoveTempChar(tropius) end)

	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("As you heard from the Guildmaster,[pause=10] I will be leading your training initiative.")
	UI:WaitShowDialogue("Since you are inexperienced,[pause=10] I would like you to go to Ledian Dojo and take the basic lesson with Sensei " .. CharacterEssentials.GetCharacterName('Ledian') .. ".")
	
	
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(partner, "Question", true)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Ledian Dojo?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Ledian Dojo is a local training facility.[pause=0] Please speak with the Sensei there and request the basic lesson.")
	UI:WaitShowDialogue("She will teach you the basics of adventuring and dungeoneering.")
	UI:WaitShowDialogue("It is imperative that you learn these skills before you do any actual adventuring work.")
	UI:WaitShowDialogue("Once you leave the guild,[pause=10] go over the bridge and head east.")
	UI:WaitShowDialogue("There is a ladder that will lead down into a cave,[pause=10] where the dojo is located.")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("Aww...[pause=0] I was hoping to do something a little more exciting...[pause=0] But we are new I guess...")

	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Oh well...[pause=0] " .. noctowl:GetDisplayName() .. ",[pause=10] we'll head right over to the dojo.")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("Very good.[pause=0] Make sure not to come back to the guild too late or you will miss dinner.")
	GAME:WaitFrames(20)
	
	GeneralFunctions.PanCamera(448, 268)
	SV.Chapter2.FirstMorningMeetingDone = true
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)

	GAME:CutsceneMode(false)
		
	
	
end

--used for having apprentices leave towards the stairs
function guild_third_floor_lobby_ch_2.ApprenticeLeave(chara)
	GeneralFunctions.EightWayMove(chara, 528, 280, false, 1)
	GeneralFunctions.EightWayMove(chara, 608, 200, false, 1)
	GAME:GetCurrentGround():RemoveTempChar(chara)
end