--[[
  Basic generic ground mode AI implementation.
  
  An entity running this AI will randomly turn and wander a bit from time to time.
]]--
require 'common'
local BaseAI = require 'ai.ground_baseai'
local BaseState = require 'ai.base_state'

-------------------------------
-- States Class Definitions
-------------------------------
--[[------------------------------------------------------------------------
    Idle state:
      The entity will determine an idle EmoteIdleion to take after a certain amount of time has passed.
      It will play its idle animation meanwhile. And if it has a current task to execute it will 
      switch to the "EmoteIdle" state.
]]--------------------------------------------------------------------------
local StateIdle = Class('StateIdle', BaseState)

--The range of possible wait time between idle movements, in number of calls to the state's "Run" method/frames

function StateIdle:initialize(parentai)
  StateIdle.super.initialize(self, parentai)

  --Set a time in ticks for the next idle action
  self.idletimer = 0

end

function StateIdle:Begin(prevstate, entity)
  assert(self, "StateIdle:Begin(): Error, self is nil!")
  StateIdle.super.Begin(self, prevstate, entity)
    --print("idle")
  self.idletimer = self.parentAI.IdleTime

  local ent = LUA_ENGINE:CastToGroundAIUser(entity)
  
  --todo: better way of finding original direction
  if self.parentAI.OldDir == Direction.None then--this should only happen on initial run
	self.parentAI.OldDir = ent.Direction
	self.idletimer = self.idletimer + self.parentAI.InitialDelay
  end
  --Play Idle anim
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
  
  --If enough time passed, wander or turn
  if self.idletimer <= 0 then
    self:DoIdle()
  end
  
  --Tick down the idle timer
  self.idletimer = self.idletimer - 1 
end

-- Does pick an idle action to perform
function StateIdle:DoIdle()
  local choice = 1
  --this will need more adjusting but i dont wanna do that rn
  if self.parentAI.RandomTalk then 
	choice =  math.random(1, self.parentAI.NumOfFriends + 1) --Randomly decide to wait or emote
  --have a 1/number of peeps in the conversation chance of emoting
  end
  
  if choice == 1 then
    self.parentAI:SetState("SetEmote")
  else
    self.parentAI:SetState("Idle")
  end
end

--[[------------------------------------------------------------------------
    EmoteIdle state:
		In this state, the AI will emote for a period of time, then go to StopEmote to stop emoting.
]]--------------------------------------------------------------------------
local StateEmoteIdle = Class('StateEmoteIdle', BaseState)

function StateEmoteIdle:initialize(parentai)
  StateEmoteIdle.super.initialize(self, parentai)

  --Set a time in ticks for the next idle EmoteIdleion
  self.timeEmoting = 0
end

function StateEmoteIdle:Begin(prevstate, entity)
  assert(self, "StateEmoteIdle:Begin(): Error, self is nil!")
  StateEmoteIdle.super.Begin(self, prevstate, entity)
  --Stop Idle anim
    self.timeEmoting = self.parentAI.EmoteIdleTime
  
  --print("EmoteIdle")
end

function StateEmoteIdle:Run(entity)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  assert(self, "StateEmoteIdle:Run(): Error, self is nil!")
  StateEmoteIdle.super.Run(self, entity)
  
    local ent = LUA_ENGINE:CastToGroundAIUser(entity)

  --When interaction stopped, go idle or stop emoting if we're emoting
  if self.parentAI.Emoting and (self.timeEmoting < 0 or ent.IsInteracting) then 
	  self.parentAI:SetState("StopEmote")
 -- elseif not self.parentAI.Emoting and not ent:CurrentTask() then
	--  self.parentAI:SetState("Idle")
	end
	self.timeEmoting = self.timeEmoting - 1
  end

----------------------
-- Go to this state before going Idle to stop emoting.
--------------------
local StateStopEmote = Class('StateStopEmote', BaseState)

