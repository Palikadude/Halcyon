require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

mount_windswept_entrance_ch_5 = {}

function mount_windswept_entrance_ch_5.SetupGround()	

end

--for testing 
function mount_windswept_entrance_ch_5.SetParty()
	--Clean up the existing spawns, then call SetupGround to spawn them in.
	--Record the level of Hyko and Almotz for later use. Check to make sure they exist before doing so (mostly just so I can run this scene without needing them in the party)
	if GAME:GetPlayerPartyCount() > 2 then 
		SV.GuildSidequests.GrowlitheLevel = GAME:GetPlayerPartyMember(2).Level
		SV.GuildSidequests.ZigzagoonLevel = GAME:GetPlayerPartyMember(3).Level
	end
	
	--Default the party DESTRUCTIVELY to delete Hyko and Almotz.
	GeneralFunctions.DefaultParty(false, true)
	--reinitialize the hero and partner variables after respawning the party.
	--Failing to do this has later functions try to teleport the "old" versions of them, causing a phantom glitch. dunno why, since i thought i fixed default party...
	hero = CH('PLAYER')
	partner = CH('Teammate1')
	partner.CollisionDisabled = true
	
	--Setup Ganlon and Shuca.
	local cranidos_id = RogueEssence.Dungeon.MonsterID("cranidos", 0, "normal", Gender.Male)
	local cranidos_monster = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, cranidos_id, SV.GuildSidequests.CranidosLevel, "mold_breaker", 0)
	cranidos_monster.Discriminator = _DATA.Save.Rand:Next()--tbh idk what this is lol
	cranidos_monster.Nickname = CharacterEssentials.GetCharacterName('Cranidos', true)
	cranidos_monster.MetAt = "Adventurer's Guild"
	cranidos_monster.IsPartner = true
	cranidos_monster.IsFounder = true
	
	cranidos_monster:ReplaceSkill("headbutt", 0, true)
	cranidos_monster:ReplaceSkill("pursuit", 1, false)
	cranidos_monster:ReplaceSkill("iron_head", 2, true)
	cranidos_monster:ReplaceSkill("smack_down", 3, true)
		
	GAME:AddPlayerTeam(cranidos_monster)
	cranidos_monster:FullRestore()
	local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("GuildmateInteract")
    cranidos_monster.ActionEvents:Add(talk_evt)
	cranidos_monster:RefreshTraits()

	local mareep_id = RogueEssence.Dungeon.MonsterID("mareep", 0, "normal", Gender.Female)
	local mareep_monster = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mareep_id, SV.GuildSidequests.MareepLevel, "static", 0)
	mareep_monster.Discriminator = _DATA.Save.Rand:Next()--tbh idk what this is lol
	mareep_monster.Nickname = CharacterEssentials.GetCharacterName('Mareep', true)
	mareep_monster.MetAt = "Adventurer's Guild"
	mareep_monster.IsPartner = true
	mareep_monster.IsFounder = true
	
	mareep_monster:ReplaceSkill("thunder_shock", 0, true)
	mareep_monster:ReplaceSkill("thunder_wave", 1, false)
	mareep_monster:ReplaceSkill("take_down", 2, true)
	mareep_monster:ReplaceSkill("flatter", 3, false)
		
	GAME:AddPlayerTeam(mareep_monster)
	mareep_monster:FullRestore()
	local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("GuildmateInteract")
    mareep_monster.ActionEvents:Add(talk_evt)
	mareep_monster:RefreshTraits()
	
	
	--Assign importances to identify who they are. Do this instead of just checking species just in case randomizers down the road or something.
	local cTbl = LTBL(GAME:GetPlayerPartyMember(2))
	local mTbl = LTBL(GAME:GetPlayerPartyMember(3))
	
	cTbl.Importance = "Cranidos"
	mTbl.Importance = "Mareep"
end


function mount_windswept_entrance_ch_5.ArrivalCutscene()
	--It's already night when you arrive. Penticus is pacing around nervously wondering where you are before he realizes you're here
	--He runs up to hyko relieved and asks wtf happened. He went through the dungeon since it got late and you guys weren't here when he arrived.
	--You explain and he's super concerned that you had to fight an entire clan of Slugma.
	--He's impressed that you did it, and thanks the player team for doing a good job but he tells hyko that he pretty much had a panic attack wondering where he was and wants him to stay close for the rest of the expedition.
	--Hyko protests but eventually gives in seeing how worked up Penticus is. Penticus isn't acting entirely out of character, but obviously this is 
	--Phileas will explain at one point that the reason he and Penticus didn't find you when coming through the dungeon once it started late was probably because of how mystery dungeons shift. They're different everytime, it probably caused them to be brought a different way and so they didnt find you.
	
	--Partner at some point could say something like "I'd be really worked up too if something happened to player!". Player may be able to say something similar back. Could be laying it on too thick?

	--Later on, I was thinking of having Almotz/Rin/Coco kinda like, limp into camp after Windswept because they really struggled with it, and maybe they needed a save from Penticus for this, but this
	--may be a bit too drastic or rough on them. The expedition shouldn't be TOO depressing...


	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local tunnel = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('searing_tunnel')
	local steppe = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('vast_steppe')
	local mountain = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('mount_windswept')
	local ruins = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('cloven_ruins')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	SOUND:StopBGM()
	GAME:MoveCamera(276, 248, 1, false)
	GROUND:AddMapStatus("darkness")--nighttime
	
	--for debug purposes
	GAME:FadeOut(false, 1)
	
	local hay_bed = RogueEssence.Content.ObjAnimData('Hay_Bed', 1)
	local campfire = RogueEssence.Content.ObjAnimData('Campfire', 6)

	GROUND:TeleportTo(hero, 252, 396, Direction.Up)
	GROUND:TeleportTo(partner, 284, 396, Direction.Right)
	
	local audino, snubbull, girafarig, breloom, growlithe, zigzagoon, tropius, noctowl, mareep, cranidos = 
	CharacterEssentials.MakeCharactersFromList({
		{'Audino'},
		{'Snubbull'},
		{'Girafarig'},
		{'Breloom'},
		{'Growlithe', 292, 428, Direction.Up},
		{'Zigzagoon', 244, 428, Direction.Up},
		{'Tropius'},
		{'Noctowl'},
		{'Mareep'},
		{'Cranidos'}
	})
	
	
	--This is done like this so I can copy and paste this code into other scenes that have a similar set up and only change one value
	--to get all the beds and campfire to spawn relative to that spot.
	local bedRelativeX = 178
	local bedRelativeY = 164
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
	UI:WaitShowDialogue("Finally![pause=0] We're out of " .. tunnel:GetColoredName() .. "!")
	GAME:WaitFrames(20)
	UI:SetSpeaker(growlithe)
	UI:WaitShowDialogue("Oh,[pause=10] it's already dark![pause=0] I hope we're not too late...")
	GAME:WaitFrames(20)
	
	GAME:FadeIn(40)
	
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 92, 176, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames (10) GROUND:MoveToPosition(hero, 92, 144, false, 1) end)
	local coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(2) GROUND:MoveToPosition(growlithe, 60, 184, false, 1) end)
	local coro4 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:MoveToPosition(zigzagoon, 60, 136, false, 1) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})



end 

--Ganlon hasn't been getting to act like a jerk much this expedition; give him some opportunies for his jerkiness to shine through here