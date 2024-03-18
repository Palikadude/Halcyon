--[[
    scriptvars.lua
      This file contains all the default values for the script variables. AKA on a new game this file is loaded!
      Script variables are stored in a table  that gets saved when the game is saved.
      Its meant to be used for scripters to add data to be saved and loaded during a playthrough.
      
      You can simply refer to the "SV" global table like any other table in any scripts!
      You don't need to write a default value in this lua script to add a new value.
      However its good practice to set a default value when you can!
      
    --Examples:
    SV.SomeVariable = "Smiles go for miles!"
    SV.AnotherVariable = 2526
    SV.AnotherVariable = { something={somethingelse={} } }
    SV.AnotherVariable = function() print('lmao') end
]]--
print('Loading default script variable values..')
-----------------------------------------------
-- Services Defaults
-----------------------------------------------
SV.Services =
{
  --Anything that applies to services should be put in here, or assigned to this or a subtable of this in the service's definition script
}

-----------------------------------------------
-- General Defaults
-----------------------------------------------
SV.General =
{
  Rescue = nil,
  Starter = MonsterID("missingno", 0, "normal", Gender.Genderless)
  --Anything that applies to more than a single level, and that is too small to make a sub-table for, should be put in here ideally, or a sub-table of this
}

SV.checkpoint = 
{
  Zone    = "master_zone", Structure  = -1,
  Map  = 1, Entry  = 0,
}

--Used for flags relevant for the current dungeon run. Currently just houses whether or not you've stolen from shopkeeps this dungeon run.
SV.adventure = 
{
  Thief    = false
}

SV.partner = 
{
	Spawn = 'Default',
	Dialogue = 'Default',
	LoadPositionX = -1,
	LoadPositionY = -1,
	LoadDirection = -1

}
SV.DestinationFloorNotified = false
SV.MonsterHouseMessageNotified = false
SV.OutlawDefeated = false
SV.OutlawGoonsDefeated = false
SV.MapTurnCounter = -1



--empty string or a -1 indicates that there's nothing there currently.
--board of jobs you've actually taken.
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

--jobs on the mission board.
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

--Jobs on the outlaw board.
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
		Type = 1,
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
		
	



-------------------------------------------------
-- Temporary Flags - Flags that reset at the end of the day or on screen transition are saved here
-------------------------------------------------
--todo, move existing daily flags here
--These flags are to be reset to their initial values at the end of the day.
SV.DailyFlags = 
{
  RedMerchantItem = "",
  RedMerchantBought = false,
  GreenMerchantItem = "",
  GreenMerchantBought = false,
  
  GreenKecleonRefreshedStock = false,
  GreenKecleonStock = {},
  PurpleKecleonRefreshedStock = false,
  PurpleKecleonStock = {}

}

--Generic use flags 
SV.TemporaryFlags = 
{
	OldDirection = Direction.None,--Used for remembering which way an NPC was facing before turning to speak to you
	Dinnertime = false,--used to indicate whether generic dinner cutscene should be played on entering dining room
	Bedtime = false,--used to indicate whether to do a generic bedtime cutscene or not 
	MorningWakeup = false,--used to indicate whether to do a generic morning wakeup call or not when entering the heros room
	MorningAddress = false,--used to indicate whether to do a generic morning address
	JustWokeUp = false,--Did the duo JUST wake up on a new day?
	LastDungeonEntered = '',--Used to mark what dungeon the player was in last. Dojo dungeons don't count.This variable is set by init scripts for relevant zones.
	MissionCompleted = false,--used to mark if there are any pending missions to hand in.
	PostJobsGround = '',--used to mark the ground to go to after handing in randomly generated missions if the default choice of generic dinnertime is not wanted.
	PriorMapSetting = nil,--Used to mark what the player had their minimap setting whenever the game needs to temporarily change it to something else.
	AudinoSummonCount = 0--How many times have you made poor Rin run out for your assembly needs that day?
}


-----------------------------------------------
-- Level Specific Defaults
-----------------------------------------------

--todo: cleanup a lot of these
SV.metano_town = 
{
  Locale = 'Guild',--Where are we on the metano town map? Used for partner dialogue. Defaults to guild
  LastMarker = '',--which locale marker was touched last? we need to unhide it when another is touched.
  Song = 'Treasure Town.ogg'--song being played by the musician
  --LuxioIntro = false,
  --AggronGuided = false,
  --KecIntro = false
}

SV.metano_cafe =
{
  CafeSpecial = "",
  BoughtSpecial = false,
  FermentedItem = "", 
  ItemFinishedFermenting = false,
  
  NewDrinkUnlocked = false--set to true when a new drink is unlocked so Dion knows to let the player know
}


