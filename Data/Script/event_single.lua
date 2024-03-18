require 'common'

--Import Serpent library.
Serpent = require 'lib.serpent'

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
	  _DUNGEON:LogMsg(STRINGS:Format(RogueEssence.StringKey(string.format("TALK_SHOP_THIEF_%04d", index_from.Index)):ToLocal()))
		
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
		  for idx, dir in ipairs(dirs) do
            if COMMON.ShopTileCheck(baseLoc, dir) then
		      near_mat = true
		    end
		  end
		  
		  if (near_mat or found_shopkeep:CanSeeCharacter(_DUNGEON.ActiveTeam.Leader)) then
	        -- attempt to warp the shopkeeper next to the player
		    local cand_locs = _ZONE.CurrentMap:FindNearLocs(found_shopkeep, baseLoc, 1)
		    if cand_locs.Count > 0 then
		      TASK:WaitTask(_DUNGEON:PointWarp(found_shopkeep, cand_locs[0], false))
			  GAME:WaitFrames(60)
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
			  price = 0
		    elseif result then
			  -- iterate player inventory prices and remove total price
			  COMMON.PayDungeonSellPrice(sell_price)
			  SOUND:PlayBattleSE("DUN_Money")
			  UI:WaitShowDialogue(STRINGS:Format(RogueEssence.StringKey(string.format("TALK_SHOP_SELL_DONE_%04d", found_shopkeep.Discriminator)):ToLocal()))
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
                UI:WaitShowDialogue(STRINGS:Format(RogueEssence.StringKey(string.format("TALK_SHOP_PAY_SHORT_%04d", found_shopkeep.Discriminator)):ToLocal()))
	          else
	            -- iterate player inventory prices and remove total price
                COMMON.PayDungeonCartPrice(price)
		        SOUND:PlayBattleSE("DUN_Money")
	            UI:WaitShowDialogue(STRINGS:Format(RogueEssence.StringKey(string.format("TALK_SHOP_PAY_DONE_%04d", found_shopkeep.Discriminator)):ToLocal()))
	          end
	        end
		  end
		end
      else
        UI:SetSpeaker(found_shopkeep)
		GAME:WaitFrames(10)
        UI:WaitShowDialogue(STRINGS:Format(RogueEssence.StringKey(string.format("TALK_SHOP_END_%04d", found_shopkeep.Discriminator)):ToLocal()))
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
	local max_boost = 256
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
	mob_data.Level = math.floor(MISSION_GEN.EXPECTED_LEVEL[mission.Zone] * 1.2)
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
		local speedMin = math.floor(MISSION_GEN.EXPECTED_LEVEL[mission.Zone] * (4 / 3))
		local speedMax = math.floor(MISSION_GEN.EXPECTED_LEVEL[mission.Zone] * 3)
		new_mob.SpeedBonus = math.min(_DATA.Save.Rand:Next(speedMin, speedMax), 100)
		tactic = _DATA:GetAITactic("super_flee_stairs")
	else
		tactic = _DATA:GetAITactic("boss")
	end

	if mission.Type == COMMON.MISSION_TYPE_OUTLAW_ITEM then
		new_mob.EquippedItem = RogueEssence.Dungeon.InvItem(mission.Item)
	end
	
	new_mob.MaxHPBonus = math.min(MISSION_GEN.EXPECTED_LEVEL[mission.Zone] * 4, max_boost);
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
			UI:SetSpeakerEmotion("Surprised")
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
	--initialize status data before adding it to anything
	critical:LoadFromData()
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

--For use in the Magcargo fight
--These are kinda done in a yandere-dev fashion, but I wasn't sure how to be more clever than this. I tried :(


--helper functions for Searing Tunnel's boss fight lava mechanic.
function SINGLE_CHAR_SCRIPT.DrawLavaPool(leftBottom, rightBottom, remove_lava)
	local map = _ZONE.CurrentMap
	local leftX = 5
	local rightX = 15
	local leftY = 8
	local rightY = 8
	--local spriteflip = 1 --it's already flipped to begin with, relative to left/right.
	local leftFlip = 1
	local rightFlip = 0
	local fliptype = luanet.import_type('RogueEssence.Content.SpriteFlip')

	if leftBottom then 
		leftY = 13
	end 
	
	if rightBottom then
		rightY = 13
	end
	
	local lava_anim_left = RogueEssence.Content.ObjAnimData('Spring_Cave_Pit_Lava_Pool_Connected', 4)
	local lava_anim_right = RogueEssence.Content.ObjAnimData('Spring_Cave_Pit_Lava_Pool_Connected', 4)
	lava_anim_left.AnimFlip = LUA_ENGINE:LuaCast(leftFlip, fliptype)
	lava_anim_right.AnimFlip = LUA_ENGINE:LuaCast(rightFlip, fliptype)

	
	--Do both lava pools at the same time. Do left, then right.
	SOUND:PlayBattleSE('_UNK_EVT_102')
	DUNGEON:MoveScreen(RogueEssence.Content.ScreenMover(2, 4, 30))
	--vfx
	if remove_lava then
		map.Decorations[0].Anims:RemoveAt(2)--Two decorations are placed on the map that shouldn't be removed, so 2 is where we need to delete from.
		map.Decorations[0].Anims:RemoveAt(2)--Two decorations are placed on the map that shouldn't be removed, so 2 is where we need to delete from.
	else
		--luacast the number value for the flip type needed to the RogueEssence SpriteFlip version
		map.Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(lava_anim_left, RogueElements.Loc(leftX * 24, leftY * 24)))
		map.Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(lava_anim_right, RogueElements.Loc(rightX * 24, rightY * 24)))
	end
	
	GAME:WaitFrames(40)
end 

