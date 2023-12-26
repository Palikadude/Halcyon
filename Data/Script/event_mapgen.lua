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
ScriptGenStepType = luanet.import_type('RogueEssence.LevelGen.ScriptGenStep`1')

MapEffectStepType = luanet.import_type('RogueEssence.LevelGen.MapEffectStep`1')
MapGenContextType = luanet.import_type('RogueEssence.LevelGen.ListMapGenContext')
EntranceType = luanet.import_type('RogueEssence.LevelGen.MapGenEntrance')

RandomRoomSpawnStepType = luanet.import_type('RogueElements.RandomRoomSpawnStep`2')
PickerSpawnType = luanet.import_type('RogueElements.PickerSpawner`2')
PresetMultiRandType = luanet.import_type('RogueElements.PresetMultiRand`1')
PresetPickerType = luanet.import_type('RogueElements.PresetPicker`1')
MapItemType = luanet.import_type('RogueEssence.Dungeon.MapItem')

function ZONE_GEN_SCRIPT.GenerateMissionFromSV(zoneContext, context, queue, seed, args)
  SV.DestinationFloorNotified = false
  SV.MonsterHouseMessageNotified = false
  SV.OutlawDefeated = false
  SV.OutlawGoonsDefeated = false
  SV.OutlawItemPickedUp = false
  local partner = GAME:GetPlayerPartyMember(1)
  local tbl = LTBL(partner)
  tbl.MissionNumber = nil
  tbl.MissionType = nil
  tbl.EscortMissionNum = nil
 
 local missionType = nil
  local missionNum = nil
  local escortMissionNum = nil
  local destinationFloor = false
  local outlawFloor = false
  local escortDeathEvent = false
  local activeEffect = RogueEssence.Data.ActiveEffect()

  for name, mission in pairs(SV.TakenBoard) do
    if mission.Taken and mission.Completion == COMMON.MISSION_INCOMPLETE and zoneContext.CurrentZone == mission.Zone and mission.BackReference ~= COMMON.FLEE_BACKREFERENCE then
      if mission.Type == COMMON.MISSION_TYPE_ESCORT or mission.Type == COMMON.MISSION_TYPE_EXPLORATION then
        PrintInfo("Adding escort death event...")
        escortDeathEvent = true
        escortMissionNum = name
      end
      if zoneContext.CurrentSegment == mission.Segment and zoneContext.CurrentID + 1 == mission.Floor then
        missionNum = name
        missionType = mission.Type
        PrintInfo("Spawning Mission Goal")
        local outlaw_arr = {
          COMMON.MISSION_TYPE_OUTLAW,
          COMMON.MISSION_TYPE_OUTLAW_ITEM,
          COMMON.MISSION_TYPE_OUTLAW_FLEE,
          COMMON.MISSION_TYPE_OUTLAW_MONSTER_HOUSE
        }
  
        if GeneralFunctions.TableContains(outlaw_arr, mission.Type) then -- outlaw
          -- local boost_feature = PMDC.LevelGen.MobSpawnBoost()
          -- local specificTeam = RogueEssence.LevelGen.SpecificTeamSpawner()
          -- local post_mob = RogueEssence.LevelGen.MobSpawn()
          -- post_mob.BaseForm = RogueEssence.Dungeon.MonsterID(mission.Target, 0, "normal", Gender.Unknown)
  
          -- if mission.Type == COMMON.MISSION_TYPE_OUTLAW_FLEE then
          --   local speedMin = math.floor(MISSION_GEN.EXPECTED_LEVEL[mission.Zone] / 1.5)
          --   local speedMax = math.floor(MISSION_GEN.EXPECTED_LEVEL[mission.Zone] * 1.5)
          --   local speedBoost = RogueElements.RandRange(speedMin, speedMax)
          --   speedBoost = math.min(speedBoost:Pick(_DATA.Save.Rand), 50)
          --   boost_feature.SpeedBonus = speedBoost
          --   post_mob.Tactic = "super_flee_stairs"
          -- else
          --   post_mob.Tactic = "boss"
          -- end
          -- -- Grab the outlaw level
          -- post_mob.Level = RogueElements.RandRange(
          --   math.floor(MISSION_GEN.EXPECTED_LEVEL[mission.Zone] * 1.15)
          -- )
          
          -- post_mob.SpawnFeatures:Add(PMDC.LevelGen.MobSpawnLuaTable('{ Mission = '..name..' }'))
          -- if mission.Type == COMMON.MISSION_TYPE_OUTLAW_ITEM then
          --   local item_feature = PMDC.LevelGen.MobSpawnItem(true, mission.Item)
          --   post_mob.SpawnFeatures:Add(item_feature)
          -- end
  
          -- boost_feature.MaxHPBonus = MISSION_GEN.EXPECTED_LEVEL[mission.Zone] * 2;
          -- post_mob.SpawnFeatures:Add(boost_feature)
  
          -- specificTeam.Spawns:Add(post_mob)
          -- PrintInfo("Creating Spawn")
          -- local picker = LUA_ENGINE:MakeGenericType(PresetMultiTeamSpawnerType, { MapGenContextType }, { })
          -- picker.Spawns:Add(specificTeam)
          -- PrintInfo("Creating Step")
          -- local mobPlacement = LUA_ENGINE:MakeGenericType(PlaceEntranceMobsStepType, { MapGenContextType, EntranceType }, { picker })
          -- PrintInfo("Enqueueing")
          -- -- Priority 5.2.1 is for NPC spawning in PMDO, but any dev can choose to roll with their own standard of priority.
          -- local priority = RogueElements.Priority(5, 2, 1)
          -- queue:Enqueue(priority, mobPlacement)
          -- PrintInfo("Done")
          outlawFloor = true
        else
          if mission.Type == COMMON.MISSION_TYPE_RESCUE or mission.Type == COMMON.MISSION_TYPE_DELIVERY or mission.Type == COMMON.MISSION_TYPE_ESCORT then 
            local specificTeam = RogueEssence.LevelGen.SpecificTeamSpawner()
            local post_mob = RogueEssence.LevelGen.MobSpawn()
            post_mob.BaseForm = RogueEssence.Dungeon.MonsterID(mission.Target, 0, "normal", GeneralFunctions.NumToGender(mission.TargetGender))
            post_mob.Tactic = "slow_wander"
            post_mob.Level = RogueElements.RandRange(50)
            if mission.Type == COMMON.MISSION_TYPE_RESCUE or mission.Type == COMMON.MISSION_TYPE_DELIVERY then -- rescue
              local dialogue = RogueEssence.Dungeon.BattleScriptEvent("RescueReached")
              post_mob.SpawnFeatures:Add(PMDC.LevelGen.MobSpawnInteractable(dialogue))
              post_mob.SpawnFeatures:Add(PMDC.LevelGen.MobSpawnLuaTable('{ Mission = '..name..' }'))
            elseif mission.Type == COMMON.MISSION_TYPE_ESCORT then -- escort
              local dialogue = RogueEssence.Dungeon.BattleScriptEvent("EscortRescueReached")
              post_mob.SpawnFeatures:Add(PMDC.LevelGen.MobSpawnInteractable(dialogue))
              post_mob.SpawnFeatures:Add(PMDC.LevelGen.MobSpawnLuaTable('{ Mission = '..name..' }'))
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
  end
  if missionNum ~= nil then
    tbl.MissionNumber = missionNum
  end
  if escortDeathEvent then
    tbl.EscortMissionNum = escortMissionNum
	activeEffect.OnDeaths:Add(6, RogueEssence.Dungeon.SingleCharScriptEvent("MissionGuestCheck", '{ Mission = '..escortMissionNum..' }'))
  end
  if destinationFloor then
    -- add destination floor notification
    activeEffect.OnMapStarts:Add(-6, RogueEssence.Dungeon.SingleCharScriptEvent("DestinationFloor", '{ Mission = '..missionNum..' }'))
    if missionType == COMMON.MISSION_TYPE_LOST_ITEM then
      activeEffect.OnPickups:Add(-6, RogueEssence.Dungeon.ItemScriptEvent("MissionItemPickup", '{ Mission = '..missionNum..' }'))
    end

    local npcMissions = { COMMON.MISSION_TYPE_DELIVERY, COMMON.MISSION_TYPE_ESCORT, COMMON.MISSION_TYPE_RESCUE }
    if GeneralFunctions.TableContains(npcMissions, missionType) then
      activeEffect.OnMapTurnEnds:Add(-6, RogueEssence.Dungeon.SingleCharScriptEvent("MobilityEndTurn", '{ Mission = '..missionNum..' }'))
    end
    tbl.MissionType = COMMON.MISSION_BOARD_MISSION
  end
  if outlawFloor then
    activeEffect.OnDeaths:Add(-6, RogueEssence.Dungeon.SingleCharScriptEvent("OnOutlawDeath", '{ Mission = '..missionNum..' }'))
    if missionType == COMMON.MISSION_TYPE_OUTLAW then
      activeEffect.OnTurnEnds:Add(-6, RogueEssence.Dungeon.SingleCharScriptEvent("OutlawCheck", '{ Mission = '..missionNum..' }'))
    elseif missionType == COMMON.MISSION_TYPE_OUTLAW_FLEE then
      activeEffect.OnMapTurnEnds:Add(-6, RogueEssence.Dungeon.SingleCharScriptEvent("OutlawFleeStairsCheck", '{ Mission = '..missionNum..' }'))
      activeEffect.OnTurnEnds:Add(-6, RogueEssence.Dungeon.SingleCharScriptEvent("OutlawCheck", '{ Mission = '..missionNum..' }'))
    elseif missionType == COMMON.MISSION_TYPE_OUTLAW_ITEM then
      activeEffect.OnPickups:Add(-6, RogueEssence.Dungeon.ItemScriptEvent("OutlawItemPickup", '{ Mission = '..missionNum..' }'))
      activeEffect.OnTurnEnds:Add(-6, RogueEssence.Dungeon.SingleCharScriptEvent("OutlawItemCheck", '{ Mission = '..missionNum..' }'))
    elseif missionType == COMMON.MISSION_TYPE_OUTLAW_MONSTER_HOUSE then
      activeEffect.OnTurnEnds:Add(-6, RogueEssence.Dungeon.SingleCharScriptEvent("OnMonsterHouseOutlawCheck", '{ Mission = '..missionNum..' }'))
    end

    activeEffect.OnMapStarts:Add(-11, RogueEssence.Dungeon.SingleCharScriptEvent("SpawnOutlaw", '{ Mission = '..missionNum..' }'))
    activeEffect.OnMapStarts:Add(-6, RogueEssence.Dungeon.SingleCharScriptEvent("OutlawFloor", '{ Mission = '..missionNum..' }'))
    tbl.MissionType = COMMON.MISSION_BOARD_OUTLAW
  end

  local destNote = LUA_ENGINE:MakeGenericType( MapEffectStepType, { MapGenContextType }, { activeEffect })
  local priority = RogueElements.Priority(-6)
  queue:Enqueue(priority, destNote)
