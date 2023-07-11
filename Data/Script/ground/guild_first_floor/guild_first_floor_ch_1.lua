require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

guild_first_floor_ch_1 = {}

function guild_first_floor_ch_1.EnterGuild()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	--swap the partner and hero's spawn points, as the partner is leading in this instance
	local leftPos = hero.Position
	local rightPos = partner.Position
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	GAME:MoveCamera(160, 160, 1, false)
	GROUND:TeleportTo(partner, leftPos.X, leftPos.Y, Direction.Up)
	GROUND:TeleportTo(hero, rightPos.X, rightPos.Y, Direction.Up)
	GAME:FadeIn(40)
	
	--wow we're inside a tree!
	GAME:WaitFrames(20)
	GeneralFunctions.Recoil(hero)
	GROUND:CharSetEmote(hero, "shock", 1)	
	GeneralFunctions.HeroDialogue(hero, "(Wow![pause=0] The guild is all inside a tree!?)", "Surprised")
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Normal")
	--UI:WaitShowDialogue("My jaw dropped the first time I came inside the guild too!")
	UI:WaitShowDialogue("It's incredible that an entire guild was built inside a tree,[pause=10] isn't it?")
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GAME:WaitFrames(12)
	UI:WaitShowDialogue("This tree has been here as long as anyone can remember...[br]...But the guild itself was built a little after I hatched.")
	
	--how old does that make the partner then?
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(How old does that make " .. partner:GetDisplayName() .. " then?)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(...How old am I in this form for that matter?)", "Worried")
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("I'll have to tell you more about the town and its history later!")
	GROUND:CharAnimateTurnTo(partner, Direction.UpLeft, 4)
	GAME:WaitFrames(40)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	UI:WaitShowDialogue("But for now,[pause=10] we shouldn't keep " .. CharacterEssentials.GetCharacterName("Noctowl") .. " waiting.")
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("There's more things to see on the upper levels anyway![pause=0] C'mon!")

	--walk towards the stairs but remember to tell hero not to blab about being human
	GAME:WaitFrames(20)
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 88, 152, false, 1) 
												  GROUND:MoveToPosition(partner, 88, 112, false, 1)	
												  GROUND:CharSetEmote(partner, "exclaim", 1)
												  SOUND:PlayBattleSE("EVT_Emote_Exclaim_2") end)
	GeneralFunctions.WaitThenMove(hero, 136, 200, false, 1, 10)
	GROUND:MoveToPosition(hero, 120, 184, false, 1)
	GeneralFunctions.EightWayMove(hero, 88, 144, false, 1)
	TASK:JoinCoroutines({coro1})	
	
	UI:SetSpeakerEmotion("Surprised")
	GAME:WaitFrames(10)
	GROUND:CharSetEmote(hero, "exclaim", 1)
	UI:WaitShowDialogue("Oh![pause=0] Wait a sec!")
	
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	
	--dont tell anyone 
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("One more thing before we go up.")
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("I know all of this might be overwhelming and sudden given your amnesia...[pause=0] But...")
	UI:WaitShowDialogue("We shouldn't tell anyone that you were a human or that you lost your memory.")
	UI:WaitShowDialogue("I believe you that you were a human at one point...")
	UI:WaitShowDialogue("But I don't think anyone else will.[pause=0] They'll just think we're crazy!")
	UI:WaitShowDialogue("And if that happens,[pause=10] we don't have a chance of being accepted to train here.")
	UI:WaitShowDialogue("So please,[pause=10] let's just keep it to ourselves for now...[pause=0] OK?")
	
	-- :(
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(.........)", "Sad")
	GAME:WaitFrames(20)
	GeneralFunctions.DoAnimation(hero, "Nod")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("I'm sorry that we need to keep it a secret.")
	UI:WaitShowDialogue("I promise we'll get to the bottom of your amnesia someday.")
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4)
	GAME:WaitFrames(40)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Alright,[pause=10] let's not keep " .. CharacterEssentials.GetCharacterName("Noctowl") .. " waiting any longer.")
	GAME:WaitFrames(20)
	
	--walk away, then walk away again while fading out
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, 88, 104, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(hero, 88, 136, false, 1) end)
	TASK:JoinCoroutines({coro1, coro2})	

	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, 128, 64, false, 1) end)
	coro2 = TASK:BranchCoroutine(function() GAME:FadeOut(false, 40) end)
	local coro3 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 88, 104, false, 1)
												  GROUND:MoveToPosition(hero, 92, 100, false, 1) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})	

	GAME:CutsceneMode(false)
	GAME:EnterGroundMap("guild_second_floor", "Main_Entrance_Marker")

	
end