--left and right bottom should always match for this function, but im writing it like this to match the skeleton of the others where it doesnt necessarily match
--this WAS more elegant before I had to rewrite it to avoid using couroutines from the parent call, but what can you do :v(
function SINGLE_CHAR_SCRIPT.DrawStraightFlow(leftBottom, rightBottom, remove_lava)
	local map = _ZONE.CurrentMap
	local leftX = 7
	local rightX = 14
	local leftY = 8
	local rightY = 8
	local leftDirectionY = 1 -- -1 to reverse direction
	local rightDirectionY = 1 -- -1 to reverse direction
	local effect_tile = 'flowing_lava'
	--local spriteflip = 1 --it's already flipped to begin with, relative to left/right.
	local fliptype = luanet.import_type('RogueEssence.Content.SpriteFlip')
	local leftFlip = 1
	local rightFlip = 0
	local leftOffsetY = 0--Need to offset the flipped sprites by an amount. Being on right side needs an x offset, being on the bottom needs a y offset.
	local rightOffsetY = 0

	if leftBottom then 
		leftY = 13
		leftDirectionY = -1
		leftOffsetY = -24
		leftFlip = 3
	end 
	
	if rightBottom then
		rightY = 13
		rightDirectionY = -1
		rightOffsetY = -24
		rightFlip = 2
	end
	
	if remove_lava then effect_tile = '' end
	
	local lava_anim_small_left = RogueEssence.Content.ObjAnimData('Spring_Cave_Pit_Small_Lava_Stream', 4)
	local lava_anim_big_left = RogueEssence.Content.ObjAnimData('Spring_Cave_Pit_Big_Lava_Stream', 4)
	lava_anim_small_left.AnimFlip = LUA_ENGINE:LuaCast(leftFlip, fliptype)
	lava_anim_big_left.AnimFlip = LUA_ENGINE:LuaCast(leftFlip, fliptype)

	local lava_anim_small_right = RogueEssence.Content.ObjAnimData('Spring_Cave_Pit_Small_Lava_Stream', 4)
	local lava_anim_big_right = RogueEssence.Content.ObjAnimData('Spring_Cave_Pit_Big_Lava_Stream', 4)
	lava_anim_small_right.AnimFlip = LUA_ENGINE:LuaCast(rightFlip, fliptype)
	lava_anim_big_right.AnimFlip = LUA_ENGINE:LuaCast(rightFlip, fliptype)


	--Do 2 "sections" of lava at a time, the equivalent ones on both the left and right side.
	SOUND:PlayBattleSE('_UNK_EVT_102')
	DUNGEON:MoveScreen(RogueEssence.Content.ScreenMover(2, 4, 30))
	
	--vfx
	if remove_lava then
		map.Decorations[0].Anims:RemoveAt(2)--Two decorations are placed on the map that shouldn't be removed, so 2 is where we need to delete from.
		map.Decorations[0].Anims:RemoveAt(2)--Two decorations are placed on the map that shouldn't be removed, so 2 is where we need to delete from.
	else
		map.Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(lava_anim_small_left, RogueElements.Loc(leftX * 24, leftY * 24 + leftOffsetY)))
		--right needs to be offset on x axis by -24
		map.Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(lava_anim_small_right, RogueElements.Loc(rightX * 24 - 24, rightY * 24 + rightOffsetY)))

	end
	
	--tiles
	local leftLoc = RogueElements.Loc(leftX, leftY)
	map:GetTile(leftLoc).Effect = RogueEssence.Dungeon.EffectTile(effect_tile, true, leftLoc)
	SINGLE_CHAR_SCRIPT.ApplyTileToCharacter(leftLoc)

	leftLoc = RogueElements.Loc(leftX + 1, leftY)
	map:GetTile(leftLoc).Effect = RogueEssence.Dungeon.EffectTile(effect_tile, true, leftLoc)
	SINGLE_CHAR_SCRIPT.ApplyTileToCharacter(leftLoc)

	leftLoc = RogueElements.Loc(leftX, leftY + leftDirectionY)
	map:GetTile(leftLoc).Effect = RogueEssence.Dungeon.EffectTile(effect_tile, true, leftLoc)			
	SINGLE_CHAR_SCRIPT.ApplyTileToCharacter(leftLoc)

	--then do right side.
	local rightLoc = RogueElements.Loc(rightX, rightY)
	map:GetTile(rightLoc).Effect = RogueEssence.Dungeon.EffectTile(effect_tile, true, rightLoc)
	SINGLE_CHAR_SCRIPT.ApplyTileToCharacter(rightLoc)

	rightLoc = RogueElements.Loc(rightX - 1, rightY)
	map:GetTile(rightLoc).Effect = RogueEssence.Dungeon.EffectTile(effect_tile, true, rightLoc)
	SINGLE_CHAR_SCRIPT.ApplyTileToCharacter(rightLoc)

	rightLoc = RogueElements.Loc(rightX, rightY + rightDirectionY)
	map:GetTile(rightLoc).Effect = RogueEssence.Dungeon.EffectTile(effect_tile, true, rightLoc)			
	SINGLE_CHAR_SCRIPT.ApplyTileToCharacter(rightLoc)
	
	
	--second wave
	GAME:WaitFrames(40)
	
	SOUND:PlayBattleSE('_UNK_EVT_102')
	DUNGEON:MoveScreen(RogueEssence.Content.ScreenMover(2, 4, 30))
	leftX = leftX + 2
	rightX = rightX - 2
	
	--vfx
	if remove_lava then
		map.Decorations[0].Anims:RemoveAt(2)--Two decorations are placed on the map that shouldn't be removed, so 2 is where we need to delete from.
		map.Decorations[0].Anims:RemoveAt(2)--Two decorations are placed on the map that shouldn't be removed, so 2 is where we need to delete from.
	else
		map.Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(lava_anim_big_left, RogueElements.Loc(leftX * 24, leftY * 24 + leftOffsetY)))
		map.Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(lava_anim_big_right, RogueElements.Loc(rightX * 24 - 24, rightY * 24 + rightOffsetY)))
	end

	--tiles
	leftLoc = RogueElements.Loc(leftX, leftY)
	map:GetTile(leftLoc).Effect = RogueEssence.Dungeon.EffectTile(effect_tile, true, leftLoc)
	SINGLE_CHAR_SCRIPT.ApplyTileToCharacter(leftLoc)

	leftLoc = RogueElements.Loc(leftX + 1, leftY)
	map:GetTile(leftLoc).Effect = RogueEssence.Dungeon.EffectTile(effect_tile, true, leftLoc)
	SINGLE_CHAR_SCRIPT.ApplyTileToCharacter(leftLoc)

	leftLoc = RogueElements.Loc(leftX, leftY + leftDirectionY)
	map:GetTile(leftLoc).Effect = RogueEssence.Dungeon.EffectTile(effect_tile, true, leftLoc)			
	SINGLE_CHAR_SCRIPT.ApplyTileToCharacter(leftLoc)	
	
	leftLoc = RogueElements.Loc(leftX + 1, leftY + leftDirectionY)
	map:GetTile(leftLoc).Effect = RogueEssence.Dungeon.EffectTile(effect_tile, true, leftLoc)			
	SINGLE_CHAR_SCRIPT.ApplyTileToCharacter(leftLoc)

	--then do right side.
	rightLoc = RogueElements.Loc(rightX, rightY)
	map:GetTile(rightLoc).Effect = RogueEssence.Dungeon.EffectTile(effect_tile, true, rightLoc)
	SINGLE_CHAR_SCRIPT.ApplyTileToCharacter(rightLoc)

	rightLoc = RogueElements.Loc(rightX - 1, rightY)
	map:GetTile(rightLoc).Effect = RogueEssence.Dungeon.EffectTile(effect_tile, true, rightLoc)
	SINGLE_CHAR_SCRIPT.ApplyTileToCharacter(rightLoc)

	rightLoc = RogueElements.Loc(rightX, rightY + rightDirectionY)
	map:GetTile(rightLoc).Effect = RogueEssence.Dungeon.EffectTile(effect_tile, true, rightLoc)			
	SINGLE_CHAR_SCRIPT.ApplyTileToCharacter(rightLoc)

	rightLoc = RogueElements.Loc(rightX - 1, rightY + rightDirectionY)
	map:GetTile(rightLoc).Effect = RogueEssence.Dungeon.EffectTile(effect_tile, true, rightLoc)			
	SINGLE_CHAR_SCRIPT.ApplyTileToCharacter(rightLoc)
	
		
	GAME:WaitFrames(40)

