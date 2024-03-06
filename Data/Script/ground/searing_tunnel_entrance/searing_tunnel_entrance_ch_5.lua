require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

searing_tunnel_entrance_ch_5 = {}

function searing_tunnel_entrance_ch_5.SetupGround()	
	if not SV.Chapter5.EnteredTunnel then 
		local tropius, noctowl, mareep, cranidos, snubbull, audino, breloom, girafarig, tail = 
		CharacterEssentials.MakeCharactersFromList({
			{'Tropius', 336, 112, Direction.Left},
			{'Noctowl', 304, 112, Direction.Right},
			{'Mareep', 276, 260, Direction.UpLeft},
			{'Cranidos', 240, 260, Direction.UpRight},
			{'Snubbull', 276, 224, Direction.DownLeft},
			{'Audino', 240, 224, Direction.DownRight},
			{'Breloom', 144, 80, Direction.DownLeft},
			{'Girafarig', 120, 104, Direction.UpRight}
		})
			
		--set rin and coco to spawn from the spawners, then spawn them
		GROUND:SpawnerSetSpawn("TEAMMATE_2", GAME:GetPlayerPartyMember(2))
		local growlithe = GROUND:SpawnerDoSpawn("TEAMMATE_2")
			
		GROUND:SpawnerSetSpawn("TEAMMATE_3", GAME:GetPlayerPartyMember(3))
		local zigzagoon = GROUND:SpawnerDoSpawn("TEAMMATE_3")
		
	else
		local noctowl, tropius = 
		CharacterEssentials.MakeCharactersFromList({
			{'Noctowl', 192, 80, Direction.Down},
			{'Tropius', 376, 128, Direction.Down}
		})
		
		--Noctowl catches his sleep now since Tropius has supply duty handled.
		GROUND:CharSetAnim(noctowl, "Sleep", true)
			
		--set rin and coco to spawn from the spawners, then spawn them
		GROUND:SpawnerSetSpawn("TEAMMATE_2", GAME:GetPlayerPartyMember(2))
		local growlithe = GROUND:SpawnerDoSpawn("TEAMMATE_2")
			
		GROUND:SpawnerSetSpawn("TEAMMATE_3", GAME:GetPlayerPartyMember(3))
		local zigzagoon = GROUND:SpawnerDoSpawn("TEAMMATE_3")
		
		--teleport them to their new spot depending on where they should be.
		if SV.Chapter5.TunnelLastExitReason == 'Retreated' then
			GROUND:TeleportTo(growlithe, 440, 172, Direction.Down)
			GROUND:TeleportTo(zigzagoon, 440, 198, Direction.Up)
		else
			GROUND:TeleportTo(growlithe, 360, 152, Direction.Right)
			GROUND:TeleportTo(zigzagoon, 392, 152, Direction.Left)
		end
	end
end


