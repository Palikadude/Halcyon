require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

guild_heros_room_ch_1 = {}




function guild_heros_room_ch_1.RoomIntro()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true)
	GROUND:Hide('Bedroom_Exit')--disable map transition object
	
	local noctowl =
		CharacterEssentials.MakeCharactersFromList({
			{"Noctowl", 0, 200, Direction.Right},
		})

	GAME:MoveCamera(248, 216, 1, false)
	GROUND:TeleportTo(partner, -32, 188, Direction.Right)
	GROUND:TeleportTo(hero, -32, 212, Direction.Right)

	GAME:FadeIn(20)

	local coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(8) GROUND:MoveToPosition(partner, 160, 188, false, 1) GeneralFunctions.EmoteAndPause(partner, "Exclaim", true) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(16) GROUND:MoveToPosition(hero, 160, 212, false, 1) GeneralFunctions.EmoteAndPause(hero, "Exclaim", false) end)
	local coro3 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(noctowl, 192, 200, false, 1) GROUND:CharAnimateTurnTo(noctowl, Direction.Left, 4) end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("Wow![pause=0] Do we really get to have this room!?")
	
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(noctowl)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("That is correct.[pause=0] These will be your quarters while you train here at the guild.")
	UI:WaitShowDialogue("There is quite a bit of furnishings here already.[pause=0] You may make use of them as you will.")

	--thanks phileas!
	GAME:WaitFrames(10)
	GeneralFunctions.Hop(partner, "Idle")
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Joyous")
	GROUND:CharSetEmote(partner, 4, 0)
	GROUND:CharSetAnim(partner, "Idle", true)
	UI:WaitShowDialogue("Thank you so much " .. noctowl:GetDisplayName() .. "![pause=0] This room is amazing!")
	
	GAME:WaitFrames(10)
	GROUND:CharSetEmote(partner, -1, 0)
	GROUND:CharSetAnim(partner, "None", true)
	local bed1 = MRKR("Hero_Bed")
	local bed2 = MRKR("Partner_Bed")
	
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, bed1.Position.X, bed1.Position.Y, false, 1)
											GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(hero, partner, 4) end)
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(noctowl, partner, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	--this bed is comfy
	GeneralFunctions.Hop(partner)
	GeneralFunctions.Hop(partner)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Ooh,[pause=10] this bed is comfy![pause=0] " .. hero:GetDisplayName() .. "[pause=10], come sit on one of these!")
	
	GAME:WaitFrames(10)
	
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(hero, bed1.Position.X, bed1.Position.Y, false, 1) 
											GROUND:CharAnimateTurnTo(hero, Direction.Right, 4) end)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, bed2.Position.X, bed2.Position.Y, false, 1) 
											GROUND:CharAnimateTurnTo(partner, Direction.Left, 4) end)
	TASK:BranchCoroutine({coro1, coro2})
	
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(It may be just a pile of straws,[pause=10] but this bed is actually quite nice!)", "Normal")
	
	
	--is this what's it's like to want to wag your tail?
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(I may have lost my memory and turned into a Pokémon,[pause=10] but...)", "Normal")
	GeneralFunctions.HeroDialogue(hero, "(Joining this guild,[pause=10] getting this room,[pause=10] and meeting " .. partner:GetDisplayName() .. "...)", "Normal")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(...I can't help but feel excited.)", "Inspired")
	GeneralFunctions.HeroDialogue(hero, "(I feel like I should be scared having transformed into a Pokémon,[pause=10] but I feel happy!)", "Inspired")
	GeneralFunctions.HeroDialogue(hero, "(This is all so new to me,[pause=10] and yet I feel right at home!)", "Inspired")
	
	GAME:WaitFrames(20)

	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	GROUND:CharSetEmote(partner, 4, 0)
	UI:WaitShowDialogue("Haha,[pause=10] told you,[pause=10] didn't I?")
	GROUND:CharSetEmote(hero, 4, 0)
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:SetSpeakerEmotion("Happy")
	--GROUND:CharSetEmote(noctowl, 4, 0)
	UI:WaitShowDialogue("Ho ho ho![pause=0] I am glad that you like the room.")
	--GROUND:CharSetEmote(noctowl, -1, 0)
	
	--why not go meet your compatriots?
	GROUND:CharSetEmote(partner, -1, 0)
	GROUND:CharSetEmote(hero, -1, 0)
	GROUND:CharTurnToCharAnimated(partner, noctowl, 4)
	GROUND:CharTurnToCharAnimated(hero, noctowl, 4)
	
	GAME:WaitFrames(12)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Your training starts tomorrow.[pause=0] Make sure to get plenty of rest.")
	UI:WaitShowDialogue("Our daily routine starts bright and early!")
	
	GAME:WaitFrames(10)
	GeneralFunctions.Hop(partner)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("Aww,[pause=10] but it's not even that late yet...")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("It is true that most guild members do not sleep quite this early...")
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("Now may be a good time then for you to explore the guild and meet some of your fellow guild members.")
	GAME:WaitFrames(20)
	
	--we should go meet our guildmembers
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("That sounds like a great idea!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("I will leave you to it then.[pause=0] I am off to assist the Guildmaster in updating our records.")
	GAME:WaitFrames(20)
	
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(noctowl, 120, 200, false, 1)
											GROUND:CharAnimateTurnTo(noctowl, Direction.UpRight, 4) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(hero, noctowl, 4, Direction.DownLeft) end)
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(partner, noctowl, 4, Direction.DownLeft) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	UI:WaitShowDialogue("Oh,[pause=10] one more thing...")
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("Welcome to the Adventurer's Guild,[pause=10] Team " .. GAME:GetTeamName() .. ".")
	GROUND:MoveToPosition(noctowl, 0, 200, false, 1)
	GAME:GetCurrentGround():RemoveTempChar(noctowl)
	
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GAME:WaitFrames(12)
	
	--wow, can you believe how amazing this all is? welp, let's go explore!
	--we can hit the hay when we've felt we looked around enough
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Inspired")
	GROUND:CharSetAnim(partner, "Idle", true)
	UI:WaitShowDialogue("Can you believe this " .. hero:GetDisplayName() .. "?[pause=0] We're really going to be adventurers!")
	UI:WaitShowDialogue("This feels surreal to me.[pause=0] I never thought this would ever happen![pause=0] It's like a dream!")
	
	GAME:WaitFrames(20)
	
	GROUND:CharSetAnim(hero, "Idle", true)
	GeneralFunctions.HeroDialogue(hero, "(It is amazing how we managed to join up with the guild.)", "Normal")
	GeneralFunctions.HeroDialogue(hero, "(I'm pretty hyped about it too![pause=0] I think I'm going to have a lot of fun adventuring with " .. partner:GetDisplayName() .. "!)", "Happy")
	
	
	--let's go meet our guildmates!!
	GAME:WaitFrames(10)
	GeneralFunctions.Hop(partner)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("C'mon![pause=0] Let's go meet some of our guildmates![pause=0] We'll come back when we're ready to sleep!")
	GROUND:CharSetAnim(partner, "None", true)
	GROUND:CharSetAnim(hero, "None", true)
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(hero, Direction.DownLeft, 4) 
											GeneralFunctions.EightWayMove(hero, 0, 200, false, 2) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.DownLeft, 4) 
											GeneralFunctions.EightWayMove(partner, 0, 200, false, 2) end)
											
	TASK:JoinCoroutines({coro1, coro2})
	
	
	GAME:FadeOut(false, 20)
	GAME:CutsceneMode(false)
	SV.Chapter1.TeamJoinedGuild = true
	GAME:EnterGroundMap("guild_bedroom_hallway", "Guild_Bedroom_Hallway_Right_Marker")
	SV.partner.Spawn = 'Guild_Bedroom_Hallway_Right_Marker_Partner'
											
end



