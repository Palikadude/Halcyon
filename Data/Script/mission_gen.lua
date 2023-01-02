require 'common'

--Halcyon Custom work:
--Code in this folder is used to generate, display, and handle randomized missions
--and all that goes with that (rewards, rankups, etc)


--A job is saved as a list of variables, where each variable represents an attribute of the job, such as reward, client, destination floor, etc.
--There are 3 sets of lua lists then. One for the missions taken, one for the missions on the job board, and one for the missions on the outlaw board.
--Each of those lists can only have up to 8 jobs.

--List of mission attributes:
--Client (the pokemon in need of escort, rescue, or the person asking for an outlaw capture). Given as species string
--Target (Pokemon in need of rescue, or the one to escort to, or the mon to be arrested). Given as species string
--Escort Species - should be given as a blank if this is not an escort mission.
--Zone (dungeon)
--Segment (part of the dungeon) - this is typically the default segment
--Floor 
--Reward - given as item name's string. If money, should be given as "Money" and the amount will be based off the difficulty.
--Mission Type - outlaw, escort, or rescue
--Completion status - Incomplete or Complete. When a reward is handed out at the end of the day, any missions that are completed should be removed from the taken board.
--Taken - Was the mission on the board taken? This is also used to suspend missions that were taken off the board
--Difficulty - Letter rank that are hardcoded to represent certain number amounts
--Flavor - Flavor text for the mission, should be a string in strings.resx that can potentially be filled in by blanks.


--Hardcoded number values. Adjust those sorts of things here.
--Difficulty's point ranks
MISSION_GEN = {}

MISSION_GEN.DIFFICULTY = {}
MISSION_GEN.DIFFICULTY[""] = 0
MISSION_GEN.DIFFICULTY["F"] = 0
MISSION_GEN.DIFFICULTY["E"] = 10
MISSION_GEN.DIFFICULTY["D"] = 15
MISSION_GEN.DIFFICULTY["C"] = 20
MISSION_GEN.DIFFICULTY["B"] = 30
MISSION_GEN.DIFFICULTY["A"] = 50
MISSION_GEN.DIFFICULTY["S"] = 70

--dungeon's assigned difficulty
MISSION_GEN.DUNGEON_DIFFICULTY = {}
MISSION_GEN.DUNGEON_DIFFICULTY[""] = "F"--just in case lul
MISSION_GEN.DUNGEON_DIFFICULTY["relic_forest"] = "E"--missions shouldn't be given for relic forest 
MISSION_GEN.DUNGEON_DIFFICULTY["illuminant_riverbed"] = "D"
MISSION_GEN.DUNGEON_DIFFICULTY["crooked_cavern"] = "C"


--order of difficulties. 
MISSION_GEN.DIFF_TO_ORDER = {}
MISSION_GEN.DIFF_TO_ORDER[""] = 1
MISSION_GEN.DIFF_TO_ORDER["F"] = 2
MISSION_GEN.DIFF_TO_ORDER["E"] = 3
MISSION_GEN.DIFF_TO_ORDER["D"] = 4
MISSION_GEN.DIFF_TO_ORDER["C"] = 5
MISSION_GEN.DIFF_TO_ORDER["B"] = 6
MISSION_GEN.DIFF_TO_ORDER["A"] = 7
MISSION_GEN.DIFF_TO_ORDER["S"] = 8

--use this to get back from above.
MISSION_GEN.ORDER_TO_DIFF = {"", "F", "E", "D", "C", "B", "A", "S"}

--mapping of difficulty to reward amounts for money
MISSION_GEN.DIFF_TO_MONEY = {}
MISSION_GEN.DIFF_TO_MONEY[""] = 0
MISSION_GEN.DIFF_TO_MONEY["F"] = 0
MISSION_GEN.DIFF_TO_MONEY["E"] = 100
MISSION_GEN.DIFF_TO_MONEY["D"] = 150
MISSION_GEN.DIFF_TO_MONEY["C"] = 200
MISSION_GEN.DIFF_TO_MONEY["B"] = 250
MISSION_GEN.DIFF_TO_MONEY["A"] = 300
MISSION_GEN.DIFF_TO_MONEY["S"] = 350