end

function ZONE_GEN_SCRIPT.ReverseRelicForest(zoneContext, context, queue, seed, args)
  if SV.Chapter1.PartnerMetHero and not SV.Chapter1.TeamCompletedForest then
    local activeEffect = RogueEssence.Data.ActiveEffect()
    local destNote = LUA_ENGINE:MakeGenericType( MapEffectStepType, { MapGenContextType }, { activeEffect })
    local priority = RogueElements.Priority(-6)
    activeEffect.OnMapStarts:Add(-6, RogueEssence.Dungeon.SingleCharScriptEvent("RelicForestFlipStairs"))
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
 
--Used to create a somewhat irregular cross that cuts through Apricorn Grove. It's needed to add some more pathways for
--mobs to navigate the dungeon with and jump you more often
--Note: I think with the right RNG, the area in the middle may end up resembling a swastika. Be aware of this and perhaps adjust some numbers in the logic around to fix it if it ends up being an issue. I may just be paranoid.
function FLOOR_GEN_SCRIPT.CreateCrossHalls(map, args)
	
	--get the center of the map to start the cross from, plus or minus 1 or 2 for variety.
	local mapCenterX = math.ceil(map.Width / 2) + map.Rand:Next(-2, 3)
	local mapCenterY = math.ceil(map.Height / 2) + map.Rand:Next(-2, 3)
	
	local originTile = RogueElements.Loc(mapCenterX, mapCenterY)
	map:TrySetTile(originTile, RogueEssence.Dungeon.Tile("floor"))
	
	--try to set the tile to floor. If it's already floor, return true to let the loop know to break.
	local function SetTileOrBreak(x, y)
		local loc = RogueElements.Loc(x, y)
		if map:GetTile(loc):TileEquivalent(map.WallTerrain) then
			map:TrySetTile(loc, RogueEssence.Dungeon.Tile("floor"))
			return false
		elseif map:GetTile(loc):TileEquivalent(map.RoomTerrain) then
			return true --if we hit a floor tile, break early. Can't break in the local function, so return true to let the caller know.
		end
	end
	
	--i could have maybe figured out a way to be more clever and reuse the same functionality, since it's the same function but in different directions essentially, but this
	--was the most straightforward to my brain way of doing this.
	local function GenerateVertical(centerX, centerY, reverseDirection)
		local start, finish, sign
		if reverseDirection then 
			start = centerY + 1 
			finish = map.Height
			sign = 1
		else
			start = centerY - 1 
			finish = 0
			sign = -1
		end
		
		--Go in a given direction until we hit a floor tile. If we somehow never do (we always should), stop at the edge of the map
		local didSidestep = false
		local x = centerX
		for i = start, finish, sign do
			if SetTileOrBreak(x, i) then break end
			--Once you've left the origin at least map axis length / 10 tiles, start rolling a 1/7 chance to do a one time adjust to the side for a few tiles.		
			--sidestep will be for map axis length / 20 plus 0 or 1
			--only do 1 side step.
			if not didSidestep and math.abs(i - centerY) >=  math.floor(map.Height / 10) then
				if map.Rand:Next(1, 8) == 1 then 
					didSidestep = true
					local sidestepDirection = 1
					local sidestepDistance = math.floor(map.Height / 20) + map.Rand:Next(0, 2)
					--50% chance to turn left or right
					if map.Rand:Next(1, 3) == 1 then sidestepDirection = -1 end  
					for j = x + sidestepDirection, x + (sidestepDirection * sidestepDistance), sidestepDirection do 
						--do j + sidestep direction because without the sidestep addition, we'd be starting on the tile we're already on and immediately would hit a break
						x = j
						if SetTileOrBreak(x, i) then break end
					end 
				end 
			end
		end 
	end 
	
	local function GenerateHorizontal(centerX, centerY, reverseDirection)
		local start, finish, sign
		if reverseDirection then 
			start = centerX + 1 
			finish = map.Width
			sign = 1
		else
			start = centerX - 1 
			finish = 0
			sign = -1
		end
		
		--Go in a given direction until we hit a floor tile. If we somehow never do (we always should), stop at the edge of the map
		local didSidestep = false
		local y = centerY
		for i = start, finish, sign do
			if SetTileOrBreak(i, y) then break end
			--Once you've left the origin at least map axis length / 10 tiles, start rolling a 1/7 chance to do a one time adjust to the side for a few tiles.		
			--sidestep will be for map axis length / 20 plus 0 or 1.
			--only do 1 side step.
			if not didSidestep and math.abs(i - centerX) >=  math.floor(map.Width / 10) then
				if map.Rand:Next(1, 8) == 1 then 
					didSidestep = true
					local sidestepDirection = 1
					local sidestepDistance = math.floor(map.Width / 20) + map.Rand:Next(0, 2)
					--50% chance to turn left or right
					if map.Rand:Next(1, 3) == 1 then sidestepDirection = -1 end  
					--do j + sidestep direction because without the sidestep addition, we'd be starting on the tile we're already on and immediately would hit a break
					for j = y + sidestepDirection, y + (sidestepDirection * sidestepDistance), sidestepDirection do 
						y = j
						if SetTileOrBreak(i, y) then break end
					end 
				end 
			end
		end 
	end
	
	--With our functions defined, run them each twice, one for each direction.
	GenerateHorizontal(mapCenterX, mapCenterY, false)
	GenerateHorizontal(mapCenterX, mapCenterY, true)
	GenerateVertical(mapCenterX, mapCenterY, false)
	GenerateVertical(mapCenterX, mapCenterY, true)
	
	
 
