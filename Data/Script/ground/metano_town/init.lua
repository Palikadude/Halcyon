require 'common'
require 'PartnerEssentials'
require 'metano_town_ch_1'

local MapStrings = {}

local metano_town = {}


function metano_town.Init(map)
	DEBUG.EnableDbgCoro()
	print('=>> Init_metano_town <<=')
	MapStrings = COMMON.AutoLoadLocalizedStrings()
	COMMON.RespawnAllies()
	PartnerEssentials.InitializePartnerSpawn()
	GROUND:AddMapStatus(6)
	
	
	--Set up some NPC States
	GROUND:CharSetAnim(CH('Furret'), 'Sleep', true)
	
	if SV.metano_town.AggronGuided then--Hide Aggron if he's been guided to the Dojo
		GROUND:Hide('Aggron')
	end
	
	local chara = CH('Aggron')
	metano_town.CreateWalkArea(chara, 1264, 560, 32, 32)
	chara = CH('Delcatty')
	metano_town.CreateWalkArea(chara, 1122, 888, 32, 32)
	




end



function metano_town.Enter(map)
	DEBUG.EnableDbgCoro()
	print('Enter_metano_town')
	UI:ResetSpeaker()
	--if SV.ChapterProgression.Chapter == 1 then 
		--if not SV.Chapter1.PartnerCompletedForest then
			--metano_town_ch_1.PartnerLongingCutscene()
		--elseif SV.Chapter1.TeamCompletedForest then
			--metano_town_ch_1.EnterGuild()
		--end
	--else 
		GAME:FadeIn(20)
--	end
	--GAME:MoveCamera(0,0,60, true)
end

function metano_town.Update(map, time)

end

--------------------------------------------------
-- Map Begin Functions
--------------------------------------------------
function metano_town.CreateWalkArea(chara, x, y, w, h)


  --Set the area to wander in
  AI:SetCharacterAI(chara,                                      --[[Entity that will use the AI]]--
                    "ai.ground_default",                         --[[Class path to the AI class to use]]--
                    RogueElements.Loc(x, y), --[[Top left corner pos of the allowed idle wander area]]--
                    RogueElements.Loc(w, h), --[[Width and Height of the allowed idle wander area]]--
                    1,                                         --[[Wandering speed]]--
                    16,                                          --[[Min move distance for a single wander]]--
                    32,                                          --[[Max move distance for a single wander]]--
                    40,                                         --[[Min delay between idle actions]]--
                    180)                                        --[[Max delay between idle actions]]--
end







----------------------
-- Map Transitions
----------------------

--Main_Entrance_Marker is the default entrance marker for a map, every map
--has that marker, but it's kinda arbitrary which one I choose to be the "main" one.
--Other markers may need to be specified if a map has more than once entrance point.

function metano_town.North_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("luminous_spring", "entrance_south")
  SV.partner.Spawn = 'Default'
end

function metano_town.South_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("metano_altere_transition", "Main_Entrance_Marker")
  SV.partner.Spawn = 'Default'
end

function metano_town.Guild_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("guild_first_floor", "Main_Entrance_Marker")
  SV.partner.Spawn = 'Default'
end

function metano_town.Cafe_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("metano_cafe", "Main_Entrance_Marker")
  SV.partner.Spawn = 'Default'
end

function metano_town.Fire_Home_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("metano_fire_home", "Main_Entrance_Marker")
  SV.partner.Spawn = 'Default'
end

function metano_town.Rock_Home_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("metano_rock_home", "Main_Entrance_Marker")
  SV.partner.Spawn = 'Default'
end

function metano_town.Water_Home_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("metano_water_home", "Main_Entrance_Marker")
  SV.partner.Spawn = 'Default'
end

function metano_town.Grass_Home_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("metano_grass_home", "Main_Entrance_Marker")
  SV.partner.Spawn = 'Default'
end

function metano_town.Electric_Home_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("metano_electric_home", "Main_Entrance_Marker")
  SV.partner.Spawn = 'Default'
end

function metano_town.Cave_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("metano_cave", "Main_Entrance_Marker")
  SV.partner.Spawn = 'Default'
end







-----------------------
-- Partner scripting
-----------------------

function metano_town.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function metano_town.Mawile_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  COMMON.GroundInteract(activator, chara, true)
  AI:SetCharacterAI(chara, "ai.ground_partner", CH('PLAYER'), chara.Position)
  chara.CollisionDisabled = true
end


-----------------------
-- Shop/Useful NPCs
-----------------------

--TO DO: Randomize the trades that the Kec shop has, as well as the swap shop. Will need to make function that randomizes some values in SV global vars (base_shop, base_trades)