--this is one long ass continuous cutscene
--TASK:BranchCoroutine(searing_tunnel_entrance_ch_5.ArrivalDinnerNightAndAddressCutscene)
function searing_tunnel_entrance_ch_5.ArrivalDinnerNightAndAddressCutscene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local tunnel = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('searing_tunnel')
	local steppe = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('vast_steppe')
	local ruins = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('cloven_ruins')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	SOUND:StopBGM()
	GAME:MoveCamera(160, 168, 1, false)
	GROUND:AddMapStatus("dusk")--dusk
	
	--for debug purposes
	GAME:FadeOut(false, 1)
	
	local hay_bed = RogueEssence.Content.ObjAnimData('Hay_Bed', 1)
	local campfire = RogueEssence.Content.ObjAnimData('Campfire', 6)

	GROUND:TeleportTo(hero, -32, 144, Direction.Right)
	GROUND:TeleportTo(partner, -32, 176, Direction.Right)
	
	local audino, snubbull, girafarig, breloom, growlithe, zigzagoon, tropius, noctowl, mareep, cranidos = 
	CharacterEssentials.MakeCharactersFromList({
		{'Audino', -64, 184, Direction.Right},
		{'Snubbull', -64, 136, Direction.Right},
		{'Girafarig', 254, 141, Direction.Right},
		{'Breloom', 181, 195, Direction.DownLeft},
		{'Growlithe'},
		{'Zigzagoon'},
		{'Tropius'},
		{'Noctowl'},
		{'Mareep'},
		{'Cranidos'}
	})
	
	GROUND:CharSetAnim(breloom, "Idle", true)
	GROUND:CharSetAnim(girafarig, "Idle", true)
	
	--if you failed in the steppe at all, you get here later than Ganlon's team.
	if SV.Chapter5.LostSteppe then 
		GROUND:Unhide('Cranidos')
		GROUND:Unhide('Mareep')
		GROUND:Unhide('Growlithe')
		GROUND:Unhide('Zigzagoon')
		
		GROUND:TeleportTo(cranidos, 120, 96, Direction.UpRight)
		GROUND:TeleportTo(mareep, 144, 72, Direction.DownLeft)
		GROUND:CharSetAnim(mareep, "Idle", true)
		AI:SetCharacterAI(mareep, "ai.ground_talking", false, 60, 60, 0, false, 'Default', {cranidos})	
		
		GROUND:TeleportTo(zigzagoon, 224, 200, Direction.UpRight)
		GROUND:TeleportTo(growlithe, 248, 176, Direction.DownLeft)
		GROUND:CharSetAnim(zigzagoon, "Idle", true)
		GROUND:CharSetAnim(growlithe, "Idle", true)
		AI:SetCharacterAI(growlithe, "ai.ground_talking", false, 60, 60, 0, false, 'Default', {zigzagoon})	
	end
	
	--This is done like this so I can copy and paste this code into other scenes that have a similar set up and only change one value
	--to get all the beds and campfire to spawn relative to that spot.
	local bedRelativeX = 114
	local bedRelativeY = 84
	local bed1X, bed6X = bedRelativeX + 78, bedRelativeX + 78
	local bed2X, bed5X = bedRelativeX + 123, bedRelativeX + 123
	local bed3X, bed4X = bedRelativeX + 156, bedRelativeX + 156
	local bed7X, bed10X = bedRelativeX + 33, bedRelativeX + 33
	local bed8X, bed9X = bedRelativeX, bedRelativeX
	
	local bed11X, bed11Y = 312, 108
	local bed12X, bed12Y = 344, 132
	
	local bed1Y = bedRelativeY
	local bed2Y, bed10Y = bedRelativeY + 11, bedRelativeY + 11
	local bed3Y, bed9Y = bedRelativeY + 44, bedRelativeY + 44
	local bed4Y, bed8Y = bedRelativeY + 84, bedRelativeY + 84
	local bed5Y, bed7Y = bedRelativeY + 117, bedRelativeY + 117
	local bed6Y = bedRelativeY + 128
	

	--Beds. Start with top center, go clockwise, then do the two off to the side.
	GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(bed1X, bed1Y)))
	GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(bed2X, bed2Y)))
	GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(bed3X, bed3Y)))
	GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(bed4X, bed4Y)))
	GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(bed5X, bed5Y)))
	GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(bed6X, bed6Y)))
	GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(bed7X, bed7Y)))
	GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(bed8X, bed8Y)))
	GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(bed9X, bed9Y)))
	GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(bed10X, bed10Y)))

	--bed 11/12 are a bit more free form in where they go.
	GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(bed11X, bed11Y)))
	GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay_bed, RogueElements.Loc(bed12X, bed12Y)))
	
	
	GAME:WaitFrames(40)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("We did it![pause=0] We made it through " .. steppe:GetColoredName() .. "!")
	GAME:WaitFrames(20)
	UI:SetSpeaker(snubbull)
	UI:WaitShowDialogue("Look ahead![pause=0] That must be the camp over there.")
	GAME:WaitFrames(20)
	
	GAME:FadeIn(40)
	SOUND:PlayBGM('At The End of the Day.ogg', true)
	
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 92, 176, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames (10) GROUND:MoveToPosition(hero, 92, 144, false, 1) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(2) GROUND:MoveToPosition(audino, 60, 184, false, 1) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:MoveToPosition(snubbull, 60, 136, false, 1) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	GAME:WaitFrames(10)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Woah![pause=0] The camp is all set up already!")
	
	GAME:WaitFrames(20)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
	coro1 = TASK:BranchCoroutine(function() GROUND:CharSetEmote(breloom, "exclaim", 1)
											GROUND:CharEndAnim(breloom) 
											GAME:WaitFrames(20)
											GROUND:CharAnimateTurnTo(breloom, Direction.Left, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:CharSetEmote(girafarig, "notice", 1)
											GAME:WaitFrames(20)
											GROUND:CharEndAnim(girafarig) 
											GROUND:CharAnimateTurnTo(girafarig, Direction.Left, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(12)
											GROUND:CharEndAnim(cranidos) 
											GROUND:CharAnimateTurnTo(cranidos, Direction.DownLeft, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharEndAnim(mareep) 
											AI:DisableCharacterAI(mareep)	
											GROUND:CharSetEmote(mareep, "", 0)
											GROUND:CharAnimateTurnTo(mareep, Direction.DownLeft, 4) end)
	local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharEndAnim(zigzagoon) 
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.Left, 4) end)
	local coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharEndAnim(growlithe) 
											AI:DisableCharacterAI(growlithe)		
											GROUND:CharSetEmote(growlithe, "", 0)
											GROUND:CharAnimateTurnTo(growlithe, Direction.Left, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6})
	
	GAME:WaitFrames(10)
	UI:SetSpeaker(girafarig)
	UI:SetSpeakerEmotion("Happy")
	if SV.Chapter5.LostSteppe then
		UI:WaitShowDialogue("Oh,[pause=10] hey![pause=0] You guys finally made it!")
		UI:WaitShowDialogue("We're just finishing setting up the camp.")
	else 
		UI:WaitShowDialogue("Oh,[pause=10] hey![pause=0] You guys made it here quick!")
		UI:WaitShowDialogue("We're still setting up the camp.")
	end
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(breloom)
	UI:WaitShowDialogue("We've got the setup covered,[pause=10] by the way.[pause=0] It's our job,[pause=10] after all!")	
	if SV.Chapter5.LostSteppe then
		UI:WaitShowDialogue("We'll probably have to wait a little while for the Guildmaster and " .. noctowl:GetDisplayName() .. " to get here.")
	else 
		UI:WaitShowDialogue("We'll probably have to wait a little while for the Guildmaster and the others to get here.")
	end
	UI:WaitShowDialogue("So feel free to settle in.[pause=0] I'm sure you're all tired after the journey here.")

	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Thanks,[pause=10] " .. breloom:GetDisplayName() .. "![pause=0] We'll take this chance to rest then.")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(snubbull)
	UI:SetSpeakerEmotion("Special0")
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(snubbull, Direction.DownRight, 4)
											UI:WaitShowDialogue("Rest?[pause=0] Ah,[pause=10] but the real adventure is only starting now!") end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(partner, Direction.UpLeft, 4) end)					 
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(12)
											GROUND:CharAnimateTurnTo(audino, Direction.Up, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(14)
											GROUND:CharAnimateTurnTo(hero, Direction.Left, 4) end)		
	coro5 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(breloom, Direction.DownLeft, 4)		
											GROUND:CharSetAnim(breloom, "Idle", true) end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:CharAnimateTurnTo(girafarig, Direction.Right, 4)		
											GROUND:CharSetAnim(girafarig, "Idle", true) end)
	local coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(12)
											GROUND:CharTurnToCharAnimated(cranidos, mareep, 4) end)
	local coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharTurnToCharAnimated(mareep, cranidos, 4) 				
											GROUND:CharSetAnim(mareep, "Idle", true) end)
	local coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:CharTurnToCharAnimated(zigzagoon, growlithe, 4) 
												  GROUND:CharSetAnim(zigzagoon, "Idle", true) end)
	local coro10 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
												   GROUND:CharTurnToCharAnimated(growlithe, zigzagoon, 4) 
												   GROUND:CharSetAnim(growlithe, "Idle", true) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9, coro10})
	
	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(partner, "Question", true) 
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("What do you mean?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(snubbull)
	UI:SetSpeakerEmotion("Special0")
	UI:WaitShowDialogue("A culinary adventure,[pause=10] of course. "  .. STRINGS:Format("\\u266A") .. "[pause=0]\nIt's time to prepare my next masterpiece!")
	UI:WaitShowDialogue("I found some Rabuta Berries during our travels that I think will make an excellent dinner blanched.") 
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(hero:GetDisplayName() .. ",[pause=10] " .. partner:GetDisplayName() .. "...[pause=0] Thank you for accompanying " .. audino:GetDisplayName() .. " and I today.")
	UI:WaitShowDialogue("Our adventure was exquisite.[pause=0] We should team up again in the future. "  .. STRINGS:Format("\\u266A"))
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Yeah![pause=0] It was a lot of fun adventuring together today![pause=0] We'll have to do it again!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(snubbull)
	UI:SetSpeakerEmotion("Special0")
	UI:WaitShowDialogue("Definitely.[pause=0] But for now,[pause=10] I have culinary efforts to pursue.")
	UI:WaitShowDialogue("Ah,[pause=10] a chef's work is never done...[pause=0] I'd best get to it. " .. STRINGS:Format("\\u266A"))
	
	
	GAME:WaitFrames(10)
	UI:SetSpeaker(audino)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(snubbull, Direction.UpRight, 4)
											GeneralFunctions.EightWayMove(snubbull, 352, 112, false, 1) 
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(60) 
											GROUND:CharAnimateTurnTo(audino, Direction.UpRight, 4)
											UI:WaitShowDialogue("I s-should probably go help her.[pause=0] She'll need some help to get dinner ready before it gets dark!")
											UI:SetSpeakerEmotion("Sigh")
											UI:WaitShowDialogue("Plus,[pause=10] there's a chance I can keep her ingredient use in check and our meal will still be edible...")
											GAME:WaitFrames(20)
											UI:SetSpeakerEmotion("Normal")
											UI:WaitShowDialogue("H-hey,[pause=10] would the two of you want to come help too?") end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(70)
											GROUND:CharAnimateTurnTo(partner, Direction.Left, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(76)
											GROUND:CharAnimateTurnTo(hero, Direction.DownLeft, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Huh?[pause=0] You want our help cooking?")
	UI:WaitShowDialogue("But neither of us have any experience in the kitchen...[pause=0] We wouldn't know what we're doing!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(audino)
	UI:WaitShowDialogue("Well sure![pause=0] I know we're d-done with the steppe,[pause=10] so we don't have to team up anymore...")
	UI:WaitShowDialogue("But I r-really enjoyed adventuring with you two today,[pause=10] so I thought we could k-keep it going!")
	UI:WaitShowDialogue("Just because we're not assigned to each other anymore doesn't mean we can't still work together!")
	UI:WaitShowDialogue("And d-don't worry about having no experience cooking.[pause=0] You'll just be helping out!")
	UI:SetSpeakerEmotion("Happy")
	GROUND:CharSetEmote(audino, "glowing", 0)
	UI:WaitShowDialogue("B-besides,[pause=10] with some of the " .. '"delicacies" that ' .. snubbull:GetDisplayName() .. " makes...[br]...sometimes I feel like she doesn't have any cooking experience either!")
	GAME:WaitFrames(20)
	
	GROUND:CharSetEmote(audino, "", 0)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Hahaha,[pause=10] I don't know if I'd go that far.[pause=0] But sure,[pause=10] I'd love to try and help!")

	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("What do you say,[pause=10] " .. hero:GetDisplayName() .. "?[pause=0] Are you feeling up to it?")
	GAME:WaitFrames(10)
	GeneralFunctions.DoAnimation(hero, 'Nod')
	GAME:WaitFrames(20)	
	
	UI:WaitShowDialogue("Alright!")
	GROUND:CharTurnToCharAnimated(partner, audino, 4)
	GROUND:CharTurnToCharAnimated(hero, audino, 4)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(audino:GetDisplayName() .. ",[pause=10] we'd love to help!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(audino)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Wonderful![pause=0] Let's get to work then!")
	GAME:WaitFrames(20)
	
	coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4)
											GeneralFunctions.EightWayMove(partner, 352, 160, false, 1) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(32) 
											GROUND:CharAnimateTurnTo(hero, Direction.DownRight, 4)
											GeneralFunctions.EightWayMove(hero, 352, 160, false, 1) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(36)
											--GROUND:CharAnimateTurnTo(audino, Direction.UpRight, 4)
											GeneralFunctions.EightWayMove(audino, 352, 160, false, 1) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(120)
											SOUND:FadeOutBGM(60)
											GAME:FadeOut(false, 60) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	GAME:WaitFrames(80)
	
	--unhide them if they didn't get here before you
	if not SV.Chapter5.LostSteppe then
		GROUND:Unhide('Cranidos')
		GROUND:Unhide('Mareep')
		GROUND:Unhide('Growlithe')
		GROUND:Unhide('Zigzagoon')
	end
	
	GROUND:Unhide('Tropius')
	GROUND:Unhide('Noctowl')
	
	GROUND:CharSetAnim(hero, "Eat", true)
	GROUND:CharSetAnim(partner, "Eat", true)
	GROUND:CharSetAnim(tropius, "Eat", true)
	GROUND:CharSetAnim(noctowl, "Eat", true)
	GROUND:CharSetAnim(cranidos, "Eat", true)
	GROUND:CharSetAnim(mareep, "Eat", true)
	GROUND:CharSetAnim(girafarig, "Eat", true)
	GROUND:CharSetAnim(breloom, "Eat", true)
	GROUND:CharSetAnim(audino, "Eat", true)
	GROUND:CharSetAnim(snubbull, "Eat", true)
	GROUND:CharSetAnim(growlithe, "Eat", true)
	GROUND:CharSetAnim(zigzagoon, "Eat", true)	
	
	GROUND:CharSetEmote(hero, "eating", 0)
	GROUND:CharSetEmote(partner, "eating", 0)
	GROUND:CharSetEmote(tropius, "eating", 0)
	GROUND:CharSetEmote(noctowl, "eating", 0)
	GROUND:CharSetEmote(cranidos, "eating", 0)
	GROUND:CharSetEmote(mareep, "eating", 0)
	GROUND:CharSetEmote(girafarig, "eating", 0)
	GROUND:CharSetEmote(breloom, "eating", 0)
	GROUND:CharSetEmote(audino, "eating", 0)
	GROUND:CharSetEmote(snubbull, "eating", 0)
	GROUND:CharSetEmote(growlithe, "eating", 0)
	GROUND:CharSetEmote(zigzagoon, "eating", 0)
	
	--add 13 to x of the bed, 10 to y of the bed to get where the characters should sit.
	GROUND:TeleportTo(hero, bed1X + 13, bed1Y + 10, Direction.Down) 
	GROUND:TeleportTo(partner, bed2X + 13, bed2Y + 10, Direction.Down) 
	GROUND:TeleportTo(growlithe, bed3X + 13, bed3Y + 10, Direction.Down) 
	GROUND:TeleportTo(zigzagoon, bed4X + 13, bed4Y + 10, Direction.Right) 
	GROUND:TeleportTo(audino, bed5X + 13, bed5Y + 10, Direction.Up) 
	GROUND:TeleportTo(snubbull, bed6X + 13, bed6Y + 10, Direction.Down) 
	GROUND:TeleportTo(mareep, bed7X + 13, bed7Y + 10, Direction.Right) 
	GROUND:TeleportTo(cranidos, bed8X + 13, bed8Y + 10, Direction.Right) 
	GROUND:TeleportTo(girafarig, bed9X + 13, bed9Y + 10, Direction.Left) 
	GROUND:TeleportTo(breloom, bed10X + 13, bed10Y + 10, Direction.Down) 
	GROUND:TeleportTo(tropius, bed11X + 13, bed11Y + 10, Direction.Down) 
	GROUND:TeleportTo(noctowl, bed12X + 13, bed12Y + 10, Direction.Down) 
	
	--spawn in food
	local food1 = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Food", 1, 0, 0), 
													RogueElements.Rect(bed1X + 13, bed1Y + 17, 16, 16),
													RogueElements.Loc(0, 0), 
													false, 
													"Food1")
	local food2 = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Food", 1, 0, 0), 
													RogueElements.Rect(bed2X + 13, bed2Y + 17, 16, 16),
													RogueElements.Loc(0, 0), 
													false, 
													"Food2")
	local food3 = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Food", 1, 0, 0), 
													RogueElements.Rect(bed3X + 13, bed3Y + 17, 16, 16),
													RogueElements.Loc(0, 0), 
													false, 
													"Food3")
	local food4 = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Food_Flipped", 1, 0, 0), 
													RogueElements.Rect(bed4X + 13, bed4Y, 16, 16),
													RogueElements.Loc(0, 0), 
													false, 
													"Food4")
	local food5 = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Food_Flipped", 1, 0, 0), 
													RogueElements.Rect(bed5X + 13, bed5Y, 16, 16),
													RogueElements.Loc(0, 0), 
													false, 
													"Food5")
	local food6 = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Food_Flipped", 1, 0, 0), 
													RogueElements.Rect(bed6X + 13, bed6Y, 16, 16),
													RogueElements.Loc(0, 0), 
													false, 
													"Food6")
	local food7 = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Food_Flipped", 1, 0, 0), 
													RogueElements.Rect(bed7X + 13, bed7Y, 16, 16),
													RogueElements.Loc(0, 0), 
													false, 
													"Food7")
	local food8 = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Food_Flipped", 1, 0, 0), 
													RogueElements.Rect(bed8X + 13, bed8Y, 16, 16),
													RogueElements.Loc(0, 0), 
													false, 
													"Food8")
	local food9 = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Food", 1, 0, 0), 
													RogueElements.Rect(bed9X + 13, bed9Y + 17, 16, 16),
													RogueElements.Loc(0, 0), 
													false, 
													"Food9")
	local food10 = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Food", 1, 0, 0), 
													RogueElements.Rect(bed10X + 13, bed10Y + 17, 16, 16),
													RogueElements.Loc(0, 0), 
													false, 
													"Food10")
	local food11 = RogueEssence.Ground.GroundObject(RogueEssence.Content.ItemAnimData("Banana_Yellow", 1, 0, 0), --itemanimdata for the banana instead!
													RogueElements.Rect(bed11X + 13, bed11Y + 17, 16, 16),
													RogueElements.Loc(0, 0), 
													false,
													"Food11")	
	local food12 = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Food", 1, 0, 0), 
													RogueElements.Rect(bed12X + 13, bed12Y + 17, 16, 16),
													RogueElements.Loc(0, 0), 
													false, 
													"Food12")
	
	food1:ReloadEvents()
	food2:ReloadEvents()
	food3:ReloadEvents()
	food4:ReloadEvents()
	food5:ReloadEvents()
	food6:ReloadEvents()
	food7:ReloadEvents()
	food8:ReloadEvents()
	food9:ReloadEvents()
	food10:ReloadEvents()
	food11:ReloadEvents()
	food12:ReloadEvents()
	
	GAME:GetCurrentGround():AddTempObject(food1)
	GAME:GetCurrentGround():AddTempObject(food2)
	GAME:GetCurrentGround():AddTempObject(food3)
	GAME:GetCurrentGround():AddTempObject(food4)
	GAME:GetCurrentGround():AddTempObject(food5)
	GAME:GetCurrentGround():AddTempObject(food6)
	GAME:GetCurrentGround():AddTempObject(food7)
	GAME:GetCurrentGround():AddTempObject(food8)
	GAME:GetCurrentGround():AddTempObject(food9)
	GAME:GetCurrentGround():AddTempObject(food10)
	GAME:GetCurrentGround():AddTempObject(food11)
	GAME:GetCurrentGround():AddTempObject(food12)
	
	--GAME:MoveCamera(160, 168, 1, false)
	
	local stopEating = false 
	UI:SetSpeaker('', false, "", -1, "", RogueEssence.Data.Gender.Unknown)
	SOUND:LoopSE('Dinner Eating')
	local coro1 = TASK:BranchCoroutine(function() GAME:FadeIn(40) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:MoveCamera(248, 168, 180, false)
												  GAME:WaitFrames(120)
												  stopEating = true end)
	local coro3 = TASK:BranchCoroutine(function() while not stopEating do 
													UI:WaitShowTimedDialogue("Crunch-munch! Om-nom-nom! Chomp-chomp!\nCrunch-munch! Om-nom-nom! Chomp-chomp!", 6)
												  end
												  SOUND:FadeOutSE('Dinner Eating', 120)
												  GAME:FadeOut(false, 120)  end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	GAME:WaitFrames(60)
	
	GAME:GetCurrentGround():RemoveTempObject(food1)
	GAME:GetCurrentGround():RemoveTempObject(food2)
	GAME:GetCurrentGround():RemoveTempObject(food3)
	GAME:GetCurrentGround():RemoveTempObject(food4)
	GAME:GetCurrentGround():RemoveTempObject(food5)
	GAME:GetCurrentGround():RemoveTempObject(food6)
	GAME:GetCurrentGround():RemoveTempObject(food7)
	GAME:GetCurrentGround():RemoveTempObject(food8)
	GAME:GetCurrentGround():RemoveTempObject(food9)
	GAME:GetCurrentGround():RemoveTempObject(food10)
	GAME:GetCurrentGround():RemoveTempObject(food11)
	GAME:GetCurrentGround():RemoveTempObject(food12)
	
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	GROUND:CharEndAnim(tropius)
	GROUND:CharEndAnim(noctowl)
	GROUND:CharEndAnim(audino)
	GROUND:CharEndAnim(snubbull)
	GROUND:CharEndAnim(growlithe)
	GROUND:CharEndAnim(zigzagoon)
	GROUND:CharEndAnim(mareep)
	GROUND:CharEndAnim(cranidos)
	GROUND:CharEndAnim(breloom)
	GROUND:CharEndAnim(girafarig)
	
	GROUND:CharSetEmote(hero, "", 0)
	GROUND:CharSetEmote(partner, "", 0)
	GROUND:CharSetEmote(tropius, "", 0)
	GROUND:CharSetEmote(noctowl, "", 0)
	GROUND:CharSetEmote(cranidos, "", 0)
	GROUND:CharSetEmote(mareep, "", 0)
	GROUND:CharSetEmote(girafarig, "", 0)
	GROUND:CharSetEmote(breloom, "", 0)
	GROUND:CharSetEmote(audino, "", 0)
	GROUND:CharSetEmote(snubbull, "", 0)
	GROUND:CharSetEmote(growlithe, "", 0)
	GROUND:CharSetEmote(zigzagoon, "", 0)
	
	GROUND:CharTurnToChar(hero, partner)
	GROUND:CharTurnToChar(partner, hero)
	GROUND:CharTurnToChar(growlithe, zigzagoon)
	GROUND:CharTurnToChar(zigzagoon, growlithe)
	
	GROUND:TeleportTo(breloom, 357, 174, Direction.Up)
	
	GROUND:CharSetAnim(tropius, "Sleep", true)
	GAME:WaitFrames(6)--to desync their breathing
	GROUND:CharSetAnim(cranidos, "Sleep", true)
	GAME:WaitFrames(6)
	GROUND:CharSetAnim(mareep, "EventSleep", true)
	GAME:WaitFrames(8)
	GROUND:CharSetAnim(girafarig, "Sleep", true)
	GAME:WaitFrames(6)
	GROUND:CharSetAnim(audino, "EventSleep", true)
	GAME:WaitFrames(4)
	GROUND:CharSetAnim(snubbull, "Sleep", true)
	
	GROUND:CharSetAnim(partner, "Idle", true)
	GROUND:CharSetAnim(hero, "Idle", true)
	GROUND:CharSetAnim(zigzagoon, "Idle", true)
	GROUND:CharSetAnim(growlithe, "Idle", true)

	--set it to night with a nice little camp fire
	GAME:GetCurrentGround().Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(campfire, RogueElements.Loc(bedRelativeX + 80, bedRelativeY + 62)))
	GROUND:RemoveMapStatus("dusk")
	GROUND:AddMapStatus("darkness")
	
	
	--Kino tells you to sleep. Also says that Phileas is still up to help guard. he doesnt need much sleep and he's best adapted for keeping watch at night
	--partner, hero, growlithe, and zigzagoon discuss the fun they've been having.
	--talk about their partners. talk about what might be at the end of the expedition
	--it's zigzagoon's first expedition, but growlithe has been with the guild as long as he can remember so he's been on them before (though not when he was young)
	--they eventually decide to go to sleep, partner and hero chat briefly, partner goes to sleep. Hero thinks about the strange feeling getting stronger. 
	--Hasn't brought it up because there hasn't been much reason to (could be more bullshit)
	--eventually decides he needs to get some rest and goes to sleep.
	GAME:FadeIn(40)
	SOUND:LoopSE('AMB_Fire_Loud')
	
	GAME:WaitFrames(40)
	GROUND:CharSetAnim(breloom, "Idle", true)
	GAME:WaitFrames(60)
	GROUND:CharEndAnim(breloom)
	
	GAME:WaitFrames(20)
	--freeze phileas briefly in the first frame of his sleep animation to simulate him nodding
	--TODO: Improve this scene with more animations if they're made for breloom or noctowl
	GROUND:CharSetAction(noctowl, RogueEssence.Ground.FrameGroundAction(noctowl.Position, noctowl.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Sleep"), 0))
	GAME:WaitFrames(20)
	GROUND:CharEndAnim(noctowl)
	GAME:WaitFrames(30)
	
	--expeditionTODO: Make this camera movement cleaner
	GROUND:CharAnimateTurnTo(breloom, Direction.Left, 4)
	GeneralFunctions.EightWayMoveRS(breloom, 312, 158, false, 1)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMoveRS(breloom, 240, 144, false, 1) 
											GROUND:CharAnimateTurnTo(breloom, Direction.UpRight, 4)
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(28)
											GAME:MoveCamera(264, 168, 16, false)
											GAME:MoveCamera(264, 140, 28, false)
											end)
	TASK:JoinCoroutines({coro1, coro2})
	
	UI:SetSpeaker(breloom)
	UI:WaitShowDialogue("Don't stay up too late guys.[pause=0] Everyone else has already gone to sleep!")
	
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GROUND:CharEndAnim(partner) GROUND:CharTurnToCharAnimated(partner, breloom, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) GROUND:CharEndAnim(hero) GROUND:CharTurnToCharAnimated(hero, breloom, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(12) GROUND:CharEndAnim(growlithe) GROUND:CharTurnToCharAnimated(growlithe, breloom, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(16) GROUND:CharEndAnim(zigzagoon) GROUND:CharTurnToCharAnimated(zigzagoon, breloom, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	GAME:WaitFrames(10)
	UI:WaitShowDialogue("This next dungeon's a doozy.[pause=0] You're gonna want to be all rested up to tackle it tomorrow.")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(zigzagoon)
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowDialogue("Don't worry,[pause=10] " .. breloom:GetDisplayName() .. ",[pause=10] we'll turn in soon.")
											UI:SetSpeakerEmotion("Happy")
											UI:WaitShowDialogue("Today was just so exciting,[pause=10] it's hard to fall asleep!")
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(16)
											GROUND:CharTurnToCharAnimated(breloom, zigzagoon, 4) 
											end)
	TASK:JoinCoroutines({coro1, coro2})
	GAME:WaitFrames(20)
 
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("Say,[pause=10] " .. breloom:GetDisplayName() .. "...[pause=0] You said everyone else is asleep,[pause=10] but " .. noctowl:GetDisplayName() .. " is still awake.")
	UI:WaitShowDialogue("Shouldn't he be getting some rest as well?")
	GAME:WaitFrames(12)
	
	GROUND:CharTurnToCharAnimated(breloom, partner, 4)
	UI:SetSpeaker(breloom)
	UI:WaitShowDialogue("Nah,[pause=10] " .. noctowl:GetDisplayName() .. " doesn't sleep much at night.[pause=0] A " .. _DATA:GetMonster('noctowl'):GetColoredName() .. " like him is built for the night!")
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Though,[pause=10] now that I think of it,[pause=10] I'm not sure when he gets his shuteye...")
	GAME:WaitFrames(20)
	
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Anyways,[pause=10] there's no need to fret over him.[pause=0] He's responsible,[pause=10] he knows where to find his rest.")
	UI:WaitShowDialogue("Speaking of,[pause=10] I'd better get some myself.[pause=0] Catch you all in the morning!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Ruff![pause=0] Good night,[pause=10] " .. breloom:GetDisplayName() .. "!")
	
	--GAME:WaitFrames(12)
	--GROUND:CharTurnToCharAnimated(breloom, growlithe, 4)
	--UI:SetSpeaker(breloom)
	--UI:SetSpeakerEmotion("Happy")
	--UI:WaitShowDialogue("Sleep tight![pause=0] Make sure you don't stay up too much longer.")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Joyous")
	--todo: improve breloom animations here if animations get added.
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:CharTurnToCharAnimated(growlithe, zigzagoon, 4)
											GROUND:CharSetEmote(growlithe, "glowing", 0)
											--UI:WaitShowDialogue("I dunno how I'm gonna get to sleep,[pause=10] ruff![pause=0] I'm still too[script=0] worked up![pause=0] Today was so much fun!", {function() TASK:BranchCoroutine(function() GROUND:CharSetAction(breloom, RogueEssence.Ground.FrameGroundAction(breloom.Position, breloom.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Sleep"), 0)) end) end})
											UI:WaitShowDialogue("I dunno how I'm gonna get to sleep,[pause=10] ruff![pause=0] I'm still too worked up![pause=0] Today was so much fun!")
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(18)
											GROUND:CharTurnToCharAnimated(zigzagoon, growlithe, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(30)
											GROUND:CharTurnToCharAnimated(partner, growlithe, 4) end)
	coro4 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(breloom, Direction.Up, 4)
											GeneralFunctions.EightWayMove(breloom, 192, 120, false, 1) 
											GeneralFunctions.EightWayMoveRS(breloom, bed10X + 13, bed10Y + 10, false, 1) 
											GROUND:CharAnimateTurnTo(breloom, Direction.Down, 4)					
											end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(growlithe, "", 0)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")

	coro1 = TASK:BranchCoroutine(function() UI:WaitShowDialogue("I know right?[pause=0] It was awesome adventuring with " .. audino:GetDisplayName() .. " and " .. snubbull:GetDisplayName() .. "!") 
											UI:WaitShowDialogue("Even though they usually stick to work around the guild,[pause=10] they're very skilled adventurers!")
											UI:WaitShowDialogue("I'm glad we got to team up with them.[pause=0] I had a nice time helping them prepare dinner too!")
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(16) GROUND:CharTurnToCharAnimated(growlithe, partner, 4 ) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(18) GROUND:CharAnimateTurnTo(zigzagoon, Direction.UpLeft, 4 ) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(8) 	--kino lies down here, but doesn't fall asleep immediately	
											GROUND:CharSetAction(breloom, RogueEssence.Ground.FrameGroundAction(breloom.Position, breloom.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Sleep"), 0))
											end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(zigzagoon)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Yeah![pause=0] And I was able to learn a lot from " .. mareep:GetDisplayName() .. " and " .. cranidos:GetDisplayName() .. ".")
	UI:WaitShowDialogue("I wrote down what I learned from them in the almanac I brought along with me.")
	UI:WaitShowDialogue("My alamancs are gonna be chock-full of new information by the time this expedition is over!")
	--these notes are gonna be about movement speed in his almanac later. Also L-Shaped positioning
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(growlithe)
	UI:WaitShowDialogue("I'm just happy to be adventuring with everyone again,[pause=10] ruff!")
	UI:WaitShowDialogue("Sentry duty is so boring...[pause=0] I much prefer being out with everyone in the guild!")
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("It's nice to be out in the field,[pause=10] ruff![pause=0] I can't wait to adventure more tomorrow!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(zigzagoon)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Same here![pause=0] Adventuring with everyone here is gonna teach me so much!")
	UI:WaitShowDialogue("I'm hoping I'll get to learn from you too,[pause=10] " .. partner:GetDisplayName() .. " and " .. hero:GetDisplayName() .. "![pause=0] It'd be great if we got paired tomorrow!")
	--really excited to see who we get to team up with tomorrow
	
	GAME:WaitFrames(20)
	--hero zones out
	GROUND:EntTurn(hero, Direction.Down)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("Teaming up would be awesome,[pause=10] but I don't know how much you'd learn from studying us.")
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("I think it's more likely we'd learn something from you!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(zigzagoon)
	UI:WaitShowDialogue("Oh,[pause=10] don't say that![pause=0] There's always something to learn from others,[pause=10] no matter who they are.")
	UI:WaitShowDialogue("I'm confident we can both learn from each other!")
	GAME:WaitFrames(20)
	
	UI:WaitShowDialogue("You know,[pause=10] if you want,[pause=10] I could share with you some of the things I learned today.")
	UI:WaitShowDialogue("That way we can start the mutual learning process!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("That would be great![pause=0] Let's do it!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(zigzagoon)
	UI:WaitShowDialogue("Alright![pause=0] Let me start with what I learned about moves that affect movement...")

	--use this to flag the side conversation to stop
	local stopTalking = false
	
	SOUND:FadeOutSE('AMB_Fire_Loud', 60)	
	GAME:WaitFrames(20)
	--he falls asleep
	GROUND:CharSetAnim(breloom, "Sleep", true)
	GAME:WaitFrames(10)
	GAME:MoveCamera(213, 140, 51, false)
	GAME:WaitFrames(20)
	UI:SetSpeaker('', false, hero.CurrentForm.Species, hero.CurrentForm.Form, hero.CurrentForm.Skin, hero.CurrentForm.Gender)
	UI:SetSpeakerEmotion("Worried")
	--hero zones out during this conversation
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowDialogue("(.........)")
											UI:WaitShowDialogue("(Today was fun,[pause=10] but something's been bothering me and I can't get my mind off of it.)") 
											UI:WaitShowDialogue("(The strange tension...[pause=0] I've been feeling it ever since " .. breloom:GetDisplayName() .. " and " .. girafarig:GetDisplayName() .. " got back.)")
											UI:WaitShowDialogue("(What's more is that it's been growing a little more intense each day we've been on the road.)")
											UI:WaitShowDialogue("(I thought that maybe I was just excited about the expedition...)")
											UI:WaitShowDialogue("(And while I am excited,[pause=10] I'm certain now this tension is something different.)")
											UI:WaitShowDialogue("(It's like it's urging me to keep moving forward.[pause=0] I would have done that anyways,[pause=10] but...)")
											stopTalking = true
											UI:WaitShowDialogue("(It does make me wonder why I'm having these strange feelings in the first place.[pause=0] What do they mean?)") 
											UI:WaitShowDialogue("(What triggered[script=0] them all those times in the past?)", {function() TASK:BranchCoroutine(function() GROUND:CharSetEmote(partner, "question", 1) end) end}) 
											UI:WaitShowDialogue("(Why is the feeling growing stronger[script=0] with each day that passes on this expedition?)", {function() TASK:BranchCoroutine(function() GROUND:CharSetEmote(partner, "happy", 3) end) end}) 
											UI:WaitShowDialogue("(Could [script=0]they be related somehow?)", {function() TASK:BranchCoroutine(function() GROUND:CharSetEmote(partner, "happy", 3) end) end})  
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											while not stopTalking do 
												GROUND:CharSetAnim(zigzagoon, "Idle", true)
												GROUND:CharSetEmote(zigzagoon, "happy", 0)
												GAME:WaitFrames(60)
												GROUND:CharEndAnim(zigzagoon)
												GROUND:CharSetEmote(zigzagoon, "", 0)
												GAME:WaitFrames(40)	
												if stopTalking then break end
												
												GROUND:CharSetAnim(partner, "Idle", true)
												GROUND:CharSetEmote(partner, "happy", 0)
												GAME:WaitFrames(60)
												GROUND:CharEndAnim(partner)
												GROUND:CharSetEmote(partner, "", 0)
												GAME:WaitFrames(40)
												if stopTalking then break end												
												
												GROUND:CharSetAnim(growlithe, "Idle", true)
												GROUND:CharSetEmote(growlithe, "happy", 0)
												GAME:WaitFrames(60)
												GROUND:CharEndAnim(growlithe)
												GROUND:CharSetEmote(growlithe, "", 0)
												GAME:WaitFrames(40)			
			
											end
											
											GROUND:CharTurnToCharAnimated(partner, hero, 4)
											GROUND:CharTurnToCharAnimated(growlithe, hero, 4)
											GROUND:CharTurnToCharAnimated(zigzagoon, hero, 4) end)
	TASK:JoinCoroutines({coro1, coro2})

	SOUND:FadeInSE('AMB_Fire_Loud', 60)
	GAME:WaitFrames(30)
	GROUND:CharSetEmote(partner, "happy", 0)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue(hero:GetDisplayName() .. "!")
	
	GAME:WaitFrames(10)
	GROUND:CharSetEmote(partner, "", 0)
	GeneralFunctions.EmoteAndPause(hero, "Exclaim", true)
	GAME:WaitFrames(10)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	GAME:WaitFrames(20)
	
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Are you feeling alright?[pause=0] I kept calling your name but you weren't responding!")
	UI:WaitShowDialogue("You looked zoned out.[pause=0] You must be feeling pretty exhausted!")
	
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(partner, growlithe, 4)
	GROUND:CharTurnToCharAnimated(hero, zigzagoon, 4)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Well,[pause=10] it is getting late.[pause=0] I'm sure we're all tired after today!")
	UI:WaitShowDialogue("Let's hit the hay for the night.[pause=0] We need our sleep if we're gonna do our best tomorrow!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(zigzagoon)
	UI:WaitShowDialogue("Agreed.[pause=0] My mind's still racing,[pause=10] but I'll just have to try to sleep anyways!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Ruff![pause=0] Good night everyone!")
	
	GAME:WaitFrames(60)
	SOUND:FadeOutSE('AMB_Fire_Loud', 60)
	GAME:FadeOut(false, 60)
	
	GAME:WaitFrames(120)
	
	
	--setup things for the morning
	GROUND:CharSetAnim(zigzagoon, 'EventSleep', true)
	GROUND:CharSetAnim(growlithe, 'Sleep', true)
	GROUND:CharSetAnim(hero, 'EventSleep', true)
	GROUND:CharSetAnim(partner, 'EventSleep', true)
	GROUND:CharEndAnim(audino)
	GROUND:CharEndAnim(tropius)
	
	GROUND:TeleportTo(audino, 205, 158, Direction.Down)
	GROUND:TeleportTo(tropius, 312, 152, Direction.Left)
	GROUND:TeleportTo(noctowl, 336, 176, Direction.Left)

	GROUND:EntTurn(zigzagoon, Direction.Right)
	GROUND:EntTurn(hero, Direction.Right)
	GROUND:EntTurn(partner, Direction.Left)
	GROUND:EntTurn(growlithe, Direction.Down)
	
	GAME:MoveCamera(212, 160, 1, false)
	
	
	--cleanup things for the morning
	--remove the fire, remove darkness
	GAME:GetCurrentGround().Decorations[0].Anims:RemoveAt(12)
	GROUND:RemoveMapStatus("darkness")
		
	UI:SetAutoFinish(true)
	UI:WaitShowVoiceOver("The next morning...\n\n", -1)
	UI:SetAutoFinish(false)
	
	
	
	GAME:WaitFrames(60)
	UI:SetSpeaker(audino)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Wake up sleepyheads![pause=0] It's a bright new day!")
	GAME:FadeIn(40)
	GAME:WaitFrames(20)

	SOUND:PlayBattleSE("DUN_Heal_Bell")
	GROUND:CharSetAction(audino, RogueEssence.Ground.PoseGroundAction(audino.Position, audino.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GAME:WaitFrames(100)
	GROUND:CharEndAnim(audino)
	GAME:WaitFrames(20)
	
	--Everyone wakes up, besides Kino
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GeneralFunctions.Shake(hero)
											GAME:WaitFrames(20)
											GeneralFunctions.DoAnimation(hero, 'Wake')
											GAME:WaitFrames(20)
											GROUND:CharTurnToCharAnimated(hero, audino, 4)
											end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.Shake(partner)
											GAME:WaitFrames(20)
											GeneralFunctions.DoAnimation(partner, 'Wake') 
											GAME:WaitFrames(20)
											GROUND:CharTurnToCharAnimated(partner, audino, 4)
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.Shake(zigzagoon)
											GAME:WaitFrames(20)
											GeneralFunctions.DoAnimation(zigzagoon, 'Wake')
											GAME:WaitFrames(20)
											GROUND:CharTurnToCharAnimated(zigzagoon, audino, 4)
											end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GeneralFunctions.Shake(growlithe)
											GAME:WaitFrames(70)
											GROUND:CharEndAnim(growlithe)
											GAME:WaitFrames(20)
											GROUND:CharTurnToCharAnimated(growlithe, audino, 4)
											end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(16)
											GeneralFunctions.Shake(snubbull)
											GAME:WaitFrames(90)
											GROUND:CharEndAnim(snubbull)
											GAME:WaitFrames(20)
											GROUND:CharTurnToCharAnimated(snubbull, audino, 4)
											end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GeneralFunctions.Shake(mareep)
											GAME:WaitFrames(20)
											GeneralFunctions.DoAnimation(mareep, 'Wake')
											GAME:WaitFrames(20)
											GROUND:CharTurnToCharAnimated(mareep, audino, 4)
											end)
	coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(16)
											GeneralFunctions.Shake(cranidos)
											GAME:WaitFrames(10)
											GeneralFunctions.Shake(cranidos)
											GAME:WaitFrames(70)
											GROUND:CharEndAnim(cranidos)
											GAME:WaitFrames(20)
											GROUND:CharTurnToCharAnimated(cranidos, audino, 4)
											end)
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GeneralFunctions.Shake(girafarig)
											GAME:WaitFrames(80)
											GROUND:CharEndAnim(girafarig)
											GAME:WaitFrames(20)
											GROUND:CharTurnToCharAnimated(girafarig, audino, 4)
											end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8})
	
	SOUND:PlayBGM("Do Your Best, As Always!.ogg", true)
	UI:WaitShowDialogue("G-good morning everyone![pause=0] I hope you all slept well!")
	UI:WaitShowDialogue("It's time to get back on the r-road![pause=0] We'll all need to work hard to get p-past this next area!")
	
	GAME:WaitFrames(40)
	GeneralFunctions.EmoteAndPause(audino, "Notice", true)
	GROUND:CharTurnToCharAnimated(audino, breloom, 4)
	GAME:WaitFrames(10)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(breloom:GetDisplayName() .. "![pause=0] It's t-time to get up!")
	
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(breloom:GetDisplayName() .. "?")

	SOUND:FadeOutBGM(60)	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMoveRS(audino, 160, 144, false, 1)
											GeneralFunctions.EightWayMove(audino, 160, 121, false, 1) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(hero, audino, 4, Direction.DownLeft) end)
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(partner, audino, 4, Direction.Left) end)
	coro4 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(cranidos, audino, 4, Direction.Up) end)
	coro5 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(mareep, audino, 4, Direction.Up) end)
	coro6 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(zigzagoon, audino, 4, Direction.UpLeft) end)
	coro7 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(girafarig, audino, 4, Direction.UpRight) end)
	coro8 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(snubbull, audino, 4, Direction.UpLeft) end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8})

	GAME:WaitFrames(10)
	GeneralFunctions.Complain(audino)
	UI:SetSpeakerEmotion("Shouting")
	UI:WaitShowDialogue(breloom:GetDisplayName() .. "!!!")
	GAME:WaitFrames(20)
	
	SOUND:PlayBGM("Guildmaster Wigglytuff.ogg", true)
	UI:SetSpeaker(breloom)
	UI:SetSpeakerEmotion("Sigh")
	UI:WaitShowDialogue("...zzzZZZzzz...[pause=0] Nnnggh...[pause=0] Five more minutes...")
	GAME:WaitFrames(20)
	
	GeneralFunctions.EmoteAndPause(audino, "Sweatdrop", true)
	GAME:WaitFrames(10)
	UI:SetSpeaker(audino)
	UI:SetSpeakerEmotion("Sigh")
	UI:WaitShowDialogue("Th-this may take a while...")
	GAME:WaitFrames(10)
	GROUND:CharAnimateTurnTo(audino, Direction.DownRight, 4)
	--UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Could the rest of you please start packing up the camp while I wake him up?")
	GAME:WaitFrames(40)
	
	SOUND:FadeOutBGM(60)
	GAME:FadeOut(false, 60)
	
	GROUND:CharEndAnim(breloom)	
		
	GROUND:TeleportTo(tropius, 320, 120, Direction.Down)
	GROUND:TeleportTo(noctowl, 280, 128, Direction.Down)

	GROUND:TeleportTo(partner, 256, 160, Direction.UpRight)
	GROUND:TeleportTo(hero, 256, 192, Direction.UpRight)

	GROUND:TeleportTo(breloom, 288, 160, Direction.Up)
	GROUND:TeleportTo(girafarig, 288, 192, Direction.Up)

	GROUND:TeleportTo(snubbull, 320, 160, Direction.Up)
	GROUND:TeleportTo(audino, 320, 192, Direction.Up)
	
	GROUND:TeleportTo(mareep, 352, 160, Direction.Up)
	GROUND:TeleportTo(cranidos, 352, 192, Direction.Up)
	
	GROUND:TeleportTo(growlithe, 384, 160, Direction.UpLeft)
	GROUND:TeleportTo(zigzagoon, 384, 192, Direction.UpLeft)

	GeneralFunctions.CenterCamera({snubbull, tropius})

	--remove beds
	GAME:GetCurrentGround().Decorations[0].Anims:RemoveAt(0)
	GAME:GetCurrentGround().Decorations[0].Anims:RemoveAt(0)
	GAME:GetCurrentGround().Decorations[0].Anims:RemoveAt(0)
	GAME:GetCurrentGround().Decorations[0].Anims:RemoveAt(0)
	GAME:GetCurrentGround().Decorations[0].Anims:RemoveAt(0)
	GAME:GetCurrentGround().Decorations[0].Anims:RemoveAt(0)
	GAME:GetCurrentGround().Decorations[0].Anims:RemoveAt(0)
	GAME:GetCurrentGround().Decorations[0].Anims:RemoveAt(0)
	GAME:GetCurrentGround().Decorations[0].Anims:RemoveAt(0)
	GAME:GetCurrentGround().Decorations[0].Anims:RemoveAt(0)
	GAME:GetCurrentGround().Decorations[0].Anims:RemoveAt(0)
	GAME:GetCurrentGround().Decorations[0].Anims:RemoveAt(0)

	GAME:WaitFrames(60)
	
	GAME:FadeIn(40)
	SOUND:PlayBGM("Spring Cave.ogg", true)

	UI:SetSpeaker(tropius)
	UI:WaitShowDialogue("Howdy Pokémon![pause=0] I trust that everyone's feeling rested and ready to go!")
	UI:WaitShowDialogue("This next dungeon is known as " .. tunnel:GetColoredName() .. ".")
	UI:WaitShowDialogue("It doesn't look it from out here,[pause=10] but this passage through the rockface is blazing hot!")
	UI:WaitShowDialogue("Once we pass through it,[pause=10] we'll be at the foot of the mountains where " .. ruins:GetColoredName() .. " are!")
	GAME:WaitFrames(20)
	GROUND:CharTurnToChar(tropius, breloom)
	UI:WaitShowDialogue(breloom:GetDisplayName() .. ",[pause=10] now that you're finally awake,[pause=10] could you tell us about this mystery dungeon?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(breloom)
	UI:WaitShowDialogue("Sure thing,[pause=10] Guildmaster!")
	GAME:WaitFrames(10)
	
	--coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
	--										GROUND:MoveInDirection(breloom, Direction.Up, 16, false, 1) 
	--										GROUND:CharAnimateTurnTo(breloom, Direction.Down, 4)
	--										end)
	--coro2 = TASK:BranchCoroutine(function() GROUND:AnimateInDirection(noctowl, "Walk", Direction.Down, Direction.Up, 8, 1, 1) end)
	
	--TASK:JoinCoroutines({coro1, coro2})


	coro1 = TASK:BranchCoroutine(function() UI:WaitShowDialogue("The tunnel is long and narrow.[pause=0] It shouldn't be too hard for you to find your way forward.")
											UI:WaitShowDialogue("But,[pause=10] like the name suggests,[pause=10] this place is also hot hot hot![pause=0] There's lava everywhere!")
											UI:SetSpeakerEmotion("Worried")
											UI:WaitShowDialogue("...Well,[pause=10] sort of.")
											UI:WaitShowDialogue("The lava in the tunnel is... inconsistent?[pause=0] Sometimes there's lava and other times there's none at all!")
											UI:WaitShowDialogue("Once we got far enough,[pause=10] the tunnel would be flooded with lava![pause=0] We had a lot of trouble in those parts.")
											UI:WaitShowDialogue("You should all be careful and change up how you maneuver based on the lava level!")
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(12) 
											GROUND:CharAnimateTurnTo(growlithe, Direction.Left, 4)										
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(14) 
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.Left, 4)										
											end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(18) 
											GROUND:CharAnimateTurnTo(cranidos, Direction.UpLeft, 4)
											end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(16) 
											GROUND:CharAnimateTurnTo(mareep, Direction.Left, 4)
											end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(22) 
											GROUND:CharAnimateTurnTo(snubbull, Direction.Left, 4)
											end)	
	coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(14) 
											GROUND:CharAnimateTurnTo(audino, Direction.UpLeft, 4)
											end)	
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) 
											GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
											end)	
	coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(30) 
											GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4)
											end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9})
	
	GAME:WaitFrames(20)
		
	UI:SetSpeaker(tropius)
	GROUND:EntTurn(tropius, Direction.Down)
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowDialogue("Alright everyone,[pause=10] you heard him.[pause=0] Be careful in there!")
											UI:WaitShowDialogue("With all that lava,[pause=10] everyone should prepare for burns and Fire-type opponents.")
											--UI:WaitShowDialogue("Maybe i make a comment about the unstability being especially worrying") --KINO will comment on the instability being strange. Tropius doesn't need to be the one to foreshadow every time, too spoonfeedy i think.
											UI:WaitShowDialogue("I want all our teams to take caution when traveling through here.[pause=0] Make sure to keep each other safe!")
											UI:WaitShowDialogue("And remember,[pause=10] " .. noctowl:GetDisplayName() .. " and I have extra supplies if you're struggling with the dungeon.")
											UI:WaitShowDialogue("Now,[pause=10] it's time to announce the teams!")
											UI:WaitShowDialogue("Our first team will be " .. mareep:GetDisplayName() .. ",[pause=10] " .. cranidos:GetDisplayName() .. ",[pause=10] " .. audino:GetDisplayName() .. ",[pause=10] and " .. snubbull:GetDisplayName() .. ".")
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(12) 
											GROUND:CharAnimateTurnTo(growlithe, Direction.UpLeft, 4)										
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(14) 
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.UpLeft, 4)										
											end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(18) 
											GROUND:CharAnimateTurnTo(cranidos, Direction.Up, 4)
											end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(16) 
											GROUND:CharAnimateTurnTo(mareep, Direction.Up, 4)
											end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(22) 
											GROUND:CharAnimateTurnTo(snubbull, Direction.Up, 4)
											end)	
	coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(14) 
											GROUND:CharAnimateTurnTo(audino, Direction.Up, 4)
											end)	
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) 
											GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4)
											end)	
	coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(14) 
											GROUND:CharAnimateTurnTo(breloom, Direction.Up, 4)
											end)	
	--coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(30) 
	--										GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4)
	--										end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8})	
	
	GAME:WaitFrames(10)
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(2)
											GROUND:CharAnimateTurnTo(growlithe, Direction.Left, 4)
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.Left, 4)
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharAnimateTurnTo(cranidos, Direction.Left, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:CharAnimateTurnTo(mareep, Direction.DownLeft, 4)
											end)
	coro5 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(audino, Direction.UpRight, 4) end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(snubbull, Direction.Right, 4) 
											end)							 
	coro7 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Right, 4) end)
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(hero, Direction.Right, 4) end)
	coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(breloom, Direction.Right, 4) end)
	coro10 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharAnimateTurnTo(girafarig, Direction.Right, 4) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9, coro10})	
	GAME:WaitFrames(20)
	
	local heal_bell = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Skill]:Get("heal_bell")
	UI:SetSpeaker(audino)
	UI:WaitShowDialogue("I guess w-we're teaming up this time![pause=0] I'll do my best to keep us healthy with " .. heal_bell:GetColoredName() .. "!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(cranidos)
	UI:WaitShowTimedDialogue("Hmmph,[pause=10] stuck with the housekeepers of the-", 40)
	GAME:WaitFrames(20)
	
	GeneralFunctions.DoubleHop(mareep)
	GROUND:CharSetEmote(mareep, "happy", 0)
	GROUND:CharSetAnim(mareep, "Idle", true)
	UI:SetSpeaker(mareep)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Ya-a-a-ay![pause=0] I've never been on an adventure with you two before!")
	UI:WaitShowDialogue("I'm amped to see what you ga-a-a-als can do![pause=0] Aren't you as well,[pause=10] " .. cranidos:GetDisplayName() .. "?")
	GAME:WaitFrames(20)
	
	GROUND:CharEndAnim(mareep)
	GROUND:CharSetEmote(mareep, "", 0)
	UI:SetSpeaker(cranidos)
	UI:SetSpeakerEmotion("Surprised")
	GROUND:CharSetEmote(cranidos, "sweating", 1)
	UI:WaitShowDialogue("Oh,[pause=10] uh...[pause=0] Yeah![pause=0] I can't wait!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(tropius)
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowDialogue("That leaves " .. partner:GetDisplayName() .. ",[pause=10] " .. hero:GetDisplayName() .. ",[pause=10] " .. zigzagoon:GetDisplayName() .. ",[pause=10] and " .. growlithe:GetDisplayName() .. " for team two.")
								 end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(12) 
											GROUND:CharAnimateTurnTo(growlithe, Direction.UpLeft, 4)										
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(14) 
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.UpLeft, 4)										
											end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(18) 
											GROUND:CharAnimateTurnTo(cranidos, Direction.Up, 4)
											end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(16) 
											GROUND:CharAnimateTurnTo(mareep, Direction.Up, 4)
											end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(22) 
											GROUND:CharAnimateTurnTo(snubbull, Direction.Up, 4)
											end)	
	coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(14) 
											GROUND:CharAnimateTurnTo(audino, Direction.Up, 4)
											end)	
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(20) 
											GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4)
											end)	
	coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(30) 
											GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4)
											end)
	coro10 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(breloom, Direction.Up, 4) end)
	local coro11 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharAnimateTurnTo(girafarig, Direction.Up, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9, coro10, coro11})
	
	GAME:WaitFrames(10)
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(2)
											GROUND:CharAnimateTurnTo(growlithe, Direction.Left, 4)
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.Left, 4)
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharAnimateTurnTo(cranidos, Direction.Right, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:CharAnimateTurnTo(mareep, Direction.Right, 4)
											end)
	coro5 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(audino, Direction.Left, 4) end)
	coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(snubbull, Direction.Left, 4) 
											end)							 
	coro7 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Right, 4) end)
	coro8 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharAnimateTurnTo(hero, Direction.Right, 4) end)
	coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(4)
											GROUND:CharAnimateTurnTo(breloom, Direction.DownLeft, 4) end)
	coro10 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharAnimateTurnTo(girafarig, Direction.Left, 4) end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9, coro10})	
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Looks like we made it onto the same team![pause=0] Imagine that!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Ruff![pause=0] I'm glad we're teaming with you![pause=0] This is gonna be a load of fun,[pause=10] ruff!")
	GAME:WaitFrames(40)
	

	GROUND:CharTurnToChar(tropius, growlithe)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Worried")
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowDialogue(growlithe:GetDisplayName() .. "...[pause=0] This place is very dangerous.")
											UI:WaitShowDialogue("Please...[pause=0] Don't be too reckless,[pause=10] OK?") 
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(12)
											GROUND:CharAnimateTurnTo(growlithe, Direction.UpLeft, 4)
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(41)
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.UpLeft, 4)
											end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(18)
											GROUND:CharAnimateTurnTo(cranidos, Direction.Up, 4) end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(16)
											GROUND:CharAnimateTurnTo(mareep, Direction.Up, 4)
											end)
	coro6 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(audino, Direction.Up, 4) end)
	coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(14)
											GROUND:CharAnimateTurnTo(snubbull, Direction.Up, 4) 
											end)							 
	coro8 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4) end)
	coro9 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4) end)
	coro10 = TASK:BranchCoroutine(function() GAME:WaitFrames(14)
											 GROUND:CharAnimateTurnTo(breloom, Direction.Up, 4) end)
	coro11 = TASK:BranchCoroutine(function() GAME:WaitFrames(18)
											 GROUND:CharAnimateTurnTo(girafarig, Direction.Up, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7, coro8, coro9, coro10, coro11})
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(growlithe)
	UI:WaitShowDialogue("Don't worry,[pause=10] " .. tropius:GetDisplayName() .. "![pause=0] I'll be careful!")
	GAME:WaitFrames(20)
	
	GROUND:CharTurnToCharAnimated(tropius, partner, 4)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("That goes for you two and " .. zigzagoon:GetDisplayName() .. " as well.[pause=0] Protect each other in there.")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	--UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("We'll do our best,[pause=10] Guildmaster![pause=0] You can count on us!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Thank you.[pause=0] I'm putting my trust in you.")
	GAME:WaitFrames(30)
	
	
	GROUND:EntTurn(tropius, Direction.Down)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("...That covers everything.[pause=0] We should all get moving.")
	UI:WaitShowDialogue("Like before,[pause=10] take some time now to prepare yourselves.")
	UI:WaitShowDialogue("When your team is ready,[pause=10] head into the tunnel towards our last stop before " .. ruins:GetColoredName() .. ".")
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Alright Pokémon,[pause=10] let's get to it!")
	GAME:WaitFrames(20)
		
	--well we have our team. Let's get ready and roll out.
	GROUND:CharSetEmote(growlithe, "happy", 0)
	GROUND:CharSetEmote(zigzagoon, "happy", 0)
	GROUND:CharSetEmote(mareep, "happy", 0)
	GROUND:CharSetEmote(breloom, "happy", 0)
	GROUND:CharSetEmote(audino, "happy", 0)	
	GROUND:CharSetEmote(partner, "happy", 0)

	--turn pokemon so pose is appropriate
	GROUND:EntTurn(growlithe, Direction.Up)
	GROUND:EntTurn(zigzagoon, Direction.Up)
	GROUND:EntTurn(snubbull, Direction.Up)
	GROUND:EntTurn(audino, Direction.Up)
	GROUND:EntTurn(mareep, Direction.Up)
	GROUND:EntTurn(cranidos, Direction.Up)
	GROUND:EntTurn(breloom, Direction.Up)
	GROUND:EntTurn(girafarig, Direction.Up)
	GROUND:EntTurn(partner, Direction.Up)
	GROUND:EntTurn(hero, Direction.Up)
	
	GROUND:CharSetAction(growlithe, RogueEssence.Ground.PoseGroundAction(growlithe.Position, growlithe.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(zigzagoon, RogueEssence.Ground.PoseGroundAction(zigzagoon.Position, zigzagoon.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(breloom, RogueEssence.Ground.PoseGroundAction(breloom.Position, breloom.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(girafarig, RogueEssence.Ground.PoseGroundAction(girafarig.Position, girafarig.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(cranidos, RogueEssence.Ground.PoseGroundAction(cranidos.Position, cranidos.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(mareep, RogueEssence.Ground.PoseGroundAction(mareep.Position, mareep.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(audino, RogueEssence.Ground.PoseGroundAction(audino.Position, audino.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
	GROUND:CharSetAction(snubbull, RogueEssence.Ground.PoseGroundAction(snubbull.Position, snubbull.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))	
	GROUND:CharSetAction(partner, RogueEssence.Ground.PoseGroundAction(partner.Position, partner.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))	
	GROUND:CharSetAction(hero, RogueEssence.Ground.PoseGroundAction(hero.Position, hero.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))	
	UI:SetSpeaker('[color=#00FFFF]Everyone[color]', true, "", -1, "", RogueEssence.Data.Gender.Unknown)	
	UI:WaitShowDialogue("HURRAH!")
	
	GAME:WaitFrames(60)
	GAME:FadeOut(false, 60)
	
	--Clean up the existing spawns, then call SetupGround to spawn them in.
	--Record the level of Rin and Coco for later use. Check to make sure they exist before doing so (mostly just so I can run this scene without needing them in the party)
	if GAME:GetPlayerPartyCount() > 2 then 
		SV.GuildSidequests.SnubbullLevel = GAME:GetPlayerPartyMember(2).Level
		SV.GuildSidequests.AudinoLevel = GAME:GetPlayerPartyMember(3).Level
	end
	
	--Default the party DESTRUCTIVELY to delete Rin and Coco.
	GeneralFunctions.DefaultParty(false, true)
	--reinitialize the hero and partner variables after respawning the party.
	--Failing to do this has later functions try to teleport the "old" versions of them, causing a phantom glitch. dunno why, since i thought i fixed default party...
	hero = CH('PLAYER')
	partner = CH('Teammate1')
	partner.CollisionDisabled = true
	
	--Setup Hyko and Almotz.
	local growlithe_id = RogueEssence.Dungeon.MonsterID("growlithe", 0, "normal", Gender.Male)
	local growlithe_monster = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, growlithe_id, SV.GuildSidequests.GrowlitheLevel, "flash_fire", 0)
	growlithe_monster.Discriminator = _DATA.Save.Rand:Next()--tbh idk what this is lol
	growlithe_monster.Nickname = CharacterEssentials.GetCharacterName('Growlithe', true)
	growlithe_monster.MetAt = "Adventurer's Guild"
	growlithe_monster.IsPartner = true
	growlithe_monster.IsFounder = true
	
	growlithe_monster:ReplaceSkill("flame_wheel", 0, true)
	growlithe_monster:ReplaceSkill("bite", 1, true)
	growlithe_monster:ReplaceSkill("close_combat", 2, true)
	growlithe_monster:ReplaceSkill("roar", 3, false)
		
	GAME:AddPlayerTeam(growlithe_monster)
	growlithe_monster:FullRestore()
	local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("GuildmateInteract")
    growlithe_monster.ActionEvents:Add(talk_evt)
	growlithe_monster:RefreshTraits()

	local zigzagoon_id = RogueEssence.Dungeon.MonsterID("zigzagoon", 0, "normal", Gender.Male)
	local zigzagoon_monster = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, zigzagoon_id, SV.GuildSidequests.ZigzagoonLevel, "pickup", 0)
	zigzagoon_monster.Discriminator = _DATA.Save.Rand:Next()--tbh idk what this is lol
	zigzagoon_monster.Nickname = CharacterEssentials.GetCharacterName('Zigzagoon', true)
	zigzagoon_monster.MetAt = "Adventurer's Guild"
	zigzagoon_monster.IsPartner = true
	zigzagoon_monster.IsFounder = true
	
	zigzagoon_monster:ReplaceSkill("headbutt", 0, true)
	zigzagoon_monster:ReplaceSkill("helping_hand", 1, false)
	zigzagoon_monster:ReplaceSkill("pin_missile", 2, true)
	zigzagoon_monster:ReplaceSkill("odor_sleuth", 3, false)
		
	GAME:AddPlayerTeam(zigzagoon_monster)
	zigzagoon_monster:FullRestore()
	local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("GuildmateInteract")
    zigzagoon_monster.ActionEvents:Add(talk_evt)
	zigzagoon_monster:RefreshTraits()
	


	GAME:GetCurrentGround():RemoveTempChar(breloom)
	GAME:GetCurrentGround():RemoveTempChar(girafarig)
	GAME:GetCurrentGround():RemoveTempChar(tropius)
	GAME:GetCurrentGround():RemoveTempChar(noctowl)
	GAME:GetCurrentGround():RemoveTempChar(snubbull)
	GAME:GetCurrentGround():RemoveTempChar(audino)
	GAME:GetCurrentGround():RemoveTempChar(growlithe)
	GAME:GetCurrentGround():RemoveTempChar(zigzagoon)
	GAME:GetCurrentGround():RemoveTempChar(cranidos)
	GAME:GetCurrentGround():RemoveTempChar(mareep)
		
	tropius, noctowl, mareep, cranidos, snubbull, audino, breloom, girafarig, tail = 
		CharacterEssentials.MakeCharactersFromList({
			{'Tropius', 336, 112, Direction.Left},
			{'Noctowl', 304, 112, Direction.Right},
			{'Mareep', 276, 260, Direction.UpLeft},
			{'Cranidos', 240, 260, Direction.UpRight},
			{'Snubbull', 276, 224, Direction.DownLeft},
			{'Audino', 240, 224, Direction.DownRight},
			{'Breloom', 144, 80, Direction.DownLeft},
			{'Girafarig', 120, 104, Direction.UpRight}
		})
		
	--set hyko and almotz to spawn from the spawners, then spawn them
	GROUND:SpawnerSetSpawn("TEAMMATE_2", GAME:GetPlayerPartyMember(2))
	growlithe = GROUND:SpawnerDoSpawn("TEAMMATE_2")
		
	GROUND:SpawnerSetSpawn("TEAMMATE_3", GAME:GetPlayerPartyMember(3))
	zigzagoon = GROUND:SpawnerDoSpawn("TEAMMATE_3")

	  	
	GROUND:CharEndAnim(partner)	
	GROUND:CharEndAnim(hero)	
	GROUND:CharSetEmote(partner, "", 0)
	GROUND:TeleportTo(hero, 258, 176, Direction.Down)
	GROUND:TeleportTo(partner, 258, 144, Direction.Down)
	GAME:MoveCamera(0, 0, 1, true)
	
	
	GAME:WaitFrames(20)
	GAME:FadeIn(60)

	SV.Chapter5.FinishedTunnelIntro = true
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)
	GAME:CutsceneMode(false)
end


function searing_tunnel_entrance_ch_5.Tropius_Action(chara, activator)
	--Will hand out the supplies if needed this time. Will be in a bit of a panic if you wipe. You can also
	--speak to him after wiping to the boss, which prompts Hyko to get you to not give details about the boss
	--since he wouldn't want the guildmaster to flip
end 

function searing_tunnel_entrance_ch_5.Noctowl_Action(chara, activator)
	--Guildmaster insisted on handing out potential supplies to your team, so talk to him.
	--...Why does the Guildmaster worry over Hyko so much? There's a reason... But it's not my story to tell.
	
	--He sleeps if you die and visit him. This is where he finds his rest after all.
	
end 

function searing_tunnel_entrance_ch_5.Breloom_Action(chara, activator)
	--Reiterates how the place is unstable. It's strange, since he's heard of this place before, and it was never said to be unstable then! (his memory is good so HMMM)
end 

function searing_tunnel_entrance_ch_5.Girafarig_Action(chara, activator)
	--Tells you about treasure boxes
end 

function searing_tunnel_entrance_ch_5.Growlithe_Action(chara, activator)

end 

function searing_tunnel_entrance_ch_5.Zigzagoon_Action(chara, activator)

end 

function searing_tunnel_entrance_ch_5.Audino_Action(chara, activator)
	--We're bound to get burned with all the lava and fire-types in there. Heal bell will be useful for us in there!

end 

function searing_tunnel_entrance_ch_5.Snubbull_Action(chara, activator)


end 

function searing_tunnel_entrance_ch_5.Mareep_Action(chara, activator)

end 

function searing_tunnel_entrance_ch_5.Cranidos_Action(chara, activator)

end 




function searing_tunnel_entrance_ch_5.DiedCutscene()

	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local growlithe = CH('Teammate2')
	local zigzagoon = CH('Teammate3')
	local tropius = CH('Tropius')
	local noctowl = CH('Noctowl')
	local coro1, coro2, coro3, coro4
	
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	SOUND:StopBGM()
	GROUND:TeleportTo(partner, 396, 184, Direction.Right)
	GROUND:TeleportTo(hero, 356, 184, Direction.Left)
	
	--GROUND:CharSetAnim(noctowl, "Sleep", true)
	GAME:MoveCamera(384, 148, 1, false)
	
	--todo: if growlithe gets eventsleep/wake animations, use them here.
	GROUND:CharSetAnim(partner, "EventSleep", true)
	GROUND:CharSetAnim(hero, "EventSleep", true)
	GAME:WaitFrames(10)--to offset their breathing cycles
	GROUND:CharSetAnim(growlithe, "Sleep", true)
	GROUND:CharSetAnim(zigzagoon, "EventSleep", true)
			
	GAME:FadeIn(40)
	SOUND:PlayBGM('Spring Cave.ogg', true)
	GAME:WaitFrames(60)
	
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("H-hey![pause=0] Are you all OK!?[pause=0] " .. growlithe:GetDisplayName() .. "!?")
	GAME:WaitFrames(30)
	
	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Pain")
	UI:WaitShowDialogue("...Huh?")
	GAME:WaitFrames(10)
	
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.DoAnimation(hero, 'Wake')
											GAME:WaitFrames(10) 
											GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
											GAME:WaitFrames(40)
											GeneralFunctions.LookAround(hero, 3, 4, false, false, false, Direction.Left)
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GeneralFunctions.DoAnimation(partner, 'Wake')
											GAME:WaitFrames(15) 
											GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
											GAME:WaitFrames(40)
											GeneralFunctions.LookAround(partner, 3, 4, false, false, true, Direction.Right)
											end)	
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GeneralFunctions.DoAnimation(zigzagoon, 'Wake')
											GAME:WaitFrames(10) 
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.Down, 4)
											GAME:WaitFrames(40)
											GeneralFunctions.LookAround(zigzagoon, 3, 4, false, false, true, Direction.Down)
											end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(26) 
										    GeneralFunctions.DoAnimation(growlithe, 'Rumble')
											GAME:WaitFrames(12)
											GROUND:CharAnimateTurnTo(growlithe, Direction.Down, 4)
											GAME:WaitFrames(40)
											GeneralFunctions.LookAround(growlithe, 3, 4, false, false, false, Direction.Down) 
											end)

	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	GAME:WaitFrames(30)
	
	coro1 = TASK:BranchCoroutine(function () GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end)
	coro2 = TASK:BranchCoroutine(function () GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) end)
	coro3 = TASK:BranchCoroutine(function () GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4) end)
	coro4 = TASK:BranchCoroutine(function () GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4) end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Surprised")
	GROUND:CharSetEmote(tropius, "sweating", 1)
	UI:WaitShowDialogue("Are you alright!?[pause=0] What happened!?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("We're OK,[pause=10] Guildmaster.[pause=0] Just encountered some trouble in the tunnel.")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(growlithe)
	UI:WaitShowDialogue("Yeah,[pause=10] but it's nothing we can't handle,[pause=10] ruff!")
	UI:WaitShowDialogue("We'll get it done for sure next time!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("If you say so...[pause=0] But please,[pause=10] be more careful!")
	UI:WaitShowDialogue("I don't want to see you wiped out like that again.")
	GAME:WaitFrames(10)
	GROUND:CharAnimateTurnTo(tropius, Direction.UpLeft, 4)
	GAME:WaitFrames(60)
	GROUND:CharAnimateTurnTo(tropius, Direction.Down, 4)
	
	UI:WaitShowDialogue("Here,[pause=10] these supplies should help you get through the tunnel.[pause=0] Please,[pause=10] take them!")
	GAME:WaitFrames(20)
	GeneralFunctions.RewardItem("food_apple")
	GeneralFunctions.RewardItem("berry_oran")
	GeneralFunctions.RewardItem("berry_oran")
	GeneralFunctions.RewardItem("berry_leppa")
	GeneralFunctions.RewardItem("berry_rawst")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Good luck,[pause=10] and stay safe.[pause=0] I know you can do it.")
	GAME:WaitFrames(20)
	
	GeneralFunctions.PanCamera()

	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(zigzagoon, growlithe, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:CharTurnToCharAnimated(growlithe, zigzagoon, 4) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	GROUND:CharEndAnim(noctowl)
	SV.Chapter5.PlayTempTunnelScene = false

	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)
	GROUND:CharTurnToChar(partner, hero)
	GAME:CutsceneMode(false)
	
end

function searing_tunnel_entrance_ch_5.EscapedCutscene()

	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local growlithe = CH('Teammate2')
	local zigzagoon = CH('Teammate3')
	local tropius = CH('Tropius')
	local noctowl = CH('Noctowl')
	local coro1, coro2, coro3, coro4
	
	GAME:CutsceneMode(true)
	SOUND:StopBGM()
	AI:DisableCharacterAI(partner)
	GROUND:TeleportTo(partner, 396, 184, Direction.Up)
	GROUND:TeleportTo(hero, 356, 184, Direction.Up)
	GROUND:EntTurn(zigzagoon, Direction.Down)
	GROUND:EntTurn(growlithe, Direction.Down)
	
	--GROUND:CharSetAnim(noctowl, "Sleep", true)
	GAME:MoveCamera(384, 148, 1, false)
			
	GAME:FadeIn(40)
	SOUND:PlayBGM('Spring Cave.ogg', true)
	GAME:WaitFrames(20)
		
	UI:SetSpeaker(zigzagoon)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("Hmm...[pause=0] It's tough in there...")
	GAME:WaitFrames(20)

	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Surprised")
	GROUND:CharSetEmote(tropius, "sweating", 1)
	UI:WaitShowDialogue("Are you alright!?[pause=0] What happened!?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowDialogue("We're OK,[pause=10] Guildmaster.[pause=0] We encountered some trouble in the tunnel so we decided to retreat.") end)
	coro2 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(growlithe, Direction.Up, 4) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:CharAnimateTurnTo(zigzagoon, Direction.Up, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(growlithe)
	UI:WaitShowDialogue("Yeah,[pause=10] but it's nothing we can't handle,[pause=10] ruff!")
	UI:WaitShowDialogue("We'll get it done for sure next time!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(tropius)
	UI:WaitShowDialogue("Well,[pause=10] alright...[pause=0] I'm just glad you decided to escape rather than endanger yourselves further.")
	GAME:WaitFrames(10)
	GROUND:CharAnimateTurnTo(tropius, Direction.UpLeft, 4)
	GAME:WaitFrames(60)
	GROUND:CharAnimateTurnTo(tropius, Direction.Down, 4)
	
	UI:WaitShowDialogue("Here,[pause=10] these supplies should help you get through the tunnel.[pause=0] Please,[pause=10] take them!")
	GAME:WaitFrames(20)
	GeneralFunctions.RewardItem("food_apple")
	GeneralFunctions.RewardItem("berry_oran")
	GeneralFunctions.RewardItem("berry_rawst")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(tropius)
	UI:WaitShowDialogue("Good luck,[pause=10] and stay safe.[pause=0] I know you can do it!")
	GAME:WaitFrames(20)
	
	
	GeneralFunctions.PanCamera()

	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(zigzagoon, growlithe, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:CharTurnToCharAnimated(growlithe, zigzagoon, 4) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	SV.Chapter5.PlayTempTunnelScene = false

	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)
	GROUND:CharTurnToChar(partner, hero)
	GAME:CutsceneMode(false)
end

function searing_tunnel_entrance_ch_5.RetreatedCutscene()

	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local growlithe = CH('Teammate2')
	local zigzagoon = CH('Teammate3')
	local tropius = CH('Tropius')
	local noctowl = CH('Noctowl')
	local coro1, coro2, coro3, coro4, coro5
	
	GAME:CutsceneMode(true)
	GROUND:Hide('Dungeon_Entrance')
	SOUND:StopBGM()
	AI:DisableCharacterAI(partner)
	GROUND:TeleportTo(hero, 544, 148, Direction.Left)
	GROUND:TeleportTo(partner, 544, 172, Direction.Left)
	GROUND:TeleportTo(growlithe, 560, 144, Direction.Left)
	GROUND:TeleportTo(zigzagoon, 560, 176, Direction.Left)
	GROUND:TeleportTo(tropius, 376, 128, Direction.Down)
	--GROUND:CharSetAnim(noctowl, "Sleep", true)
	GROUND:CharSetAnim(tropius, "Idle", true)
	GAME:MoveCamera(424, 168, 1, false)
	
	
	GAME:FadeIn(40)
	SOUND:PlayBGM('Spring Cave.ogg', true)
	GAME:WaitFrames(10)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Surprised")
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMoveRS(partner, 436, 188, false, 1)
											GROUND:MoveInDirection(partner, Direction.Left, 24, false, 1)											
										    end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GeneralFunctions.EightWayMoveRS(hero, 436, 164, false, 1)
											GROUND:MoveInDirection(hero, Direction.Left, 24, false, 1)
											end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GeneralFunctions.EightWayMoveRS(growlithe, 448, 172, false, 1)
											GROUND:MoveInDirection(growlithe, Direction.Left, 8, false, 1)
											end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(24)
											GeneralFunctions.EightWayMoveRS(zigzagoon, 448, 198, false, 1)
											GROUND:MoveInDirection(zigzagoon, Direction.Left, 8, false, 1)
										    end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(100)
											GROUND:CharEndAnim(tropius)
											GeneralFunctions.EmoteAndPause(tropius, "Notice", true)
											GROUND:CharAnimateTurnTo(tropius, Direction.DownRight, 4)
											UI:WaitShowDialogue("Oh,[pause=10] you're back![pause=0] Did something happen in the tunnel?")
											end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(growlithe)
	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(growlithe, tropius, 4)
											UI:WaitShowDialogue("Nope,[pause=10] nothing happened.[pause=0] We're all fine,[pause=10] ruff!")
										    end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:CharTurnToCharAnimated(partner, tropius, 4)
										    end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(14)
											GROUND:CharTurnToCharAnimated(hero, tropius, 4)
										    end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharTurnToCharAnimated(zigzagoon, tropius, 4)
										    end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(tropius, "Question", true)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Then why are you back here?[pause=0] We need to keep moving forward!")
	UI:WaitShowDialogue("It's important that we all get to the next base camp before nightfall.")
	
	GAME:WaitFrames(10)
	GeneralFunctions.EmoteAndPause(partner, "Sweating", true)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("Wh-whoops.[pause=0] Sorry,[pause=10] Guildmaster.[pause=0] We'll get right back in there.")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(tropius)
	UI:WaitShowDialogue("It's alright.[pause=0] You should still have enough time to make it through the tunnel before the sun sets.")
	GAME:WaitFrames(10)
	GROUND:CharAnimateTurnTo(tropius, Direction.UpLeft, 4)
	GAME:WaitFrames(60)
	GROUND:CharTurnToCharAnimated(tropius, hero, 4)
	
	UI:WaitShowDialogue("Here,[pause=10] take some supplies.[pause=0] They'll help you get back through the tunnel faster.")
	GAME:WaitFrames(10)
	coro1 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(tropius, Direction.DownRight, 20, false, 1) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(growlithe, tropius) end)
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(partner, tropius) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	GAME:WaitFrames(10)
	GeneralFunctions.RewardItem("food_apple")
	GeneralFunctions.RewardItem("berry_oran")
	GeneralFunctions.RewardItem("berry_rawst")
	
	GAME:WaitFrames(20)
	coro1 = TASK:BranchCoroutine(function() GROUND:AnimateInDirection(tropius, "Walk", Direction.DownRight, Direction.UpLeft, 20, 1, 1) end)
	coro2 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(growlithe, tropius) end)
	coro3 = TASK:BranchCoroutine(function() GeneralFunctions.FaceMovingCharacter(partner, tropius) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	UI:SetSpeaker(tropius)
	UI:WaitShowDialogue("Good luck,[pause=10] and stay safe.[pause=0] I know you can do it!")
	GAME:WaitFrames(20)
	
	GeneralFunctions.PanCamera()

	coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(zigzagoon, growlithe, 4) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:CharTurnToCharAnimated(growlithe, zigzagoon, 4) end)
	coro3 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3})
	
	SV.Chapter5.PlayTempTunnelScene = false
	GROUND:Unhide('Dungeon_Entrance')
	
	--he needs to face back down
	GROUND:EntTurn(tropius, Direction.Down)
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)
	GROUND:CharTurnToChar(partner, hero)
	GAME:CutsceneMode(false)		
end


function searing_tunnel_entrance_ch_5.Dungeon_Entrance_Touch(obj, activator)

	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local growlithe = CH('Teammate2')
	local zigzagoon = CH('Teammate3')
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("searing_tunnel") 
	
	local result = false
	
	GROUND:CharSetAnim(partner, "None", true)
	GROUND:CharSetAnim(hero, "None", true)
	local coro1 = TASK:BranchCoroutine(function() result = GeneralFunctions.StartPartnerYesNo("Are we ready to roll out,[pause=10] " .. hero:GetDisplayName() .. "?") end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GROUND:CharTurnToCharAnimated(growlithe, hero, 4) GROUND:CharSetAnim(growlithe, "None", true) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(16) GROUND:CharTurnToCharAnimated(zigzagoon, hero, 4) GROUND:CharSetAnim(zigzagoon, "None", true) end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3})
	GAME:WaitFrames(10)		
	if result then 
		GROUND:Hide('Dungeon_Entrance')
		local face_direction = Direction.DownLeft
		if SV.Chapter5.TunnelLastExitReason ~= '' then 
			face_direction = Direction.Left
		end
		
		coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(hero, 480, 176, false, 1)
												GROUND:CharAnimateTurnTo(hero, face_direction, 4)
												GROUND:CharSetAnim(hero, "None", true) end)	
		coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, 480, 144, false, 1)
												GROUND:CharAnimateTurnTo(partner, face_direction, 4)
												GROUND:CharSetAnim(partner, "None", true) end) 
		coro3 = TASK:BranchCoroutine(function() GeneralFunctions.PanCamera(nil, nil, false, nil, GAME:GetCameraCenter().X, 168) end)
		TASK:JoinCoroutines({coro1, coro2, coro3})
		
		--different movement pattern depending on where they are
		if SV.Chapter5.TunnelLastExitReason == '' then--haven't entered yet
			coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(growlithe, 448, 148, false, 1)
													GROUND:CharAnimateTurnTo(growlithe, Direction.Right, 4) 
													GROUND:CharSetAnim(growlithe, "None", true) end)
			coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
													GeneralFunctions.EightWayMove(zigzagoon, 432, 216, false, 1)
													GeneralFunctions.EightWayMove(zigzagoon, 448, 172, false, 1)
													GROUND:CharAnimateTurnTo(zigzagoon, Direction.Right, 4)
													GROUND:CharSetAnim(zigzagoon, "None", true) end)
		elseif SV.Chapter5.TunnelLastExitReason == 'Retreated' then
			coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(growlithe, 448, 148, false, 1)
													GROUND:CharAnimateTurnTo(growlithe, Direction.Right, 4) 
													GROUND:CharSetAnim(growlithe, "None", true) end)
			coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) 
													GeneralFunctions.EightWayMove(zigzagoon, 448, 172, false, 1)
													GROUND:CharAnimateTurnTo(zigzagoon, Direction.Right, 4)
													GROUND:CharSetAnim(zigzagoon, "None", true) end)
		else--died or escaped or retreated
			coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) 
													GeneralFunctions.EightWayMoveRS(growlithe, 448, 148, false, 1)
													GROUND:CharAnimateTurnTo(growlithe, Direction.Right, 4) 
													GROUND:CharSetAnim(growlithe, "None", true) end)
			coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMoveRS(zigzagoon, 448, 172, false, 1)
													GROUND:CharAnimateTurnTo(zigzagoon, Direction.Right, 4)
													GROUND:CharSetAnim(zigzagoon, "None", true) end)
		end
		
		coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GeneralFunctions.FaceMovingCharacter(hero, zigzagoon) end)
		local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GeneralFunctions.FaceMovingCharacter(partner, growlithe) end)
		TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
		
		UI:SetSpeaker(growlithe)
		UI:SetSpeakerEmotion("Happy")
		
		if not SV.Chapter5.EnteredTunnel then 
			UI:WaitShowDialogue("Ready to go,[pause=10] ruff?[pause=0] Finally![pause=0] Let's get to it!")
		elseif not SV.Chapter5.EncounteredBoss then
			UI:WaitShowDialogue("Ready to go,[pause=10] ruff?[pause=0] Finally![pause=0] Let's do it this time!")
		else
			UI:WaitShowDialogue("Ready to go,[pause=10] ruff?[pause=0] Alright![pause=0] We'll get past those " .. _DATA:GetMonster('slugma'):GetColoredName() .. " for sure this time!")
		end 
		
		
		GAME:WaitFrames(10)
		coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
												GROUND:MoveInDirection(partner, Direction.Right, 72, false, 1) end)			
		coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
												GROUND:CharAnimateTurnTo(hero, Direction.Right, 4)
												GROUND:MoveInDirection(hero, Direction.Right, 72, false, 1) end)		
		coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(24)
												GROUND:MoveInDirection(growlithe, Direction.Right, 72, false, 1) end)			
		local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(30)
													  GROUND:MoveInDirection(zigzagoon, Direction.Right, 72, false, 1) end)	
		local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(40) GAME:FadeOut(false, 40) end)


		TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})	
		
		GeneralFunctions.EndConversation(partner)
		SV.Chapter5.EnteredTunnel = true
		GAME:EnterDungeon("searing_tunnel", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)

	else
		UI:WaitShowDialogue("OK.[pause=0] Let's get ourselves ready,[pause=10] and we'll move out then!")
		coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EndConversation(partner) end)
		coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(growlithe, zigzagoon, 4) GROUND:CharEndAnim(growlithe) end)
		coro3 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(zigzagoon, growlithe, 4) GROUND:CharEndAnim(zigzagoon) end)
		TASK:JoinCoroutines({coro1, coro2, coro3})
	end

end