MISSION_GEN.COMPLETE = 1
MISSION_GEN.INCOMPLETE = 0

--pokemon to choose from for missions
MISSION_GEN.POKEMON = 
	{"caterpie", "metapod", "butterfree", "weedle", "kakuna", "beedrill"}


--Weighted list of rewards to choose from for missions
MISSION_GEN.REWARDS = {
	{"money", 50},
	{"food_apple", 50}
}


--"order" of dungeons
MISSION_GEN.DUNGEON_ORDER = {}
MISSION_GEN.DUNGEON_ORDER[""] = 99999--empty missions should get shoved towards the end 
MISSION_GEN.DUNGEON_ORDER["relic_forest"] = 1
MISSION_GEN.DUNGEON_ORDER["illuminant_riverbed"] = 2
MISSION_GEN.DUNGEON_ORDER["crooked_cavern"] = 3



--Do the stairs go up or down? Blank string if up, B if down
MISSION_GEN.STAIR_TYPE = {}
MISSION_GEN.STAIR_TYPE[""] = ""
MISSION_GEN.STAIR_TYPE["relic_forest"] = ""
MISSION_GEN.STAIR_TYPE["illuminant_riverbed"] = ""
MISSION_GEN.STAIR_TYPE["crooked_cavern"] = "B"




function MISSION_GEN.WeightedRandom (weights)
    local summ = 0
    for i, value in pairs (weights) do
        summ = summ + value[2]
    end
    if summ == 0 then return end
    -- local value = math.random (summ) -- for integer weights only
    local rand = summ*math.random ()
    summ = 0
    for i, value in pairs (weights) do
        summ = summ + value[2]
        if rand <= summ then
            return value[1]--, weight
        end
    end
end


function MISSION_GEN.has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end



function MISSION_GEN.ResetBoards()
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
		Type = "",
		Completion = -1,
		Taken = false,
		Difficulty = ""
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
		Type = "",
		Completion = -1,
		Taken = false,
		Difficulty = ""
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
		Type = "",
		Completion = -1,
		Taken = false,
		Difficulty = ""
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
		Type = "",
		Completion = -1,
		Taken = false,
		Difficulty = ""
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
		Type = "",
		Completion = -1,
		Taken = false,
		Difficulty = ""
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
		Type = "",
		Completion = -1,
		Taken = false,
		Difficulty = ""
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
		Type = "",
		Completion = -1,
		Taken = false,
		Difficulty = ""
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
		Type = "",
		Completion = -1,
		Taken = false,
		Difficulty = ""
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
		Type = "",
		Completion = -1,
		Taken = false,
		Difficulty = ""
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
		Type = "",
		Completion = -1,
		Taken = false,
		Difficulty = ""
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
		Type = "",
		Completion = -1,
		Taken = false,
		Difficulty = ""
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
		Type = "",
		Completion = -1,
		Taken = false,
		Difficulty = ""
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
		Type = "",
		Completion = -1,
		Taken = false,
		Difficulty = ""
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
		Type = "",
		Completion = -1,
		Taken = false,
		Difficulty = ""
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
		Type = "",
		Completion = -1,
		Taken = false,
		Difficulty = ""
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
		Type = "",
		Completion = -1,
		Taken = false,
		Difficulty = ""
	}
}

end