function metano_town.Shop_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  
  if not SV.metano_town.KecIntro then
	return
  end
  
  local state = 0
  local repeated = false
  local cart = {}
  local catalog = { }
  for ii = 1, #SV.base_shop, 1 do
	local base_data = SV.base_shop[ii]
	local item_data = { Item = RogueEssence.Dungeon.InvItem(base_data.Index,false,base_data.Hidden), Price = base_data.Price }
	table.insert(catalog, item_data)
  end
  
  
  local chara = CH('Shop_Owner')
  UI:SetSpeaker(chara)
  
	while state > -1 do
		if state == 0 then
			local msg = STRINGS:Format(MapStrings['Shop_Intro'])
			if repeated == true then
				msg = STRINGS:Format(MapStrings['Shop_Intro_Return'])
			end
			local shop_choices = {STRINGS:Format(MapStrings['Shop_Option_Buy']), STRINGS:Format(MapStrings['Shop_Option_Sell']),
			STRINGS:FormatKey("MENU_INFO"),
			STRINGS:FormatKey("MENU_EXIT")}
			UI:BeginChoiceMenu(msg, shop_choices, 1, 4)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			repeated = true
			if result == 1 then
				if #catalog > 0 then
					--TODO: use the enum instead of a hardcoded number
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['Shop_Buy'], STRINGS:LocalKeyString(26)))
					state = 1
				else
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['Shop_Buy_Empty']))
				end
			elseif result == 2 then
				local bag_count = GAME:GetPlayerBagCount()
				if bag_count > 0 then
					--TODO: use the enum instead of a hardcoded number
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['Shop_Sell'], STRINGS:LocalKeyString(26)))
					state = 3
				else
					UI:SetSpeakerEmotion("Angry")
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['Shop_Bag_Empty']))
					UI:SetSpeakerEmotion("Normal")
				end
			elseif result == 3 then
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Shop_Info_001']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Shop_Info_002']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Shop_Info_003']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Shop_Info_004']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Shop_Info_005']))
			else
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Shop_Goodbye']))
				state = -1
			end
		elseif state == 1 then
			UI:ShopMenu(catalog)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			if #result > 0 then
				local bag_count = GAME:GetPlayerBagCount()
				local bag_cap = GAME:GetPlayerBagLimit()
				if bag_count == bag_cap then
					UI:SetSpeakerEmotion("Angry")
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['Shop_Bag_Full']))
					UI:SetSpeakerEmotion("Normal")
				else
					cart = result
					state = 2
				end
			else
				state = 0
			end
		elseif state == 2 then
			local total = 0
			for ii = 1, #cart, 1 do
				total = total + catalog[cart[ii]].Price
			end
			local msg
			if total > GAME:GetPlayerMoney() then
				UI:SetSpeakerEmotion("Angry")
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Shop_Buy_No_Money']))
				UI:SetSpeakerEmotion("Normal")
				state = 1
			else
				if #cart == 1 then
					local name = catalog[cart[1]].Item:GetDisplayName()
					msg = STRINGS:Format(MapStrings['Shop_Buy_One'], total, name)
				else
					msg = STRINGS:Format(MapStrings['Shop_Buy_Multi'], total)
				end
				UI:ChoiceMenuYesNo(msg, false)
				UI:WaitForChoice()
				result = UI:ChoiceResult()
				
				if result then
					GAME:RemoveFromPlayerMoney(total)
					for ii = 1, #cart, 1 do
						local item = catalog[cart[ii]].Item
						GAME:GivePlayerItem(item.ID, 1, false, item.HiddenValue)
					end
					for ii = #cart, 1, -1 do
						table.remove(catalog, cart[ii])
						table.remove(SV.base_shop, cart[ii])
					end
					
					cart = {}
					SOUND:PlayBattleSE("DUN_Money")
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['Shop_Buy_Complete']))
					state = 0
				else
					state = 1
				end
			end
		elseif state == 3 then
			UI:SellMenu()
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			
			if #result > 0 then
				cart = result
				state = 4
			else
				state = 0
			end
		elseif state == 4 then
			local total = 0
			for ii = 1, #cart, 1 do
				local item
				if cart[ii].IsEquipped then
					item = GAME:GetPlayerEquippedItem(cart[ii].Slot)
				else
					item = GAME:GetPlayerBagItem(cart[ii].Slot)
				end
				total = total + item:GetSellValue()
			end
			local msg
			if #cart == 1 then
				local item
				if cart[1].IsEquipped then
					item = GAME:GetPlayerEquippedItem(cart[1].Slot)
				else
					item = GAME:GetPlayerBagItem(cart[1].Slot)
				end
				msg = STRINGS:Format(MapStrings['Shop_Sell_One'], total, item:GetDisplayName())
			else
				msg = STRINGS:Format(MapStrings['Shop_Sell_Multi'], total)
			end
			UI:ChoiceMenuYesNo(msg, false)
			UI:WaitForChoice()
			result = UI:ChoiceResult()
			
			if result then
				for ii = #cart, 1, -1 do
					if cart[ii].IsEquipped then
						GAME:TakePlayerEquippedItem(cart[ii].Slot)
					else
						GAME:TakePlayerBagItem(cart[ii].Slot)
					end
				end
				SOUND:PlayBattleSE("DUN_Money")
				GAME:AddToPlayerMoney(total)
				cart = {}
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Shop_Sell_Complete']))
				state = 0
			else
				state = 3
			end
		end
	end
end

function metano_town.Musician_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  local chara = CH('Musician')
  UI:SetSpeaker(chara)
  UI:WaitShowDialogue(STRINGS:Format(MapStrings['Music_Intro']))
  UI:ShowMusicMenu()
  UI:WaitForChoice()
  local result = UI:ChoiceResult()
  if result ~= nil then
	SV.base_town.Song = result--To do: rename this for specifically metano town map
  end
  UI:WaitShowDialogue(STRINGS:Format(MapStrings['Music_End']))
end









function metano_town.Storage_Action(obj, activator)
	DEBUG.EnableDbgCoro()
	
	UI:SetSpeaker(CH('Storage_Owner'))
	UI:SetSpeakerEmotion('Happy')
	
	local state = 0
	local repeated = false
	
	while state > -1 do
		local has_items = GAME:GetPlayerBagCount() > 0
		local has_storage = GAME:GetPlayerStorageCount() > 0
		
		local item_count = GAME:GetPlayerBagCount()
		
		local storage_choices = { { STRINGS:FormatKey('MENU_STORAGE_STORE'), has_items},
		{ STRINGS:FormatKey('MENU_STORAGE_TAKE_ITEM'), has_storage},
		{ STRINGS:FormatKey('MENU_INFO'), true},
		{ STRINGS:FormatKey("MENU_CANCEL"), true}}
		
		local msg = STRINGS:Format(MapStrings['Storage_Intro'])
		if repeated then 
			msg = STRINGS:Format(MapStrings['Storage_Intro_Return']) 
			UI:SetSpeakerEmotion('Normal')			
		end
		
		UI:BeginChoiceMenu(msg, storage_choices, 1, 4)
		UI:WaitForChoice()
		local result = UI:ChoiceResult()	
		UI:SetSpeakerEmotion('Normal')

		
		if result == 1 then
			repeated = true
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Storage_Store'], STRINGS:LocalKeyString(26)))
			UI:StorageMenu()
			UI:WaitForChoice()
			if item_count ~= GAME:GetPlayerBagCount() then 
				UI:SetSpeakerEmotion('Happy')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Storage_Stored_Items']))
			end
		elseif result == 2 then
			repeated = true
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Storage_Withdraw'], STRINGS:LocalKeyString(26)))
			UI:WithdrawMenu()
			UI:WaitForChoice()
			if item_count ~= GAME:GetPlayerBagCount() then 
				UI:SetSpeakerEmotion('Happy')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Storage_Withdrew_Items']))
			end 
		elseif result == 3 then
			repeated = true
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Storage_Info_1']))
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Storage_Info_2']))
			UI:SetSpeakerEmotion('Happy')
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Storage_Info_3']))
			UI:SetSpeakerEmotion('Normal')
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Storage_Info_4']))
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Storage_Info_5']))
		else 
			UI:SetSpeakerEmotion('Happy')
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Storage_Goodbye']))
			state = -1
		end
	end
end 

function metano_town.Bank_Action(obj, activator)
	DEBUG.EnableDbgCoro()
	
	UI:SetSpeaker(CH('Bank_Owner'))
	
	local state = 0
	local repeated = false
	
	while state > -1 do
		
		local player_money = GAME:GetPlayerMoney()
		local bank_choices = { { STRINGS:FormatKey('MENU_STORAGE_MONEY'), true},
		{ STRINGS:FormatKey('MENU_INFO'), true},
		{ STRINGS:FormatKey("MENU_CANCEL"), true}}
		
		local msg = STRINGS:Format(MapStrings['Bank_Intro'], GAME:GetPlayerMoneyBank())
		if repeated then msg = STRINGS:Format(MapStrings['Bank_Intro_Return']) end
		
		UI:BeginChoiceMenu(msg, bank_choices, 1, 3)
		UI:WaitForChoice()
		local result = UI:ChoiceResult()	
		
		if result == 1 then
			repeated = true
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Bank_Interact']))
			UI:BankMenu()
			UI:WaitForChoice()
			local difference = math.abs(player_money - GAME:GetPlayerMoney())
			if player_money > GAME:GetPlayerMoney() then --deposited money
				UI:SetSpeakerEmotion('Inspired')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Bank_Stored_Money'], difference))
			elseif player_money < GAME:GetPlayerMoney() then --Withdrew money
				UI:SetSpeakerEmotion('Sad')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Bank_Withdrew_Money'], difference))
			else 
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Bank_Canceled']))
			end
			UI:SetSpeakerEmotion('Normal')
		elseif result == 2 then
			repeated = true
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Bank_Info_1']))
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Bank_Info_2']))
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Bank_Info_3']))
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Bank_Info_4']))
		else 
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Bank_Goodbye']))
			state = -1
		end
	end
