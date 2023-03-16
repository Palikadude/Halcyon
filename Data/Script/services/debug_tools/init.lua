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
  
  if _DATA.Save.ActiveTeam.Players.Count > 0 then
     local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("HeroInteract")
    _DATA.Save.ActiveTeam.Players[0].ActionEvents:Add(talk_evt)
	_DATA.Save:RegisterMonster(_DATA.Save.ActiveTeam.Players[0].BaseForm.Species)
	
	_DATA.Save.ActiveTeam:SetRank("normal")
	if not GAME:InRogueMode() then
      _DATA.Save.ActiveTeam.Bank = 1000
	end
  else	
		PrintInfo("\n<!> ExampleSvc: Preparing debug save file")
	  _DATA.Save.ActiveTeam:SetRank("none")
	  _DATA.Save.ActiveTeam.Name = "Valiant"
	  _DATA.Save.ActiveTeam.Money = 1000
	  _DATA.Save.ActiveTeam.Bank = 999999
	  _DATA.Save.NoSwitching = true--switching is not allowed

	  
	  local mon_id = RogueEssence.Dungeon.MonsterID("treecko", 0, "normal", Gender.Male)
	  local p = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 8, "", 0)
	  local tbl = LTBL(p)
	  tbl.Importance = 'Hero'
	  p.IsFounder = true
	  p.IsPartner = true
	  p.Nickname = 'Palika'
	  _DATA.Save.ActiveTeam.Players:Add(p)
	  
	  mon_id = RogueEssence.Dungeon.MonsterID("riolu", 0, "normal", Gender.Male)
	  p = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 8, "", 0)
	  tbl = LTBL(p)
	  tbl.Importance = 'Partner'
	  p.IsFounder = true
	  p.IsPartner = true
	  p.Nickname = 'Genshi'
	  _DATA.Save.ActiveTeam.Players:Add(p)
	  
	  
	  talk_evt = RogueEssence.Dungeon.BattleScriptEvent("HeroInteract")
	  _DATA.Save.ActiveTeam.Players[0].ActionEvents:Add(talk_evt)
	  talk_evt = RogueEssence.Dungeon.BattleScriptEvent("PartnerInteract")
	  _DATA.Save.ActiveTeam.Players[1].ActionEvents:Add(talk_evt)
	  
	  mon_id = RogueEssence.Dungeon.MonsterID("tropius", 0, "normal", Gender.Male)
	  _DATA.Save.ActiveTeam.Players:Add(_DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 50, "", 0))
	  
	  --This is a scrapped feature where you would have started with some bonuses to your stats.
		--_DATA.Save.ActiveTeam.Players[0].MaxHPBonus = 3
		--_DATA.Save.ActiveTeam.Players[0].AtkBonus = 1
		--_DATA.Save.ActiveTeam.Players[0].DefBonus = 1
		--_DATA.Save.ActiveTeam.Players[0].MAtkBonus = 1
		--_DATA.Save.ActiveTeam.Players[0].MDefBonus = 1
		--_DATA.Save.ActiveTeam.Players[0].SpeedBonus = 1

		--_DATA.Save.ActiveTeam.Players[1].MaxHPBonus = 3
		--_DATA.Save.ActiveTeam.Players[1].AtkBonus = 1
		--_DATA.Save.ActiveTeam.Players[1].DefBonus = 1
		--_DATA.Save.ActiveTeam.Players[1].MAtkBonus = 1
		--_DATA.Save.ActiveTeam.Players[1].MDefBonus = 1
		--_DATA.Save.ActiveTeam.Players[1].SpeedBonus = 1
		
	  --audino 
	   -- mon_id = RogueEssence.Dungeon.MonsterID("audino", 0, "normal", Gender.Female)
	  --_DATA.Save.ActiveTeam.Players:Add(_DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 50, "", 0))
	 _DATA.Save.ActiveTeam:SetRank("normal")
	  _DATA.Save:UpdateTeamProfile(true)
	  

	  
		local dungeon_keys = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:GetOrderedKeys(false)
		for ii = 0, dungeon_keys.Count-1 ,1 do
			GAME:UnlockDungeon(dungeon_keys[ii])
		end
	  
	  SV.base_camp.ExpositionComplete = true
	  SV.base_camp.IntroComplete = true
	end 
