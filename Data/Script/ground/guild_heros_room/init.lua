--[[
    init.lua
    Created: 06/28/2021 23:00:22
    Description: Autogenerated script file for the map guild_heros_room.
]]--
-- Commonly included lua functions and data
require 'common'
require 'PartnerEssentials'
require 'ground.guild_heros_room.guild_heros_room_ch_1'

-- Package name
local guild_heros_room = {}

-- Local, localized strings table
-- Use this to display the named strings you added in the strings files for the map!
-- Ex:
--      local localizedstring = MapStrings['SomeStringName']
local MapStrings = {}

-------------------------------
-- Map Callbacks
-------------------------------
---guild_heros_room.Init
--Engine callback function
function guild_heros_room.Init(map)
	DEBUG.EnableDbgCoro()
	print('=>> Init_guild_heros_room<<=')
	MapStrings = COMMON.AutoLoadLocalizedStrings()
	COMMON.RespawnAllies()
	PartnerEssentials.InitializePartnerSpawn()

end

---guild_heros_room.Enter
--Engine callback function
function guild_heros_room.Enter(map)

	if SV.ChapterProgression.Chapter == 1 then
		if SV.Chapter1.TeamCompletedForest and not SV.Chapter1.TeamJoinedGuild then
			guild_heros_room_ch_1.RoomIntro()
		else
			guild_heros_room_ch_1.SetupGround()
		end		
	else	
		GAME:FadeIn(20)
	end
end

---guild_heros_room.Exit
--Engine callback function
function guild_heros_room.Exit(map)


end

---guild_heros_room.Update
--Engine callback function
function guild_heros_room.Update(map)


end




---------------------------------
-- Event Trigger
-- This is a temporary object created by a script used to trigger events that only happen
-- once, typically a cutscene of sorts for a particular chapter.
---------------------------------
function guild_heros_room.Event_Trigger_1_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("guild_heros_room_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Event_Trigger_1_Touch(...,...)"), obj, activator))
end











------------------------------------
--Special Functions
------------------------------------
function guild_heros_room.Bedtime(generic)
--if generic is true, do a generic nighttime cutscene and relevant processing. 
--if generic is false, just make the room look like it's night and put the duo in bed.
	if generic == nil then generic = false end
	
	if not generic then 
		local groundObj = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Night_Window", 1, 0, 0), 
														RogueElements.Rect(176, 56, 64, 64),
														RogueElements.Loc(0, 0), 
														false, 
														"Window")
		groundObj:ReloadEvents()
		GAME:GetCurrentGround():AddObject(groundObj)
		GROUND:AddMapStatus(50)
		
		local hero_bed = MRKR('Hero_Bed')
		local partner_bed = MRKR('Partner_Bed')
		GROUND:TeleportTo(CH('PLAYER'), hero_bed.Position.X, hero_bed.Position.Y, Direction.Down)
		GROUND:TeleportTo(CH('Teammate1'), partner_bed.Position.X, partner_bed.Position.Y, Direction.Down)
	 
	end
	--todo: generic 

end


function guild_heros_room.Save_Point_Touch(obj, activator)
	GeneralFunctions.PromptSaveAndQuit()
end


-------------------------------
-- Entities Callbacks
-------------------------------
function guild_heros_room.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

---------------------------
-- Map Transitions
---------------------------
function guild_heros_room.Bedroom_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("guild_bedroom_hallway", "Guild_Bedroom_Hallway_Right_Marker")
  SV.partner.Spawn = 'Guild_Bedroom_Hallway_Right_Marker_Partner'
end

return guild_heros_room

