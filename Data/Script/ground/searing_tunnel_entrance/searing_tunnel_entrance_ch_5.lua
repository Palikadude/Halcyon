require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

searing_tunnel_entrance_ch_5 = {}

function searing_tunnel_entrance_ch_5.SetupGround()	

end


--this is one long ass continuous cutscene
--TASK:BranchCoroutine(searing_tunnel_entrance_ch_5.ArrivalDinnerNightAndAddressCutscene)
function searing_tunnel_entrance_ch_5.ArrivalDinnerNightAndAddressCutscene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local tunnel = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('searing_tunnel')
	local steppe = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('vast_steppe')
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
	UI:WaitShowDialogue("We did it![pause=0] We cleared " .. steppe:GetColoredName() .. "!")
	GAME:WaitFrames(20)
	UI:SetSpeaker(snubbull)
	UI:WaitShowDialogue("Look ahead![pause=0] That must be the camp there.")
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
											GROUND:CharAnimateTurnTo(mareep, Direction.DownLeft, 4) end)
	local coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
											GROUND:CharEndAnim(zigzagoon) 
											GROUND:CharAnimateTurnTo(zigzagoon, Direction.Left, 4) end)
	local coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(8)
											GROUND:CharEndAnim(growlithe) 
											AI:DisableCharacterAI(growlithe)										
											GROUND:CharAnimateTurnTo(growlithe, Direction.Left, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6})
	
	UI:SetSpeaker(girafarig)
	UI:SetSpeakerEmotion("Happy")
	if SV.Chapter5.LostSteppe then
		UI:WaitShowDialogue("Oh,[pause=10] hey![pause=0] You guys made it,[pause=10] finally!")
		UI:WaitShowDialogue("We're just finishing setting up the camp.")
	else 
		UI:WaitShowDialogue("Oh,[pause=10] hey![pause=0] You guys made it here quick!")
		UI:WaitShowDialogue("We're still setting up the camp.")
	end
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(breloom)
	UI:WaitShowDialogue("We've got the setup covered,[pause=10] by the way.[pause=0] It's our job,[pause=10] after all!")
	UI:WaitShowDialogue("So feel free to settle in.[pause=0] I'm sure you're all tired after that " .. steppe:GetColoredName() .. ".")
	
	if SV.Chapter5.LostSteppe then
		UI:WaitShowDialogue("We'll probably have to wait a little while for the Guildmaster and " .. noctowl:GetDisplayName() .. " to get here.")
	else 
		UI:WaitShowDialogue("We'll probably have to wait a little while for the Guildmaster and the others to get here.")
	end
	
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Thanks,[pause=10] " .. breloom:GetDisplayName() .. "![pause=0] We'll rest in that case then.")
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
	
	GAME:WaitFrames(20)
	GeneralFunctions.EmoteAndPause(partner, "Question", true) 
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("What do you mean?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(snubbull)
	UI:WaitShowDialogue("A culinary adventure,[pause=10] of course. "  .. STRINGS:Format("\\u266A") .. "[pause=0]\nIt's time to prepare my next masterpiece!")
	UI:WaitShowDialogue("I found a wonderful (random unpalatable shit) during our travels that I think will make an excellent dish.") 
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(hero:GetDisplayName() .. ",[pause=10] " .. partner:GetDisplayName() .. "...[pause=0] Thank you for accompanying " .. audino:GetDisplayName() .. " and I today.")
	UI:WaitShowDialogue("That adventure was fun.[pause=0] We should team up again in the future. "  .. STRINGS:Format("\\u266A"))
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Yeah![pause=0] We had fun teaming up with you too![pause=0] We'll have to do it again soon!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(snubbull)
	UI:SetSpeakerEmotion("Special0")
	UI:WaitShowDialogue("Well,[pause=10] a chef's work is never done...[pause=0] I'd better get to it!")
	
	
	GAME:WaitFrames(10)
	UI:SetSpeaker(audino)
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(snubbull, 352, 112, false, 1) 
											end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(60) 
											GROUND:CharAnimateTurnTo(audino, Direction.UpRight, 4)
											UI:WaitShowDialogue("I s-should probably go help her.[pause=0] (It's getting late and it'll speed things up)")
											UI:SetSpeakerEmotion("Sigh")
											UI:WaitShowDialogue("Plus,[pause=10] there's a chance I can keep her ingredient use in check and our meal will still be edible...")
											UI:SetSpeakerEmotion("Normal")
											UI:WaitShowDialogue("Hey,[pause=10] would the two of you want to come help too?") end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(70)
											GROUND:CharAnimateTurnTo(partner, Direction.Left, 4) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(76)
											GROUND:CharAnimateTurnTo(hero, Direction.DownLeft, 4) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	GAME:WaitFrames(10)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Really?[pause=0] You want our help cooking?[pause=0] Neither of us have any experience in the kitchen...")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(audino)
	UI:WaitShowDialogue("Well sure![pause=0] I know we're d-done with the dungeon,[pause=10] so we don't have to team up anymore...")
	UI:WaitShowDialogue("But just because we're not assigned to each other anymore doesn't mean we can't still work together!")
	UI:WaitShowDialogue("And d-don't worry about having no experience cooking.")
	UI:SetSpeakerEmotion("Happy")
	GROUND:CharSetEmote(audino, "glowing", 0)
	UI:WaitShowDialogue("With some of the " .. '"delicacies" that ' .. snubbull:GetDisplayName() .. " makes, sometimes I feel like she doesn't either!")
	GAME:WaitFrames(20)
	
	GROUND:CharSetEmote(audino, "", 0)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Haha,[pause=10] I don't know if I'd go that far.[pause=0] But sure,[pause=10] I'd love to try and help!")

	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("What do you say,[pause=10] " .. hero:GetDisplayName() .. "?[pause=0] Are you feeling up to it?")
	GAME:WaitFrames(20)
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
	
	coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EightWayMove(partner, 352, 152, false, 1) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(32) 
											GeneralFunctions.EightWayMove(hero, 352, 152, false, 1) end)
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(28)
											GeneralFunctions.EightWayMove(audino, 352, 152, false, 1) end)
	coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(120)
											SOUND:FadeOutBGM(60)
											GAME:FadeOut(false, 60) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})
	
	GAME:WaitFrames(90)
	
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
	GROUND:TeleportTo(zigzagoon, bed4X + 13, bed4Y + 10, Direction.Up) 
	GROUND:TeleportTo(audino, bed5X + 13, bed5Y + 10, Direction.Up) 
	GROUND:TeleportTo(snubbull, bed6X + 13, bed6Y + 10, Direction.Up) 
	GROUND:TeleportTo(mareep, bed7X + 13, bed7Y + 10, Direction.Up) 
	GROUND:TeleportTo(cranidos, bed8X + 13, bed8Y + 10, Direction.Up) 
	GROUND:TeleportTo(girafarig, bed9X + 13, bed9Y + 10, Direction.Down) 
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
													RogueElements.Rect(bed4X + 13, bed4Y + 17, 16, 16),
													RogueElements.Loc(0, 0), 
													false, 
													"Food4")
	local food5 = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Food_Flipped", 1, 0, 0), 
													RogueElements.Rect(bed5X + 13, bed5Y + 17, 16, 16),
													RogueElements.Loc(0, 0), 
													false, 
													"Food5")
	local food6 = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Food_Flipped", 1, 0, 0), 
													RogueElements.Rect(bed6X + 13, bed6Y + 17, 16, 16),
													RogueElements.Loc(0, 0), 
													false, 
													"Food6")
	local food7 = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Food_Flipped", 1, 0, 0), 
													RogueElements.Rect(bed7X + 13, bed7Y + 17, 16, 16),
													RogueElements.Loc(0, 0), 
													false, 
													"Food7")
	local food8 = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Food_Flipped", 1, 0, 0), 
													RogueElements.Rect(bed8X + 13, bed8Y + 17, 16, 16),
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
	local food11 = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Food", 1, 0, 0), 
													RogueElements.Rect(bed11X + 13, bed11Y + 17, 16, 16),
													RogueElements.Loc(0, 0), 
													false,
													--RogueEssence.Ground.GroundEntity.EEntityTriggerTypes.Action, --need this as the overload instead of the false for itemanimdata
													"Food11")	
	local food12 = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Food", 1, 0, 0), 
													RogueElements.Rect(bed12X - 20, bed12Y, 16, 16),
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
	GAME:WaitFrames(60)--don't load in too fast. give it a second to transition properly.
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
	
	GROUND:CharAnimateTurnTo(breloom, Drection.Left, 4)

 
	--Kino tells you to sleep. Also says that Phileas is still up to help guard. he doesnt need much sleep and he's best adapted for keeping watch at night
	--partner, hero, growlithe, and zig discuss the fun they've been having.
	--talk about their partners. talk about what might be at the end of the expedition
	--it's zig's first expedition, but growlithe has been with the guild as long as he can remember so he's been on them before (though not when he was young)
	--they eventually decide to go to sleep, partner and hero chat briefly, partner goes to sleep. Hero thinks about the strange feeling getting stronger. 
	--Hasn't brought it up because there hasn't been much reason to (could be more bullshit)
	--eventually decides he needs to get some rest and goes to sleep.
	

end