SV.Dojo = 
{
	LessonCompletedGeneric = false,--Player just completed a lesson, should we play a generic cutscene after?
	TrainingCompletedGeneric = false,--Player just completed a training, should we play a generic cutscene after?
	TrialCompletedGeneric = false,--Player just completed a trial, should we play a generic cutscene after?
	
	LessonFailedGeneric = false,--Player just failed a lesson, should we play a generic cutscene after?
	TrainingFailedGeneric = false,--Player just failed a training, should we play a generic cutscene after?
	TrialFailedGeneric = false,--Player just failed a trial, should we play a generic cutscene after?
	
	NewMazeUnlocked = false,--Was a new maze unlocked since the player last spoke to Ledian? If so have her mention that there are new mazes.
	NewLessonUnlocked = false,--Was a new lesson unlocked since the player last spoke to Ledian? If so have her mention that there are new lessons.
	NewTrialUnlocked = false,--Was a new trial unlocked since the player last spoke to Ledian? If so have her mention that there are new trials.
	
	SkippedTutorialNotifiedTeamMode = false,--If the player skips the tutorial, there should be a pop up in normal maze 1F that tells them about team mode. Only tell them about it once, though.
	LastZone = "master_zone"--Which dojo dungeon did the player just come out of?
}


-----------------------------------------------------------------------------
-- Chapter / Cutscenes flags. Flags that control the state of the story are stored here
----------------------------------------------------------------------------


--Keeps track of overall game progression flags (chapter number, important overarching flags, etc)
SV.ChapterProgression = 
{
	DaysPassed = 0,--total number of in game days played in the game
	DaysToReach = -1, --Used to figure out what day needs to be reached to continue the story
	Chapter = 1,
	CurrentStoryDungeon = "",--Used by the Destination Menu when leaving town to the right to know if it needs to set you somewhere else first before going to the dungeon (i.e. for a cutscene outside the dungeon). If the selected dungeon matches this value, then it will try to put you on the relevant ground that is that dungeon's entrance. Note: Relic Forest 1 and Illuminant Riverbed are handled by other objects, and thus aren't ever set to the current story dungeon.
	
	UnlockedAssembly = false--this is set to true when player is allowed to recruit team members, unhides assembly objects
}


SV.Chapter1 = 
{
	PlayedIntroCutscene = false,
	PartnerEnteredForest = false,--Did partner go into the forest yet?
	PartnerCompletedForest = false,--Did partner complete solo run of first dungeon?
	PartnerMetHero = false,--Finished partner meeting hero cutscene in the relic forest?
	TeamCompletedForest = false, --completed backtrack to town?
	TeamJoinedGuild = false,--team officially joined guild? this flag lets you walk around guild without triggering cutscenes to talk to different guildmates

	--these flags mark whether you've talked to your new guild buddies yet. Need to talk to them all to go to sleep and end the chapter.
	MetSnubbull = false,--talked to snubbull?
	MetZigzagoon = false,
	MetCranidosMareep = false,
	MetBreloomGirafarig = false,
	MetAudino = false,
	
	--partner dialogue flag on second floor
	PartnerSecondFloorDialogue = 0,
	TutorialProgression = 0
}

SV.Chapter2 = 
{
	FirstMorningMeetingDone = false,--completed the first morning cutscene with the guild?
	StartedTraining = false,--started the training at ledian dojo?
	SkippedTutorial = false,--chose to do the training maze instead of the tutorial?
	FinishedTraining = false,--finished the preliminary training at ledian dojo?
	FinishedDojoCutscenes = false,--finished the last chapter 2 cutscene in ledian dojo that plays after finishing first maze/lesson?
	FinishedMarketIntro = false,--partner showed the hero the market?
	FinishedNumelTantrum = false,--watched numel's tantrum?
	FinishedFirstDay = false,--finished first day of chapter 2?
	FinishedCameruptRequestScene = false,--finished second morning address cutscene with the guild? (this only plays once, even if you die on the second day)
	
	EnteredRiver = false,--has player and partner attempted the dungeon of the chapter yet? used for a few npcs to mark that a day has passed since the initial request (i.e. you failed at least once)
	FinishedRiver = false,--player and partner have finished the dungeon and made it to Numel?
	
	TropiusGaveReviver = false,--did tropius give the free one off reviver seed?
	WooperIntro = false--talked to the wooper siblings? if not play their little cutscene
}

