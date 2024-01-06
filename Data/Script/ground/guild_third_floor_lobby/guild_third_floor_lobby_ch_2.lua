require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'
require 'ground.guild_third_floor_lobby.guild_third_floor_lobby_helper'

guild_third_floor_lobby_ch_2 = {}

function guild_third_floor_lobby_ch_2.SetupGround()

	--noctowl should not appear if this is the 2nd day, as he would be down on the 2nd floor 
	if SV.Chapter2.EnteredRiver or not SV.Chapter2.FinishedFirstDay then 
		local noctowl = CharacterEssentials.MakeCharactersFromList({
			{'Noctowl', 'Noctowl'}
		})
		GROUND:CharSetAnim(noctowl, 'Idle', true)
	end
	
	GAME:FadeIn(20)	
end



----------------
--NPC Scripts
----------------
function guild_third_floor_lobby_ch_2.Noctowl_Action(chara, activator)
	if not SV.Chapter2.EnteredRiver then 
		GeneralFunctions.StartConversation(chara, "Go to Ledian Dojo and take the basic lesson with Sensei " .. CharacterEssentials.GetCharacterName('Ledian') .. ".")
		UI:WaitShowDialogue("She will teach you the basics of adventuring and dungeoneering.")
		UI:WaitShowDialogue("Once you leave the guild,[pause=10] go over the bridge and head east.")
		UI:WaitShowDialogue("There is a ladder that will lead down into a cave,[pause=10] where the dojo is located.")
		GeneralFunctions.EndConversation(chara)
	else 
		local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("illuminant_riverbed")
		GeneralFunctions.StartConversation(chara, zone:GetColoredName() .. " is located to the north of town.")
		UI:WaitShowDialogue("You should prepare yourselves with the proper facilities in town,[pause=10] then head north to search for " .. CharacterEssentials.GetCharacterName("Numel") .. ".")
		UI:WaitShowDialogue("If you manage to find him,[pause=10] please bring him back to town immediately.")
		GeneralFunctions.EndConversation(chara)
	end
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
	GAME:FadeIn(40)
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
	UI:SetSpeaker('[color=#00FFFF]Everyone[color]', true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(tropius, hero, 4) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(noctowl, hero, 4) end)
	local coro3 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(growlithe, Direction.Left, 4)
												  GROUND:CharSetEmote(growlithe, "happy", 0)
												  GROUND:CharSetAnim(growlithe, "Idle", true) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
												  GROUND:CharAnimateTurnTo(zigzagoon, Direction.Left, 4)
												  GROUND:CharSetEmote(zigzagoon, "glowing", 0)
												  GROUND:CharSetAnim(zigzagoon, "Idle", true) end)
	local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(30)
												  GROUND:CharAnimateTurnTo(cranidos, Direction.Left, 4) end)
	local coro6 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(mareep, Direction.Left, 4) 
												  GROUND:CharSetEmote(mareep, "happy", 0)
												  GROUND:CharSetAnim(mareep, "Twirl", true) end)
	local coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:CharAnimateTurnTo(breloom, Direction.Left, 4)
												  GROUND:CharSetAnim(breloom, "Idle", true) end)
	local coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
												  GROUND:CharAnimateTurnTo(girafarig, Direction.Left, 4)
												  GROUND:CharSetEmote(girafarig, "happy", 0)
												  GROUND:CharSetAnim(girafarig, "Idle", true) end)
	local coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											      GROUND:CharAnimateTurnTo(audino, Direction.Left, 4)
												  GROUND:CharSetEmote(audino, "glowing", 0) 
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
	GROUND:CharSetEmote(partner, "happy", 0)
	GROUND:CharSetAnim(partner, "Idle", true)
	UI:WaitShowDialogue("Oh![pause=0] Thank you everyone!")
	GAME:WaitFrames(40)
	GROUND:CharEndAnim(partner)
	SOUND:StopBattleSE('EVT_Applause_Cheer')
	
	--turn back towards guildmaster
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(tropius, Direction.Down, 4) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(noctowl, Direction.Down, 4) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:CharSetEmote(growlithe, "", 0)
											GROUND:CharEndAnim(growlithe) end)
											GROUND:CharAnimateTurnTo(growlithe, Direction.UpLeft, 4)
	coro4 = TASK:BranchCoroutine(function() --GAME:WaitFrames(20)
											GROUND:CharSetEmote(zigzagoon, "", 0)
											GROUND:CharEndAnim(zigzagoon) 
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.UpLeft, 4) end)
	coro5 = TASK:BranchCoroutine(function() --GAME:WaitFrames(30)
											GROUND:CharAnimateTurnTo(cranidos, Direction.Up, 4) end)
	coro6 = TASK:BranchCoroutine(function() GROUND:CharSetEmote(mareep, "", 0)
											GROUND:CharEndAnim(mareep)
											GROUND:CharAnimateTurnTo(mareep, Direction.Up, 4) end)
	coro7 = TASK:BranchCoroutine(function() --GAME:WaitFrames(10)
											GROUND:CharEndAnim(breloom)
											GROUND:CharAnimateTurnTo(breloom, Direction.Up, 4) end)
	coro8 = TASK:BranchCoroutine(function() --GAME:WaitFrames(20)
											GROUND:CharSetEmote(girafarig, "", 0)
											GROUND:CharEndAnim(girafarig)
											GROUND:CharAnimateTurnTo(girafarig, Direction.Up, 4) end)
	coro9 = TASK:BranchCoroutine(function() --GAME:WaitFrames(10)
											GROUND:CharSetEmote(audino, "", 0) 
											GROUND:CharEndAnim(audino) 
											GROUND:CharAnimateTurnTo(audino, Direction.Up, 4) end)
	coro10 = TASK:BranchCoroutine(function() --GAME:WaitFrames(10)
											 GROUND:CharAnimateTurnTo(snubbull, Direction.Up, 4) end)
	coro11 = TASK:BranchCoroutine(function() --GAME:WaitFrames(10)
										     GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4) end)
	coro12 = TASK:BranchCoroutine(function() GROUND:CharSetEmote(partner, "", 0)
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
	GROUND:CharSetEmote(tropius, "happy", 0)
	UI:WaitShowDialogue("One for all...")
	GAME:WaitFrames(20)
	

	UI:SetSpeaker('[color=#00FFFF]Everyone[color]', true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	GROUND:CharSetEmote(tropius, "", 0)
	GROUND:CharSetEmote(growlithe, "happy", 0)
	GROUND:CharSetEmote(zigzagoon, "happy", 0)
	GROUND:CharSetEmote(mareep, "happy", 0)
	GROUND:CharSetEmote(breloom, "happy", 0)
	GROUND:CharSetEmote(audino, "happy", 0)
	UI:WaitShowDialogue("AND ALL FOR ONE!")
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(growlithe, "", 0)
	GROUND:CharSetEmote(zigzagoon, "", 0)
	GROUND:CharSetEmote(mareep, "", 0)
	GROUND:CharSetEmote(breloom, "", 0)
	GROUND:CharSetEmote(audino, "", 0)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Alright Pokémon,[pause=10] let's get to the day's adventures!")
	GAME:WaitFrames(20)
	
	--HURRAH!
	GROUND:CharSetEmote(growlithe, "happy", 0)
	GROUND:CharSetEmote(zigzagoon, "happy", 0)
	GROUND:CharSetEmote(mareep, "happy", 0)
	GROUND:CharSetEmote(breloom, "happy", 0)
	GROUND:CharSetEmote(audino, "happy", 0)	
	--turn pokemon on the edges up so pose is appropriate
	GROUND:EntTurn(growlithe, Direction.Up)
	GROUND:EntTurn(zigzagoon, Direction.Up)
	
	GROUND:CharSetAction(growlithe, RogueEssence.Ground.PoseGroundAction(growlithe.Position, growlithe.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(zigzagoon, RogueEssence.Ground.PoseGroundAction(zigzagoon.Position, zigzagoon.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(breloom, RogueEssence.Ground.PoseGroundAction(breloom.Position, breloom.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(girafarig, RogueEssence.Ground.PoseGroundAction(girafarig.Position, girafarig.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(cranidos, RogueEssence.Ground.PoseGroundAction(cranidos.Position, cranidos.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(mareep, RogueEssence.Ground.PoseGroundAction(mareep.Position, mareep.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(audino, RogueEssence.Ground.PoseGroundAction(audino.Position, audino.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(snubbull, RogueEssence.Ground.PoseGroundAction(snubbull.Position, snubbull.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))	
	UI:SetSpeaker('[color=#00FFFF]Everyone[color]', true, "", -1, "", RogueEssence.Data.Gender.Unknown)	
	UI:WaitShowDialogue("HURRAH!")
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(growlithe, "", 0)
	GROUND:CharSetEmote(zigzagoon, "", 0)
	GROUND:CharSetEmote(mareep, "", 0)
	GROUND:CharSetEmote(breloom, "", 0)
	GROUND:CharSetEmote(audino, "", 0)
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
	coro1 = TASK:BranchCoroutine(function() guild_third_floor_lobby_helper.ApprenticeLeave(growlithe) end)
	coro2 = TASK:BranchCoroutine(function() --GAME:WaitFrames(6) 
											guild_third_floor_lobby_helper.ApprenticeLeaveBottom(zigzagoon) end)
	coro3 = TASK:BranchCoroutine(function() --GAME:WaitFrames(10)
											guild_third_floor_lobby_helper.ApprenticeLeave(mareep) end)
	coro4 = TASK:BranchCoroutine(function() --GAME:WaitFrames(18)
											guild_third_floor_lobby_helper.ApprenticeLeaveBottom(cranidos) end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											guild_third_floor_lobby_helper.ApprenticeLeave(snubbull) end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											guild_third_floor_lobby_helper.ApprenticeLeaveBottom(audino) end)
	coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											guild_third_floor_lobby_helper.ApprenticeLeave(breloom) end)
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											guild_third_floor_lobby_helper.ApprenticeLeaveBottom(girafarig) end)
	coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(16) 
											GROUND:CharAnimateTurnTo(partner, Direction.Right, 4) end)
	coro10 = TASK:BranchCoroutine(function() GAME:WaitFrames(26) 
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
	UI:WaitShowDialogue("On to business...[pause=0] As it's your first day,[pause=10] allow me to explain how your guild training will work.")
	UI:WaitShowDialogue("Every morning,[pause=10] after the daily meeting,[pause=10] " .. noctowl:GetDisplayName() .. " will give you an assignment for the day.")
	UI:WaitShowDialogue("This could be taking requests from the boards downstairs or tasks " .. noctowl:GetDisplayName() .. " comes up with for you.")
	UI:WaitShowDialogue("Make sure to speak with him before you leave for the day and that you do whatever he asks of you!")
	UI:WaitShowDialogue("If you have any trouble,[pause=10] you can always ask any of your fellow guild members for help...[pause=0] Including me!")
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Oh,[pause=10] and we have dinner just after sunset,[pause=10] so make it back by then if you want to have " .. snubbull:GetDisplayName() .. "'s cooking!")
	UI:SetSpeakerEmotion("Normal")
	
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(tropius, noctowl, 4)
	GROUND:CharTurnToCharAnimated(noctowl, tropius, 4)
	UI:WaitShowDialogue("Now,[pause=10] " .. noctowl:GetDisplayName() .. ",[pause=10] if you would?[pause=0] I've got to get some work done in my office.")

	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("Of course,[pause=10] Guildmaster.")
	
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
	
	
	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(partner, "Question", true)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Ledian Dojo?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Ledian Dojo is a local training facility.[pause=0] Please speak with the sensei there and request the basic lesson.")
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


function guild_third_floor_lobby_ch_2.BeforeFirstDinner()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	--[[
	--create characters
	local snubbull, girafarig, breloom, tail = 
		CharacterEssentials.MakeCharactersFromList({
			{'Snubbull', 'Snubbull'},
			{'Girafarig', 'Girafarig'},
			{'Breloom', 'Breloom'},
			{'Tail'})

			
	GAME:MoveCamera(232, 288, 1, false)
	GROUND:TeleportTo(partner, 632, 336, Direction.Left)
	GROUND:TeleportTo(hero, 680, 336, Direction.Left)
	GAME:FadeIn(40)
	
	UI:SetSpeaker(breloom) 
	UI:WaitShowDialogue("Hey,[pause=10] it's the new guys![pause=0] How was your first day on the job?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("It was good![pause=0] We trained at Ledian Dojo today.")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(breloom)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Awesome![pause=0] You'll be exploring ancient ruins and saving Pokémon in danger in no time!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Haha,[pause=10] thanks![pause=0] I sure hope so!")
	
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("What are you two up to out here then?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(breloom)
	UI:WaitShowDialogue(girafarig:GetDisplayName() .. " and I are waiting out here until " .. snubbull:GetDisplayName() .. " finishes cooking dinner.")
	UI:WaitShowDialogue("We would wait at the dinner table,[pause=10] but " .. snubbull:GetDisplayName() .. " insists that nobody watch her while she cooks.")
	UI:WaitShowDialogue("She doesn't want anyone disturbing her while she's " .. '"making art".')
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("She talked big about her food yesterday,[pause=10] but I didn't think she would go that far.")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(girafarig)2
	UI:WaitShowDialogue("Yup,[pause=10] " .. snubbull:GetDisplayName() .. " takes her cooking very seriously.")
	UI:WaitShowDialogue("I wish she didn't take so long though to finish dinner.")
	UI:WaitShowDialogue("We've been waiting for quite a bit now![pause=0] " .. CharacterEssentials.GetCharacterName("Tail") .. " and I are starving!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(tail) 
	UI:WaitShowDialogue(".........")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(breloom)
	UI:WaitShowDialogue("It's worth the wait though.[pause=0] I don't know how she does it,[pause=10] but she makes great meals.")
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Sometimes I even try to sneak in a midnight snack of some of the leftovers,[pause=10] heheh!")
	]]--
	
	
	--create characters
	local snubbull, girafarig, breloom, zigzagoon, audino, tropius, noctowl, growlithe, cranidos, mareep = 
		CharacterEssentials.MakeCharactersFromList({
			{'Snubbull', 32, 332, Direction.Right},
			{'Girafarig', 248, 332, Direction.Left},
			{'Breloom', 212, 332, Direction.Right},
			{'Zigzagoon', 200, 288, Direction.Down},
			{'Audino', 420, 332, Direction.Left},
			{'Tropius', 440, 332, Direction.Left},
			{'Noctowl', 440, 332, Direction.Left},
			{'Growlithe', 440, 288, Direction.Left},
			{'Cranidos', 440, 312, Direction.Left},
			{'Mareep', 440, 344, Direction.Left}
			})

	SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true)
	GAME:MoveCamera(232, 288, 1, false)
	GROUND:TeleportTo(hero, 420, 264, Direction.Left)
	GROUND:TeleportTo(partner, 420, 296, Direction.Left)
	GROUND:CharSetAnim(zigzagoon, "Idle", true)
	GROUND:CharSetAnim(breloom, "Idle", true)
	GROUND:CharSetAnim(girafarig, "Idle", true)
	GAME:FadeIn(20)
	
	local coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:MoveToPosition(hero, 264, 264, false, 1)
												  GROUND:CharAnimateTurnTo(hero, Direction.DownLeft) end)
	local coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 264, 296, false, 1) 
												  GROUND:CharAnimateTurnTo(partner, Direction.DownLeft, 4) end)

	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(10)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("Looks like a few other guild members are waiting around here for dinner.")

	GROUND:MoveToPosition(snubbull, 144, 332, false, 1)


	--put a sfx here
	UI:SetSpeaker(snubbull)
	UI:WaitShowDialogue("Everyone![pause=0] Your attention please!")
	
	GAME:WaitFrames(20)
	SOUND:PlayBattleSE('EVT_Emote_Exclaim_2')
	coro1 = TASK:BranchCoroutine(function() GROUND:CharSetEmote(partner, "exclaim", 1)
											GROUND:CharTurnToCharAnimated(partner, snubbull, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharSetEmote(hero, "notice", 1)
											GROUND:CharTurnToCharAnimated(partner, snubbull, 4) end)
	local coro3 = TASK:BranchCoroutine(function() GROUND:CharSetEmote(girafarig, "notice", 1)
												  GROUND:CharEndAnim(girafarig)
												  GROUND:CharTurnToCharAnimated(girafarig, snubbull, 4) end)	
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(30)
											GROUND:CharSetEmote(breloom, "exclaim", 1)
											GROUND:CharEndAnim(breloom)
											GROUND:CharTurnToCharAnimated(breloom, snubbull, 4) end)
	local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:CharSetEmote(zigzagoon, "exclaim", 1)
											GROUND:CharEndAnim(zigzagoon)
											GROUND:CharTurnToCharAnimated(zigzagoon, snubbull, 4) end)
											
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("My latest work of art is ready for the public.[pause=0] Follow me for the viewing,[pause=10] if you would. " .. STRINGS:Format("\\u266A"))
	
	--partner and hero are confused
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.DoubleHop(breloom) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GeneralFunctions.Hop(girafarig) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GeneralFunctions.DoubleHop(zigzagoon) end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3})

	GROUND:CharSetAnim(zigzagoon, "Idle", true)
	GROUND:CharSetAnim(breloom, "Idle", true)
	GROUND:CharSetAnim(girafarig, "Idle", true)
	
	GROUND:CharSetEmote(zigzagoon, "happy", 0)
	GROUND:CharSetEmote(breloom, "happy", 0)
	GROUND:CharSetEmote(girafarig, "glowing", 0)
	
	SOUND:LoopBattleSE('EVT_Applause_Cheer')
	UI:SetSpeaker(breloom:GetDisplayName() .. ', ' .. girafarig:GetDisplayName() .. ', & ' .. zigzagoon:GetDisplayName(), false, "", -1, "", RogueEssence.Data.Gender.Unknown)
	UI:WaitShowDialogue("HOORAY!")
	SOUND:StopBattleSE('EVT_Applause_Cheer')
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(zigzagoon, "", 0)
	GROUND:CharSetEmote(breloom, "", 0)
	GROUND:CharSetEmote(girafarig, "", 0)
	GROUND:CharEndAnim(breloom)
	GROUND:CharEndAnim(girafarig)
	GROUND:CharEndAnim(zigzagoon)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(breloom, 0, 332, false, 2) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.EightWayMove(girafarig, 0, 332, false, 2) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(54)
											GeneralFunctions.EightWayMove(zigzagoon, 0, 332, false, 2) end)
	coro4 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(snubbull, Direction.Left, 4)
											GeneralFunctions.EightWayMove(snubbull, 0, 332, false, 2) end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GeneralFunctions.EmoteAndPause(hero, "Question", false) end)
	local coro6 = TASK:BranchCoroutine(function() 
											GAME:WaitFrames(10)
											SOUND:PlayBattleSE('EVT_Emote_Confused')
											GROUND:CharSetEmote(partner, "question", 1) 
											UI:WaitShowTimedDialogue("Huh?[pause=30] Work of art?[pause=30] What's going on?", 60) end)
	local coro7 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(audino, 232, 332, false, 1) end)
	
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7})		
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(audino)
	UI:SetSpeakerEmotion("Happy")
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(audino, partner, 4) 
											UI:WaitShowDialogue("That's just how " .. snubbull:GetDisplayName() .. " lets everyone know it's dinnertime.")
											UI:SetSpeakerEmotion("Normal")
											UI:WaitShowDialogue("She's v-very prideful when it comes to her cooking.[pause=0] She considers each meal she makes a work of art!") end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, audino, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(hero, Direction.DownLeft, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Oh.[pause=0] That's a bit odd,[pause=10] but I guess I understand now.[pause=0] Well,[pause=10] in that case...")
	

	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:SetSpeakerEmotion("Happy")
	GROUND:CharSetEmote(partner, "glowing", 0)
	UI:WaitShowDialogue("Let's eat!")
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(partner, "", 0)
	GROUND:CharAnimateTurnTo(audino, Direction.Left, 4)
	
	--they walk off
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(12)
											GeneralFunctions.EightWayMove(audino, 0, 332, false, 1)
											SOUND:FadeOutBGM(60)
											GAME:FadeOut(false, 60) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(9)
											GeneralFunctions.EightWayMove(hero, 264, 296, false, 1)
											GeneralFunctions.EightWayMove(hero, 0, 332, false, 1) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.DownLeft, 4)
											GeneralFunctions.EightWayMove(partner, 0, 332, false, 1) end)
	coro4 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(tropius, 130, 332, false, 1) end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(32)
											GeneralFunctions.EightWayMove(noctowl, 162, 332, false, 1) end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(60)
											GROUND:MoveInDirection(growlithe, Direction.Left, 260, false, 1) end)
	coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(120)
											GROUND:MoveInDirection(mareep, Direction.Left, 200, false, 1) end)
	local coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(130)
											GROUND:MoveInDirection(cranidos, Direction.Left, 200, false, 1) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8})		

	GAME:WaitFrames(20)
	SV.TemporaryFlags.Dinnertime = true
	GAME:CutsceneMode(false)
	SV.partner.Spawn = 'Default'
	GAME:EnterGroundMap("guild_dining_room", "Main_Entrance_Marker")


