require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_town_ch_1 = {}


--partner passes by guild with a sad expression
--Team Style sees him and talk about how they're so great and gonna join the guild
--partner walks away wistfully
function metano_town_ch_1.PartnerLongingCutscene()
	--Cutscene where partner looks longingly at the guild, then walks away
	local partner = CH('Teammate1')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	GAME:MoveCamera(648, 1216, 1, false)
	GROUND:TeleportTo(partner, 840, 1232, Direction.Left)
	--GROUND:Unhide("Growlithe")
	GROUND:Hide("Green_Merchant")
	GROUND:Hide("Red_Merchant")
	
	--[[local luxio, glameow, cacnea = 
		CharacterEssentials.MakeCharactersFromList({
			{'Luxio', 440, 1208, Direction.Right},
			{'Glameow', 416, 1192, Direction.Right},
			{'Cacnea', 416, 1224, Direction.Right}
		})
	]]--
	GAME:FadeIn(40)

	

	--walk from offscreen to under the bridge
	GROUND:MoveToPosition(partner, 704, 1232, false, 1)
	GROUND:MoveToPosition(partner, 680, 1208, false, 1)
	GROUND:MoveToPosition(partner, 640, 1208, false, 1)
	GAME:WaitFrames(20)
	--they turn towards the guild and pause
	GROUND:CharAnimateTurn(partner, Direction.Up, 4, false)
	GAME:WaitFrames(60)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("...")
	GAME:WaitFrames(60)

--[[		
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	UI:WaitShowDialogue("Hey,[pause=10] you there!")
	GeneralFunctions.EmoteAndPause(partner, "Exclaim", true)
	
	
	local coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Left, 4) end)
	local coro2 = TASK:BranchCoroutine(function() GeneralFunctions.CenterCamera({partner, luxio}, 648, 1208, 2) end)
	
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(60)
	
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(luxio, Direction.Right, 160, false, 1) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:MoveInDirection(glameow, Direction.Right, 160, false, 1) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(12)
												  GROUND:MoveInDirection(cacnea, Direction.Right, 160, false, 1) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:MoveCamera(628, 1216, 80, false) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	GAME:WaitFrames(20)
	GeneralFunctions.LookAround(partner, 2, 4, false, true, true, Direction.Left)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Who,[pause=10] me?")
	GAME:WaitFrames(20)


--tone should be condescending and smug, but not necessarily mean
	UI:SetSpeaker(luxio)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Yeah.[pause=0] Do you know where the adventurer's guild is?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("The adventurer's guild?")
	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	GAME:WaitFrames(12)
	
	UI:WaitShowDialogue("It's just across this bridge here.")
	GROUND:CharTurnToCharAnimated(partner, luxio, 4)
	GAME:WaitFrames(12)
	
	UI:SetSpeaker(luxio)
	UI:WaitShowDialogue("Oh,[pause=10] we're a lot closer than I thought we were.[pause=0] Thanks.")
	GROUND:CharAnimateTurnTo(luxio, Direction.Left, 4)
	UI:WaitShowDialogue("Let's get a move on team.")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(glameow)
	UI:WaitShowDialogue("Of course,[pause=10] darling.")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(cacnea)
	UI:WaitShowDialogue("Uhhh,[pause=10] OK boss.")
		--they walk a bit closer
		
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("H-hey![pause=0] Hold up a second!")
	GAME:WaitFrames(20)
	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(luxio, partner, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharTurnToCharAnimated(glameow, partner, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(12)
											GROUND:CharTurnToCharAnimated(cacnea, partner, 4) end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	UI:SetSpeaker(luxio)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Hmm?[pause=0] What's up?[pause=0] Something you wanna say?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(
	
	]]--
	
	
	
	
	GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)

	
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 444, 1208, false, 1) end)
	GAME:WaitFrames(186)
	SOUND:FadeOutBGM()
	GAME:FadeOut(false, 40)
	TASK:JoinCoroutines({coro1})	
	
		
	GAME:CutsceneMode(false)
	GAME:EnterGroundMap("altere_pond", "Main_Entrance_Marker")

end

--enter guild cutscene, partner runs in leaving you in the dust
function metano_town_ch_1.RunSequencePartner()
	GROUND:MoveToPosition(CH('Teammate1'), 648, 1200, false, 3)
	GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Left, 4)
end

