require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

guild_third_floor_lobby_ch_1 = {}

function guild_third_floor_lobby_ch_1.SetupGround()
	local door = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Closed_Guild_Door", 1, 0, 0), 
													RogueElements.Rect(424, 160, 48, 64),
													RogueElements.Loc(8, -8), 
													false, 
													"Event_Object_1")
	door:ReloadEvents()
	GAME:GetCurrentGround():AddTempObject(door)
	
	GROUND:Hide('Door_Exit')
	GAME:FadeIn(20)	
end

function guild_third_floor_lobby_ch_1.Event_Object_1_Action(obj, activator)
	local hero = CH('PLAYER')
    local partner = CH('Teammate1')
	partner.IsInteracting = true
    GROUND:CharSetAnim(partner, 'None', true)
    GROUND:CharSetAnim(hero, 'None', true)
	
	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue("(The door is locked.)")
	UI:SetCenter(false)
	
	partner.IsInteracting = false	
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
end


--TASK:BranchCoroutine(guild_third_floor_lobby_ch_1.GoToGuildmasterRoom)
--follow noctowl to guildmaster's room
function guild_third_floor_lobby_ch_1.GoToGuildmasterRoom()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	GAME:MoveCamera(600, 240, 1, false)
	
	
	local door = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Closed_Guild_Door", 1, 0, 0), 
													RogueElements.Rect(416, 160, 64, 64),
													RogueElements.Loc(0, -8), 
													false, 
													"Closed_Door")
	door:ReloadEvents()
	GAME:GetCurrentGround():AddTempObject(door)
		
	local noctowl = 
		CharacterEssentials.MakeCharactersFromList({
			{"Noctowl", 600, 240, Direction.Up}
		})
	
	
	GAME:FadeIn(40)
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("This is the top level of the guild.[pause=0] This is where guild members work and live.")
	UI:WaitShowDialogue("The Guildmaster's office is just over here.[pause=0] Please come with me.")
	
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(noctowl, Direction.Left, 4)
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(noctowl, 440, 240, false, 1) 
												  GROUND:CharAnimateTurnTo(noctowl, Direction.Right, 4) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(15)
												  GROUND:MoveToPosition(partner, 584, 240, false, 1)
												  GeneralFunctions.EightWayMove(partner, 472, 240, false, 1) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(15)
												  GROUND:EntTurn(hero, Direction.DownLeft)
												  GAME:WaitFrames(32)
												  GeneralFunctions.EightWayMove(hero, 512, 240, false, 1)
												  GeneralFunctions.EightWayMove(hero, 472, 272, false, 1)
												  GROUND:CharTurnToChar(hero, noctowl) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:MoveCamera(466, 240, 136, false)	end)							
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	--wait there please.
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("Please wait here.[pause=0] I am going to notify the Guildmaster of your arrival.")
	
	--[[GeneralFunctions.DoubleHop(partner, 'None', 6, 6)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("OK![pause=0] We'll wait right here!")
	GAME:WaitFrames(20)

	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("Very good.[pause=0] I shall return momentarily.")
	]]--
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(noctowl, Direction.Up, 4)

	
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(noctowl, Direction.Up, 16, false, 1)
											end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(hero, noctowl) end)
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(partner, noctowl) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	--open and close the door
	GROUND:Hide(door.EntName)
	SOUND:PlayBattleSE('EVT_Chest_Click')
	GAME:WaitFrames(40)
	GROUND:MoveInDirection(noctowl, Direction.Up, 8, false, 1)
	GROUND:Hide(noctowl.EntName) 
	GAME:WaitFrames(20)
	GROUND:Unhide(door.EntName)
	SOUND:PlayBattleSE('EVT_Chest_Click')

	
	GAME:WaitFrames(60)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GeneralFunctions.DoubleHop(partner)
	
	--omg im so excited but also so scared
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Inspired")
	GROUND:CharSetAnim(partner, "Idle", true)
	GROUND:CharSetEmote(partner, "happy", 0)
	UI:WaitShowDialogue("Wow![pause=0] I can't believe we're about to meet the Guildmaster!")
	UI:WaitShowDialogue("The first time I came here I only met with " .. noctowl:GetDisplayName() .. ".[pause=0] I didn't get to see the Guildmaster!")
	UI:WaitShowDialogue("He's a world famous adventurer![pause=0] And we're going to meet him!")
	UI:WaitShowDialogue("I knew we'd have to see him eventually...[pause=0] But I'm still starstruck![script=0]", {function() return GeneralFunctions.Hop(partner) end})

