require 'origin.common'

require "halcyon.CharacterEssentials"

RedirectionType = luanet.import_type('PMDC.Dungeon.Redirected')
DmgMultType = luanet.import_type('PMDC.Dungeon.DmgMult')


function BATTLE_SCRIPT.ShopkeeperInteract(owner, ownerChar, context, args)

  if COMMON.CanTalk(context.Target) then
	local security_state = COMMON.GetShopPriceState()
    local price = security_state.Cart
    local sell_price = COMMON.GetDungeonSellPrice()
  
    local oldDir = context.Target.CharDir
    DUNGEON:CharTurnToChar(context.Target, context.User)
	
    if sell_price > 0 then
      context.TurnCancel.Cancel = true
      UI:SetSpeaker(context.Target)
	  UI:ChoiceMenuYesNo(STRINGS:Format(RogueEssence.StringKey(string.format("TALK_SHOP_SELL_%04d", context.Target.Discriminator)):ToLocal(), STRINGS:FormatKey("MONEY_AMOUNT", sell_price)), false)
	  UI:WaitForChoice()
	  result = UI:ChoiceResult()
	  
	  if SV.adventure.Thief then
	    COMMON.ThiefReturn()
	  elseif result then
	    -- iterate player inventory prices and remove total price
        COMMON.PayDungeonSellPrice(sell_price)
	    SOUND:PlayBattleSE("DUN_Money")
	    UI:WaitShowDialogue(RogueEssence.StringKey(string.format("TALK_SHOP_SELL_DONE_%04d", context.Target.Discriminator)):ToLocal())
	  else
	    -- nothing
	  end
    end
	
    if price > 0 then
      context.TurnCancel.Cancel = true
      UI:SetSpeaker(context.Target)
	  UI:ChoiceMenuYesNo(STRINGS:Format(RogueEssence.StringKey(string.format("TALK_SHOP_PAY_%04d", context.Target.Discriminator)):ToLocal(), STRINGS:FormatKey("MONEY_AMOUNT", price)), false)
	  UI:WaitForChoice()
	  result = UI:ChoiceResult()
	  if SV.adventure.Thief then
	    COMMON.ThiefReturn()
	  elseif result then
	    if price > GAME:GetPlayerMoney() then
          UI:WaitShowDialogue(RogueEssence.StringKey(string.format("TALK_SHOP_PAY_SHORT_%04d", context.Target.Discriminator)):ToLocal())
	    else
	      -- iterate player inventory prices and remove total price
          COMMON.PayDungeonCartPrice(price)
	      SOUND:PlayBattleSE("DUN_Money")
	      UI:WaitShowDialogue(RogueEssence.StringKey(string.format("TALK_SHOP_PAY_DONE_%04d", context.Target.Discriminator)):ToLocal())
	    end
	  else
	    UI:WaitShowDialogue(RogueEssence.StringKey(string.format("TALK_SHOP_PAY_REFUSE_%04d", context.Target.Discriminator)):ToLocal())
	  end
    end
	
	if price == 0 and sell_price == 0 then
      context.CancelState.Cancel = true
      UI:SetSpeaker(context.Target)
	  --Halcyon tweak: If you talk to kec or enter his shop after stealing, he'll aggro you
	  if SV.adventure.Thief then
		COMMON.ThiefReturn()
	  else
		UI:WaitShowDialogue(RogueEssence.StringKey(string.format("TALK_SHOP_%04d", context.Target.Discriminator)):ToLocal())
		context.Target.CharDir = oldDir
	  end
	end
  else

    UI:ResetSpeaker()
	
	local chosen_quote = RogueEssence.StringKey("TALK_CANT"):ToLocal()
    chosen_quote = string.gsub(chosen_quote, "%[myname%]", context.Target:GetDisplayName(true))
    UI:WaitShowDialogue(chosen_quote)
  end
end

function BATTLE_SCRIPT.EscortInteract(owner, ownerChar, context, args)
  context.CancelState.Cancel = true
  local oldDir = context.Target.CharDir
  DUNGEON:CharTurnToChar(context.Target, context.User)
  UI:SetSpeaker(context.Target)
  
  --Basic for now, but choose a different line based on mission type/special 
  --Should be expanded on in the future to be more dynamic, and to have more special lines for special pairs
  local tbl = LTBL(context.Target)
  local mission_slot = tbl.Escort
  local job = SV.TakenBoard[mission_slot]
  
  if job.Type == COMMON.MISSION_TYPE_EXPLORATION then
		local floor = MISSION_GEN.STAIR_TYPE[job.Zone] .. '[color=#00FFFF]' .. tostring(job.Floor) .. '[color]' .. "F"
		UI:WaitShowDialogue("Please, take me to " .. floor .. "!")
  elseif job.Type == COMMON.MISSION_TYPE_ESCORT then
    if job.Special == MISSION_GEN.SPECIAL_CLIENT_LOVER then
	  UI:WaitShowDialogue("Please, bring me to my love! I'm counting on you!")
	else
	  UI:WaitShowDialogue("I'm counting on you to bring me to " .. _DATA:GetMonster(job.Target):GetColoredName() .. "!") 
	end
   end
  context.Target.CharDir = oldDir