end 


function metano_town.Red_Merchant_Action(obj, activator)
	DEBUG.EnableDbgCoro()
	local state = 0
	local repeated = false

	
	--todo: remove some nice items, add to green merchant... they should have a few exclusive items
	
	--items the merchants can potentially sell. should be about 2/3 chance for common junk, 1/3 to get something more interesting.
	local merchant_catalog = 
	{
		450, 450, 450, --link box 
		--451, 451, 451, --assembly box (disabled in demo)
		452, 452, 452, --storage box
		200, 200, 200, 200, 200, 200, 200, 200, 200, 200, --stick
		201, 201, 201, 201, 201, --cacnea spike
		202, 202, 202, 202, 202, --corsola twig
		203, 203, 203, 203, 203, --iron thorn
		204, 204, 204, 204, 204,  --silver spike 
		205, 205, 205,   --golden thorn 
		206,  --rare fossil
		207, 207, 207, 207, 207, --geo pebble
		208, 208, 208, 208, 208,   --gravelerock
		219, --perfect apricorn
		220, 220, 220, 220, 220,--path wand 
		221, 221, 221, 221, 221,--pounce wand 
		222, 222, 222, 222, 222, --whirlwind wand
		223, 223, 223, 223, 223, --switcher wand
		224, 224, 224, 224, 224, --surround wand
		225, 225, 225, 225, 225,--lure wand 
		226, 226, 226, 226, 226, --slow wand 
		227, 227, 227, 227, 227, --stayaway wand 
		228, 228, 228, 228, 228, --fear wand 
		229, 229, 229, 229, 229,--totter wand
		230, 230, 230, 230, 230,--infatuation wand 
		231, 231, 231, 231, 231, --topsy turvy wand 
		232, 232, 232, 232, 232, --warp wand 
		233, 233, 233, 233, 233, --purge wand
		234, 234, 234, 234, 234, --lob wand
		--rest of items are non "junk", put one of each since they should be rare to get a specific item, but there's so many different ones it isn't rare to find non junk
		331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 342, 343, 344, 345, 346, 347, 348, --type boosting items
		349, 350, 351, 352, 353, 354, 355, 356, 357, 358, 359, 360, 361, 362, 363, 364, 365, 366, 367, 368, 369, 370, 371, 372, 373, 374, 375, 376, 377, 378,--evolution items, maybe disable if game is not complete?
		453 --ability capsule
	}
	
	if SV.DailyFlags.RedMerchantItem == -1 then 
		SV.DailyFlags.RedMerchantItem = GAME.Rand:Next(1, #merchant_catalog)
	end
	
	local chara = CH('Red_Merchant')
	
	local item = RogueEssence.Dungeon.InvItem(merchant_catalog[SV.DailyFlags.RedMerchantItem])
	local itemEntry = RogueEssence.Data.DataManager.Instance:GetItem(item.ID)
	item.HiddenValue = itemEntry.MaxStack
	local itemName = item:GetDisplayName()
	local itemPrice = item:GetSellValue()

	local merchant_choices = {STRINGS:Format(MapStrings['Merchant_Option_Deal']), STRINGS:FormatKey('MENU_INFO'), STRINGS:FormatKey('MENU_EXIT')}
	UI:SetSpeaker(chara)
	local olddir = chara.Direction
	GROUND:CharTurnToChar(chara, CH('PLAYER'))
	
	while state > -1 do
		--merchant is angry and refuses to sell to you if you bought from the green merchant
		local angry = SV.DailyFlags.GreenMerchantBought
		--merchant is happy if you've bought from him, he can't sell you anything else though.
		local happy = SV.DailyFlags.RedMerchantBought
		
		UI:SetSpeakerEmotion('Normal')
		local msg = STRINGS:Format(MapStrings['Red_Merchant_Intro'])
		
		
		if repeated then
			if happy then 
				msg = STRINGS:Format(MapStrings['Red_Merchant_Intro_Return_Happy'])
				UI:SetSpeakerEmotion('Normal')
			elseif angry then 
				state = -1 --he won't loop back to the menu if he's angry, he's just done with you
				break
			else
				msg = STRINGS:Format(MapStrings['Red_Merchant_Intro_Return'])
			end
		elseif happy then
			UI:SetSpeakerEmotion('Happy')
			msg = STRINGS:Format(MapStrings['Red_Merchant_Intro_Happy'])
		elseif angry then 
			UI:SetSpeakerEmotion('Determined')
			msg = STRINGS:Format(MapStrings['Red_Merchant_Intro_Angry'])
		end
		
		UI:BeginChoiceMenu(msg, merchant_choices, 1, 3)
		UI:WaitForChoice()
		local result = UI:ChoiceResult()
		repeated = true
		if result == 1 then 
			if happy then 
				UI:SetSpeakerEmotion('Worried')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Red_Merchant_No_Stock']))
			elseif angry then 
				UI:SetSpeakerEmotion('Angry')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Red_Merchant_Refuse_Service']))
			else
				UI:ChoiceMenuYesNo(STRINGS:Format(MapStrings['Red_Merchant_Daily_Item'], itemName, itemPrice))
				UI:WaitForChoice()
				result = UI:ChoiceResult()
				if result then
					if itemPrice > GAME:GetPlayerMoney() then
						UI:SetSpeakerEmotion('Worried')
						UI:WaitShowDialogue(STRINGS:Format(MapStrings['Red_Merchant_No_Money']))
					elseif GAME:GetPlayerBagCount() == GAME:GetPlayerBagLimit() then
						UI:SetSpeakerEmotion('Worried')
						UI:WaitShowDialogue(STRINGS:Format(MapStrings['Red_Merchant_Bag_Full']))
					else
						SV.DailyFlags.RedMerchantBought = true
						GAME:RemoveFromPlayerMoney(itemPrice)
						GAME:GivePlayerItem(item.ID, 1, false, itemEntry.MaxStack)
						SOUND:PlayBattleSE("DUN_Money")
						UI:SetSpeakerEmotion("Joyous")
						UI:WaitShowDialogue(STRINGS:Format(MapStrings['Red_Merchant_Purchase_Made'], itemName))
					end
				end
			end				
		elseif result == 2 then 
			if angry then 
				UI:SetSpeakerEmotion('Angry')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Red_Merchant_Info_Angry']))
			elseif happy then 
				UI:SetSpeakerEmotion('Normal')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Red_Merchant_Info_Happy_1']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Red_Merchant_Info_Happy_2']))
				UI:SetSpeakerEmotion('Sad')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Red_Merchant_Info_Happy_3']))
				UI:SetSpeakerEmotion('Inspired')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Red_Merchant_Info_Happy_4']))
				UI:SetSpeakerEmotion('Normal')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Red_Merchant_Info_Happy_5']))
			else 
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Red_Merchant_Info_1']))
				UI:SetSpeakerEmotion('Sad')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Red_Merchant_Info_2']))
				UI:SetSpeakerEmotion('Normal')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Red_Merchant_Info_3']))
				UI:SetSpeakerEmotion('Determined')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Red_Merchant_Info_4']))
				UI:SetSpeakerEmotion('Normal')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Red_Merchant_Info_5']))
			end 
		else
			if angry then
				UI:SetSpeakerEmotion('Determined')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Red_Merchant_Goodbye_Angry']))
			elseif happy then
				UI:SetSpeakerEmotion('Happy')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Red_Merchant_Goodbye_Happy']))
			else
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Red_Merchant_Goodbye']))
			end
			state = -1
		end 
	end

	GROUND:EntTurn(chara, olddir)
	
	