end 
--used for making the river in the Illuminant Riverbed
function FLOOR_GEN_SCRIPT.CreateRiver(map, args)
    local riverBaseLength = 6
	local mapCenter = math.ceil(map.Width / 2)
	local randomOffset = map.Rand:Next(-2,3) --a random small offset added to all tiles to help randomize where the river falls a bit 
	local leftBound = mapCenter - riverBaseLength + randomOffset --base left bound 
	local rightBound = mapCenter + riverBaseLength - randomOffset -- base right bound
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
            local maploc = map:GetTile(loc)
			if not maploc:TileEquivalent(map.RoomTerrain) then
                if maploc.ID == "unbreakable" then
                    maploc.Data.StableTex = true
                    local texture = maploc.Data.TileTex
                    texture.AutoTileset = "sky_peak_4th_pass_secondary"
                else
                    map:TrySetTile(loc, RogueEssence.Dungeon.Tile("water"))
                end
            end

            --Check all adjacent tiles to see if we need to change their texture
            if RogueElements.Collision.InBounds(map.Width, map.Height, loc) then
                for curX = x-1, x+1, 1 do
                    for curY = y-1, y+1, 1 do
                        local curLoc = RogueElements.Loc(curX, curY)
                        if RogueElements.Collision.InBounds(map.Width, map.Height, curLoc) then
                            local curMapLoc = map:GetTile(curLoc)
                            if curMapLoc:TileEquivalent(map.RoomTerrain) and FLOOR_GEN_SCRIPT.IsBridge(map, curLoc, args) then
                                curMapLoc.Data.StableTex = true
                                local texture = curMapLoc.Data.TileTex
                                texture.AutoTileset = "sky_peak_4th_pass_secondary"
								
								--Roll to see what kind of rock to put down. Different varieties for flavor and to break up monotony, but this is purely a visual thing.
								local rock_type = "river_stone_diamond"
								if map.Rand:Next(0, 2) == 0 then
									rock_type = 'river_stone_round'
								end
								
                                local riverStone = RogueEssence.Dungeon.EffectTile(rock_type, true)
                                curMapLoc.Effect = riverStone
                            end
                        end
                    end
                end
            end
		end
		
		leftOffsetRemaining = leftOffsetRemaining - 1
		rightOffsetRemaining = rightOffsetRemaining - 1

    end
