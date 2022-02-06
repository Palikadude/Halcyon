require 'common'
require 'dungeon_event.beginner_lesson'

SINGLE_CHAR_SCRIPT = {}

function SINGLE_CHAR_SCRIPT.Test(owner, ownerChar, character, args)
  PrintInfo("Test")
end

function SINGLE_CHAR_SCRIPT.DestinationFloor(owner, ownerChar, character, args)
  SOUND:PlayFanfare("Fanfare/Note")
  UI:ResetSpeaker()
  UI:WaitShowDialogue("You've reached a destination floor!")
end


function SINGLE_CHAR_SCRIPT.OutlawFloor(owner, ownerChar, character, args)
  SOUND:PlayBGM("C07. Outlaw.ogg", false)
  UI:ResetSpeaker()
  UI:WaitShowDialogue("Wanted outlaw spotted!")
  
  -- add a map status for outlaw clear check
  local checkClearStatus = 35 -- outlaw clear check
  local status = RogueEssence.Dungeon.MapStatus(checkClearStatus)
  status:LoadFromData()
  TASK:WaitTask(_DUNGEON:AddMapStatus(status))
end

function SINGLE_CHAR_SCRIPT.OutlawClearCheck(owner, ownerChar, character, args)
  -- check for no outlaw in the mission list
  remaining_outlaw = false
  for name, mission in pairs(SV.test_grounds.Missions) do
    PrintInfo("Checking Mission: "..tostring(name))
    if mission.Complete == COMMON.MISSION_INCOMPLETE and _ZONE.CurrentZoneID == mission.DestZone
	  and _ZONE.CurrentMapID.Segment == mission.DestSegment and _ZONE.CurrentMapID.ID == mission.DestFloor then
	  local found_outlaw = false
	  local team_count = _ZONE.CurrentMap.MapTeams.Count
	  for team_idx = 0, team_count-1, 1 do
	    -- search for a wild mon with the table value
		local player_count = _ZONE.CurrentMap.MapTeams[team_idx].Players.Count
		for player_idx = 0, player_count-1, 1 do
		  player = _ZONE.CurrentMap.MapTeams[team_idx].Players[player_idx]
		  local player_tbl = LTBL(player)
		  if player_tbl.Mission == name then
		    found_outlaw = true
			break
		  end
		  if found_outlaw then
		    break
		  end
		end
	  end
      if not found_outlaw then
	    -- if no outlaws of the mission list, mark quest as complete
		mission.Complete = 1
		UI:ResetSpeaker()
        UI:WaitShowDialogue("Mission status set to complete. Return to quest giver for reward.")
	  else
	    remaining_outlaw = true
	  end
    end
  end
  if not remaining_outlaw then
    -- if no outlaws are found in the map, return music to normal and remove this status from the map
    SOUND:PlayBGM(_ZONE.CurrentMap.Music, true)
    local checkClearStatus = 35 -- outlaw clear check
	TASK:WaitTask(_DUNGEON:RemoveMapStatus(checkClearStatus))
  end
end




--custom Halcyon SINGLE_CHAR_SCRIPT scripts

