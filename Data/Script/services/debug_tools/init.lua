--[[
    Example Service
    
    This is an example to demonstrate how to use the BaseService class to implement a game service.
    
    **NOTE:** After declaring you service, you have to include your package inside the main.lua file!
]]--
require 'common'
require 'services.baseservice'
require 'mission_gen'
require 'recruit_list'
require 'config'

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
--function DebugTools:__gc()
--  PrintInfo('*****************DebugTools:__gc()')
--end

--[[---------------------------------------------------------------
    DebugTools:OnInit()
      Called on initialization of the script engine by the game!
---------------------------------------------------------------]]
function DebugTools:OnInit()
  assert(self, 'DebugTools:OnInit() : self is null!')
	PrintInfo("\n<!> DebugTools: Init..")
	CONFIG.RegularStarters = true
	CONFIG.UseNicknames = true
	self.checkForMods()
	print("CONFIG.RegularStarters = "..tostring(CONFIG.RegularStarters))
	print("CONFIG.UseNicknames = "..tostring(CONFIG.UseNicknames).."\n")
end

function DebugTools.checkForMods()
	print("\nChecking for Config Mods...")
	for i=0, RogueEssence.PathMod.Mods.Length-1, 1 do
		local mod = RogueEssence.PathMod.Mods[i]
		print("checking: "..mod.Name)
		if mod.Name == "Halcyon All Starters" then
			print("> Starter mode set to \"all\"")
			CONFIG.RegularStarters = false
		elseif mod.Name == "Halcyon No Nickname" then
			print("> Nicknames disabled")
			CONFIG.UseNicknames = false
		else
			print("> No changes required")
		end
	end
end

--[[---------------------------------------------------------------
    DebugTools:OnDeinit()
      Called on de-initialization of the script engine by the game!
---------------------------------------------------------------]]
function DebugTools:OnDeinit()
  assert(self, 'DebugTools:OnDeinit() : self is null!')
  PrintInfo("\n<!> DebugTools: Deinit..")
end