--walking up to growlithe.
function metano_town_ch_1.WalkSequenceHero()
	GROUND:MoveToPosition(CH('PLAYER'), 648, 1032, false, 1)
	GeneralFunctions.EightWayMove(CH('PLAYER'), 696, 986, false, 1)
	GROUND:MoveToPosition(CH('PLAYER'), 696, 948, false, 1)
	GROUND:CharTurnToCharAnimated(CH('PLAYER'), CH('Growlithe'), 4)
end

--walking up to growlithe
function metano_town_ch_1.WalkSequencePartner()
	GROUND:MoveToPosition(CH('Teammate1'), 648, 1032, false, 1)
	GeneralFunctions.EightWayMove(CH('Teammate1'), 696, 986, false, 1)
	GROUND:MoveToPosition(CH('Teammate1'), 696, 924, false, 1)
	GROUND:CharTurnToCharAnimated(CH('Teammate1'), CH('Growlithe'), 4)
end

--growlithe turning as you walk towards him, with him getting excited
function metano_town_ch_1.GrowlitheSequence()
	GAME:WaitFrames(20)
	local chara = CH('Growlithe')
	GROUND:CharSetEmote(chara, "notice", 1)
	GROUND:CharSetAnim(chara, 'Idle', true)
	GROUND:CharAnimateTurnTo(chara, Direction.Down, 4)
	GAME:WaitFrames(40)
	GROUND:CharAnimateTurnTo(chara, Direction.DownRight, 4)
end 

--growlithe leaving his post to go inside the guild
function metano_town_ch_1.GrowlitheRunInside()
	local chara = CH('Growlithe')
	SOUND:PlayBattleSE('_UNK_EVT_010')--jump sfx. Maybe find a better one if possible?
	GROUND:AnimateToPosition(chara, 'Rumble', Direction.Right, 694, 924, 1, 2, 0)
	GROUND:MoveToPosition(chara, 712, 924, true, 4)
	GROUND:MoveToPosition(chara, 712, 876, true, 4)
	GROUND:Hide('Growlithe')	
end

function metano_town_ch_1.PartnerPushedBack()
	local chara = CH('Teammate1')
	GROUND:CharSetEmote(chara, "shock", 1)
	GROUND:AnimateToPosition(chara, 'Hurt', Direction.Down, 696, 900, 1, 3, 0)
	GROUND:CharEndAnim(chara)
	GAME:WaitFrames(6)
	--GROUND:EntTurn(chara, Direction.Down)
	--GAME:WaitFrames(12)
	--GROUND:CharAnimateTurnTo(chara, Direction.Right, 4)
	--GAME:WaitFrames(12)
	--GROUND:CharAnimateTurnTo(chara, Direction.UpRight, 4)
	GeneralFunctions.FaceMovingCharacter(chara, CH('Growlithe'))
end

function metano_town_ch_1.HeroPushedBack()
	local chara = CH('PLAYER')
	GROUND:CharSetEmote(chara, "shock", 1)
	GROUND:CharAnimateTurnTo(chara, Direction.Up, 4)