end



function metano_town.Green_Merchant_Action(obj, activator)
	DEBUG.EnableDbgCoro()
	local state = 0
	local repeated = false

	
	--code and strings say "angry" but this merchant actually gets sad when you buy from the other one. too lazy to update naming to reflect that, as code is copied from other merchant 
	--items the merchants can potentially sell. should be about 2/3 chance for common junk, 1/3 to get something more interesting.
	local merchant_catalog = 
	{
		450, 450, 450, --link box 
		--451, 451, 451, --assembly box (disable in demo)
		452, 452, 452, --storage box
		200, 200, 200, 200, 200, 200, 200, 200, 200, 200, --stick
		201, 201, 201, 201, 201, --cacnea spike
		202, 202, 202, 202, 202, --corsola twig
		203, 203, 203, 203, 203, --iron thorn
		204, 204, 204, 204, 204,  --silver spike 
		205, 205, 205,   --golden thorn 
		206,  --rare fossil
		207, 207, 207, 207, 207, --geo pebble
		208, 208, 208, 208, 208,   --gravelerock
		219, --perfect apricorn
		220, 220, 220, 220, 220,--path wand 
		221, 221, 221, 221, 221,--pounce wand 
		222, 222, 222, 222, 222, --whirlwind wand
		223, 223, 223, 223, 223, --switcher wand
		224, 224, 224, 224, 224, --surround wand
		225, 225, 225, 225, 225,--lure wand 
		226, 226, 226, 226, 226, --slow wand 
		227, 227, 227, 227, 227, --stayaway wand 
		228, 228, 228, 228, 228, --fear wand 
		229, 229, 229, 229, 229,--totter wand
		230, 230, 230, 230, 230,--infatuation wand 
		231, 231, 231, 231, 231, --topsy turvy wand 
		232, 232, 232, 232, 232, --warp wand 
		233, 233, 233, 233, 233, --purge wand
		234, 234, 234, 234, 234, --lob wand
		--rest of items are non "junk", put one of each since they should be rare to get a specific item, but there's so many different ones it isn't rare to find non junk
		400, 400, 400, 401, 401, 401, 402, 402, 402, 403, 403, 403, --power band, def scarf, etc
		300, 301, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, --some assorted bands and scarfs
		317, 318, 319, 320, 321, 322, 323, 324, 325, 326, 327, 328, 329, 330, 404, 405, --assorted hold items
		453 --ability capsule
	}
	
	if SV.DailyFlags.GreenMerchantItem == -1 then 
		SV.DailyFlags.GreenMerchantItem = GAME.Rand:Next(1, #merchant_catalog)
	end
	
	local chara = CH('Green_Merchant')
	
	local item = RogueEssence.Dungeon.InvItem(merchant_catalog[SV.DailyFlags.GreenMerchantItem])
	local itemEntry = RogueEssence.Data.DataManager.Instance:GetItem(item.ID)
	item.HiddenValue = itemEntry.MaxStack
	local itemName = item:GetDisplayName()
	local itemPrice = item:GetSellValue()
	local merchant_choices = {STRINGS:Format(MapStrings['Merchant_Option_Deal']), STRINGS:FormatKey('MENU_INFO'), STRINGS:FormatKey('MENU_EXIT')}
	UI:SetSpeaker(chara)
	local olddir = chara.Direction
	GROUND:CharTurnToChar(chara, CH('PLAYER'))
	
	while state > -1 do
		--merchant is angry and refuses to sell to you if you bought from the red merchant
		local angry = SV.DailyFlags.RedMerchantBought
		--merchant is happy if you've bought from him, he can't sell you anything else though.
		local happy = SV.DailyFlags.GreenMerchantBought
		
		UI:SetSpeakerEmotion('Normal')
		local msg = STRINGS:Format(MapStrings['Green_Merchant_Intro'])
		
		
		if repeated then
			if happy then 
				msg = STRINGS:Format(MapStrings['Green_Merchant_Intro_Return_Happy'])
				--UI:SetSpeakerEmotion('Happy')
			elseif angry then 
				state = -1 --he won't loop back to the menu if he's angry, he's just done with you
				break
			else
				msg = STRINGS:Format(MapStrings['Green_Merchant_Intro_Return'])
			end
		elseif happy then
			UI:SetSpeakerEmotion('Happy')
			msg = STRINGS:Format(MapStrings['Green_Merchant_Intro_Happy'])
		elseif angry then 
			UI:SetSpeakerEmotion('Teary-Eyed')
			msg = STRINGS:Format(MapStrings['Green_Merchant_Intro_Angry'])
		end
		
		UI:BeginChoiceMenu(msg, merchant_choices, 1, 3)
		UI:WaitForChoice()
		local result = UI:ChoiceResult()
		repeated = true
		if result == 1 then 
			if happy then 
				UI:SetSpeakerEmotion('Worried')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Green_Merchant_No_Stock']))
			elseif angry then 
				UI:SetSpeakerEmotion('Crying')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Green_Merchant_Refuse_Service']))
			else
				UI:ChoiceMenuYesNo(STRINGS:Format(MapStrings['Green_Merchant_Daily_Item'], itemName, itemPrice))
				UI:WaitForChoice()
				result = UI:ChoiceResult()
				if result then
					if itemPrice > GAME:GetPlayerMoney() then
						UI:SetSpeakerEmotion('Worried')
						UI:WaitShowDialogue(STRINGS:Format(MapStrings['Green_Merchant_No_Money']))
					elseif GAME:GetPlayerBagCount() == GAME:GetPlayerBagLimit() then
						UI:SetSpeakerEmotion('Worried')
						UI:WaitShowDialogue(STRINGS:Format(MapStrings['Green_Merchant_Bag_Full']))
					else
						SV.DailyFlags.GreenMerchantBought = true
						GAME:RemoveFromPlayerMoney(itemPrice)
						GAME:GivePlayerItem(item.ID, 1, false, itemEntry.MaxStack)
						SOUND:PlayBattleSE("DUN_Money")
						UI:SetSpeakerEmotion("Happy")
						UI:WaitShowDialogue(STRINGS:Format(MapStrings['Green_Merchant_Purchase_Made'], itemName))
					end
				end
			end				
		elseif result == 2 then 
			if angry then 
				UI:SetSpeakerEmotion('Crying')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Green_Merchant_Info_Angry']))
			elseif happy then 
				UI:SetSpeakerEmotion('Normal')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Green_Merchant_Info_Happy_1']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Green_Merchant_Info_Happy_2']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Green_Merchant_Info_Happy_3']))
				UI:SetSpeakerEmotion('Happy')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Green_Merchant_Info_Happy_4']))
				UI:SetSpeakerEmotion('Normal')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Green_Merchant_Info_Happy_5']))
			else 
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Green_Merchant_Info_1']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Green_Merchant_Info_2']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Green_Merchant_Info_3']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Green_Merchant_Info_4']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Green_Merchant_Info_5']))
			end 
		else
			if angry then
				UI:SetSpeakerEmotion('Teary-Eyed')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Green_Merchant_Goodbye_Angry']))
			elseif happy then
				UI:SetSpeakerEmotion('Happy')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Green_Merchant_Goodbye_Happy']))
			else
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Green_Merchant_Goodbye']))
			end
			state = -1
		end 
	end

	GROUND:EntTurn(chara, olddir)
	
	
	
	
	
	
