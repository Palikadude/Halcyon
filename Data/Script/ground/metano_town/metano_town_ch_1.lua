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
	GROUND:Unhide("Growlithe")
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
	GROUND:MoveToPosition(CH('Teammate1'), 648, 1200, false, 3)
	GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Left, 4)
end

--walking up to growlithe.
function metano_town_ch_1.WalkSequenceHero()
	GROUND:MoveToPosition(CH('PLAYER'), 648, 1032, false, 1)
	GROUND:MoveToPosition(CH('PLAYER'), 696, 986, false, 1)
	GROUND:MoveToPosition(CH('PLAYER'), 696, 948, false, 1)
	GROUND:CharTurnToCharAnimated(CH('PLAYER'), CH('Growlithe'), 4)
end

--walking up to growlithe
function metano_town_ch_1.WalkSequencePartner()
	GROUND:MoveToPosition(CH('Teammate1'), 648, 1032, false, 1)
	GROUND:MoveToPosition(CH('Teammate1'), 696, 986, false, 1)
	GROUND:MoveToPosition(CH('Teammate1'), 696, 924, false, 1)
	GROUND:CharTurnToCharAnimated(CH('Teammate1'), CH('Growlithe'), 4)
end

--growlithe turning as you walk towards him, with him getting excited
function metano_town_ch_1.GrowlitheSequence()
	--todo: add a little hop either in here or when growlithe first speaks
	GAME:WaitFrames(20)
	local chara = CH('Growlithe')
	GROUND:CharSetEmote(chara, 2, 1)
	GROUND:CharSetAnim(chara, 'Idle', true)
	GROUND:CharAnimateTurnTo(chara, Direction.Down, 4)
	GAME:WaitFrames(40)
	GROUND:CharAnimateTurnTo(chara, Direction.DownRight, 4)
end 

--growlithe leaving his post to go inside the guild
function metano_town_ch_1.GrowlitheRunInside()
	local chara = CH('Growlithe')
	--todo: proper animations
	SOUND:PlayBattleSE('_UNK_EVT_010')--jump sfx. Maybe find a better one if possible?
	--GROUND:CharSetAnim(chara, 'Rumble', false)--this wont do anything until that new function comes
	GROUND:MoveToPosition(chara, 696, 924, false, 2)
	GROUND:MoveToPosition(chara, 712, 924, true, 4)
	GROUND:MoveToPosition(chara, 712, 876, true, 4)
	GROUND:Hide('Growlithe')	
end

function metano_town_ch_1.PartnerPushedBack()
	local chara = CH('Teammate1')
	GROUND:CharSetEmote(chara, 8, 1)
	GROUND:MoveToPosition(chara, 696, 900, false, 4)--todo: proper animation
	GROUND:EntTurn(chara, Direction.Down)
	GAME:WaitFrames(6)
	GROUND:CharAnimateTurnTo(chara, Direction.Right, 4)
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(chara, Direction.UpRight, 4)
end

function metano_town_ch_1.HeroPushedBack()
	local chara = CH('PLAYER')
	GROUND:CharSetEmote(chara, 8, 1)
	GROUND:CharAnimateTurnTo(chara, Direction.Up, 4)