end

function BATTLE_SCRIPT.RescueReached(owner, ownerChar, context, args)
	-- Set the nickname of the target, removing the gender sign
	local base_name = RogueEssence.Data.DataManager.Instance.DataIndices[RogueEssence.Data.DataManager.DataType.Monster]:Get(context.Target.BaseForm.Species).Name:ToLocal()
	GAME:SetCharacterNickname(context.Target, base_name)

	context.CancelState.Cancel = false
	context.TurnCancel.Cancel = true

	local targetName = _DATA:GetMonster(context.Target.BaseForm.Species):GetColoredName()

  local oldDir = context.Target.CharDir

	local tbl = LTBL(context.Target)
	local mission = SV.TakenBoard[tbl.Mission]
  DUNGEON:CharTurnToChar(context.Target, context.User)
	UI:ResetSpeaker()

	if mission.Type == COMMON.MISSION_TYPE_RESCUE then
		RescueCheck(context, targetName, mission)
	elseif mission.Type == COMMON.MISSION_TYPE_DELIVERY then
		DeliveryCheck(context, targetName, mission)
	end
end

function RescueCheck(context, targetName, mission)
	UI:ChoiceMenuYesNo("Yes! You've found " .. targetName .. "!\nDo you want to use your badge to rescue " .. targetName .. "?", false)
	UI:WaitForChoice()
	local use_badge = UI:ChoiceResult()
	if use_badge then 
		--Mark mission completion flags
		SV.TemporaryFlags.MissionCompleted = true
		--Clear but remember minimap state
		SV.TemporaryFlags.PriorMapSetting = _DUNGEON.ShowMap
		_DUNGEON.ShowMap = _DUNGEON.MinimapState.None
		GAME:WaitFrames(20)
		mission.Completion = 1
		UI:WaitShowDialogue("Your badge shines on " .. targetName .. ", and ".. targetName .. " is transported away magically!" )
		GAME:WaitFrames(20)
		UI:SetSpeaker(context.Target)
		
		--different responses for special targets
		if mission.Special == MISSION_GEN.SPECIAL_CLIENT_CHILD then 
			UI:SetSpeakerEmotion("Joyous")
			UI:WaitShowDialogue("Thank you for rescuing me! This place was so scary! I can't wait to see my family again!")
		elseif mission.Special == MISSION_GEN.SPECIAL_CLIENT_FRIEND then
			UI:WaitShowDialogue("Oh, my friend sent you to rescue me? Thank goodness! We'll see you at the guild later to say thanks!")
		elseif mission.Special == MISSION_GEN.SPECIAL_CLIENT_RIVAL then 
			UI:WaitShowDialogue("Tch, my rival sent you to rescue me, huh? Well, thank you. We'll reward you later at the guild.")		
		elseif mission.Special == MISSION_GEN.SPECIAL_CLIENT_LOVER then 
			UI:SetSpeakerEmotion("Joyous")
			UI:WaitShowDialogue("Oh, my beloved " .. _DATA:GetMonster(mission.Client):GetColoredName() .. " sent you to rescue me? I can't wait to reunite with them!")
		else
			UI:WaitShowDialogue("Thanks for the rescue!\nI'll see you at the guild after with your reward!")
			end
		GAME:WaitFrames(20)
		UI:ResetSpeaker()
		UI:WaitShowDialogue(targetName .. " escaped from the dungeon!")
		GAME:WaitFrames(20)
		-- warp out
		TASK:WaitTask(_DUNGEON:ProcessBattleFX(context.Target, context.Target, _DATA.SendHomeFX))
		_DUNGEON:RemoveChar(context.Target)
		GAME:WaitFrames(50)
		GeneralFunctions.AskMissionWarpOut()
	else 
		--quickly hide the minimap for the 20 frame pause
		local map_setting = _DUNGEON.ShowMap
		_DUNGEON.ShowMap = _DUNGEON.MinimapState.None
		GAME:WaitFrames(20)
		UI:SetSpeaker(context.Target)
		if mission.Special == MISSION_GEN.SPECIAL_CLIENT_CHILD then 
			UI:SetSpeakerEmotion("Crying")
			UI:WaitShowDialogue("Waaah! It's s-scary here! P-please help me!")
		elseif mission.Special == MISSION_GEN.SPECIAL_CLIENT_FRIEND then
			UI:SetSpeakerEmotion("Surprised")
			UI:WaitShowDialogue("Please don't leave me here! My friend is probably worried sick!")
		elseif mission.Special == MISSION_GEN.SPECIAL_CLIENT_RIVAL then 
			UI:SetSpeakerEmotion("Worried")
			UI:WaitShowDialogue("Woah, don't just leave me hanging here!")	
		elseif mission.Special == MISSION_GEN.SPECIAL_CLIENT_LOVER then 
			UI:SetSpeakerEmotion("Worried")
			UI:WaitShowDialogue("Please, get me out of here! I just want to see my dear " .. _DATA:GetMonster(mission.Client):GetColoredName() .. " again!")
		else
			UI:SetSpeakerEmotion("Surprised")
			UI:WaitShowDialogue("H-hey! Don't just leave me here!")
		end
		--change map setting back to what it was
		_DUNGEON.ShowMap = map_setting
		GAME:WaitFrames(20)
	end