end





function metano_town.Swap_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  
  --silk/dust/gem/globes
  local catalog = { 
	{ Item=702, ReqItem={700,701}},
	{ Item=703, ReqItem={700, 701, 702}},
	{ Item=706, ReqItem={704,705}},
	{ Item=707, ReqItem={704, 705, 706}},
	{ Item=710, ReqItem={708,709}},
	{ Item=711, ReqItem={708, 709, 710}},
	{ Item=714, ReqItem={712,713}},
	{ Item=715, ReqItem={712, 713, 714}},
	{ Item=718, ReqItem={716,717}},
	{ Item=719, ReqItem={716, 717, 718}},
	{ Item=722, ReqItem={720,721}},
	{ Item=723, ReqItem={720, 721, 722}},
	{ Item=726, ReqItem={724,725}},
	{ Item=727, ReqItem={724, 725, 726}},
	{ Item=730, ReqItem={728,729}},
	{ Item=731, ReqItem={728, 729, 730}},
	{ Item=734, ReqItem={732,733}},
	{ Item=735, ReqItem={732, 733, 734}},
	{ Item=738, ReqItem={736,737}},
	{ Item=739, ReqItem={736, 737, 738}},
	{ Item=742, ReqItem={740,741}},
	{ Item=743, ReqItem={740, 741, 742}},
	{ Item=746, ReqItem={744,745}},
	{ Item=747, ReqItem={744, 745, 746}},
	{ Item=750, ReqItem={748,749}},
	{ Item=751, ReqItem={748, 749, 750}},
	{ Item=754, ReqItem={752,753}},
	{ Item=755, ReqItem={752, 753, 754}},
	{ Item=758, ReqItem={756,757}},
	{ Item=759, ReqItem={756, 757, 758}},
	{ Item=762, ReqItem={760,761}},
	{ Item=763, ReqItem={760, 761, 762}},
	{ Item=766, ReqItem={764,765}},
	{ Item=767, ReqItem={764, 765, 766}},
	{ Item=770, ReqItem={768,769}},
	{ Item=771, ReqItem={768, 769, 770}}
}
  
  local state = 0
  local repeated = false
  local cart = {} --catalog element chosen to trade for
  local tribute = {} --item IDs chosen to trade in
  
  --normal trades
  for ii = 1, #COMMON_GEN.TRADES, 1 do
	local base_data = COMMON_GEN.TRADES[ii]
	table.insert(catalog, base_data)
  end
  
  --random trades
  for ii = 1, #SV.base_trades, 1 do
	local base_data = SV.base_trades[ii]
	table.insert(catalog, base_data)
  end
  
  local Prices = { 1000, 5000, 20000, 50000, 100000 }
  local player = CH('PLAYER')
  local chara = CH('Swap_Owner')
  UI:SetSpeaker(chara)
  
	while state > -1 do
		if state == 0 then
			local msg = STRINGS:Format(MapStrings['Swap_Intro'])
			if repeated == true then
				msg = STRINGS:Format(MapStrings['Swap_Intro_Return'])
			end
			local shop_choices = {STRINGS:Format(MapStrings['Swap_Option_Swap']),
			STRINGS:FormatKey("MENU_INFO"),
			STRINGS:FormatKey("MENU_EXIT")}
			UI:BeginChoiceMenu(msg, shop_choices, 1, 3)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			repeated = true
			if result == 1 then
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Swap_Choose']))
				state = 1
			elseif result == 2 then
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Swap_Info_001']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Swap_Info_002']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Swap_Info_003']))
			else
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Swap_Goodbye']))
				state = -1
			end
		elseif state == 1 then
			--only show the items that can be swapped for, checking inv, held, and storage
			--allow trade from storage, and find a way around multi-select for storage.
			UI:SwapMenu(catalog, Prices)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			if result > -1 then
				cart = result
				state = 2
			else
				state = 0
			end
		elseif state == 2 then
			local trade = catalog[cart]
			local receive_item = RogueEssence.Dungeon.InvItem(trade.Item)
			local free_slots = 0
			tribute = {}
			for ii = 1, #trade.ReqItem, 1 do
				if trade.ReqItem[ii] == -1 then
					free_slots = free_slots + 1
				else
					table.insert(tribute, trade.ReqItem[ii])
				end
			end
			
			if free_slots > 0 then
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Swap_Give_Choose'], receive_item:GetDisplayName()))
				--tribute simply aggregates all items period
				--this means that choosing multiple of one item will be impossible
				--must choose all DIFFERENT specific items
				UI:TributeMenu(free_slots)
				UI:WaitForChoice()
				local result = UI:ChoiceResult()
				if #result > 0 then
					for ii = 1, #result, 1 do
						table.insert(tribute, result[ii])
					end
					state = 3
				else
					state = 0
				end
			else
				state = 3
			end
		elseif state == 3 then
			local trade = catalog[cart]
			local receive_item = RogueEssence.Dungeon.InvItem(trade.Item)
			local give_items = {}
			for ii = 1, #tribute, 1 do
				local give_item = RogueEssence.Dungeon.InvItem(tribute[ii])
				table.insert(give_items, give_item:GetDisplayName())
			end
			
			local itemEntry = RogueEssence.Data.DataManager.Instance:GetItem(trade.Item)
			local total = Prices[itemEntry.Rarity]
			
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Swap_Confirm_001'], STRINGS:CreateList(give_items), receive_item:GetDisplayName()))
			UI:ChoiceMenuYesNo(STRINGS:Format(MapStrings['Swap_Confirm_002'], total), false)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			
			if result then
				for ii = #tribute, 1, -1 do
					local item_slot = GAME:FindPlayerItem(tribute[ii], true, true)
					if not item_slot:IsValid() then
						--it is a certainty that there is an item in storage, due to previous checks
						GAME:TakePlayerStorageItem(tribute[ii])
					elseif item_slot.IsEquipped then
						GAME:TakePlayerEquippedItem(item_slot.Slot)
					else
						GAME:TakePlayerBagItem(item_slot.Slot)
					end
				end
				SOUND:PlayBattleSE("DUN_Money")
				GAME:RemoveFromPlayerMoney(total)
				
				UI:SetSpeakerEmotion("Angry")
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Swap_Complete_001']))
				UI:SetSpeakerEmotion("Stunned")
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Swap_Complete_002']))
				UI:SetSpeakerEmotion("Normal")
				
				UI:ResetSpeaker()
				SOUND:PlayFanfare("Fanfare/Treasure")
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Swap_Give'], player:GetDisplayName(), receive_item:GetDisplayName()))
				
				--local bag_count = GAME:GetPlayerBagCount()
				--local bag_cap = GAME:GetPlayerBagLimit()
				--if bag_count < bag_cap then
				--	GAME:GivePlayerItem(trade.Item, 1, false, 0)
				--else--TODO: load universal strings alongside local strings
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Item_Give_Storage'], receive_item:GetDisplayName()))
				GAME:GivePlayerStorageItem(trade.Item, 1, false, 0)
				--end
				
				UI:SetSpeaker(chara)
				tribute = {}
				cart = {}
				state = 0
			else
				state = 1
			end
		end
	end