--[[---------------------------------------------------------------
    DebugTools:OnMenuButtonPressed()
      When the main menu button is pressed or the main menu should be enabled this is called!
      This is called as a coroutine.
---------------------------------------------------------------]]
function DebugTools:OnMenuButtonPressed()
  if DebugTools.MainMenu == nil then
    DebugTools.MainMenu = RogueEssence.Menu.MainMenu()
  end
  
  DebugTools.MainMenu:SetupChoices()
  
  --Halcyon custom menu stuff for jobs. 
  --Check if we're in a dungeon or not. Only do main menu changes outside of a dungeon. Do others menu changes in dungeon only.
  if RogueEssence.GameManager.Instance.CurrentScene == RogueEssence.Dungeon.DungeonScene.Instance then
    DebugTools.MainMenu.Choices:RemoveAt(5)
    DebugTools.MainMenu.Choices:Insert(5, RogueEssence.Menu.MenuTextChoice("Others", function () _MENU:AddMenu(DebugTools:CustomDungeonOthersMenu(), false) end))
  else--not in a dungeon 
	--Add Job List option
	local taken_count = MISSION_GEN.GetTakenCount()
	local job_list_color = Color.Red
	if taken_count > 0 then
		job_list_color = Color.White
	end 
	
	DebugTools.MainMenu.Choices:Insert(4, RogueEssence.Menu.MenuTextChoice("Job List", function () _MENU:AddMenu(BoardMenu:new(COMMON.MISSION_BOARD_TAKEN, nil, DebugTools.MainMenu).menu, false) end, taken_count > 0, job_list_color))
 
	--Add rank/points to go 
	--local level_length = RogueEssence.Content.GraphicsManager.TextFont.SubstringWidth(STRINGS:FormatKey("MENU_TEAM_LEVEL_SHORT") .. tostring(RogueEssence.Data.DataManager.Instance.Start.MaxLevel))
	--local hp_length = RogueEssence.Content.GraphicsManager.TextFont.SubstringWidth(STRINGS:FormatKey("MENU_TEAM_HP") .. " {999}/{999}")
	--local hunger_length = RogueEssence.Content.GraphicsManager.TextFont.SubstringWidth(STRINGS:FormatKey("MENU_TEAM_HUNGER") .. " {Character.MAX_FULLNESS}/{Character.MAX_FULLNESS}");

	--local rankStart = RogueEssence.Content.GraphicsManager.MenuBG.TileWidth + 4 + DebugTools.NicknameMenu.MAX_LENGTH + level_length + hp_length + remaining_width				
	--local remaining_width = DebugTools.MainMenu.SummaryMenuBounds.End.X - DebugTools.MainMenu.SummaryMenuBounds.X - (RogueEssence.Content.GraphicsManager.MenuBG.TileWidth + 4) * 2 - level_length - hp_length - hunger_length - DebugTools.NicknameMenu.MAX_LENGTH


  end
 
  DebugTools.MainMenu:SetupTitleAndSummary()
  
  --need to do this after setting up title and summary
  --Add rank/points to go in overworld
  if RogueEssence.GameManager.Instance.CurrentScene ~= RogueEssence.Dungeon.DungeonScene.Instance then
  	local rank = _DATA.Save.ActiveTeam.Rank
	local to_go = _DATA:GetRank(rank).FameToNext - _DATA.Save.ActiveTeam.Fame 
	rank = "[color=#FFA5FF]" .. rank:gsub("^%l", string.upper) .. "[color]"
	
	-- -1 to go represents max rank
	if to_go < 0 then
		to_go = "Maxed!"
	end
	
	to_go = "[color=#00FFFF]" .. to_go .. "[color]"
  
    DebugTools.MainMenu.SummaryElements:Add(RogueEssence.Menu.MenuText("Rank: " .. rank,
											RogueElements.Loc(104, RogueEssence.Content.GraphicsManager.MenuBG.TileHeight), RogueElements.DirH.Left))
	
  	DebugTools.MainMenu.SummaryElements:Add(RogueEssence.Menu.MenuText("To go: " .. to_go,
                    RogueElements.Loc(206, RogueEssence.Content.GraphicsManager.MenuBG.TileHeight), RogueElements.DirH.Left))
  end
  
  DebugTools.MainMenu:InitMenu()
  TASK:WaitTask(_MENU:ProcessMenuCoroutine(DebugTools.MainMenu))
end



