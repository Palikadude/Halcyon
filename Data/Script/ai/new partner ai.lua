--[[
  Basic ground partner AI implementation.
  
  An entity running this AI will follow the target entity. Typically, this should be the hero,
  but it also can be used to follow other characters in a similar manner.
]]--
require 'common'
require 'queue'
local BaseAI = require 'ai.ground_baseai'
local BaseState = require 'ai.base_state'


-------------------------------
-- States Class Definitions
-------------------------------
--[[------------------------------------------------------------------------
    Idle state:
      The partner should stay idle if they're close enough to the hero. 
      It will play its idle animation meanwhile. If the hero moves too far from the partner, task to execute it will 
      switch to the "Act" state.
]]--------------------------------------------------------------------------
local StateIdle = Class('StateIdle', BaseState)



function StateIdle:initialize(parentai)
  StateIdle.super.initialize(self, parentai)
end

function StateIdle:Begin(prevstate, entity)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  assert(self, "StateIdle:Begin(): Error, self is nil!")
  print('partner AI: begin idle state')
  StateIdle.super.Begin(self, prevstate, entity)
  --Play Idle anim
  
end

function StateIdle:Run(entity)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  assert(self, "StateIdle:Run(): Error, self is nil!")
  StateIdle.super.Run(self, entity)
  local ent = LUA_ENGINE:CastToGroundAIUser(entity)
  
  --has player stopped idling? if so flag it, and queue in their new position
  self.parentAI:CalculateNextPosition(entity)
  
  
  --Suspend while interacting with the entity
  if ent.IsInteracting then 
    return 
  end
  
  local distance = GetDistance(entity.Position, self.parentAI.TargetEntity.Position)
  
  -- threshold for switching to follow mode is the distance you feel the target should stay
  if self.parentAI.TravelLength > self.parentAI.ComfortZone then
	self.parentAI:SetState("Follow")
  end
  
  GAME:SetDebugUI("X:"..tostring(self.parentAI.LastTargetPosition.X).." Y:"..tostring(self.parentAI.LastTargetPosition.Y) .. "\n" .. GAME:GetDebugUI())
  GAME:SetDebugUI("Travel:" .. tostring(self.parentAI.TravelLength) .. "\n" .. GAME:GetDebugUI())
  for i=1, self.parentAI.QueueLength, 1 do
    local element = Queue.popright(self.parentAI.TargetMemory)
	local queueStr = "X:"..tostring(element.X).." Y:"..tostring(element.Y)
    GAME:SetDebugUI(queueStr .. "\n" .. GAME:GetDebugUI())
	Queue.pushleft(self.parentAI.TargetMemory, element)
  end
end
















--[[------------------------------------------------------------------------
    Catchup state:
      When the entity is in this state, player has stopped moving and AI is an awkward length away. Need to get close to hero.
]]--------------------------------------------------------------------------


local StateCatchup = Class('StateCatchup', BaseState)

function StateCatchup:initialize(parentai)
  assert(self, "StateCatchup:initalize(): Error, self is nil!")
  StateCatchup.super.initialize(self, parentai)
end

function StateCatchup:Begin(prevstate, entity)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  assert(self, "StateCatchup:Begin(): Error, self is nil!")
  print('partner ai: begin catchup state')  
  StateCatchup.super.Begin(self, prevstate, entity)
  
  self:Catchup(entity)
  
end  



function StateCatchup:Catchup(entity)--clear out coordinate queue, calculate a catchup point, and schedule a task to go there
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine

  self.parentAI:ClearQueue()
  
  --find a point x distance away from player, that will be our new target
  local distance = self.parentAI.ComfortZone - 2
  local vectorX = entity.Position.X - self.parentAI.TargetEntity.Position.X
  local vectorY = entity.Position.Y - self.parentAI.TargetEntity.Position.Y

  
  local vectorLength = math.sqrt((vectorX * vectorX) + (vectorY * vectorY))
  
  --this shouldn't happen, but this is here to prevent a divide by 0 error
  if vectorLength == 0 then self.parentAI:SetState("Idle") end

   
  vectorX = vectorX / vectorLength
  vectorY = vectorY / vectorLength
  
  --had to make targetX/Y a self variable, because when I tried to initialize points in the catchup run
  --using entity.Position instead, it wouldn't be the catchup point. I.e. the partner wouldn't go to the
  --catchup point BEFORE it got to the populate queue statement. probably has something to do with the other odd behavior
  --the debug output is going to be your friend in solving this overall issue...
  
  --local distance is the distance away we want to be when we are done catching up

  self.targetX = math.floor(self.parentAI.TargetEntity.Position.X + (distance * vectorX))
  self.targetY = math.floor(self.parentAI.TargetEntity.Position.Y + (distance * vectorY))
  
  print("I'm at", entity.Position.X, entity.Position.Y)
  print("I'm aiming to catchup at", self.targetX, self.targetY)
  

   
  --set task to run to catch up!
  TASK:StartEntityTask(entity,
	function()
	  GROUND:MoveToPosition(entity, self.targetX, self.targetY, true, 5)
	end)
  
	