--Generate a board. Board_type should be given as "Mission" or "Outlaw".
--Job/Outlaw Boards should be cleared before being regenerated.
function MISSION_GEN.GenerateBoard(board_type)
	local jobs_to_make = math.random(5, 8)--Todo: jobs generated is based on your rank or how many dungeons you've done.
	local assigned_combos = {}--floor/dungeon combinations that already have had missions genned for it. Need to consider already genned missions and missions on taken board.
	
	--default to mission.
	local mission_type = "Mission"
	if board_type == "Outlaw" then mission_type = "Outlaw" end
	
	--todo: figures out dungeons based on what you've completed, minus certain ones like dojo dungeons and relic forest.
	local dungeon_list = {"illuminant_riverbed", "crooked_cavern"}
	
	--generate jobs
	for i = 1, jobs_to_make, 1 do 
		--choose a dungeon, client, target, etc
		local dungeon = dungeon_list[math.random(1, #dungeon_list)]
		local client = MISSION_GEN.POKEMON[math.random(1, #MISSION_GEN.POKEMON)]

		
		--generate the objective. 10% chance of escort vs rescue.
		local objective 
		if mission_type == "Outlaw" then 
			objective = COMMON.MISSION_TYPE_OUTLAW
		else
			if math.random(1, 10) == 1 then 
				--if there's already an escort mission generated for this dungeon, don't gen another one and just make it a rescue.
				objective = COMMON.MISSION_TYPE_ESCORT 
				--only check from 1 to i-1 to save time.
				for j = 1, i-1, 1 do 
					if SV.MissionBoard[j].Zone == dungeon and SV.MissionBoard[j].Type == COMMON.MISSION_TYPE_ESCORT then
						objective = COMMON.MISSION_TYPE_RESCUE
						break
					end 
				end 
				
				for j = 1, 8, 1 do
					if SV.TakenBoard[j].Zone == dungeon and SV.TakenBoard[j].Type == COMMON.MISSION_TYPE_ESCORT then
						objective = COMMON.MISSION_TYPE_RESCUE
						break
					end
				end
			else 
				objective = COMMON.MISSION_TYPE_RESCUE
			end
		end
		
		
		--50% chance that the client and target are the same. Target is the escort if its an escort mission.
		--It is possible for this to roll the same target as the client again, which is fine.
		--Always give a target if objective is escort.
		local target = client
		if math.random(1, 2) == 1 or objective == COMMON.MISSION_TYPE_ESCORT then 
			target = MISSION_GEN.POKEMON[math.random(1, #MISSION_GEN.POKEMON)]
		end
		
		--if its an outlaw mission, 50% chance client is Zhayn. Otherwise, someone different than the target.
		--It is possible for this to roll the same target as the client again, which is fine.
		if objective == COMMON.MISSION_TYPE_OUTLAW then
			if math.random(1, 2) == 1 then
				client = "zhayn"
			else
				client = MISSION_GEN.POKEMON[math.random(1, #MISSION_GEN.POKEMON)]
			end
		end
		
		--up the difficulty by 1 if its an outlaw or escort mission.
		local difficulty = MISSION_GEN.DUNGEON_DIFFICULTY[dungeon]
		if objective == COMMON.MISSION_TYPE_ESCORT or objective == COMMON.MISSION_TYPE_OUTLAW then
				difficulty = MISSION_GEN.ORDER_TO_DIFF[MISSION_GEN.DIFF_TO_ORDER[difficulty]+1]
		end
		
		--should pretty much always be in segment 0 for missions
		local segment = 0
		
		--generate reward with hardcoded list of weighted rewards
		local reward = MISSION_GEN.WeightedRandom(MISSION_GEN.REWARDS)
		
		--get the zone, and max floors (counted floors of relevant segments)
		local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get(dungeon)
		
		
		--todo
		local flavor = "Flavor text.\nI love the sweet, succulent flavor text!"
		

		--todo
		local title = "I need help!"

		
		--mission floor should be in last 45% of the dungeon
		--don't pick a floor that's already been chosen for another mission in a dungeon
		
		
		local used_floors = {}
		for j = 1, 8, 1 do 
			if SV.OutlawBoard[j].Zone == dungeon then
				table.insert(used_floors, 1, SV.OutlawBoard[j].Floor)
			end
			if SV.MissionBoard[j].Zone == dungeon then
				table.insert(used_floors, 1, SV.MissionBoard[j].Floor)
			end
			if SV.TakenBoard[j].Zone == dungeon then
				table.insert(used_floors, 1, SV.TakenBoard[j].Floor)
			end
		end
				
		local mission_floor = math.random(math.floor(zone.CountedFloors * .55), zone.CountedFloors)
		
		--don't generate this particular job slot if this floor's already been taken.
		--a bit of a lazy approach, perphaps upgrade in future?
		if not MISSION_GEN.has_value(used_floors, mission_floor) then 
			if mission_type == "Outlaw" then
				SV.OutlawBoard[i].Client = client
				SV.OutlawBoard[i].Target = target
				SV.OutlawBoard[i].Flavor = flavor
				SV.OutlawBoard[i].Title = title
				SV.OutlawBoard[i].Zone = dungeon
				SV.OutlawBoard[i].Segment = segment
				SV.OutlawBoard[i].Reward = reward
				SV.OutlawBoard[i].Floor = mission_floor
				SV.OutlawBoard[i].Type = objective
				SV.OutlawBoard[i].Completion = MISSION_GEN.INCOMPLETE
				SV.OutlawBoard[i].Taken = false
				SV.OutlawBoard[i].Difficulty = difficulty
			else 
				SV.MissionBoard[i].Client = client
				SV.MissionBoard[i].Target = target
				SV.MissionBoard[i].Flavor = flavor
				SV.MissionBoard[i].Title = title
				SV.MissionBoard[i].Zone = dungeon
				SV.MissionBoard[i].Segment = segment
				SV.MissionBoard[i].Reward = reward
				SV.MissionBoard[i].Floor = mission_floor
				SV.MissionBoard[i].Type = objective
				SV.MissionBoard[i].Completion = MISSION_GEN.INCOMPLETE
				SV.MissionBoard[i].Taken = false
				SV.MissionBoard[i].Difficulty = difficulty
			end
		end
			
	end
	
end

function MISSION_GEN.JobSortFunction(j1, j2)
	--if they're the same dungeon, then check floors. Otherwise, dungeon order takes presidence. 
	if MISSION_GEN.DUNGEON_ORDER[j1.Zone] == MISSION_GEN.DUNGEON_ORDER[j2.Zone] then
		return j1.Floor < j2.Floor 
	else 
		return MISSION_GEN.DUNGEON_ORDER[j1.Zone] < MISSION_GEN.DUNGEON_ORDER[j2.Zone]
	end
end


function MISSION_GEN.SortTaken()
	table.sort(SV.TakenBoard, MISSION_GEN.JobSortFunction)
end

function MISSION_GEN.SortMission()
	table.sort(SV.MissionBoard, MISSION_GEN.JobSortFunction)
end

function MISSION_GEN.SortOutlaw()
	table.sort(SV.OutlawBoard, MISSION_GEN.JobSortFunction)
end



JobMenu = Class('JobMenu')

--jobs is a job board 
--job type should be taken, mission, or outlaw
--job number should be 1-8
function JobMenu:initialize(job_type, job_number, parent_board_menu)
  assert(self, "JobMenu:initialize(): Error, self is nil!")
  self.menu = RogueEssence.Menu.ScriptableMenu(24, 24, 272, 192, function(input) self:Update(input) end)
  --self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(jobs[i], RogueElements.Loc(16, 8 + 14 * (i-1))))
    
  local job 
  
  self.job_number = job_number
  
  self.job_type = job_type
  
  self.parent_board_menu = parent_board_menu
  
  --get relevant board
  local job
  if job_type == 'taken' then
	job = SV.TakenBoard[job_number]
  elseif job_type == 'outlaw' then
  	job = SV.OutlawBoard[job_number]
  else --default to mission board
  	job = SV.MissionBoard[job_number]
  end
  
  self.taken = job.Taken
  
  self.flavor = job.Flavor
  --Zhayn is the only non-species name that'll show up here. So he is hardcoded in as an exception here.
  --TODO: Unhardcode this by adding in a check if string is not empty and if its not a species name, then add the color coding around it for  proper names.
  self.client = ""
  if job.Client == 'zhayn' then 
	self.client = '[color=#00FFFF]Zhayn[color]' 
  elseif job.Client ~= "" then 
	self.client = _DATA:GetMonster(job.Client):GetColoredName() 
  end
  print(self.client)

  self.target = ""
  if job.Target ~= '' then self.target = _DATA:GetMonster(job.Target):GetColoredName() end
  
  self.objective = ""
  self.type = job.Type
  
  if self.type == COMMON.MISSION_TYPE_RESCUE then
	self.objective = "Rescue " .. self.client .. "."
  elseif self.type == COMMON.MISSION_TYPE_ESCORT then
    self.objective = "Escort " .. self.client .. " to " .. self.target .. "."
  elseif self.type == COMMON.MISSION_TYPE_OUTLAW then 
	self.objective = "Arrest " .. self.target .. "."
  end
  
  
  self.zone = ""
  if job.Zone ~= "" then self.zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get(job.Zone):GetColoredName() end
  
  self.floor = ""
  if job.Floor ~= -1 then self.floor = MISSION_GEN.STAIR_TYPE[job.Zone] .. '[color=#00FFFF]' .. tostring(job.Floor) .. "[color]F" end
  
  self.difficulty = ""
  if job.Difficulty ~= "" then self.difficulty = "[color=#FFC663]" .. job.Difficulty .. "[color]   (" .. tostring(MISSION_GEN.DIFFICULTY[job.Difficulty]) .. ")" end 
  
  
  
  
  self.reward = ""
  if job.Reward ~= '' then
	--special case for money
	if job.Reward == "money" then
		self.reward = '[color=#00FFFF]' .. MISSION_GEN.DIFF_TO_MONEY[job.Difficulty] .. '[color]' .. STRINGS:Format("\\uE024")
	else 
		self.reward = RogueEssence.Dungeon.InvItem(job.Reward):GetDisplayName()
    end
  end
  
  
  
	self:DrawJob()
  

end

function JobMenu:DrawJob()
  --Standard menu divider. Reuse this whenever you need a menu divider at the top for a title.
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuDivider(RogueElements.Loc(8, 8 + 12), self.menu.Bounds.Width - 8 * 2));

  --Standard title. Reuse this whenever a title is needed.
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText("Job Summary", RogueElements.Loc(16, 8)))
  
  
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(self.flavor, RogueElements.Loc(16, 24)))
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText("Client:", RogueElements.Loc(16, 54)))
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText("Objective:", RogueElements.Loc(16, 68)))
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText("Place:", RogueElements.Loc(16, 82)))
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText("Difficulty:", RogueElements.Loc(16, 96)))
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText("Reward:", RogueElements.Loc(16, 110))) 

  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(self.client, RogueElements.Loc(68, 54)))
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(self.objective, RogueElements.Loc(68, 68)))
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(self.zone .. " " .. self.floor, RogueElements.Loc(68, 82)))
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(self.difficulty, RogueElements.Loc(68, 96)))
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(self.reward, RogueElements.Loc(68, 110)))
end 



