require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'

metano_town_ch_1 = {}



function metano_town_ch_1.PartnerChickenOutCutscene()
	--Cutscene where partner chickens out of signing up at the guild, played after very first cutscene in relic forest
	local partner = CH('Teammate1')
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	GAME:MoveCamera(648, 1208, 1, false)
	GROUND:TeleportTo(partner, 840, 1232, Direction.Left)
	GAME:FadeIn(20)

	--todo: hide everyone that isn't being used for the cutscene, or put the function
	--to do so in the init for the map itself
	--todo: clean up some of the pauses, add an OWOWOWOW when you trip and a pause into sitting down and feeling sorry for yourself
	
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
	UI:WaitShowDialogue("C'mon " .. partner:GetDisplayName() .. ",[pause=10] you can do it t-this time...[pause=0] J-just have some confidence...")
	UI:WaitShowDialogue("F-focus on yourself...[pause=0] Don't think about the o-others...")

	
	--they approach the guild, but get nervous and turn back
	GROUND:MoveToPosition(partner, 640, 1168, false, 1)
	GAME:WaitFrames(60)
	UI:SetSpeakerEmotion("Pain")
	UI:WaitShowDialogue('...')
	GROUND:MoveToPosition(partner, 640, 1136, false, 1)
	GAME:WaitFrames(40)
	SOUND:PlayBattleSE('EVT_Emote_Sweating')
	GROUND:CharSetEmote(partner, 5, 1)
	GAME:WaitFrames(40)
	GeneralFunctions.ShakeHead(partner, 4)

	--exit left
	UI:SetSpeakerEmotion('Shouting')
	UI:WaitShowDialogue("I can't do it!")
	GAME:WaitFrames(10)
	GROUND:MoveToPosition(partner, 640, 1200, false, 4)
	GeneralFunctions.MoveCharAndCamera(partner, 344, 1200, 4, true)

	
	--trip and fall like the MORON YOU ARE
	SOUND:PlayBattleSE('_UNK_EVT_014')--a decent tripping noise
	GROUND:CharPoseAnim(partner, 'Trip')
	GROUND:CharSetEmote(partner, 8, 1)
	UI:SetSpeakerEmotion('Pain')
	UI:WaitShowTimedDialogue('Oof!', 60)

	--partner ready to cry
	--todo: a little shake here before they start getting sobby
	local partner_species = DataManager.Instance.GetMonster(partner.CurrentForm.Species):GetColoredName()
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion('Teary-Eyed')
	UI:WaitShowDialogue("It happened again...[pause=0] I couldn't do it...")
	UI:WaitShowDialogue("My fear overcame me...[pause=0] I mean,[pause=10] what would they think of me?")
	UI:WaitShowDialogue("A " .. partner_species .. " with no partner,[pause=10] no field experience,[pause=10] asking to join[br] the guild of one of the greatest adventurers to ever live?")
	UI:WaitShowDialogue("I'd be laughed out of the room...")
--note: partner should later bring up that their fear of rejection/ridicule was all in their head, the guildmaster and co are actually quite nice
	
	--realize that with your bad logic, you just need to go into a mystery dungeon
	GAME:WaitFrames(80)
	GROUND:CharSetEmote(partner, 3, 1)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
	UI:SetSpeakerEmotion("Surprised")
	GAME:WaitFrames(20)
	GROUND:CharSetAnim(partner, 'None', true)
	UI:WaitShowDialogue("But wait!")
	UI:WaitShowDialogue("If I at least had some field experience,[pause=10] maybe they wouldn't be so harsh!")
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("But how could I get some experience?[pause=0] The only thing I can think of would be to trek a mystery dungeon...")
	local zone = RogueEssence.Data.DataManager.Instance.DataIndices[RogueEssence.Data.DataManager.DataType.Zone].Entries[50]
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("What mystery dungeon would I explore then?")
	UI:WaitShowDialogue("The only one I know of is " .. zone:GetColoredName() .. ".")

	GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
	GAME:WaitFrames(20)
	
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("The entrance to that place is by Altere Pond.")

	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("But mystery dungeons are dangerous,[pause=10] aren't they?[pause=0] Could I even make it through?")
	
	--todo: do a little hop
	GAME:WaitFrames(60)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("No![pause=0] I can't chicken out on this!")
	UI:WaitShowDialogue("If I can't brave a mystery dungeon then they'll never let me into the guild!")
	UI:WaitShowDialogue("I have to do this so I can achieve my dream!")
	
	--todo: a little sfx for the pose to show they're hyped?
	GROUND:CharPoseAnim(partner, 'Pose')
	GAME:WaitFrames(60)
	
	coro1 = TASK:BranchCoroutine(GROUND:_MoveToPosition(partner, 344, 1336, false, 1))
	GAME:WaitFrames(40)
	GAME:FadeOut(false, 20)
	TASK:JoinCoroutines({coro1})	
	
		
	
	GAME:FadeOut(false, 20)
	GAME:CutsceneMode(false)
	GAME:EnterGroundMap("altere_pond", "Main_Entrance_Marker")

end