end 

function StateCatchup:Run(entity)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  assert(self, "StateCatchup:Run(): Error, self is nil!")
  StateCatchup.super.Run(self, entity)
  
  --run the catchup task
  local ent = LUA_ENGINE:CastToGroundAIUser(entity)
  
  if not ent:CurrentTask() then 

	if GetDistance(entity.Position, self.parentAI.TargetEntity.Position) > 40 then --need to catchup again, player moved again since we tried to catch up
	  self:Catchup(entity) 
	else
	  --Reinitialize the task queue with some coordinates like when the AI is first initalized
	  self.parentAI:PopulateQueue(RogueElements.Loc(self.targetX, self.targetY), self.parentAI.TargetEntity.Position)
	
	  --Go back to idle state, we caught up... I would like to go to follow if player has started moving since we reached our catchup point
	  --but that had it's own unique issue... more state transition stuff
	  self.parentAI:SetState("Idle")
		
    end
  end
end
















 
--[[------------------------------------------------------------------------
    Follow state:
      When the entity is in this state, it will try to move to stay near the hero.
]]--------------------------------------------------------------------------
local StateFollow = Class('StateFollow', BaseState)

function StateFollow:initialize(parentai)
  assert(self, "StateFollow:initialize(): Error, self is nil!")
  StateFollow.super.initialize(self, parentai)

end

function StateFollow:Begin(prevstate, entity)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  assert(self, "StateFollow:Begin(): Error, self is nil!")
  print('partner ai: begin follow state')  
  StateFollow.super.Begin(self, prevstate, entity)
  
  self:SetTask(entity)
end


function StateFollow:SetTask(entity)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  local targetpos = Queue.popright(self.parentAI.TargetMemory)--get next coordinate to travel to
  self.parentAI.QueueLength = self.parentAI.QueueLength - 1
  local distance = GetDistance(self.parentAI.LastTargetPosition, targetpos)
  self.parentAI.TravelLength = self.parentAI.TravelLength - distance
  
  local run = false
  local speed = 2
  
  --run if the distance is above a certain threshold
  if self.parentAI.TravelLength > self.parentAI.ComfortZone + 2 then
    run = true
	speed = 5
  end 
  
  self.parentAI.LastTargetPosition = targetpos--set LastTaskPosition to the one we're about to move to 
  PrintInfo("Walking to "..tostring(targetpos.X)..","..tostring(targetpos.Y).." dist:"..tostring(distance))
  TASK:StartEntityTask(entity, 
    function()
      GROUND:MoveToPosition(entity, targetpos.X, targetpos.Y, run, speed)
    end)
end


function StateFollow:Run(entity)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  assert(self, "StateFollow:Run(): Error, self is nil!")
  StateFollow.super.Run(self, entity)
  
  self.parentAI:CalculateNextPosition(entity)
  
  local ent = LUA_ENGINE:CastToGroundAIUser(entity)
  
  --Suspend while interacting with the entity
  if ent.IsInteracting then 
    self.parentAI:SetState("Idle")
  end
  
  if not ent:CurrentTask() then 
    --threshold for switching back is slightly lower to prevent stuttering walk
	if self.parentAI.TravelLength > self.parentAI.ComfortZone - 2 then
	  self:SetTask(entity)
	else
	  self.parentAI:SetState("Idle") 
	end
  end
  
  GAME:SetDebugUI("X:"..tostring(self.parentAI.LastTargetPosition.X).." Y:"..tostring(self.parentAI.LastTargetPosition.Y) .. "\n" .. GAME:GetDebugUI())
  GAME:SetDebugUI("Travel:" .. tostring(self.parentAI.TravelLength) .. "\n" .. GAME:GetDebugUI())
  for i=1, self.parentAI.QueueLength, 1 do
    local element = Queue.popright(self.parentAI.TargetMemory)
	local queueStr = "X:"..tostring(element.X).." Y:"..tostring(element.Y)
    GAME:SetDebugUI(queueStr .. "\n" .. GAME:GetDebugUI())
	Queue.pushleft(self.parentAI.TargetMemory, element)
  end

