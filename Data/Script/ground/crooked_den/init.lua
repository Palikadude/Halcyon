--[[
    init.lua
    Created: 08/09/2022 17:51:31
    Description: Autogenerated script file for the map crooked_den.
]]--
-- Commonly included lua functions and data
-- Commonly included lua functions and data
require 'common'
require 'PartnerEssentials'
require 'ground.crooked_den.crooked_den_ch_3'

-- Package name
local crooked_den = {}

-- Local, localized strings table
-- Use this to display the named strings you added in the strings files for the map!
-- Ex:
--      local localizedstring = MapStrings['SomeStringName']
local MapStrings = {}

-------------------------------
-- Map Callbacks
-------------------------------
---crooked_den.Init
--Engine callback function
function crooked_den.Init(map, time)

	DEBUG.EnableDbgCoro()
	print('=>> Init_crooked_den <<=')
	MapStrings = COMMON.AutoLoadLocalizedStrings()
	COMMON.RespawnAllies()
	PartnerEssentials.InitializePartnerSpawn()
end

---crooked_den.Enter
--Engine callback function
function crooked_den.Enter(map, time)

	crooked_den.PlotScripting()

end

---crooked_den.Exit
--Engine callback function
function crooked_den.Exit(map, time)


end

---crooked_den.Update
--Engine callback function
function crooked_den.Update(map, time)


end

function crooked_den.GameLoad(map)
	PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
	crooked_den.PlotScripting()
end

function crooked_den.GameSave(map)
	PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end


function crooked_den.PlotScripting()
	if SV.ChapterProgression.Chapter == 3 then 
		if not SV.Chapter3.EnteredCavern then
			crooked_den_ch_3.FirstAttemptCutscene()
		elseif not SV.Chapter3.EncounteredBoss then
			crooked_den_ch_3.LostBeforeStyle()
		else 
			crooked_den_ch_3.LostToStyle()
		end
	else
		GAME:FadeIn(20)
	end
end





function crooked_den.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
 end

return crooked_den




