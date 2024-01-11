require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'
require 'ground.guild_third_floor_lobby.guild_third_floor_lobby_helper'


guild_third_floor_lobby_ch_4 = {}

function guild_third_floor_lobby_ch_4.SetupGround()
	
	local noctowl = CharacterEssentials.MakeCharactersFromList({
		{'Noctowl', 'Noctowl'}
	})
	
	GAME:FadeIn(20)
end



----------------
--NPC Scripts
----------------
function guild_third_floor_lobby_ch_4.Noctowl_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then 
		local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("apricorn_grove")
		GeneralFunctions.StartConversation(chara, "The Guildmaster has asked you to explore the newly discovered " .. zone:GetColoredName() .. ".")
		UI:WaitShowDialogue("Investigate the dungeon to the best of your abilities,[pause=10] then report back with any findings.")
		GeneralFunctions.EndConversation(chara)
	else
		guild_third_floor_lobby_helper.GenericNoctowlResponse()
	end
end
	

------------------------
--Post Address Scripts
------------------------

--Player's last dungeon wasn't the grove and they haven't reached the end of the grove yet.
function guild_third_floor_lobby_ch_4.NotEnteredGrove()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("apricorn_grove")
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("C'mon " .. hero:GetDisplayName() .. "![pause=0] We have to explore that new dungeon!" )
	UI:WaitShowDialogue("Let's go to " .. zone:GetColoredName() .. " and discover something amazing!")
	
	GeneralFunctions.PanCamera()
	GAME:CutsceneMode(false)
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)
end

--player died before making it to the glade
function guild_third_floor_lobby_ch_4.FailedGroveBeforeEnd()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("apricorn_grove")
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("C'mon " .. hero:GetDisplayName() .. "![pause=0] Our exploration isn't complete yet!" )
	UI:WaitShowDialogue("Let's hurry back to " .. zone:GetColoredName() .. " and discover something this time!")
		
	GeneralFunctions.PanCamera()
	GAME:CutsceneMode(false)
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)
end 

--player failed to grab the apricorn, but did reach the glade.
function guild_third_floor_lobby_ch_4.FailedToGrabApricorn()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("apricorn_grove")
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	
	
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("C'mon " .. hero:GetDisplayName() .. "![pause=0] That huge Apricorn is calling our name!")
	UI:WaitShowDialogue("Let's hurry back to " .. zone:GetColoredName() .. " with enough Pokémon to reach it!")
		
	GeneralFunctions.PanCamera()
	GAME:CutsceneMode(false)
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)
end