end 
--hero and partner enter the guild
function metano_town_ch_1.EnterGuild()
	--center of guild: 744, 796
	--todo: hide all ground characters besides those needed
	
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local growlithe = CH('Growlithe')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	GAME:MoveCamera(640, 1208, 1, false)
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
	UI:WaitShowDialogue("C'mon,[pause=10] you gotta keep up, " .. hero:GetDisplayName() .. "!")
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:CharSetEmote(partner, -1, 0)
	
	GAME:WaitFrames(20)
	GeneralFunctions.LookAround(partner, 2, 4, false, false, false)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("I know you're probably curious about the town.[pause=0] But we need go to the guild before it gets any later!")
	UI:WaitShowDialogue("I'll show you around town tomorrow.")
	
	--turn towards  the guild
	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("The Adventurer's Guild is just across that bridge.")
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:WaitShowDialogue("I'm very excited,[pause=10] and I hope you are too but...")
	GeneralFunctions.EmoteAndPause(partner, "Sweating", true)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("I can't help but feel nervous...")
	UI:WaitShowDialogue("You may have figured it out,[pause=10] but I've been here before to apply and...")
	UI:WaitShowDialogue("...well,[pause=10] obviously it didn't turn out too well.")
	
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(I understand why " .. partner:GetDisplayName() .. " would feel apprehensive coming here,[pause=10] even now...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(But they only turned " .. GeneralFunctions.GetPronoun(partner, "them") .. " away because " .. GeneralFunctions.GetPronoun(partner, "they") .. " didn't have a partner.)", "Normal")
	GeneralFunctions.HeroDialogue(hero, "(Now that I'm here,[pause=10] there shouldn't be any issue,[pause=10] right?)", "Normal")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroSpeak(hero, 60)
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Normal")
	--todo a little hop when text reaches the end of the string
	UI:WaitShowDialogue("Yeah I know...[pause=0] With you I should have nothing to worry about.")
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("I still have butterflies in my stomach though...")
	GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
	GAME:WaitFrames(20)
	GeneralFunctions.DoAnimation(partner, "DeepBreath")
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Alright,[pause=10] I'm think I'm as good as I'm gonna be.[pause=0] Let's go!")
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(hero, 'Nod') end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(partner, 'Nod') end)
	TASK:JoinCoroutines({coro1, coro2})	
	GAME:FadeOut(false, 20)
	
	--show the guild
	local frameDur = GeneralFunctions.CalculateCameraFrames(744, 796, 684, 928, 2)
	GAME:MoveCamera(744, 796, 1, false)
	GAME:WaitFrames(40)
	GAME:FadeIn(20)
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
	GROUND:CharSetEmote(growlithe, 4, 0)
	UI:WaitShowDialogue("Hi " .. partner:GetDisplayName() .. "![pause=0] Glad to see you![pause=0] I am on sentry duty as usual!")
	GROUND:EntTurn(growlithe, Direction.DownRight)
	GROUND:CharSetEmote(growlithe, -1, 0)
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
	UI:WaitShowDialogue("I'm glad to see you too " .. growlithe:GetDisplayName() .. "!")
	GAME:WaitFrames(12)
	GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
	GROUND:EntTurn(hero, Direction.Up)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("This is " .. hero:GetDisplayName() .. ".")
	GAME:WaitFrames(12)
	GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
	GROUND:EntTurn(hero, Direction.UpLeft)
	UI:WaitShowDialogue(GeneralFunctions.GetPronoun(hero, "they're", true) .. " a friend of mine who's new to town.")
	
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Happy")
	--todo:  little hop
	GROUND:CharSetEmote(growlithe, 4, 0)
	GROUND:EntTurn(growlithe, Direction.DownRight)
	GROUND:CharSetAnim(growlithe, 'Idle', true)
	UI:WaitShowDialogue("It's nice to meet you " .. hero:GetDisplayName() .. "![pause=0] My name is " .. growlithe:GetDisplayName() .. "!")
	GROUND:CharSetEmote(growlithe, -1, 0)
	GROUND:CharSetAnim(growlithe, 'None', true)
	GAME:WaitFrames(20)
	GROUND:EntTurn(growlithe, Direction.Right)
	
	--whatcha doin here?
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("So what brings you to the guild today?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("W-we're here to...[pause=0] Uh...")
	GROUND:CharAnimateTurnTo(partner,Direction.Down,4)
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	GeneralFunctions.EmoteAndPause(partner, "Sweating", true)
	GAME:WaitFrames(20)
	GeneralFunctions.DoAnimation(hero, 'Nod')
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
	GROUND:EntTurn(hero, Direction.UpLeft)
	UI:WaitShowDialogue("We're here to...[pause=0] speak with the Guildmaster about apprenticing here.")
	
	--woah im glad! more friends :) I'll go let them know you're coming
	GeneralFunctions.EmoteAndPause(growlithe, "Exclaim", true)
	GAME:WaitFrames(20)
	--todo: do two hops
	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Inspired")
	GROUND:CharSetEmote(growlithe, 1, 0)
	UI:WaitShowDialogue("Wow![pause=0] Really!?[pause=0] I would love to have more guildmates!")
	UI:WaitShowDialogue("More friends is always good,[pause=10] ruff![pause=0] I hope you two are accepted!")
	GROUND:CharSetEmote(growlithe, -1, 0)
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Wait here you guys![pause=0] I need to let them know you're coming before you go in!")
	
	
	--he hops over his little post, pushing you to the side, and runs inside the guild.
	--partner and hero reflect on how well it's going, growlithe comes back out after a while
	--todo: proper animations to jump over post, and for partner to be knocked back
	coro1 = TASK:BranchCoroutine(metano_town_ch_1.GrowlitheRunInside)
	coro2 = TASK:BranchCoroutine(metano_town_ch_1.PartnerPushedBack)
	coro3 = TASK:BranchCoroutine(metano_town_ch_1.HeroPushedBack)
	TASK:JoinCoroutines({coro1, coro2, coro3})	
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(partner, 9, 1)
	GROUND:CharSetEmote(hero, 9, 1)
	SOUND:PlayBattleSE('EVT_Emote_Sweatdrop')
	GAME:WaitFrames(120)
	
	--hyko is easily excitable
	GeneralFunctions.HeroDialogue(hero, '(...)', 'Stunned')
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Stunned")
	UI:WaitShowDialogue("I didn't realize " .. growlithe:GetDisplayName() .. " was that excitable...")
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue(growlithe:GetDisplayName() .. " seemed very glad to hear we wanted to join the guild!")
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("That's gotta help our chances,[pause=10] surely?[pause=0] I feel more confident now,[pause=10] anyway.")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(It's reassuring that we only just got here and we're being taken kindly...)", "Normal")
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4)
	GeneralFunctions.HeroDialogue(hero, "(...but is this really the guild?[pause=0] It's a tree?", "Worried")
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
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
	GROUND:CharTurnToCharAnimated(partner, growlithe, 4)	--todo: two little hops
	GROUND:CharSetEmote(growlithe, 1, 0)
	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Happy")
	GROUND:CharSetAnim(growlithe, 'Idle', true)
	UI:WaitShowDialogue("Ok,[pause=10] you two are good to head in,[pause=10] ruff!")
	GROUND:CharSetAnim(growlithe, 'None', true)
	GROUND:CharSetEmote(growlithe, -1, 0)
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("You need to speak with [color=#00FFFF]Phileas[color].[pause=0] He's a [color=#00FF00]Noctowl[color].[pause=0] He'll be looking for you on the second floor!")


	GAME:WaitFrames(20)
	--todo: a hop
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Thanks " .. growlithe:GetDisplayName() .. "![pause=0] We'll go find [color=#00FFFF]Phileas[color] on the second floor now then!")
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() metano_town_ch_1.TeamEnterGuild(hero) end)
	coro2 = TASK:BranchCoroutine(function() metano_town_ch_1.TeamEnterGuild(partner) end)
	coro3 = TASK:BranchCourtine(UI:_WaitShowTimedDialogue(growlithe, "Good luck![pause=20] I know you two can do it!", 60))
	coro3 = TASK:BranchCourtine(function () GAME:WaitFrames(10) GROUND:CharAnimateTurnTo(growlithe, Direction.UpRight, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})	

	GAME:WaitFrames(20)
	GAME:FadeOut(false, 20)
	GAME:EnterGroundMap("guild_first_floor ", "Main_Entrance_Marker")
	


end



function metano_town_ch_1.TeamEnterGuild(chara)
	GROUND:MoveToPosition(chara, 712, 908, false, 1)
	GROUND:MoveToPosition(chara, 712, 876, false, 1)
end

--comes back from inside the guild to tell you to go on in
function metano_town_ch_1.GrowlitheReturn()
	local chara = CH('Growlithe')
	GROUND:MoveToPosition(chara, 712, 924, false, 2)
	GROUND:MoveToPosition(chara, 696, 924, false, 2)
	SOUND:PlayBattleSE('_UNK_EVT_010')--jump sfx. Maybe find a better one if possible?
	--todo: add the jump  to get back over the desk
	GROUND:MoveToPosition(chara, 664, 924, false, 2)
	GROUND:CharAnimateTurnTo(chara, Direction.Right, 4)
end 

function metano_town_ch_1.TeamWatchGrowlithe(chara)
	GAME:WaitFrames(10)
	GROUND:CharTurnToChar(chara, CH('Growlithe'))
	GROUND:CharSetEmote(chara, 3, 1)
	GeneralFunctions.FaceMovingCharacter(chara, CH('Growlithe'))
end