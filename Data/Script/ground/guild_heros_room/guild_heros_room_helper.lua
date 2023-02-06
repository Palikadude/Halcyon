--contains helper functions used by guild_heros_room scripts.
guild_heros_room_helper = {}
------------------------------------
--Special Functions
------------------------------------
function guild_heros_room_helper.Bedtime(generic, continueSong)
--if generic is true, do a generic nighttime cutscene and relevant processing. 
--if generic is false, just make the room look like it's night and put the duo in bed.
	if generic == nil then generic = false end
	if continueSong == nil then continueSong = false end
	
	local groundObj = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Night_Window", 1, 0, 0), 
													RogueElements.Rect(176, 56, 64, 64),
													RogueElements.Loc(0, 0), 
													false, 
													"Window_Cutscene")
	groundObj:ReloadEvents()
	GAME:GetCurrentGround():AddTempObject(groundObj)
	GROUND:AddMapStatus("darkness")
	if not continueSong then SOUND:StopBGM() end--cut bgm so it doesn't kick in until we want it to, unless we want the previous track to continue on
	AI:DisableCharacterAI(CH('Teammate1'))

	local hero_bed = MRKR('Hero_Bed')
	local partner_bed = MRKR('Partner_Bed')
	GROUND:Hide("Save_Point")--disable bed saving
	GROUND:TeleportTo(CH('PLAYER'), hero_bed.Position.X, hero_bed.Position.Y, Direction.Right)
	GROUND:TeleportTo(CH('Teammate1'), partner_bed.Position.X, partner_bed.Position.Y, Direction.Left)
	GeneralFunctions.CenterCamera({CH('PLAYER'), CH('Teammate1')})

	
	--todo: generic 
	if generic then 
		local partner = CH('Teammate1')
		local hero = CH('PLAYER')
		GAME:CutsceneMode(true)
		GAME:FadeIn(40)
		SOUND:PlayBGM('Goodnight.ogg', true)
		GAME:WaitFrames(40)
		UI:SetSpeaker(partner)
		UI:WaitShowDialogue("Today was tiring.[pause=0] We should get some rest so we can give it our all tomorrow!")
		UI:WaitShowDialogue("OK,[pause=10] good night,[pause=10] " .. hero:GetDisplayName() .. ".")
		SOUND:FadeOutBGM(60)
		GAME:FadeOut(false, 60)
		SV.TemporaryFlags.Bedtime = false 
		GROUND:RemoveMapStatus("darkness")
		GAME:CutsceneMode(false)
		GAME:GetCurrentGround():RemoveTempObject(groundObj)
		GeneralFunctions.EndOfDay()--reset daily flags and increment day counter by 1

	end
end

function guild_heros_room_helper.Morning(generic)
	if generic == nil then generic = true end
	
	if generic then 
		GAME:FadeOut(false, 1)--fadeout if we aren't already
		local hero = CH('PLAYER')
		local partner = CH('Teammate1')
		GAME:CutsceneMode(true)
		AI:DisableCharacterAI(partner)
		UI:ResetSpeaker()
		SOUND:StopBGM()
		GROUND:CharSetAnim(hero, 'EventSleep', true)
		GROUND:CharSetAnim(partner, 'EventSleep', true)
		GROUND:Hide('Bedroom_Exit')--disable map transition object
		GROUND:Hide("Save_Point")--disable bed saving
		local hero_bed = MRKR('Hero_Bed')
		local partner_bed = MRKR('Partner_Bed')
		GROUND:TeleportTo(CH('PLAYER'), hero_bed.Position.X, hero_bed.Position.Y, Direction.Right)
		GROUND:TeleportTo(CH('Teammate1'), partner_bed.Position.X, partner_bed.Position.Y, Direction.Left)
		GeneralFunctions.CenterCamera({hero, partner})
		GAME:WaitFrames(90)--wait a bit just in case we didn't wait before starting this scene 

		local audino =
			CharacterEssentials.MakeCharactersFromList({
				{"Audino", 120, 204, Direction.UpRight},
			})
			
		UI:SetAutoFinish(true)
		UI:WaitShowVoiceOver("The next morning...\n\n", -1)
		UI:SetAutoFinish(false)
	
		GAME:WaitFrames(60)
		UI:SetSpeaker(audino)
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("Good morning sleepyheads![pause=0] It's a bright new day!")
		GAME:FadeIn(40)
		GAME:WaitFrames(20)
	
		GROUND:CharAnimateTurnTo(audino, Direction.Down, 4)
		GAME:WaitFrames(10)
		SOUND:PlayBattleSE("DUN_Heal_Bell")
		GROUND:CharSetAction(audino, RogueEssence.Ground.PoseGroundAction(audino.Position, audino.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
		GAME:WaitFrames(100)
		GROUND:CharEndAnim(audino)
		GAME:WaitFrames(10)
		GROUND:CharAnimateTurnTo(audino, Direction.Left, 4)
		GROUND:MoveToPosition(audino, 0, 204, false, 2)
		GAME:GetCurrentGround():RemoveTempChar(audino)
		GROUND:CharSetAnim(hero, "Laying", true)
		GROUND:CharSetAnim(partner, "Laying", true)

		coro1 = TASK:BranchCoroutine(function () GAME:WaitFrames(10)
												 GeneralFunctions.Shake(hero)
												 GAME:WaitFrames(20)
												 GeneralFunctions.DoAnimation(hero, 'Wake') 
												 --GROUND:CharAnimateTurnTo(hero, Direction.Down, 4) 
												 GAME:WaitFrames(20) end)
		coro2 = TASK:BranchCoroutine(function () GeneralFunctions.Shake(partner)
												 GAME:WaitFrames(20)
												 GeneralFunctions.DoAnimation(partner, 'Wake') 
												 --GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
												 GAME:WaitFrames(20) end)
		TASK:JoinCoroutines({coro1, coro2})
		
		GROUND:CharTurnToCharAnimated(partner, hero, 4)
		GROUND:CharTurnToCharAnimated(hero, partner, 4)
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Happy")
		SOUND:PlayBGM("Wigglytuff's Guild.ogg", true)
		UI:WaitShowDialogue("Good morning,[pause=10] " .. hero:GetDisplayName() .. "!")	
		GAME:WaitFrames(20)
		GeneralFunctions.PanCamera()
		GAME:WaitFrames(20)
		GROUND:CharEndAnim(hero)
		GROUND:CharEndAnim(partner)
		GROUND:Unhide("Bedroom_Exit")
		GROUND:Unhide("Save_Point")
		GAME:CutsceneMode(false)
		AI:EnableCharacterAI(partner)
		AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)
		
		SV.TemporaryFlags.JustWokeUp = true
		SV.TemporaryFlags.MorningWakeup = false
	end
	
end