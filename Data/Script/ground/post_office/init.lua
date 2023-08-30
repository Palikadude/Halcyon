require 'common'
require 'GeneralFunctions'
require 'PartnerEssentials'

local post_office = {}
local MapStrings = {}
--------------------------------------------------
-- Map Callbacks
--------------------------------------------------
function post_office.Init(map)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> Init_post_office")
  MapStrings = COMMON.AutoLoadLocalizedStrings()
  COMMON.RespawnAllies()
  PartnerEssentials.InitializePartnerSpawn()
  
  if SOUND:GetCurrentSong() ~= SV.metano_town.Song then
    SOUND:PlayBGM(SV.metano_town.Song, true)
  end
  
--Remove nicknames from characters if the nickname mod is enabled.
  if CONFIG.UseNicknames then
	CH('Connect_Owner').Data.Nickname = CharacterEssentials.GetCharacterName('Pelipper_Connect')
	CH('Rescue_Owner').Data.Nickname = CharacterEssentials.GetCharacterName('Pelipper_Rescue')
  else 
	CH('Connect_Owner').Data.Nickname = 'Pelipper'
	CH('Rescue_Owner').Data.Nickname = 'Pelipper'
  end

	
end

function post_office.Enter(map)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  
  post_office.PlotScripting()
  --[[
  local rescue = SV.General.Rescue

  if rescue ~= nil then
    local chara = CH('Rescue_Owner')
	UI:SetSpeaker(chara)
	local result = SV.General.Rescue
	SV.General.Rescue = nil
	if result == RogueEssence.Data.GameProgress.ResultType.Rescue then
		UI:WaitShowDialogue(STRINGS:Format(MapStrings['Rescue_Return_Success_001']))
		local remark_choices =
		{ 
		  "It was fun!",
		  "It was too difficult!",
		  "All in a day's work.",
		  "You can do it!",
		  "You're welcome!",
		  "Never again...",
		  "Be careful.",
		  "We've got your back.",
		  "Don't forget my reward!"
		}
		local filtered_choices = { }
		local filtered_idx = { }
		for ii = 1, 4, 1 do
			local idx = math.random(1, #remark_choices)
			table.insert(filtered_choices, remark_choices[idx])
			table.insert(filtered_idx, idx)
			table.remove(remark_choices, idx)
		end
		
		--UI:BeginChoiceMenu(STRINGS:Format(MapStrings['Rescue_Return_Success_002']), --remark_choices, 1, 1)
		--UI:WaitForChoice()
		--local choice = UI:ChoiceResult()
		--GAME:AddAOKRemark(filtered_idx[choice]-1)
		UI:WaitShowDialogue(STRINGS:Format(MapStrings['Rescue_Return_Success_003']))
		UI:WaitShowDialogue(STRINGS:Format(MapStrings['Rescue_Return_Success_004']))
	elseif result == RogueEssence.Data.GameProgress.ResultType.Cleared or result == RogueEssence.Data.GameProgress.ResultType.Escaped then
		UI:WaitShowDialogue(STRINGS:Format(MapStrings['Rescue_Return_Miss_001']))
		UI:WaitShowDialogue(STRINGS:Format(MapStrings['Rescue_Return_Miss_002']))
		UI:WaitShowDialogue(STRINGS:Format(MapStrings['Rescue_Return_Miss_003']))
	else
		UI:WaitShowDialogue(STRINGS:Format(MapStrings['Rescue_Return_Fail_001']))
		UI:WaitShowDialogue(STRINGS:Format(MapStrings['Rescue_Return_Fail_002']))
	end
	
    GAME:WaitFrames(1);
  end
  ]]--
end

function post_office.Update(map, time)
end

function post_office.GameLoad(map)
	PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
	post_office.PlotScripting()
end

function post_office.GameSave(map)
	PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function post_office.PlotScripting()
	GAME:FadeIn(20)
end
--------------------------------------------------
-- Map Begin Functions
--------------------------------------------------

--------------------------------------------------
-- Objects Callbacks
--------------------------------------------------
function post_office.South_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("metano_town", "Post_Office_Entrance_Marker", true)
  SV.partner.Spawn = 'Post_Office_Entrance_Marker_Partner'
end


function post_office.Main_Desk_Action(obj, activator)
	local chara = CH('Connect_Owner')
	GeneralFunctions.StartConversation(chara, "We are still getting set up in here.[pause=0] Please come back again in a later version!")
	GeneralFunctions.EndConversation(chara)
end 

function post_office.Side_Desk_Action(obj, activator)
	local chara = CH('Rescue_Owner')
	GeneralFunctions.StartConversation(chara, "We are still getting set up in here.[pause=0] Please come back again in a later version!")
	GeneralFunctions.EndConversation(chara)
end

--[[
function post_office.Main_Desk_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine

  --TODO: rank calc
  --Stars:
  --Complete all dungeons
  --Complete dex
  --Complete Rogue
  --Reach 100F of neverending tale
  --Reach Lv100 with founder

  local state = 0
  local repeated = false
  local chara = CH('Connect_Owner')
  UI:SetSpeaker(chara)
  
	while state > -1 do
		if state == 0 then
			local msg = STRINGS:Format(MapStrings['Connect_Intro'])
			if repeated == true then
				msg = STRINGS:Format(MapStrings['Connect_Intro_Return'])
			end
			
			local end_choice = 5
			local connect_choices = {}
			connect_choices[1] = STRINGS:Format(MapStrings['Connect_Option_Connect'])
			connect_choices[2] = STRINGS:Format(MapStrings['Connect_Option_Server'])
			-- connect_choices[3] = "Connect Peer-to-Peer"
			connect_choices[4] = STRINGS:FormatKey("MENU_INFO")
			connect_choices[5] = STRINGS:FormatKey("MENU_EXIT")
			
			UI:BeginChoiceMenu(msg, connect_choices, 1, end_choice)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			repeated = true
			if result == 1 then
				if GAME:HasServerSet() then
					state = 1
				else
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_No_Server']))
				end
			elseif result == 2 then
				UI:ServersMenu()
				UI:WaitForChoice()
			elseif result == 3 then
				state = 4
			elseif result == 4 then
				state = 7
			else
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_Goodbye']))
				state = -1
			end
		elseif state == 1 then
			UI:ContactsMenu()
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			if result == 1 then
				state = 2
			else
				state = 0
			end
		elseif state == 2 then
			UI:ShowConnectMenu()
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			if result == 1 then
				state = 3
			else
				state = 1
			end
		elseif state == 3 then
			UI:CurrentActivityMenu()
			UI:WaitForChoice()
			state = 1
		elseif state == 4 then
			UI:PeersMenu()
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			if result == 1 then
				state = 5
			else
				state = 0
			end
		elseif state == 5 then
			UI:ShowConnectMenu()
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			if result == 1 then
				state = 6
			else
				state = 4
			end
		elseif state == 6 then
			UI:CurrentActivityMenu()
			UI:WaitForChoice()
			state = 4
		elseif state == 7 then
			local end_choice = 7
			local connect_choices = {}
			connect_choices[1] = STRINGS:Format(MapStrings['Connect_Option_Friends'])
			connect_choices[2] = STRINGS:Format(MapStrings['Connect_Option_Friend_Rescue'])
			connect_choices[3] = STRINGS:Format(MapStrings['Connect_Option_Teammate'])
			connect_choices[4] = STRINGS:Format(MapStrings['Connect_Option_Treasure'])
			-- connect_choices[5] = "Mail Exchange"
			connect_choices[6] = STRINGS:Format(MapStrings['Connect_Option_Advanced'])
			connect_choices[7] = STRINGS:FormatKey("MENU_CANCEL")
			
				-- Connecting Peer-to-Peer
				-- File Rescue
				-- Hosting a Server
			
			UI:BeginChoiceMenu(STRINGS:Format(MapStrings['Connect_Info_Ask']), connect_choices, 1, end_choice)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			
			if result == 1 then
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_Info_Friends_001']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_Info_Friends_002']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_Info_Friends_003']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_Info_Friends_004']))
			elseif result == 2 then
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_Info_Rescue_001']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_Info_Rescue_002']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_Info_Rescue_003']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_Info_Rescue_004']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_Info_Rescue_005']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_Info_Rescue_006']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_Info_Rescue_007']))
			elseif result == 3 then
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_Info_Trade_Team_001']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_Info_Trade_Team_002']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_Info_Trade_Team_003']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_Info_Trade_Team_004']))
			elseif result == 4 then
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_Info_Trade_Item_001']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_Info_Trade_Item_002']))
			elseif result == 5 then
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_Info_Trade_Mail_001']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_Info_Trade_Mail_002']))
			elseif result == 6 then
				state = 8
			else
				state = 0
			end
		elseif state == 8 then
			local end_choice = 4
			local connect_choices = {}
			connect_choices[1] = STRINGS:Format(MapStrings['Connect_Option_P2P'])
			connect_choices[2] = STRINGS:Format(MapStrings['Connect_Option_File_Rescue'])
			connect_choices[3] = STRINGS:Format(MapStrings['Connect_Option_Host'])
			connect_choices[4] = STRINGS:FormatKey("MENU_CANCEL")
			
			UI:BeginChoiceMenu(STRINGS:Format(MapStrings['Connect_Info_Ask']), connect_choices, 1, end_choice)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			
			if result == 1 then
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_Info_P2P_001']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_Info_P2P_002']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_Info_P2P_003']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_Info_P2P_004']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_Info_P2P_005']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_Info_P2P_006']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_Info_P2P_007']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_Info_P2P_008']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_Info_P2P_009']))
			elseif result == 2 then
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_Info_File_Rescue_001']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_Info_File_Rescue_002']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_Info_File_Rescue_003']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_Info_File_Rescue_004']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_Info_File_Rescue_005']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_Info_File_Rescue_006']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_Info_File_Rescue_007']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_Info_File_Rescue_008']))
			elseif result == 3 then
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_Info_Server_Host_001']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_Info_Server_Host_002']))
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Connect_Info_Server_Host_003']))
			else
				state = 7
			end
		end
	end