--Check to make sure the partner or hero is not dead, or anyone else marked as "IsPartner"
--checks guests as well
--if one is dead, then cause an instant game over
function SINGLE_CHAR_SCRIPT.HeroPartnerCheck(owner, ownerChar, character, args)
	local player_count = GAME:GetPlayerPartyCount()
	local guest_count = GAME:GetPlayerGuestCount()
	if player_count < 1 then return end--If there's no party members then we dont need to do anything
	for i = 0, player_count - 1, 1 do 
		local player = GAME:GetPlayerPartyMember(i)
		if player.Dead and player.IsPartner then --someone died 
			for i = 0, player_count - 1, 1 do --beam everyone else out
				player = GAME:GetPlayerPartyMember(i)
				if not player.Dead then--dont beam out whoever died
					TASK:WaitTask(_DUNGEON:ProcessBattleFX(player, player, _DATA.SendHomeFX))
					player.Dead = true
					GAME:WaitFrames(60)
				end
			end
			--beam out guests
			for i = 0, guest_count - 1, 1 do --beam everyone else out
				guest = GAME:GetPlayerGuestMember(i)
				if not guest.Dead then--dont beam out whoever died
					TASK:WaitTask(_DUNGEON:ProcessBattleFX(guest, guest, _DATA.SendHomeFX))
					guest.Dead = true
					GAME:WaitFrames(60)
				end
			end
			--TASK:WaitTask(_GAME:EndSegment(RogueEssence.Data.GameProgress.ResultType.Failed))
			return--cut the script short here if someone died, no need to check guests
		end
	end
	
	--check guests as well
	if guest_count < 1 then return end--If there's no guest members then we dont need to do anything
	for i = 0, guest_count - 1, 1 do 
		local guest = GAME:GetPlayerGuestMember(i)
		if guest.Dead and guest.IsPartner then --someone died 
			--beam player's team out first
			for i = 0, player_count - 1, 1 do --beam everyone else out
				player = GAME:GetPlayerPartyMember(i)
				if not player.Dead then--dont beam out whoever died
					TASK:WaitTask(_DUNGEON:ProcessBattleFX(player, player, _DATA.SendHomeFX))
					player.Dead = true
					GAME:WaitFrames(60)
				end
			end
			for i = 0, guest_count - 1, 1 do --beam everyone else out
				guest = GAME:GetPlayerGuestMember(i)
				if not guest.Dead then--dont beam out whoever died
					TASK:WaitTask(_DUNGEON:ProcessBattleFX(guest, guest, _DATA.SendHomeFX))
					guest.Dead = true
					GAME:WaitFrames(60)
				end
			end
			--TASK:WaitTask(_GAME:EndSegment(RogueEssence.Data.GameProgress.ResultType.Failed))
		end
	end
			
end






--Halcyon dungeon scripts

--For Ledian's speeches within the beginner lesson
function SINGLE_CHAR_SCRIPT.BeginnerLessonSpeech(owner, ownerChar, character, args)
  if character == nil then return end
  if character.Nickname == 'Lotus' and character.Level > 50 then--this check is needed so that the script runs only once, otherwise it'll run for each entity in the map. 
	--TODO: change character check to player and use the below call to call speeches. location of triggers will need to shift on actual maps
	--GAME:QueueLeaderEvent(BeginnerLessonSpeech(owner, ownerChar, characters, args))--
	BeginnerLessonSpeechHelper(owner, ownerChar, characters, args)
  end
end

--helper function to go with queueleaderevent call in BeginnerLessonSpeech
function BeginnerLessonSpeechHelper(owner, ownerChar, characters, args)
	--slight pause if this isn't being called by asking Ledian for help. Don't pause if ledian wouldn't say anything (restepping on trigger tile)
	if SV.Tutorial.Progression ~= -1  and args.Speech > SV.Tutorial.Progression then GAME:WaitFrames(20) end 
	
	if args.Speech == 1 and SV.Tutorial.Progression < 1 then
		beginner_lesson.Floor_1_Intro(owner, ownerChar, character, args)
		GAME:WaitFrames(20)--prevent mashing causing you to accidentially speak to Ledian or attack the air
	elseif args.Speech == 2 and SV.Tutorial.Progression < 2 then
		beginner_lesson.Floor_2_Intro(owner, ownerChar, character, args)
		GAME:WaitFrames(20)
	elseif args.Speech == 3 and SV.Tutorial.Progression < 3 then
		beginner_lesson.Floor_3_Intro(owner, ownerChar, character, args)
		GAME:WaitFrames(20)
	elseif args.Speech == 4 and SV.Tutorial.Progression < 4 then
		beginner_lesson.Floor_3_Wand_Speech(owner, ownerChar, character, args)
		GAME:WaitFrames(20)
	elseif args.Speech == 5 and SV.Tutorial.Progression < 5 then
		beginner_lesson.Floor_3_HeldItem_Speech(owner, ownerChar, character, args)
		GAME:WaitFrames(20)
	elseif args.Speech == 6 and SV.Tutorial.Progression < 6 then
		beginner_lesson.Floor_3_ThrownReviver_Speech(owner, ownerChar, character, args)
		GAME:WaitFrames(20)
	elseif args.Speech == 7 and SV.Tutorial.Progression < 7 then
		beginner_lesson.Floor_4_Intro(owner, ownerChar, character, args)
		GAME:WaitFrames(20)
	elseif args.Speech == 8 and SV.Tutorial.Progression < 8 then
		beginner_lesson.Floor_4_Key_Speech(owner, ownerChar, character, args)
		GAME:WaitFrames(20)
	elseif args.Speech == 9 and SV.Tutorial.Progression < 9 then
		beginner_lesson.Floor_5_Intro(owner, ownerChar, character, args)
		GAME:WaitFrames(20)
	end
