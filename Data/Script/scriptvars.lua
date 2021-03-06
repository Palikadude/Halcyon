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
  Rescue = nil
  --Anything that applies to more than a single level, and that is too small to make a sub-table for, should be put in here ideally, or a sub-table of this
}

SV.checkpoint = 
{
  Zone    = 0, Structure  = -1,
  Map  = 1, Entry  = 0,
}

SV.partner = 
{
	Spawn = 'Default',
	Dialogue = 'Default',
	LoadPositionX = -1,
	LoadPositionY = -1,
	LoadDirection = -1

}



-------------------------------------------------
-- Temporary Flags - Flags that reset at the end of the day or on screen transition are saved here
-------------------------------------------------
--todo, move existing daily flags here
--These flags are to be reset to their initial values at the end of the day.
SV.DailyFlags = 
{
  RedMerchantItem = -1,
  RedMerchantBought = false,
  GreenMerchantItem = -1,
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
	JustWokeUp = false--Did the duo JUST wake up on a new day?

}


-----------------------------------------------
-- Level Specific Defaults
-----------------------------------------------

--todo: cleanup a lot of these
SV.metano_town = 
{
  Locale = 'Guild',--Where are we on the metano town map? Used for partner dialogue. Defaults to guild
  LastMarker = ''--which locale marker was touched last? we need to unhide it when another is touched.
  --LuxioIntro = false,
  --AggronGuided = false,
  --KecIntro = false
}

SV.metano_cafe =
{
  CafeSpecial = -1,
  BoughtSpecial = false,
  FermentedItem = 2500, 
  ItemFinishedFermenting = true,
  ExpeditionPreparation = true,
  GaveFreeExpeditionItem = false
}


SV.Dojo = 
{
	LessonCompletedGeneric = false,--Player just completed a lesson, should we play a generic cutscene after?
	TrainingCompletedGeneric = false,--Player just completed a training, should we play a generic cutscene after?
	TrialCompletedGeneric = false,--Player just completed a trial, should we play a generic cutscene after?
	
	LessonFailedGeneric = false,--Player just failed a lesson, should we play a generic cutscene after?
	TrainingFailedGeneric = false,--Player just failed a training, should we play a generic cutscene after?
	TrialFailedGeneric = false,--Player just failed a trial, should we play a generic cutscene after?
	
	LastZone = 0--Which dojo dungeon did the player just come out of?
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




















--base game stuff
SV.test_grounds =
{
  SpokeToPooch = false,
  AcceptedPooch = false
}


SV.base_camp = 
{
  IntroComplete    = false,
  ExpositionComplete  = false,
  FirstTalkComplete  = false
}

SV.base_shop = {
	{ Index = 1, Hidden = 0, Price = 50},
	{ Index = 2, Hidden = 0, Price = 150},
	{ Index = 6, Hidden = 0, Price = 500},
	{ Index = 9, Hidden = 0, Price = 80},
	{ Index = 11, Hidden = 0, Price = 80}
}

SV.base_trades = {
	{ Item=902, ReqItem={-1,-1}},
	{ Item=908, ReqItem={-1,-1}},
	{ Item=914, ReqItem={-1,-1}}
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
