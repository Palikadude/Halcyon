--[[
    init.lua
    Created: 03/21/2021 22:07:39
    Description: Autogenerated script file for the map metano_grass_home.
]]--
-- Commonly included lua functions and data
require 'common'
require 'PartnerEssentials'
require 'ground.metano_grass_home.metano_grass_home_ch_2'
require 'ground.metano_grass_home.metano_grass_home_ch_3'
require 'ground.metano_grass_home.metano_grass_home_ch_4'

-- Package name
local metano_grass_home = {}

-- Local, localized strings table
-- Use this to display the named strings you added in the strings files for the map!
-- Ex:
--      local localizedstring = MapStrings['SomeStringName']
local MapStrings = {}

-------------------------------
-- Map Callbacks
-------------------------------
---metano_grass_home.Init
--Engine callback function
function metano_grass_home.Init(map, time)

	DEBUG.EnableDbgCoro()
	print('=>> Init_metano_grass_home <<=')
	MapStrings = COMMON.AutoLoadLocalizedStrings()
	COMMON.RespawnAllies()
	PartnerEssentials.InitializePartnerSpawn()
	
	if SOUND:GetCurrentSong() ~= SV.metano_town.Song then
      SOUND:PlayBGM(SV.metano_town.Song, true)
    end
end

---metano_grass_home.Enter
--Engine callback function
function metano_grass_home.Enter(map, time)

	metano_grass_home.PlotScripting()

end

---metano_grass_home.Exit
--Engine callback function
function metano_grass_home.Exit(map, time)


end

---metano_grass_home.Update
--Engine callback function
function metano_grass_home.Update(map, time)


end

function metano_grass_home.GameLoad(map)
	PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
	metano_grass_home.PlotScripting()
end

function metano_grass_home.GameSave(map)
	PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end


function metano_grass_home.PlotScripting()
	if SV.ChapterProgression.Chapter == 2 then 
		metano_grass_home_ch_2.SetupGround()
	elseif SV.ChapterProgression.Chapter == 3 then 
		metano_grass_home_ch_3.SetupGround()	
	elseif SV.ChapterProgression.Chapter == 4 then 
		metano_grass_home_ch_4.SetupGround()
	else
		GAME:FadeIn(20)
	end
end

-------------------------------
-- Map Transitions
-------------------------------

function metano_grass_home.Grass_Home_Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap("metano_town", "Grass_Home_Entrance_Marker", true)
  SV.partner.Spawn = 'Grass_Home_Entrance_Marker_Partner'
end



------------------
--NPCS 
----------------
function metano_grass_home.Vileplume_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  assert(pcall(load("metano_grass_home_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Vileplume_Action(...,...)"), chara, activator))
end

function metano_grass_home.Bellossom_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  assert(pcall(load("metano_grass_home_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Bellossom_Action(...,...)"), chara, activator))
end

function metano_grass_home.Gloom_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  assert(pcall(load("metano_grass_home_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Gloom_Action(...,...)"), chara, activator))
end

function metano_grass_home.Oddish_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  assert(pcall(load("metano_grass_home_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Oddish_Action(...,...)"), chara, activator))
end


function metano_grass_home.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))end

return metano_grass_home