end

function metano_town.Tutor_Sequence(member, moveEntry)
	--Does the animation + flash whenever slowpoke helps you remember/forget a move
	local chara = CH('Tutor_Owner')
	GAME:WaitFrames(10)
	GROUND:CharSetAnim(chara, "Strike", false)
	GAME:WaitFrames(15)
	local emitter = RogueEssence.Content.FlashEmitter()
	emitter.FadeInTime = 2
	emitter.HoldTime = 4
	emitter.FadeOutTime = 2
	emitter.StartColor = Color(0, 0, 0, 0)
	emitter.Layer = DrawLayer.Top
	emitter.Anim = RogueEssence.Content.BGAnimData("White", 0)
	GROUND:PlayVFX(emitter, chara.MapLoc.X, chara.MapLoc.Y)
	SOUND:PlayBattleSE("EVT_Battle_Flash")
	GAME:WaitFrames(10)
	GROUND:CharSetAnim(chara, "Idle", true)
	GAME:WaitFrames(30)
end

function metano_town.Tutor_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  
  local price = 500
  local state = 0
  local repeated = false
  local member = nil
  local move = -1
  local chara = CH('Tutor_Owner')
  UI:SetSpeaker(chara)
  
	while state > -1 do
		if state == 0 then
			local msg = STRINGS:Format(MapStrings['Tutor_Intro'])
			if repeated == true then
				msg = STRINGS:Format(MapStrings['Tutor_Intro_Return'])
			end
			
			local tutor_choices = {RogueEssence.StringKey("MENU_RECALL_SKILL"):ToLocal(),
			RogueEssence.StringKey("MENU_FORGET_SKILL"):ToLocal(),
			STRINGS:FormatKey("MENU_INFO"),
			STRINGS:FormatKey("MENU_EXIT")}
			UI:BeginChoiceMenu(msg, tutor_choices, 1, 4)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			repeated = true
			if result == 1 then
				if price > GAME:GetPlayerMoney() then
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['Tutor_No_Money']))
				else
					state = 1
				end
			elseif result == 2 then
				state = 4
			elseif result == 3 then
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Tutor_Info_001']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Tutor_Info_002']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Tutor_Info_003']))
			else
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Tutor_Goodbye']))
				state = -1
			end
		elseif state == 1 then
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Tutor_Remember_Who']))
			UI:TutorTeamMenu()
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			if result > -1 then
				state = 2
				member = GAME:GetPlayerPartyMember(result)
			else
				state = 0
			end
		elseif state == 2 then
			if not GAME:CanRelearn(member) then
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Tutor_Cant_Remember']))
				state = 1
			else
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Tutor_Remember_What'], member.BaseName))
				UI:RelearnMenu(member)
				UI:WaitForChoice()
				local result = UI:ChoiceResult()
				if result > -1 then
					move = result
					state = 3
				else
					state = 1
				end
			end
		elseif state == 3 then
			local moveEntry = RogueEssence.Data.DataManager.Instance:GetSkill(move)
			if GAME:CanLearn(member) then
				SOUND:PlayBattleSE("DUN_Money")
				GAME:RemoveFromPlayerMoney(price)
				GAME:LearnSkill(member, move)
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Tutor_Remember_Begin']))
				metano_town.Tutor_Sequence()	
				SOUND:PlayBattleSE("DUN_Learn_Move")
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Tutor_Remember_Success'], member.BaseName, moveEntry.Name:ToLocal()))				state = 0
			else
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Tutor_Remember_Replace']))
				local result = UI:LearnMenu(member, move)
				UI:WaitForChoice()
				local result = UI:ChoiceResult()
				if result > -1 and result < 4 then
					SOUND:PlayBattleSE("DUN_Money")
					GAME:RemoveFromPlayerMoney(price)
					GAME:SetCharacterSkill(member, move, result)
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['Tutor_Remember_Begin']))
					metano_town.Tutor_Sequence()	
					SOUND:PlayBattleSE("DUN_Learn_Move")
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['Tutor_Remember_Success'], member.BaseName, moveEntry.Name:ToLocal()))					state = 0
				else
					state = 2
				end
			end
		elseif state == 4 then
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Tutor_Forget_Who']))
			UI:TutorTeamMenu()
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			if result > -1 then
				member = GAME:GetPlayerPartyMember(result)
				if not GAME:CanForget(member) then
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['Tutor_Cant_Forget']))
				else
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['Tutor_Forget_What'], member.BaseName))
					state = 5
				end
			else
				state = 0
			end
		elseif state == 5 then
			local result = UI:ForgetMenu(member)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			if result > -1 then
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Tutor_Forget_Begin']))
				metano_town.Tutor_Sequence()
				move = GAME:GetCharacterSkill(member, result)
				local moveEntry = RogueEssence.Data.DataManager.Instance:GetSkill(move)
				GAME:ForgetSkill(member, result)
				SOUND:PlayBattleSE("DUN_Learn_Move")
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Tutor_Forget_Success'], member.BaseName, moveEntry.Name:ToLocal()))
				state = 0
			else
				state = 4
			end
		end
	end
