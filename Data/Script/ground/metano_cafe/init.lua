--[[
    init.lua
    Created: 02/07/2021 21:52:45
    Description: Autogenerated script file for the map metano_cafe.
]]--
-- Commonly included lua functions and data
require 'common'
require 'PartnerEssentials'

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
	


	local chara = CH('Teammate1')
	AI:SetCharacterAI(chara, "ai.ground_partner", CH('PLAYER'), chara.Position)
	chara.CollisionDisabled = true

end

---metano_cafe.Enter
--Engine callback function
function metano_cafe.Enter(map, time)
	DEBUG.EnableDbgCoro()
	print('Enter_metano_cafe')
	GAME:FadeIn(20)
	UI:ResetSpeaker()

end

---metano_cafe.Update
--Engine callback function
function metano_cafe.Update(map, time)
	

end

function metano_cafe.GameLoad(map)
	PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
end

function metano_cafe.GameSave(map)
	PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function metano_cafe.PlotScripting()

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
	UI:WaitShowMonologue(STRINGS:Format(MapStrings['Cafe_Sign_Intro']))

	
	while state > -1 do
		local choices = {STRINGS:Format(MapStrings['Cafe_Option_Domi']), STRINGS:Format(MapStrings['Cafe_Option_Cider']), STRINGS:FormatKey('MENU_EXIT')}
		UI:BeginChoiceMenu(STRINGS:Format(MapStrings['Cafe_Sign_Which_Drinks']), choices, 1, 3)
		UI:WaitForChoice()
		local result = UI:ChoiceResult()
		if result == 1 then
			UI:WaitShowMonologue(STRINGS:Format(MapStrings['Cafe_Sign_Domi_1']))
			UI:WaitShowMonologue(STRINGS:Format(MapStrings['Cafe_Sign_Domi_2']))
		elseif result == 2 then
			UI:WaitShowMonologue(STRINGS:Format(MapStrings['Cafe_Sign_Cider_1']))
			UI:WaitShowMonologue(STRINGS:Format(MapStrings['Cafe_Sign_Cider_2']))		
		else 
			state = -1
		end
	end
	
end




