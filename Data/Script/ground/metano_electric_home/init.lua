--[[
    init.lua
    Created: 03/21/2021 22:07:39
    Description: Autogenerated script file for the map metano_electric_home.
]]--
-- Commonly included lua functions and data
require 'common'
require 'PartnerEssentials'
require 'ground.metano_electric_home.metano_electric_home_ch_2'
require 'ground.metano_electric_home.metano_electric_home_ch_3'

-- Package name
local metano_electric_home = {}

-- Local, localized strings table
-- Use this to display the named strings you added in the strings files for the map!
-- Ex:
--      local localizedstring = MapStrings['SomeStringName']
local MapStrings = {}

-------------------------------
-- Map Callbacks
-------------------------------
---metano_electric_home.Init
--Engine callback function
function metano_electric_home.Init(map, time)
	DEBUG.EnableDbgCoro()
	print('=>> Init_metano_electric_home <<=')
	MapStrings = COMMON.AutoLoadLocalizedStrings()
	COMMON.RespawnAllies()
	PartnerEssentials.InitializePartnerSpawn()
    
	if SOUND:GetCurrentSong() ~= SV.metano_town.Song then
      SOUND:PlayBGM(SV.metano_town.Song, true)
    end
end

---metano_electric_home.Enter
--Engine callback function
function metano_electric_home.Enter(map, time)
	metano_electric_home.PlotScripting()

end

---metano_electric_home.Exit
--Engine callback function
function metano_electric_home.Exit(map, time)


end

---metano_electric_home.Update
--Engine callback function
function metano_electric_home.Update(map, time)


end

function metano_electric_home.GameLoad(map)
	PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
	metano_electric_home.PlotScripting()
end

function metano_electric_home.GameSave(map)
	PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end


function metano_electric_home.PlotScripting()
	if SV.ChapterProgression.Chapter == 2 then 
		metano_electric_home_ch_2.SetupGround()
	elseif SV.ChapterProgression.Chapter == 3 then 
		metano_electric_home_ch_3.SetupGround()
	else
		GAME:FadeIn(20)
	end
end


-------------------------------
-- Map Transitions
-------------------------------

function metano_electric_home.Electric_Home_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("metano_town", "Electric_Home_Entrance_Marker")
  SV.partner.Spawn = 'Electric_Home_Entrance_Marker_Partner'
end



------------------
--NPCS 
----------------
function metano_electric_home.Electrike_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  assert(pcall(load("metano_electric_home_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Electrike_Action(...,...)"), chara, activator))
end

function metano_electric_home.Luxray_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  assert(pcall(load("metano_electric_home_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Luxray_Action(...,...)"), chara, activator))
end

function metano_electric_home.Manectric_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  assert(pcall(load("metano_electric_home_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Manectric_Action(...,...)"), chara, activator))
end





function metano_electric_home.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))end

return metano_electric_home

