require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'
require 'ground.guild_third_floor_lobby.guild_third_floor_lobby_helper'


guild_third_floor_lobby_ch_3 = {}

function guild_third_floor_lobby_ch_3.SetupGround()
	
	local noctowl = CharacterEssentials.MakeCharactersFromList({
		{'Noctowl', 'Noctowl'}
	})
	
	GAME:FadeIn(20)
end


----------------
--NPC Scripts
----------------
function guild_third_floor_lobby_ch_3.Noctowl_Action(chara, activator)
	if not SV.Chapter3.DefeatedBoss then 
		GeneralFunctions.StartConversation(chara, CharacterEssentials.GetCharacterName("Mareep") .. " and " .. CharacterEssentials.GetCharacterName("Cranidos") .. " have helped you pick out an outlaw job from the board.")
		UI:WaitShowDialogue("They should also be able to assist you with any trouble you may have.")
		UI:WaitShowDialogue("Once you capture the outlaw,[pause=10] bring them back to the guild for your reward from " .. CharacterEssentials.GetCharacterName("Bisharp") .. ".")
		GeneralFunctions.EndConversation(chara)
	else
		guild_third_floor_lobby_helper.GenericNoctowlResponse()
	end
end
	

------------------------
--Post Address Scripts
------------------------

--Player's last dungeon wasn't the cavern and they haven't met the boss of chapter 3.
function guild_third_floor_lobby_ch_3.NotEnteredCavern()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("crooked_cavern")
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(hero:GetDisplayName() .. "![pause=0] We still have an outlaw to catch!")
	UI:WaitShowDialogue("Quickly![pause=0] To " .. zone:GetColoredName() .. "!")
	
	GeneralFunctions.PanCamera()
	GAME:CutsceneMode(false)
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)
end

--player died before making it to boss fight
function guild_third_floor_lobby_ch_3.FailedCavernBeforeBoss()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("crooked_cavern")
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(hero:GetDisplayName() .. "![pause=0] We still have an outlaw to catch!")
	UI:WaitShowDialogue("Quickly![pause=0] To " .. zone:GetColoredName() .. "![pause=0] We can do it this time!")
	
	GeneralFunctions.PanCamera()
	GAME:CutsceneMode(false)
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)
end 

--player died after making it to boss fight
function guild_third_floor_lobby_ch_3.FailedCavernAfterBoss()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("crooked_cavern")
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue(hero:GetDisplayName() .. "![pause=0] We have to get back to " .. CharacterEssentials.GetCharacterName("Sandile") .. "!")
	UI:WaitShowDialogue("Quickly![pause=0] To " .. zone:GetColoredName() .. "![pause=0] We can't let Team [color=#FFA5FF]Style[color] get away with this!")
	
	GeneralFunctions.PanCamera()
	GAME:CutsceneMode(false)
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)
end

------------------------
--Cutscene Scripts
------------------------