--for use with submenu
function JobMenu:DeleteJob()
	SV.TakenBoard[self.job_number] = {
										Client = "",
										Target = "",
										Flavor = "",
										Title = "",
										Zone = "",
										Segment = -1,
										Floor = -1,
										Reward = "",
										Type = "",
										Completion = -1,
										Taken = false,
										Difficulty = ""
									}
	
	MISSION_GEN.SortTaken()
	if self.parent_board_menu ~= nil then 
		--redraw board with potentially changed information from job board
		self.parent_board_menu.menu.MenuElements:Clear()
		self.parent_board_menu:RefreshSelf()
		self.parent_board_menu:DrawBoard()
	end
	_MENU:RemoveMenu()
	_MENU:RemoveMenu()
end

--for use with submenu
--flips taken status of self, and also updates the appropriate SV var's taken value
function JobMenu:FlipTakenStatus()
	self.taken = not self.taken
	if self.job_type == 'taken' then
		SV.TakenBoard[self.job_number].Taken = self.taken
	elseif self.job_type == 'outlaw' then
		SV.OutlawBoard[self.job_number].Taken = self.taken
	else 
		SV.MissionBoard[self.job_number].Taken = self.taken
	end
	if self.parent_board_menu ~= nil then 
		--redraw board with potentially changed information from job board
		self.parent_board_menu.menu.MenuElements:Clear()
		self.parent_board_menu:RefreshSelf()
		self.parent_board_menu:DrawBoard()
	end