end



function metano_town.Appraisal_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  
  local state = 0
  local repeated = false
  local cart = {}
  local price = 150
  local chara = CH('Appraisal')
  UI:SetSpeaker(chara)
	while state > -1 do
		if state == 0 then
			local msg = STRINGS:Format(MapStrings['Appraisal_Intro'])
			if repeated == true then
				msg = STRINGS:Format(MapStrings['Appraisal_Return'])
			end
			local shop_choices = {STRINGS:Format(MapStrings['Appraisal_Option_Open']),
			STRINGS:FormatKey("MENU_INFO"),
			STRINGS:FormatKey("MENU_EXIT")}
			UI:BeginChoiceMenu(msg, shop_choices, 1, 3)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			repeated = true
			if result == 1 then
				local bag_count = GAME:GetPlayerBagCount()
				if bag_count > 0 then
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['Appraisal_Choose'], "A"))
					state = 1
				else
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['Appraisal_Bag_Empty']))
				end
			elseif result == 2 then
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Appraisal_Info_001']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Appraisal_Info_002']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Appraisal_Info_003']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Appraisal_Info_004']))
			else
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Appraisal_Goodbye']))
				state = -1
			end
		elseif state == 1 then
			UI:AppraiseMenu()
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			
			if #result > 0 then
				cart = result
				state = 2
			else
				state = 0
			end
		elseif state == 2 then
			local total = #cart * price
			
			if total > GAME:GetPlayerMoney() then
				UI:SetSpeakerEmotion('Angry')
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Appraisal_No_Money']))
				UI:SetSpeakerEmotion('Normal')
				state = 1
			else
				local msg
				if #cart == 1 then
					local item
					if cart[1].IsEquipped then
						item = GAME:GetPlayerEquippedItem(cart[1].Slot)
					else
						item = GAME:GetPlayerBagItem(cart[1].Slot)
					end
					msg = STRINGS:Format(MapStrings['Appraisal_Choose_One'], total, item:GetDisplayName())
				else
					msg = STRINGS:Format(MapStrings['Appraisal_Choose_Multi'], total)
				end
				UI:ChoiceMenuYesNo(msg, false)
				UI:WaitForChoice()
				result = UI:ChoiceResult()
				
				local treasure = {}
				if result then
					for ii = #cart, 1, -1 do
						local box = nil
						local stack = 0
						if cart[ii].IsEquipped then
							box = GAME:GetPlayerEquippedItem(cart[ii].Slot)
							GAME:TakePlayerEquippedItem(cart[ii].Slot)
						else
							box = GAME:GetPlayerBagItem(cart[ii].Slot)
							GAME:TakePlayerBagItem(cart[ii].Slot)
						end
						
						local itemEntry = RogueEssence.Data.DataManager.Instance:GetItem(box.HiddenValue)
						local treasure_choice = { Box = box, Item = RogueEssence.Dungeon.InvItem(box.HiddenValue,false,itemEntry.MaxStack)}
						table.insert(treasure, treasure_choice)
					end
					SOUND:PlayBattleSE("DUN_Money")
					GAME:RemoveFromPlayerMoney(total)
					cart = {}
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['Appraisal_Start']))
					
					--Sneasel should ready himself, then scratch once for each box he has to open
				
					
					GROUND:CharAnimateTurnTo(chara, Direction.Up, 5)
					GROUND:CharSetAnim(chara, 'Charge', true)
					GAME:WaitFrames(60)
					
					--Do a fury swipes for each box we gotta open
					for i=1,(total / price),1
					do
						GROUND:CharSetAnim(chara, 'MultiScratch', false)
						SOUND:PlayBattleSE('DUN_Fury_Swipes')
						GAME:WaitFrames(30)
					end
						
					GROUND:CharAnimateTurnTo(chara, Direction.Down, 5)
					GAME:WaitFrames(10)
					
					SOUND:PlayFanfare("Fanfare/Treasure")
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['Appraisal_End']))
					UI:SpoilsMenu(treasure)
					UI:WaitForChoice()
					
					for ii = 1, #treasure, 1 do
						local item = treasure[ii].Item
						GAME:GivePlayerItem(item.ID, 1, false, item.HiddenValue)
					end
					
					state = 0
				else
					state = 1
				end
			end
		end
	end
end








--------------------
-- Town NPCs
--------------------

--[[
Generic town NPCs to be handled on a per chapter basis, as what they say and do will change between chapters.
The list of non-shop NPCs that live in the town are:

Floatzel
Quagsire
Wooper Boy (Dee)
Wooper Girl (Dun)

???
Manetric
Electrike

Machamp
Medicham
Meditite

???
Magmortar
Magby

???
Bellossom
Gloom
Oddish

???
???
???

??? (Cave Hermit)

??? lives in a tent

??? lives in a tent

Lickitung (   , cafe goer)
???
???
???

]]--




---
--test npcs
---
function metano_town.hcox_Action(chara, activator)
	DEBUG.EnableDbgCoro()
	print('hcox action')
	local hcox = chara
	local olddir = hcox.CharDir
	GROUND:CharTurnToCharAnimated(hcox, CH('PLAYER'), 5)
	UI:SetSpeaker(hcox)
	UI:WaitShowDialogue(STRINGS:Format(MapStrings['hcox_test']))
	GROUND:CharAnimateTurnTo(chara, olddir, 5)
	
	--reset all flags
	SV.metano_town = 
	{
	  WooperIntro = false,
	  LuxioIntro = false,
	  AggronGuided = false,
	  KecIntro = false,
	  RedMerchantItem = -1,
	  RedMerchantBought = false,
	  GreenMerchantItem = -1,
	  GreenMerchantBought = false
	}

	SV.metano_cafe =
	{
		CafeSpecial = -1,
		BoughtSpecial = false
	}
	
	
end


function metano_town.free_items_Action(chara, activator)
	DEBUG.EnableDbgCoro()
	print('free items action')
	UI:SetSpeaker(chara)
	UI:WaitShowDialogue(STRINGS:Format(MapStrings['Test_Free_Items']))
	GAME:GivePlayerItem(444, GAME:GetPlayerBagLimit() - GAME:GetPlayerBagCount(), false, 2003)--that last value is a hidden value. Probably used for chests that can have multiple items inside. 2003 corresponds to Tropius hat, so these should all give Tropius hat
end


