require 'common'

ListType = luanet.import_type('System.Collections.Generic.List`1')
MobSpawnType = luanet.import_type('RogueEssence.LevelGen.MobSpawn')

SINGLE_CHAR_SCRIPT = {}

local function in_array(value, array)
    for index = 1, #array do
        if array[index] == value then
            return true
        end
    end

    return false -- We could ommit this part, as nil is like false
end


function SINGLE_CHAR_SCRIPT.Test(owner, ownerChar, context, args)
  PrintInfo("Test")
end

function SINGLE_CHAR_SCRIPT.ResetTurnCounter(owner, ownerChar, context, args)
	if context.User == _DUNGEON.ActiveTeam.Leader then
  	SV.MapTurnCounter = 1
	end
end

function SINGLE_CHAR_SCRIPT.IncrementTurnCounter(owner, ownerChar, context, args)
  SV.MapTurnCounter = SV.MapTurnCounter + 1
end

ShopSecurityType = luanet.import_type('PMDC.Dungeon.ShopSecurityState')
MapIndexType = luanet.import_type('RogueEssence.Dungeon.MapIndexState')


function SINGLE_CHAR_SCRIPT.ThiefCheck(owner, ownerChar, context, args)
  local baseLoc = _DUNGEON.ActiveTeam.Leader.CharLoc
  local tile = _ZONE.CurrentMap.Tiles[baseLoc.X][baseLoc.Y]
  
  local thief_idx = "thief"
  
  local price = COMMON.GetDungeonCartPrice()
  local security_price = COMMON.GetShopPriceState()
  if price < 0 then
    --lost merchandise was placed back in shop, readjust the security price and clear the current price
    security_price.Amount = security_price.Amount - price
  elseif price < security_price.Cart then
    --merchandise was returned.  doesn't matter who did it.
    security_price.Cart = price
  elseif price > security_price.Cart then
    local char_index = _ZONE.CurrentMap:GetCharIndex(context.User)
    if char_index.Faction ~= RogueEssence.Dungeon.Faction.Player then
      --non-player was responsible for taking/destroying merchandise, just readjust the security price and clear the current price
      security_price.Amount = security_price.Amount - price + security_price.Cart
	else
	  --player was responsible for taking/destroying merchandise, add to the cart
      security_price.Cart = price
    end
  end

  
  if tile.Effect.ID ~= "area_shop" then
	if security_price.Cart > 0 then
	  _GAME:BGM("", false)
      COMMON.ClearAllPrices()
	  
	  SV.adventure.Thief = true
	  local index_from = owner.StatusStates:Get(luanet.ctype(MapIndexType))
	  _DUNGEON:LogMsg(RogueEssence.StringKey(string.format("TALK_SHOP_THIEF_%04d", index_from.Index)):ToLocal())
		
	  -- create thief status
	  local thief_status = RogueEssence.Dungeon.MapStatus(thief_idx)
      thief_status:LoadFromData()
	  -- put spawner from security status in thief status
	  local security_to = thief_status.StatusStates:Get(luanet.ctype(ShopSecurityType))
	  local security_from = owner.StatusStates:Get(luanet.ctype(ShopSecurityType))
	  security_to.Security = security_from.Security
      TASK:WaitTask(_DUNGEON:RemoveMapStatus(owner.ID))
      TASK:WaitTask(_DUNGEON:AddMapStatus(thief_status))
	  GAME:WaitFrames(60)
	end
  else
    local shop_idx = "shopping"
	if not _ZONE.CurrentMap.Status:ContainsKey(thief_idx) and not _ZONE.CurrentMap.Status:ContainsKey(shop_idx) then
	  
	  local shop_status = RogueEssence.Dungeon.MapStatus(shop_idx)
      shop_status:LoadFromData()
      TASK:WaitTask(_DUNGEON:AddMapStatus(shop_status))
	end
  end
end