end




--Reset most variables to their default if they don't exist
--This needs to be upkept whenever I add new variables to the game.
--Yanderedev ftw
function DebugTools:OnUpgrade()
  assert(self, 'DebugTools:OnUpgrade() : self is null!')
  
  PrintInfo("=>> Loading version")

--daily flags
 if SV.DailyFlags.RedMerchantItem == nil then SV.DailyFlags.RedMerchantItem = "" end
 if SV.DailyFlags.RedMerchantBought == nil then SV.DailyFlags.RedMerchantBought = false end
 if SV.DailyFlags.GreenMerchantItem == nil then SV.DailyFlags.GreenMerchantItem = "" end
 if SV.DailyFlags.GreenMerchantBought == nil then SV.DailyFlags.GreenMerchantBought = false end
 if SV.DailyFlags.GreenKecleonRefreshedStock == nil then SV.DailyFlags.GreenKecleonRefreshedStock = false end
 if SV.DailyFlags.GreenKecleonStock == nil then SV.DailyFlags.GreenKecleonStock = {} end
 if SV.DailyFlags.PurpleKecleonRefreshedStock == nil then SV.DailyFlags.PurpleKecleonRefreshedStock = false end
 if SV.DailyFlags.PurpleKecleonStock == nil then SV.DailyFlags.PurpleKecleonStock = {} end

