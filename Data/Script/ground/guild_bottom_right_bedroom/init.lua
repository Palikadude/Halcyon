--[[
    init.lua
    Created: 06/28/2021 23:00:22
    Description: Autogenerated script file for the map guild_bottom_right_bedroom.
]]--
-- Commonly included lua functions and data
require 'common'
require 'PartnerEssentials'

-- Package name
local guild_bottom_right_bedroom = {}

-- Local, localized strings table
-- Use this to display the named strings you added in the strings files for the map!
-- Ex:
--      local localizedstring = MapStrings['SomeStringName']
local MapStrings = {}

-------------------------------
-- Map Callbacks
-------------------------------
---guild_bottom_right_bedroom.Init
--Engine callback function
function guild_bottom_right_bedroom.Init(map)
	DEBUG.EnableDbgCoro()
	print('=>> Init_guild_bottom_right_bedroom<<=')
	MapStrings = COMMON.AutoLoadLocalizedStrings()
	COMMON.RespawnAllies()
	PartnerEssentials.InitializePartnerSpawn()

end

---guild_bottom_right_bedroom.Enter
--Engine callback function
function guild_bottom_right_bedroom.Enter(map)

  GAME:FadeIn(20)

end

---guild_bottom_right_bedroom.Exit
--Engine callback function
function guild_bottom_right_bedroom.Exit(map)


end

---guild_bottom_right_bedroom.Update
--Engine callback function
function guild_bottom_right_bedroom.Update(map)


end

-------------------------------
-- Entities Callbacks
-------------------------------
function guild_bottom_right_bedroom.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end


function guild_bottom_right_bedroom.Almanac_Action(chara, activator)
	UI:ResetSpeaker(false)
	UI:WaitShowDialogue("This is Almotz's almanac (along with the books/papers on the floor)")
	UI:WaitShowDialogue("But there's a lot of work that needs to go into this almanac...")
	UI:WaitShowDialogue("Which will be done at a later date.[pause=0] It'll have some lore,[pause=10] gameplay tips,[pause=10] etc.")
	UI:WaitShowDialogue("So look forward to it!")
end
---------------------------
-- Map Transitions
---------------------------
function guild_bottom_right_bedroom.Bedroom_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("guild_bedroom_hallway", "Guild_Bedroom_Hallway_Bottom_Right_Marker")
  SV.partner.Spawn = 'Guild_Bedroom_Hallway_Bottom_Right_Marker_Partner'
end

return guild_bottom_right_bedroom