end 
--hero and partner enter the guild
function metano_town_ch_1.EnterGuild()
	--center of guild: 744, 796
	
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local growlithe = CH('Growlithe')
	GROUND:AddMapStatus("dusk")--dusk
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	GROUND:Hide("Green_Merchant")--hide merchants 
	GROUND:Hide("Red_Merchant")
	GROUND:Hide("Guild_Entrance")--disable map transition object
	UI:ResetSpeaker()
	GAME:MoveCamera(640, 1208, 1, false)
	GROUND:TeleportTo(partner, 444, 1200, Direction.Right)
	GROUND:TeleportTo(hero, 380, 1200, Direction.Right)
	GAME:FadeIn(40)
	
	--the partner runs in due to excitement, hero struggling to keep up
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(hero, 616, 1200, false, 2) end)
	local coro2 = TASK:BranchCoroutine(metano_town_ch_1.RunSequencePartner)
	TASK:JoinCoroutines({coro1, coro2})	
		
	GeneralFunctions.EmoteAndPause(hero, "Sweating", true)
	UI:SetSpeaker('', false, hero.CurrentForm.Species, hero.CurrentForm.Form, hero.CurrentForm.Skin, hero.CurrentForm.Gender)
	UI:SetSpeakerEmotion("Pain")
	UI:WaitShowTimedDialogue("*huff*[pause=20] *huff*", 60)
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(partner, "glowing", 0)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	GROUND:CharSetAnim(partner, 'Idle', true)
	UI:WaitShowDialogue("Heheh,[pause=10] sorry " .. hero:GetDisplayName() .. ".[pause=0] I guess I got a little too excited.")
	GROUND:CharSetAnim(partner, 'None', true)
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(partner, "", 0)
	GAME:WaitFrames(10)
	
	GeneralFunctions.LookAround(partner, 2, 4, false, false, false)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("I know you're probably curious about the town.[pause=0] But we need go to the guild before it gets any later!")
	GAME:WaitFrames(20)
	
	--turn towards  the guild
	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("The Adventurer's Guild is just across that bridge.")
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:WaitShowDialogue("I'm very excited,[pause=10] and I hope you are too but...")
	GeneralFunctions.EmoteAndPause(partner, "Sweating", true)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("I can't help but feel nervous...")
	UI:WaitShowDialogue("You may have figured it out,[pause=10] but I've been here before to apply.")
	UI:WaitShowDialogue("I was so scared...[pause=0] It took me ages to gather my courage just to step foot inside the guild.")
	UI:WaitShowDialogue("And,[pause=10] well,[pause=10] obviously it didn't turn out too good for me.")
	
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(I understand why " .. partner:GetDisplayName() .. " would feel apprehensive coming here,[pause=10] even now...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(But they only turned " .. GeneralFunctions.GetPronoun(partner, "them") .. " away because " .. GeneralFunctions.GetPronoun(partner, "they") .. " didn't have a partner.)", "Normal")
	GeneralFunctions.HeroDialogue(hero, "(Now that I'm here,[pause=10] there shouldn't be any issue,[pause=10] right?)", "Normal")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroSpeak(hero, 60)
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Yeah,[pause=10] I know...[pause=0] With you I shouldn't have anything to worry about.")
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("I still have butterflies in my stomach,[pause=10] though...")
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
	GAME:WaitFrames(20)
	GeneralFunctions.DoAnimation(partner, "DeepBreath")
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Alright,[pause=10] I think I'm as ready as I'm gonna be.[pause=0] Let's go!")
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(hero, 'Nod') end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(partner, 'Nod') end)
	TASK:JoinCoroutines({coro1, coro2})	
	GAME:WaitFrames(20)
	GAME:FadeOut(false, 40)
	
	--show the guild
	local frameDur = GeneralFunctions.CalculateCameraFrames(744, 796, 684, 928, 2)
	GAME:MoveCamera(744, 796, 1, false)
	GAME:WaitFrames(40)
	GAME:FadeIn(40)
	GAME:WaitFrames(120)
	GROUND:TeleportTo(partner, 648, 1064, Direction.Up)
	GROUND:TeleportTo(hero, 648, 1096, Direction.Up)
	
	coro1= TASK:BranchCoroutine(GAME:_MoveCamera(684, 928, frameDur, false))
	--coro1 = TASK:BranchCoroutine(function() GeneralFunctions.CenterCamera({hero, partner, growlithe}, 744, 796, 1) end)
	coro2 = TASK:BranchCoroutine(metano_town_ch_1.WalkSequenceHero)
	local coro3 = TASK:BranchCoroutine(metano_town_ch_1.WalkSequencePartner)
	local coro4 = TASK:BranchCoroutine(metano_town_ch_1.GrowlitheSequence)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})	
	GROUND:CharAnimateTurnTo(growlithe, Direction.Right, 4)
	--696, 912
	
	--growlithe is excited to see you
	--dont give their name in the textbox at first
	UI:SetSpeaker(STRINGS:Format("\\uE040"), true, growlithe.CurrentForm.Species, growlithe.CurrentForm.Form, growlithe.CurrentForm.Skin, growlithe.CurrentForm.Gender)
	UI:SetSpeakerEmotion("Happy")
	GROUND:CharSetEmote(growlithe, "glowing", 0)
	GeneralFunctions.Hop(growlithe)
	UI:WaitShowDialogue("Hi " .. partner:GetDisplayName() .. "![pause=0] Glad to see you,[pause=10] ruff![pause=0] I'm on sentry duty as usual!")
	GROUND:EntTurn(growlithe, Direction.DownRight)
	GROUND:CharSetEmote(growlithe, "", 0)
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Normal")
	GROUND:CharSetAnim(growlithe, 'None', true)
	UI:WaitShowDialogue("Who is this?[pause=0] I've never seen you before!")
	UI:SetSpeakerEmotion("Happy")
	GROUND:CharSetAnim(growlithe, 'Idle', true)
	UI:WaitShowDialogue("Hi there!")
	GROUND:CharSetAnim(growlithe, 'None', true)
	GAME:WaitFrames(16)
	GROUND:CharAnimateTurnTo(growlithe, Direction.Right, 4)
	
	--introduce hero to growlithe, partner and growlithe are already acquainted
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("I'm glad to see you too,[pause=10] " .. growlithe:GetDisplayName() .. "!")
	GAME:WaitFrames(12)
	GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
	GROUND:EntTurn(hero, Direction.Up)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("This is " .. hero:GetDisplayName() .. ".")
	GAME:WaitFrames(12)
	GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
	GROUND:EntTurn(hero, Direction.UpLeft)
	--[[Dialogue removed for being a bit unnecessary
	UI:WaitShowDialogue(GeneralFunctions.GetPronoun(hero, "they're", true) .. "...")
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(partner, "Notice", true)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("(Hmm...[pause=0] I probably shouldn't tell anyone that " .. hero:GetDisplayName() .. " was a human...)")
	GAME:WaitFrames(20)
	
	UI:SetSpeakerEmotion("Normal")]]--
	UI:WaitShowDialogue(GeneralFunctions.GetPronoun(hero, "they're", true) .. "...[pause=0] a friend of mine who's new to town.")	
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Happy")
	GROUND:CharSetEmote(growlithe, "glowing", 0)
	GROUND:EntTurn(growlithe, Direction.DownRight)
	GROUND:CharSetAnim(growlithe, 'Idle', true)