SV.Chapter3 = 
{
	ShowedTitleCard = false,--Did the generic wakeup for the first day? Need a variable for this due to chapter 3 title card.
	FinishedOutlawIntro = false,--did shuca and ganlon teach you about outlaws?
	MetTeamStyle = false,--did you meet team style?
	FinishedCafeCutscene = false,--did partner point out the cafe's open?
	EnteredCavern = false,--did duo enter the dungeon?
	FailedCavern = false,--did duo die in cavern to either dungeon or the boss?
	EncounteredBoss = false,--did duo find team style in the dungeon yet?
	LostToBoss = false,--did duo die to boss?
	EscapedBoss = false,--due team use an escape orb to escape boss?
	DefeatedBoss = false, --did duo defeat team style?
	RootSceneTransition = false, --Used to remember where in the root scene we are after transitioning away to show the root 
	FinishedRootScene = false, --Showed root scene? This is used to mark the first half of chapter 3 (the non filler portion) as having been completed or not
	FinishedMerchantIntro = false, --Did merchant intro cutscene?
	--DemoThankYou = false,--Showed demo thank you? Not needed for future versions.

	TropiusGaveWand = false,--did tropius give some wands to help the duo?
	BreloomGirafarigConvo = false, --talked to breloom/girafarig about their expedition?
	PostBossSpokeToCranidos = false -- Talked to cranidos in town after beating boss? Used to flag the partner to mention not being able to impress cranidos.
}

SV.Chapter4 = 
{
	ShowedTitleCard = false,--Did the generic wakeup for the first day? Need a variable for this due to chapter 4 title card.
	FinishedFirstAddress = false,--Did you get the address regarding your mission for the chapter and the expedition?
	FinishedAssemblyIntro = false,--did audino teach you about her assembly?
	FinishedSignpostCutscene = false,--Did audino show you her signpost for the assembly by the cafe?
	EnteredGrove = false,--has player set foot at all into the grove yet?
	BacktrackedOutGroveYet = false,--has player ever backtracked out the entrance of the grove yet? if not, give them a cutscene explaining what just happened
	ReachedGlade = false, --has player reached the glade yet?
	FinishedGrove = false,--has player finished the grove for good?
	FinishedBedtimeCutscene = false,--has player watched the bedtime cutscene? this is the last cutscene of this chapter
	
	TropiusGaveAdvice = false,--did you speak with Tropius day one?
	SpokeToRelicanthDayOne = false,--did you speak with relicanth day one?
	HeardRelicanthStory = false,--did you hear with relicanth's story? (TO BE USED ONCE STORY IS CREATED)
	MedichamMachampArgument = false,--did you see machamp and medicham arguing over their mailbox?
	CranidosBlush = false,--did Cranidos accidentally spill the beans on being a softy towards mareep?
	WoopersMedititeConvo = false,--did you see woopers and meditite talk to each other?
	DemoThankYou = false--Showed demo thank you?

}



SV.Chapter5 = 
{
	ShowedTitleCard = false,--Did the generic wakeup for the first day? Need a variable for this due to chapter 5 title card.
	FinishedExpeditionAddress = false,--Did the address about the expedition starting today?
	ReadyForExpedition = false,--Talked to Penticus to ready up for the expedition?
	
	FinishedSteppeIntro = false,--Did the player see the intro cutscene for Vast Steppe?
	EnteredSteppe = false,--did player enter the steppe?
	LostSteppe = false,--did player die in steppe?
	EscapedSteppe = false,--Do we need to play the escaped from dungeon scene when loading this map?
	DiedSteppe = false,--Do we need to play the died in dungeon scene when loading this map?
	SpokeToTropiusSteppe = false,--Did you talk to tropius outside the steppe and get his foreshadowing/deferral?
	
	FinishedTunnelIntro = false,--Did the player see the nighttime+intro cutscene for Searing Tunnel?
	EnteredTunnel = false,--did player enter the tunnel?
	LostTunnel = false,--did player die in the tunnel or to the boss?
	TunnelLastExitReason = '',--Why did the player exit the tunnel to the entrance? Should be Died, Escaped, or Retreated
	PlayTempTunnelScene = false,--Do we need to play a one time scene outside the tunnel for having died/escaped/retreated?
	PlayedMidpointIntro = false,--Did you do the first "Let's go forward!" cutscene for the midpoint?
	TunnelMidpointState = 'FirstArrival',--What scene needs to play, and how do we handle midpoint respawning for almotz and hyko? can be FirstArrival, RepeatArrival, DeathArrival.
	EncounteredBoss = false, --Did the player encounter the slugmas?
	DefeatedBoss = false, --Did the player defeat the slugmas?
	DiedToBoss = false,--Did the player lose to the boss ever?
	JustDiedToBoss = false,--Did the player JUST die to the boss? This is a temporary flag that gets cleared after the boss death cutscene plays.
	SpokeToNoctowlTunnel = false,--Did you get some extra info about Hyko and Penticus's relation from Phileas?
	SpokeToCranidosTunnel = false,--Did you get to see Ganlon trying to be protective of Shuca?
	GrowlitheTropiusBossInterrupt = false,--did Hyko stop you from telling Penticus about the boss?
	
	FinishedMountWindsweptIntro = false,--Did the player see the intro cutscene for Mt. Windswept?
	EnteredMountain = false,--did player enter Mt. Windswept?
	LostMountain = false,--did player die in Mt. Windswept?
	DiedToWind = false,--did player's last run die to the time limit?
	EscapedMountain = false,--Do we need to play the escaped from dungeon scene when loading this map?
	DiedMountain = false,--Do we need to play the died in dungeon scene when loading this map?
	
	NeedGiveSupplies = false--does penticus/phileas need to give supplies out?
}


