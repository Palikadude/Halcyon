require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'

altere_pond_ch_1 = {}



function altere_pond_ch_1.PrologueGoToRelicForest()
	--Cutscene where partner enters Relic Forest after passing by the guild
	--local hero = GAME:GetPartyMember(1)--and send the hero to assembly for now
	--GAME:RemovePlayerTeam(1)
	--GAME:AddPlayerAssembly(hero)
	--COMMON.RespawnAllies()
	
	local partner = CH('Teammate1')
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone].Entries[50]
	print(partner:GetDisplayName())
	--todo: hide player
	GROUND:TeleportTo(CH('PLAYER'), 800, 0, Direction.Down)
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	GAME:MoveCamera(272, 8, 1, false)
	GROUND:TeleportTo(partner, 264, -32, Direction.Down)
	GAME:FadeIn(20)
	

	
	local coro1 = TASK:BranchCoroutine(GAME:_FadeIn(20))
	GeneralFunctions.MoveCharAndCamera(partner, 264, 112, false, 1)
	TASK:JoinCoroutines({coro1})
	
	GeneralFunctions.MoveCharAndCamera(partner, 312, 112, false, 1)
	GeneralFunctions.MoveCharAndCamera(partner, 312, 128, false, 1)
	
	UI:SetSpeaker(partner)
	GeneralFunctions.LookAround(partner, 4, 4, false, false, GeneralFunctions.RandBool(), Direction.Down)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("Sigh...")
	UI:WaitShowDialogue("I always end up going to " .. zone:GetColoredName() .. " when I'm feeling down.")
	GAME:WaitFrames(20)

	
	--walk down the steps
	GeneralFunctions.MoveCharAndCamera(partner, 312, 320, false, 1)

	
	
	--remember Relicanth is there
	local oldman = CH("Relicanth")
	GROUND:CharSetAnim(oldman, 'Idle', true)
	UI:SetSpeakerEmotion("Surprised")
	GROUND:CharSetEmote(partner, 3, 1)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
	UI:WaitShowDialogue("Oh![pause=0] I almost forgot!")
	print(oldman:GetDisplayName())

	--Move camera to show relicanth, then move back
	coro1 = TASK:BranchCoroutine(GAME:_MoveCamera(544, 328, 112, false))
	GROUND:CharTurnToCharAnimated(partner, oldman, 4)
	TASK:JoinCoroutines({coro1})
	GAME:WaitFrames(120)
	GAME:MoveCamera(320, 328, 116, false)
	
	--Remember that relicanth told you not to go in the forest
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Worried")
	SOUND:PlayBattleSE('EVT_Emote_Sweating')
	GROUND:CharSetEmote(partner, 5, 1)
	GAME:WaitFrames(40)
	UI:WaitShowDialogue("I can't let " .. oldman:GetDisplayName() .. " see me go into " .. zone:GetColoredName() .. '.')
	UI:WaitShowDialogue("Last time he caught me I got an earful about how it's dangerous...")
	UI:WaitShowDialogue("Supposedly there's some strong forces at work in there.")--foreshadow: the hero is the thing referred to here in a way. 
	
	--todo: hop twice
	GAME:WaitFrames(40)
	GROUND:CharSetEmote(partner, 6, 1)
	SOUND:PlayBattleSE("EVT_Emote_Confused")
	GAME:WaitFrames(40)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("But I've been there plenty of times and nothing bad's ever happened.")


	--Remember that you don't give a shit what relicanth has to say
	UI:SetSpeakerEmotion("Normal")
	GAME:WaitFrames(20)
	--TODO:make him do a little jump
	UI:WaitShowDialogue("That old coot is always overexaggerating...[br] Something like that would never be right next to town.")
	GROUND:CharAnimateTurn(partner, Direction.Down, 4, false)
	GeneralFunctions.LookAround(partner, 3, 4, true, false, GeneralFunctions.RandBool(), Direction.Down)
	UI:WaitShowDialogue("I am going to need to sneak around though.[pause=0] I don't want " .. oldman:GetDisplayName() .. " seeing me.")
	
	
	--sneak off towards the treeline, fade to black
	GROUND:CharAnimateTurn(partner, Direction.DownLeft, 4, false)
	GAME:WaitFrames(16)
	UI:WaitShowDialogue("I'll have to stick to the trees as usual.")

	coro1 = TASK:BranchCoroutine(GROUND:_MoveToPosition(partner, 224, 400, false, 1))
	GAME:WaitFrames(40)
	GAME:FadeOut(false, 20)
	TASK:JoinCoroutines({coro1})	
	
	GAME:WaitFrames(60)
	
	
	--Fade back in by the entrance to the forest
	GAME:MoveCamera(840, 312, 1, false)
	GROUND:TeleportTo(partner, 840, 432, Direction.Up)
	GAME:FadeIn(60)
	GROUND:MoveToPosition(partner, 840, 336, false, 1)
	
	--look all around
	GeneralFunctions.LookAround(partner, 5, 4, true, false, GeneralFunctions.RandBool(), Direction.Left)
	UI:WaitShowDialogue("Looks like he didn't notice.[pause=0] Now I won't have to hear him later...")
	GROUND:CharAnimateTurn(partner, Direction.UpRight, 4, false)
	

	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("Sigh...")


	GROUND:MoveToPosition(partner, 880, 336, false, 1)
	coro1 = TASK:BranchCoroutine(GROUND:_MoveToPosition(partner, 920, 296, false, 1))
	GAME:FadeOut(false, 20)
	TASK:JoinCoroutines({coro1})	
	
	SV.Chapter1.PartnerEnteredForest = true
	--todo: change party data so its partner alone, enter dungeon
	SV.Chapter1.PartnerCompletedForest = true
	
	
	GAME:FadeOut(false, 20)
	GAME:CutsceneMode(false)
	GAME:EnterGroundMap("relic_forest", "Main_Entrance_Marker")
	
	
	