end

function guild_third_floor_lobby_ch_2.PostSecondMorningAddress()
	local noctowl = CH('Noctowl')
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	GROUND:CharTurnToCharAnimated(noctowl, partner, 4)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("Ah,[pause=10] Team " .. GAME:GetTeamName() .. ".")
	GAME:WaitFrames(20)
	
	GROUND:CharTurnToCharAnimated(partner, noctowl, 4)
	GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4)
	
	
	UI:WaitShowDialogue("Please follow me.[pause=0] I will show you to your assignment for today.")
	GAME:WaitFrames(20)
	
	local coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(noctowl, Direction.Right, 4) 
											GROUND:MoveInDirection(noctowl, Direction.Right, 200, false, 1) end)	
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(30)
											GROUND:CharAnimateTurnTo(partner, Direction.Right, 4) 
											GROUND:MoveInDirection(partner, Direction.Right, 180, false, 1) end)	
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(40)
											GROUND:CharAnimateTurnTo(hero, Direction.Right, 4) 
											GROUND:MoveInDirection(hero, Direction.Right, 180, false, 1)  end) 
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(140)
												  SOUND:FadeOutBGM()		
												  GAME:FadeOut(false, 40) end)
											
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	GAME:WaitFrames(20)
	GAME:CutsceneMode(false)
	SV.partner.Spawn = 'Default'
	GAME:EnterGroundMap("guild_second_floor", "Main_Entrance_Marker")


end

function guild_third_floor_lobby_ch_2.FailedRiver()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("illuminant_riverbed")
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("Come on " .. hero:GetDisplayName() .. "![pause=0] We need to get back to " .. zone:GetColoredName() .. " to find " .. CharacterEssentials.GetCharacterName("Numel") .. "!") 
	
	GeneralFunctions.PanCamera()
	GAME:CutsceneMode(false)
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)

end