end 

--gets the tile at location, and applies its effect if someone is also standing at the location.
--Created for use with the lava flow scripts.
function SINGLE_CHAR_SCRIPT.ApplyTileToCharacter(loc)
	local tile = _ZONE.CurrentMap:GetTile(loc)
	local chara = _ZONE.CurrentMap:GetCharAtLoc(loc)
	if chara ~= nil and tile.Effect.ID ~= '' then--don't try to apply the tile if it's a nothing tile
		TASK:WaitTask(tile.Effect:InteractWithTile(RogueEssence.Dungeon.SingleCharContext(chara)))
	end
end 

function SINGLE_CHAR_SCRIPT.DrawDiagonalFlow(leftBottom, rightBottom, remove_lava)
	local map = _ZONE.CurrentMap
	local leftX = 7
	local rightX = 14
	local leftY = 8
	local rightY = 8
	local leftDirectionY = 1 -- -1 to reverse direction
	local rightDirectionY = 1 -- -1 to reverse direction
	local effect_tile = 'flowing_lava'
	--local spriteflip = 1 --it's already flipped to begin with, relative to left/right.
	local fliptype = luanet.import_type('RogueEssence.Content.SpriteFlip')
	local leftFlip = 1
	local rightFlip = 0
	local leftOffsetY = 0--Need to offset the flipped sprites by an amount. Being on right side needs an x offset, being on the bottom needs a y offset.
	local rightOffsetY = 0

	if leftBottom then 
		leftY = 13
		leftDirectionY = -1
		leftOffsetY = -24
		leftFlip = 3
	end 
	
	if rightBottom then
		rightY = 13
		rightDirectionY = -1
		rightOffsetY = -24
		rightFlip = 2
	end
	
	if remove_lava then effect_tile = '' end
	
	local lava_anim_small_left = RogueEssence.Content.ObjAnimData('Spring_Cave_Pit_Small_Lava_Stream', 4)
	local lava_anim_big_left = RogueEssence.Content.ObjAnimData('Spring_Cave_Pit_Big_Lava_Stream', 4)
	lava_anim_small_left.AnimFlip = LUA_ENGINE:LuaCast(leftFlip, fliptype)
	lava_anim_big_left.AnimFlip = LUA_ENGINE:LuaCast(leftFlip, fliptype)

	local lava_anim_small_right = RogueEssence.Content.ObjAnimData('Spring_Cave_Pit_Small_Lava_Stream', 4)
	local lava_anim_big_right = RogueEssence.Content.ObjAnimData('Spring_Cave_Pit_Big_Lava_Stream', 4)
	lava_anim_small_right.AnimFlip = LUA_ENGINE:LuaCast(rightFlip, fliptype)
	lava_anim_big_right.AnimFlip = LUA_ENGINE:LuaCast(rightFlip, fliptype)

	--Do 1 "section" of lava at a time.
	SOUND:PlayBattleSE('_UNK_EVT_102')
	DUNGEON:MoveScreen(RogueEssence.Content.ScreenMover(2, 4, 30))

	--vfx
	if remove_lava then
		map.Decorations[0].Anims:RemoveAt(2)--Two decorations are placed on the map that shouldn't be removed, so 2 is where we need to delete from.
		map.Decorations[0].Anims:RemoveAt(2)--Two decorations are placed on the map that shouldn't be removed, so 2 is where we need to delete from.
	else
		map.Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(lava_anim_small_left, RogueElements.Loc(leftX * 24, leftY * 24 + leftOffsetY)))
		--right needs to be offset on x axis by -24
		map.Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(lava_anim_small_right, RogueElements.Loc(rightX * 24 - 24, rightY * 24 + rightOffsetY)))
	end
	
	
	--tiles
	local leftLoc = RogueElements.Loc(leftX, leftY)
	map:GetTile(leftLoc).Effect = RogueEssence.Dungeon.EffectTile(effect_tile, true, leftLoc)
	SINGLE_CHAR_SCRIPT.ApplyTileToCharacter(leftLoc)

	leftLoc = RogueElements.Loc(leftX + 1, leftY)
	map:GetTile(leftLoc).Effect = RogueEssence.Dungeon.EffectTile(effect_tile, true, leftLoc)
	SINGLE_CHAR_SCRIPT.ApplyTileToCharacter(leftLoc)

	leftLoc = RogueElements.Loc(leftX, leftY + leftDirectionY)
	map:GetTile(leftLoc).Effect = RogueEssence.Dungeon.EffectTile(effect_tile, true, leftLoc)			
	SINGLE_CHAR_SCRIPT.ApplyTileToCharacter(leftLoc)

	--then do right side.
	local rightLoc = RogueElements.Loc(rightX, rightY)
	map:GetTile(rightLoc).Effect = RogueEssence.Dungeon.EffectTile(effect_tile, true, rightLoc)
	SINGLE_CHAR_SCRIPT.ApplyTileToCharacter(rightLoc)

	rightLoc = RogueElements.Loc(rightX - 1, rightY)
	map:GetTile(rightLoc).Effect = RogueEssence.Dungeon.EffectTile(effect_tile, true, rightLoc)
	SINGLE_CHAR_SCRIPT.ApplyTileToCharacter(rightLoc)

	rightLoc = RogueElements.Loc(rightX, rightY + rightDirectionY)
	map:GetTile(rightLoc).Effect = RogueEssence.Dungeon.EffectTile(effect_tile, true, rightLoc)			
	SINGLE_CHAR_SCRIPT.ApplyTileToCharacter(rightLoc)
	
		
	GAME:WaitFrames(40)
	
	--second wave
	SOUND:PlayBattleSE('_UNK_EVT_102')
	DUNGEON:MoveScreen(RogueEssence.Content.ScreenMover(2, 4, 30))
	leftX = leftX + 1
	rightX = rightX - 1
	leftY = leftY + leftDirectionY
	rightY = rightY + rightDirectionY
	
	--vfx
	if remove_lava then
		map.Decorations[0].Anims:RemoveAt(2)--Two decorations are placed on the map that shouldn't be removed, so 2 is where we need to delete from.
		map.Decorations[0].Anims:RemoveAt(2)--Two decorations are placed on the map that shouldn't be removed, so 2 is where we need to delete from.
	else
		map.Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(lava_anim_small_left, RogueElements.Loc(leftX * 24, leftY * 24 + leftOffsetY)))
		--right needs to be offset on x axis by -24
		map.Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(lava_anim_small_right, RogueElements.Loc(rightX * 24 - 24, rightY * 24 + rightOffsetY)))

	end

	--tiles
	leftLoc = RogueElements.Loc(leftX, leftY)
	map:GetTile(leftLoc).Effect = RogueEssence.Dungeon.EffectTile(effect_tile, true, leftLoc)
	SINGLE_CHAR_SCRIPT.ApplyTileToCharacter(leftLoc)

	leftLoc = RogueElements.Loc(leftX + 1, leftY)
	map:GetTile(leftLoc).Effect = RogueEssence.Dungeon.EffectTile(effect_tile, true, leftLoc)
	SINGLE_CHAR_SCRIPT.ApplyTileToCharacter(leftLoc)

	leftLoc = RogueElements.Loc(leftX, leftY + leftDirectionY)
	map:GetTile(leftLoc).Effect = RogueEssence.Dungeon.EffectTile(effect_tile, true, leftLoc)			
	SINGLE_CHAR_SCRIPT.ApplyTileToCharacter(leftLoc)	
	

	--then do right side.
	rightLoc = RogueElements.Loc(rightX, rightY)
	map:GetTile(rightLoc).Effect = RogueEssence.Dungeon.EffectTile(effect_tile, true, rightLoc)
	SINGLE_CHAR_SCRIPT.ApplyTileToCharacter(rightLoc)

	rightLoc = RogueElements.Loc(rightX - 1, rightY)
	map:GetTile(rightLoc).Effect = RogueEssence.Dungeon.EffectTile(effect_tile, true, rightLoc)
	SINGLE_CHAR_SCRIPT.ApplyTileToCharacter(rightLoc)

	rightLoc = RogueElements.Loc(rightX, rightY + rightDirectionY)
	map:GetTile(rightLoc).Effect = RogueEssence.Dungeon.EffectTile(effect_tile, true, rightLoc)			
	SINGLE_CHAR_SCRIPT.ApplyTileToCharacter(rightLoc)
	
	GAME:WaitFrames(40)

	SOUND:PlayBattleSE('_UNK_EVT_102')
	DUNGEON:MoveScreen(RogueEssence.Content.ScreenMover(2, 4, 30))
	leftX = leftX + 1
	rightX = rightX - 1
	leftY = leftY + leftDirectionY
	rightY = rightY + rightDirectionY
	
	--vfx
	if remove_lava then
		map.Decorations[0].Anims:RemoveAt(2)--Two decorations are placed on the map that shouldn't be removed, so 2 is where we need to delete from.
		map.Decorations[0].Anims:RemoveAt(2)--Two decorations are placed on the map that shouldn't be removed, so 2 is where we need to delete from.
	else
		map.Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(lava_anim_big_left, RogueElements.Loc(leftX * 24, leftY * 24 + leftOffsetY)))
		map.Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(lava_anim_big_right, RogueElements.Loc(rightX * 24 - 24, rightY * 24 + rightOffsetY)))
	end

	--tiles
	leftLoc = RogueElements.Loc(leftX, leftY)
	map:GetTile(leftLoc).Effect = RogueEssence.Dungeon.EffectTile(effect_tile, true, leftLoc)
	SINGLE_CHAR_SCRIPT.ApplyTileToCharacter(leftLoc)

	leftLoc = RogueElements.Loc(leftX + 1, leftY)
	map:GetTile(leftLoc).Effect = RogueEssence.Dungeon.EffectTile(effect_tile, true, leftLoc)
	SINGLE_CHAR_SCRIPT.ApplyTileToCharacter(leftLoc)

	leftLoc = RogueElements.Loc(leftX, leftY + leftDirectionY)
	map:GetTile(leftLoc).Effect = RogueEssence.Dungeon.EffectTile(effect_tile, true, leftLoc)			
	SINGLE_CHAR_SCRIPT.ApplyTileToCharacter(leftLoc)	
	
	leftLoc = RogueElements.Loc(leftX + 1, leftY + leftDirectionY)
	map:GetTile(leftLoc).Effect = RogueEssence.Dungeon.EffectTile(effect_tile, true, leftLoc)			
	SINGLE_CHAR_SCRIPT.ApplyTileToCharacter(leftLoc)

	--then do right side.
	rightLoc = RogueElements.Loc(rightX, rightY)
	map:GetTile(rightLoc).Effect = RogueEssence.Dungeon.EffectTile(effect_tile, true, rightLoc)
	SINGLE_CHAR_SCRIPT.ApplyTileToCharacter(rightLoc)

	rightLoc = RogueElements.Loc(rightX - 1, rightY)
	map:GetTile(rightLoc).Effect = RogueEssence.Dungeon.EffectTile(effect_tile, true, rightLoc)
	SINGLE_CHAR_SCRIPT.ApplyTileToCharacter(rightLoc)

	rightLoc = RogueElements.Loc(rightX, rightY + rightDirectionY)
	map:GetTile(rightLoc).Effect = RogueEssence.Dungeon.EffectTile(effect_tile, true, rightLoc)			
	SINGLE_CHAR_SCRIPT.ApplyTileToCharacter(rightLoc)

	rightLoc = RogueElements.Loc(rightX - 1, rightY + rightDirectionY)
	map:GetTile(rightLoc).Effect = RogueEssence.Dungeon.EffectTile(effect_tile, true, rightLoc)			
	SINGLE_CHAR_SCRIPT.ApplyTileToCharacter(rightLoc)
		
	GAME:WaitFrames(40)

