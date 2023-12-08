--[[
    Example Service
    
    This is an example to demonstrate how to use the BaseService class to implement a game service.
    
    **NOTE:** After declaring you service, you have to include your package inside the main.lua file!
]]--
require 'common'
require 'services.baseservice'

--Declare class MusicService
local MusicService = Class('MusicService', BaseService)

--[[---------------------------------------------------------------
    MusicService:initialize()
      MusicService class constructor
---------------------------------------------------------------]]
function MusicService:initialize()
  BaseService.initialize(self)
  self.mapname = ""
  PrintInfo('MusicService:initialize()')
end

--[[---------------------------------------------------------------
    MusicService:__gc()
      MusicService class gc method
      Essentially called when the garbage collector collects the service.
  ---------------------------------------------------------------]]
--function MusicService:__gc()
--  PrintInfo('*****************MusicService:__gc()')
--end

--[[---------------------------------------------------------------
    MusicService:OnInit()
      Called on initialization of the script engine by the game!
---------------------------------------------------------------]]
function MusicService:OnInit()
  assert(self, 'MusicService:OnInit() : self is null!')
  PrintInfo("\n<!> ExampleSvc: Init..")
end

--[[---------------------------------------------------------------
    MusicService:OnDeinit()
      Called on de-initialization of the script engine by the game!
---------------------------------------------------------------]]
function MusicService:OnDeinit()
  assert(self, 'MusicService:OnDeinit() : self is null!')
  PrintInfo("\n<!> ExampleSvc: Deinit..")
end

---Summary
-- Subscribe to all channels this service wants callbacks from
function MusicService:Subscribe(med)
  med:Subscribe("MusicService", EngineServiceEvents.Init,                function() self.OnInit(self) end )
  med:Subscribe("MusicService", EngineServiceEvents.Deinit,              function() self.OnDeinit(self) end )
  --med:Subscribe("MusicService", EngineServiceEvents.MusicChange,       function(_, songinfo) self.OnMusicChange(self, songinfo) end )
end

---Summary
-- un-subscribe to all channels this service subscribed to
function MusicService:UnSubscribe(med)
end

---Summary
-- The update method is run as a coroutine for each services.
function MusicService:Update(gtime)
--  while(true)
--    coroutine.yield()
--  end
end

--Add our service
SCRIPT:AddService("MusicService", MusicService:new())
return MusicService