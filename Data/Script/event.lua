require 'common'

SINGLE_CHAR_SCRIPT = {}

function SINGLE_CHAR_SCRIPT.Test(owner, ownerChar, character, args)
  PrintInfo("Test")
end

function SINGLE_CHAR_SCRIPT.DestinationFloor(owner, ownerChar, character, args)
  SOUND:PlayFanfare("Fanfare/Note")
  UI:ResetSpeaker()
  UI:WaitShowDialogue("You've reached a destination floor!")
end


BATTLE_SCRIPT = {}

function BATTLE_SCRIPT.Test(owner, ownerChar, context, args)
  PrintInfo("Test")
end

function BATTLE_SCRIPT.AllyInteract(owner, ownerChar, context, args)
  COMMON.DungeonInteract(context.User, context.Target, context.CancelState, context.TurnCancel)
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
MapEffectStepType = luanet.import_type('RogueEssence.LevelGen.MapEffectStep`1')
MapGenContextType = luanet.import_type('RogueEssence.LevelGen.ListMapGenContext')

function ZONE_GEN_SCRIPT.SpawnMissionNpcFromSV(zoneContext, context, queue, seed, args)
  -- choose a the floor to spawn it on
  local destinationFloor = false
  for name, mission in pairs(SV.test_grounds.Missions) do
    PrintInfo("Checking Mission: "..tostring(name))
    if zoneContext.CurrentZone == mission.DestZone and zoneContext.CurrentSegment == mission.DestSegment and zoneContext.CurrentID == mission.DestFloor then
      PrintInfo("Spawning Destination")
      local specificTeam = RogueEssence.LevelGen.SpecificTeamSpawner()
      local post_mob = RogueEssence.LevelGen.MobSpawn()
      post_mob.BaseForm = RogueEssence.Dungeon.MonsterID(mission.TargetSpecies, 0, 0, Gender.Unknown)
      post_mob.Tactic = 21
      post_mob.Level = RogueElements.RandRange(50)
	  local dialogue = RogueEssence.Dungeon.BattleScriptEvent("RescueReached")
      post_mob.SpawnFeatures:Add(PMDC.LevelGen.MobSpawnInteractable(dialogue))
      post_mob.SpawnFeatures:Add(PMDC.LevelGen.MobSpawnLuaTable('{ Mission = "'..name..'" }'))
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
  
  if destinationFloor then
    -- add destination floor notification
    local activeEffect = RogueEssence.Data.ActiveEffect()
    activeEffect.OnMapStarts:Add(-6, RogueEssence.Dungeon.SingleCharScriptEvent("DestinationFloor"))
	local destNote = LUA_ENGINE:MakeGenericType( MapEffectStepType, { MapGenContextType }, { activeEffect })
	local priority = RogueElements.Priority(-6)
	queue:Enqueue(priority, destNote)
  end
end


FLOOR_GEN_SCRIPT = {}

function FLOOR_GEN_SCRIPT.Test(map, args)
  PrintInfo("Test")
end