function guild_third_floor_lobby_ch_3.FirstMorningAddress()
--this is copy pasted from the usual morning address script, up to a certain point.
--Make sure to modify this if the original morning address script gets modified in a significant way.
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local tropius, noctowl, audino, snubbull, growlithe, zigzagoon, girafarig, 
		  breloom, mareep, cranidos = guild_third_floor_lobby_helper.SetupMorningAddress()

	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Normal")
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
	GROUND:CharSetEmote(partner, "happy", 0)
	UI:WaitShowDialogue("AND ALL FOR ONE!")
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(growlithe, "", 0)
	GROUND:CharSetEmote(zigzagoon, "", 0)
	GROUND:CharSetEmote(mareep, "", 0)
	GROUND:CharSetEmote(breloom, "", 0)
	GROUND:CharSetEmote(audino, "", 0)
	GROUND:CharSetEmote(partner, "", 0)
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
	GROUND:CharSetEmote(partner, "happy", 0)

	--turn pokemon on the edges up so pose is appropriate
	GROUND:EntTurn(growlithe, Direction.Up)
	GROUND:EntTurn(zigzagoon, Direction.Up)
	GROUND:EntTurn(hero, Direction.Up)
	GROUND:EntTurn(partner, Direction.Up)
	
	GROUND:CharSetAction(growlithe, RogueEssence.Ground.PoseGroundAction(growlithe.Position, growlithe.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(zigzagoon, RogueEssence.Ground.PoseGroundAction(zigzagoon.Position, zigzagoon.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(breloom, RogueEssence.Ground.PoseGroundAction(breloom.Position, breloom.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(girafarig, RogueEssence.Ground.PoseGroundAction(girafarig.Position, girafarig.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(cranidos, RogueEssence.Ground.PoseGroundAction(cranidos.Position, cranidos.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(mareep, RogueEssence.Ground.PoseGroundAction(mareep.Position, mareep.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(audino, RogueEssence.Ground.PoseGroundAction(audino.Position, audino.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(snubbull, RogueEssence.Ground.PoseGroundAction(snubbull.Position, snubbull.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))	
	GROUND:CharSetAction(partner, RogueEssence.Ground.PoseGroundAction(partner.Position, partner.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))	
	GROUND:CharSetAction(hero, RogueEssence.Ground.PoseGroundAction(hero.Position, hero.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))	
	UI:SetSpeaker('[color=#00FFFF]Everyone[color]', true, "", -1, "", RogueEssence.Data.Gender.Unknown)	
	UI:WaitShowDialogue("HURRAH!")
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(growlithe, "", 0)
	GROUND:CharSetEmote(zigzagoon, "", 0)
	GROUND:CharSetEmote(mareep, "", 0)
	GROUND:CharSetEmote(breloom, "", 0)
	GROUND:CharSetEmote(audino, "", 0)	
	GROUND:CharSetEmote(partner, "", 0)

	GROUND:CharEndAnim(growlithe)
	GROUND:CharEndAnim(zigzagoon)
	GROUND:CharEndAnim(breloom)
	GROUND:CharEndAnim(girafarig)
	GROUND:CharEndAnim(cranidos)
	GROUND:CharEndAnim(mareep)
	GROUND:CharEndAnim(audino)
	GROUND:CharEndAnim(snubbull)	
	GROUND:CharEndAnim(partner)	
	GROUND:CharEndAnim(hero)	
	
	UI:SetSpeaker(noctowl)
	
	--a modified leaving script as phileas interrupts shuca and ganlon's departure
	GAME:WaitFrames(40)
	local coro1 = TASK:BranchCoroutine(function() guild_third_floor_lobby_helper.ApprenticeLeave(growlithe) end)
	local coro2 = TASK:BranchCoroutine(function() guild_third_floor_lobby_helper.ApprenticeLeaveBottom(zigzagoon) end)
											
											
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											guild_third_floor_lobby_ch_3.ModifiedApprenticeLeave(snubbull) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											guild_third_floor_lobby_ch_3.ModifiedApprenticeLeaveBottom(audino) end)
	local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											guild_third_floor_lobby_ch_3.ModifiedApprenticeLeave(breloom) end)
	local coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											guild_third_floor_lobby_ch_3.ModifiedApprenticeLeaveBottom(girafarig) end)
	local coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) 
												   GROUND:CharAnimateTurnTo(tropius, Direction.Up, 4)
												   GROUND:MoveInDirection(tropius, Direction.Up, 24, false, 1)
												   GAME:GetCurrentGround():RemoveTempChar(tropius) end)
	
	
	--noctowl calls out for shuca and ganlon. the player and partner also will turn towards noctowl
	local coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(16) 
												  GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
												  GAME:WaitFrames(30)
												  GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4) end)
	local coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(26) 
												  GROUND:CharAnimateTurnTo(hero, Direction.Right, 4) 
												  GAME:WaitFrames(30)
												  GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4) end)
	
	local coro10 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(mareep, Direction.Right, 64, false, 1)
												   GeneralFunctions.EmoteAndPause(mareep, "Exclaim", true) end)
	local coro11 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(cranidos, Direction.Right, 80, false, 1)
												   GeneralFunctions.EmoteAndPause(cranidos, "Exclaim", false) end)

	local coro12 = TASK:BranchCoroutine(function() GAME:WaitFrames(40)
												   GROUND:CharAnimateTurnTo(noctowl, Direction.Right, 4)
												   GROUND:CharSetEmote(noctowl, "happy", 0)
												   UI:WaitShowTimedDialogue(mareep:GetDisplayName() .. "![pause=20] " .. cranidos:GetDisplayName() .. "![pause=20] Could you both come here a moment?", 60) end)
												   
												
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9, coro10, coro11, coro12})
	GROUND:CharSetEmote(noctowl, "", 0)
	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(mareep, Direction.Left, 4)
											GROUND:MoveToPosition(mareep, 424, 280, false, 1)
											GROUND:CharAnimateTurnTo(mareep, Direction.UpLeft, 4) end)										
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharAnimateTurnTo(cranidos, Direction.Left, 4)
											GROUND:MoveToPosition(cranidos, 424, 312, false, 1)
											GROUND:CharAnimateTurnTo(cranidos, Direction.UpLeft, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GeneralFunctions.FaceMovingCharacter(noctowl, mareep, 4, Direction.Down) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(32)
											GAME:MoveCamera(408, 268, 40, false) end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	UI:SetSpeaker(mareep)
	UI:WaitShowDialogue("Wha-a-a-at's up,[pause=10] " .. noctowl:GetDisplayName() .. "?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("With Team " .. GAME:GetTeamName() .. "'s successful mission yesterday,[pause=10] I believe they are ready for an outlaw job.")
	UI:WaitShowDialogue("As you and " .. cranidos:GetDisplayName() .. " are the most experienced outlaw hunters in the guild...")
	UI:WaitShowDialogue("...I would like the two of you to assist them in choosing their first job from the Outlaw Notice Board.")
	
	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(cranidos, "Exclaim", true)
	UI:SetSpeaker(cranidos)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("What?[pause=0] You can't be serious,[pause=10] " .. noctowl:GetDisplayName() .. "!")
	UI:WaitShowDialogue("Why should we waste our time helping a bunch of newbies when we could be out catching outlaws ourselves!")
	SOUND:FadeOutBGM(120)
	UI:WaitShowTimedDialogue("No way![pause=30] I won't-", 40)
	
	GAME:WaitFrames(20)
	GeneralFunctions.Hop(mareep)
	GeneralFunctions.Hop(mareep)
	GROUND:CharSetAnim(mareep, "Idle", true)
	GROUND:CharSetEmote(mareep, "happy", 0)
	UI:SetSpeaker(mareep)
	UI:SetSpeakerEmotion("Happy")
	SOUND:PlayBGM('Guildmaster Wigglytuff.ogg', false)
	UI:WaitShowDialogue("Of course,[pause=10] " .. noctowl:GetDisplayName() .. "![pause=0] We'd love to!")
	UI:WaitShowDialogue("We've been dying to show them the ropes of outlaw catching since they joined the guild!")
	GAME:WaitFrames(12)
	GROUND:CharSetEmote(mareep, "", 0)
	GROUND:CharTurnToCharAnimated(mareep, cranidos, 4)
	GROUND:CharEndAnim(mareep)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Isn't that right,[pause=10] " .. cranidos:GetDisplayName() .. "?")
		
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(noctowl, cranidos, 4) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, cranidos, 4) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(hero, cranidos, 4) end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3})
	GAME:WaitFrames(40)
	GROUND:CharTurnToCharAnimated(cranidos, hero, 2)
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(cranidos, mareep, 2)
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(cranidos, hero, 2)	
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(cranidos, mareep, 2)
	GAME:WaitFrames(40)
	
	UI:SetSpeaker(cranidos)
	UI:SetSpeakerEmotion("Surprised")
	GROUND:CharSetEmote(cranidos, "sweating", 1)
	UI:WaitShowDialogue("Y-yup![pause=0] T-that's right![pause=0] We would love to help them with their first outlaw job!")
	UI:WaitShowDialogue("You know how much I love to teach others![pause=0] It's in my nature!")
	UI:SetSpeakerEmotion("Joyous")
	GROUND:CharSetEmote(cranidos, "glowing", 0)
	UI:WaitShowDialogue("Hahaha!")
	
	GAME:WaitFrames(30)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(partner, "Sweatdrop", true) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(hero, "Sweatdrop", false) end)
	TASK:JoinCoroutines({coro1, coro2})

	GAME:WaitFrames(20)
	GROUND:CharSetEmote(cranidos, "", 0)
	UI:SetSpeaker(noctowl)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(mareep, Direction.UpLeft, 4) end)
	coro4 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(cranidos, Direction.UpLeft, 4) end)
	coro5 = TASK:BranchCoroutine(function() UI:WaitShowDialogue("Thank you.[pause=0] Be sure to help them out in any way they may need.") end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})

	GAME:WaitFrames(20)
	UI:SetSpeaker(mareep)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Will do![pause=0] I ca-a-a-an't wait to see what outlaw they're gonna nab!")
	
	GAME:WaitFrames(16)
	GROUND:CharTurnToCharAnimated(mareep, partner, 4)
	GROUND:CharTurnToChar(partner, mareep)
	GROUND:CharTurnToChar(hero, mareep)
	UI:WaitShowDialogue("Come on,[pause=10] you guys![pause=0] Let's get over to the Outlaw Notice Board!")
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
	
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(30)
	--coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(partner, "Sweatdrop", true) end)
	--coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(hero, "Sweatdrop", false) end)
	
	--TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(partner, mareep, 4)
	GROUND:CharTurnToChar(hero, mareep)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Um...[pause=0] Sure thing...[pause=0] We'll be right behind you.")
	
	--ganlon doesn't follow at first
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(mareep, Direction.Right, 4) 
											GROUND:MoveToPosition(mareep, 488, 280, false, 1)
											GAME:WaitFrames(30)
											GROUND:CharTurnToCharAnimated(mareep, cranidos, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:MoveToPosition(partner, 456, 280, false, 1) end)	
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(60)
											GeneralFunctions.EightWayMove(hero, 424, 280, false, 1) end)
											
	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	UI:SetSpeaker(mareep)
	UI:WaitShowDialogue("Coming,[pause=10] " .. cranidos:GetDisplayName() .. "?")
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(hero, cranidos, 4) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, cranidos, 4) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:CharSetEmote(cranidos, "shock", 1)
											SOUND:PlayBattleSE('EVT_Emote_Shock_Bad')
											GAME:WaitFrames(40) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	GROUND:CharAnimateTurnTo(cranidos, Direction.UpRight, 4)
	GROUND:CharSetEmote(cranidos, "sweating", 1)
	UI:SetSpeaker(cranidos)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Uh-huh![pause=0] I'm r-right behind you,[pause=10] too!")
	
	GAME:WaitFrames(20)
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(mareep, Direction.Right, 4) 
											GROUND:MoveToPosition(mareep, 588, 280, false, 1) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(12)
											GROUND:MoveToPosition(partner, 556, 280, false, 1) end)	
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(12)
											GROUND:MoveToPosition(hero, 524, 280, false, 1) end)	
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(43) 
											GeneralFunctions.EightWayMove(cranidos, 492, 280, false, 1) end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(40) SOUND:FadeOutBGM(60) GAME:FadeOut(false, 60) end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	GAME:WaitFrames(40)
	GAME:CutsceneMode(false)
	SV.partner.Spawn = 'Default'--prevents the backend debug console from crying
	GAME:EnterGroundMap("guild_second_floor", "Main_Entrance_Marker")
	
	

end



--used to have apprentices path around shuca and ganlon
function guild_third_floor_lobby_ch_3.ModifiedApprenticeLeave(chara)
	GeneralFunctions.EightWayMove(chara, 504, 280, false, 1)
	GeneralFunctions.EightWayMove(chara, 560, 256, false, 1)
	GeneralFunctions.EightWayMove(chara, 628, 200, false, 1)
	GAME:GetCurrentGround():RemoveTempChar(chara)

end

--used to have apprentices path around shuca and ganlon
function guild_third_floor_lobby_ch_3.ModifiedApprenticeLeaveBottom(chara)
	GeneralFunctions.EightWayMove(chara, 520, 312, false, 1)
	GeneralFunctions.EightWayMove(chara, 576, 336, false, 1)
	GeneralFunctions.EightWayMove(chara, 644, 276, false, 1)
	GAME:GetCurrentGround():RemoveTempChar(chara)
end




