--[[
    Example init.lua
    
  ****Each maps must have init.lua! ****
    
    Each map needs to have a init.lua, and a actions.lua file that defines its own instance of the GroundMap class.
    This will be used to determine how to run the map events and more!
    
    If the base implementation of GroundMap isn't enough, you can override any methods of the 
    GroundMap class in here as needed!
    
    You can add any number of scripts in the map folder as you want! Some special constants are available to fetch the current map's directory
    to load the scripts using a dofile or require function call.
    
    _SCRIPT_MAP_DIR = global containing the path from the Script root folder to the current folder
]]--
require('common')

local test_grounds = {}

local MapStrings = {}
--------------------------------------------------
-- Map Callbacks
--------------------------------------------------
function test_grounds.Init(map)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> Init_test_grounds <<=")
  MapStrings = COMMON.AutoLoadLocalizedStrings()
  COMMON.RespawnAllies()
  
  --Set Poochy AI
  local poochy = CH("Poochy")
  --Set the area to wander in
  local poochzone = {X = poochy.X - 100, Y = poochy.Y - 100, 
                     W = 200, H = 200};
  AI:SetCharacterAI(poochy,                                      --[[Entity that will use the AI]]--
                    "ai.ground_default",                         --[[Class path to the AI class to use]]--
                    RogueElements.Loc(poochzone.X, poochzone.Y), --[[Top left corner pos of the allowed idle wander area]]--
                    RogueElements.Loc(poochzone.W, poochzone.H), --[[Width and Height of the allowed idle wander area]]--
                    0.5,                                         --[[Wandering speed]]--
                    48,                                          --[[Min move distance for a single wander]]--
                    64,                                          --[[Max move distance for a single wander]]--
                    320,                                         --[[Min delay between idle actions]]--
                    620);                                        --[[Max delay between idle actions]]--
    


  local coord_table = {}
  coord_table[1] = { 200, 192, Direction.Down }
  coord_table[2] = { 200, 224, Direction.Down }
  coord_table[3] = { 200, 256, Direction.Down }
  
  --get assembly ready
  local assemblyCount = GAME:GetPlayerAssemblyCount()
  
  --Place player teammates
  for i = 1,5,1 do
    GROUND:RemoveCharacter("Assembly" .. tostring(i))
  end
  total = assemblyCount
  if total > 5 then
    total = 5
  end
  for i = 1,total,1 do
    p = GAME:GetPlayerAssemblyMember(i-1)
    GROUND:SpawnerSetSpawn("ASSEMBLY_" .. tostring(i),p)
    local chara = GROUND:SpawnerDoSpawn("ASSEMBLY_" .. tostring(i))
    --GROUND:GiveCharIdleChatter(chara)
  end
  
  --Spawn our spawner npcs
  GROUND:SpawnerDoSpawn('MerchantSpawner')
  
  GROUND:SpawnerDoSpawn('MerchantSpawner2')
end


function test_grounds.Prepare(map)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  
  --place random recruits
  
end

--Called when the screen fades in as the player enters the map
function test_grounds.Enter(map)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo('Enter_test_grounds')
  SV.base_camp.ExpositionComplete = true
  SV.base_camp.FirstTalkComplete = true
  GAME:SetTeamName(STRINGS:FormatKey("TEAM_NAME", "Guildmaster"))
  GAME:FadeIn(60)
  GAME:MoveCamera(0, 0, 60, true)
  UI:ResetSpeaker()
  --UI:WaitShowDialogue(STRINGS:Format("Congratulations on completing the toughest dungeon in the demo![pause=0] Enjoy the debug room!"))
end

--Called constantly while the map is running
function test_grounds.Update(map, time)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
end

