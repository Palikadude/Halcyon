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
	GROUND:Hide('Door_Exit')
	GAME:FadeIn(20)	
end


function guild_third_floor_lobby_ch_2.Event_Object_1_Action(obj, activator)
	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue("(There are a number of internal guild postings here...)")
	UI:WaitShowDialogue("(...But you're not really sure what to make of them yet.)")
	UI:SetCenter(false)
end



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
	
	GeneralFunctions.CenterCamera({audino, tropius})
	GROUND:TeleportTo(partner, 552, 336, Direction.Left)
	GROUND:TeleportTo(hero, 584, 336, Direction.Left)
	GAME:FadeIn(20)
	GAME:WaitFrames(40)
	
	--hero and partner rush in
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 376, 336, true, 4)
												  GROUND:MoveToPosition(partner, MRKR("Partner").X, MRKR("Partner").Y, true, 4)
												  GROUND:CharAnimateTurnTo(partner, MRKR("Partner").Direction, 4) end)
	local coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 376, 336, true, 4)
												  GROUND:MoveToPosition(hero, MRKR("Hero").X, MRKR("Hero").Y, true, 4)
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
	UI:WaitShowDialogue("Alright,[pause=10] looks like everyone's here now.")
	GAME:WaitFrames(20)
	
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Howdy Pokémon![pause=0] If you don't already know,[pause=10] we have new recruits!")
	GAME:WaitFrames(20)
	
	GROUND:CharAnimateTurnTo(tropius, Direction.DownLeft, 4)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Everyone,[pause=10] please give a warm welcome to Team " .. GAME:GetTeamName() .. ",[pause=10] " .. hero:GetDisplayName() .. " and " .. partner:GetDisplayName() .. "!")
		
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
	SOUND:StopBattleSE()
	
	--turn back towards guildmaster
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(tropius, Direction.Down, 4) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(noctowl, Direction.Down, 4) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(growlithe, Direction.UpLeft, 4)
										    GROUND:CharSetEmote(growlithe, -1, 0)
											GROUND:CharEndAnim(growlithe) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.UpLeft, 4)
											GROUND:CharSetEmote(zigzagoon, -1, 0)
											GROUND:CharEndAnim(zigzagoon) end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(30)
											GROUND:CharAnimateTurnTo(cranidos, Direction.Up, 4) end)
	coro6 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(mareep, Direction.Up, 4) 
											GROUND:CharSetEmote(mareep, -1, 0)
											GROUND:CharEndAnim(mareep) end)
	coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(breloom, Direction.Up, 4)
											GROUND:CharEndAnim(breloom) end)
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:CharAnimateTurnTo(girafarig, Direction.Up, 4)
											GROUND:CharSetEmote(girafarig, -1, 0)
											GROUND:CharEndAnim(girafarig) end)
	coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(audino, Direction.Up, 4)
											GROUND:CharSetEmote(audino, -1, 0) 
											GROUND:CharEndAnim(audino) end)
	coro10 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											 GROUND:CharAnimateTurnTo(snubbull, Direction.Up, 4) end)
	coro11 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
										     GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4) end)
	coro12 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9, coro10, coro11, coro12})
	
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Be sure to treat them with the same respect and kindness you'd treat any other apprentice with!")
	UI:WaitShowDialogue("But that goes without saying of course!")
	GAME:WaitFrames(20)
	
	--morning cheer
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("That's the only announcement for today!")
	UI:WaitShowDialogue("But before we start today's work,[pause=10] what do we always say?")
	GROUND:CharSetEmote(tropius, 1, 0)
	UI:WaitShowDialogue("One for all...")
	GAME:WaitFrames(20)
	

	UI:SetSpeaker('[color=#00FFFF]Everyone[color]', false, -1, -1, -1, RogueEssence.Data.Gender.Unknown)
	GROUND:CharSetEmote(tropius, -1, 0)
	GROUND:CharSetEmote(growlithe, 1, 0)
	GROUND:CharSetEmote(zigzagoon, 1, 0)
	GROUND:CharSetEmote(mareep, 1, 0)
	GROUND:CharSetEmote(girafarig, 1, 0)
	GROUND:CharSetEmote(audino, 1, 0)
	UI:WaitShowDialogue("AND ALL FOR ONE!")
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(growlithe, -1, 0)
	GROUND:CharSetEmote(zigzagoon, -1, 0)
	GROUND:CharSetEmote(mareep, -1, 0)
	GROUND:CharSetEmote(girafarig, -1, 0)
	GROUND:CharSetEmote(audino, -1, 0)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Alright Pokémon,[pause=10] let's get to the day's adventures!")
	GAME:WaitFrames(20)
	
	--HURRAH!
	GROUND:CharSetEmote(growlithe, 1, 0)
	GROUND:CharSetEmote(zigzagoon, 1, 0)
	GROUND:CharSetEmote(mareep, 1, 0)
	GROUND:CharSetEmote(girafarig, 1, 0)
	GROUND:CharSetEmote(audino, 1, 0)	
	GROUND:CharSetAnim(growlithe, "Pose", true)
	GROUND:CharSetAnim(zigzagoon, "Pose", true)
	GROUND:CharSetAnim(breloom, "Pose", true)
	GROUND:CharSetAnim(girafarig, "Pose", true)
	GROUND:CharSetAnim(cranidos, "Pose", true)
	GROUND:CharSetAnim(mareep, "Pose", true)
	GROUND:CharSetAnim(audino, "Pose", true)
	GROUND:CharSetAnim(snubbull, "Pose", true)	
	UI:SetSpeaker('[color=#00FFFF]Everyone[color]', false, -1, -1, -1, RogueEssence.Data.Gender.Unknown)	
	UI:WaitShowDialogue("HURRAH!")
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(growlithe, -1, 0)
	GROUND:CharSetEmote(zigzagoon, -1, 0)
	GROUND:CharSetEmote(mareep, -1, 0)
	GROUND:CharSetEmote(girafarig, -1, 0)
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
end

--used for having apprentices leave towards the stairs
function guild_third_floor_lobby_ch_2.ApprenticeLeave(chara)

end