--temporary flags
 if SV.TemporaryFlags.OldDirection == nil then SV.TemporaryFlags.OldDirection = Direction.None end
 if SV.TemporaryFlags.Dinnertime == nil then SV.TemporaryFlags.Dinnertime = false end 
 if SV.TemporaryFlags.Bedtime == nil then SV.TemporaryFlags.Bedtime = false end
 if SV.TemporaryFlags.MorningWakeup == nil then SV.TemporaryFlags.MorningWakeup = false end
 if SV.TemporaryFlags.MorningAddress == nil then SV.TemporaryFlags.MorningAddress = false end 
 if SV.TemporaryFlags.JustWokeUp == nil then SV.TemporaryFlags.JustWokeUp = false end 
 if SV.TemporaryFlags.LastDungeonEntered == nil then SV.TemporaryFlags.LastDungeonEntered = false end
 if SV.TemporaryFlags.MissionCompleted == nil then SV.TemporaryFlags.MissionCompleted = false end
 if SV.TemporaryFlags.PostJobsGround == nil then SV.TemporaryFlags.PostJobsGround = '' end
  

 if SV.metano_cafe.CafeSpecial == nil then SV.metano_cafe.CafeSpecial = -1 end
 if SV.metano_cafe.BoughtSpecial == nil then SV.metano_cafe.BoughtSpecial = false end
 if SV.metano_cafe.FermentedItem == nil then SV.metano_cafe.FermentedItem = "" end
 if SV.metano_cafe.ItemFinishedFermenting == nil then SV.metano_cafe.ItemFinishedFermenting = false end
  
  
 if SV.Dojo.LessonCompletedGeneric == nil then SV.Dojo.LessonCompletedGeneric = false end
 if SV.Dojo.TrainingCompletedGeneric == nil then SV.Dojo.TrainingCompletedGeneric = false end
 if SV.Dojo.TrialCompletedGeneric == nil then SV.Dojo.TrialCompletedGeneric = false end
 if SV.Dojo.LessonFailedGeneric == nil then SV.Dojo.LessonFailedGeneric = false end
 if SV.Dojo.TrainingFailedGeneric == nil then SV.Dojo.TrainingFailedGeneric = false end
 if SV.Dojo.TrialFailedGeneric == nil then SV.Dojo.TrialFailedGeneric = false end
 if SV.Dojo.NewMazeUnlocked == nil then SV.Dojo.NewMazeUnlocked = false end
 if SV.Dojo.NewLessonUnlocked == nil then SV.Dojo.NewLessonUnlocked = false end
 if SV.Dojo.NewTrialUnlocked == nil then SV.Dojo.NewTrialUnlocked = false end
 if SV.Dojo.LastZone == nil then SV.Dojo.LastZone = "master_zone" end
  
  
 if SV.ChapterProgression.DaysPassed == nil then SV.ChapterProgression.DaysPassed = 0 end 
 if SV.ChapterProgression.DaysToReach == nil then SV.ChapterProgression.DaysToReach = -1 end 
 if SV.ChapterProgression.Chapter == nil then SV.ChapterProgression.Chapter = 1 end 
 if SV.ChapterProgression.CurrentStoryDungeon == nil then SV.ChapterProgression.CurrentStoryDungeon = "" end 
 if SV.ChapterProgression.UnlockedAssembly == nil then SV.ChapterProgression.UnlockedAssembly = false end 
 
 --if this is a pre-chapter 3 save, need to initialize chapter 3 in the first place.
 if SV.Chapter3 == nil then SV.Chapter3 = {} end
 
 if SV.Chapter3.ShowedTitleCard == nil then SV.Chapter3.ShowedTitleCard = false end
 if SV.Chapter3.FinishedOutlawIntro == nil then SV.Chapter3.FinishedOutlawIntro = false end
 if SV.Chapter3.MetTeamStyle == nil then SV.Chapter3.MetTeamStyle = false end
 if SV.Chapter3.FinishedCafeCutscene == nil then SV.Chapter3.FinishedCafeCutscene = false end
 if SV.Chapter3.EnteredCavern == nil then SV.Chapter3.EnteredCavern = false end
 if SV.Chapter3.FailedCavern == nil then SV.Chapter3.FailedCavern = false end
 if SV.Chapter3.EncounteredBoss == nil then SV.Chapter3.EncounteredBoss = false end
 if SV.Chapter3.LostToBoss == nil then SV.Chapter3.LostToBoss = false end
 if SV.Chapter3.EscapedBoss == nil then SV.Chapter3.EscapedBoss = false end
 if SV.Chapter3.DefeatedBoss == nil then SV.Chapter3.DefeatedBoss = false end
 if SV.Chapter3.RootSceneTransition == nil then SV.Chapter3.RootSceneTransition = false end
 if SV.Chapter3.FinishedRootScene == nil then SV.Chapter3.FinishedRootScene = false end
 if SV.Chapter3.FinishedMerchantIntro == nil then SV.Chapter3.FinishedMerchantIntro = false end
 if SV.Chapter3.TropiusGaveWand == nil then SV.Chapter3.TropiusGaveWand = false end
 if SV.Chapter3.BreloomGirafarigConvo == nil then SV.Chapter3.BreloomGirafarigConvo = false end
 
 
 --Fix old chapter 2 and before saves that have bad cafe variables
 --Curse you sunkern
 if type(SV.metano_cafe.CafeSpecial) == "number" then SV.metano_cafe.CafeSpecial = -1 SV.metano_cafe.BoughtSpecial = false end
 if type(SV.metano_cafe.FermentedItem) == "number" then SV.metano_cafe.FermentedItem = "" SV.metano_cafe.ItemFinishedFermenting = false end
 
 if SV.DungeonFlags.GenericEnding == nil then SV.DungeonFlags.GenericEnding = false end
 
 --dungeon unlocks that didnt exist for old versions
 if SV.ChapterProgression.Chapter >= 3 and not GAME:DungeonUnlocked("crooked_cavern") then
	GAME:UnlockDungeon("grass_maze")--unlock new mazes at ledian dojo
	GAME:UnlockDungeon("fire_maze")--unlock new mazes at ledian dojo
	GAME:UnlockDungeon("water_maze")--unlock new mazes at ledian dojo
	GAME:UnlockDungeon("crooked_cavern")--unlock chapter 3 dungeon
	SV.Dojo.NewMazeUnlocked = true