end
function SINGLE_CHAR_SCRIPT.QueueLavaFlow()
	--Randomly choose top or bottom on each side. Draw a scripted lava flow from point A to point B afterwards.
	local map = _ZONE.CurrentMap
	
	--local top_left = RogueElements.Loc(7, 8)
	--local top_right = RogueElements.Loc(14, 8)
	--local bottom_left = RogueElements.Loc(7, 13)
	--local bottom_right = RogueElements.Loc(14, 13)
	
	--0 is top, 1 is bottom
	local left_side = map.Rand:Next(0,2)
	local right_side = map.Rand:Next(0,2)

	print("left side :" .. tostring(left_side) .. " right side: " .. tostring(right_side))


	--straight line across the top
	if left_side == right_side and left_side == 0 then
		SV.SearingTunnel.LavaFlowDirection = "TopStraight"
		SINGLE_CHAR_SCRIPT.DrawLavaPool(false, false, false)
		SINGLE_CHAR_SCRIPT.DrawStraightFlow(false, false, false)		
	--Straight line across the bottom
	elseif left_side == right_side and left_side == 1 then
		SV.SearingTunnel.LavaFlowDirection = "BottomStraight"
		SINGLE_CHAR_SCRIPT.DrawLavaPool(true, true, false)
		SINGLE_CHAR_SCRIPT.DrawStraightFlow(true, true, false)
	--Diagonal Down
	elseif left_side ~= right_side and left_side == 0 then
		SV.SearingTunnel.LavaFlowDirection = "DiagonalDown"
		SINGLE_CHAR_SCRIPT.DrawLavaPool(false, true, false)
		SINGLE_CHAR_SCRIPT.DrawDiagonalFlow(false, true, false)
	--diagonal up
	else
		SV.SearingTunnel.LavaFlowDirection = "DiagonalUp"
		SINGLE_CHAR_SCRIPT.DrawLavaPool(true, false, false)
		SINGLE_CHAR_SCRIPT.DrawDiagonalFlow(true, false, false)
	end
	