--------------------------------------------------
-- Objects Callbacks
--------------------------------------------------
function test_grounds.Sign1_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo('Sign1_Action')
  UI:ResetSpeaker()
  UI:WaitShowMonologue(MapStrings['Sign1_Action_Line0'])
  
  TASK:WaitStartEntityTask(activator, function()
    SOUND:PlayBattleSE("EVT_Emote_Confused")
    GROUND:CharSetEmote(activator, 6, 1)
    GAME:WaitFrames(60)
    GROUND:MoveInDirection(activator, Direction.Down, 30)
    GROUND:MoveInDirection(activator, Direction.DownLeft, 30)
    GROUND:MoveInDirection(activator, Direction.DownRight, 30)
    GROUND:MoveInDirection(activator, Direction.UpRight, 30)
    GROUND:MoveInDirection(activator, Direction.UpLeft, 30)
  end)

  TASK:WaitEntityTask(activator)
  UI:WaitShowMonologue("Ye")
end


function test_grounds.Concurrent_Sequence(turnTime)
	local chara = CH('PLAYER')
  
  GROUND:CharSetAnim(chara, "None", true)
  GROUND:CharAnimateTurnTo(chara, Direction.Left, turnTime)
  GAME:WaitFrames(20)
  GROUND:CharAnimateTurn(chara, Direction.Right, turnTime, false)
  GAME:WaitFrames(20)
  GROUND:CharAnimateTurn(chara, Direction.Left, turnTime, true)
  GAME:WaitFrames(20)
  GROUND:CharAnimateTurn(chara, Direction.Right, turnTime, false)
  GAME:WaitFrames(20)
  GROUND:CharAnimateTurn(chara, Direction.Left, turnTime, true)
  GAME:WaitFrames(20)
  GROUND:CharAnimateTurn(chara, Direction.Right, turnTime, false)
  GAME:WaitFrames(20)
  GROUND:CharAnimateTurnTo(chara, Direction.Up, turnTime)
  GAME:WaitFrames(20)
  SOUND:PlayBattleSE("EVT_Emote_Confused")
  GROUND:CharSetEmote(chara, 6, 1)
  GAME:WaitFrames(20)
  GROUND:CharSetAnim(chara, "None", false)
end

function test_grounds.Sign2_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  local chara = CH('PLAYER')
  PrintInfo('Sign2_Action')
  UI:ResetSpeaker()
  UI:WaitShowMonologue(MapStrings['Sign2_Action_Line0'])
  GAME:FadeOut(false, 30)
  GAME:MoveCamera(0, 120, 1, true)
  --perform this fade without waiting for its completion
  local coro1 = TASK:BranchCoroutine(GAME:_FadeIn(60))
  local coro2 = TASK:BranchCoroutine(function() test_grounds.Concurrent_Sequence(4) end)
  GAME:MoveCamera(0, 0, 60, true)
  --TODO: wait to join coroutines before giving control back to the player
  TASK:JoinCoroutines({coro1, coro2})
end

function test_grounds.SouthExit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  UI:ResetSpeaker()
  UI:ChoiceMenuYesNo(MapStrings['SouthExit_Touch_Line0'])
  UI:WaitForChoice()
  local chres = UI:ChoiceResult() 
  if chres then
    GAME:FadeOut(false, 40)
    GAME:EnterGroundMap("base_camp", "entrance_north")
  else
    GROUND:MoveInDirection(activator, Direction.Up, 20)
  end
  
end
--------------------------------------------------
-- Characters Callbacks
--------------------------------------------------
function test_grounds.Mew_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  local mew = CH('Mew')
  local state = {olddir = mew.CharDir}

  GROUND:CharTurnToChar(mew,CH('PLAYER'))
  GROUND:CharSetEmote(mew, 5, 1)
  SOUND:PlayBattleSE("EVT_Emote_Sweating")

  UI:SetSpeaker(mew)
  UI:WaitShowDialogue(STRINGS:Format(MapStrings['Mew_Action_Line0']))

  CH('Mew').CharDir = state.olddir
end

function test_grounds.Hungrybox_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo('Hungrybox_Action')
  local hbox = chara
  local olddir = hbox.CharDir
  GROUND:CharTurnToCharAnimated(hbox, CH('PLAYER'), 4)
  UI:SetSpeaker(hbox)
  UI:TextDialogue(STRINGS:Format(MapStrings['Hungrybox_Action_Line0']))
  UI:WaitDialog()
  GROUND:CharAnimateTurnTo(hbox, olddir, 4)
  chara.CollisionDisabled = true
