--[[
    init.lua
    Created: 07/03/2022 16:01:27
    Description: Autogenerated script file for the map personality_test.
]]--
-- Commonly included lua functions and data
require 'common'

-- Package name
local personality_test = {}

-- Local, localized strings table
-- Use this to display the named strings you added in the strings files for the map!
-- Ex:
--      local localizedstring = MapStrings['SomeStringName']
local MapStrings = {}

-------------------------------
-- Map Callbacks
-------------------------------
---personality_test.Init
--Engine callback function
function personality_test.Init(map)

  --This will fill the localized strings table automatically based on the locale the game is 
  -- currently in. You can use the MapStrings table after this line!
  MapStrings = COMMON.AutoLoadLocalizedStrings()

end

---personality_test.Enter
--Engine callback function
function personality_test.Enter(map)

  GAME:FadeIn(20)

end

---personality_test.Exit
--Engine callback function
function personality_test.Exit(map)


end

---personality_test.Update
--Engine callback function
function personality_test.Update(map)


end

---personality_test.GameSave
--Engine callback function
function personality_test.GameSave(map)


end

---personality_test.GameLoad
--Engine callback function
function personality_test.GameLoad(map)

  GAME:FadeIn(20)

end

-------------------------------
-- Entities Callbacks
-------------------------------


return personality_test
