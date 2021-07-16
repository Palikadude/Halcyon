require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'

metano_town_ch_1 = {}



function metano_town_ch_1.PartnerLongingCutscene()
	--Cutscene where partner looks longingly at the guild, then walks away
	local partner = CH('Teammate1')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	GAME:MoveCamera(648, 1208, 1, false)
	GROUND:TeleportTo(partner, 840, 1232, Direction.Left)
	GAME:FadeIn(20)

	--todo: hide everyone that isn't being used for the cutscene, or put the function
	--to do so in the init for the map itself
	
	--todo: put strings into "map strings" but for chapters instead or whatever audino comes up with 

	--walk from offscreen to under the bridge
	GROUND:MoveToPosition(partner, 704, 1232, false, 1)
	GROUND:MoveToPosition(partner, 672, 1200, false, 1)
	GROUND:MoveToPosition(partner, 640, 1200, false, 1)
	GAME:WaitFrames(20)
	--they turn towards the guild and pause
	GROUND:CharAnimateTurn(partner, Direction.Up, 4, false)
	GAME:WaitFrames(60)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("...")
	GAME:WaitFrames(60)
	GROUND:CharAnimateTurnTo(parntner, Direction.Left, 4)

	
	local coro1 = TASK:BranchCoroutine(GROUND:_MoveToPosition(partner, 444, 1200, false, 1))
	GAME:WaitFrames(166)
	GAME:FadeOut(false, 20)
	TASK:JoinCoroutines({coro1})	
	
		
	GAME:CutsceneMode(false)
	GAME:EnterGroundMap("altere_pond", "Main_Entrance_Marker")

end