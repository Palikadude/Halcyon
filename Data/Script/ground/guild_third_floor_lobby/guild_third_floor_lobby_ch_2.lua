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
	UI:WaitShowDialogue("Looks like everyone's here now.")
	GAME:WaitFrames(20)
	
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Howdy Pokémon![pause=0] If you don't already know,[pause=10] we have new recruits!")
	GAME:WaitFrames(20)
	
	GROUND:CharAnimateTurnTo(tropius, Direction.DownLeft, 4)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Everyone,[pause=10] please give a warm welcome to Team " .. GAME:GetTeamName() .. ",[pause=10] " .. hero:GetDisplayName() .. " and " .. partner:GetDisplayName() .. "!")
	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(tropius, hero, 4) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(noctowl, hero, 4) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(growlithe, Direction.Left, 4) end)
	coro4 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(zigzagoon, Direction.Left, 4) end)
	coro5 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(cranidos, Direction.Left, 4) end)
	coro6 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(mareep, Direction.Left, 4) end)
	coro7 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(breloom, Direction.Left, 4) end)
	coro8 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(girafarig, Direction.Left, 4) end)
	coro9 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(audino, Direction.Left, 4) end)
	coro10 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(snubbull, Direction.Left, 4) end)
	coro11 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(hero, Direction.Right, 4) end)
	coro12 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Right, 4) end)

	