function metano_town.test_emotes_Action(chara, activator)
	DEBUG.EnableDbgCoro()
	local test_emotes = chara
	UI:SetSpeaker(test_emotes)
	UI:WaitShowDialogue(STRINGS:Format(MapStrings['NPC_Emote_Test_1']))
	UI:SetSpeakerEmotion('Happy')
	UI:WaitShowDialogue(STRINGS:Format(MapStrings['NPC_Emote_Test_2']))
	UI:SetSpeakerEmotion('Pain')
	UI:WaitShowDialogue(STRINGS:Format(MapStrings['NPC_Emote_Test_2']))
	UI:SetSpeakerEmotion('Angry')
	UI:WaitShowDialogue(STRINGS:Format(MapStrings['NPC_Emote_Test_2']))
	UI:SetSpeakerEmotion('Worried')
	UI:WaitShowDialogue(STRINGS:Format(MapStrings['NPC_Emote_Test_2']))
	UI:SetSpeakerEmotion('Sad')
	UI:WaitShowDialogue(STRINGS:Format(MapStrings['NPC_Emote_Test_2']))
	UI:SetSpeakerEmotion('Crying')
	UI:WaitShowDialogue(STRINGS:Format(MapStrings['NPC_Emote_Test_2']))
	UI:SetSpeakerEmotion('Shouting')
	UI:WaitShowDialogue(STRINGS:Format(MapStrings['NPC_Emote_Test_2']))
	UI:SetSpeakerEmotion('Teary-Eyed')
	UI:WaitShowDialogue(STRINGS:Format(MapStrings['NPC_Emote_Test_2']))
	UI:SetSpeakerEmotion('Determined')
	UI:WaitShowDialogue(STRINGS:Format(MapStrings['NPC_Emote_Test_2']))
	UI:SetSpeakerEmotion('Joyous')
	UI:WaitShowDialogue(STRINGS:Format(MapStrings['NPC_Emote_Test_2']))
	UI:SetSpeakerEmotion('Inspired')
	UI:WaitShowDialogue(STRINGS:Format(MapStrings['NPC_Emote_Test_2']))
	UI:SetSpeakerEmotion('Surprised')
	UI:WaitShowDialogue(STRINGS:Format(MapStrings['NPC_Emote_Test_2']))
	UI:SetSpeakerEmotion('Dizzy')
	UI:WaitShowDialogue(STRINGS:Format(MapStrings['NPC_Emote_Test_2']))
	UI:SetSpeakerEmotion('Sigh')
	UI:WaitShowDialogue(STRINGS:Format(MapStrings['NPC_Emote_Test_2']))
	UI:SetSpeakerEmotion('Stunned')
	UI:WaitShowDialogue(STRINGS:Format(MapStrings['NPC_Emote_Test_2']))
end


function metano_town.cutscene_test_Action(chara, activator)
	UI:SetSpeaker(chara)
	UI:WaitShowDialogue(STRINGS:Format(MapStrings['Test_Intro_Cutscene']))
	metano_town.Intro_Cutscene()
end 
------------------------------
-- Cutscenes 
------------------------------

--Pans the camera around the town to show off the town
function metano_town.Intro_Cutscene()

    local player = CH('PLAYER')
	local partner = CH('Teammate1')
	--local dummy = CH('PLAYER') --probably a better way to do it that doesn't require a useless dummy var for the activator for the task	
	GAME:FadeOut(false, 1)
	GROUND:TeleportTo(player, 704, 904, Direction.Down)
	GROUND:TeleportTo(partner, 728, 904, Direction.Down)
	GAME:MoveCamera(288, 288, 1, false)
	
	local coro = TASK:BranchCoroutine(GAME:_FadeIn(60))
	GAME:MoveCamera(288, 588, 180, false)
    TASK:JoinCoroutines({coro})

	coro = TASK:BranchCoroutine(GAME:_FadeOut(false, 60))
	GAME:MoveCamera(288, 688, 60, false)
    TASK:JoinCoroutines({coro})


	GAME:MoveCamera(168, 1080, 1, false)
		
	coro = TASK:BranchCoroutine(GAME:_FadeIn(60))
	GAME:MoveCamera(468, 1080, 180, false)
    TASK:JoinCoroutines({coro})

	
	coro = TASK:BranchCoroutine(GAME:_FadeOut(false, 60))
	GAME:MoveCamera(568, 1080, 60, false)
    TASK:JoinCoroutines({coro})
	
	
	GAME:MoveCamera(984, 1256, 1, false)
	
	coro = TASK:BranchCoroutine(GAME:_FadeIn(60))
	GAME:MoveCamera(984, 556, 420, false)
    TASK:JoinCoroutines({coro})
	
	coro = TASK:BranchCoroutine(GAME:_FadeOut(false, 60))
	GAME:MoveCamera(984, 456, 60, false)
    TASK:JoinCoroutines({coro})


	
	GAME:MoveCamera(704, 604, 1, false)
	
	coro = TASK:BranchCoroutine(GAME:_FadeIn(60))
	GAME:MoveCamera(0, 0, 180, true)
    TASK:JoinCoroutines({coro})
	
	coro = TASK:BranchCoroutine(GROUND:_CharTurnToCharAnimated(player, partner, 5))
	GROUND:CharTurnToCharAnimated(partner, player, 5)
    TASK:JoinCoroutines({coro})
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion('Normal')
	UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cutscene_Intro_Partner_1']))
	
	UI:SetSpeakerEmotion('Worried')
	UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cutscene_Intro_Partner_2']))
	
	UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cutscene_Intro_Partner_3']))

	UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cutscene_Intro_Partner_4']))
	
	UI:SetSpeakerEmotion('Normal')
	UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cutscene_Intro_Partner_5']))


	UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cutscene_Intro_Partner_6']))
	UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cutscene_Intro_Partner_7']))

	UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cutscene_Intro_Partner_8']))


end






------------------------------
--Signposts, other objects
------------------------------


function metano_town.Guild_Bridge_Sign_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  UI:ResetSpeaker()
  UI:WaitShowMonologue(STRINGS:Format(MapStrings['Sign_Guild_Bridge_1']))
end


function metano_town.Crossroads_Sign_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  UI:ResetSpeaker()
  UI:WaitShowMonologue(STRINGS:Format(MapStrings['Sign_Crossroads_1']))
  UI:WaitShowMonologue(STRINGS:Format(MapStrings['Sign_Crossroads_2']))
  UI:WaitShowMonologue(STRINGS:Format(MapStrings['Sign_Crossroads_3']))
end

function metano_town.Dojo_Sign_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  UI:ResetSpeaker()
  UI:WaitShowMonologue(STRINGS:Format(MapStrings['Sign_Dojo_1']))
end

function metano_town.To_Dungeons_Sign_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  UI:ResetSpeaker()
  UI:WaitShowMonologue(STRINGS:Format(MapStrings['Sign_To_Dungeons_1']))
end

function metano_town.Wishing_Well_Sign_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  UI:ResetSpeaker()
  UI:WaitShowMonologue(STRINGS:Format(MapStrings['Sign_Wishing_Well_1']))
end

function metano_town.To_Spring_Sign_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  UI:ResetSpeaker()
  UI:WaitShowMonologue(STRINGS:Format(MapStrings['Sign_To_Spring_1']))
end


--Change this to a little cutscene like how chimecho comes out to see you? Whoever ends up running the assmebly should come out to see you
function metano_town.Assembly_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  UI:ResetSpeaker()
  COMMON.ShowTeamAssemblyMenu(COMMON.RespawnAllies)
end

return metano_town