end

--Make sure target character is holding the Band of Passage or they will be warped away
function SINGLE_CHAR_SCRIPT.BeginnerLessonHeldItemCheck(owner, ownerChar, character, args)
	if character ~= GAME:GetPlayerGuestMember(0) and character.EquippedItem.ID ~= 2503 then--band of passage. Ledian is allowed to pass no matter what
		_DUNGEON:LogMsg(STRINGS:Format("{0} doesn't have a {1} equipped!", character:GetDisplayName(false), RogueEssence.Dungeon.InvItem(2503):GetDisplayName()))
		GAME:WaitFrames(40)
		TASK:WaitTask(_DUNGEON:PointWarp(character, RogueElements.Loc(18, 18), true)) --warp them to the specified x18, y18 tile with a message saying they warped
	elseif character ~= GAME:GetPlayerGuestMember(0) then --no messages or checks should be done on Ledian
		_DUNGEON:LogMsg(STRINGS:Format("{0} has a {1} equipped and is allowed to pass!", character:GetDisplayName(false), RogueEssence.Dungeon.InvItem(2503):GetDisplayName()))
	end
end

BATTLE_SCRIPT = {}

function BATTLE_SCRIPT.Test(owner, ownerChar, context, args)
  PrintInfo("Test")
end

function BATTLE_SCRIPT.AllyInteract(owner, ownerChar, context, args)
  COMMON.DungeonInteract(context.User, context.Target, context.CancelState, context.TurnCancel)
end


