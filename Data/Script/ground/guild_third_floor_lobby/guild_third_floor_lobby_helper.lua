--contains helper functions used by guild_third_floor_lobby_helper scripts.
guild_third_floor_lobby_helper = {}
function guild_third_floor_lobby_helper.SetupMorningAddress()
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
	GROUND:TeleportTo(partner, MRKR("Partner").X, MRKR("Partner").Y, MRKR("Partner").Direction)
	GROUND:TeleportTo(hero, MRKR("Hero").X, MRKR("Hero").Y, MRKR("Hero").Direction)
	GAME:FadeIn(40)
	GAME:WaitFrames(20)
	
	return tropius, noctowl, audino, snubbull, growlithe, zigzagoon, girafarig, breloom, mareep, cranidos
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