--[[
    init.lua
    Created: 12/17/2023 23:06:04
    Description: Autogenerated script file for the map vast_steppe_entrance.
]]--
-- Commonly included lua functions and data
require 'common'

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

  --This will fill the localized strings table automatically based on the locale the game is 
  -- currently in. You can use the MapStrings table after this line!
  MapStrings = COMMON.AutoLoadLocalizedStrings()

end

---vast_steppe_entrance.Enter(map)
--Engine callback function
function vast_steppe_entrance.Enter(map)

  GAME:FadeIn(20)

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


end

---vast_steppe_entrance.GameLoad(map)
--Engine callback function
function vast_steppe_entrance.GameLoad(map)

  GAME:FadeIn(20)

end

-------------------------------
-- Entities Callbacks
-------------------------------


return vast_steppe_entrance

