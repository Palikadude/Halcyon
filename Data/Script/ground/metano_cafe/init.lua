--[[
    init.lua
    Created: 02/07/2021 21:52:45
    Description: Autogenerated script file for the map metano_cafe.
]]--
-- Commonly included lua functions and data
require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

-- Package name
local metano_cafe = {}

-- Local, localized strings table
-- Use this to display the named strings you added in the strings files for the map!
-- Ex:
--      local localizedstring = MapStrings['SomeStringName']
local MapStrings = {}

-------------------------------
-- Map Callbacks
-------------------------------
---metano_cafe.Init
--Engine callback function
function metano_cafe.Init(map, time)
	DEBUG.EnableDbgCoro()
	print('=>> Init_metano_cafe <<=')
	MapStrings = COMMON.AutoLoadLocalizedStrings()
	COMMON.RespawnAllies()
	
	PartnerEssentials.InitializePartnerSpawn()
end

---metano_cafe.Enter
--Engine callback function
function metano_cafe.Enter(map, time)
	metano_cafe.PlotScripting()
end

---metano_cafe.Update
--Engine callback function
function metano_cafe.Update(map, time)
	

end

function metano_cafe.GameLoad(map)
	PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
	metano_cafe.PlotScripting()
end

function metano_cafe.GameSave(map)
	PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function metano_cafe.PlotScripting()
	GAME:FadeIn(20)
end

-------------------------------
-- Map Transition
-------------------------------

function metano_cafe.Cafe_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  SOUND:FadeOutBGM(20)
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("metano_town", "Cafe_Entrance_Marker")
  SV.partner.Spawn = 'Cafe_Entrance_Marker_Partner'
end



-------------------------------
-- Entities Callbacks
-------------------------------