end

function post_office.Side_Desk_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine

  local state = 0
  local sos = nil
  local repeated = false
  local chara = CH('Rescue_Owner')
  UI:SetSpeaker(chara)
  
	while state > -1 do
		if state == 0 then
			local msg = STRINGS:Format(MapStrings['Rescue_Intro'])
			if repeated == true then
				msg = STRINGS:Format(MapStrings['Rescue_Intro_Return'])
			end
			
			local connect_choices = {STRINGS:Format(MapStrings['Rescue_Option_SOS']),
			STRINGS:Format(MapStrings['Rescue_Option_AOK']),
			STRINGS:FormatKey("MENU_EXIT")}
			UI:BeginChoiceMenu(msg, connect_choices, 1, 3)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			repeated = true
			if result == 1 then
				if GAME:HasSOSMail() then
					state = 1
				else
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['Rescue_SOS_None']))
				end
			elseif result == 2 then
				if GAME:HasAOKMail() then
					UI:AOKMenu()
					UI:WaitForChoice()
				else
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['Rescue_AOK_None']))
				end
			else
				UI:WaitShowDialogue(STRINGS:Format(MapStrings['Rescue_Goodbye']))
				state = -1
			end
		elseif state == 1 then
			UI:SOSMenu()
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			if result ~= nil then
				sos = result
				state = 2
			else
				state = 0
			end
		elseif state == 2 then
			local mail = RogueEssence.Data.DataManager.LoadRescueMail(sos);
			local dungeon = RogueEssence.Data.DataManager.Instance:GetZone(mail.Goal.ID)
			UI:ChoiceMenuYesNo(STRINGS:Format(MapStrings['Rescue_Confirm'], dungeon.Name:ToLocal()), false)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			if result then
				state = -1
			else
				sos = nil
				state = 1
			end
		end
	end
	
	if sos ~= nil then
		UI:WaitShowDialogue(STRINGS:Format(MapStrings['Rescue_Begin']))
		GAME:FadeOut(false, 20)
		-- begin rescue mission
		GAME:EnterRescue(sos)
	end
end
]]--


function post_office.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

return post_office