require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

guild_guildmasters_room_ch_4 = {}


function guild_guildmasters_room_ch_4.Tropius_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then		
		local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('apricorn_grove')
		GeneralFunctions.StartConversation(chara, "Howdy,[pause=10] Team " .. GAME:GetTeamName() .. "![pause=0] Good luck exploring " .. zone:GetColoredName() .. " today!")
		if SV.Chapter3.TropiusGaveWand or SV.Chapter2.TropiusGaveReviver then 
			UI:WaitShowDialogue("Oh,[pause=10] and if you're looking for some help like before...")
		else
			UI:WaitShowDialogue("Oh,[pause=10] and if you're looking for some help...")
		end 
		UI:SetSpeakerEmotion("Joyous")
		GROUND:CharSetEmote(chara, "glowing", 0)
		UI:WaitShowDialogue("I have nothing to give you![pause=0] This is supposed to be a test of sorts,[pause=10] after all!")
		GAME:WaitFrames(20)
		GROUND:CharSetEmote(chara, "", 0)		
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("I will offer some advice,[pause=10] however.")
		UI:WaitShowDialogue("You should make use of the Apricorns you'll find in the dungeon to recruit a full team of four Pokémon.")
		UI:WaitShowDialogue("More allies will make overcoming any challenges you come across easier![pause=0] So aim to fill up your team!")
		SV.Chapter4.TropiusGaveAdvice = true
	else 
		local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('apricorn_grove')
		GeneralFunctions.StartConversation(chara, "Great work again you two exploring " .. zone:GetColoredName() .."![pause=0] I'm still in disbelief at the size of that Apricorn!", "Happy")
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("I hope you two are as excited for the upcoming expedition as I am!")
		UI:WaitShowDialogue(CharacterEssentials.GetCharacterName("Breloom") .. " and " .. CharacterEssentials.GetCharacterName("Girafarig") .. " will be back any day now,[pause=10] so keep up the good work and prepare yourselves until then!")
	end
	GeneralFunctions.EndConversation(chara)
end


