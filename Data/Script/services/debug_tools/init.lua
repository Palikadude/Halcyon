--[[
    Example Service
    
    This is an example to demonstrate how to use the BaseService class to implement a game service.
    
    **NOTE:** After declaring you service, you have to include your package inside the main.lua file!
]]--
require 'common'
require 'services.baseservice'

--Declare class DebugTools
local DebugTools = Class('DebugTools', BaseService)

--[[---------------------------------------------------------------
    DebugTools:initialize()
      DebugTools class constructor
---------------------------------------------------------------]]
function DebugTools:initialize()
  BaseService.initialize(self)
  PrintInfo('DebugTools:initialize()')
end

--[[---------------------------------------------------------------
    DebugTools:__gc()
      DebugTools class gc method
      Essentially called when the garbage collector collects the service.
  ---------------------------------------------------------------]]
function DebugTools:__gc()
  PrintInfo('*****************DebugTools:__gc()')
end

--[[---------------------------------------------------------------
    DebugTools:OnInit()
      Called on initialization of the script engine by the game!
---------------------------------------------------------------]]
function DebugTools:OnInit()
  assert(self, 'DebugTools:OnInit() : self is null!')
  PrintInfo("\n<!> ExampleSvc: Init..")
end

--[[---------------------------------------------------------------
    DebugTools:OnDeinit()
      Called on de-initialization of the script engine by the game!
---------------------------------------------------------------]]
function DebugTools:OnDeinit()
  assert(self, 'DebugTools:OnDeinit() : self is null!')
  PrintInfo("\n<!> ExampleSvc: Deinit..")
end

--[[---------------------------------------------------------------
    DebugTools:OnNewGame()
      When a debug save file is loaded this is called!
---------------------------------------------------------------]]
function DebugTools:OnNewGame()
  assert(self, 'DebugTools:OnNewGame() : self is null!')
  PrintInfo("\n<!> ExampleSvc: Preparing debug save file")
  _DATA.Save.ActiveTeam:SetRank("none")
  _DATA.Save.ActiveTeam.Name = "Valiant"
  _DATA.Save.ActiveTeam.Money = 1000
  _DATA.Save.ActiveTeam.Bank = 999999
  _DATA.Save.NoSwitching = true--switching is not allowed

  
  local mon_id = RogueEssence.Dungeon.MonsterID(252, 0, 0, Gender.Male)
  local p = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 8, -1, 0)
  local tbl = LTBL(p)
  tbl.Importance = 'Hero'
  p.IsFounder = true
  p.IsPartner = true
  p.Nickname = 'Palika'
  _DATA.Save.ActiveTeam.Players:Add(p)
  
  mon_id = RogueEssence.Dungeon.MonsterID(447, 0, 0, Gender.Male)
  p = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 8, -1, 0)
  tbl = LTBL(p)
  tbl.Importance = 'Partner'
  p.IsFounder = true
  p.IsPartner = true
  p.Nickname = 'Genshi'
  _DATA.Save.ActiveTeam.Players:Add(p)
  
  --mon_id = RogueEssence.Dungeon.MonsterID(357, 0, 0, Gender.Male)
  --_DATA.Save.ActiveTeam.Players:Add(_DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 50, -1, 0))
  
  
  	_DATA.Save.ActiveTeam.Players[0].MaxHPBonus = 3
	_DATA.Save.ActiveTeam.Players[0].AtkBonus = 1
	_DATA.Save.ActiveTeam.Players[0].DefBonus = 1
	_DATA.Save.ActiveTeam.Players[0].MAtkBonus = 1
	_DATA.Save.ActiveTeam.Players[0].MDefBonus = 1
	_DATA.Save.ActiveTeam.Players[0].SpeedBonus = 1

	_DATA.Save.ActiveTeam.Players[1].MaxHPBonus = 3
	_DATA.Save.ActiveTeam.Players[1].AtkBonus = 1
	_DATA.Save.ActiveTeam.Players[1].DefBonus = 1
	_DATA.Save.ActiveTeam.Players[1].MAtkBonus = 1
	_DATA.Save.ActiveTeam.Players[1].MDefBonus = 1
	_DATA.Save.ActiveTeam.Players[1].SpeedBonus = 1
	
  --audino 
   -- mon_id = RogueEssence.Dungeon.MonsterID(531, 0, 0, Gender.Female)
  --_DATA.Save.ActiveTeam.Players:Add(_DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 50, -1, 0))
 _DATA.Save.ActiveTeam:SetRank("normal")
  _DATA.Save:UpdateTeamProfile(true)
  

  
	local dungeon_dict = LUA_ENGINE:MakeTable(_DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone].Entries)
	for k, v in pairs(dungeon_dict) do
		GAME:UnlockDungeon(k)
	end
  
  SV.base_camp.ExpositionComplete = true
  SV.base_camp.IntroComplete = true
end

---Summary
-- Subscribe to all channels this service wants callbacks from
function DebugTools:Subscribe(med)
  med:Subscribe("DebugTools", EngineServiceEvents.Init,                function() self.OnInit(self) end )
  med:Subscribe("DebugTools", EngineServiceEvents.Deinit,              function() self.OnDeinit(self) end )
  med:Subscribe("DebugTools", EngineServiceEvents.NewGame,        function() self.OnNewGame(self) end )
--  med:Subscribe("DebugTools", EngineServiceEvents.GraphicsUnload,      function() self.OnGraphicsUnload(self) end )
--  med:Subscribe("DebugTools", EngineServiceEvents.Restart,             function() self.OnRestart(self) end )
end

---Summary
-- un-subscribe to all channels this service subscribed to
function DebugTools:UnSubscribe(med)
end

---Summary
-- The update method is run as a coroutine for each services.
function DebugTools:Update(gtime)
--  while(true)
--    coroutine.yield()
--  end
end

--Add our service
SCRIPT:AddService("DebugTools", DebugTools:new())
return DebugTools