function DebugTools:CustomDungeonOthersMenu()
    local menu = RogueEssence.Menu.OthersMenu()
    menu:SetupChoices();
	if RogueEssence.GameManager.Instance.CurrentScene == RogueEssence.Dungeon.DungeonScene.Instance then
		menu.Choices:Add(RogueEssence.Menu.MenuTextChoice("Mission Objectives", function () _MENU:AddMenu(DungeonJobList:new().menu, false) end))
		-- add recruitment search menu only if assembly is unlocked
		if SV.Chapter4 and SV.Chapter4.FinishedAssemblyIntro then
			menu.Choices:Add(RogueEssence.Menu.MenuTextChoice(RogueEssence.StringKey("MENU_RECRUITMENT"):ToLocal(), function () _MENU:AddMenu(RecruitmentListMenu:new().menu, false) end))
		end
	end
	menu:InitMenu();
    return menu
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

	  
	  local mon_id = RogueEssence.Dungeon.MonsterID("turtwig", 0, "normal", Gender.Male)
	  local p = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 100, "", 0)
	  local tbl = LTBL(p)
	  tbl.Importance = 'Hero'
	  p.IsFounder = true
	  p.IsPartner = true
	  p.Nickname = 'Palika'
	  _DATA.Save.ActiveTeam.Players:Add(p)
	  
	  mon_id = RogueEssence.Dungeon.MonsterID("piplup", 0, "normal", Gender.Male)
	  p = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 100, "", 0)
	  tbl = LTBL(p)
	  tbl.Importance = 'Partner'
	  p.IsFounder = true
	  p.IsPartner = true
	  p.Nickname = 'Genshi'
	  _DATA.Save.ActiveTeam.Players:Add(p)
	  
	  _DATA.Save.ActiveTeam:SetRank("bronze")

	  talk_evt = RogueEssence.Dungeon.BattleScriptEvent("HeroInteract")
	  _DATA.Save.ActiveTeam.Players[0].ActionEvents:Add(talk_evt)
	  talk_evt = RogueEssence.Dungeon.BattleScriptEvent("PartnerInteract")
	  _DATA.Save.ActiveTeam.Players[1].ActionEvents:Add(talk_evt)
	  
	  mon_id = RogueEssence.Dungeon.MonsterID("growlithe", 0, "normal", Gender.Male)
	  _DATA.Save.ActiveTeam.Players:Add(_DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 100, "", 0))
	  _DATA.Save.ActiveTeam.Players[2].Nickname = 'Hyko'
	  
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
	  mon_id = RogueEssence.Dungeon.MonsterID("zigzagoon", 0, "normal", Gender.Female)
	  _DATA.Save.ActiveTeam.Players:Add(_DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id,100, "", 0))
	  _DATA.Save.ActiveTeam.Players[3].Nickname = 'Almotz'
	  _DATA.Save.ActiveTeam:SetRank("normal")
	  _DATA.Save:UpdateTeamProfile(true)
	  

		GAME:GivePlayerItem('seed_reviver')	  
		GAME:GivePlayerItem('seed_reviver')	  
		GAME:GivePlayerItem('seed_reviver')	  
		
		
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
 if SV.TemporaryFlags.LastDungeonEntered == nil then SV.TemporaryFlags.LastDungeonEntered = '' end
 if SV.TemporaryFlags.MissionCompleted == nil then SV.TemporaryFlags.MissionCompleted = false end
 if SV.TemporaryFlags.PostJobsGround == nil then SV.TemporaryFlags.PostJobsGround = '' end
 if SV.TemporaryFlags.AudinoSummonCount == nil then SV.TemporaryFlags.AudinoSummonCount = 0 end
 
 
 if SV.adventure == nil then SV.adventure = {} end
 if SV.adventure.Thief == nil then SV.adventure.Thief = false end
  

 if SV.metano_cafe.CafeSpecial == nil then SV.metano_cafe.CafeSpecial = "" end
 if SV.metano_cafe.BoughtSpecial == nil then SV.metano_cafe.BoughtSpecial = false end
 if SV.metano_cafe.FermentedItem == nil then SV.metano_cafe.FermentedItem = "" end
 if SV.metano_cafe.ItemFinishedFermenting == nil then SV.metano_cafe.ItemFinishedFermenting = false end
 if SV.metano_cafe.NewDrinkUnlocked == nil then SV.metano_cafe.NewDrinkUnlocked = false end
  
  
 if SV.Dojo.LessonCompletedGeneric == nil then SV.Dojo.LessonCompletedGeneric = false end
 if SV.Dojo.TrainingCompletedGeneric == nil then SV.Dojo.TrainingCompletedGeneric = false end
 if SV.Dojo.TrialCompletedGeneric == nil then SV.Dojo.TrialCompletedGeneric = false end
 if SV.Dojo.LessonFailedGeneric == nil then SV.Dojo.LessonFailedGeneric = false end
 if SV.Dojo.TrainingFailedGeneric == nil then SV.Dojo.TrainingFailedGeneric = false end
 if SV.Dojo.TrialFailedGeneric == nil then SV.Dojo.TrialFailedGeneric = false end
 if SV.Dojo.NewMazeUnlocked == nil then SV.Dojo.NewMazeUnlocked = false end
 if SV.Dojo.NewLessonUnlocked == nil then SV.Dojo.NewLessonUnlocked = false end
 if SV.Dojo.NewTrialUnlocked == nil then SV.Dojo.NewTrialUnlocked = false end
 if SV.Dojo.SkippedTutorialNotifiedTeamMode == nil then SV.Dojo.SkippedTutorialNotifiedTeamMode = false end
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
-- if SV.Chapter3.DemoThankYou == nil then SV.Chapter3.DemoThankYou = false end
 if SV.Chapter3.TropiusGaveWand == nil then SV.Chapter3.TropiusGaveWand = false end
 if SV.Chapter3.BreloomGirafarigConvo == nil then SV.Chapter3.BreloomGirafarigConvo = false end
 if SV.Chapter3.PostBossSpokeToCranidos == nil then SV.Chapter3.PostBossSpokeToCranidos = false end
 
 
 --for pre-chapter 4 saves
 if SV.Chapter4 == nil then SV.Chapter4 = {} end

 if SV.Chapter4.ShowedTitleCard == nil then SV.Chapter4.ShowedTitleCard = false end
 if SV.Chapter4.FinishedFirstAddress == nil then SV.Chapter4.FinishedFirstAddress = false end
 if SV.Chapter4.FinishedAssemblyIntro == nil then SV.Chapter4.FinishedAssemblyIntro = false end
 if SV.Chapter4.FinishedSignpostCutscene == nil then SV.Chapter4.FinishedSignpostCutscene = false end
 if SV.Chapter4.EnteredGrove == nil then SV.Chapter4.EnteredGrove = false end
 if SV.Chapter4.BacktrackedOutGroveYet == nil then SV.Chapter4.BacktrackedOutGroveYet = false end
 if SV.Chapter4.ReachedGlade == nil then SV.Chapter4.ReachedGlade = false end
 if SV.Chapter4.FinishedGrove == nil then SV.Chapter4.FinishedGrove = false end
 if SV.Chapter4.FinishedFirstAddress == nil then SV.Chapter4.FinishedFirstAddress = false end
 if SV.Chapter4.FinishedBedtimeCutscene == nil then SV.Chapter4.FinishedBedtimeCutscene = false end
 if SV.Chapter4.TropiusGaveAdvice == nil then SV.Chapter4.TropiusGaveAdvice = false end
 if SV.Chapter4.SpokeToRelicanthDayOne == nil then SV.Chapter4.SpokeToRelicanthDayOne = false end
 if SV.Chapter4.HeardRelicanthStory == nil then SV.Chapter4.HeardRelicanthStory = false end
 if SV.Chapter4.MedichamMachampArgument == nil then SV.Chapter4.MedichamMachampArgument = false end
 if SV.Chapter4.CranidosBlush == nil then SV.Chapter4.CranidosBlush = false end
 if SV.Chapter4.WoopersMedititeConvo == nil then SV.Chapter4.WoopersMedititeConvo = false end
 if SV.Chapter4.DemoThankYou == nil then SV.Chapter4.DemoThankYou = false end

 if SV.ApricornGrove == nil then SV.ApricornGrove = {} end
 
 if SV.ApricornGrove.InDungeon == nil then SV.ApricornGrove.InDungeon = false end
 
 
 --for pre chapter 5 saves
 if SV.Chapter5 == nil then SV.Chapter5 = {} end
 
 if SV.Chapter5.ShowedTitleCard == nil then SV.Chapter5.ShowedTitleCard = false end
 if SV.Chapter5.FinishedExpeditionAddress == nil then SV.Chapter5.FinishedExpeditionAddress = false end
 if SV.Chapter5.ReadyForExpedition == nil then SV.Chapter5.ReadyForExpedition = false end
 if SV.Chapter5.FinishedSteppeIntro == nil then SV.Chapter5.FinishedSteppeIntro = false end
 if SV.Chapter5.EnteredSteppe == nil then SV.Chapter5.EnteredSteppe = false end
 if SV.Chapter5.LostSteppe == nil then SV.Chapter5.LostSteppe = false end
 if SV.Chapter5.EscapedSteppe == nil then SV.Chapter5.EscapedSteppe = false end
 if SV.Chapter5.DiedSteppe == nil then SV.Chapter5.DiedSteppe = false end
 if SV.Chapter5.SpokeToTropiusSteppe == nil then SV.Chapter5.SpokeToTropiusSteppe = false end
 if SV.Chapter5.FinishedTunnelIntro == nil then SV.Chapter5.FinishedTunnelIntro = false end
 if SV.Chapter5.EnteredTunnel == nil then SV.Chapter5.EnteredTunnel = false end
 if SV.Chapter5.LostTunnel == nil then SV.Chapter5.LostTunnel = false end
 if SV.Chapter5.TunnelLastExitReason == nil then SV.Chapter5.TunnelLastExitReason = '' end
 if SV.Chapter5.PlayTempTunnelScene == nil then SV.Chapter5.PlayTempTunnelScene = false end
 if SV.Chapter5.PlayedMidpointIntro == nil then SV.Chapter5.PlayedMidpointIntro = false end
 if SV.Chapter5.TunnelMidpointState == nil then SV.Chapter5.TunnelMidpointState = 'FirstArrival' end
 if SV.Chapter5.EncounteredBoss == nil then SV.Chapter5.EncounteredBoss = false end
 if SV.Chapter5.DefeatedBoss == nil then SV.Chapter5.DefeatedBoss = false end
 if SV.Chapter5.DiedToBoss == nil then SV.Chapter5.DiedToBoss = false end
 if SV.Chapter5.JustDiedToBoss == nil then SV.Chapter5.JustDiedToBoss = false end
 if SV.Chapter5.SpokeToNoctowlTunnel == nil then SV.Chapter5.SpokeToNoctowlTunnel = false end
 if SV.Chapter5.FinishedMountWindsweptIntro == nil then SV.Chapter5.FinishedMountWindsweptIntro = false end
 if SV.Chapter5.EnteredMountain == nil then SV.Chapter5.EnteredMountain = false end
 if SV.Chapter5.LostMountain == nil then SV.Chapter5.LostMountain = false end
 if SV.Chapter5.DiedToWind == nil then SV.Chapter5.DiedToWind = false end
 if SV.Chapter5.EscapedMountain == nil then SV.Chapter5.EscapedMountain = false end
 if SV.Chapter5.DiedMountain == nil then SV.Chapter5.DiedMountain = false end
 if SV.Chapter5.NeedGiveSupplies == nil then SV.Chapter5.NeedGiveSupplies = false end
 
 

 --for terrakion's dungeon boulder variable timer
 if SV.ClovenRuins == nil then SV.ClovenRuins = {} end
 
 if SV.ClovenRuins.BoulderCountdown == nil then SV.ClovenRuins.BoulderCountdown = -1 end
 
 --For Searing Tunnel's boss fight
 if SV.SearingTunnel == nil then SV.SearingTunnel = {} end
 
 if SV.SearingTunnel.DiedPastCheckpoint == nil then SV.SearingTunnel.DiedPastCheckpoint = false end
 if SV.SearingTunnel.LavaFlowDirection == nil then SV.SearingTunnel.LavaFlowDirection = 'TopStraight' end
 if SV.SearingTunnel.LavaCountdown == nil then SV.SearingTunnel.LavaCountdown = -1 end
 
 if SV.GuildSidequests == nil then SV.GuildSidequests = {} end
 
 if SV.GuildSidequests.ZigzagoonLevel == nil then SV.GuildSidequests.ZigzagoonLevel = 19 end 
 if SV.GuildSidequests.GrowlitheLevel == nil then SV.GuildSidequests.GrowlitheLevel = 16 end 
 if SV.GuildSidequests.SnubbullLevel == nil then SV.GuildSidequests.SnubbullLevel = 17 end 
 if SV.GuildSidequests.AudinoLevel == nil then SV.GuildSidequests.AudinoLevel = 16 end 
 if SV.GuildSidequests.MareepLevel == nil then SV.GuildSidequests.MareepLevel = 19 end 
 if SV.GuildSidequests.CranidosLevel == nil then SV.GuildSidequests.CranidosLevel = 20 end 
 --if SV.GuildSidequests.BreloomLevel == nil then SV.GuildSidequests.BreloomLevel = 33 end 
 --if SV.GuildSidequests.GirafarigLevel == nil then SV.GuildSidequests.GirafarigLevel = 32 end 
 
 
 if SV.adventure == nil then SV.adventure = {} end 
 if SV.adventure.Thief == nil then SV.adventure.Thief = false end
 
  --Fix old chapter 2 and before saves that have bad cafe variables
 --Curse you sunkern
 if type(SV.metano_cafe.CafeSpecial) == "number" then SV.metano_cafe.CafeSpecial = "" SV.metano_cafe.BoughtSpecial = false end
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
 if SV.ChapterProgression.Chapter == 3 and not SV.Chapter3.DefeatedBoss then
 	SV.ChapterProgression.CurrentStoryDungeon = "crooked_cavern" -- Crooked Cavern
 end 
 
 
 if SV.DestinationFloorNotified == nil then SV.DestinationFloorNotified = false end
 if SV.MonsterHouseMessageNotified == nil then SV.MonsterHouseMessageNotified = false end
 if SV.OutlawDefeated == nil then SV.OutlawDefeated = false end
 if SV.OutlawGoonsDefeated == nil then SV.OutlawGoonsDefeated = false end
 if SV.OutlawItemPickedUp == nil then SV.OutlawItemPickedUp = false end

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
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = "",
			BackReference = -1
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
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = "",
			BackReference = -1
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
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = "",
			BackReference = -1
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
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = "",
			BackReference = -1
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
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = "",
			BackReference = -1
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
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = "",
			BackReference = -1
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
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = "",
			BackReference = -1
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
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = "",
			BackReference = -1
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
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = ""
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
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = ""
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
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = ""
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
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = ""
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
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = ""
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
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = ""
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
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = ""
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
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = ""
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
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = ""
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
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = ""
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
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = ""
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
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = ""
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
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = ""
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
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = ""
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
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = ""
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
			Special = "",
			ClientGender = -1,
			TargetGender = -1,
			BonusReward = ""
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
 
  --remove money. You'll keep 15-25% of what you had. Thieves keep nothing
  local remainder = math.random(1500, 2500) 
  if SV.adventure.Thief then remainder = 0 end
  save.ActiveTeam.Money = math.floor((save.ActiveTeam.Money * remainder) / 10000)
 

  local inv_count = save.ActiveTeam:GetInvCount() - 1
  --remove bag items
  for i = inv_count, 0, -1 do
    local entry = _DATA:GetItem(save.ActiveTeam:GetInv(i).ID)
    if not entry.CannotDrop then
		if math.random(1, 4) > 1 or SV.adventure.Thief then --1/4 chance an individual item will be kept. Thieves keep NOTHING
			save.ActiveTeam:RemoveFromInv(i)
		end
    end
  end
  
  --DO NOT remove equips unless the player was a thief
  
  if SV.adventure.Thief then
    local player_count = save.ActiveTeam.Players.Count
	for i = 0, player_count - 1, 1 do 
	  local player = save.ActiveTeam.Players[i]
	  if player.EquippedItem.ID ~= '' and player.EquippedItem.ID ~= nil then 
		local entry = _DATA:GetItem(player.EquippedItem.ID)
		if not entry.CannotDrop then
		  player:SilentDequipItem()
		end
	  end
    end
  end
  
