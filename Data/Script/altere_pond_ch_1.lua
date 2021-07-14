require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'

altere_pond_ch_1 = {}



function altere_pond_ch_1.PrologueGoToRelicForest()
	--Cutscene where partner enters Relic Forest after chickening out at the guild
	--TODO: Figure out how to make the partner's name yellow during this section
	--GAME:SetTeamLeaderIndex(1)--temporarily make the partner the leader for this cutscene, as we're going to control them
	--local hero = GAME:GetPartyMember(1)--and send the hero to assembly for now
	--GAME:RemovePlayerTeam(1)
	--GAME:AddPlayerAssembly(hero)
	--COMMON.RespawnAllies()
	
	local partner = CH('Teammate1')
	local zone = RogueEssence.Data.DataManager.Instance.DataIndices[RogueEssence.Data.DataManager.DataType.Zone].Entries[50]
	print(partner:GetDisplayName())
	--todo: hide player
	GROUND:TeleportTo(CH('PLAYER'), 800, 0, Direction.Down)
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	GAME:MoveCamera(272, 8, 1, false)
	GROUND:TeleportTo(partner, 264, 0, Direction.Down)
	GAME:FadeIn(20)
	

	
	local coro1 = TASK:BranchCoroutine(GAME:_FadeIn(20))
	GeneralFunctions.MoveCharAndCamera(partner, 264, 112, 1)
	TASK:JoinCoroutines({coro1})
	
	GeneralFunctions.MoveCharAndCamera(partner, 312, 112, 1)
	GeneralFunctions.MoveCharAndCamera(partner, 312, 128, 1)
	
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("The path to " .. zone:GetColoredName() .. " should be by the pond.[pause=0] But where exactly?")
	
	--look around, realize that the entrance is to the right of the pond itself
	GeneralFunctions.LookAround(partner, 4, 4, false, false, GeneralFunctions.RandBool(), Direction.Down)
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurn(partner, Direction.DownRight, 4, true)
	
	SOUND:PlayBattleSE('EVT_Emote_Exclaim')
	GROUND:CharSetEmote(partner, 2, 1)
	GAME:WaitFrames(20)
	
	--Move camera to entrance
	GAME:FadeOut(false, 30)
	GAME:MoveCamera(808, 304, 1, false)
	GAME:WaitFrames(20)
	GAME:FadeIn(30)
	
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("Oh![pause=0] I bet that's it over there!")
	UI:SetSpeakerEmotion("Normal")
	
	GAME:FadeOut(false, 30)
	GAME:MoveCamera(partner.Position.X+8, partner.Position.Y+8, 1, false)
	GAME:WaitFrames(20)
	GAME:FadeIn(30)
	
	
	
	UI:SetSpeakerEmotion("Happy")
	SOUND:PlayBattleSE("EVT_Emote_Startled_2")
	--UI:WaitFrames(20)
	--todo: have him to a little jump
	GROUND:CharSetEmote(partner, 4, 0)
	UI:WaitShowDialogue("Perfect![pause=0] Maybe this will be easier than I thought!")
	GROUND:CharSetEmote(partner, -1, 0)

	
	--walk down the steps
	GeneralFunctions.MoveCharAndCamera(partner, 312, 320, 1)

	
	
	--remember Relicanth is there
	local oldman = CH("Relicanth")
	GROUND:CharSetAnim(oldman, 'Idle', true)
	UI:SetSpeakerEmotion("Surprised")
	GROUND:CharSetEmote(partner, 3, 1)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
	UI:WaitShowDialogue("Wait![pause=0] I almost forgot!")
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
	UI:WaitShowDialogue(oldman:GetDisplayName() .. " forbids anyone from entering " .. zone:GetColoredName() .. "...")
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("He says that deep within,[pause=10] there's supposed to be something...")
	GAME:WaitFrames(40)
	GROUND:CharSetEmote(partner, 6, 1)
	SOUND:PlayBattleSE("EVT_Emote_Confused")
	GAME:WaitFrames(40)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Uhh...[pause=0] Important?[pause=0] Powerful?[pause=0] Dangerous?[pause=0] I can't really recall.")


	--Remember that you don't give a shit what relicanth has to say
	UI:SetSpeakerEmotion("Normal")
	--UI:WaitFrames(20)
	--TODO:make him do a little jump
	UI:WaitShowDialogue("I'm sure he overexaggerated.[pause=0] There's no way something that crazy is this close to town.")
	GROUND:CharAnimateTurn(partner, Direction.Down, 4, false)
	GeneralFunctions.LookAround(partner, 3, 4, true, false, GeneralFunctions.RandBool(), Direction.Down)
	UI:WaitShowDialogue("I am going to need to sneak around though.[pause=0] I don't want " .. oldman:GetDisplayName() .. " seeing me.")
	
	
	--sneak off towards the treeline, fade to black
	GROUND:CharAnimateTurn(partner, Direction.DownLeft, 4, false)
	GAME:WaitFrames(16)
	UI:WaitShowDialogue("Sticking to the trees is probably my best bet.[pause=0] He probably won't see me there.")

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
	UI:WaitShowDialogue("Looks like he didn't notice.[pause=0] At least now he won't talk my ear off later...")
	GROUND:CharAnimateTurn(partner, Direction.UpRight, 4, false)
	
	--turn towards dungeon, muster your courage!
	UI:WaitShowDialogue("This must be the entrance.")
	GAME:WaitFrames(30)
	SOUND:PlayBattleSE('EVT_Emote_Sweating')
	GROUND:CharSetEmote(partner, 5, 1)
	GAME:WaitFrames(40)
	UI:SetSpeakerEmotion("Stunned")
	UI:WaitShowDialogue("Urk...[pause=0] Scary...")
	GeneralFunctions.ShakeHead(partner, 4)

	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Determined")
	--todo: do a little hop
	UI:WaitShowDialogue("No![pause=0] I may have chickened out at the guild,[pause=10] but not this time!")
	UI:WaitShowDialogue("If I can get through here,[pause=10] I know I can get into the guild!")
	UI:WaitShowDialogue("I can do this!")
	
	coro1 = TASK:BranchCoroutine(GROUND:_MoveToPosition(partner, 920, 256, false, 1))
	GAME:WaitFrames(40)
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

end 

function altere_pond_ch_1.PartnerHeroReturn()
	--partner takes pity on hero since they have nowhere to go, and wanting to help pokemon like a true adventurer, offers a teamup

--hero is wondering why partner was there
	GeneralFunctions.HeroSpeak(hero, 30)
	
	--why is the partner here then?
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Why am I here?[pause=0] I've been trying to join the Adventurer's Guild.")
	UI:WaitShowDialogue("The guild is well-known for its great adventurers.")
	UI:WaitShowDialogue("I want to apprentice there so that I can learn how to be a great adventurer too.")
	UI:WaitShowDialogue("I went there today to try to join but...")
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("I chicken out anytime I get close to the guild.")
	UI:WaitShowDialogue("It's happened more times than I'd like to admit.")
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("I figured if I could make it through a mystery dungeon it would give me the confidence I need.")
	
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