function metano_cafe.Cafe_Action(obj, activator)
	DEBUG.EnableDbgCoro()
	print("Cafe action")
	
	local state = 0
	local repeated = false
	
	--list of ~100 items, a random one is taken for new day to be sold as the cafe's special. entries show up multiple times if they're more common
	local specials_catalog  = 
	{
		2, 2, 2, 2, 2,  --big apples
		3, 3, 3, 3, 3,  --huge apples
		4, 				--gold apples
		5, 5, 5,        --perfect apples
		6, 6 ,6, 6, 6,  --bananas
		7, 7, 7,		--big bananas
		8, 				--golden banana
		12, 12, 12,		--lum berry
		19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, --type berries
		37, 38, 43, 44, 45, 46, 47, 48, 49, 51,  --other rare berries (enigma, starf, etc)
		72, 72, 72,     --sitrus berry
		75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, --gummis
		100, 100, 100, 100, 100, --plain seeds
		101, 101, 101, 101,  --rev seed 
		102,            --joy seed
		104, 104, 104,  --doom seed 
		150, 151, 152, 153, 154, 155, 156, --nectar + vitamins
		183, 184, 185  --mental, power, white herb
	}
	
	-- special is -1 if nothing has been selected as the daily special. It should be set back to -1 when a new day happens
	--but more ideally it should just be reinitialized when a new day happens. I just need to figure out how to do that properly
	if SV.metano_cafe.CafeSpecial == -1 then 
		SV.metano_cafe.CafeSpecial = GAME.Rand:Next(1, #specials_catalog)
	end
	
	local special = RogueEssence.Dungeon.InvItem(specials_catalog[SV.metano_cafe.CafeSpecial])
	local specialName = special:GetDisplayName()
	local specialPrice = special:GetSellValue()
	UI:SetSpeaker(CH('Cafe_Owner'))
	
	
	--he has a fermented item to give you
	if SV.metano_cafe.FermentedItem ~= -1 and SV.metano_cafe.ItemFinishedFermenting then
		local juice = RogueEssence.Dungeon.InvItem(SV.metano_cafe.FermentedItem)
		local juiceEntry = RogueEssence.Data.DataManager.Instance:GetItem(juice.ID)
		UI:SetSpeakerEmotion('Normal')
		UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Fermented_Give_Item'], juice:GetDisplayName()))
		if GAME:GetPlayerBagCount() == GAME:GetPlayerBagLimit() then
			UI:SetSpeakerEmotion('Worried')
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Bag_Full']))
			state = -1 --don't go to normal dialogue if he cant give you the fermented item.
		else
			GAME:GivePlayerItem(juice.ID, 1, false, juiceEntry.MaxStack)
			SV.metano_cafe.FermentedItem = -1
			SV.metano_cafe.ItemFinishedFermenting = false
			SOUND:PlayBattleSE("DUN_Drink")
			UI:WaitShowMonologue(STRINGS:Format(MapStrings['Cafe_Fermented_Item_Received'], juice:GetDisplayName()))
		end			
	end
	
	
	
	
	
	--Give player free Apple Cider if they're preparing for the Expedition
	if SV.metano_cafe.ExpeditionPreparation and not SV.metano_cafe.GaveFreeExpeditionItem and state > - 1 then
		UI:SetSpeakerEmotion('Normal')
		UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Expedition_Item_Intro_1']))
		UI:SetSpeakerEmotion('Happy')
		UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Expedition_Item_Intro_2']))
		UI:SetSpeakerEmotion('Normal')
		if GAME:GetPlayerBagCount() == GAME:GetPlayerBagLimit() then
			UI:SetSpeakerEmotion('Worried')
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Bag_Full']))
			state = -1 --don't go to normal dialogue if he cant give you the fermented item.
		else
			SV.metano_cafe.GaveFreeExpeditionItem = true
			GAME:GivePlayerItem(2501, 1, false, 4)--apple cider 
			SOUND:PlayBattleSE("DUN_Drink")
			local cider = RogueEssence.Dungeon.InvItem(2501, false, 4)--Apple Cider
			UI:WaitShowMonologue(STRINGS:Format(MapStrings['Cafe_Fermented_Item_Received'], cider:GetDisplayName()))
		end			
	end
	
	
	
	
	
	
	
	--Normal Cafe Shop script
	while state > -1 do
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
			if SV.metano_cafe.ExpeditionPreparation then
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Expedition_Prevent_Fermenting_1']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Expedition_Prevent_Fermenting_2']))
			else
				local ferment_state = 0
				while ferment_state > -1 do
					local ferment_choices = {STRINGS:Format(MapStrings['Cafe_Option_Domi']), 
											 STRINGS:Format(MapStrings['Cafe_Option_Cider']),
											 STRINGS:FormatKey('MENU_EXIT')}
					UI:BeginChoiceMenu(STRINGS:Format(MapStrings['Cafe_Ferment_Prompt']), ferment_choices, 1, 3)
					UI:WaitForChoice()
					result = UI:ChoiceResult()
					if result == 1 then --Domi Blend
						--to do: check for ingredients, take them, set fermented item variable to Domi Blend 
					elseif result == 2 then
						--to do: check for ingredients, take them, set fermented item variable to Apple Cider 
					else
						ferment_state = -1
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
						UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Bag_Full']))
						UI:SetSpeakerEmotion('Normal')
					else
						SV.metano_cafe.BoughtSpecial = true
						GAME:RemoveFromPlayerMoney(specialPrice)
						GAME:GivePlayerItem(special.ID, 1, false, 0)
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
		else--exit
			UI:SetSpeakerEmotion("Happy")
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Cafe_Goodbye']))
			UI:SetSpeakerEmotion("Normal")
			state = -1
		end
				
				
		
	
	
	
	--elseif state == 1 then 	 shop menu for smoothies	
		
		
	end	
end



function metano_cafe.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  COMMON.GroundInteract(activator, chara, true)
end



return metano_cafe

