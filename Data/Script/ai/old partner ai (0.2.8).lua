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
 -- GROUND:CharSetAnim(entity, 'Idle', true)

  
  self.TargetLastPos = self.parentAI.TargetEntity.Position
  self.PlayerIdle = true
end



function StateIdle:Run(entity)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  assert(self, "StateIdle:Run(): Error, self is nil!")
  StateIdle.super.Run(self, entity)
  local ent = LUA_ENGINE:CastToGroundAIUser(entity)
  
  
  --Suspend while interacting with the entity
  if ent.IsInteracting then 
    return 
  end
  
  --has player stopped idling? if so flag it, and queue in their new position
  self:CalculateNextPosition(entity)
  
  local distance = GetDistance(entity.Position, self.parentAI.TargetEntity.Position)
  
  
  --has player stopped moving and AI lagging behind too far? enter catchup mode
  if self.PlayerIdle and distance > 40 --and not ent:CurrentTask() 
  then 
    self.parentAI:SetState("Catchup")
  end

  
  --If enough time passed, wander or turn
  if not self.PlayerIdle then
	self.parentAI:SetState("Follow")
  end
  
end

function StateIdle:CalculateNextPosition(entity)
  assert(self, "StateIdle:CalculateNextPosition(): Error, self is nil!")
  --Has player moved?
  local flag = (self.TargetLastPos.X == self.parentAI.TargetEntity.Position.X 
	        and self.TargetLastPos.Y == self.parentAI.TargetEntity.Position.Y)
  
  --add current position to positions queue if player has moved since we last checked
  --if not, flag the AI to go idle
  if not flag then
	self.PlayerIdle = false
	Queue.pushleft(self.parentAI.TargetMemory, self.parentAI.TargetEntity.Position)
	self.parentAI.QueueLength = self.parentAI.QueueLength + 1
	self.TargetLastPos = self.parentAI.TargetEntity.Position
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
  
  --clear out task queue
  print('length of queue is', self.parentAI.QueueLength)
  for i=1, self.parentAI.QueueLength,1 do
    local pos = Queue.popright(self.parentAI.TargetMemory)
  end
  
  self.parentAI.QueueLength = 0
  
  --find a point 32 away from player, that will be our new target
  local distance = 32
  local vectorX = self.parentAI.TargetEntity.Position.X - entity.Position.X
  local vectorY = self.parentAI.TargetEntity.Position.Y - entity.Position.Y

  
  local vectorLength = math.sqrt((vectorX * vectorX) + (vectorY * vectorY))
  
  --this shouldn't happen, but this is here to prevent a divide by 0 error
  if vectorLength == 0 then self.parentAI:SetState("Idle") end

   
  vectorX = vectorX / vectorLength
  vectorY = vectorY / vectorLength
  
  --had to make targetX/Y a self variable, because when I tried to initialize points in the catchup run
  --using entity.Position instead, it wouldn't be the catchup point. I.e. the partner wouldn't go to the
  --catchup point BEFORE it got to the populate queue statement. probably has something to do with the other odd behavior
  --the debug output is going to be your friend in solving this overall issue...
  
  --32 is the distance away we want to be when we are done catching up

  self.targetX = math.floor(entity.Position.X + (distance * vectorX))
  self.targetY = math.floor(entity.Position.Y + (distance * vectorY))
  
  print("I'm at", entity.Position.X, entity.Position.Y)
  print("I'm aiming to catchup at", self.targetX, self.targetY)
  
   
  --set task to run to catch up!
  TASK:StartEntityTask(entity,
	function()
	  GROUND:MoveToPosition(entity, self.targetX, self.targetY, true)
	end)
  
  
  
end  


function StateCatchup:Run(entity)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  assert(self, "StateCatchup:Run(): Error, self is nil!")
  StateCatchup.super.Run(self, entity)
  
  --run the catchup task
  local ent = LUA_ENGINE:CastToGroundAIUser(entity)
  if ent then ent:UpdateTask() end
  
  --wait until it's finished
  TASK:WaitEntityTask(ent)
  

  
  
  print("I'm currently at ", entity.Position.X, entity.Position.Y)
  --Reinitialize the task queue with some coordinates like when the AI is first initalized
  self.parentAI:PopulateQueue(RogueElements.Loc(self.targetX, self.targetY), self.parentAI.TargetEntity.Position)
  
  --Go back to idle state, we caught up 
  self.parentAI:SetState("Idle")
  
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
  --GROUND:CharSetAnim(entity, 'Walk', true)

  self.TargetLastPos = self.parentAI.TargetEntity.Position
  self.PlayerIdle = false
  