end 


function SINGLE_CHAR_SCRIPT.RemoveLavaFlow()
	--Remove the current lava flow.
	local map = _ZONE.CurrentMap
		
	print("Removing lava flow! " .. SV.SearingTunnel.LavaFlowDirection)
	--straight line across the top
	if SV.SearingTunnel.LavaFlowDirection == 'TopStraight' then
		SINGLE_CHAR_SCRIPT.DrawLavaPool(false, false, true)
		SINGLE_CHAR_SCRIPT.DrawStraightFlow(false, false, true)
	--Straight line across the bottom
	elseif SV.SearingTunnel.LavaFlowDirection == 'BottomStraight' then
		SINGLE_CHAR_SCRIPT.DrawLavaPool(true, true, true)
		SINGLE_CHAR_SCRIPT.DrawStraightFlow(true, true, true)
	--Diagonal Down
	elseif SV.SearingTunnel.LavaFlowDirection == 'DiagonalDown' then
		SINGLE_CHAR_SCRIPT.DrawLavaPool(false, true, true)
		SINGLE_CHAR_SCRIPT.DrawDiagonalFlow(false, true, true)
	--diagonal up
	elseif SV.SearingTunnel.LavaFlowDirection == 'DiagonalUp' then
		SINGLE_CHAR_SCRIPT.DrawLavaPool(true, false, true)
		SINGLE_CHAR_SCRIPT.DrawDiagonalFlow(true, false, true)
	end
	
	--clear the flag
	SV.SearingTunnel.LavaFlowDirection = "None"
end 

function SINGLE_CHAR_SCRIPT.LavaFlowHandler(owner, ownerChar, context, args)
	--args.LavaDuration - how long the lava is out before it recedes. Should be 1 pretty much always. Dont let it be less than 1!!!!
	--args.NothingDuration - How long is there nothing until the lava returns?
	if context.User == nil then
		--failsafes
		if SV.SearingTunnel.LavaCountdown == nil then SV.SearingTunnel.LavaCountdown = -1 end
		
		--reset the counter when we go past 0. -1 or else it would end up taking 1 more turn than intended
		if SV.SearingTunnel.LavaCountdown < 0 then
			SV.SearingTunnel.LavaCountdown = args.LavaDuration + args.NothingDuration - 1
		end
		
		--When there's only Nothing Duration left, remove lava.
		if SV.SearingTunnel.LavaCountdown == args.NothingDuration then
			GAME:WaitFrames(20)--Pause a bit so it doesn't insta clear as soon as the map turn is done.
			SINGLE_CHAR_SCRIPT.RemoveLavaFlow()
		end
		
		if SV.SearingTunnel.LavaCountdown == 0 then
			GAME:WaitFrames(20)--Pause a bit so it doesn't insta clear as soon as the map turn is done.
			SINGLE_CHAR_SCRIPT.QueueLavaFlow()
		end 
		
		SV.SearingTunnel.LavaCountdown = SV.SearingTunnel.LavaCountdown - 1
		print("Lava counter " .. tostring(SV.SearingTunnel.LavaCountdown))
	end
end