end 

--for use with submenu
--adds the current job to the taken board, then sorts it. Then close the menu
function JobMenu:AddJobToTaken()
	--this should already be true if we get to this point, but just in case, check if the last job slot is empty
	if SV.TakenBoard[8].Client == "" then
		if self.job_type == 'outlaw' then
			SV.TakenBoard[8] = SV.OutlawBoard[self.job_number]
		elseif self.job_type == 'mission' then
			SV.TakenBoard[8] = SV.MissionBoard[self.job_number]
		end 
		MISSION_GEN.SortTaken()
	end
	_MENU:RemoveMenu()
end


function JobMenu:Update(input)
    assert(self, "BaseState:Begin(): Error, self is nil!")
  if input:JustPressed(RogueEssence.FrameInput.InputType.Confirm) then  
	if self.job_type ~= 'taken' and self.taken then 
		--This is a job from the board that was already taken! Play a cancel noise.
		_GAME:SE("Menu/Cancel")
	else 
	    _GAME:SE("Menu/Confirm")
		--create prompt menu
		local choices = {}
		print(self.job_type .. " taken: " .. tostring(self.taken))
		if self.job_type == 'taken' then
			local choice_str = "Take Job"
			if self.taken then
				choice_str = 'Suspend'
			end
			choices = {	{choice_str, true, function() self:FlipTakenStatus() _MENU:RemoveMenu() end},
						{"Delete", true, function() self:DeleteJob() end},
						{"Cancel", true, function() _MENU:RemoveMenu() end} }
			
		else --outlaw/mission boards
			--we already made a check above to see if this is a job board and not taken 
			--only selectable if there's room on the taken board for the job and we haven't already taken this mission
			choices = {{"Take Job", SV.TakenBoard[8].Client == "" and not self.taken, function() self:FlipTakenStatus() 
																								 self:AddJobToTaken() end },
					   {"Cancel", true, function() _MENU:RemoveMenu() end} }
		end 
	
		submenu = RogueEssence.Menu.ScriptableSingleStripMenu(220, 24, 24, choices, 1) 
		_MENU:AddMenu(submenu, true)
		
	end
  elseif input:JustPressed(RogueEssence.FrameInput.InputType.Cancel) then
    _GAME:SE("Menu/Cancel")
    _MENU:RemoveMenu()
	--open job menu for that particular job
  else

  end
