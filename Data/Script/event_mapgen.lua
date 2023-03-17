require 'common'
require 'mission_gen'

ZONE_GEN_SCRIPT = {}

function ZONE_GEN_SCRIPT.Test(zoneContext, context, queue, seed, args)
  PrintInfo("Test")
end

PresetMultiTeamSpawnerType = luanet.import_type('RogueEssence.LevelGen.PresetMultiTeamSpawner`1')
PlaceRandomMobsStepType = luanet.import_type('RogueEssence.LevelGen.PlaceRandomMobsStep`1')
PlaceEntranceMobsStepType = luanet.import_type('RogueEssence.LevelGen.PlaceEntranceMobsStep`2')
MonsterHouseStepType = luanet.import_type('RogueEssence.LevelGen.MonsterHouseStep`1')


MapEffectStepType = luanet.import_type('RogueEssence.LevelGen.MapEffectStep`1')
MapGenContextType = luanet.import_type('RogueEssence.LevelGen.ListMapGenContext')
EntranceType = luanet.import_type('RogueEssence.LevelGen.MapGenEntrance')

SpawnListType = luanet.import_type('RogueElements.SpawnList`1')
ItemSpawnStepType = luanet.import_type('RogueEssence.LevelGen.ItemSpawnStep`1')
InvItemType = luanet.import_type('RogueEssence.Dungeon.InvItem')

RandomRoomSpawnStepType = luanet.import_type('RogueElements.RandomRoomSpawnStep`2')
PickerSpawnType = luanet.import_type('RogueElements.PickerSpawner`2')
PresetMultiRandType = luanet.import_type('RogueElements.PresetMultiRand`1')
PresetPickerType = luanet.import_type('RogueElements.PresetPicker`1')
MapItemType = luanet.import_type('RogueEssence.Dungeon.MapItem')

function ZONE_GEN_SCRIPT.SpawnMissionNpcFromSV(zoneContext, context, queue, seed, args)
  local destinationFloor = false 
  
  local outlawFloor = false
  for name, mission in pairs(SV.TakenBoard) do
    if mission.Taken and mission.Completion == COMMON.MISSION_INCOMPLETE and zoneContext.CurrentZone == mission.Zone
	  and zoneContext.CurrentSegment == mission.Segment and zoneContext.CurrentID + 1 == mission.Floor then
      PrintInfo("Spawning Mission Goal")
      local outlaw_arr = { 
        COMMON.MISSION_TYPE_OUTLAW,
        COMMON.MISSION_TYPE_OUTLAW_ITEM,
        COMMON.MISSION_TYPE_OUTLAW_FLEE,
        COMMON.MISSION_TYPE_OUTLAW_MONSTER_HOUSE
      }

      if GeneralFunctions.TableContains(outlaw_arr, mission.Type) then -- outlaw
        local specificTeam = RogueEssence.LevelGen.SpecificTeamSpawner()
        local post_mob = RogueEssence.LevelGen.MobSpawn()
        post_mob.BaseForm = RogueEssence.Dungeon.MonsterID(mission.Target, 0, "normal", Gender.Unknown)

        if mission.Type == COMMON.MISSION_TYPE_OUTLAW_FLEE then
          --TODO: Change to get tact
          post_mob.Tactic = "get_away"
        else
          post_mob.Tactic = "boss"
        end
        -- Grab the outlaw level
        post_mob.Level = RogueElements.RandRange(
          math.floor(MISSION_GEN.EXPECTED_LEVEL[mission.Zone] * 1.15)
        )
        
        post_mob.SpawnFeatures:Add(PMDC.LevelGen.MobSpawnLuaTable('{ Mission = "'..name..'" }'))
        if mission.Type == COMMON.MISSION_TYPE_OUTLAW_ITEM then
          local item_feature = PMDC.LevelGen.MobSpawnItem(true, mission.Item)
          post_mob.SpawnFeatures:Add(item_feature)
        end

        local boost_feature = PMDC.LevelGen.MobSpawnBoost()
        boost_feature.MaxHPBonus = MISSION_GEN.EXPECTED_LEVEL[mission.Zone] * 2;
        post_mob.SpawnFeatures:Add(boost_feature)

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
        if mission.Type == COMMON.MISSION_TYPE_RESCUE or mission.Type == COMMON.MISSION_TYPE_DELIVERY or mission.Type == COMMON.MISSION_TYPE_ESCORT then 
          local specificTeam = RogueEssence.LevelGen.SpecificTeamSpawner()
          local post_mob = RogueEssence.LevelGen.MobSpawn()
          post_mob.BaseForm = RogueEssence.Dungeon.MonsterID(mission.Target, 0, "normal", Gender.Unknown)
          post_mob.Tactic = "slow_wander"
          post_mob.Level = RogueElements.RandRange(50)
          if mission.Type == COMMON.MISSION_TYPE_RESCUE or mission.Type == COMMON.MISSION_TYPE_DELIVERY then -- rescue
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
        

        elseif mission.Type == COMMON.MISSION_TYPE_LOST_ITEM then
          PrintInfo("Spawning Lost Item")
          local lost_item = RogueEssence.Dungeon.MapItem(mission.Item)
          local preset_picker = LUA_ENGINE:MakeGenericType(PresetPickerType, { MapItemType }, { lost_item })
          local multi_preset_picker = LUA_ENGINE:MakeGenericType(PresetMultiRandType, { MapItemType }, { preset_picker })
          local picker_spawner = LUA_ENGINE:MakeGenericType(PickerSpawnType, {  MapGenContextType, MapItemType }, { multi_preset_picker })
          local random_room_spawn = LUA_ENGINE:MakeGenericType(RandomRoomSpawnStepType, { MapGenContextType, MapItemType }, { })
          random_room_spawn.Spawn = picker_spawner
          random_room_spawn.Filters:Add(PMDC.LevelGen.RoomFilterConnectivity(PMDC.LevelGen.ConnectivityRoom.Connectivity.Main))
          local priority = RogueElements.Priority(5, 2, 1)
          queue:Enqueue(priority, random_room_spawn)
        end
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