end

function DeliveryCheck(context, targetName, mission)
	local inv_slot = GAME:FindPlayerItem(mission.Item, false, true)
	local team_slot = GAME:FindPlayerItem(mission.Item, true, false)
	local has_item = inv_slot:IsValid() or team_slot:IsValid()
	local item_name =  RogueEssence.Dungeon.InvItem(mission.Item):GetDisplayName()

	if has_item then
		UI:ChoiceMenuYesNo("Yes! You've located " .. targetName .. "!" .. " Do you want to deliver the requested " .. item_name .. " to " .. targetName .. "?")
		UI:WaitForChoice()
		local deliver_item = UI:ChoiceResult()
		if deliver_item then
			SV.TemporaryFlags.MissionCompleted = true
			mission.Completion = 1
			--Clear but remember minimap state
			SV.TemporaryFlags.PriorMapSetting = _DUNGEON.ShowMap
			_DUNGEON.ShowMap = _DUNGEON.MinimapState.None
			-- Take from inventory first before held items 
			if inv_slot:IsValid() then 
				GAME:TakePlayerBagItem(inv_slot.Slot, true)
			else 
				GAME:TakePlayerEquippedItem(team_slot.Slot, true)
			end
			GAME:WaitFrames(20)
			UI:SetSpeaker(context.Target)
			UI:WaitShowDialogue("Thanks for the " .. item_name .. "!\n I'll see you at the guild after with your reward!")
			GAME:WaitFrames(20)
			UI:ResetSpeaker()
			UI:WaitShowDialogue(targetName .. " escaped from the dungeon!")
			GAME:WaitFrames(20)
			TASK:WaitTask(_DUNGEON:ProcessBattleFX(context.Target, context.Target, _DATA.SendHomeFX))
			_DUNGEON:RemoveChar(context.Target)
			GAME:WaitFrames(50)
			GeneralFunctions.AskMissionWarpOut()
		else --they are sad if you dont give them the item
			--quickly hide the minimap for the 20 frame pause
			local map_setting = _DUNGEON.ShowMap
			_DUNGEON.ShowMap = _DUNGEON.MinimapState.None
			GAME:WaitFrames(20)
			UI:SetSpeaker(context.Target)
			UI:SetSpeakerEmotion("Sad")
			UI:WaitShowDialogue("Oh, please! I really need that " .. item_name .. "...")
			--change map setting back to what it was
			_DUNGEON.ShowMap = map_setting
			GAME:WaitFrames(20)		end
	else
		UI:WaitShowDialogue("The requested " .. item_name .. " isn't in the Treasure Bag.\nThere is nothing to deliver.")
		--quickly hide the minimap for the 20 frame pause
		local map_setting = _DUNGEON.ShowMap
		_DUNGEON.ShowMap = _DUNGEON.MinimapState.None
		GAME:WaitFrames(20)
		UI:SetSpeaker(context.Target)
		UI:SetSpeakerEmotion("Sad")
		UI:WaitShowDialogue("Huh, you don't have the " .. item_name .. "? That's too bad...")
		--change map setting back to what it was
		_DUNGEON.ShowMap = map_setting
		GAME:WaitFrames(20)
	end
end

function BATTLE_SCRIPT.EscortRescueReached(owner, ownerChar, context, args)
	context.CancelState.Cancel = false
	context.TurnCancel.Cancel = true
  --Mark this as the last dungeon entered.
  local tbl = LTBL(context.Target)
	if tbl ~= nil and tbl.Mission ~= nil then
		local mission = SV.TakenBoard[tbl.Mission]
		local escort = COMMON.FindMissionEscort(tbl.Mission)
		local escortName = _DATA:GetMonster(mission.Client):GetColoredName()
		if escort then
			local oldDir = context.Target.CharDir
			DUNGEON:CharTurnToChar(context.Target, context.User)
			UI:ResetSpeaker()
			if math.abs(escort.CharLoc.X - context.Target.CharLoc.X) <= 4 and math.abs(escort.CharLoc.Y - context.Target.CharLoc.Y) <= 4 then
				--Mark mission completion flags
				SV.TemporaryFlags.MissionCompleted = true
				mission.Completion = 1
				UI:WaitShowDialogue("Yes! You completed " .. escortName .. "'s escort mission.\n" .. escortName .. " is delighted!")
				--Clear but remember minimap state
				SV.TemporaryFlags.PriorMapSetting = _DUNGEON.ShowMap
				_DUNGEON.ShowMap = _DUNGEON.MinimapState.None
				GAME:WaitFrames(20)
				
				UI:SetSpeaker(escort)
				UI:WaitShowDialogue("Thank you for escorting me to " .. _DATA:GetMonster(context.Target.CurrentForm.Species):GetColoredName() .. "!")
				GAME:WaitFrames(20)
				UI:ResetSpeaker()
				UI:WaitShowDialogue(escortName .. "'s twosome left the dungeon!")
				GAME:WaitFrames(20)

				--Set max team size to 4 as the guest is no longer "taking" up a party slot
				RogueEssence.Dungeon.ExplorerTeam.MAX_TEAM_SLOTS = 4
				
				-- warp out
				TASK:WaitTask(_DUNGEON:ProcessBattleFX(escort, escort, _DATA.SendHomeFX))
				_DUNGEON:RemoveChar(escort)
				_ZONE.CurrentMap.DisplacedChars:Remove(escort)
				GAME:WaitFrames(70)
				TASK:WaitTask(_DUNGEON:ProcessBattleFX(context.Target, context.Target, _DATA.SendHomeFX))
				_DUNGEON:RemoveChar(context.Target)
				
				GAME:WaitFrames(50)
				GeneralFunctions.AskMissionWarpOut()
			else
				UI:WaitShowDialogue(escortName .. " doesn't seem to be around...")
			end
		end
  end