end


--play this cutscene if you wiped in the forest as just the partner
function altere_pond_ch_1.WipedInForest()
	local partner = CH('Teammate1')	
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone].Entries[50]
	--todo: hide player
	GROUND:TeleportTo(CH('PLAYER'), 800, 0, Direction.Down)
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	GAME:MoveCamera(840, 312, 1, false)
	GROUND:TeleportTo(partner, 840, 336, Direction.Right)
	GROUND:CharSetAnim(partner, 'EventSleep', true)
	GAME:FadeIn(20)
	
	--wake up and look around
	GAME:WaitFrames(120)
	GROUND:CharSetAnim(partner, 'Wake', false)
	GAME:WaitFrames(40)
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
	GAME:WaitFrames(20)
	GeneralFunctions.LookAround(partner, 2, 4, false, false, false, Direction.Down)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion('Pain')
	GeneralFunctions.EmoteAndPause(partner, 'Sweating', true)
	
	UI:WaitShowDialogue('Ugh... That was rough.')
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4)
	
	UI:SetSpeakerEmotion('Normal')
	UI:WaitShowDialogue('I got knocked out,[pause=10] so the dungeon spat me back at the entrance...')
	UI:SetSpeakerEmotion('Pain')
	UI:WaitShowDialogue('Exploring ' .. zone:GetColoredName() .. ' can be difficult sometimes.')
	
	GAME:WaitFrames(40)
	GeneralFunctions.ShakeHead(partner, 4)
	UI:SetSpeakerEmotion('Normal')
	UI:WaitShowDialogue("Alright.[pause=0] I think I'm ready to give it another go.")
	UI:WaitShowDialogue("I'll make it through this time for sure!")
	
	--todo: enter dungeon code
	GROUND:MoveToPosition(partner, 880, 336, false, 1)
	coro1 = TASK:BranchCoroutine(GROUND:_MoveToPosition(partner, 936, 280, false, 1))
	GAME:FadeOut(false, 20)
	TASK:JoinCoroutines({coro1})	
end 
	
	
	


function altere_pond_ch_1.PartnerHeroReturn()
	--they made it back through the forest. it's evening now 
	--todo: create map effect for evening shading
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	--todo: hide player
	GROUND:TeleportTo(CH('PLAYER'), 800, 0, Direction.Down)
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	GAME:MoveCamera(840, 312, 1, false)
	GROUND:TeleportTo(partner, 936, 280, Direction.Right)
	GROUND:TeleportTo(hero, 968, 248, Direction.Right)
	GAME:FadeIn(20)
	
	--move into frame then look around 
	local coro1 = TASK:BranchCoroutine(GROUND:_MoveToPosition(partner, 792, 344, false, 1))
	GROUND:MoveToPosition(hero, 824, 344, false, 1)
	TASK:JoinCoroutines({coro1})	
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.LookAround(partner, 3, 4, true, false, false, Direction.Right) end)
	GeneralFunctions.LookAround(hero, 3, 4, true, false, false, Direction.Left)	
	TASK:JoinCoroutines({coro1})	

	--foreshadowing :v) hero has done this shit before in a past life (pmd1, 2, etc)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Looks like we made it out of the forest.")
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("For someone who claims to be a human,[pause=10] you were pretty impressive in that dungeon,[pause=10] " .. hero:GetDisplayName() .. ".")
	UI:SetSpeakerEmotion("Happy")
	UI:CharSetEmote(partner, 1, 0)
	UI:WaitShowDialogue("If I didn't know any better,[pause=10] I'd say you've done this before,[pause=10] hehe!")
	GAME:WaitFrames(20)
	UI:CharSetEmote(partner, -1, 0)
	
	GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
	GAME:WaitFrames(40)
	GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
	
	UI:WaitShowDialogue("This isn't really the place to talk...[pause=0] Follow me please.")






	--gush about how cool it is to be an adventurer
	GROUND:CharAnimateTurnTo(partner, Direction.UpLeft, 4)
	UI:WaitFrames(30)
	UI:WaitShowDialogue("Being an adventurer would be the best...")
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("Exploring lands untouched by civilization with hidden treasures...")
	UI:WaitShowDialogue("Helping Pokémon in need and bringing outlaws to justice...")
	UI:WaitShowDialogue("Meeting Pokémon from around the world and forging friendships with compatriots...")
	
	UI:CharAnimateTurnTo(partner, Direction.Left, 4)
	
	UI:WaitShowDialogue("It's what I've always dreamed about![pause=0] Don't you think it's exciting too?")
	
	GeneralFunctions.HeroDialogue(hero, "(That does sound pretty cool,[pause=10] actually.[pause=0] Being an adventurer sounds like a lot of fun.)", "Inspired")
	GeneralFunctions.HeroDialogue(hero, "(But...[pause=0] )", "Inspired")

end