end



--Queue in the next movement coordinate for the partner. If hero stopped moving, don't queue anything and flag they've gone idle
function StateFollow:CalculateNextPosition(entity)
  DEBUG.EnableDbgCoro()
  assert(self, "StateFollow:CalculateNextPosition(): Error, self is nil!")
  
  
  --Has player moved?
  local flag = (self.TargetLastPos.X == self.parentAI.TargetEntity.Position.X 
	        and self.TargetLastPos.Y == self.parentAI.TargetEntity.Position.Y)
  
  
  --add current position to positions queue if player has moved since we last checked
  --if not, flag the AI to go idle
  if flag then
	self.PlayerIdle = true
  else
    --print("player coordinates", self.parentAI.TargetEntity.Position.X, self.parentAI.TargetEntity.Position.Y)
	Queue.pushleft(self.parentAI.TargetMemory, self.parentAI.TargetEntity.Position)
	self.parentAI.QueueLength = self.parentAI.QueueLength + 1
	self.TargetLastPos = self.parentAI.TargetEntity.Position
  end
 
end



function StateFollow:SetTask(entity)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  local targetpos = Queue.popright(self.parentAI.TargetMemory)--get next coordinate to travel to
  self.parentAI.QueueLength = self.parentAI.QueueLength - 1

  
  local run = false
  
  local distance = GetDistance(targetpos, self.parentAI.LastTargetPosition)
  
  --run if the distance is large. walking diagonally gives a max distance of about 8.5 depending on polling
  if distance > 9 then run = true end 
  
  self.parentAI.LastTargetPosition = targetpos--set LastTaskPosition to the one we're about to move to 
  print("I'm walkin' here!!", targetpos.X, targetpos.Y, distance)
  TASK:StartEntityTask(entity, 
    function()
      GROUND:MoveToPosition(entity, targetpos.X, targetpos.Y, run)
    end)
end



function StateFollow:Run(entity)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  assert(self, "StateFollow:Run(): Error, self is nil!")
  StateFollow.super.Run(self, entity)
  
  --local ent = LUA_ENGINE:CastToGroundChar(entity)
  
  
  self:CalculateNextPosition(entity)
  self:SetTask(entity)
  
  --run task
  local ent = LUA_ENGINE:CastToGroundAIUser(entity)
  if ent then ent:UpdateTask() end
  
  --wait for task to end
  TASK:WaitEntityTask(ent)
  
  if ent:CurrentTask() then 
    print("I currently have a task")
  else
    print("I don't have a task rn")
  end 
  
  --this section refused to work for some reason, even when i lowered the distance by quite a bit
  --local distance = GetDistance(entity.Position, self.parentAI.TargetEntity.Position)
  --has player stopped moving and AI lagging behind too far? enter catchup mode
  --if self.PlayerIdle and distance > 30 --and not ent:CurrentTask() 
  --then 
   -- self.parentAI:SetState("Catchup")
  --end
  
  if self.PlayerIdle then 
	self.parentAI:SetState("Idle")
  end 
  
  --Suspend while interacting with the entity
  if ent.IsInteracting then 
    self.parentAI:SetState("Idle")
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
  self.InitialSteps = 3--AI will be this many "steps" behind the player, plus two additional ones. 
  self.QueueLength = 0--How many entries in the queue?
  
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
  
  --Used for tracking previous task. Used to determine distance between tasks to determine whether to run or not
  self.LastTargetPosition = self.InitialPosition

  --initailize some target destinations between partner and player when spawning into map
  self:PopulateQueue(self.InitialPosition, self.TargetEntity.Position)
 

  
  -- Place the instances of the states classes into the States table
  self.States.Idle        = StateIdle:new(self)
  self.States.Follow      = StateFollow:new(self)
  self.States.Catchup     = StateCatchup:new(self)
end

--used to initalize a number of steps between two positions, typically between player's and partner's coords
function ground_partner:PopulateQueue(startPos, endPos)
  --typically, startPos will be partner's position, and endPos will be player's position
  local xDiff = startPos.X - endPos.X
  local yDiff = startPos.Y - endPos.Y
  local xPos, yPos = 0, 0
  
  for i=1, self.InitialSteps, 1 do
	xPos = math.floor(startPos.X - (xDiff * i / self.InitialSteps))
	yPos = math.floor(startPos.Y - (yDiff * i / self.InitialSteps))
	print('initialize position', xPos, yPos, xDiff, yDiff)
	Queue.pushleft(self.TargetMemory, RogueElements.Loc(xPos, yPos))
	self.QueueLength = self.QueueLength + 1
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