end 



BoardMenu = Class('BoardMenu')

--board type should be taken, mission, or outlaw 
function BoardMenu:initialize(board_type)
  assert(self, "BoardMenu:initialize(): Error, self is nil!")
    
  self.menu = RogueEssence.Menu.ScriptableMenu(24, 24, 272, 192, function(input) self:Update(input) end)
  self.cursor = RogueEssence.Menu.MenuCursor(self.menu)
  
  self.board_type = board_type
  
  if self.board_type == 'taken' then
	self.jobs = SV.TakenBoard
  elseif self.board_type == 'outlaw' then
  	self.jobs = SV.OutlawBoard
  else --default to mission board
  	self.jobs = SV.MissionBoard
  end

  self.total_items = #self.jobs
  --get total job count
  --todo: make this less bad 
  for i = #self.jobs, 1, -1 do 
	if self.jobs[i].Client ~= "" then break else self.total_items = self.total_items - 1 end
  end
  
  self.current_item = 0
  self.cursor.Loc = RogueElements.Loc(8, 22)
  self.page = 1--1 or 2
  self.total_pages = math.ceil(self.total_items / 4)


  self:DrawBoard()

end

--refresh information from results of job menu
function BoardMenu:RefreshSelf()
  print("Debug: Refreshing self!")
  if self.board_type == 'taken' then
	self.jobs = SV.TakenBoard
  elseif self.board_type == 'outlaw' then
  	self.jobs = SV.OutlawBoard
  else --default to mission board
  	self.jobs = SV.MissionBoard
  end
  
  self.total_items = #self.jobs
  --get total job count
  --todo: make this less bad 
  for i = #self.jobs, 1, -1 do 
	if self.jobs[i].Client ~= "" then break else self.total_items = self.total_items - 1 end
  end
 
  --in the event of deleting the last item on the board, move the cursor to accomodate.
  if self:GetSelectedJobIndex() > self.total_items then 
	print("On refresh self, needed to adjust current item!")
	self.current_item = (self.total_items % 4) - 1
	
	--move cursor to reflect new current item location
	self.cursor:ResetTimeOffset()
    self.cursor.Loc = RogueElements.Loc(8, 22 + 26 * self.current_item)
  end
  
  self.total_pages = math.ceil(self.total_items / 4)

  --go to page 1 if we now only have 1 page
  if self.page == 2 and self.total_pages == 1 then
	self.page = 1
  end
  
  --if there are no more missions and we're on the taken screen, close the menu.  
  if SV.TakenBoard[1].Client == "" and self.board_type == 'taken' then 
	  _MENU:RemoveMenu()
  end