end	
 
 --set current story dungeon in case current one is not accurate
 if SV.ChapterProgression.Chapter == 3 then
 	SV.ChapterProgression.CurrentStoryDungeon = "crooked_cavern" -- Crooked Cavern
 end 
 
 if SV.TakenBoard == nil then
	SV.TakenBoard =
	{
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = ""
		},
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = ""
		},	
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = ""
		},	
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = ""
		},	
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = ""
		},	
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = ""
		},
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = ""
		},	
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = ""
		}

	}
	end 
	
	if SV.MissionBoard == nil then
		SV.MissionBoard =
		{
			{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = ""
		},
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = ""
		},	
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = ""
		},	
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = ""
		},	
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = ""
		},	
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = ""
		},
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = ""
		},	
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = ""
		}

	}
	end
	
	if SV.OutlawBoard == nil then
		SV.OutlawBoard =
		{
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = ""
		},
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = ""
		},	
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = ""
		},	
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = ""
		},	
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = ""
		},	
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = ""
		},
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = ""
		},	
		{
			Client = "",
			Target = "",
			Flavor = "",
			Title = "",
			Zone = "",
			Segment = -1,
			Floor = -1,
			Reward = "",
			Type = -1,
			Completion = -1,
			Taken = false,
			Difficulty = "",
			Item = "",
			Special = ""
		}
	}
	end
 
  PrintInfo("=>> Loaded version")
end

--[[---------------------------------------------------------------
    DebugTools:OnLossPenalty()
      Called when the player fails a dungeon in main progress
  ---------------------------------------------------------------]]
function DebugTools:OnLossPenalty(save) 
  assert(self, 'DebugTools:OnLossPenalty() : self is null!')
 
  --remove money. You'll keep 15-25% of what you had 
  local remainder = math.random(1500, 2500) 
  save.ActiveTeam.Money = math.floor((save.ActiveTeam.Money * remainder) / 10000)
 

  local inv_count = save.ActiveTeam:GetInvCount() - 1
  --remove bag items
  for i = inv_count, 0, -1 do
    local entry = _DATA:GetItem(save.ActiveTeam:GetInv(i).ID)
    if not entry.CannotDrop then
		if math.random(1, 4) > 1 then --1/4 chance an individual item will be kept 
			save.ActiveTeam:RemoveFromInv(i)
		end
    end
  end
  
  --DO NOT remove equips
  --local player_count = save.ActiveTeam.Players.Count
  --for i = 0, player_count - 1, 1 do 
  --  local player = save.ActiveTeam.Players[i]
  --  if player.EquippedItem.ID ~= '' and player.EquippedItem.ID ~= nil then 
  --    local entry = _DATA:GetItem(player.EquippedItem.ID)
  --    if not entry.CannotDrop then
  --       player:SilentDequipItem()
  --    end
  --  end
  --end
end



---Summary
-- Subscribe to all channels this service wants callbacks from
function DebugTools:Subscribe(med)
  med:Subscribe("DebugTools", EngineServiceEvents.Init,                function() self.OnInit(self) end )
  med:Subscribe("DebugTools", EngineServiceEvents.Deinit,              function() self.OnDeinit(self) end )
  med:Subscribe("DebugTools", EngineServiceEvents.NewGame,        function() self.OnNewGame(self) end )
  med:Subscribe("DebugTools", EngineServiceEvents.UpgradeSave,        function() self.OnUpgrade(self) end )
  med:Subscribe("DebugTools", EngineServiceEvents.LossPenalty,        function(_, args) self.OnLossPenalty(self, args[0]) end )
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