SV.Chapter6 = 
{

}



--info related to guild member sidequests.
SV.GuildSidequests = 
{
	--Last known levels for guild members. These start being used on the expedition.
	--If you level them up more during the expedition, they'll keep more of their levels when you do stuff with them later.
	ZigzagoonLevel = 19,
	GrowlitheLevel = 16,
	SnubbullLevel = 17,
	AudinoLevel = 16,
	MareepLevel = 19,
	CranidosLevel = 20
--	BreloomLevel = 33,
--	GirafarigLevel = 32
}

----------------------------------
--Dungeon relevant flags 
----------------------------------
SV.DungeonFlags = 
{
	GenericEnding = false--do a generic ending for the end of a dungeon in the relevant zone/ground
}

--For dojo lessons
SV.Tutorial = 
{
	Lesson = "null",
	LastSpeech = "null",--remember which function for a dialogue set was spoken last.
	Progression = 0--a number value that corresponds to how many dialogues Ledian has said so far. Used to remember if ledian said anything already when the floor is reset so she doesn't repeat herself.
}

SV.ApricornGrove = 
{
	InDungeon = false--has character actually left the dungeon run yet? Used to determine what cutscenes to play inside the dungeon entrance/end
}

SV.SearingTunnel = 
{
	LavaFlowDirection = "TopStraight",--TopStraight, BottomStraight, DiagonalDown, DiagonalUp, or None. Defaults to TopStraight as the boss fight starts with the lava spawned straight at the top.
	LavaCountdown = -1,--Used to determine how long until the lava flow changes?
	DiedPastCheckpoint = false--Used to flag whether you died in depths/crucible. Needed for cutscenes on wiping and waking up back in the checkpoint.
}

--to be renamed
SV.ClovenRuins = 
{
	BoulderCountdown = -1--Used to determine when boulder falls should happen and resolve.
}





--base game stuff
SV.test_grounds =
{
  SpokeToPooch = false,
  AcceptedPooch = false,
  Starter = { Species="pikachu", Form=0, Skin="normal", Gender=2 },
  Partner = { Species="eevee", Form=0, Skin="normal", Gender=1 },
  DemoComplete = false,
}

SV.missions =
{
  Missions = { },
  FinishedMissions = { },
}


SV.base_camp = 
{
  IntroComplete    = false,
  ExpositionComplete  = false,
  FirstTalkComplete  = false
}

SV.base_shop = {
	{ Index = "food_apple", Amount = 0, Price = 50},
	{ Index = "food_apple_big", Amount = 0, Price = 150},
	{ Index = "food_banana", Amount = 0, Price = 500},
	{ Index = "food_chestnut", Amount = 0, Price = 80},
	{ Index = "berry_leppa", Amount = 0, Price = 80}
}

SV.base_trades = {
	{ Item="xcl_family_bulbasaur_02", ReqItem={"",""}},
	{ Item="xcl_family_charmander_02", ReqItem={"",""}},
	{ Item="xcl_family_squirtle_02", ReqItem={"",""}}
}

SV.base_town = 
{
  Song    = "1 - Base Town.ogg"
}

SV.forest_camp = 
{
  ExpositionComplete  = false
}

SV.cliff_camp = 
{
  ExpositionComplete  = false,
  TeamRetreatIntro = false
}

SV.canyon_camp = 
{
  ExpositionComplete  = false
}

SV.rest_stop = 
{
  ExpositionComplete  = false
}

SV.final_stop = 
{
  ExpositionComplete  = false
}

SV.guildmaster_summit = 
{
  ExpositionComplete  = false,
  BattleComplete = false
}


----------------------------------------------
print('Script variables default values loaded!')