function FLOOR_GEN_SCRIPT.TestGrid(map, args)
  PrintInfo("Test Grid")
  
  -- this step operates on the grid floor of the map, assuming it has one
  -- free-form floors do not have a grid
  local floorPlan = map.GridPlan
  -- these changes will only affect the map if they are done after the grid is created (after priority -5)
  -- these changes will only affect the map if they are done before the grid is drawn to the floor plan (before priority -3)
  
  
  -- set the brush for all vertical hallways on the right half to be blocked rooms 
  for xx = floorPlan.GridWidth / 2, floorPlan.GridWidth - 1, 1 do
    for yy = 0, floorPlan.GridHeight - 2, 1 do
	  local hall = floorPlan:GetHall(RogueElements.LocRay4(RogueElements.Loc(xx, yy), Dir4.Down))
	  -- only modify existing halls
	  if hall ~= nil then
	    local hallGen = LUA_ENGINE:MakeGenericType(RoomGenBlockedType, { map:GetType() }, {  })
	    -- no need to change width and height since they will be ordered by the floors
	    hallGen.BlockWidth = RogueElements.RandRange(2)
	    hallGen.BlockHeight = RogueElements.RandRange(10)
		hallGen.BlockTerrain = RogueEssence.Dungeon.Tile("water")
		floorPlan:SetHall(RogueElements.LocRay4(RogueElements.Loc(xx, yy), Dir4.Down), hallGen, hall.Components)
	  end
	end
  end
  
  -- turns all rooms on the left side into evo rooms
  for yy = 0, floorPlan.GridHeight - 1, 1 do
	local room = floorPlan:GetRoomPlan(RogueElements.Loc(0, yy))
	if room ~= nil then
	  local roomGen = LUA_ENGINE:MakeGenericType(RoomGenEvoType, { map:GetType() }, {  })
	  room.RoomGen = roomGen
	end
  end
  