end


















--------------------------
-- ground_partner AI Class
--------------------------
-- Ground partner AI template
local ground_partner = Class('ground_partner', BaseAI)

--Constructor
function ground_partner:initialize(targetentity, initialposition)
  assert(self, "ground_partner:initialize(): Error, self is nil!")
  DEBUG:EnableDbgCoro()
  ground_partner.super.initialize(self)
  self.NextState = "Idle" --Always set the initial state as the next state, so "Begin" is run!
  self.TargetMemory = Queue.new() -- A queue where the AI will store recent player positions. When initialized some points between where the hero and partner spawn should be added
  self.InitialSteps = 6--AI will be this many "steps" behind the player, plus two additional ones. 
  self.QueueLength = 0--How many entries in the queue?
  self.TravelLength = 0--How long is the combined travel length in the queue?
  self.ComfortZone = 32
  
  --Who is the partner following? 
  if not targetentity then
	self.TargetEntity = CH('PLAYER')--don't know if this works, but default should be to follow player
  else
	self.TargetEntity = targetentity
  end
  
  if not initialposition then
	self.InitialPosition = RogueElements.Loc()
  else
    self.InitialPosition = initialposition
  end
  
  self.TargetLastPos = self.TargetEntity.Position
  self.PlayerIdle = true

  --initailize some target destinations between partner and player when spawning into map
  self:PopulateQueue(self.InitialPosition, self.TargetEntity.Position)
 

  
  -- Place the instances of the states classes into the States table
  self.States.Idle        = StateIdle:new(self)
  self.States.Follow      = StateFollow:new(self)
  self.States.Catchup     = StateCatchup:new(self)
end

--used to initalize a number of steps between two positions, typically between player's and partner's coords
function ground_partner:PopulateQueue(startPos, endPos)
  self.LastTargetPosition = startPos
  --typically, startPos will be partner's position, and endPos will be player's position
  local xDiff = startPos.X - endPos.X
  local yDiff = startPos.Y - endPos.Y
  local xPos, yPos = 0, 0
  local curPos = startPos
  
  for i=1, self.InitialSteps, 1 do
	xPos = math.floor(startPos.X - (xDiff * i / self.InitialSteps))
	yPos = math.floor(startPos.Y - (yDiff * i / self.InitialSteps))
	print('initialize position', xPos, yPos, xDiff, yDiff)
	local targetLoc = RogueElements.Loc(xPos, yPos)
	Queue.pushleft(self.TargetMemory, targetLoc)
	local distance = GetDistance(curPos, targetLoc)
	self.QueueLength = self.QueueLength + 1
	self.TravelLength = self.TravelLength + distance
	curPos = targetLoc
  end
end 

function ground_partner:ClearQueue()

  --clear out task queue
  --print('length of queue is', self.QueueLength)
  for i=1, self.QueueLength,1 do
    local pos = Queue.popright(self.TargetMemory)
  end
  
  self.QueueLength = 0
  self.TravelLength = 0
end

function ground_partner:CalculateNextPosition(entity)

  --Has player moved?
  self.PlayerIdle = (self.TargetLastPos.X == self.TargetEntity.Position.X 
	        and self.TargetLastPos.Y == self.TargetEntity.Position.Y)

  --add current position to positions queue if player has moved since we last checked
  --if not, flag the AI to go idle
  if not self.PlayerIdle then
    local distance = GetDistance(self.TargetLastPos, self.TargetEntity.Position)
	print("queueing position:", self.TargetEntity.Position.X, self.TargetEntity.Position.Y)
	Queue.pushleft(self.TargetMemory, self.TargetEntity.Position)
	self.QueueLength = self.QueueLength + 1
	self.TravelLength = self.TravelLength + distance
	self.TargetLastPos = self.TargetEntity.Position
  end
 
end


function GetDistance(pos1, pos2)--distance between two positions 
  local diffX = pos1.X - pos2.X
  local diffY = pos1.Y - pos2.Y
  local distance = math.sqrt((diffX * diffX) + (diffY * diffY))  
  
  return distance
end 


--Return the class
return ground_partner