end

-- function DebugTools:OnDungeonMapInit(mapname, mapobj)
-- 	if GAME:GetPlayerPartyCount() > 1 and GeneralFunctions.TableContains(MISSION_GEN.DUNGEON_LIST, _ZONE.CurrentZoneID) then
-- 		local partner = GAME:GetPlayerPartyMember(1)
-- 		local tbl = LTBL(partner)
-- 		if tbl.MissionType == COMMON.MISSION_BOARD_OUTLAW then
-- 			local origin = _DATA.Save.ActiveTeam.Leader.CharLoc
-- 			local radius = 2
-- 			local mission_num = tbl.MissionNumber
-- 			SpawnOutlaw(origin, radius, mission_num)
-- 		end
-- 	end
-- end

---Summary
-- Subscribe to all channels this service wants callbacks from
function DebugTools:Subscribe(med)
  med:Subscribe("DebugTools", EngineServiceEvents.Init,                function() self.OnInit(self) end )
  med:Subscribe("DebugTools", EngineServiceEvents.Deinit,              function() self.OnDeinit(self) end )
  med:Subscribe("DebugTools", EngineServiceEvents.MenuButtonPressed,        function() self.OnMenuButtonPressed() end )
  med:Subscribe("DebugTools", EngineServiceEvents.NewGame,        function() self.OnNewGame(self) end )
  med:Subscribe("DebugTools", EngineServiceEvents.UpgradeSave,        function() self.OnUpgrade(self) end )
  med:Subscribe("DebugTools", EngineServiceEvents.LossPenalty,        function(_, args) self.OnLossPenalty(self, args[0]) end )
	-- med:Subscribe("DebugTools", EngineServiceEvents.DungeonMapInit,        function(_, args) self.OnDungeonMapInit(self, args[0], args[1]) end )
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