--	GeneralFunctions.Hop(growlithe)
	UI:WaitShowDialogue("Ruff![pause=0] It's nice to meet you,[pause=10] " .. hero:GetDisplayName() .. "![pause=0] My name's " .. growlithe:GetDisplayName() .. "!")
	GROUND:CharSetEmote(growlithe, "", 0)
	GROUND:CharSetAnim(growlithe, 'None', true)
	GAME:WaitFrames(20)
	GROUND:EntTurn(growlithe, Direction.Right)
	
	--whatcha doin here?
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("So what brings you to the guild today?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("W-we've come to...[pause=0] Uh...")
	GROUND:CharAnimateTurnTo(partner,Direction.Down,4)
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	GeneralFunctions.EmoteAndPause(partner, "Sweating", true)
	GAME:WaitFrames(20)
	GeneralFunctions.DoAnimation(hero, 'Nod')
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
	GROUND:EntTurn(hero, Direction.UpLeft)
	UI:WaitShowDialogue("We've come to...[pause=0] speak with the Guildmaster about apprenticing here.")
	GAME:WaitFrames(20)
	
	--woah im glad! more friends :) I'll go let them know you're coming
	GeneralFunctions.EmoteAndPause(growlithe, "Exclaim", true)
	GAME:WaitFrames(10)
	GeneralFunctions.DoubleHop(growlithe, 'None', 10, 10, true, true)
	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Inspired")
	GROUND:CharSetAnim(growlithe, 'Idle', true)
	GROUND:CharSetEmote(growlithe, "happy", 0)
	UI:WaitShowDialogue("Wow![pause=0] Really!?[pause=0] I'd love to have more guildmates!")
	UI:WaitShowDialogue("More friends is always great,[pause=10] ruff![pause=0] I hope you two get to join!")
	GROUND:CharSetEmote(growlithe, "", 0)
	GROUND:CharSetAnim(growlithe, 'None', true)
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Wait here,[pause=10] you guys![pause=0] I need to let them know you're coming before you go in!")
	
	
	--he hops over his little post, pushing you to the side, and runs inside the guild.
	--partner and hero reflect on how well it's going, growlithe comes back out after a while
	coro1 = TASK:BranchCoroutine(metano_town_ch_1.GrowlitheRunInside)
	coro2 = TASK:BranchCoroutine(metano_town_ch_1.PartnerPushedBack)
	coro3 = TASK:BranchCoroutine(metano_town_ch_1.HeroPushedBack)
	TASK:JoinCoroutines({coro1, coro2, coro3})	
	
	GAME:WaitFrames(60)
	GROUND:CharSetEmote(partner, "sweatdrop", 1)
	GROUND:CharSetEmote(hero, "sweatdrop", 1)
	SOUND:PlayBattleSE('EVT_Emote_Sweatdrop')
	GAME:WaitFrames(60)
	
	--hyko is easily excitable
	GeneralFunctions.HeroDialogue(hero, '(...)', 'Stunned')
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Stunned")
	UI:WaitShowDialogue("I didn't realize " .. growlithe:GetDisplayName() .. " was so excitable...")
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("But he seemed very glad to hear we wanted to join the guild!")
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("That's gotta be a good sign,[pause=10] right?[pause=0] I feel a little more confident now,[pause=10] at least.")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(It's reassuring that we only just got here and we're already being taken so kindly...)", "Normal")
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4)
	GeneralFunctions.HeroDialogue(hero, "(...But is this really the guild?[pause=0] It's a tree?[pause=0] I was expecting something different...)", "Worried")
	GAME:WaitFrames(60)
	
	--hyko returns
	GROUND:Unhide('Growlithe')
	coro1 = TASK:BranchCoroutine(metano_town_ch_1.GrowlitheReturn)
	coro2 = TASK:BranchCoroutine(function() metano_town_ch_1.TeamWatchGrowlithe(hero) end)
	coro3 = TASK:BranchCoroutine(function() metano_town_ch_1.TeamWatchGrowlithe(partner) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})	

	--he tells you to meet up with phileas on the 2nd floor
	GAME:WaitFrames(10)
	GROUND:MoveToPosition(partner, 696, 924, false, 1)
	GROUND:CharTurnToCharAnimated(partner, growlithe, 4)	
	GAME:WaitFrames(10)
	GeneralFunctions.DoubleHop(growlithe)
	GROUND:CharSetEmote(growlithe, "happy", 0)
	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Happy")
	GROUND:CharSetAnim(growlithe, 'Idle', true)
	UI:WaitShowDialogue("Ok,[pause=10] you two are good to head in,[pause=10] ruff!")
	GROUND:CharSetAnim(growlithe, 'None', true)
	GROUND:CharSetEmote(growlithe, "", 0)
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("You need to speak with " .. CharacterEssentials.GetCharacterName("Noctowl") .. ".[pause=0] He's a [color=#00FF00]Noctowl[color].[pause=0] He'll be looking for you on the second floor!")


	GAME:WaitFrames(10)
	GeneralFunctions.Hop(partner)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Thanks,[pause=10] " .. growlithe:GetDisplayName() .. "![pause=0] We'll go find " .. CharacterEssentials.GetCharacterName("Noctowl") .. " on the second floor now then!")
	UI:SetSpeaker(growlithe)
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(metano_town_ch_1.TeamEnterGuildHero)
	coro2 = TASK:BranchCoroutine(metano_town_ch_1.TeamEnterGuildPartner)
	coro3 = TASK:BranchCoroutine(function() UI:WaitShowTimedDialogue("Good luck,[pause=10] ruff![pause=20] I know you two can do it!", 60) end)
	coro4 = TASK:BranchCoroutine(function () GAME:WaitFrames(10) GROUND:CharAnimateTurnTo(growlithe, Direction.UpRight, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})	

	GAME:WaitFrames(20)
	SOUND:FadeOutBGM()
	GAME:FadeOut(false, 40)
	GAME:EnterGroundMap("guild_first_floor", "Main_Entrance_Marker")
	