end 


--NOTE: Board is hardcoded to have 4 items a page, and only to have up to 8 total items to display.
--If you want to edit this, you'll probably have to change most instances of the number 4 here and some references to page. Sorry!
function BoardMenu:DrawBoard()
  --Standard menu divider. Reuse this whenever you need a menu divider at the top for a title.
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuDivider(RogueElements.Loc(8, 8 + 12), self.menu.Bounds.Width - 8 * 2));

  --Standard title. Reuse this whenever a title is needed.
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText("Notice Board", RogueElements.Loc(16, 8)))
  
  --page element
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText("(" .. tostring(self.page) .. "/" .. tostring(self.total_pages) .. ")", RogueElements.Loc(self.menu.Bounds.Width - 35, 8)))

  self.menu.MenuElements:Add(self.cursor)
  
  --populate 4 self.jobs on a page
  for i = (4 * self.page) - 3, 4 * self.page, 1 do 
	--stop populating self.jobs if we hit a job that's empty
    if self.jobs[i].Client == "" then break end 
	
	
	local title = self.jobs[i].Title
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get(self.jobs[i].Zone):GetColoredName()
    local floor =  MISSION_GEN.STAIR_TYPE[self.jobs[i].Zone] ..'[color=#00FFFF]' .. tostring(self.jobs[i].Floor) .. "[color]F"
    local difficulty = "[color=#FFC663]" .. self.jobs[i].Difficulty .. "[color]" 
	
	local icon = ""
	if self.board_type == 'taken' then
		if self.jobs[i].Taken then 
			icon = STRINGS:Format("\\uE10F")--open letter
		else
			icon = STRINGS:Format("\\uE10E")--closed letter
		end
	else 
		if self.jobs[i].Taken then 
			icon = STRINGS:Format("\\uE10E")--closed letter
		else
			icon = STRINGS:Format("\\uE110")--paper
		end
	end
	
	local location = zone .. " " .. floor .. " " .. difficulty
	
	--color everything red if job is taken and this is a job board
	if self.jobs[i].Taken and self.board_type ~= 'taken' then
		location = string.gsub(location, '%[color=#00FFFF]', '')
		location = string.gsub(location, '%[color=#FFC663]', '')
		location = string.gsub(location, '%[color]', '')
		title = "[color=#FF0000]" .. title .. "[color]"
		location = "[color=#FF0000]" .. location .. "[color]"
	end
	
	--modulo the iterator so that if we're on the 2nd page it goes to the right spot
	
	self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(icon, RogueElements.Loc(16, 23 + 26 * ((i-1) % 4))))
	self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(title, RogueElements.Loc(28, 23 + 26 * ((i-1) % 4))))
	self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(location, RogueElements.Loc(28, 35 + 26 * ((i-1) % 4))))


  end