function SINGLE_CHAR_SCRIPT.ShopCheckout(owner, ownerChar, context, args)
  local baseLoc = _DUNGEON.ActiveTeam.Leader.CharLoc
  local tile = _ZONE.CurrentMap.Tiles[baseLoc.X][baseLoc.Y]

  if tile.Effect.ID ~= "area_shop" then
	local found_shopkeep = COMMON.FindNpcWithTable(false, "Role", "Shopkeeper")
    if found_shopkeep and COMMON.CanTalk(found_shopkeep) then
	  local security_state = COMMON.GetShopPriceState()
      local price = security_state.Cart
	  local sell_price = COMMON.GetDungeonSellPrice()
  
      if price > 0 or sell_price > 0 then
	    local is_near = false
		local loc_diff = _DUNGEON.ActiveTeam.Leader.CharLoc - found_shopkeep.CharLoc
		if loc_diff:Dist8() > 1 then
		  -- check to see if the shopkeeper can see the player and warp there
		  local near_mat = false
		  local dirs = { Direction.Down, Direction.DownLeft, Direction.Left, Direction.UpLeft, Direction.Up, Direction.UpRight, Direction.Right, Direction.DownRight }
		  for idx, dir in pairs(dirs) do
            if COMMON.ShopTileCheck(baseLoc, dir) then
		      near_mat = true
		    end
		  end
		  
		  if (near_mat or found_shopkeep:CanSeeCharacter(_DUNGEON.ActiveTeam.Leader)) then
	        -- attempt to warp the shopkeeper next to the player
		    local cand_locs = _ZONE.CurrentMap:FindNearLocs(found_shopkeep, baseLoc, 1)
		    if cand_locs.Count > 0 then
		      TASK:WaitTask(_DUNGEON:PointWarp(found_shopkeep, cand_locs[0], false))
			  is_near = true
		    end
		  end
		else
		  is_near = true
		end

		-- if it can't, fall through
		if is_near then
		  DUNGEON:CharTurnToChar(found_shopkeep, _DUNGEON.ActiveTeam.Leader)
		  DUNGEON:CharTurnToChar(_DUNGEON.ActiveTeam.Leader, found_shopkeep)
          UI:SetSpeaker(found_shopkeep)
		  
		  if sell_price > 0 then
		    UI:ChoiceMenuYesNo(STRINGS:Format(RogueEssence.StringKey(string.format("TALK_SHOP_SELL_%04d", found_shopkeep.Discriminator)):ToLocal(), STRINGS:FormatKey("MONEY_AMOUNT", sell_price)), false)
		    UI:WaitForChoice()
		    result = UI:ChoiceResult()
		  
		    if SV.adventure.Thief then
			  COMMON.ThiefReturn()
		    elseif result then
			  -- iterate player inventory prices and remove total price
			  COMMON.PayDungeonSellPrice(sell_price)
			  SOUND:PlayBattleSE("DUN_Money")
			  UI:WaitShowDialogue(RogueEssence.StringKey(string.format("TALK_SHOP_SELL_DONE_%04d", found_shopkeep.Discriminator)):ToLocal())
		    else
			  -- nothing
		    end
		  end
		  
		  if price > 0 then
	        UI:ChoiceMenuYesNo(STRINGS:Format(RogueEssence.StringKey(string.format("TALK_SHOP_PAY_%04d", found_shopkeep.Discriminator)):ToLocal(), STRINGS:FormatKey("MONEY_AMOUNT", price)), false)
	        UI:WaitForChoice()
	        result = UI:ChoiceResult()
	        if SV.adventure.Thief then
			  COMMON.ThiefReturn()
		    elseif result then
	          if price > GAME:GetPlayerMoney() then
                UI:WaitShowDialogue(RogueEssence.StringKey(string.format("TALK_SHOP_PAY_SHORT_%04d", found_shopkeep.Discriminator)):ToLocal())
	          else
	            -- iterate player inventory prices and remove total price
                COMMON.PayDungeonCartPrice(price)
		        SOUND:PlayBattleSE("DUN_Money")
	            UI:WaitShowDialogue(RogueEssence.StringKey(string.format("TALK_SHOP_PAY_DONE_%04d", found_shopkeep.Discriminator)):ToLocal())
	          end
	        end
		  end
		end
      else
        UI:SetSpeaker(found_shopkeep)
        UI:WaitShowDialogue(RogueEssence.StringKey(string.format("TALK_SHOP_END_%04d", found_shopkeep.Discriminator)):ToLocal())
      end
	end
  end
end

function SINGLE_CHAR_SCRIPT.DestinationFloor(owner, ownerChar, context, args)
	local missionNum = args.Mission
	local mission = SV.TakenBoard[missionNum]
	if not SV.DestinationFloorNotified then
		if mission.Type == COMMON.MISSION_TYPE_EXPLORATION then
			UI:ResetSpeaker()
			UI:WaitShowDialogue("Yes! You've reached the destination! " .. _DATA:GetMonster(mission.Client):GetColoredName().. " seems happy!")
			local escort = COMMON.FindMissionEscort(missionNum)
			if escort then
				--Clear but remember minimap state
				SV.TemporaryFlags.PriorMapSetting = _DUNGEON.ShowMap
				_DUNGEON.ShowMap = _DUNGEON.MinimapState.None
				GAME:WaitFrames(20)
				SV.TemporaryFlags.MissionCompleted = true
				mission.Completion = 1
				UI:SetSpeaker(escort)
				DUNGEON:CharTurnToChar(escort, GAME:GetPlayerPartyMember(0))
				DUNGEON:CharTurnToChar(GAME:GetPlayerPartyMember(0), escort)
				UI:WaitShowDialogue("Thank you for exploring this place with me!")

				GAME:WaitFrames(30)		
				--Set max team size to 4 as the guest is no longer "taking" up a party slot
				RogueEssence.Dungeon.ExplorerTeam.MAX_TEAM_SLOTS = 4
				TASK:WaitTask(_DUNGEON:ProcessBattleFX(escort, escort, _DATA.SendHomeFX))
				_DUNGEON:RemoveChar(escort)
				GAME:WaitFrames(50)
				GeneralFunctions.AskMissionWarpOut()
			end
		else
			SOUND:PlayFanfare("Fanfare/Note")
			UI:ResetSpeaker()
			UI:WaitShowDialogue("You've reached a destination floor!")
		end
		SV.DestinationFloorNotified = true
		GAME:WaitFrames(10)
	end
end