--For use in the Terrakion Fight and his dungeon after the midway point.
function SINGLE_CHAR_SCRIPT.QueueRockFall(owner, ownerChar, context, args)
	
	--random chance for floor tiles to become a "falling rock shadow" tile.
	local map = _ZONE.CurrentMap

	SOUND:PlayBattleSE("EVT_Tower_Quake")
	--minshake, maxshake, shaketime
	DUNGEON:MoveScreen(RogueEssence.Content.ScreenMover(3, 6, 40))
	_DUNGEON:LogMsg(STRINGS:Format("A great power shakes the cavern!"))

	--flavor rocks; rocks should fall all over, not just on you.
	for xx = 0, map.Width - 1, 1 do
		for yy = 0, map.Height - 1, 1 do
			--1/8 chance to set a tile to rock fall.  is
			if map.Rand:Next(1,9) == 1 then 
				local loc = RogueElements.Loc(xx, yy)
				local tile = map:GetTile(loc)
				--Make sure the tile is a floor tile and has nothing on it already (traps)
				if tile.ID == _DATA.GenFloor and tile.Effect.ID == '' then
					tile.Effect = RogueEssence.Dungeon.EffectTile('falling_rock_shadow', true, loc)
				end
			end
		end
	end
			
	--for every pokemon on the floor, queue up extra rocks around them. Always make sure a spot is clear within one tile of them though!
	--todo: Improve code efficiency. Multiple for loops for each party instead of transferring to a lua table if this proves to be too slow.
	local floor_mons = {}

	--your team 
	for i = 0, GAME:GetPlayerPartyCount() - 1, 1 do
		table.insert(floor_mons, GAME:GetPlayerPartyMember(i))
		print("PlayerParty" .. i)
	end
		
	for i = 0, GAME:GetPlayerGuestCount() - 1, 1 do
		table.insert(floor_mons, GAME:GetPlayerGuestMember(i))
		print("GuestParty" .. i)
	end
	
	--enemy teams
	for i = 0, map.MapTeams.Count - 1, 1 do
		local team = map.MapTeams[i].Players
		for j = 0, team.Count - 1, 1 do
			table.insert(floor_mons, team[j])	
			print("EnemyTeam" .. i)
		end
	end
	
	--neutrals
	for i = 0, map.AllyTeams.Count - 1, 1 do
		local team = map.AllyTeams[i].Players
		for j = 0, team.Count - 1, 1 do
			table.insert(floor_mons, team[j])
			print("Neutral" .. i)
		end
	end
	
	print("length = " .. tostring(#floor_mons))

	for i = 1, #floor_mons, 1 do
		local member = floor_mons[i] --RogueEssence.Dungeon.Character
		local charLoc = member.CharLoc
		
		--Spawn extra boulders near Pokemon in a 3x3 radius.
		--Don't spawn boulders on top of terrakion; they'll be too good at killing him if this happens.
		if member.CurrentForm.Species ~= 'terrakion' then
			for xx = -1, 1, 1 do
				for yy = -1, 1, 1 do 
					--pass a check with 66% success rate. If you do, spawn a boulder shadow.
					--Bound these values to stay in bounds. This has a byproduct of condensing boulders a bit when at map edges, but this shouldn't come into practice much.
					if map.Rand:Next(1, 4) ~= 1 then 
						local boulderX = charLoc.X + xx
						local boulderY = charLoc.Y + yy
					
						if boulderX < 0 then boulderX = 0 end 
						if boulderY < 0 then boulderY = 0 end							
						
						if boulderX >= map.Width then boulderX = map.Width - 1 end 
						if boulderY >= map.Height then boulderY = map.Height - 1 end
						
						local loc = RogueElements.Loc(charLoc.X + xx, charLoc.Y + yy)
						local tile = map:GetTile(loc)
						if tile.ID == _DATA.GenFloor and tile.Effect.ID == '' then
							tile.Effect = RogueEssence.Dungeon.EffectTile('falling_rock_shadow', true, loc)
						end
					end
				end			
			end
		end
	end		

	
	--loop through the pokemon on the floor again; this time clean 1 boulder next to each pokemon.
	--this is to help prevent RNG screwing you over into a checkmate scenario
	for i = 1, #floor_mons, 1 do
		local member = floor_mons[i] --RogueEssence.Dungeon.Character
		local charLoc = member.CharLoc
		
		--Clear 1 space nearby each pokemon.
		local nearby_boulder_locs = {}
		
		--again, Terrakion is an exception. Dont remove boulders near him since we aren't spawning them near him.
		--todo: make this less hacky? Maybe just remove him from the overall list instead of exceptioning him twice? but would such a search be too slow?
		if member.CurrentForm.Species ~= 'terrakion' then 
			for xx = -1, 1, 1 do
				for yy = -1, 1, 1 do 
					local boulderX = charLoc.X + xx
					local boulderY = charLoc.Y + yy
				
					if boulderX < 0 then boulderX = 0 end 
					if boulderY < 0 then boulderY = 0 end							
					
					if boulderX >= map.Width then boulderX = map.Width - 1 end 
					if boulderY >= map.Height then boulderY = map.Height - 1 end
					
					local loc = RogueElements.Loc(charLoc.X + xx, charLoc.Y + yy)
					local tile = map:GetTile(loc)
					if tile.Effect.ID == 'falling_rock_shadow' then
						table.insert(nearby_boulder_locs, loc)
					end
				end			
			end
		
			--Finally clear the tile.
			if #nearby_boulder_locs > 0 then
				local loc = nearby_boulder_locs[map.Rand:Next(1, #nearby_boulder_locs + 1)]
				local tile = map:GetTile(loc)
				tile.Effect = RogueEssence.Dungeon.EffectTile('', true, loc)
			end
		end
	end
			

	
	GAME:WaitFrames(30)
end 

function SINGLE_CHAR_SCRIPT.ResolveRockFall(owner, ownerChar, context, args)
	--Resolve the queued up rock falls. Play the animation in 4 waves so the animations aren't 100% synced up; what wave you're in is your x pos + y pos modulo 4 + 1.
	
	local waves = {{}, {}, {}, {}}
	local map = _ZONE.CurrentMap
	local width = map.Width 
	local height = map.Height

	SOUND:PlayBattleSE("DUN_Rock_Throw")
	
	--drops a boulder on a location
	local function DropBoulder(loc)
	
		--emitter for the result anim of our main emitter
		local result_emitter = RogueEssence.Content.SingleEmitter(RogueEssence.Content.AnimData("Rock_Smash_Front", 2))
		result_emitter.Layer = RogueEssence.Content.DrawLayer.Front
						
		--falling boulder animation. Emitter attributes are mostly self explanatory.
		local emitter = RogueEssence.Content.MoveToEmitter()
		emitter.MoveTime = 30
		emitter.Anim = RogueEssence.Content.AnimData("Rock_Piece_Rotating", 2)
		emitter.ResultAnim = result_emitter--this result anim can be any other emitter i believe, not just an emptyfiniteemitter.
		emitter.ResultLayer = RogueEssence.Content.DrawLayer.Front
		emitter.HeightStart = 240
		emitter.HeightEnd = 0
		--emitter.OffsetStart = 0 --these are saved as Locations i believe, not as ints
		--emitter.OffsetEnd = 0
		emitter.LingerStart = 0--linger is having the anim stay still before or after it moves
		emitter.LingerEnd = 0
		DUNGEON:PlayVFX(emitter, loc.X * 24 + 12, loc.Y * 24 + 16)

		GAME:WaitFrames(30)
		
		--clear the shadow
		map:GetTile(loc).Effect = RogueEssence.Dungeon.EffectTile('', true, loc)
		
		local flinch = RogueEssence.Dungeon.StatusEffect("flinch")
		--initialize status data before adding it to anything
		flinch:LoadFromData()
		local chara =  map:GetCharAtLoc(loc)
		
		--damage anyone standing under a rock when it resolves.
		if chara ~= nil then
			--deal 1/4 max hp as damage, multiplied based on type effectiveness. Also flinch the target.
			local damage = chara.MaxHP / 4
			
			--get the type effectiveness on each of the chara's types, then add that together. then run it through GetEffectivenessMult to get the actual multiplier. This is the numerator for x/4. so divide by 4 after for true amount
			local type_effectiveness = PMDC.Dungeon.PreTypeEvent.CalculateTypeMatchup('rock', chara.Element1) + PMDC.Dungeon.PreTypeEvent.CalculateTypeMatchup('rock', chara.Element2)
			type_effectiveness = PMDC.Dungeon.PreTypeEvent.GetEffectivenessMult(type_effectiveness)


			damage = math.floor(type_effectiveness * damage) / 4

			TASK:WaitTask(chara:InflictDamage(damage))
			TASK:WaitTask(chara:AddStatusEffect(nil, flinch, true))
		end		
		
	end
		
		--local arriveAnim = RogueEssence.Content.StaticAnim(RogueEssence.Content.AnimData("Rock_Pieces", 1), 1)
		--arriveAnim:SetupEmitted(RogueElements.Loc(waves[i][j].X * 24 + 12, waves[i][j].Y * 24 + 12), 32, RogueElements.Dir8.Down)
		--DUNGEON:PlayVFXAnim(arriveAnim, RogueEssence.Content.DrawLayer.Front)


	for xx = 0, map.Width - 1, 1 do
		for yy = 0, map.Height - 1, 1 do
			local loc = RogueElements.Loc(xx, yy)
			local tile = map:GetTile(loc)
			--queue up the shadow in that position for that wave.
			if tile.Effect.ID == 'falling_rock_shadow' then
				table.insert(waves[((xx + yy) % #waves) + 1], loc)
			end
		end
	end

	local boulder_coroutines = {}
	for i = 1, #waves, 1 do 
		for j = 1, #waves[i], 1 do
			table.insert(boulder_coroutines, TASK:BranchCoroutine(function() GAME:WaitFrames((i-1) * 10) DropBoulder(waves[i][j]) end))
		end 
	end 	
	
	TASK:JoinCoroutines(boulder_coroutines)
	
	--pause a bit after dropping all boulders
	GAME:WaitFrames(20)
		
end



function SINGLE_CHAR_SCRIPT.RockfallTemors(owner, ownerChar, context, args)
	--args.ShadowDuration - how long the shadows are out before they fall. Should be 1 pretty much always. Dont let it be less than 1!!!!
	--args.TurnsBetweenTremors - how many turns after one tremor should another trigger? Much less during the bossfight.
	if context.User == nil then
		--failsafes
		if SV.ClovenRuins.BoulderCountdown == nil then SV.ClovenRuins.BoulderCountdown = -1 end
		
		--reset the counter when we go past 0. -1 or else it would end up taking 1 more turn than intended
		if SV.ClovenRuins.BoulderCountdown < 0 then
			SV.ClovenRuins.BoulderCountdown = args.TurnsBetweenTremors - 1
		end
		
		--when there's only ShadowDuration turns left, trigger the shadow spawns.
		if SV.ClovenRuins.BoulderCountdown == args.ShadowDuration then
			SINGLE_CHAR_SCRIPT.QueueRockFall(owner, ownerChar, context, args)
		end
		
		if SV.ClovenRuins.BoulderCountdown == 0 then
			SINGLE_CHAR_SCRIPT.ResolveRockFall(owner, ownerChar, context, args)
		end 
		
		SV.ClovenRuins.BoulderCountdown = SV.ClovenRuins.BoulderCountdown - 1
	end

end

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
				dest_state.PreserveMusic = false
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



--Reimplementing Audino's C# event for BeginBattleEvent. 
--This will allow us to inject custom function code before ending a battle (such as clearing existing lava flows when a boss fight ends).
MapCheckState = luanet.import_type('RogueEssence.Dungeon.MapCheckState')
SingleCharScriptEvent = luanet.import_type('RogueEssence.Dungeon.SingleCharScriptEvent')

function SINGLE_CHAR_SCRIPT.LuaBeginBattleEvent(owner, ownerChar, context, args)
	
	local map_clear_idx = 'map_clear_check'


	if context.User ~= nil then return end
	--if a custom clear event is not given, use the default one.
	if args.CustomClearEvent == nil then args.CustomClearEvent = 'LuaCheckBossClearEvent' end
	
	--Turn on Team Mode if allowed when the boss fight starts.
	if _DUNGEON:CanUseTeamMode() then
		_DUNGEON:SetTeamMode(true)
	end
	
	local clear_status = RogueEssence.Dungeon.MapStatus(map_clear_idx)
	clear_status:LoadFromData()
	
	local check = clear_status.StatusStates:GetWithDefault(luanet.ctype(MapCheckState))
	--The 2nd argument in the function below needs a string that represents a lua table of the arguments to pass. Serpent.line will convert the lua table to a string representing it for us.
	--We only NEED to pass args, as owner, ownerchar, and context are automatically passed in when the check event is called
	check.CheckEvents:Add(SingleCharScriptEvent(args.CustomClearEvent, Serpent.line(args)))
	--check.CheckEvents:Add(LuaCheckBossClearEvent(owner, ownerChar, context, args))
	
	TASK:WaitTask(_DUNGEON:AddMapStatus(clear_status))
end

--Reimplementation of the basic CheckBossClearEvent. 
--Call something different from LuaBeginBattleEvent or edit this accordingly if you want a different wincon for your map or special effects/anims on win.
function SINGLE_CHAR_SCRIPT.LuaCheckBossClearEvent(owner, ownerChar, context, args)
	
	--Sequence that runs when map is over. Fade out, cut the music, etc.
	function end_sequence()
		
		--HALCYON ONLY CHANGE, the only change I've made to this from the original reimplementation:
		--A small wait before calling the end sequence proper so we can see more of the "won" battlefield
		GAME:WaitFrames(40)
		
		_GAME:BGM("", true)
		 
		TASK:WaitTask(_GAME:FadeOut(false))
		 
		_DUNGEON:ResetTurns()
		
		--restore all and remove all map status
		local statuses_to_remove = {}
		for i = 0, _ZONE.CurrentMap.Status.Keys.Count - 1, 1 do
			statuses_to_remove[i] = _ZONE.CurrentMap.Status.Keys[i]
		end
		
		for i = 0, #statuses_to_remove - 1, 1 do
			TASK:WaitTask(_DUNGEON:RemoveMapStatus(statuses_to_remove[i], false))
		end 
		
		--heal everyone in the party
		for i = 0, GAME:GetPlayerPartyCount() - 1, 1 do
			_DATA.Save.ActiveTeam.Players[i]:FullRestore()
		end
		
		TASK:WaitTask(_GAME:EndSegment(RogueEssence.Data.GameProgress.ResultType.Cleared))

	end

	--For each enemy team, check each chara in that team. If any are still alive, then fail this check and return early.
	for i = 0, _ZONE.CurrentMap.MapTeams.Count - 1, 1 do 
		local team = _ZONE.CurrentMap.MapTeams[i].Players
		for j = 0, team.Count - 1, 1 do
			--Break and return early if even one enemy is not dead.
			if not team[j].Dead then return end
		end
	end
	
	--Everyone's dead, clear the scene.
	local checks = owner.StatusStates:GetWithDefault(luanet.ctype(MapCheckState))
	
	--The call originally for this was to remove(this), which isn't in lua. So we need to find the LuaCheckBossClearEvent and remove that (remove ourself)
	for i = 0, checks.CheckEvents.Count - 1, 1 do
		if LUA_ENGINE:TypeOf(checks.CheckEvents[i]) == luanet.ctype(SingleCharScriptEvent) then
			if checks.CheckEvents[i].Script == args.CustomClearEvent then
				checks.CheckEvents:Remove(checks.CheckEvents[i])
			end
		end
	end
	
	if _DATA.CurrentReplay == nil then
		TASK:WaitTask(end_sequence())
	else 
		TASK:WaitTask(_GAME:EndSegment(RogueEssence.Data.GameProgress.ResultType.Cleared))
	end
	
end



--For Searing Tunnel's boss: Remove any existing lava, if it exists, before fading out.
function SINGLE_CHAR_SCRIPT.LavaBossClear(owner, ownerChar, context, args)
	
	--Sequence that runs when map is over. Fade out, cut the music, etc.
	function end_sequence()
		
		GAME:WaitFrames(40)
	
		if SV.SearingTunnel.LavaFlowDirection ~= "None" then
			SINGLE_CHAR_SCRIPT.RemoveLavaFlow()
			GAME:WaitFrames(20)
		end		
		
		_GAME:BGM("", true)
		 
		TASK:WaitTask(_GAME:FadeOut(false))
		 
		_DUNGEON:ResetTurns()
		
		--restore all and remove all map status
		local statuses_to_remove = {}
		for i = 0, _ZONE.CurrentMap.Status.Keys.Count - 1, 1 do
			statuses_to_remove[i] = _ZONE.CurrentMap.Status.Keys[i]
		end
		
		for i = 0, #statuses_to_remove - 1, 1 do
			TASK:WaitTask(_DUNGEON:RemoveMapStatus(statuses_to_remove[i], false))
		end 
		
		--heal everyone in the party
		for i = 0, GAME:GetPlayerPartyCount() - 1, 1 do
			_DATA.Save.ActiveTeam.Players[i]:FullRestore()
		end
		
		TASK:WaitTask(_GAME:EndSegment(RogueEssence.Data.GameProgress.ResultType.Cleared))

	end

	--For each enemy team, check each chara in that team. If any are still alive, then fail this check and return early.
	for i = 0, _ZONE.CurrentMap.MapTeams.Count - 1, 1 do 
		local team = _ZONE.CurrentMap.MapTeams[i].Players
		for j = 0, team.Count - 1, 1 do
			--Break and return early if even one enemy is not dead.
			if not team[j].Dead then return end
		end
	end
	
	--Everyone's dead, clear the scene.
	local checks = owner.StatusStates:GetWithDefault(luanet.ctype(MapCheckState))
	
	--The call originally for this was to remove(this), which isn't in lua. So we need to find the LuaCheckBossClearEvent and remove that (remove ourself)
	for i = 0, checks.CheckEvents.Count - 1, 1 do
		if LUA_ENGINE:TypeOf(checks.CheckEvents[i]) == luanet.ctype(SingleCharScriptEvent) then
			if checks.CheckEvents[i].Script == args.CustomClearEvent then
				checks.CheckEvents:Remove(checks.CheckEvents[i])
			end
		end
	end
	
	if _DATA.CurrentReplay == nil then
		TASK:WaitTask(end_sequence())
	else 
		TASK:WaitTask(_GAME:EndSegment(RogueEssence.Data.GameProgress.ResultType.Cleared))
	end
	
end