end 


function BoardMenu:Update(input)
    assert(self, "BaseState:Begin(): Error, self is nil!")
  if input:JustPressed(RogueEssence.FrameInput.InputType.Confirm) then
	--open the selected job menu
	_GAME:SE("Menu/Confirm")
	local job_menu = JobMenu:new(self.board_type, self:GetSelectedJobIndex(), self)
	_MENU:AddMenu(job_menu.menu, false)
  elseif input:JustPressed(RogueEssence.FrameInput.InputType.Cancel) then
    _GAME:SE("Menu/Cancel")
    _MENU:RemoveMenu()
	--open job menu for that particular job
  else
    moved = false
    if RogueEssence.Menu.InteractableMenu.IsInputting(input, LUA_ENGINE:MakeLuaArray(Dir8, { Dir8.Down, Dir8.DownLeft, Dir8.DownRight })) then
      moved = true
      self.current_item = (self.current_item + 1) % 4
	  
	  --if we try to move the cursor to an empty slot on a down press, then move it to the space for the first job on the page.
	  if self:GetSelectedJobIndex() > self.total_items then 
		local new_current = 0
		--undo moved flag if we didn't actually move
		if new_current == (self.current_item - 1) % 4 then
			moved = false
		end
		self.current_item = new_current
	  end
	  
    elseif RogueEssence.Menu.InteractableMenu.IsInputting(input, LUA_ENGINE:MakeLuaArray(Dir8, { Dir8.Up, Dir8.UpLeft, Dir8.UpRight })) then
      moved = true
      self.current_item = (self.current_item - 1) % 4
	  
	  --if we try to move the cursor to an empty slot on an up press, then move it to the space for the last job on the page.
	  if self:GetSelectedJobIndex() > self.total_items then 
		local new_current = (self.total_items % 4) - 1
		--undo moved flag if we didn't actually move
		if new_current == (self.current_item + 1 ) % 4 then
			moved = false
		end
		self.current_item = new_current
	  end
	  
	elseif RogueEssence.Menu.InteractableMenu.IsInputting(input, LUA_ENGINE:MakeLuaArray(Dir8, {Dir8.Left, Dir8.Right})) then
	  --go to other menu if there are more options on the 2nd menu
	  if self.total_pages > 1 then 
	    --change the page
	    if self.page == 1 then self.page = 2 else self.page = 1 end
		moved = true
		
	  --if we try to move the cursor to an empty slot on a side press, then move it to the space for the last job on the page.
	    if self:GetSelectedJobIndex() > self.total_items then 
			local new_current = (self.total_items % 4) - 1
			self.current_item = new_current
		end
		
		
		self.menu.MenuElements:Clear()
		self:DrawBoard()
	  end
    end
    if moved then
      _GAME:SE("Menu/Select")
      self.cursor:ResetTimeOffset()
      self.cursor.Loc = RogueElements.Loc(8, 22 + 26 * self.current_item)
    end
  end
end 

--gets current job index based on the current item and the page. if self.page is 2, and current item is 0, returned answer should be 5.
function BoardMenu:GetSelectedJobIndex()
	return self.current_item + (4 * (self.page - 1) + 1)
	
end