end

--Checks to see if at least one tile (with its two adjacent tiles having water) and its opposite have water
--If the opposite is out of bounds or has unbreakable, it's the map edge and we return true too
function FLOOR_GEN_SCRIPT.IsBridge(map, loc, args)
    local x = loc.X
    local y = loc.Y

    for curX = x-1, x+1, 1 do
        for curY = y-1, y+1, 1 do
            if curX ~= x or curY ~= y then
                local curLoc = RogueElements.Loc(curX, curY)
                if RogueElements.Collision.InBounds(map.Width, map.Height, curLoc) then
                    local maploc = map:GetTile(curLoc)
                    if maploc.ID == "water" then

                        local adjacentX1 = x
                        local adjacentY1 = y
                        local adjacentX2 = x
                        local adjacentY2 = y

                        --Get adjacent tiles
                        if curY == y then
                            adjacentX1 = x-1
                            adjacentX2 = x+1
                        elseif curX == x then
                            adjacentY1 = y-1
                            adjacentY2 = y+1
                        else
                            adjacentX1 = curX
                            adjacentY2 = curY
                        end
                    
                        --Get the tile across from the original tile with this one
                        local acrossX = (-1 * (curX - x)) + x
                        local acrossY = (-1 * (curY - y)) + y
                        local adjacentLoc1 = RogueElements.Loc(adjacentX1, adjacentY1)
                        local adjacentLoc2 = RogueElements.Loc(adjacentX2, adjacentY2)
                        local acrossLoc = RogueElements.Loc(acrossX, acrossY)
                        if RogueElements.Collision.InBounds(map.Width, map.Height, adjacentLoc1) and RogueElements.Collision.InBounds(map.Width, map.Height, adjacentLoc2) then
                            local adj1MapLoc = map:GetTile(adjacentLoc1)
                            local adj2MapLoc = map:GetTile(adjacentLoc2)
                            if adj1MapLoc.ID == "water" and adj2MapLoc.ID == "water" then
                                if RogueElements.Collision.InBounds(map.Width, map.Height, acrossLoc) == false then
                                    --This is adjacent to the edge of the map
                                    return true
                                end
                                local acrossMapLoc = map:GetTile(acrossLoc)
                                if acrossMapLoc.ID == "water" or acrossMapLoc.ID == "unbreakable" then
                                    return true
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end