end



function metano_town_ch_1.TeamEnterGuildPartner()
	local chara = CH('Teammate1')
	GeneralFunctions.EightWayMove(chara, 712, 908, false, 1)
	GeneralFunctions.EightWayMove(chara, 712, 876, false, 1)
	GROUND:Hide(chara.EntName)
end


function metano_town_ch_1.TeamEnterGuildHero()
	local chara = CH('PLAYER')
	GAME:WaitFrames(10)
	GeneralFunctions.EightWayMove(chara, 712, 908, false, 1)
	GeneralFunctions.EightWayMove(chara, 712, 876, false, 1)
	GROUND:Hide(chara.EntName)
end

--comes back from inside the guild to tell you to go on in
function metano_town_ch_1.GrowlitheReturn()
	local chara = CH('Growlithe')
	GROUND:MoveToPosition(chara, 712, 924, false, 2)
	GROUND:MoveToPosition(chara, 694, 924, false, 2)
	SOUND:PlayBattleSE('_UNK_EVT_010')--jump sfx. Maybe find a better one if possible?
	GROUND:AnimateToPosition(chara, 'Rumble', Direction.Left, 662, 924, 1, 2, 0)
	GROUND:CharAnimateTurnTo(chara, Direction.Right, 4)
end 

function metano_town_ch_1.TeamWatchGrowlithe(chara)
	GAME:WaitFrames(10)
	GROUND:CharTurnToChar(chara, CH('Growlithe'))
	GROUND:CharSetEmote(chara, "exclaim", 1)
	GeneralFunctions.FaceMovingCharacter(chara, CH('Growlithe'))
end