------------------------
--Cutscene Scripts
------------------------
function guild_third_floor_lobby_ch_4.ExpeditionAnnouncementAddress()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local tropius, noctowl, audino, snubbull, growlithe, zigzagoon, girafarig, 
		  breloom, mareep, cranidos = guild_third_floor_lobby_helper.SetupMorningAddress()
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('apricorn_grove')
	
	UI:SetSpeaker(tropius)
	UI:WaitShowDialogue("Howdy Pokémon![pause=0] I have a special announcement to make before we get to our adventures today!")
	UI:WaitShowDialogue("As you may have noticed,[pause=10] " .. breloom:GetDisplayName() .. " and " .. girafarig:GetDisplayName() .. " have been absent for the last few days.")
	UI:WaitShowDialogue("They've gone off to scout the ruins up in the mountain range far to the north.")
	UI:WaitShowDialogue("It's believed that these ruins hold undiscovered secrets!")
	UI:WaitShowDialogue("Of course,[pause=10] as adventurers,[pause=10] it's our job to discover the true nature of these ruins and the mysteries they hide.")
	UI:WaitShowDialogue("As such,[pause=10] the guild will be mounting a full-scale expedition to explore these ruins soon!")
	GAME:WaitFrames(10)
	

	local coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(growlithe, "Exclaim", true) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
												  GROUND:CharSetEmote(zigzagoon, "exclaim", 1) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(22)
												  GROUND:CharSetEmote(cranidos, "notice", 1) end)
	local coro4 = TASK:BranchCoroutine(function() GROUND:CharSetEmote(mareep, "exclaim", 1) end)
	local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(16)
												  GROUND:CharSetEmote(audino, "notice", 1) end)
	local coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(14)
												   GROUND:CharSetEmote(snubbull, "notice", 1) end)	
	local coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:CharSetEmote(hero, "notice", 1) end)									 
	local coro8 = TASK:BranchCoroutine(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
	TASK:BranchCoroutine({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8})
	
	GAME:WaitFrames(50)
	GROUND:CharSetAnim(growlithe, "Idle", true)
	GROUND:CharSetAnim(zigzagoon, "Idle", true)
	GROUND:CharSetAnim(audino, "Idle", true)
	GROUND:CharSetAnim(mareep, "Idle", true)
	
	GROUND:CharSetEmote(growlithe, "happy", 0)
	GROUND:CharSetEmote(audino, "happy", 0)
	GROUND:CharSetEmote(mareep, "happy", 0)
	
	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("Wow![pause=0] A guild expedition,[pause=10] ruff?[pause=0] I can't wait!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(mareep)
	UI:SetSpeakerEmotion("Joyous")
	UI:WaitShowDialogue("It's been fa-a-a-ar too long since our last expedition![pause=0] Ooh,[pause=10] I'm so excited!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(audino)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("An expedition means I won't have to do any chores around the guild!")
	UI:WaitShowDialogue("Oh,[pause=10] and exploring those ruins sounds fun too!")
	GAME:WaitFrames(20)
	
	--GeneralFunctions.EmoteAndPause(partner, "Question", true)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Um...[pause=0] What is an expedition exactly?")
	GAME:WaitFrames(20)
	
	--clear guildies emotes/anims
	--GROUND:CharEndAnim(growlithe)
	--GROUND:CharEndAnim(zigzagoon)
	--GROUND:CharEndAnim(mareep)
	--GROUND:CharEndAnim(audino)
	--GROUND:CharSetEmote(growlithe, "", 0)
	--GROUND:CharSetEmote(audino, "", 0)
	--GROUND:CharSetEmote(mareep, "", 0)
	
	GROUND:CharTurnToChar(noctowl, partner)
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("An expedition means that the entire guild will go on an adventure together in a distant place.")
	
	GAME:WaitFrames(10)
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GROUND:CharTurnToCharAnimated(snubbull, noctowl, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(8) GROUND:CharTurnToCharAnimated(cranidos, noctowl, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:CharEndAnim(mareep) 
															   GROUND:CharSetEmote(mareep, "", 0) 
															   GROUND:CharTurnToCharAnimated(mareep, noctowl, 4) end)
	coro5 = TASK:BranchCoroutine(function() GROUND:CharEndAnim(audino)
											GROUND:CharSetEmote(audino, "", 0)
											GROUND:CharTurnToCharAnimated(audino, noctowl, 4) end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharSetEmote(growlithe, "", 0)
											GROUND:CharEndAnim(growlithe)
											GROUND:CharTurnToCharAnimated(growlithe, noctowl, 4) end)
	coro7 = TASK:BranchCoroutine(function() GROUND:CharEndAnim(zigzagoon)
											GROUND:CharTurnToCharAnimated(zigzagoon, noctowl, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7})
	
	UI:WaitShowDialogue("Because it is so far away,[pause=10] we all must trek a great distance together to reach our destination.")
	UI:WaitShowDialogue("As such,[pause=10] great care and preparations are necessary to ensure safe and effective travels.")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Inspired")
	GROUND:CharSetAnim(partner, "Idle", 0)
	UI:WaitShowDialogue("Woah![pause=0] Awesome![pause=0] So we're all gonna go on a big adventure together?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("That's right!")
	GAME:WaitFrames(10)
	
	GROUND:CharEndAnim(partner)
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GROUND:CharAnimateTurnTo(snubbull, Direction.Up, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(8) GROUND:CharAnimateTurnTo(cranidos, Direction.Up, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:CharAnimateTurnTo(mareep, Direction.Up, 4) end)
	coro5 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(audino, Direction.Up, 4) end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GROUND:CharAnimateTurnTo(growlithe, Direction.UpLeft, 4) end)
	coro7 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(zigzagoon, Direction.UpLeft, 4) end)
	coro8 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(noctowl, Direction.Down, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8})
	
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Adventures are more fun with more Pokémon,[pause=10] so expeditions are an absolute blast!")
	UI:WaitShowDialogue("Having the entire guild present allows us to cover more ground and helps keep everyone safe too.")
	UI:WaitShowDialogue("Now,[pause=10] I'm sure you're all excited to go on the expedition...[br]...But we'll have to wait for " .. breloom:GetDisplayName() .. " and " .. girafarig:GetDisplayName() .. " to return first!")
	UI:WaitShowDialogue("They're scouting the road ahead so the expedition can go smoothly!")
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Plus,[pause=10] we wouldn't want to exclude them from the fun,[pause=10] right?")
	GAME:WaitFrames(20)
	
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("They won't be back for a while,[pause=10] so you all have time to do anything you may need to before we embark!")
	UI:WaitShowDialogue("In the meantime,[pause=10] let's all keep up the good work as always![pause=0] Now,[pause=10] what do we always say?")
	
	GROUND:CharSetEmote(tropius, "happy", 0)
	UI:WaitShowDialogue("One for all...")
	GAME:WaitFrames(20)
	

	UI:SetSpeaker('[color=#00FFFF]Everyone[color]', true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	GROUND:CharSetEmote(tropius, "", 0)
	GROUND:CharSetEmote(growlithe, "happy", 0)
	GROUND:CharSetEmote(zigzagoon, "happy", 0)
	GROUND:CharSetEmote(mareep, "happy", 0)
	GROUND:CharSetEmote(audino, "happy", 0)
	GROUND:CharSetEmote(partner, "happy", 0)
	UI:WaitShowDialogue("AND ALL FOR ONE!")
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(growlithe, "", 0)
	GROUND:CharSetEmote(zigzagoon, "", 0)
	GROUND:CharSetEmote(mareep, "", 0)
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
	GROUND:CharSetEmote(audino, "", 0)	
	GROUND:CharSetEmote(partner, "", 0)

	GROUND:CharEndAnim(growlithe)
	GROUND:CharEndAnim(zigzagoon)
	GROUND:CharEndAnim(cranidos)
	GROUND:CharEndAnim(mareep)
	GROUND:CharEndAnim(audino)
	GROUND:CharEndAnim(snubbull)	
	GROUND:CharEndAnim(partner)	
	GROUND:CharEndAnim(hero)	
	
	--everyone leaves
	GAME:WaitFrames(40)
	local coro1 = TASK:BranchCoroutine(function() guild_third_floor_lobby_helper.ApprenticeLeave(growlithe) end)
	local coro2 = TASK:BranchCoroutine(function() --GAME:WaitFrames(6) 
											guild_third_floor_lobby_helper.ApprenticeLeaveBottom(zigzagoon) end)
	local coro3 = TASK:BranchCoroutine(function() --GAME:WaitFrames(10)
											guild_third_floor_lobby_helper.ApprenticeLeave(mareep) end)
	local coro4 = TASK:BranchCoroutine(function() --GAME:WaitFrames(18)
											guild_third_floor_lobby_helper.ApprenticeLeaveBottom(cranidos) end)
	local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											guild_third_floor_lobby_helper.ApprenticeLeave(snubbull) end)
	local coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											guild_third_floor_lobby_helper.ApprenticeLeaveBottom(audino) end)
	local coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(16) 
											GROUND:CharAnimateTurnTo(partner, Direction.Right, 4) end)
	local coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(26) 
											 GROUND:CharAnimateTurnTo(hero, Direction.Right, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8})

	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(tropius, Direction.DownLeft, 4)
	GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4)
	GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Team " .. GAME:GetTeamName() .. "![pause=0] Could you please come here for a moment?")
	GAME:WaitFrames(20)
	
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, 456, 272, false, 1) 
											GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(30)
											GeneralFunctions.EightWayMove(hero, 424, 272, false, 1) 
											GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end)
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(tropius, partner, 4, Direction.Down) end)
	coro4 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(noctowl, partner, 4, Direction.DownRight) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	GAME:WaitFrames(20)

	--While everyone is welcome of course on the expedition, Guildmaster wants to gauge your skills by sending you to the new forest.
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("I hope the two of you are excited for the upcoming expedition!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Inspired")
	GeneralFunctions.Hop(partner)
	UI:WaitShowDialogue("Of course![pause=0] It sounds absolutely amazing,[pause=10] I can barely contain myself!")
	GAME:WaitFrames(10)
	
	
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("Don't you think so too,[pause=10] " .. hero:GetDisplayName() .."?")
	GAME:WaitFrames(20)
	
	--Same feeling they felt when joining the guild and meeting partner; the expedition is the way forward in their "mission"
	GeneralFunctions.HeroDialogue(hero, "(Hearing about this expedition has me feeling all tense and excited![pause=0] It seems like it'll be a lot of fun!)", "Inspired")
	GAME:WaitFrames(20)
	GeneralFunctions.DoAnimation(hero, 'Nod')
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("That's great![pause=0] I'm glad to hear it!")
	GAME:WaitFrames(10)
	
	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Anyways,[pause=10] onto why I wanted to talk with the both of you.")
	UI:WaitShowDialogue("I wanted to congratulate you on the great work you've done so far!")
	UI:WaitShowDialogue("I haven't seen such promise in a pair of new recruits before!")
	UI:WaitShowDialogue("So,[pause=10] I'd like to put your skills to the test!")
	
	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(partner, "Question", true)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Put our skills to the test?[pause=0] What do you mean?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(tropius)
	UI:WaitShowDialogue("A new forest full of Apricorns was discovered recently.")
	UI:WaitShowDialogue("This is great because up until now there's been a nasty shortage of them!")
	UI:WaitShowDialogue("However,[pause=10] as it turns out,[pause=10] this forest houses a mystery dungeon![pause=0] Pokémon are calling it " .. zone:GetColoredName() ..".")
	UI:WaitShowDialogue("Some Pokémon have gone to its outskirts to pick some Apricorns...[br]...But no one has actually explored the dungeon itself yet.")
	UI:WaitShowDialogue("So,[pause=10] I'd like the two of you to explore the dungeon and see if you can find anything interesting in it!")
	GAME:WaitFrames(10)
	
	GeneralFunctions.EmoteAndPause(partner, "Exclaim", true)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("Y-you're asking us to explore a never before seen dungeon?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(tropius)
	UI:WaitShowDialogue("That's right![pause=0] After your recent successes,[pause=10] I think you're both ready for a real adventure!")
	UI:WaitShowDialogue("Plus,[pause=10] we've got time before " .. CharacterEssentials.GetCharacterName("Breloom") .. " and " .. CharacterEssentials.GetCharacterName("Girafarig") .. " return from their trip.")
	UI:WaitShowDialogue("So this is a good time to gauge your skills for exploration before the expedition.")
	UI:WaitShowDialogue("This new,[pause=10] unexplored dungeon is a great opportunity to do just that!")
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Inspired")
	GeneralFunctions.DoubleHop(partner)
	GROUND:CharSetAnim(partner, "Idle", true)
	UI:WaitShowDialogue("Yes yes yes![pause=0] A real adventure![pause=0] We won't let you down,[pause=10] Guildmaster!")
	GAME:WaitFrames(20)
	
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:WaitShowDialogue(hero:GetDisplayName() .. "![pause=0] Can you believe it!?[pause=0] Our first real adventure!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Happy")
	GROUND:CharSetEmote(tropius, "glowing", 0)
	UI:WaitShowDialogue("Hahaha![pause=0] I see you're already brimming with excitement!")
	GAME:WaitFrames(20)
	
	UI:SetSpeakerEmotion("Normal")
	GROUND:CharSetEmote(tropius, "", 0)
	GROUND:CharEndAnim(partner)
	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	UI:WaitShowDialogue("Of course,[pause=10] we don't know anything about the dungeon besides where it is...[br]...So who even knows if there's anything special in it!")
	UI:WaitShowDialogue("So don't worry if you don't end up finding anything worth reporting!")
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("But do come see me and tell me how it went once you've covered the place top to bottom!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("We will Guildmaster![pause=0] We'll do our best!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("I know you will![pause=0] Good luck and stay safe![pause=0] I know you two will do great!")
	GAME:WaitFrames(20) 
	
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("I'll be heading to my office now.[pause=0] Come see me or " .. noctowl:GetDisplayName() .. " if you need anything!")
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(tropius, Direction.Up, 4)
	GROUND:MoveInDirection(tropius, Direction.Up, 24, false, 1)
	GAME:GetCurrentGround():RemoveTempChar(tropius)
		
	GAME:WaitFrames(40)	
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("I still can't believe it,[pause=10] " .. hero:GetDisplayName() .. "![pause=0] An expedition AND our first real adventure!")
	UI:SetSpeakerEmotion("Teary-Eyed")
	UI:WaitShowDialogue("I'm getting worked up just thinking about it all![pause=0] I can hardly contain myself!")
	
	GAME:WaitFrames(20)
	GeneralFunctions.DoubleHop(partner)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue(hero:GetDisplayName() .. "![pause=0] Let's go to " .. zone:GetColoredName() .. " right now![pause=0] I don't know how much longer I can wait!")
	
	GAME:WaitFrames(20)
	SV.Chapter4.FinishedFirstAddress = true
	GAME:GetCurrentGround():RemoveTempChar(breloom)
	GAME:GetCurrentGround():RemoveTempChar(girafarig)
	GeneralFunctions.PanCamera()
	GROUND:CharAnimateTurnTo(noctowl, Direction.Down, 4)
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)
	GAME:CutsceneMode(false)
		

end