--lists fermented drinks, their effects, and the recipes for each
function metano_cafe.Cafe_Sign_Action(obj, activator)
	DEBUG.EnableDbgCoro()
	print("Cafe sign action")
	UI:ResetSpeaker()
	local state = 0
	UI:SetCenter(true)
	UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Sign_Intro']))
	UI:SetCenter(false)
	
	local item1
	local item2
	
	while state > -1 do
		local choices = {STRINGS:Format(MapStrings['Cafe_Option_Domi']),
						STRINGS:Format(MapStrings['Cafe_Option_Cider']), 
						STRINGS:Format(MapStrings['Cafe_Option_Bomb']), 
						STRINGS:FormatKey('MENU_EXIT')}
		UI:BeginChoiceMenu(STRINGS:Format(MapStrings['Cafe_Sign_Which_Drinks']), choices, 1, #choices)
		UI:WaitForChoice()
		local result = UI:ChoiceResult()
		if result == 1 then
			item1 = RogueEssence.Dungeon.InvItem("oran_berry")--oran berry 
			item2 = RogueEssence.Dungeon.InvItem("ammo_stick")--stick
			item2.Amount = 5
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Sign_Domi_1']))
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Sign_Domi_2'], item1:GetDisplayName(), item2:GetDisplayName()))
		elseif result == 2 then
			item1 = RogueEssence.Dungeon.InvItem("apple")--Apple 
			item2 = RogueEssence.Dungeon.InvItem("oran_berry")--oran berry
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Sign_Cider_1']))
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Sign_Cider_2'], item1:GetDisplayName(), item2:GetDisplayName()))
		elseif result == 3 then 
			item1 = RogueEssence.Dungeon.InvItem("cheri_berry")--cheri berry
			item2 = RogueEssence.Dungeon.InvItem("blast_seed")--blast seed 
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Sign_Bomb_1']))
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Sign_Bomb_2'], item1:GetDisplayName(), item2:GetDisplayName()))
		else
			state = -1
		end
	end
	
end


--[[
Drink ideas:
Frosty Float:
- ingredients: aspear berries, oran berries
- grants aurora veil to the party, even if it's not hailing

Banana Smoothie:
- Party full HP recovery + all stats EVs up by 1
- Tropius provides bananas to guild members as a rare reward for a job well done 


Endure Tonic:
- Gives drinker endure status for some time where they cannot be KO'd.
- Costs a reviver seed and something else.
]]--

function metano_cafe.Cafe_Action(obj, activator)
	DEBUG.EnableDbgCoro()
	print("Cafe action")
	
	local state = 0
	local repeated = false
	
	--list of ~100 items, a random one is taken for new day to be sold as the cafe's special. entries show up multiple times if they're more common
	local specials_catalog  = 
	{
		"food_apple_big", "food_apple_big", "food_apple_big", "food_apple_big", "food_apple_big",  --big apples
		"food_apple_huge", "food_apple_huge", "food_apple_huge", "food_apple_huge", "food_apple_huge",  --huge apples
		"food_apple_golden", 				--gold apples
		"food_apple_perfect", "food_apple_perfect", "food_apple_perfect",        --perfect apples
		"food_banana", "food_banana" ,"food_banana", "food_banana", "food_banana",  --bananas
		"food_banana_big", "food_banana_big", "food_banana_big",		--big bananas
		"food_banana_golden", 				--golden banana
		"lum_berry", "lum_berry", "lum_berry",		--lum berry
		"berry_tanga", "berry_colbur", "berry_haban", "berry_wacan", "berry_chople", "berry_occa", "berry_coba", "berry_kasib", "berry_rindo", "berry_shuca", "berry_yache", "berry_chilan", "berry_kebia", "berry_payapa", "berry_charti", "berry_babiri", "berry_passho", "berry_roseli", --type berries
		"berry_jaboca", "berry_rowap", "berry_apicot", "berry_liechi", "berry_ganlon", "berry_salac", "berry_petaya", "berry_starf", "berry_micle", "berry_enigma",  --other rare berries (enigma, starf, etc)
		"berry_sitrus", "berry_sitrus", "berry_sitrus",     --sitrus berry
		"wonder_gummi", "blue_gummi", "black_gummi", "clear_gummi", "grass_gummi", "green_gummi", "brown_gummi", "orange_gummi", "gold_gummi", "pink_gummi", "purple_gummi", "red_gummi", "royal_gummi", "silver_gummi", "white_gummi", "yellow_gummi", "sky_gummi", "gray_gummi", "magenta_gummi", --gummis
		"plain_seed", "plain_seed", "plain_seed", "plain_seed", "plain_seed", --plain seeds
		"reviver_seed", "reviver_seed", "reviver_seed", "reviver_seed",  --rev seed 
		"seed_joy",            --joy seed
		"seed_doom", "seed_doom", "seed_doom",  --doom seed 
		"boost_nectar", "boost_protein", "boost_iron", "boost_calcium", "boost_zinc", "boost_carbos", "boost_hp_up", --nectar + vitamins
		"herb_mental", "herb_power", "herb_white"  --mental, power, white herb
	}
	
	-- special is -1 if nothing has been selected as the daily special. It should be set back to -1 when a new day happens
	--but more ideally it should just be reinitialized when a new day happens. I just need to figure out how to do that properly
	if SV.metano_cafe.CafeSpecial == -1 then 
		SV.metano_cafe.CafeSpecial = GAME.Rand:Next(1, #specials_catalog)
	end
	
	local special = RogueEssence.Dungeon.InvItem(specials_catalog[SV.metano_cafe.CafeSpecial])
	local specialName = special:GetDisplayName()
	local specialPrice = special:GetSellValue()
	local owner = CH('Cafe_Owner')
	UI:SetSpeaker(owner)
	
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	owner.IsInteracting = true
	partner.IsInteracting = true
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharSetAnim(owner, 'None', true)
			
	GROUND:CharTurnToChar(hero, owner)
	local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, owner, 4) end)

	
	--he has a fermented item to give you
	if SV.metano_cafe.FermentedItem ~= "" and SV.metano_cafe.ItemFinishedFermenting then
		local juice = RogueEssence.Dungeon.InvItem(SV.metano_cafe.FermentedItem)
		local juiceEntry = RogueEssence.Data.DataManager.Instance:GetItem(juice.ID)
		UI:SetSpeakerEmotion('Normal')
		UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Fermented_Give_Item'], juice:GetDisplayName()))
		if GAME:GetPlayerBagCount() == GAME:GetPlayerBagLimit() then
			UI:SetSpeakerEmotion('Worried')
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Bag_Full'], CharacterEssentials.GetCharacterName('Kangaskhan')))
			state = -1 --don't go to normal dialogue if he cant give you the fermented item.
		else
			GAME:GivePlayerItem(juice.ID, juiceEntry.MaxStack)
			SV.metano_cafe.FermentedItem = ""
			SV.metano_cafe.ItemFinishedFermenting = false
			SOUND:PlayBattleSE("DUN_Drink")
			UI:ResetSpeaker()
			UI:SetCenter(true)
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Fermented_Item_Received'], juice:GetDisplayName(), owner:GetDisplayName()))
			UI:SetCenter(false)
		end			
	end
	

	--Normal Cafe Shop script
	while state > -1 do
		UI:SetSpeaker(owner)
		UI:SetSpeakerEmotion("Normal")
		local msg = STRINGS:Format(MapStrings['Cafe_Intro'])
		if repeated then 
			msg = STRINGS:Format(MapStrings['Cafe_Intro_Return'])
		end
		local cafe_choices = {STRINGS:Format(MapStrings['Cafe_Option_Ferment']), STRINGS:Format(MapStrings['Cafe_Option_Special']),
							  STRINGS:FormatKey('MENU_INFO'), STRINGS:FormatKey('MENU_EXIT')}
		UI:BeginChoiceMenu(msg, cafe_choices, 1, 4)
		UI:WaitForChoice()
		local result = UI:ChoiceResult()
		repeated = true
		if result == 1 then --drinks
			local ferment_state = 0
			local item_to_ferment = ""
			local recipe_list = {}
			
			--he's already brewing something
			if SV.metano_cafe.FermentedItem ~= "" then
				local ferment_item = RogueEssence.Dungeon.InvItem(SV.metano_cafe.FermentedItem)
				local ferment_item_entry = RogueEssence.Data.DataManager.Instance:GetItem(SV.metano_cafe.FermentedItem)
				
				if ferment_item_entry.MaxStack > 1 then ferment_item.Amount = ferment_item_entry.MaxStack end--for multi-use items, like the apple cider
				
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Already_Fermenting'], ferment_item:GetDisplayName()))
				ferment_state = -1
			end
			
			while ferment_state > -1 do
				local ferment_choices = {STRINGS:Format(MapStrings['Cafe_Option_Domi']), 
										 STRINGS:Format(MapStrings['Cafe_Option_Cider']),
										 STRINGS:Format(MapStrings['Cafe_Option_Bomb']),
										 STRINGS:FormatKey('MENU_EXIT')}
										 
				--TODO: As game grows and more drinks get added later in the plot, add scripting here to expand ferment_choices.						 
				
				UI:SetSpeakerEmotion("Normal")
				UI:BeginChoiceMenu(STRINGS:Format(MapStrings['Cafe_Ferment_Prompt']), ferment_choices, 1, #ferment_choices)
				UI:WaitForChoice()
				result = UI:ChoiceResult()
				if result == #ferment_choices then--back
					ferment_state = -1
				else
					if result == 1 then --Domi Blend - 3 Orans, 5 Sticks
						item_to_ferment = "domi_blend"
						recipe_list = {{"oran_berry", 3}, {"ammo_stick", 5}}
					elseif result == 2 then --Apple Cider - 1 Oran, 3 Apples
						item_to_ferment = "apple_cider"
						recipe_list = {{"oran_berry", 1}, {"apple", 3}}
					elseif result == 3 then--Cheri Bomb - 1 Cheri Berry, 1 Blast Seed
						item_to_ferment = "cheri_bomb"
						recipe_list = {{"cheri_berry", 1}, {"blast_seed", 1}}
					end
					
					
					local ferment_item = RogueEssence.Dungeon.InvItem(item_to_ferment)
					local ferment_item_entry = RogueEssence.Data.DataManager.Instance:GetItem(item_to_ferment)--need item entry to get maxstack.
			
					if ferment_item_entry.MaxStack > 1 then ferment_item.Amount = ferment_item_entry.MaxStack end--for multi-use items, like the apple cider
				
					--if we have the ingredients, set the fermented item to the one requested and let the player know.
					if metano_cafe.CheckForItems(recipe_list) then 
						--confirm that's the correct drink
						UI:ChoiceMenuYesNo(STRINGS:Format(MapStrings['Cafe_Confirm_Ferment_Choice'], ferment_item:GetDisplayName()), true)
						UI:WaitForChoice()
						local confirm = UI:ChoiceResult()
						--make drink if confirmed. Otherwise go back to previous menu asking which drink to make
						if confirm then
							SV.metano_cafe.FermentedItem = item_to_ferment
							metano_cafe.RemoveItems(recipe_list) 
							ferment_state = -1
							UI:SetSpeakerEmotion("Happy")
							UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Begin_Fermenting_1']))
							--puts the items in his shell
							SOUND:PlayBattleSE('DUN_Equip')
							GROUND:CharPoseAnim(owner, "Withdraw")
							GAME:WaitFrames(60)
							SOUND:PlayBattleSE('DUN_Drink')
							GAME:WaitFrames(60)
							SOUND:PlayBattleSE('DUN_Fake_Tears')
							GAME:WaitFrames(60)
							SOUND:PlayBattleSE('DUN_Food')
							GAME:WaitFrames(60)
							GROUND:CharSetAnim(owner, "None", true)
							SOUND:PlayBattleSE('DUN_Worry_Seed')
							UI:SetSpeakerEmotion("Inspired")
							UI:WaitShowTimedDialogue(STRINGS:Format(MapStrings['Cafe_Begin_Fermenting_2']), 60)
							GAME:WaitFrames(20)
							UI:SetSpeakerEmotion("Happy")
							UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Begin_Fermenting_3'], ferment_item:GetDisplayName()))
						end
					else --otherwise, say they don't have enough ingredients.
						UI:SetSpeakerEmotion("Worried")
						UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Missing_Ingredients'], ferment_item:GetDisplayName()))
					end

					
						
				end
			end
		elseif result == 2 then --today's special
			if SV.metano_cafe.BoughtSpecial then 
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Bought_Special']))	
			else 					
				UI:ChoiceMenuYesNo(STRINGS:Format(MapStrings['Cafe_Daily_Special'], specialName, specialPrice))
				UI:WaitForChoice()
				result = UI:ChoiceResult()
				if result then 
					if specialPrice > GAME:GetPlayerMoney() then
						UI:SetSpeakerEmotion('Worried')
						UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_No_Money']))
						UI:SetSpeakerEmotion('Normal')
					elseif GAME:GetPlayerBagCount() == GAME:GetPlayerBagLimit() then
						UI:SetSpeakerEmotion('Worried')
						UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Bag_Full'], CharacterEssentials.GetCharacterName('Kangaskhan')))
						UI:SetSpeakerEmotion('Normal')
					else
						SV.metano_cafe.BoughtSpecial = true
						GAME:RemoveFromPlayerMoney(specialPrice)
						GAME:GivePlayerItem(special.ID, 1)
						SOUND:PlayBattleSE("DUN_Money")
						UI:SetSpeakerEmotion("Happy")
						UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Special_Complete'], specialName))
						UI:SetSpeakerEmotion("Normal")
					end
				end 
			end
		elseif result == 3 then --cafe info
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Info_1']))
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Info_2']))
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Info_3']))
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Info_4']))
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Info_5']))
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Info_6']))
		else--exit
			UI:SetSpeakerEmotion("Happy")
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Goodbye']))
			UI:SetSpeakerEmotion("Normal")
			state = -1
		end
				
				
		
	
	
	
	--elseif state == 1 then 	 shop menu for smoothies	
		
		
	end

	--reimplementing parts of endconversation
	TASK:JoinCoroutines({coro1})
	partner.IsInteracting = false
	owner.IsInteracting = false
	
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	GROUND:CharEndAnim(owner)	
	
	
end




--used to check what items you have. Returns true or false.
--item list is a list of pairs that contain an item ID and the corresponding amount needed.
function metano_cafe.CheckForItems(itemList)
	local bag_count = GAME:GetPlayerBagCount()
	local item_count = #itemList--how many unique items are needed for the recipe?
	local stack_count
	local recipe_item
	local item
	local item_entry
	local togo 
	
	--no items, no way this could return true
	if bag_count == 0 then return false end
	
	for i=1, item_count, 1 do
		recipe_item = itemList[i][1]
		togo = itemList[i][2]
		for j=0, bag_count-1, 1 do
			item = GAME:GetPlayerBagItem(j)
			item_entry = RogueEssence.Data.DataManager.Instance:GetItem(item.ID)
			if item_entry.MaxStack > 1 then stack_count = item.Amount else stack_count = 1 end
			if item.ID == recipe_item then
				togo = togo - stack_count --subtract from the needed items by the stack count. This can go negative, which is fine.
			end
		end
		
		if togo > 0 then return false end --Break early and return a false if we couldn't meet the item requirements for a particular recipe item.
		
	end
	
	--to get to this point, we must have passed item counts for all needed items.
	return true

	

end

--used to remove items needed for a drink.
--item list is a list of pairs that contain an item ID and the corresponding amount needed.
function metano_cafe.RemoveItems(itemList)
	local bag_count
	local item_count = #itemList--how many unique items are needed for the recipe?
	local stack_count
	local recipe_item
	local item
	local item_entry
	local togo

	--the item bag indexes at 0.
	for i=1, item_count, 1 do
		recipe_item = itemList[i][1]	
		togo = itemList[i][2]
		bag_count = GAME:GetPlayerBagCount()--update bag count as we go
		for j=bag_count-1 , 0, -1 do
			item = GAME:GetPlayerBagItem(j)
			item_entry = RogueEssence.Data.DataManager.Instance:GetItem(item.ID)
			if item_entry.MaxStack > 1 then stack_count = item.Amount else stack_count = 1 end
			if item.ID == recipe_item then
				if item_entry.MaxStack <= 1 then 
					GAME:TakePlayerBagItem(j)
				else
					if item.Amount > togo then--check if the stackable item needs to be deleted, or just subtracted from.
						--remove from the player's bag item stack but not fully.
						item.Amount = stack_count - togo
					else
						print(item.Amount)
						print(j)
						GAME:TakePlayerBagItem(j)
					end
				end
				
				togo = togo - stack_count --subtract from the needed items by the stack count. This can go below 0 when stackables are involved.
						
				--break early for an item if this particular item has been cleared.
				if togo <= 0 then break end
			end
		end
	end

end

function metano_cafe.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

--your allies will wait for you in the cafe if you have any.
function metano_cafe.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  COMMON.GroundInteract(activator, chara, true)
end

function metano_cafe.Teammate3_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  COMMON.GroundInteract(activator, chara, true)
end



return metano_cafe