end

--------------------------------------------------
-- Characters Callbacks
--------------------------------------------------
function test_grounds.Poochy_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintSVAndStrings()
  
  local olddir = chara.CharDir
  GROUND:CharTurnToCharAnimated(chara, activator, 4)
  UI:SetSpeaker(chara)
  
  if SV.base_camp.AcceptedPooch then
    --If we already talked with poochy and got him to set the ScriptVar
    UI:TextDialogue(STRINGS:Format(MapStrings['Pooch_Action_Line3']))
    UI:WaitDialog()
  else
    --If we haven't gotten poochy to set the script var
    
    if not SV.base_camp.SpokeToPooch then
      --If we never spoke to poochy before
      UI:TextDialogue(STRINGS:Format(MapStrings['Pooch_Action_Line0A']))
      UI:WaitDialog()
      SV.base_camp.SpokeToPooch = true
    else
      --If we already spoke to poochy before, but didn't get him to set the script var
      UI:TextDialogue(STRINGS:Format(MapStrings['Pooch_Action_Line0B']))
      UI:WaitDialog()
    end
    
    UI:ChoiceMenuYesNo(STRINGS:Format(MapStrings['Pooch_Action_Question1']))
    UI:WaitForChoice()
    local ch = UI:ChoiceResult()
    
    if ch then
      --The player told poochy to set the script var
      SV.base_camp.AcceptedPooch = true
      SOUND:PlayFanfare("Fanfare/MissionClear")
      SOUND:WaitFanfare()
      UI:TextDialogue(STRINGS:Format(MapStrings['Pooch_Action_Line2A']))
    else
      --The player told poochy NOT to set the script var
      UI:TextDialogue(STRINGS:Format(MapStrings['Pooch_Action_Line2B']))
    end
    
    UI:WaitDialog()
    
  end -- if SV.AcceptedPooch
  UI:ResetSpeaker()
  GROUND:CharAnimateTurnTo(chara, olddir, 4)
end

--------------------------------------------------
-- Spawners Callbacks
--------------------------------------------------

--[[
--]]
function test_grounds.MerchantSpawner_EntSpawned(spawner, spawnedent)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("test_grounds.MerchantSpawner_EntSpawned()!!")
end

--[[
    
--]]
function test_grounds.Merchant_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  UI:ResetSpeaker()
  
  local olddir = chara.CharDir
  GROUND:CharTurnToCharAnimated(chara, activator, 4)
  UI:SetSpeaker(chara)
  
  UI:TextDialogue(STRINGS:Format(MapStrings['Merchant_Greet']))
  UI:WaitDialog()
  GROUND:CharAnimateTurnTo(chara, olddir, 4)
end

--[[
--]]
function test_grounds.MerchantSpawner2_EntSpawned(spawner, spawnedent)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("test_grounds.MerchantSpawner_EntSpawned()!!")
end

--[[
    
--]]
function test_grounds.Merchant2_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  UI:ResetSpeaker()
  
  local olddir = chara.CharDir
  GROUND:CharTurnToCharAnimated(chara, activator, 4)
  UI:SetSpeaker(chara)
  
  UI:TextDialogue(STRINGS:Format("HELLO!"))
  UI:WaitDialog()
  GROUND:CharAnimateTurnTo(chara, olddir, 4)
end

function test_grounds.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  UI:SetSpeaker(chara)
  
  local tbl = LTBL(chara)
  
  if tbl.TalkAmount == nil then
    UI:WaitShowDialogue("I have script vars specific to me.")
    UI:WaitShowDialogue("Switch with me by pressing 2 and 1.")
    UI:WaitShowDialogue("We will remember how many times we've been talked to.")
	tbl.TalkAmount = 1
  else
	tbl.TalkAmount = tbl.TalkAmount + 1
  end
  UI:WaitShowDialogue("You've talked to me "..tostring(tbl.TalkAmount).." times.")
end

function test_grounds.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  COMMON.GroundInteract(activator, chara, true)
end

function test_grounds.Teammate3_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  COMMON.GroundInteract(activator, chara, true)
end

return test_grounds