function SpawnOutlaw(origin, radius, mission_num)
	local mission = SV.TakenBoard[mission_num]
	local max_boost = 128
	local top_left = RogueElements.Loc(origin.X - radius, origin.Y - radius)
	local bottom_right =  RogueElements.Loc(origin.X + radius, origin.Y + radius)

	local rect_area = RogueElements.Loc(1)
	local rect_area2 = RogueElements.Loc(3)
	function checkBlock(loc)

		local result = _ZONE.CurrentMap:TileBlocked(loc)
		return result
	end

	function checkDiagBlock(loc)
		return true
	end
	
	local spawn_candidates = {}
	for x = top_left.X, bottom_right.X, 1 do
		for y = top_left.Y, bottom_right.Y, 1 do
			local testLoc = RogueElements.Loc(x, y)
			local is_choke_point = RogueElements.Grid.IsChokePoint(testLoc - rect_area, rect_area2, testLoc, checkBlock, checkDiagBlock)
			local tile_block = _ZONE.CurrentMap:TileBlocked(testLoc)
			local char_at = _ZONE.CurrentMap:GetCharAtLoc(testLoc)

			--don't spawn the outlaw directly next to the player or their teammates
			local next_to_player_units = false
			for i = 1, GAME:GetPlayerPartyCount(), 1 do 
				local party_member = GAME:GetPlayerPartyMember(i-1)
				if math.abs(party_member.CharLoc.X - x) <= 1 and math.abs(party_member.CharLoc.Y - y) <= 1 then
					next_to_player_units = true
					break
				end
			end
				
			--guests too!
			for i = 1, GAME:GetPlayerGuestCount(), 1 do 
				local party_member = GAME:GetPlayerGuestMember(i-1)
				if math.abs(party_member.CharLoc.X - x) <= 1 and math.abs(party_member.CharLoc.Y - y) <= 1 then
					next_to_player_units = true
					break
				end
			end	
			
			if tile_block == false and char_at == nil and not is_choke_point and not next_to_player_units then
				table.insert(spawn_candidates, testLoc)
			end
		end
	end

	local spawn_loc = spawn_candidates[_DATA.Save.Rand:Next(1, #spawn_candidates)]
	local new_team = RogueEssence.Dungeon.MonsterTeam()
	local mob_data = RogueEssence.Dungeon.CharData(true)
	local base_form_idx = 0
	local form = _DATA:GetMonster(mission.Target).Forms[base_form_idx]
	-- local gender = form:RollGender(_DATA.Save.Rand)
	mob_data.BaseForm = RogueEssence.Dungeon.MonsterID(mission.Target, base_form_idx, "normal", GeneralFunctions.NumToGender(mission.TargetGender))
	mob_data.Level = math.floor(MISSION_GEN.EXPECTED_LEVEL[mission.Zone] * 1.15)
	local ability = form:RollIntrinsic(_DATA.Save.Rand, 3)
	mob_data.BaseIntrinsics[0] = ability
	local new_mob = RogueEssence.Dungeon.Character(mob_data)
	--Old move learning logic
	--StringType = luanet.import_type('System.String')
	--local extra_moves = LUA_ENGINE:MakeGenericType(ListType, { StringType }, { })
	--local final_skills = form:RollLatestSkills(new_mob.Level, extra_moves)

	--for i = 0, final_skills.Count - 1, 1 do
	--	local skill = final_skills[i]
	--	new_mob:LearnSkill(skill, true)
    --end
	
	
	--TODO: Add logic to make sure outlaw has at least one decent attacking move based on their level.
	--<skilldata>.Data.Category == RogueEssence.Data.BattleData.SkillCategory.Physical
	--Pick 4 moves at random in the mon's level up table at that point. 
	--certain moves are blacklisted due to snaids.
	local skill_candidates = {}
	local skill_blacklist = {'teleport', 'gullotine', 'sheer_cold', 'horn_drill', 'fissure', 'memento',
							 'healing_wish', 'lunar_dance', 'self_destruct', 'explosion', 'final_gambit', 'perish_song',
							 'dragon_rage'}
	
	--print("Outlaw level is!: " .. tostring(mob_data.Level))
	--generate the skill candidate list based on level and the blacklist
	for i = 0,  _DATA:GetMonster(new_mob.BaseForm.Species).Forms[new_mob.BaseForm.Form].LevelSkills.Count - 1, 1 do
		local skill =_DATA:GetMonster(new_mob.BaseForm.Species).Forms[new_mob.BaseForm.Form].LevelSkills[i].Skill
		if _DATA:GetMonster(new_mob.BaseForm.Species).Forms[new_mob.BaseForm.Form].LevelSkills[i].Level <= new_mob.Level and not in_array(skill, skill_blacklist) then
			--print("new skill candidate!: " .. skill)
			table.insert(skill_candidates, skill)
		end 
	end
	
	--learn as many skills as we can from the candidate list.
	local learn_count = 0
	while learn_count < 4 and #skill_candidates > 0 do	
		local randval = _DATA.Save.Rand:Next(1, #skill_candidates)
		local learned_skill = skill_candidates[randval]
		new_mob:LearnSkill(learned_skill, true)
		learn_count = learn_count + 1
		--print("Outlaw learned " .. learned_skill)
		table.remove(skill_candidates, randval)
	end
	
	
	local tactic = nil
	if mission.Type == COMMON.MISSION_TYPE_OUTLAW_FLEE then
		local speedMin = math.floor(MISSION_GEN.EXPECTED_LEVEL[mission.Zone] / 1.5)
		local speedMax = math.floor(MISSION_GEN.EXPECTED_LEVEL[mission.Zone] * 1.5)
		new_mob.SpeedBonus = math.min(_DATA.Save.Rand:Next(speedMin, speedMax), 50)
		tactic = _DATA:GetAITactic("super_flee_stairs")
	else
		tactic = _DATA:GetAITactic("boss")
	end

	if mission.Type == COMMON.MISSION_TYPE_OUTLAW_ITEM then
		new_mob.EquippedItem = RogueEssence.Dungeon.InvItem(mission.Item)
	end
	
	new_mob.MaxHPBonus = math.min(MISSION_GEN.EXPECTED_LEVEL[mission.Zone] * 2, max_boost);
	new_mob.HP = new_mob.MaxHP;
	new_mob.Unrecruitable = true
	new_mob.Tactic = tactic
	new_mob.CharLoc = spawn_loc
	new_team.Players:Add(new_mob)
	
	tbl = LTBL(new_mob)
	tbl.Mission = mission_num
			
	_ZONE.CurrentMap.MapTeams:Add(new_team)
	new_mob:RefreshTraits()
	_ZONE.CurrentMap:UpdateExploration(new_mob)
	
	local base_name = RogueEssence.Data.DataManager.Instance.DataIndices[RogueEssence.Data.DataManager.DataType.Monster]:Get(new_mob.BaseForm.Species).Name:ToLocal()
	GAME:SetCharacterNickname(new_mob, base_name)
	return new_mob
end


function SINGLE_CHAR_SCRIPT.OutlawFloor(owner, ownerChar, context, args)
  local outlaw = context.User
  local tbl = LTBL(outlaw)
	if tbl ~= nil and tbl.Mission then
		local mission_num = args.Mission
		local mission = SV.TakenBoard[mission_num]
		outlaw.Nickname = RogueEssence.Dungeon.CharData.GetFullFormName( RogueEssence.Dungeon.MonsterID(mission.Target, 0, "normal", GeneralFunctions.NumToGender(mission.TargetGender)))
		SOUND:PlayBGM("C07. Outlaw.ogg", true, 20)
		UI:ResetSpeaker()
		DUNGEON:CharTurnToChar(outlaw, GAME:GetPlayerPartyMember(0))
		GeneralFunctions.TeamTurnTo(outlaw)
		UI:WaitShowDialogue("Wanted outlaw spotted!")

		if mission.Type == COMMON.MISSION_TYPE_OUTLAW_FLEE then
			GAME:WaitFrames(20)
			UI:SetSpeaker(outlaw)
			UI:WaitShowDialogue("Waah! A-adventurers! Run for it!")
			local leaderDir = _DUNGEON.ActiveTeam.Leader.CharDir
			outlaw.CharDir = leaderDir
		elseif mission.Type == COMMON.MISSION_TYPE_OUTLAW_MONSTER_HOUSE then
			GAME:WaitFrames(20)
			UI:SetSpeaker(outlaw)
			UI:WaitShowDialogue("You've fallen into my trap!")
			SOUND:FadeOutBGM(20)
			GAME:WaitFrames(20)
      
			-- ===========Monster house spawning logic============
			local rect_area = RogueElements.Loc(1)
			local rect_area2 = RogueElements.Loc(3)

			function checkBlock(loc)
				local result = _ZONE.CurrentMap:TileBlocked(loc)
				return result
			end
		
			function checkDiagBlock(loc)
				return true
			end
			
			
			local goon_spawn_radius = 5
      
			local origin = _DUNGEON.ActiveTeam.Leader.CharLoc

			local leftmost_x = math.maxinteger
			local rightmost_x = math.mininteger

			local downmost_y = math.mininteger
			local upmost_y = math.maxinteger


			local topLeft = RogueElements.Loc(origin.X - goon_spawn_radius, origin.Y - goon_spawn_radius)
			local bottomRight =  RogueElements.Loc(origin.X + goon_spawn_radius, origin.Y + goon_spawn_radius)

			local valid_tile_total = 0
			for x = math.max(topLeft.X, 0), math.min(bottomRight.X, _ZONE.CurrentMap.Width - 1), 1 do
				for y = math.max(topLeft.Y, 0), math.min(bottomRight.Y, _ZONE.CurrentMap.Height - 1), 1 do
					local testLoc = RogueElements.Loc(x,y)
					local is_choke_point = RogueElements.Grid.IsChokePoint(testLoc - rect_area, rect_area2, testLoc, checkBlock, checkDiagBlock)
					local tile_block = _ZONE.CurrentMap:TileBlocked(testLoc)
					local char_at = _ZONE.CurrentMap:GetCharAtLoc(testLoc)

					if tile_block == false and char_at == nil and not is_choke_point then
						valid_tile_total = valid_tile_total + 1
						leftmost_x = math.min(testLoc.X, leftmost_x)
						rightmost_x = math.max(testLoc.X, rightmost_x)
						downmost_y = math.max(testLoc.Y, downmost_y)
						upmost_y = math.min(testLoc.Y, upmost_y)
					end
				end
			end

			local house_event = PMDC.Dungeon.MonsterHouseMapEvent();

			local tl = RogueElements.Loc(leftmost_x - 1, upmost_y - 1)
			local br =  RogueElements.Loc(rightmost_x + 1, downmost_y + 1)

			local bounds = RogueElements.Rect.FromPoints(tl, br)
			house_event.Bounds = bounds

			local min_goons = math.floor(valid_tile_total / 5)
			local max_goons = math.floor(valid_tile_total / 4)
			local total_goons = _DATA.Save.Rand:Next(min_goons, max_goons)
			
			local all_spawns = LUA_ENGINE:MakeGenericType( ListType, { MobSpawnType }, { })
			for i = 0,  _ZONE.CurrentMap.TeamSpawns.Count - 1, 1 do
				local possible_spawns = _ZONE.CurrentMap.TeamSpawns:GetSpawn(i):GetPossibleSpawns()
				for j = 0, possible_spawns.Count - 1, 1 do
					local spawn = possible_spawns:GetSpawn(j):Copy()
					all_spawns:Add(spawn)
				end
			end

			for _ = 1, total_goons, 1 do
				local randint = _DATA.Save.Rand:Next(0, all_spawns.Count)
				local spawn = all_spawns[randint]
				spawn.SpawnFeatures:Add(PMDC.LevelGen.MobSpawnLuaTable('{ Goon = '..mission_num..' }'))
				spawn.SpawnFeatures:Add(PMDC.LevelGen.MobSpawnUnrecruitable())
				house_event.Mobs:Add(spawn)
			end
			local charaContext = RogueEssence.Dungeon.SingleCharContext(_DUNGEON.ActiveTeam.Leader)
			TASK:WaitTask(house_event:Apply(owner, ownerChar, charaContext))
			GAME:WaitFrames(20)
		else
			--to prevent accidental button mashing making you waste your turn
			GAME:WaitFrames(20)
		end
	end
end


function SINGLE_CHAR_SCRIPT.OnOutlawDeath(owner, ownerChar, context, args)
	local mission_num = args.Mission
	local tbl = LTBL(context.User)
	if tbl.Mission then
		SV.OutlawDefeated = true
		local curr_mission = SV.TakenBoard[mission_num]
		if curr_mission.Type == COMMON.MISSION_TYPE_OUTLAW_ITEM then
			SOUND:PlayBGM(_ZONE.CurrentMap.Music, true)
		end
	end

	tbl.Mission = nil
	tbl.Goon = nil

	local found_goon = COMMON.FindNpcWithTable(true, "Goon", mission_num)
	if not found_goon then
		SV.OutlawGoonsDefeated = true
	end
end

function SINGLE_CHAR_SCRIPT.OnMonsterHouseOutlawCheck(owner, ownerChar, context, args)
	local mission_number = args.Mission
	local curr_mission = SV.TakenBoard[mission_number]
	local outlaw_name = _DATA:GetMonster(curr_mission.Target):GetColoredName()

	if curr_mission.Completion == COMMON.MISSION_INCOMPLETE then
		local found_outlaw = COMMON.FindNpcWithTable(true, "Mission", mission_number)
		local found_goon = COMMON.FindNpcWithTable(true, "Goon", mission_number)
		--print("found outlaw = " .. tostring(found_outlaw) .. ", found_goon = " .. tostring(found_goon))
		if not SV.MonsterHouseMessageNotified then
			if found_goon and not found_outlaw then
				GAME:WaitFrames(20)
				UI:ResetSpeaker()
				UI:WaitShowDialogue("Yes! You defeated " .. outlaw_name .. "! Defeat the rest of the goons!" )
				SV.MonsterHouseMessageNotified = true
			end
			if not found_goon and found_outlaw then
				GAME:WaitFrames(40)
				UI:SetSpeaker(found_outlaw)
				UI:WaitShowDialogue("Grr! You won't be able to defeat me!")
				SV.MonsterHouseMessageNotified = true
			end
		end

		if not (found_goon or found_outlaw) then
			SOUND:PlayBGM(_ZONE.CurrentMap.Music, true)
			SV.TemporaryFlags.MissionCompleted = true
			curr_mission.Completion = 1
			GAME:WaitFrames(20)
			UI:ResetSpeaker()
			UI:WaitShowDialogue("Yes!\nKnocked out outlaw " .. outlaw_name .. " and goons!")
			SV.TemporaryFlags.PriorMapSetting = _DUNGEON.ShowMap
			_DUNGEON.ShowMap = _DUNGEON.MinimapState.None
			GeneralFunctions.AskMissionWarpOut()
		end
	end
end

function SINGLE_CHAR_SCRIPT.SpawnOutlaw(owner, ownerChar, context, args) 
	if context.User == GAME:GetPlayerPartyMember(0) then
		local mission_num = args.Mission
		local curr_mission = SV.TakenBoard[mission_num]
		if curr_mission.Completion == COMMON.MISSION_INCOMPLETE then
			local origin = _DATA.Save.ActiveTeam.Leader.CharLoc
			local radius = 3
			SpawnOutlaw(origin, radius, mission_num)
		end
	end
end

function SINGLE_CHAR_SCRIPT.OutlawCheck(owner, ownerChar, context, args)
	local mission_num = args.Mission
	local curr_mission = SV.TakenBoard[mission_num]
	if curr_mission.Completion == COMMON.MISSION_INCOMPLETE then
		if SV.OutlawDefeated then
			local curr_mission = SV.TakenBoard[mission_num]
			local outlaw_name = _DATA:GetMonster(curr_mission.Target):GetColoredName()
			SOUND:PlayBGM(_ZONE.CurrentMap.Music, true)
			SV.TemporaryFlags.MissionCompleted = true
			curr_mission.Completion = 1
			GAME:WaitFrames(50)
			UI:ResetSpeaker()
			UI:WaitShowDialogue("Yes!\nKnocked out outlaw " .. outlaw_name .. "!")
			--Clear but remember minimap state
			SV.TemporaryFlags.PriorMapSetting = _DUNGEON.ShowMap
			_DUNGEON.ShowMap = _DUNGEON.MinimapState.None
			GeneralFunctions.AskMissionWarpOut()
		end
	end
end

function SINGLE_CHAR_SCRIPT.OutlawItemCheck(owner, ownerChar, context, args)
	local mission_num = args.Mission
	local curr_mission = SV.TakenBoard[mission_num]
	if curr_mission.Completion == COMMON.MISSION_INCOMPLETE then
		if SV.OutlawDefeated and SV.OutlawItemPickedUp then
			SV.TemporaryFlags.MissionCompleted = true
			curr_mission.Completion = 1
			local item_name =  RogueEssence.Dungeon.InvItem(curr_mission.Item):GetDisplayName()
			SOUND:PlayBGM(_ZONE.CurrentMap.Music, true)
			GAME:WaitFrames(50)
			UI:ResetSpeaker()
			UI:WaitShowDialogue("Yes!\nYou reclaimed the " .. item_name .. "!")
			--Clear but remember minimap state
			SV.TemporaryFlags.PriorMapSetting = _DUNGEON.ShowMap
			_DUNGEON.ShowMap = _DUNGEON.MinimapState.None
			GeneralFunctions.AskMissionWarpOut()
		end
	end
end

function SINGLE_CHAR_SCRIPT.OutlawFleeStairsCheck(owner, ownerChar, context, args)
	local stairs_arr = {
		"stairs_back_down", "stairs_back_up", "stairs_exit_down", 
		"stairs_exit_up", "stairs_go_up", "stairs_go_down"
	}

	local mission_num = args.Mission
	local curr_mission = SV.TakenBoard[mission_num]
	local found_outlaw = COMMON.FindNpcWithTable(true, "Mission", mission_num)

	if found_outlaw then
		local targetName = found_outlaw:GetDisplayName(true)
		local map = _ZONE.CurrentMap;
		local charLoc = found_outlaw.CharLoc
		local tile = map:GetTile(charLoc)
		local tile_effect_id = tile.Effect.ID
		if tile and GeneralFunctions.TableContains(stairs_arr, tile_effect_id) then
			GAME:WaitFrames(20)
			_DUNGEON:RemoveChar(found_outlaw)
			GAME:WaitFrames(20)
			UI:ResetSpeaker()
			UI:WaitShowDialogue(targetName .. " escaped...")
			curr_mission.BackReference = COMMON.FLEE_BACKREFERENCE
			SOUND:PlayBGM(_ZONE.CurrentMap.Music, true)
			GAME:WaitFrames(20)
		end
	end
end

function SINGLE_CHAR_SCRIPT.OutlawClearCheck(owner, ownerChar, context, args)
	-- Keep this here since outlaw_clear_check might depend on this
end




function SINGLE_CHAR_SCRIPT.MissionGuestCheck(owner, ownerChar, context, args)
	
	if not context.User.Dead then
		return
	end

	local tbl = LTBL(context.User)

	if tbl ~= nil and tbl.Escort ~= nil then
		local targetName = _DATA:GetMonster(context.User.BaseForm.Species):GetColoredName()
		UI:ResetSpeaker()
		UI:WaitShowDialogue("Oh no! " ..  targetName .. " fainted!")
		GAME:WaitFrames(40)
		--Set max team size to 4 as the guest is no longer "taking" up a party slot
		RogueEssence.Dungeon.ExplorerTeam.MAX_TEAM_SLOTS = 4
		GeneralFunctions.WarpOut()
		GAME:WaitFrames(80)
		TASK:WaitTask(_GAME:EndSegment(RogueEssence.Data.GameProgress.ResultType.Failed))
	end
end

function SINGLE_CHAR_SCRIPT.MobilityEndTurn(owner, ownerChar, context, args)
	local mission_num = args.Mission
	if SV.TakenBoard[mission_num].Completion == COMMON.MISSION_INCOMPLETE then
		local npc = COMMON.FindNpcWithTable(false, "Mission", args.Mission)
		if npc then
			npc.Mobility = RogueEssence.Data.TerrainData.Mobility.Passable
		end
	end
end

--custom Halcyon SINGLE_CHAR_SCRIPT scripts

--Check to make sure the partner or hero is not dead, or anyone else marked as "IsPartner"
--checks guests as well
--if one is dead, then cause an instant game over
--if someone died and they aren't "IsPartner", then send them home automatically.
function SINGLE_CHAR_SCRIPT.AllyDeathCheck(owner, ownerChar, context, args)
	local player_count = GAME:GetPlayerPartyCount()
	local guest_count = GAME:GetPlayerGuestCount()
	if player_count < 1 then return end--If there's no party members then we dont need to do anything
	for i = 0, player_count - 1, 1 do 
		local player = GAME:GetPlayerPartyMember(i)
		if player.Dead and player.IsPartner then --someone died 
			for j = 0, player_count - 1, 1 do --beam everyone else out
				player = GAME:GetPlayerPartyMember(j)
				if not player.Dead then--dont beam out whoever died
					--delay between beam outs
					GAME:WaitFrames(60)
					TASK:WaitTask(_DUNGEON:ProcessBattleFX(player, player, _DATA.SendHomeFX))
					player.Dead = true
				end
			end
			--beam out guests
			for j = 0, guest_count - 1, 1 do --beam everyone else out
				guest = GAME:GetPlayerGuestMember(j)
				if not guest.Dead then--dont beam out whoever died
					--delay between beam outs
					GAME:WaitFrames(60)
					TASK:WaitTask(_DUNGEON:ProcessBattleFX(guest, guest, _DATA.SendHomeFX))
					guest.Dead = true
				end
			end
			--TASK:WaitTask(_GAME:EndSegment(RogueEssence.Data.GameProgress.ResultType.Failed))
			return--cut the script short here if someone died, no need to check guests
		elseif player.Dead and not player.IsPartner then 
			--Send them back to the assembly and boot them from the current team if they died and aren't important.
			TASK:WaitTask(_DUNGEON:SilentSendHome(i))
		end
	end
	
	--check guests as well
	if guest_count < 1 then return end--If there's no guest members then we dont need to do anything
	for i = 0, guest_count - 1, 1 do 
		local guest = GAME:GetPlayerGuestMember(i)
		if guest.Dead and guest.IsPartner then --someone died 
			--beam player's team out first
			for j = 0, player_count - 1, 1 do --beam everyone else out
				player = GAME:GetPlayerPartyMember(j)
				if not player.Dead then--dont beam out whoever died
					TASK:WaitTask(_DUNGEON:ProcessBattleFX(player, player, _DATA.SendHomeFX))
					player.Dead = true
					GAME:WaitFrames(60)
				end
			end
			for j = 0, guest_count - 1, 1 do --beam everyone else out
				guest = GAME:GetPlayerGuestMember(j)
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

--sets critical health status if teammate's health is low. This just adds a cosmetic Exclamation point over their head.
function SINGLE_CHAR_SCRIPT.SetCriticalHealthStatus(owner, ownerChar, context, args)
	local player_count = GAME:GetPlayerPartyCount()
	local critical = RogueEssence.Dungeon.StatusEffect("critical_health")
	for i = 0, player_count - 1, 1 do 
	local player = GAME:GetPlayerPartyMember(i)
		if player.HP <= player.MaxHP / 4 and player:GetStatusEffect("critical_health") == nil then 
			TASK:WaitTask(player:AddStatusEffect(nil, critical, false))
			--print("Set crit health!")
		elseif player.HP > player.MaxHP / 4 and player:GetStatusEffect("critical_health") ~= nil then
			TASK:WaitTask(player:RemoveStatusEffect("critical_health"))
			--print("Remove crit health!")
		end
	end
end




--Halcyon dungeon scripts

--For Ledian's speeches within the beginner lesson
function SINGLE_CHAR_SCRIPT.BeginnerLessonSpeech(owner, ownerChar, context, args)
  if context.User == nil then return end
  if context.User == GAME:GetPlayerPartyMember(0) then--this check is needed so that the script runs only once, otherwise it'll run for each entity in the map. 
	GAME:QueueLeaderEvent(function() BeginnerLessonSpeechHelper(owner, ownerChar, context, args) end)--
  end
end

--helper function to go with queueleaderevent call in BeginnerLessonSpeech
function BeginnerLessonSpeechHelper(owner, ownerChar, context, args)
	--slight pause if this isn't being called by asking Ledian for help. Don't pause if ledian wouldn't say anything (restepping on trigger tile)
	if SV.Tutorial.Progression ~= -1  and args.Speech > SV.Tutorial.Progression then GAME:WaitFrames(20) end 
	
	if args.Speech == 1 and SV.Tutorial.Progression < 1 then
		beginner_lesson_evt.Floor_1_Intro(owner, ownerChar, context.User, args)
		GAME:WaitFrames(20)--prevent mashing causing you to accidentially speak to Ledian or attack the air
	elseif args.Speech == 2 and SV.Tutorial.Progression < 2 then
		beginner_lesson_evt.Floor_2_Intro(owner, ownerChar, context.User, args)
		GAME:WaitFrames(20)
	elseif args.Speech == 3 and SV.Tutorial.Progression < 3 then
		beginner_lesson_evt.Floor_3_Intro(owner, ownerChar, context.User, args)
		GAME:WaitFrames(20)
	elseif args.Speech == 4 and SV.Tutorial.Progression < 4 then
		beginner_lesson_evt.Floor_3_Wand_Speech(owner, ownerChar, context.User, args)
		GAME:WaitFrames(20)
	elseif args.Speech == 5 and SV.Tutorial.Progression < 5 then
		beginner_lesson_evt.Floor_3_HeldItem_Speech(owner, ownerChar, context.User, args)
		GAME:WaitFrames(20)
	elseif args.Speech == 6 and SV.Tutorial.Progression < 6 then
		beginner_lesson_evt.Floor_3_ThrownReviver_Speech(owner, ownerChar, context.User, args)
		GAME:WaitFrames(20)
	elseif args.Speech == 7 and SV.Tutorial.Progression < 7 then
		beginner_lesson_evt.Floor_4_Intro(owner, ownerChar, context.User, args)
		GAME:WaitFrames(20)
	elseif args.Speech == 8 and SV.Tutorial.Progression < 8 then
		beginner_lesson_evt.Floor_4_Key_Speech(owner, ownerChar, context.User, args)
		GAME:WaitFrames(20)
	elseif args.Speech == 9 and SV.Tutorial.Progression < 9 then
		beginner_lesson_evt.Floor_5_Intro(owner, ownerChar, context.User, args)
		GAME:WaitFrames(20)
	end
end

--Make sure target character is holding the Band of Passage or they will be warped away
function SINGLE_CHAR_SCRIPT.BeginnerLessonHeldItemCheck(owner, ownerChar, context, args)
	if context.User ~= GAME:GetPlayerGuestMember(0) and context.User.EquippedItem.ID ~= "held_band_of_passage" then--band of passage. Ledian is allowed to pass no matter what
		_DUNGEON:LogMsg(STRINGS:Format("{0} doesn't have a {1} equipped!", context.User:GetDisplayName(false), RogueEssence.Dungeon.InvItem("held_band_of_passage"):GetDisplayName()))
		GAME:WaitFrames(40)
		TASK:WaitTask(_DUNGEON:PointWarp(context.User, RogueElements.Loc(18, 18), true)) --warp them to the specified x18, y18 tile with a message saying they warped
	elseif context.User ~= GAME:GetPlayerGuestMember(0) then --no messages or checks should be done on Ledian
		_DUNGEON:LogMsg(STRINGS:Format("{0} has a {1} equipped and is allowed to pass!", context.User:GetDisplayName(false), RogueEssence.Dungeon.InvItem("held_band_of_passage"):GetDisplayName()))
	end
end

function SINGLE_CHAR_SCRIPT.CheckOngoingMissions(owner, ownerChar, context, args)
	local curr_zone = _ZONE.CurrentZoneID
	local curr_segment = _ZONE.CurrentMapID.Segment
	local curr_floor = GAME:GetCurrentFloor().ID + 1
	for _, mission in ipairs(SV.TakenBoard) do
		if mission.BackReference ~= COMMON.FLEE_BACKREFERENCE and mission.Taken and mission.Completion == COMMON.MISSION_INCOMPLETE and curr_floor == mission.Floor and curr_zone == mission.Zone and curr_segment == mission.Segment then
			UI:ResetSpeaker()
			UI:ChoiceMenuYesNo("You currently have an ongoing mission on this floor.\nDo you still want to proceed?", true)
			UI:WaitForChoice()
			local continue = UI:ChoiceResult()
			if not continue then
				context.CancelState.Cancel = true
				context.TurnCancel.Cancel = true
				break
			end
		end
	end
end

function SINGLE_CHAR_SCRIPT.RelicForestFlipStairs(owner, ownerChar, context, args)
	if context.User == _DUNGEON.ActiveTeam.Leader then
		local map = _ZONE.CurrentMap
		for xx = 0, map.Width - 1, 1 do
			for yy = 0, map.Height - 1, 1 do
				local loc = RogueElements.Loc(xx, yy)
				local tl = map:GetTile(loc)
				local sec_loc = RogueEssence.Dungeon.SegLoc(0, -1)
				local dest_state = PMDC.Dungeon.DestState(sec_loc, true)
				dest_state.PreserveMusic = true
				if tl.Effect.ID == "stairs_go_up" then
					tl.Effect.TileStates:Set(dest_state)
					tl.Effect.ID = "stairs_back_down"
				end
			end
		end
	end
end


--Halcyon Script
--Popup in Normal maze IF player skipped the tutorial to let them know that Team Mode exists.
function SINGLE_CHAR_SCRIPT.SkippedTutorialTeamModeNotification(owner, ownerChar, context, args)
	if context.User == nil and SV.Chapter2.SkippedTutorial and not SV.Dojo.SkippedTutorialNotifiedTeamMode then 
		UI:ResetSpeaker()
		SOUND:PlayFanfare("Fanfare/Note")
		UI:WaitShowDialogue("Did you know?[pause=0] You can control each of your party member's actions for a given turn with Team Mode!")
		UI:WaitShowDialogue("You can toggle Team Mode by pressing " .. STRINGS:LocalKeyString(7) .. ".")
		SV.Dojo.SkippedTutorialNotifiedTeamMode = true
		GAME:WaitFrames(20)--to prevent mashing making you do an attack after clearing box
	end
end
--Halcyon script
--Popups with information on how to play the game in Relic Forest's first two pass throughs
function SINGLE_CHAR_SCRIPT.RelicForestTutorial(owner, ownerChar, context, args)
  if context.User == nil then
    --note: each floor has 2 messages as the 2nd set of messages plays on the playthrough back with the partner
    UI:ResetSpeaker()
    if args.Floor == 1 then
			if SV.Chapter1.TutorialProgression < 1 then
				SOUND:PlayFanfare("Fanfare/Note")
				UI:WaitShowDialogue("Head for the stairs![pause=0] You can attack enemies by pressing " .. STRINGS:LocalKeyString(2) .. ".[pause=0] Enemies don't move or attack until you do.")
				UI:WaitShowDialogue("Press " .. STRINGS:LocalKeyString(0) .. " to confirm selections or press " .. STRINGS:LocalKeyString(1) .. " to cancel.")
				SV.Chapter1.TutorialProgression = 1
				GAME:WaitFrames(20)
			elseif SV.Chapter1.PartnerMetHero and SV.Chapter1.TutorialProgression < 10 then
				SOUND:PlayFanfare("Fanfare/Note")
				UI:WaitShowDialogue("Want to change settings such as controls, battle speed, or window size?[pause=0] Press " .. STRINGS:LocalKeyString(9) .. " and check the Others menu.")
				SV.Chapter1.TutorialProgression = 10
				GAME:WaitFrames(20)
			end 		
	end
    elseif args.Floor == 2 then
	  	if SV.Chapter1.TutorialProgression < 2 then
				SOUND:PlayFanfare("Fanfare/Note")
				UI:WaitShowDialogue("To earn Exp. Points,[pause=10] a Pokémon must use at least one move against a foe,[pause=10] rather than just its basic " .. STRINGS:LocalKeyString(2) .. " attack.")
				UI:WaitShowDialogue("To use moves,[pause=10] hold " .. STRINGS:LocalKeyString(4) .. ",[pause=10] then press " .. STRINGS:LocalKeyString(21) .. ",[pause=10] " .. STRINGS:LocalKeyString(22) .. ",[pause=10] " .. STRINGS:LocalKeyString(23) .. ",[pause=10] or " .. STRINGS:LocalKeyString(24) .. " to use the corresponding move.")
				UI:WaitShowDialogue("Alternatively,[pause=10] press " .. STRINGS:LocalKeyString(9) .. " and choose the Moves option or press " .. STRINGS:LocalKeyString(11) .. " to access the Moves menu.")
				SV.Chapter1.TutorialProgression = 2
				GAME:WaitFrames(20)
			elseif SV.Chapter1.PartnerMetHero and SV.Chapter1.TutorialProgression < 9 then
				SOUND:PlayFanfare("Fanfare/Note")
				UI:WaitShowDialogue("To view a history of recent actions,[pause=10] press " .. STRINGS:LocalKeyString(10) .. ".")
				UI:WaitShowDialogue("You can also toggle minimap modes using " .. STRINGS:LocalKeyString(8) .. ",[pause=10] and view the status of your team using " .. STRINGS:LocalKeyString(14) .. ".")
				SV.Chapter1.TutorialProgression = 9 
				GAME:WaitFrames(20)
			end 
    elseif args.Floor == 3 then
			if SV.Chapter1.TutorialProgression < 3 then
				SOUND:PlayFanfare("Fanfare/Note")
				UI:WaitShowDialogue("You can carry a number of items.[pause=0] Items have a number of various effects and uses.")
				UI:WaitShowDialogue("To see what items you are carrying,[pause=10] press " .. STRINGS:LocalKeyString(9) .. " and choose the Items option.")
				UI:WaitShowDialogue("Alternatively,[pause=10] press " .. STRINGS:LocalKeyString(12) .. " to access your items more quickly.") 
				SV.Chapter1.TutorialProgression = 3
				GAME:WaitFrames(20)
			elseif SV.Chapter1.PartnerMetHero and SV.Chapter1.TutorialProgression < 8 then
				SOUND:PlayFanfare("Fanfare/Note")
				UI:WaitShowDialogue("You can hold " .. STRINGS:LocalKeyString(3) .. " to run![pause=0] This doesn't let you travel more distance in a single turn,[pause=10] but helps you navigate faster.")
				UI:WaitShowDialogue("Hold " .. STRINGS:LocalKeyString(5) .. " and press a direction to look that way without moving or using up your turn.")
				UI:WaitShowDialogue("You can also hold " .. STRINGS:LocalKeyString(6) .. " to only allow for diagonal movement.")
				SV.Chapter1.TutorialProgression = 8 
				GAME:WaitFrames(20)
			end 
    elseif args.Floor == 4 then
	  	if SV.Chapter1.TutorialProgression < 4 then
				local apple  = RogueEssence.Dungeon.InvItem("food_apple"):GetDisplayName()
				SOUND:PlayFanfare("Fanfare/Note")
				UI:WaitShowDialogue("If you get hungry,[pause=10] eat an " .. apple .. ".[pause=0] If your Belly runs empty,[pause=10] you will slowly lose health until you faint or eat something!")
				SV.Chapter1.TutorialProgression = 4
				GAME:WaitFrames(20)
			elseif SV.Chapter1.PartnerMetHero and SV.Chapter1.TutorialProgression < 7 then
				SOUND:PlayFanfare("Fanfare/Note")
				UI:WaitShowDialogue("Team members will receive Exp. Points when enemies are defeated.[pause=0] When a teammate gets enough,[pause=10] they will level up!")
				UI:WaitShowDialogue("A Pokémon will get more HP,[pause=10] higher stats,[pause=10] and possibly a new move each time it levels up.")
				UI:WaitShowDialogue("Make sure to fight enemies if you want to toughen up!")
				SV.Chapter1.TutorialProgression = 7 
				GAME:WaitFrames(20)
			end
    elseif args.Floor == 5 then
	  if SV.Chapter1.TutorialProgression < 5 then
				SOUND:PlayFanfare("Fanfare/Note")
				UI:WaitShowDialogue("In your travels you may see a black tile with a green arrow.[pause=0] This is known as a Wonder Tile.")
				UI:WaitShowDialogue("Step on one to reset the stat changes of yourself and anyone nearby.")
				SV.Chapter1.TutorialProgression = 5
				GAME:WaitFrames(20)
			elseif SV.Chapter1.PartnerMetHero and SV.Chapter1.TutorialProgression < 6 then
				SOUND:PlayFanfare("Fanfare/Note")
				UI:WaitShowDialogue("Watch the HP stats of you and your partner at the top of the screen.[pause=0] If a Pokémon's HP reaches 0,[pause=10] it will faint!")
				UI:WaitShowDialogue("If either you or your partner faint,[pause=10] you will both be ejected from the dungeon![pause=0] So work together to get through danger!")
				SV.Chapter1.TutorialProgression = 6 
				GAME:WaitFrames(20)
    end
  end
end