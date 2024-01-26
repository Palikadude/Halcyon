--contains helper functions used by guild_third_floor_lobby_helper scripts.
guild_third_floor_lobby_helper = {}
function guild_third_floor_lobby_helper.SetupMorningAddress(fadeIn)
	--controls whether or not to do the fade in and short pause, or to let whatever's calling this handle that.
	if fadeIn == nil then fadeIn = true end 

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
	
	--during second half of chapter 3, girafarig and breloom are absent.
	--They return at the beginning of Chapter 5, but they still need to be excluded in chapter 5 since they appear from offscreen.
	--This is kind of a hacky way of doing this, but it works
	--todo? Handle this better instead of a hardcode here
	if (SV.ChapterProgression.Chapter == 3 and SV.Chapter3.DefeatedBoss) or SV.ChapterProgression.Chapter == 4 or (SV.ChapterProgression.Chapter == 5 and not SV.Chapter5.FinishedExpeditionAddress) then
		GROUND:TeleportTo(breloom, 640, 280, Direction.Up)
		GROUND:TeleportTo(girafarig, 640, 312, Direction.Up)
	end

	
	GeneralFunctions.CenterCamera({snubbull, tropius})
	GROUND:TeleportTo(partner, MRKR("Partner").X, MRKR("Partner").Y, MRKR("Partner").Direction)
	GROUND:TeleportTo(hero, MRKR("Hero").X, MRKR("Hero").Y, MRKR("Hero").Direction)
	
	if fadeIn then
		GAME:FadeIn(40)
		GAME:WaitFrames(20)
	end
		
	return tropius, noctowl, audino, snubbull, growlithe, zigzagoon, girafarig, breloom, mareep, cranidos
end

function guild_third_floor_lobby_helper.GenericNoctowlResponse()
	local noctowl = CH('Noctowl')
	GeneralFunctions.StartConversation(noctowl, "Complete requests from the Job Bulletin Board and the Outlaw Notice Board.")
	UI:WaitShowDialogue("That will be all for today.[pause=0] I wish you luck in your day's endeavors.")
	GeneralFunctions.EndConversation(noctowl)
end

--used for having apprentices leave towards the stairs
function guild_third_floor_lobby_helper.ApprenticeLeave(chara)
	GeneralFunctions.EightWayMove(chara, 544, 280, false, 1)
	GeneralFunctions.EightWayMove(chara, 628, 200, false, 1)
	GAME:GetCurrentGround():RemoveTempChar(chara)

end

--used for having apprentices leave towards the stairs
function guild_third_floor_lobby_helper.ApprenticeLeaveBottom(chara)
	GeneralFunctions.EightWayMove(chara, 552, 312, false, 1)
	GeneralFunctions.EightWayMove(chara, 648, 208, false, 1)
	GAME:GetCurrentGround():RemoveTempChar(chara)
end

--used for having apprentices leave towards the stairs - shorter to end cutscene faster
function guild_third_floor_lobby_helper.ApprenticeLeaveFast(chara)
	GeneralFunctions.EightWayMove(chara, 552, 280, false, 1)
	GAME:GetCurrentGround():RemoveTempChar(chara)

end

--used for having apprentices leave towards the stairs - shorter to end cutscene faster
function guild_third_floor_lobby_helper.ApprenticeLeaveBottomFast(chara)
	GeneralFunctions.EightWayMove(chara, 552, 312, false, 1)
	GAME:GetCurrentGround():RemoveTempChar(chara)

end