--special Halcyon script for the partner
function BATTLE_SCRIPT.PartnerInteract(owner, ownerChar, context, args)
	local chara = context.User
	local target = context.Target
	local action_cancel = context.CancelState
	local turn_cancel = context.TurnCancel


	  action_cancel.Cancel = true
  -- TODO: create a charstate for being unable to talk and have talk-interfering statuses cause it
  if target:GetStatusEffect(1) == nil and target:GetStatusEffect(3) == nil then
    
    local ratio = target.HP * 100 // target.MaxHP
    
    local mon = RogueEssence.Data.DataManager.Instance:GetMonster(target.BaseForm.Species)
    local form = mon.Forms[target.BaseForm.Form]
    
    local personality = form:GetPersonalityType(target.Discriminator)
    
    local personality_group = COMMON.PERSONALITY[personality]
    local pool = {}
    local key = ""
    if ratio <= 25 then
      UI:SetSpeakerEmotion("Pain")
      pool = personality_group.PINCH
      key = "TALK_PINCH_%04d"
    elseif ratio <= 50 then
      UI:SetSpeakerEmotion("Worried")
      pool = personality_group.HALF
      key = "TALK_HALF_%04d"
    else
      pool = personality_group.FULL
      key = "TALK_FULL_%04d"
    end
    
    local running_pool = {table.unpack(pool)}
    local valid_quote = false
    local chosen_quote = ""
    
    while not valid_quote and #running_pool > 0 do
      valid_quote = true
      local chosen_idx = math.random(1, #running_pool)
  	  local chosen_pool_idx = running_pool[chosen_idx]
      chosen_quote = RogueEssence.StringKey(string.format(key, chosen_pool_idx)):ToLocal()
  	
      chosen_quote = string.gsub(chosen_quote, "%[player%]", chara:GetDisplayName(true))
      chosen_quote = string.gsub(chosen_quote, "%[myname%]", target:GetDisplayName(true))
      
      if string.find(chosen_quote, "%[move%]") then
        local moves = {}
  	    for move_idx = 0, 3 do
  	      if target.BaseSkills[move_idx].SkillNum > 0 then
  	        table.insert(moves, target.BaseSkills[move_idx].SkillNum)
  	      end
  	    end
  	    if #moves > 0 then
  	      local chosen_move = RogueEssence.Data.DataManager.Instance:GetSkill(moves[math.random(1, #moves)])
  	      chosen_quote = string.gsub(chosen_quote, "%[move%]", chosen_move:GetIconName())
  	    else
  	      valid_quote = false
  	    end
      end
      
      if string.find(chosen_quote, "%[kind%]") then
  	    if GAME:GetCurrentFloor().TeamSpawns.CanPick then
          local team_spawn = GAME:GetCurrentFloor().TeamSpawns:Pick(GAME.Rand)
  	      local chosen_list = team_spawn:ChooseSpawns(GAME.Rand)
  	      if chosen_list.Count > 0 then
  	        local chosen_mob = chosen_list[math.random(0, chosen_list.Count-1)]
  	        local mon = RogueEssence.Data.DataManager.Instance:GetMonster(chosen_mob.BaseForm.Species)
            chosen_quote = string.gsub(chosen_quote, "%[kind%]", mon:GetColoredName())
  	      else
  	        valid_quote = false
  	      end
  	    else
  	      valid_quote = false
  	    end
      end
      
      if string.find(chosen_quote, "%[item%]") then
        if GAME:GetCurrentFloor().ItemSpawns.CanPick then
          local item = GAME:GetCurrentFloor().ItemSpawns:Pick(GAME.Rand)
          chosen_quote = string.gsub(chosen_quote, "%[item%]", item:GetDisplayName())
  	    else
  	      valid_quote = false
  	    end
      end
  	
  	  if not valid_quote then
        -- PrintInfo("Rejected "..chosen_quote)
  	    table.remove(running_pool, chosen_idx)
  	    chosen_quote = ""
  	  end
    end
    -- PrintInfo("Selected "..chosen_quote)
	
	local oldDir = target.CharDir
    DUNGEON:CharTurnToChar(target, chara)
  
    UI:SetSpeaker(target)
  
    UI:WaitShowDialogue(chosen_quote)
  
    target.CharDir = oldDir
  else
  
    UI:ResetSpeaker()
	
	local chosen_quote = RogueEssence.StringKey("TALK_CANT"):ToLocal()
    chosen_quote = string.gsub(chosen_quote, "%[myname%]", target:GetDisplayName(true))
	
    UI:WaitShowDialogue(chosen_quote)
  
  end
end





--special Halcyon interact script for the hero
--very simplified version of partner script, only dialogue possible is "(.........)"
function BATTLE_SCRIPT.HeroInteract(owner, ownerChar, context, args)
	local chara = context.User
	local target = context.Target
	local action_cancel = context.CancelState
	local turn_cancel = context.TurnCancel
	 

	 action_cancel.Cancel = true
  -- TODO: create a charstate for being unable to talk and have talk-interfering statuses cause it
  if target:GetStatusEffect(1) == nil and target:GetStatusEffect(3) == nil then
    
    local ratio = target.HP * 100 // target.MaxHP 

    if ratio <= 25 then
      UI:SetSpeakerEmotion("Pain")
    elseif ratio <= 50 then
      UI:SetSpeakerEmotion("Worried")
    else
	  UI:SetSpeakerEmotion("Normal")
    end

    local chosen_quote = ""
    
   
	
	local oldDir = target.CharDir
    DUNGEON:CharTurnToChar(target, chara)
  
    UI:SetSpeaker(target)
	chosen_quote = '(.........)'
  
    UI:WaitShowDialogue(chosen_quote)
  
    target.CharDir = oldDir
  else
  
    UI:ResetSpeaker()
	
	local chosen_quote = RogueEssence.StringKey("TALK_CANT"):ToLocal()
    chosen_quote = string.gsub(chosen_quote, "%[myname%]", target:GetDisplayName(true))
	
    UI:WaitShowDialogue(chosen_quote)
  
  end
end

--custom Halcyon script for Ledian, the dojomaster/sensei, for use during dojo lessons (tutorials)
function BATTLE_SCRIPT.SenseiInteract(owner, ownerChar, context, args)
	local chara = context.User--player 
	local target = context.Target--ledian
	UI:SetSpeaker(target)

	local olddir = target.CharDir
	DUNGEON:CharTurnToChar(target, chara)
	UI:BeginChoiceMenu("Do you need something,[pause=10] my student?", {"Help", "Reset floor", "Nothing"}, 3, 3)
	UI:WaitForChoice()
	local result = UI:ChoiceResult()
	if result == 1 then 
		args.Speech = SV.Tutorial.Progression
		SV.Tutorial.Progression = -1 --temporarily clear progression flag so speech can happen. -1 to prevent pausing before script trigger
		SINGLE_CHAR_SCRIPT.BeginnerLessonSpeech(owner, ownerChar, target, args)
	elseif result == 2 then
		UI:WaitShowDialogue("Wahtah![pause=0] Very well![pause=0] Allow me to reset this floor!")
		GAME:WaitFrames(20)
		UI:SetSpeakerEmotion("Determined")
		UI:WaitShowDialogue(".........")
		GAME:WaitFrames(20)
		UI:SetSpeakerEmotion("Shouting")
		--setup flashes
		--todo: fix when audino adds dungeon VFX
		local emitter = RogueEssence.Content.FlashEmitter()
		emitter.FadeInTime = 2
		emitter.HoldTime = 4
		emitter.FadeOutTime = 2
		emitter.StartColor = Color(0, 0, 0, 0)
		emitter.Layer = DrawLayer.Top
		emitter.Anim = RogueEssence.Content.BGAnimData("White", 0)
		--setup hop animation
		--TODO: use a better/simpler call to do this when audino creates one
		local action = RogueEssence.Dungeon.CharAnimAction()
		action.BaseFrameType = 43 --hop
		action.AnimLoc = target.CharLoc
		action.CharDir = target.CharDir
		TASK:WaitTask(target:StartAnim(action))
		
		GROUND:PlayVFX(emitter, target.MapLoc.X, target.MapLoc.Y)
	    SOUND:PlayBattleSE("EVT_Battle_Flash")
	    GAME:WaitFrames(15)
	    GROUND:PlayVFX(emitter, target.MapLoc.X, target.MapLoc.Y)
	    SOUND:PlayBattleSE("EVT_Battle_Flash")
		UI:WaitShowTimedDialogue("HWACHA!", 40)		
		--Reset floor
		local resetEvent = PMDC.Dungeon.ResetFloorEvent()
		TASK:WaitTask(resetEvent:Apply(owner, ownerChar, chara))--chara is the one who's "activating the reset tile"
	else 
		UI:WaitShowDialogue("Hoiyah![pause=0] Onwards with the lesson then!")
	end
end


function BATTLE_SCRIPT.EscortInteract(owner, ownerChar, context, args)
  action_cancel.Cancel = true
    UI:SetSpeaker(context.Target)
    UI:WaitShowDialogue("I'm counting on you!")
end

function BATTLE_SCRIPT.RescueReached(owner, ownerChar, context, args)

  local tbl = LTBL(context.Target)
  local mission = SV.test_grounds.Missions[tbl.Mission]
  mission.Complete = 1
  
  local oldDir = context.Target.CharDir
  DUNGEON:CharTurnToChar(context.Target, chara)
  
  UI:SetSpeaker(context.Target)
  UI:WaitShowDialogue("Yay, you found me!")
  
  -- warp out
  TASK:WaitTask(_DUNGEON:ProcessBattleFX(context.Target, context.Target, _DATA.SendHomeFX))
  _DUNGEON:RemoveChar(context.Target)
  
  UI:ResetSpeaker()
  UI:WaitShowDialogue("Mission status set to complete. Return to quest giver for reward.")
end


function BATTLE_SCRIPT.EscortRescueReached(owner, ownerChar, context, args)
  
  local tbl = LTBL(context.Target)
  local escort = COMMON.FindMissionEscort(tbl.Mission)
  
  if escort then
    
    local mission = SV.test_grounds.Missions[tbl.Mission]
    mission.Complete = 1
  
    local oldDir = context.Target.CharDir
    DUNGEON:CharTurnToChar(context.Target, chara)
  
    UI:SetSpeaker(context.Target)
    UI:WaitShowDialogue("Yay, you brought the escort to me!")
  
    -- warp out
    TASK:WaitTask(_DUNGEON:ProcessBattleFX(escort, escort, _DATA.SendHomeFX))
    _DUNGEON:RemoveChar(escort)
	
    TASK:WaitTask(_DUNGEON:ProcessBattleFX(context.Target, context.Target, _DATA.SendHomeFX))
    _DUNGEON:RemoveChar(context.Target)
  
    UI:ResetSpeaker()
    UI:WaitShowDialogue("Mission status set to complete. Return to quest giver for reward.")
  end
end

function BATTLE_SCRIPT.CountTalkTest(owner, ownerChar, context, args)
  context.CancelState.Cancel = true
  
  local tbl = LTBL(context.Target)
  
  local oldDir = context.Target.CharDir
  DUNGEON:CharTurnToChar(context.Target, chara)
  
  UI:SetSpeaker(context.Target)
  
  if tbl.TalkAmount == nil then
    UI:WaitShowDialogue("I will remember how many times I've been talked to.")
	tbl.TalkAmount = 1
  else
	tbl.TalkAmount = tbl.TalkAmount + 1
  end
  UI:WaitShowDialogue("You've talked to me "..tostring(tbl.TalkAmount).." times.")
  
  context.Target.CharDir = oldDir
end

--custom Halcyon BATTLE_SCRIPT scripts

--vibrant scarf passive should only activate if a nearby ally is also wearing a vibrant scarf
function BATTLE_SCRIPT.VibrantScarfPassive(owner, ownerChar, context, args)

end




STATUS_SCRIPT = {}

function STATUS_SCRIPT.Test(owner, ownerChar, context, args)
  PrintInfo("Test")
end


MAP_STATUS_SCRIPT = {}

function MAP_STATUS_SCRIPT.Test(owner, ownerChar, character, status, msg, args)
  PrintInfo("Test")
end


REFRESH_SCRIPT = {}

function REFRESH_SCRIPT.Test(owner, ownerChar, character, args)
  PrintInfo("Test")
end


SKILL_CHANGE_SCRIPT = {}

function SKILL_CHANGE_SCRIPT.Test(owner, character, skillIndices, args)
  PrintInfo("Test")
end


ZONE_GEN_SCRIPT = {}

function ZONE_GEN_SCRIPT.Test(zoneContext, context, queue, seed, args)
  PrintInfo("Test")
end

PresetMultiTeamSpawnerType = luanet.import_type('RogueEssence.LevelGen.PresetMultiTeamSpawner`1')
PlaceRandomMobsStepType = luanet.import_type('RogueEssence.LevelGen.PlaceRandomMobsStep`1')
PlaceEntranceMobsStepType = luanet.import_type('RogueEssence.LevelGen.PlaceEntranceMobsStep`2')
MapEffectStepType = luanet.import_type('RogueEssence.LevelGen.MapEffectStep`1')
MapGenContextType = luanet.import_type('RogueEssence.LevelGen.ListMapGenContext')
EntranceType = luanet.import_type('RogueEssence.LevelGen.MapGenEntrance')

function ZONE_GEN_SCRIPT.SpawnMissionNpcFromSV(zoneContext, context, queue, seed, args)
  -- choose a the floor to spawn it on
  local destinationFloor = false
  local outlawFloor = false
  for name, mission in pairs(SV.test_grounds.Missions) do
    PrintInfo("Checking Mission: "..tostring(name))
    if mission.Complete == COMMON.MISSION_INCOMPLETE and zoneContext.CurrentZone == mission.DestZone
	  and zoneContext.CurrentSegment == mission.DestSegment and zoneContext.CurrentID == mission.DestFloor then
      PrintInfo("Spawning Mission Goal")
	  if mission.Type == COMMON.MISSION_TYPE_OUTLAW then -- outlaw
        local specificTeam = RogueEssence.LevelGen.SpecificTeamSpawner()
        local post_mob = RogueEssence.LevelGen.MobSpawn()
        post_mob.BaseForm = RogueEssence.Dungeon.MonsterID(mission.TargetSpecies, 0, 0, Gender.Unknown)
        post_mob.Tactic = 20
        post_mob.Level = RogueElements.RandRange(50)
		post_mob.SpawnFeatures:Add(PMDC.LevelGen.MobSpawnLuaTable('{ Mission = "'..name..'" }'))
	    specificTeam.Spawns:Add(post_mob)
        PrintInfo("Creating Spawn")
        local picker = LUA_ENGINE:MakeGenericType(PresetMultiTeamSpawnerType, { MapGenContextType }, { })
	    picker.Spawns:Add(specificTeam)
        PrintInfo("Creating Step")
        local mobPlacement = LUA_ENGINE:MakeGenericType(PlaceEntranceMobsStepType, { MapGenContextType, EntranceType }, { picker })
        PrintInfo("Enqueueing")
	    -- Priority 5.2.1 is for NPC spawning in PMDO, but any dev can choose to roll with their own standard of priority.
	    local priority = RogueElements.Priority(5, 2, 1)
	    queue:Enqueue(priority, mobPlacement)
        PrintInfo("Done")
	    outlawFloor = true
	  else
        local specificTeam = RogueEssence.LevelGen.SpecificTeamSpawner()
        local post_mob = RogueEssence.LevelGen.MobSpawn()
        post_mob.BaseForm = RogueEssence.Dungeon.MonsterID(mission.TargetSpecies, 0, 0, Gender.Unknown)
        post_mob.Tactic = 21
        post_mob.Level = RogueElements.RandRange(50)
	    if mission.Type == COMMON.MISSION_TYPE_RESCUE then -- rescue
	      local dialogue = RogueEssence.Dungeon.BattleScriptEvent("RescueReached")
          post_mob.SpawnFeatures:Add(PMDC.LevelGen.MobSpawnInteractable(dialogue))
          post_mob.SpawnFeatures:Add(PMDC.LevelGen.MobSpawnLuaTable('{ Mission = "'..name..'" }'))
        elseif mission.Type == COMMON.MISSION_TYPE_ESCORT then -- escort
	      local dialogue = RogueEssence.Dungeon.BattleScriptEvent("EscortRescueReached")
          post_mob.SpawnFeatures:Add(PMDC.LevelGen.MobSpawnInteractable(dialogue))
          post_mob.SpawnFeatures:Add(PMDC.LevelGen.MobSpawnLuaTable('{ Mission = "'..name..'" }'))
	    end
	    specificTeam.Spawns:Add(post_mob)
        PrintInfo("Creating Spawn")
        local picker = LUA_ENGINE:MakeGenericType(PresetMultiTeamSpawnerType, { MapGenContextType }, { })
	    picker.Spawns:Add(specificTeam)
        PrintInfo("Creating Step")
        local mobPlacement = LUA_ENGINE:MakeGenericType(PlaceRandomMobsStepType, { MapGenContextType }, { picker })
        PrintInfo("Setting everything else")
        mobPlacement.Ally = true
        mobPlacement.Filters:Add(PMDC.LevelGen.RoomFilterConnectivity(PMDC.LevelGen.ConnectivityRoom.Connectivity.Main))
        mobPlacement.ClumpFactor = 20
        PrintInfo("Enqueueing")
	    -- Priority 5.2.1 is for NPC spawning in PMDO, but any dev can choose to roll with their own standard of priority.
	    local priority = RogueElements.Priority(5, 2, 1)
	    queue:Enqueue(priority, mobPlacement)
        PrintInfo("Done")
	    destinationFloor = true
	  end
    end
  end
  
  if destinationFloor then
    -- add destination floor notification
    local activeEffect = RogueEssence.Data.ActiveEffect()
    activeEffect.OnMapStarts:Add(-6, RogueEssence.Dungeon.SingleCharScriptEvent("DestinationFloor"))
	local destNote = LUA_ENGINE:MakeGenericType( MapEffectStepType, { MapGenContextType }, { activeEffect })
	local priority = RogueElements.Priority(-6)
	queue:Enqueue(priority, destNote)
  end
  if outlawFloor then
    -- add destination floor notification
    local activeEffect = RogueEssence.Data.ActiveEffect()
    activeEffect.OnMapStarts:Add(-6, RogueEssence.Dungeon.SingleCharScriptEvent("OutlawFloor"))
	local destNote = LUA_ENGINE:MakeGenericType( MapEffectStepType, { MapGenContextType }, { activeEffect })
	local priority = RogueElements.Priority(-6)
	queue:Enqueue(priority, destNote)
  end
end


FLOOR_GEN_SCRIPT = {}

function FLOOR_GEN_SCRIPT.Test(map, args)
  PrintInfo("Test")
end




