--[[
    init.lua
    Created: 12/17/2023 23:06:04
    Description: Autogenerated script file for the map vast_steppe_entrance.
]]--
-- Commonly included lua functions and data
require 'common'
require 'PartnerEssentials'
require 'ground.vast_steppe_entrance.vast_steppe_entrance_ch_5'


-- Package name
local vast_steppe_entrance = {}

-- Local, localized strings table
-- Use this to display the named strings you added in the strings files for the map!
-- Ex:
--      local localizedstring = MapStrings['SomeStringName']
local MapStrings = {}

-------------------------------
-- Map Callbacks
-------------------------------
---vast_steppe_entrance.Init(map)
--Engine callback function
function vast_steppe_entrance.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_vast_steppe_entrance <<=')
  MapStrings = COMMON.AutoLoadLocalizedStrings()
  COMMON.RespawnAllies()
  PartnerEssentials.InitializePartnerSpawn()

end

---vast_steppe_entrance.Enter(map)
--Engine callback function
function vast_steppe_entrance.Enter(map)

  vast_steppe_entrance.PlotScripting()

end

---vast_steppe_entrance.Exit(map)
--Engine callback function
function vast_steppe_entrance.Exit(map)


end

---vast_steppe_entrance.Update(map)
--Engine callback function
function vast_steppe_entrance.Update(map)


end

---vast_steppe_entrance.GameSave(map)
--Engine callback function
function vast_steppe_entrance.GameSave(map)

	PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))

end

---vast_steppe_entrance.GameLoad(map)
--Engine callback function
function vast_steppe_entrance.GameLoad(map)
	PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
	vast_steppe_entrance.PlotScripting()
end

function vast_steppe_entrance.PlotScripting()
  GAME:FadeIn(20)
end 


-------------------------------
-- Entities Callbacks
-------------------------------
function vast_steppe_entrance.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
 end

function vast_steppe_entrance.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  COMMON.GroundInteract(activator, chara, true)
end

function vast_steppe_entrance.Teammate3_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  COMMON.GroundInteract(activator, chara, true)
end

function vast_steppe_entrance.Kangaskhan_Rock_Action(obj, activator)
	GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end


--Guild members
function vast_steppe_entrance.Tropius_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("vast_steppe_entrance_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Tropius_Action(...,...)"), obj, activator))
end

function vast_steppe_entrance.Noctowl_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("vast_steppe_entrance_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Noctowl_Action(...,...)"), obj, activator))
end

function vast_steppe_entrance.Breloom_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("vast_steppe_entrance_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Breloom_Action(...,...)"), obj, activator))
end

function vast_steppe_entrance.Girafarig_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("vast_steppe_entrance_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Girafarig_Action(...,...)"), obj, activator))
end

function vast_steppe_entrance.Growlithe_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("vast_steppe_entrance_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Growlithe_Action(...,...)"), obj, activator))
end

function vast_steppe_entrance.Zigzagoon_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("vast_steppe_entrance_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Zigzagoon_Action(...,...)"), obj, activator))
end

function vast_steppe_entrance.Snubbull_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("vast_steppe_entrance_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Snubbull_Action(...,...)"), obj, activator))
end

function vast_steppe_entrance.Audino_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("vast_steppe_entrance_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Audino_Action(...,...)"), obj, activator))
end

function vast_steppe_entrance.Cranidos_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("vast_steppe_entrance_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Cranidos_Action(...,...)"), obj, activator))
end

function vast_steppe_entrance.Mareep_Action(obj, activator)
 DEBUG.EnableDbgCoro() --Enable debugging this coroutine
 assert(pcall(load("vast_steppe_entrance_ch_" .. tostring(SV.ChapterProgression.Chapter) .. ".Mareep_Action(...,...)"), obj, activator))
end

return vast_steppe_entrance

