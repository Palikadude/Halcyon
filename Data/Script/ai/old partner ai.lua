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
  
  -- If a task is set, move to act
  --if ent:CurrentTask() then self.parentAI:SetState("Act") end
  
  --Suspend while interacting with the entity
  if ent.IsInteracting then 
    return 
  end
  
  --has player stopped idling? if so flag it, and queue in their new position
  self:CalculateNextPosition(entity)

  
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
	self.TargetLastPos = self.parentAI.TargetEntity.Position
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
  --GROUND:CharSetAnim(entity, 'Walk', true)

  self.TargetLastPos = self.parentAI.TargetEntity.Position
  self.PlayerIdle = false
  
  --self.wanderRadius = GAME.Rand:Next(self.parentAI.WanderStepMin, self.parentAI.WanderStepMax)
  --self:CalculateWanderPos(entity)
  --self:SetTask(entity)
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
	self.TargetLastPos = self.parentAI.TargetEntity.Position
  end
 
end

function StateFollow:SetTask(entity)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  local targetpos = Queue.popright(self.parentAI.TargetMemory)--get next coordinate to travel to
  
  local run = false
  local diffX = targetpos.X - self.parentAI.LastTargetPosition.X
  local diffY = targetpos.Y - self.parentAI.LastTargetPosition.Y
  local distance = math.sqrt((diffX * diffX) + (diffY * diffY))  
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
  
  local ent = LUA_ENGINE:CastToGroundChar(entity)
  
  
  self:CalculateNextPosition(entity)
  self:SetTask(entity)
  
  --run task
  local ent = LUA_ENGINE:CastToGroundAIUser(entity)
  if ent then ent:UpdateTask() end
  
  TASK:WaitEntityTask(ent)
  
  if self.PlayerIdle then 
	self.parentAI:SetState("Idle")
  end 
  
  --Suspend while interacting with the entity
  if ent.IsInteracting then 
    self.parentAI:SetState("Idle")
  end
    
  
    
  -- Step towards a random position decided at the transition to wander
  --local dir = GAME:VectorToDirection(self.wanderStep.X, self.wanderStep.Y)
  --if dir ~= RogueElements.Dir8.None then
  --  ent.CurrentCommand = RogueEssence.Dungeon.GameAction(RogueEssence.Dungeon.GameAction.ActionType.Move, dir, 0); 
  --end
  

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

  
  
  --initialize some points between the player and the partner when first initializing
  local xDiff = self.InitialPosition.X - self.TargetEntity.Position.X
  local yDiff = self.InitialPosition.Y - self.TargetEntity.Position.Y
  local xPos, yPos = 0, 0
  
  for i=1, 4, 1 do
	xPos = math.floor(self.InitialPosition.X - (xDiff * i / 4))
	yPos = math.floor(self.InitialPosition.Y - (yDiff * i / 4))
	print('initialize position', xPos, yPos, xDiff, yDiff)
	Queue.pushleft(self.TargetMemory, RogueElements.Loc(xPos, yPos))
  end

  
  -- Place the instances of the states classes into the States table
  self.States.Idle        = StateIdle:new(self)
  self.States.Follow      = StateFollow:new(self)
end

--Return the class
return ground_partner