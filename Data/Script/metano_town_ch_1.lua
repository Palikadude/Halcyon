require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'

metano_town_ch_1 = {}


--partner passes by guild with a sad expression
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

--enter guild cutscene, partner runs in leaving you in the dust
function metano_town_ch_1.RunSequencePartner()
	GROUND:MoveToPosition(CH('Teammate1'), 648, 1200, false, 2)
	GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Left, 4)
end

--walking up to growlithe.
function metano_town_ch_1.WalkSequenceHero()
	GROUND:MoveToPosition(CH('PLAYER'), 648, 1032, false, 1)
	GROUND:MoveToPosition(CH('PLAYER'), 696, 986, false, 1)
	GROUND:MoveToPosition(CH('PLAYER'), 696, 936, false, 1)
	GROUND:CharTurnToCharAnimated(CH('PLAYER'), CH('Growlithe'), 4)
end

--walking up to growlithe
function metano_town_ch_1.WalkSequencePartner()
	GROUND:MoveToPosition(CH('Teammate1'), 648, 986, false, 1)
	GROUND:MoveToPosition(CH('Teammate1'), 696, 986, false, 1)
	GROUND:MoveToPosition(CH('Teammate1'), 696, 912, false, 1)
	GROUND:CharTurnToCharAnimated(CH('Teammate1'), CH('Growlithe'), 4)
end

--growlithe turning as you walk towards him, with him getting excited
function metano_town_ch_1.GrowlitheSequence()
	--todo
end 

--hero and partner enter the guild
function metano_town_ch_1.EnterGuild()
	--center of guild: 744, 796
	--todo: hide all ground characters besides those needed
	
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	GAME:MoveCamera(648, 1208, 1, false)
	GROUND:TeleportTo(partner, 444, 1200, Direction.Right)
	GROUND:TeleportTo(hero, 380, 1200, Direction.Right)
	GAME:FadeIn(20)
	
	--the partner runs in due to excitement, hero struggling to keep up
	local coro1 = TASK:BranchCoroutine(GROUND:_MoveToPosition(hero, 616, 1200, false, 2))
	local coro2 = TASK:BranchCoroutine(metano_town_ch_1.RunSequencePartner)
	TASK:JoinCoroutines({coro1, coro2})	
	
	GeneralFunctions.EmoteAndPause(hero, "Sweating", true)
	UI:SetSpeaker('', false, hero.CurrentForm.Species, hero.CurrentForm.Form, hero.CurrentForm.Skin, hero.CurrentForm.Gender)
	UI:SetSpeakerEmotion("Pain")
	UI:WaitShowTimedDialogue("*huff*[pause=20] *huff*", 60)
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(partner, 4, 0)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	GROUND:CharSetAnim(partner, 'Idle', true)
	UI:WaitShowDialogue("Hehe,[pause=10] I was too excited to walk over,[pause=10] sorry!")
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:CharSetEmote(partner, -1, 0)
	
	GAME:WaitFrames(20)
	GeneralFunctions.LookAround(partner, 2, 4, false, false, false)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("We sort of rushed over here...[pause=0] I'll be sure to give you a tour of town later.")
	
	--turn towards  the guild
	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("Welp...[pause=0] there it is.[pause=0] The Adventurer's Guild.")
	GAME:FadeOut(false, 20)
	
	--show the guild
	local frameDur = GeneralFunctions.CalculateCameraFrames(744, 796, 720, 932, 1)
	GAME:MoveCamera(744, 796, 1, false)
	GAME:WaitFrames(40)
	GAME:FadeIn(20)
	GAME:WaitFrames(120)
	GROUND:TeleportTo(partner, 648, 1064, Direction.Up)
	GROUND:TeleportTo(hero, 648, 1096, Direction.Up)
	
	coro1= TASK:BranchCoroutine(GAME:_MoveCamera(720, 932, frameDur, false))
	coro2 = TASK:BranchCoroutine(metano_town_ch_1.WalkSequenceHero)
	local coro3 = TASK:BranchCoroutine(metano_town_ch_1.WalkSequencePartner)
	TASK:JoinCoroutines({coro1, coro2, coro3})	

	--696, 912
	
	
end