function StateStopEmote:initialize(parentai)
  assert(self, "StateStopEmote:initialize(): Error, self is nil!")
  StateStopEmote.super.initialize(self, parentai)
  self.timeWaiting = 0
  self.taskSet = false--using currenttask() wont work if they dont need to turn, hence the need for this flag
  end
 
function StateStopEmote:Run(entity)
  assert(self, "StateStopEmote:Run(): Error, self is nil!")
  StateStopEmote.super.Run(self, entity)

	--none of this should ever really run i think
  local ent = LUA_ENGINE:CastToGroundChar(entity)
  
  -- If a task is set, move to Idle
  if self.taskSet then self.parentAI:SetState("Idle") end
  
  --Suspend while interacting with the entity
  if ent.IsInteracting then 
    self.parentAI:SetState("Idle")
  end

  
end 
	
function StateStopEmote:Begin(prevstate, entity)
  assert(self, "StateStopEmote:Begin(): Error, self is nil!")
  StateStopEmote.super.Begin(self, prevstate, entity)
    --print("stopemote")
  self.taskSet = false

  self:SetTask(entity)
  self.taskSet = true
end


function StateStopEmote:SetTask(entity)
  self.parentAI.Emoting = false
  TASK:StartEntityTask(entity, 
    function()
      GROUND:CharSetEmote(entity, "", 0)
	  if self.parentAI.Turn and not LUA_ENGINE:CastToGroundChar(entity).IsInteracting then
		GROUND:CharAnimateTurnTo(entity, self.parentAI.OldDir, 4)
      end
    end)
end
	



--[[------------------------------------------------------------------------
    SetEmote state:
      When the entity is in this state, it will pick a random emote and do it for a random amount of time (if applicable)
]]--------------------------------------------------------------------------
local StateSetEmote = Class('StateSetEmote', BaseState)


function StateSetEmote:initialize(parentai)
  assert(self, "StateSetEmote:initialize(): Error, self is nil!")
  StateSetEmote.super.initialize(self, parentai)

	
  self.TurnToChar = nil
  self.taskSet = false--using currenttask() wont work if they dont need to turn, hence the need for this flag

end

function StateSetEmote:Begin(prevstate, entity)
  assert(self, "StateSetEmote:Begin(): Error, self is nil!")
  StateSetEmote.super.Begin(self, prevstate, entity)
    --print("SetEmote")
	--this gets assigned based on the chosen personality
	local EmoteSet = {}
	self.taskSet = false
	
	--todo: add different 
	--determine which emote to do.
	local rand = math.random(1, 10)
	
	--numbers correspond to emotes. the more times the number appears, the more likely it is to be chosen
	if self.parentAI.Personality == 'Default' then
		 EmoteSet = {"happy", "happy", "happy", "happy", "happy", "glowing", "glowing", "exclaim", "exclaim", "question"}
	elseif self.parentAI.Personality == 'Angry' then 
		 EmoteSet = {"happy", "happy", "happy", "happy", "angry", "angry", "angry", "exclaim", "exclaim", "question"}
	elseif self.parentAI.Personality == 'Scared' then 
		 EmoteSet = {"happy", "happy", "happy", "sweating", "sweating", "sweating", "sweating", "shock", "shock", "sweatdrop"}
	else 
		EmoteSet = {"notice", "notice", "notice", "notice", "notice", "notice", "notice", "notice", "notice", "notice"}
	end
	
	self.parentAI.Emote = EmoteSet[rand]
	--print(self.parentAI.Emote)
	
	--todo: make this cleaner
	self.parentAI.Repetitions = 1
	if self.parentAI.Emote == "happy" or self.parentAI.Emote == "glowing" then
		self.parentAI.Repetitions = 0
	elseif self.parentAI.Emote == "angry" then
		self.parentAI.Repetitions = 2
	end
	

	local ent = LUA_ENGINE:CastToGroundAIUser(entity)