function guild_guildmasters_room_ch_4.PresentApricornCutscene()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	local tropius = CH('Tropius')
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('apricorn_grove')
	GAME:CutsceneMode(true)
	GROUND:Hide('Bottom_Exit') 
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	GAME:MoveCamera(192, 120, 1, false) 
	SOUND:StopBGM()

	GROUND:TeleportTo(hero, 168, 256, Direction.Up)
	GROUND:TeleportTo(partner, 200, 256, Direction.Up)
	
	local noctowl = 
	CharacterEssentials.MakeCharactersFromList({
		{"Noctowl", 152, 120, Direction.Up}
	})
	
	local team2 = GAME:GetPlayerPartyMember(2)
	local team3 = GAME:GetPlayerPartyMember(3)
	
	
	local apricorn = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Yellow_Box", 1), --anim data. Don't set that number to 0 for valid anims
								 				 RogueElements.Rect(184, 136, 16, 16),--xy coords, then size
								  				 RogueElements.Loc(0, 0), --offset
												 true, 
												 "Apricorn_Big")--object entity name
	apricorn:ReloadEvents()
	GAME:GetCurrentGround():AddTempObject(apricorn)
	GROUND:ObjectSetDefaultAnim(apricorn, 'Apricorn_Big', 0, 0, 0,Direction.Down)
	GROUND:Hide(apricorn.EntName)
	
	--setup your teammates without using spawners
	local monster
	if team2 ~= nil then
		monster = RogueEssence.Dungeon.MonsterID(team2.CurrentForm.Species, team2.CurrentForm.Form, team2.CurrentForm.Skin, team2.CurrentForm.Gender)
		team2 = RogueEssence.Ground.GroundChar(monster, RogueElements.Loc(184, 288), Direction.Down, team2.Nickname, 'Teammate2')
		team2:ReloadEvents()
		GAME:GetCurrentGround():AddTempChar(team2)
	end
	
	if team3 ~= nil then
		monster = RogueEssence.Dungeon.MonsterID(team3.CurrentForm.Species, team3.CurrentForm.Form, team3.CurrentForm.Skin, team3.CurrentForm.Gender)
		team3 = RogueEssence.Ground.GroundChar(monster, RogueElements.Loc(216, 288), Direction.Down, team3.Nickname, 'Teammate3')
		team3:ReloadEvents()
		GAME:GetCurrentGround():AddTempChar(team3)
	end
	
	GROUND:CharTurnToChar(tropius, noctowl)
	GROUND:CharTurnToChar(noctowl, tropius)
	
	GROUND:CharSetAnim(tropius, "Idle", true)
	GROUND:CharSetAnim(noctowl, "Idle", true)
	
	GAME:FadeIn(40)
	SOUND:PlayBGM("Wigglytuff's Guild.ogg", true)
	
	
	--partner and co walk in on guildmaster and noctowl talking.
	--Partner excitedly gets guildmasters attention
	--guildmaster notices them and happily greets them. Asks if they ended up finding anything from the dungeon
	--partner lights up and presents the Apricorn. Tropius and noctowl are surprised by the size of the Apricorn.
	--Noctowl notes it's quite rare for Apricorns to get that big, but they're more effective the bigger they are
	--Tropius agrees and note it's an amazing find. well done!
	--Oh, thank you guildmaster! Here, take it!
	--Tropius denies the apricorn, insists that since your team found the treasure they should keep it. You'll get more use out of it
	--You get the big apricorn.
	--Partner thanks guildmaster for their generosity.
	--ofc ofc. Looks like it's dinner time, we'll catch up!
	--player and partner goes, camera follows them out, then pans back to noctowl and tropius.
	--Noctowl notes it was quite early to send us on such a test. Is it truly wise to involve rookies with the meaning of this expedition?
	--Tropius replies with "We'll need all the talented hands we can get if our suspicions prove true..."

	GAME:WaitFrames(40)
	local coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 200, 152, false, 1) end)
	local coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:MoveToPosition(hero, 168, 152, false, 1) end)
	local coro3 = TASK:BranchCoroutine(function() if team2 ~= nil then GAME:WaitFrames(14) GROUND:MoveToPosition(team2, 184, 184, false, 1) end end)
	local coro4 = TASK:BranchCoroutine(function() if team3 ~= nil then GAME:WaitFrames(18) GROUND:MoveToPosition(team3, 216, 184, false, 1) end end)
	
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4})

	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("Excuse us,[pause=10] Guildmaster!")
	GAME:WaitFrames(10)

	coro1 = TASK:BranchCoroutine(function() GROUND:CharEndAnim(tropius)
											GeneralFunctions.EmoteAndPause(tropius, "Exclaim", true) end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6)
											GROUND:CharEndAnim(noctowl)
											GeneralFunctions.EmoteAndPause(noctowl, "Notice", false) end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GROUND:CharAnimateTurnTo(tropius, Direction.Down, 4)
	GROUND:CharAnimateTurnTo(noctowl, Direction.DownRight, 4)
	
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Ah,[pause=10] Team " .. GAME:GetTeamName() .. "![pause=0] We didn't notice you come in!")
	
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Have you finished your exploration of " .. zone:GetColoredName() .. "?[pause=0] Did you manage to discover anything?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("We did,[pause=10] Guildmaster![pause=0] We found something amazing in the center of the forest!")
	GAME:WaitFrames(20)
	
	--GeneralFunctions.EmoteAndPause(tropius, "Exclaim", true)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Oh?[pause=0] Tell me and " .. noctowl:GetDisplayName() .. " all about it then!")
	GAME:WaitFrames(20)
	
	--partner is just absolutely beaming the entire time
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("Well,[pause=10] we made our way through the mystery dungeon until we came across a huge clearing!")
	UI:WaitShowDialogue("There were all sorts of different colored Apricorns growing on the trees there!")
	UI:WaitShowDialogue("But that's not even the best part!")
	UI:WaitShowDialogue("In the middle of the clearing,[pause=10] there was a gigantic tree,[pause=10] and on the tree we found...[pause=30] this!")
	GAME:WaitFrames(10)
	
	GROUND:CharAnimateTurnTo(partner, Direction.UpLeft, 4)
	GROUND:MoveInDirection(partner, Direction.UpLeft, 8, false, 1)
	GAME:WaitFrames(10)
	SOUND:PlayBattleSE('EVT_CH02_Item_Place')
	GROUND:Unhide("Apricorn_Big")
	GROUND:EntTurn(hero, Direction.UpRight)
	GAME:WaitFrames(20)
	GROUND:AnimateInDirection(partner, "Walk", Direction.UpLeft, Direction.DownRight, 8, 1, 1)
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(noctowl, "Exclaim", 1)
	GeneralFunctions.EmoteAndPause(tropius, "Exclaim", true)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Wow![pause=0] Look at the size of that Apricorn![pause=0] I don't think I've ever seen one that large before!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(noctowl)
	UI:WaitShowDialogue("It is indeed quite rare for Apricorns to grow this large.")
	UI:WaitShowDialogue("Apricorns are said to be more effective the larger they are,[pause=10] making this particular Apricorn quite valuable.")
	GAME:WaitFrames(10)
	
	GeneralFunctions.DoubleHop(partner)
	GROUND:CharSetAnim(partner, "Idle", true)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("R-really?[pause=0] So this is a great find then!?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("I would certainly say so!")
	GAME:WaitFrames(20)

	GROUND:CharEndAnim(partner)
	GROUND:EntTurn(partner, Direction.Up)	
	GROUND:EntTurn(hero, Direction.Up)	
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("But I must ask...[pause=0] How did you manage to get the Apricorn off the huge tree?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	
	--slightly different dialogue if onix helped
	local onix_teammate, team2species, team3species
	if team2 ~= nil then team2species = team2.CurrentForm.Species end 
	if team3 ~= nil then team3species = team3.CurrentForm.Species end 
	
	if team2species == 'onix' then 
		onix_teammate = team2
	elseif team3species == 'onix' then
		onix_teammate = team3
	end
	
	if onix_teammate ~= nil then
		GeneralFunctions.DuoTurnTowardsChar(onix_teammate)
		UI:WaitShowDialogue("Our teammate " .. onix_teammate:GetDisplayName() .. " gave me a boost up so I could pick the Apricorn!")
		UI:WaitShowDialogue("Without " .. GeneralFunctions.GetPronoun(onix_teammate, "them") .. " we wouldn't have been able to get the Apricorn down!")
	else
		coro1 = TASK:BranchCoroutine(function() GROUND:CharAnimateTurnTo(partner, Direction.Down, 4) end)
		coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GROUND:CharAnimateTurnTo(hero, Direction.DownRight, 4) end)
		coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) GROUND:CharAnimateTurnTo(team3, Direction.UpLeft, 4) end)
		TASK:JoinCoroutines({coro1, coro2, coro3})
		UI:WaitShowDialogue("All four of us worked together to form a totem so I could pick the Apricorn!")
		--GAME:WaitFrames(20)
		--UI:SetSpeakerEmotion("Normal")
		--UI:WaitShowDialogue("But honestly,[pause=10] my team did most of the work by acting as the base of the totem.[pause=0] My part was easy.")
		UI:WaitShowDialogue("If it wasn't for my teammates,[pause=10] there's no way I would have been able to reach the Apricorn!")
	end
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Happy")
	
	
	coro1 = TASK:BranchCoroutine(function() UI:WaitShowDialogue("That's wonderful![pause=0] It joys me to hear that you used teamwork to get the Apricorn!") 
											UI:WaitShowDialogue("It sounds like your adventure was a complete success!")
								 end)
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(6) 
								 GROUND:CharAnimateTurnTo(partner, Direction.Up, 4) end)	
	coro3 = TASK:BranchCoroutine(function() GAME:WaitFrames(12) 
								 GROUND:CharAnimateTurnTo(hero, Direction.Up, 4) end)	
	coro4 = TASK:BranchCoroutine(function() if team2 ~= nil then
								 GAME:WaitFrames(14) 
								 GROUND:CharAnimateTurnTo(team2, Direction.Up, 4) end end)
	local coro5 = TASK:BranchCoroutine(function() if team3 ~= nil then
												  GAME:WaitFrames(18) 
												  GROUND:CharAnimateTurnTo(team3, Direction.Up, 4) end end)
	 
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5})
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Joyous")
	GROUND:CharSetEmote(partner, "glowing", 0)
	UI:WaitShowDialogue("Yeah,[pause=10] it was![pause=0] I'm so happy we got to explore a new area and find something cool!")
	GAME:WaitFrames(20)

	GROUND:CharSetEmote(partner, "", 0)
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("So,[pause=10] Guildmaster,[pause=10] aren't you going to take the Apricorn?")
	UI:WaitShowDialogue("You were the one who told us about " .. zone:GetColoredName() .. ",[pause=10] after all.")
	GAME:WaitFrames(10)
	
	GeneralFunctions.EmoteAndPause(tropius, "Exclaim", true)
	UI:SetSpeaker(tropius)
	UI:WaitShowDialogue("Me?[pause=0] Goodness,[pause=10] no![script=0]", {function() return GeneralFunctions.ShakeHead(tropius) end})
	UI:WaitShowDialogue("Your team worked hard to retrieve this Apricorn![pause=0] It's all yours!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("Really?[pause=0] We can keep it?")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Of course![pause=0] The treasure is yours to keep!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Joyous")
	UI:WaitShowDialogue("Yay![pause=0] Thank you,[pause=10] Guildmaster!")
	GAME:WaitFrames(20)
	
	GROUND:CharAnimateTurnTo(partner, Direction.UpLeft, 4)
	GROUND:MoveInDirection(partner, Direction.UpLeft, 8, false, 1)
	GAME:WaitFrames(10)
	GROUND:Hide("Apricorn_Big")
	SOUND:PlaySE('Event Item Pickup')
	GAME:WaitFrames(40)
	GeneralFunctions.RewardItem("apricorn_big")
	GAME:WaitFrames(20)
	GROUND:AnimateInDirection(partner, "Walk", Direction.UpLeft, Direction.DownRight, 8, 1, 1)
	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	GAME:WaitFrames(20)

	UI:SetSpeaker(tropius)
	UI:WaitShowDialogue("Well,[pause=10] it's getting pretty late now,[pause=10] isn't it?")
	UI:WaitShowDialogue("Why don't you two head on to the dining room?[pause=0] Dinner should be ready any moment now.")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("Oh,[pause=10] sure![pause=0] Thank you again,[pause=10] Guildmaster!")
	
			
	GAME:WaitFrames(20)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Happy")
	coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(20)
											GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
											GROUND:MoveInDirection(hero, Direction.Down, 240, false, 1) end)	
	coro2 = TASK:BranchCoroutine(function() GAME:WaitFrames(12)
											GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
											GROUND:MoveInDirection(partner, Direction.Down, 240, false, 1) end)
	coro3 = TASK:BranchCoroutine(function() if team2 ~= nil then 
											GROUND:CharAnimateTurnTo(team2, Direction.Down, 4)
											GROUND:MoveInDirection(team2, Direction.Down, 80, false, 1) 
											GROUND:MoveInDirection(team2, Direction.DownLeft, 8, false, 1) 
											GROUND:MoveInDirection(team2, Direction.Down, 148, false, 1) 
											end end)
	coro4 = TASK:BranchCoroutine(function() if team3 ~= nil then 
											GROUND:CharAnimateTurnTo(team3, Direction.Down, 4)
											GROUND:MoveInDirection(team3, Direction.Down, 80, false, 1) 
											GROUND:MoveInDirection(team3, Direction.DownLeft, 16, false, 1) 
											GROUND:MoveInDirection(team3, Direction.Down, 140, false, 1) end end)
	coro5 = TASK:BranchCoroutine(function() GAME:WaitFrames(60) SOUND:FadeOutBGM(120) end)
	local coro6 = TASK:BranchCoroutine(function() GAME:WaitFrames(10) GeneralFunctions.MoveCamera(192, 184, 1) end)
	local coro7 = TASK:BranchCoroutine(function() GAME:WaitFrames(10)
												  GROUND:CharSetEmote(tropius, "happy", 0) 
												  UI:WaitShowTimedDialogue("Good job,[pause=10] Team " .. GAME:GetTeamName() .. "![pause=30] Keep up the good work!", 90) 
												  GROUND:CharSetEmote(tropius, "", 0) end)
	TASK:JoinCoroutines({coro1, coro2, coro3, coro4, coro5, coro6, coro7})
	
	GeneralFunctions.MoveCamera(192, 120, 1)
	GAME:WaitFrames(30)
	UI:SetSpeaker(noctowl)
	GROUND:CharAnimateTurnTo(noctowl, Direction.Right, 4)
	UI:WaitShowDialogue("Guildmaster.[pause=0] Though they passed your test,[pause=10] do you truly think it wise to involve them?")
	UI:WaitShowDialogue("They are still rookies,[pause=10] after all.")
	GAME:WaitFrames(12)
	
	UI:SetSpeaker(tropius)
	GROUND:CharAnimateTurnTo(tropius, Direction.Left, 4)
	UI:WaitShowDialogue("Of course,[pause=10] " .. noctowl:GetDisplayName() .. ".[pause=0] The way Team " .. GAME:GetTeamName() .. " performed on this mission was outstanding!")
	UI:WaitShowDialogue("They used teamwork to achieve their goal,[pause=10] and were willing to part ways with the treasure they found.")
	UI:WaitShowDialogue("They're ideal adventurers![pause=0] We need more teams like them around.")
	UI:WaitShowDialogue("Try to have some faith in them despite their relative inexperience.")
	UI:WaitShowDialogue("They've been doing a fantastic job ever since they joined the guild!")
	
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("Besides...[pause=0] We're going to need all the help we can get on this expedition.")
	
	GAME:WaitFrames(60)
	GAME:FadeOut(false, 60)
	GAME:CutsceneMode(false)
	SV.TemporaryFlags.Dinnertime = true 
	GAME:EnterGroundMap("guild_dining_room", "Main_Entrance_Marker")


end

return guild_guildmasters_room_ch_4