end

  
function FLOOR_GEN_SCRIPT.Test(map, args)
  PrintInfo("Test Tile")
  
  --A demo of various tile operations possible with scripting
  --This step should be added after everything else. (prefer 7)
  
  --Set the top-left corner to room tile. Note that unbreakable blocks are left untouched.
  for xx = 0, map.Width / 2, 1 do
    for yy = 0, map.Height / 2, 1 do
      map:TrySetTile(RogueElements.Loc(xx, yy), map.RoomTerrain)
    end  
  end
  
  --Set the center of the corner to Block tile
  for xx = map.Width / 4 - 1, map.Width / 4 + 1, 1 do
    for yy = map.Height / 4 - 1, map.Height / 4 + 1, 1 do
      map:TrySetTile(RogueElements.Loc(xx, yy), map.WallTerrain)
    end
  end
  
  --set a single coordinate to unbreakable
  map:TrySetTile(RogueElements.Loc(map.Width / 2 - 1, map.Height / 2 - 1), map.UnbreakableTerrain)
  
  --Set the bottom-right corner to water, but only if the existing tiles aren't ground.  MapGenContext has built-in members for Ground, Wall, and Impassable, but the rest must be specified.
  for xx = map.Width / 2, map.Width - 1, 1 do
    for yy = map.Height / 2, map.Height - 1, 1 do
	  local loc = RogueElements.Loc(xx, yy)
	  if not map:GetTile(loc):TileEquivalent(map.RoomTerrain) then
        map:TrySetTile(loc, RogueEssence.Dungeon.Tile("water"))
	  end
    end  
  end
  
  --Set the center of the corner to Block tile of a custom tileset.
  for xx = map.Width * 3 / 4 - 1, map.Width * 3 / 4 + 1, 1 do
    for yy = map.Height * 3 / 4 - 1, map.Height * 3 / 4 + 1, 1 do
	  local customTerrain = RogueEssence.Dungeon.Tile("wall", true) -- set StableTex to true, which prevents the map's autotexturing
	  customTerrain.Data.TileTex = RogueEssence.Dungeon.AutoTile("tiny_woods_wall")
      map:TrySetTile(RogueElements.Loc(xx, yy), customTerrain)
    end
  end
  
  --Place a trap on 2,2.  Slumber trap, revealed.
  --map:PlaceItem(RogueElements.Loc(2, 2), RogueEssence.Dungeon.EffectTile("trap_slumber", true))
  local trap_tile = map:GetTile(RogueElements.Loc(2, 2))
  trap_tile.Effect = RogueEssence.Dungeon.EffectTile("trap_slumber", true)
  
  --Place item on 3,2.  Banana, sticky
  --map:PlaceItem(RogueElements.Loc(3, 2), RogueEssence.Dungeon.MapItem(6))
  local new_item = RogueEssence.Dungeon.MapItem(6)
  new_item.Cursed = true
  new_item.TileLoc = RogueElements.Loc(3, 2)
  map.Items:Add(new_item)
  
  --Place item on 3,3.  Random amount of G between 50 and 100
  --map:PlaceItem(RogueElements.Loc(3, 3), RogueEssence.Dungeon.MapItem(true, 100))
  new_item = RogueEssence.Dungeon.MapItem.CreateMoney(map.Rand:Next(50, 101)) -- you must use the map.Rand, or else seeds wont be consistent
  new_item.TileLoc = RogueElements.Loc(3, 3)
  map.Items:Add(new_item)
  
  --Place enemies on 4,4, 4,5, together in a team, with AI of Normal Wander
  local new_team = RogueEssence.Dungeon.MonsterTeam()
  
  local mob_data = RogueEssence.Dungeon.CharData()
  mob_data.BaseForm = RogueEssence.Dungeon.MonsterID("mewtwo", 0, "normal", Gender.Male)
  mob_data.Level = 20;
  mob_data.BaseSkills[0] = RogueEssence.Dungeon.SlotSkill("pound")
  mob_data.BaseSkills[1] = RogueEssence.Dungeon.SlotSkill("fire_punch")
  mob_data.BaseSkills[2] = RogueEssence.Dungeon.SlotSkill("ice_punch")
  mob_data.BaseSkills[3] = RogueEssence.Dungeon.SlotSkill("thunder_punch")
  mob_data.BaseIntrinsics[0] = "drizzle"
  local new_mob = RogueEssence.Dungeon.Character(mob_data)
  local tactic = _DATA:GetAITactic("wander_normal")
  new_mob.Tactic = RogueEssence.Data.AITactic(tactic)
  new_mob.CharLoc = RogueElements.Loc(4, 4)
  new_mob.CharDir = Dir8.Down
  new_team.Players:Add(new_mob)
  
  mob_data = RogueEssence.Dungeon.CharData()
  mob_data.BaseForm = RogueEssence.Dungeon.MonsterID("mew", 0, "normal", Gender.Female)
  mob_data.Level = 25
  mob_data.BaseSkills[0] = RogueEssence.Dungeon.SlotSkill("pound")
  mob_data.BaseIntrinsics[0] = "speed_boost"
  new_mob = RogueEssence.Dungeon.Character(mob_data)
  tactic = _DATA:GetAITactic("wander_normal")
  new_mob.Tactic = RogueEssence.Data.AITactic(tactic)
  new_mob.CharLoc = RogueElements.Loc(5, 4)
  new_mob.CharDir = Dir8.Up
  new_team.Players:Add(new_mob)
  
  map.MapTeams:Add(new_team)
  
  --Place the player spawn just above the unbreakable wall (doesn't work if you already have one)
  map.GenEntrances:Add(RogueEssence.LevelGen.MapGenEntrance(RogueElements.Loc(map.Width / 2 - 1, map.Height / 2 - 2), Dir8.UpRight))
end




--Halcyon custom map gen steps
 --used for making the river in the Illuminant Riverbed
function FLOOR_GEN_SCRIPT.CreateRiver(map, args)
	local mapCenter = math.ceil(map.Width / 2)
	local randomOffset = map.Rand:Next(-2,3) --a random small offset added to all tiles to help randomize where the river falls a bit 
	local leftBound = math.floor(mapCenter / 2) + randomOffset --base left bound 
	local rightBound = math.ceil(mapCenter * 3 / 2) + randomOffset -- base right bound
	local leftOffset = map.Rand:Next(-1, 2)
	local rightOffset = map.Rand:Next(-1, 2)
	local leftShore = 0
	local rightShore = 0
	
	local leftOffsetRemaining = map.Rand:Next(1, 5)--how many times this specific offset can be used before being regenerated 
	local rightOffsetRemaining = map.Rand:Next(1, 5)
	
	
	
	--go row by row. Replace ground tiles towards the center of the map with water tiles to create a river flowing through the dungeon.
	--Ground tiles will remain untouched. River will ebb a bit side to side within a limit.
	
	for y = 0, map.Height-1, 1 do 
		
		--determine starting and ending positions for row of river
		--an offset will last for a few rows before trying to roll again for a new offset
		
		--roll new offsets and set new offset timer 
		--NOTE: map.Rand:Next(lower, upper) is inclusive on lower, and exclusive on upper 
		--todo: make this more clever
		if leftOffsetRemaining <= 0 then
			if leftOffset < 0 then
				leftOffset = map.Rand:Next(-1, 1)
			elseif leftOffset > 0 then 
				leftOffset = map.Rand:Next(0, 2)
			else 
				leftOffset = map.Rand:Next(-1, 2)
			end
			leftOffsetRemaining = map.Rand:Next(1, 5)
		end
		
		if rightOffsetRemaining <= 0 then
			if rightOffset < 0 then
				rightOffset = map.Rand:Next(-1, 1)
			elseif rightOffset > 0 then 
				rightOffset = map.Rand:Next(0, 2)
			else 
				rightOffset = map.Rand:Next(-1, 2)
			end
			rightOffsetRemaining = map.Rand:Next(1, 5)
		end
		
		leftShore = leftBound + leftOffset
		rightShore = rightBound + rightOffset
		--print("Left, right shore :" .. leftShore .. " " ..rightShore)
		--print("Left, right offset:" .. leftOffset .. " " .. rightOffset)
		--print("left, right offset remaining: " .. leftOffsetRemaining .. " " .. rightOffsetRemaining)
		
		--set all non ground tiles to water tiles between our left and right bounds 
		for x = leftShore, rightShore, 1 do 
			local loc = RogueElements.Loc(x, y)
			if not map:GetTile(loc):TileEquivalent(map.RoomTerrain) then
				map:TrySetTile(loc, RogueEssence.Dungeon.Tile("water"))
			end
	
	
		end 
		
		leftOffsetRemaining = leftOffsetRemaining - 1
		rightOffsetRemaining = rightOffsetRemaining - 1
		
	end 
	
	
end