end




--Use this in Interact scripts to replace wildcards, then return a chosen string from the personality with wildcards replaced.
function ChooseQuote(chara, target, key, running_pool, mission)
	local valid_quote = false
	local chosen_quote = ""
	
	--For mission relevant quotes. This feels like kinda a bad implementation since it's a copy and paste
	--of something being done already in the PartnerInteract, but... Oh well? This is the simplest/cleanest way i could think of handling it in this subfunction.
	--TODO: Reevaluate down the road potentially a cleaner way? Probably not needed.
	local tbl = LTBL(target)
	local outlaw = nil
	local rescuee = nil
	local mission = nil
	local objective_item = nil
	local escort = tbl.EscortMissionNum
	if tbl.MissionNumber ~= nil then
		mission = SV.TakenBoard[tbl.MissionNumber]
		if tbl.MissionType == COMMON.MISSION_BOARD_MISSION then
			rescuee = COMMON.FindNpcWithTable(false, "Mission", tbl.MissionNumber)
		elseif tbl.MissionType == COMMON.MISSION_BOARD_OUTLAW then
			outlaw = COMMON.FindNpcWithTable(true, "Mission", tbl.MissionNumber)
		end
				
		if mission.Type == COMMON.MISSION_TYPE_LOST_ITEM then 
			objective_item = mission.Item
		end
	end
	
	
	
	
	
    while not valid_quote and #running_pool > 0 do
	  valid_quote = true
      local chosen_idx = math.random(1, #running_pool)
  	  local chosen_pool_idx = running_pool[chosen_idx]
	  
	  --for use with [(name)] replacing
	  local char_list = {}
	  local char_count = 0
	  
      chosen_quote = RogueEssence.StringKey(string.format(key, chosen_pool_idx)):ToLocal()

	  --[(stuff)] indicates that the item inside (in this case stuff) is a pokemon's identifer and should be fed to CharacterEssentials to get their name. THANKS NO NICKNAME ENTHUSIASTS I HATE YOU
	  --NOTE/TODO: This breaks for characters who have _ (or other special chars) in their character call name. If this situation pops up, either address it here or remove the underscore from all instances of that character call name.
	  for i in string.gmatch(chosen_quote, "%[%((%a+)%)%]") do
		char_count = char_count + 1
		char_list[char_count] = i
	  end
	  
	  for i = 1, #char_list, 1 do
		chosen_quote = string.gsub(chosen_quote, "%[%(" .. char_list[i] .. "%)%]", CharacterEssentials.GetCharacterName(char_list[i]))
	  end

      chosen_quote = string.gsub(chosen_quote, "%[player%]", chara:GetDisplayName(true))
      chosen_quote = string.gsub(chosen_quote, "%[myname%]", target:GetDisplayName(true))
	  
	  --These are tags that should show up at the very start of the string, though it doesn't matter where you place them.
	  --Check for a tag in the style of [{POKEMON_NAME}], given as the species.
	  --So if a tag exists in the string, check if our current character is tagged. If they are, they can view the line. If they aren't, they can't view the line.
	  --If no tag in this manner exists for the string, then any character can view the line.
	  local chara_tbl = LTBL(chara)
	  if string.find(chosen_quote, "%[%{(%a+)%}%]") then
		valid_quote = false  
		if string.find(chosen_quote, "%[%{" .. chara_tbl.Importance .. "%}%]") then
			valid_quote = true
		end
		--remove any of these types of tags once we're done checking them.
		chosen_quote = string.gsub(chosen_quote, "%[%{(%a+)%}%]", "")
	  end 
	  --Remove all instances of a single character enclosed in a bracket, as they're just used for the above tagging.
	  chosen_quote = string.gsub(chosen_quote, "%[%a%]", "")
		
	  
	  
	  --For naming specific characters in the given slot in the party. Useful when color tagging is relevant!
	  --Given slot1, it will put character in slot1's name instead.
	  if string.find(chosen_quote, "%[slot") then
		  for i = 1, GAME:GetPlayerPartyCount(), 1 do
			chosen_quote = string.gsub(chosen_quote, "%[slot" .. tostring(i) .. "%]", GAME:GetPlayerPartyMember(i-1):GetDisplayName(true))
		  end
	  end
	  
      if string.find(chosen_quote, "%[move%]") then
        local moves = {}
  	    for move_idx = 0, 3 do
  	      if target.BaseSkills[move_idx].SkillNum ~= "" then
  	        table.insert(moves, target.BaseSkills[move_idx].SkillNum)
  	      end
  	    end
  	    if #moves > 0 then
  	      local chosen_move = _DATA:GetSkill(moves[math.random(1, #moves)])
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
  	        local mon = _DATA:GetMonster(chosen_mob.BaseForm.Species)
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
 	
	      
      if string.find(chosen_quote, "%[mission_client%]") then
        if mission ~= nil then
          chosen_quote = string.gsub(chosen_quote, "%[mission_client%]", _DATA:GetMonster(mission.Client):GetColoredName())
		elseif escort ~= nil then 
		    chosen_quote = string.gsub(chosen_quote, "%[mission_client%]", _DATA:GetMonster(SV.TakenBoard[escort].Client):GetColoredName())
  	    else
  	      valid_quote = false
  	    end
      end
 
	   if string.find(chosen_quote, "%[mission_target%]") then
        if mission ~= nil then
          chosen_quote = string.gsub(chosen_quote, "%[mission_target%]", _DATA:GetMonster(mission.Target):GetColoredName())
  	   	elseif escort ~= nil then 
		  chosen_quote = string.gsub(chosen_quote, "%[mission_target%]", _DATA:GetMonster(SV.TakenBoard[escort].Target):GetColoredName())
        else
  	      valid_quote = false
  	    end
      end
	  
	  
	  if string.find(chosen_quote, "%[mission_item%]") then
        if mission ~= nil then
          chosen_quote = string.gsub(chosen_quote, "%[mission_item%]", RogueEssence.Dungeon.InvItem(mission.Item):GetDisplayName())
  	    else
  	      valid_quote = false
  	    end
      end
  
	
	
  	  if not valid_quote then
        PrintInfo("Rejected "..chosen_quote)
  	    table.remove(running_pool, chosen_idx)
  	    chosen_quote = ""
  	  end

    end
    PrintInfo("Selected "..chosen_quote .. " from pool of " .. tostring(#running_pool))	
	return chosen_quote
end 

--special Halcyon script for the partner
function BATTLE_SCRIPT.PartnerInteract(owner, ownerChar, context, args)
	local chara = context.User
	local target = context.Target
	local action_cancel = context.CancelState
	local turn_cancel = context.TurnCancel
	
	action_cancel.Cancel = true

  if COMMON.CanTalk(target) then
    
    UI:SetSpeaker(target)

    local ratio = target.HP * 100 // target.MaxHP
    
    local mon = _DATA:GetMonster(target.BaseForm.Species)
    local form = mon.Forms[target.BaseForm.Form]
    
	--Partner has a different personality for each pool of quotes, with pools having different quotes to have additional comments on specific plotstate.
	--If no special quotes are needed because you're not doing the current story dungeon or whatever, use the default partner personality of 51.
	
    local personality = 51
	
	local dungeon = GAME:GetCurrentDungeon().Name:ToLocal()
	local segment = _ZONE.CurrentMapID.Segment
    
	local tbl = LTBL(target)
	local outlaw = nil
	local rescuee = nil
	local mission = nil
	local objective_item = nil
	local escort = tbl.EscortMissionNum
	if tbl.MissionNumber ~= nil then
		mission = SV.TakenBoard[tbl.MissionNumber]
		if tbl.MissionType == COMMON.MISSION_BOARD_MISSION then
			rescuee = COMMON.FindNpcWithTable(false, "Mission", tbl.MissionNumber)
		elseif tbl.MissionType == COMMON.MISSION_BOARD_OUTLAW then
			outlaw = COMMON.FindNpcWithTable(true, "Mission", tbl.MissionNumber)
		end
				
		if mission.Type == COMMON.MISSION_TYPE_LOST_ITEM then 
			objective_item = mission.Item
		end
	end
	PrintInfo(tostring(rescuee))
	PrintInfo(tostring(outlaw))
	PrintInfo(tostring(tbl.MissionNumber))
	PrintInfo(tostring(tbl.EscortMissionNum))
	
	
	
	if rescuee ~= nil then--comment on rescue target
		if mission.Type == COMMON.MISSION_TYPE_RESCUE then
			personality = 52
		elseif mission.Type == COMMON.MISSION_TYPE_ESCORT then
			personality = 53
		elseif mission.Type == COMMON.MISSION_TYPE_DELIVERY then
			local inv_slot = GAME:FindPlayerItem(mission.Item, false, true)
			local team_slot = GAME:FindPlayerItem(mission.Item, true, false)
			local has_item = inv_slot:IsValid() or team_slot:IsValid()
			--partner comments change depending on whether you actually have the delivery item or not
			if has_item then
				personality = 54
			else
				UI:SetSpeakerEmotion("Worried")
				personality = 55
			end
		end
	elseif outlaw ~= nil then--comment on outlaw target
		personality = 59
		UI:SetSpeakerEmotion("Determined")--this is overriden to worried/pain if hp is low enough
	elseif objective_item ~= nil and mission.Completion == COMMON.MISSION_INCOMPLETE then --comment on needing to find the item
		personality = 56
	elseif escort ~= nil and SV.TakenBoard[escort].Completion == COMMON.MISSION_INCOMPLETE then 
		if SV.TakenBoard[escort].Type == COMMON.MISSION_TYPE_ESCORT then
			personality = 57
		else
			personality = 58
		end	
	else
		--Story personalities
		if SV.ChapterProgression.Chapter == 1 and dungeon == 'Relic Forest' then
			personality = 60
		elseif SV.ChapterProgression.Chapter == 2 and dungeon == 'Illuminant Riverbed' then
			personality = 61
		elseif SV.ChapterProgression.Chapter == 3 and dungeon == 'Crooked Cavern' then
			if not SV.Chapter3.EncounteredBoss and segment == 0 then --dungeon, havent fought boss yet
				personality = 62
			elseif SV.Chapter3.EncounteredBoss and not SV.Chapter3.DefeatedBoss and not SV.Chapter3.FinishedRootScene and segment == 0 then --dungeon, lost to boss already
				personality = 63
			elseif SV.Chapter3.EncounteredBoss and not SV.Chapter3.DefeatedBoss and not SV.Chapter3.FinishedRootScene and segment == 1 then
				personality = 64
				UI:SetSpeakerEmotion("Determined")--this is overriden to worried/pain if hp is low enough
			end
		elseif SV.ChapterProgression.Chapter == 4 and dungeon == 'Apricorn Grove' then
			if not SV.Chapter4.ReachedGlade then
				personality = 65
			elseif not SV.Chapter4.FinishedGrove then
				personality = 66
			end
		end
	end
	PrintInfo("Personality in use: " .. tostring(personality))
    
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
    
	--Choose a quote, replacing wildcards in the process.
    chosen_quote = ChooseQuote(chara, target, key, running_pool)
	
	local oldDir = target.CharDir
    DUNGEON:CharTurnToChar(target, chara)
  
  
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
	 
    UI:SetSpeaker(target)

	action_cancel.Cancel = true
  -- TODO: create a charstate for being unable to talk and have talk-interfering statuses cause it
  if target:GetStatusEffect("sleep") == nil and target:GetStatusEffect("freeze") == nil then
    
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
	
	context.CancelState.Cancel = false
	context.TurnCancel.Cancel = true

	local olddir = target.CharDir
	DUNGEON:CharTurnToChar(target, chara)
	UI:BeginChoiceMenu("Do you need something,[pause=10] my student?", {"Help", "Reset floor", "Nothing"}, 3, 3)
	UI:WaitForChoice()
	local result = UI:ChoiceResult()
	if result == 1 then 
		args.Speech = SV.Tutorial.Progression
		SV.Tutorial.Progression = -1 --temporarily clear progression flag so speech can happen. -1 to prevent pausing before script trigger
		BeginnerLessonSpeechHelper(owner, ownerChar, target, args)
	elseif result == 2 then
		UI:WaitShowDialogue("Wahtah![pause=0] Very well![pause=0] Allow me to reset this floor!")
		GAME:WaitFrames(20)
		UI:SetSpeakerEmotion("Determined")
		--charging animation
		DUNGEON:CharStartAnim(target, "Charge", true)
		UI:WaitShowDialogue(".........")
		GAME:WaitFrames(20)
		DUNGEON:CharEndAnim(target)
		UI:SetSpeakerEmotion("Shouting")
		--setup flashes
		local emitter = RogueEssence.Content.FlashEmitter()
		emitter.FadeInTime = 2
		emitter.HoldTime = 4
		emitter.FadeOutTime = 2
		emitter.StartColor = Color(0, 0, 0, 0)
		emitter.Layer = DrawLayer.Top
		emitter.Anim = RogueEssence.Content.BGAnimData("White", 0)
		--setup hop animation
		local action = RogueEssence.Dungeon.CharAnimAction()
		action.BaseFrameType = 43 --hop
		action.AnimLoc = target.CharLoc
		action.CharDir = target.CharDir
		TASK:WaitTask(target:StartAnim(action))
		
		DUNGEON:PlayVFX(emitter, target.MapLoc.X, target.MapLoc.Y)
	    SOUND:PlayBattleSE("EVT_Battle_Flash")
	    GAME:WaitFrames(15)
	    DUNGEON:PlayVFX(emitter, target.MapLoc.X, target.MapLoc.Y)
	    SOUND:PlayBattleSE("EVT_Battle_Flash")
		UI:WaitShowTimedDialogue("HWACHA!", 40)		
		--Reset floor
		local resetEvent = PMDC.Dungeon.ResetFloorEvent()
		local charaContext = RogueEssence.Dungeon.SingleCharContext(chara)
		TASK:WaitTask(resetEvent:Apply(owner, ownerChar, charaContext))
	else 
		UI:WaitShowDialogue("Hoiyah![pause=0] Onwards with the lesson then!")
	end
end


--Guild member interact script. The logic should be mostly the same between them all,
--so having them in one place (for now at least) is easiest. Personality will change to reflect
--who you're actually talking to.
function BATTLE_SCRIPT.GuildmateInteract(owner, ownerChar, context, args)
	local chara = context.User
	local target = context.Target
	local action_cancel = context.CancelState
	local turn_cancel = context.TurnCancel
	
	action_cancel.Cancel = true

  if COMMON.CanTalk(target) then
    
    UI:SetSpeaker(target)

    local ratio = target.HP * 100 // target.MaxHP
    
    local mon = _DATA:GetMonster(target.BaseForm.Species)
    local form = mon.Forms[target.BaseForm.Form]
    	
    local personality = 999--default error personality. 999 has one line, and it's to tell you it's invalid.
	
	local dungeon = GAME:GetCurrentDungeon().Name:ToLocal()
	local segment = _ZONE.CurrentMapID.Segment
        
		
	local target_tbl = LTBL(target)
	local target_importance = target_tbl.Importance
	
	--Check story flags and also the species of the char to figure out who's talking and what they'd say.
	if SV.ChapterProgression.Chapter == 5 then
		--Expedition arc. Check importance flag that identifies who they are to get personality. Start personalities at 300 for NPCs
		if target_importance == "Snubbull" then 
			personality = 300
		elseif target_importance == "Audino" then 
			personality = 301
		elseif target_importance == "Growlithe" then 
			if segment == 2 then--Boss fight. Dialogue same regardless of boss death status.
				personality = 304
			elseif SV.Chapter5.DiedToBoss then--If in segment 0 or 1, and you've died to the boss, different dialogue.
				personality = 305
			elseif segment == 1 then --second half, didnt die to boss 
				personality = 303
			elseif segment == 0 then -- didnt die to boss
				personality = 302
			end 
		elseif target_importance == "Zigzagoon" then 
			if segment == 2 then--Boss fight. Dialogue same regardless of boss death status.
				personality = 308
			elseif SV.Chapter5.DiedToBoss then--If in segment 0 or 1, and you've died to the boss, different dialogue.
				personality = 309
			elseif segment == 1 then --second half, didnt die to boss 
				personality = 307
			elseif segment == 0 then -- didnt die to boss
				personality = 306
			end 		
		elseif target_importance == "Cranidos" then 
			--Run a check to see if Shuca is nearby. If she's next to Ganlon, ganlon acts timid.
			--Additionally, if you're smart enough to use team mode to talk to Ganlon as Shuca, get ANOTHER personality set where he's blushing.
			--Otherwise, Ganlon's an asshole.
			
			--Shuca should always be in the last party slot.
			local shuca = GAME:GetPlayerPartyMember(3)
			
			--Check Shuca's health. Ganlon will have different dialogue if she's on critical HP.
			local shucaHealthRatio = shuca.HP * 100 // shuca.MaxHP
			
			local tbl = LTBL(chara)
			if tbl.Importance == "Mareep" then
				if shucaHealthRatio <= 25 then 
					UI:SetSpeakerEmotion("Sad")
					personality = 314
				else 
					UI:SetSpeakerEmotion("Special1")--Blushing 
					personality = 312
				end
			else
				--Check if he's next to shuca if you're not shuca.
				local nextToShuca = false
				if (shuca.CharLoc - target.CharLoc):Dist8() <= 1 and not shuca.Dead then nextToShuca = true end
				
				if shucaHealthRatio <= 25 then
					UI:SetSpeakerEmotion("Angry")
					personality = 313--He's mad at you that Shuca's in danger, irrespective of distance between him and Shuca
				elseif nextToShuca then 
					personality = 311--timid when next to Shuca
				else 				
					UI:SetSpeakerEmotion("Determined")--Jerk if she isn't next to him
					personality = 310
				end
			end
		elseif target_importance == "Mareep" then 
			local tbl = LTBL(chara)
			if tbl.Importance == "Cranidos" then	
				UI:SetSpeakerEmotion("Happy")
				personality = 316
			else 
				personality = 315
			end
		end
	else--For chapters down the road
		
	end
	print("personality: " .. tostring(personality))
			
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
    
	--Choose a quote, replacing wildcards in the process.
    chosen_quote = ChooseQuote(chara, target, key, running_pool)
	
	local oldDir = target.CharDir
    DUNGEON:CharTurnToChar(target, chara)
  
  
    UI:WaitShowDialogue(chosen_quote)
  
    target.CharDir = oldDir
  else
  
    UI:ResetSpeaker()
	
	local chosen_quote = RogueEssence.StringKey("TALK_CANT"):ToLocal()
    chosen_quote = string.gsub(chosen_quote, "%[myname%]", target:GetDisplayName(true))
	
    UI:WaitShowDialogue(chosen_quote)
  
  end
end







function BATTLE_SCRIPT.SynergyScarfAttack(owner, ownerChar, context, args)
	local dmgmult = luanet.ctype(DmgMultType)
	if context.User.EquippedItem.ID == "held_synergy_scarf" then 
		--print("Atk " .. ownerChar.Nickname)
		--give multiplycategory status events to boost stats by 10%
		context:AddContextStateMult(dmgmult, false, 11, 10)
	end
end


function BATTLE_SCRIPT.SynergyScarfDefense(owner, ownerChar, context, args)
	local dmgmult = luanet.ctype(DmgMultType)
	if context.Target.EquippedItem.ID == "held_synergy_scarf" then 
		--print("Def " .. ownerChar.Nickname)
		--give multiplycategory status events to boost stats by 10%
		context:AddContextStateMult(dmgmult, false, 9, 10)
	end
end

--for information on how this script was made, and things like getting and converting from c# to lua and back, look at these messages between Palika and Audino
--https://discord.com/channels/534207185333256223/575891034949812225/987567409856675950
--note on when to use colon vs period for these types of things :
--Function call (if it uses parentheses) = colon
--Anything else = period
--there are a few exceptions though

function BATTLE_SCRIPT.SynergyScarfPass(owner, ownerChar, context, args)
	local redirection = luanet.ctype(RedirectionType)
	--A “context” stores all the information regarding this battle turn of a particular pokemon, like the fact that an attack critted
	--a turn can be things such as using a move, item, triggering a trap, but not passing a turn or moving. it's a BATTLE context
	--critical health, get a pass scarf event.
	--only pass to an ally who also has a scarf
	
	if ownerChar.HP <= ownerChar.MaxHP / 4 then
		
		--Do not redirect attacks that were already redirected
		if (context.ContextStates:Contains(redirection)) then
			return
		end 
		
		if (context.ActionType == RogueEssence.Dungeon.BattleActionType.Trap or context.ActionType == RogueEssence.Dungeon.BattleActionType.Item) then
			return
		end
		
		--needs to be an attacking move
		if (context.Data.Category ~= RogueEssence.Data.BattleData.SkillCategory.Physical and context.Data.Category ~= RogueEssence.Data.BattleData.SkillCategory.Magical) then
			return
		end 
		
		if (_ZONE.CurrentMap:GetCharAtLoc(context.ExplosionTile) ~= ownerChar) then
			return
		end 
		
		--make sure incoming "attack" is from a foe 
		if _DUNGEON:GetMatchup(ownerChar, context.User) ~= RogueEssence.Dungeon.Alignment.Foe then 
			return
		end

		
		
		--print("Pass " .. ownerChar.Nickname)

		local teamcount = GAME:GetPlayerPartyCount()
		for i = 0, teamcount - 1, 1 do 
			local partymember = GAME:GetPlayerPartyMember(i)
			--bodyguard must be next to you, holding a scarf, alive, and not yourself
			if partymember ~= ownerChar and not partymember.Dead and (partymember.CharLoc - ownerChar.CharLoc):Dist8() <= 1 and partymember.EquippedItem.ID == "held_synergy_scarf" then 
				--print(partymember.MemberTeam:GetCharIndex(partymember).Char) -- print slot of teammate (also this is how you get the slot of a party member)
				
				--cannot bodyguard if sleeping, paralyzed, or frozen
				if partymember:GetStatusEffect("sleep") == nil and partymember:GetStatusEffect("paralyze") == nil and partymember:GetStatusEffect("freeze") == nil then
				
					local scarves_name = STRINGS:Format('\\uE0AE')..'[color=#FFCEFF]Synergy Scarves[color]'

					_DUNGEON:LogMsg(STRINGS:Format("{0}'s and {1}'s " .. scarves_name .. " glow brightly!", partymember:GetDisplayName(false), ownerChar:GetDisplayName(false)))
					
					local olddir = partymember.CharDir 
					
					DUNGEON:CharTurnToChar(partymember, ownerChar)
					local anim = RogueEssence.Dungeon.CharAnimAction()

					anim.BaseFrameType = 40--Swing
					anim.AnimLoc = partymember.CharLoc
					anim.CharDir = partymember.CharDir
					TASK:WaitTask(partymember:StartAnim(anim))
					GAME:WaitFrames(16)
					--partymember.CharDir = olddir
					
					--_DUNGEON:LogMsg(STRINGS:Format(RogueEssence.StringKey("MSG_PASS_ATTACK"):ToLocal(), ownerChar:GetDisplayName(false), partymember:GetDisplayName(false)))
					_DUNGEON:LogMsg(STRINGS:Format("{0} intercepted the attack headed for {1}!", partymember:GetDisplayName(false), ownerChar:GetDisplayName(false)))
					context.ExplosionTile = partymember.CharLoc
					context.ContextStates:Set(PMDC.Dungeon.Redirected())
					return
				end
			end
		end
	end
end