--[[ I think it's too early for serious emotional support between these two but im not deleting all this scripting
	UI:WaitShowDialogue("I don't know if I should be estatic or if I should be panicking!")
	UI:WaitShowDialogue("I think I'm doing both!?[pause=0] And I think my face is stuck!?")
	
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(It must be hard for " .. partner:GetDisplayName() .. " to relax in a situation like this...)", "Normal")
	GeneralFunctions.HeroDialogue(hero, "(But if " .. GeneralFunctions.GetPronoun(partner, "they") .. " doesn't calm down,[pause=10] I don't think we have a shot at joining here.)", "Normal")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroSpeak(hero, 60)
	GAME:WaitFrames(20)
	
	--calm down partner!!
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("You're right,[pause=10] you're right...[pause=0] But I'm all wound up!")
	UI:WaitShowDialogue("This is the moment I've been waiting my whole life for![pause=0] It's got me all fidgety!")
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("I'm not sure I can turn it off,[pause=10] but I can try...")
	GAME:WaitFrames(20)
	GROUND:CharSetAnim(partner, "None", true)
	GROUND:CharSetEmote(partner, "", 0)
	
	UI:SetSpeakerEmotion("Sigh")
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue("In...[pause=40] Out...[pause=40] In...[pause=40] Out...", 40) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(partner, 'DeepBreath')
											GeneralFunctions.DoAnimation(partner, 'DeepBreath') end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(20)
	--todo: two hops
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("Well,[pause=10] my face isn't stuck anymore,[pause=10] but I still feel tingly with anticipation...")
	GROUND:CharSetEmote(partner, "sweating", 1)
	UI:WaitShowDialogue("Do we really have what it takes?[pause=0] Do I really have what it takes?")
	UI:WaitShowDialogue("And what if we're rejected?[pause=0] I don't know if I could handle that...")
	
	--the partner is great he just needs to believe in himself :3
	--ty hero for the peptalk
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(It's hard for me to fully understand how " .. partner:GetDisplayName() .. " is feeling right now...)", "Sad")
	GeneralFunctions.HeroDialogue(hero, "(Truthfully,[pause=10] I hardly know " .. GeneralFunctions.GetPronoun(partner, "them") .. ".)", "Sad")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(But what I do understand is that this apprenticeship means more than anything in the world to "  .. GeneralFunctions.GetPronoun(partner, "them") .. ".)", "Determined")
	GeneralFunctions.HeroDialogue(hero, "(In the short time that I've been with " .. GeneralFunctions.GetPronoun(partner, "them") .. ",[pause=10] he rescued me and promised to help get to the bottom of my amnesia.)", "Determined")
	GeneralFunctions.HeroDialogue(hero, "(If that isn't the making of a great adventurer,[pause=10] then I don't know what is!)", "Determined")
	GeneralFunctions.HeroDialogue(hero, "(" .. GeneralFunctions.GetPronoun(partner, "they", true) .. " just needs to realize that and have a little more confidence![pause=0] Then I'm sure we can do it!)", "Determined")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroSpeak(hero, 60)
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(partner, "Exclaim", true)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Yeah![pause=0] You're right!")
	--todo two hops
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("I shouldn't have so much doubt in us![pause=0] I think we can really do it now!")
	UI:WaitShowDialogue("I'm still a little nervous but...[pause=0] I don't feel as anxious anymore.")
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("I really needed to hear those words.[pause=0] Thank you,[pause=10] " ..  hero:GetDisplayName() .. ".")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(I'm glad I was able to get through to " .. GeneralFunctions.GetPronoun(partner, "them") .. "!)", "Happy")
]]--	
	
	--GeneralFunctions.HeroDialogue(hero, "(" .. partner:GetDisplayName() .. " seems to be more at ease now.[pause=0] Perhaps some of " .. GeneralFunctions.GetPronoun(partner, "their") .. " anxiety has melted away...)", "Normal")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(I don't know much about this Guildmaster...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(But " .. partner:GetDisplayName() .. " seems to have a high opinion of him.[pause=0] I'm interested to see what he's actually like.)", "Normal")
	GAME:WaitFrames(20)
	
	GROUND:CharSetEmote(partner, "", 0)
	GROUND:CharSetAnim(partner, "None", true)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("I'm excited to meet the Guildmaster,[pause=10] but...")
	GROUND:CharSetEmote(partner, "sweating", 1)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("I'm also kinda intimidated.[pause=0] I've got butterflies in my stomach again...")
	UI:WaitShowDialogue("I feel so uneasy about this...[pause=0] Do you really think they'll let us join,[pause=10] " .. hero:GetDisplayName() .. "?")
	GAME:WaitFrames(20)
	
	GeneralFunctions.HeroDialogue(hero, "(Truthfully,[pause=10] I don't know what's gonna happen once we step through that door...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(But given my amnesia and " .. partner:GetDisplayName() .. "'s nerves,[pause=10] our odds don't seem too great to me...)", "Worried")
	GAME:WaitFrames(20)
	
	GeneralFunctions.HeroDialogue(hero, "(Even so...[pause=0] I have this strong feeling that everything's going to work out.)", "Normal")
	GeneralFunctions.HeroDialogue(hero, "(This feeling...[pause=0] It makes me certain we'll join the guild!)", "Normal")
	GAME:WaitFrames(20)
	
	GeneralFunctions.HeroSpeak(hero, 60)
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("You really think so?")
	GAME:WaitFrames(20)
	
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("I still feel a little apprehensive...[pause=0] But if you have confidence,[pause=10] then I should too!")
	UI:WaitShowDialogue("As long as I do my best to keep my nerves in check,[pause=10] I'm sure we'll do fine!")
	GAME:WaitFrames(60)
	
	GROUND:Hide(door.EntName)
	SOUND:PlayBattleSE('EVT_Chest_Click')
	--noctowl returns
	--in general, when both the hero and partner are emoting at the same time to the same event, the hero should have a less extreme reaction
	--notice hero vs exclaim partner in this example
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(40)
											GROUND:EntTurn(noctowl, Direction.Down)
											GROUND:Unhide(noctowl.EntName)
											GROUND:MoveInDirection(noctowl, Direction.Down, 24, false, 1)
											GROUND:CharAnimateTurnTo(noctowl, Direction.Right, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharSetEmote(hero, "notice", 1)
											GROUND:CharTurnToCharAnimated(hero, noctowl, 4)
											GAME:WaitFrames(30)
											--SOUND:PlayBattleSE('EVT_Emote_Exclaim')
											GeneralFunctions.FaceMovingCharacter(hero, noctowl) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharSetAnim(partner, "None", true)
											GROUND:CharSetEmote(partner, "exclaim", 1)
											GROUND:CharTurnToCharAnimated(partner, noctowl, 4)
											GAME:WaitFrames(20)
											GeneralFunctions.FaceMovingCharacter(partner, noctowl) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("I apologize for the delay.[pause=0] I had some matters to discuss with the Guildmaster.")
	UI:WaitShowDialogue("He is ready to see the two of you.[pause=0] Please come with me into his quarters.")
	
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(noctowl, Direction.Up, 4)
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(noctowl, Direction.Up, 24, false, 1)
											GROUND:Hide(noctowl.EntName) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(hero, noctowl) end)
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(partner, noctowl) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	GAME:WaitFrames(40)
	
	--let's do it!
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GAME:WaitFrames(20)
	
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(hero, 'Nod') end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(partner, 'Nod') end)
	TASK:JoinCoroutines({coro1, coro2})	
	GAME:WaitFrames(20)
	
	GROUND:MoveToPosition(partner, 440, 240, false, 1)
	
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(hero, 440, 216, false, 1) GROUND:Hide(hero.EntName) end)
	coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 440, 216, false, 1) GROUND:Hide(partner.EntName) end)
	
	TASK:JoinCoroutines({coro1, coro2})
	GAME:FadeOut(false, 40)
	GAME:CutsceneMode(false)
	GAME:EnterGroundMap("guild_guildmasters_room", "Main_Entrance_Marker")

end