end


function StateSetEmote:SetTask(entity)
  self.parentAI.Emoting = true
  TASK:StartEntityTask(entity, 
    function()
      if self.parentAI.Turn then GROUND:CharTurnToCharAnimated(entity, self.TurnToChar, 4) end
	  GROUND:CharSetEmote(entity, self.parentAI.Emote, self.parentAI.Repetitions)
    end)
end

function StateSetEmote:Run(entity)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  assert(self, "StateSetEmote:Run(): Error, self is nil!")
  StateSetEmote.super.Run(self, entity)
  
  local ent = LUA_ENGINE:CastToGroundChar(entity)
  
  	--which friend do we turn to?
	if self.parentAI.Turn then 
		self.TurnToChar = self.parentAI.Friends[math.random(1, self.parentAI.NumOfFriends)]
	end

	--this would cause emoting desyncs

	--wait less time if it's a single emote chosen rather than a looping one
	--if self.parentAI.RandomTalk then 
	--	if self.parentAI.Repetitions == 0 then self.timeEmoting = self.timeEmoting / 2 end 
	--end
	if (self.parentAI.Turn and not self.TurnToChar.IsInteracting) or not self.parentAI.Turn then 
	  self:SetTask(entity)
	  self.taskSet = true
	  -- When a task is set, move to EmoteIdle
	  self.parentAI:SetState("EmoteIdle") 
	end 
	
	
  --Suspend while interacting with the entity
  if ent.IsInteracting then 
	self.parentAI:SetState("StopEmote")
  end
  --wait a bit before trying to set another emote
  GAME:WaitFrames(10)

end






--------------------------
-- ground_talking AI Class
--------------------------
-- Basic ground charEmoteIdleer AI template
local ground_talking = Class('ground_talking', BaseAI)

--Constructor
function ground_talking:initialize(turn, IdleTime, EmoteIdleTime, InitialDelay, RandomTalk, personality, friends)
  assert(self, "ground_talking:initialize(): Error, self is nil!")
  ground_talking.super.initialize(self)
  self.Memory = {} -- Where the AI will store any state shared variables it needs to keep track of at runtime (not serialized)
  self.NextState = "Idle" --Always set the initial state as the next state, so "Begin" is run!
  
  --print('start')
  
  --friends in the conversation
  if not friends then
    self.Friends = {}
  else
    self.Friends = friends
  end
  
  if not turn then
    self.Turn = false
  else
    self.Turn = turn
  end
 
  
  --Set the delay between idle actions
  if not EmoteIdleTime then
    self.EmoteIdleTime = 60
  else
    self.EmoteIdleTime = EmoteIdleTime
  end
  if not IdleTime then
    self.IdleTime = 120
  else
    self.IdleTime = IdleTime
  end
  
  if not InitialDelay then 
	self.InitialDelay = 0
  else
    self.InitialDelay = InitialDelay
  end
  
  if not RandomTalk then
	self.RandomTalk = false
  else
    self.RandomTalk = RandomTalk
  end
  
  if personality == nil then 
    self.Personality = 'Default'
  else
    self.Personality = personality
  end
  
  self.NumOfFriends = #self.Friends
  
  --dont turn if you have no friends
  if self.NumOfFriends == 0 then self.Turn = false end
  
  self.Emote = ""
  self.Repetitions = 0
  self.Emoting = false
  self.OldDir = Direction.None

  
  --if self.NumOfFriends == 0 then self.Turn = false end --dont try to turn if you have no friends for some reason
  
  -- Place the instances of the states classes into the States table
  self.States.Idle      = StateIdle:new(self)
  self.States.EmoteIdle = StateEmoteIdle:new(self)
  self.States.SetEmote  = StateSetEmote:new(self)
  self.States.StopEmote = StateStopEmote:new(self)
 -- self.States.IdleTurn    = StateIdleTurn:new(self)
end

--Return the class
return ground_talking