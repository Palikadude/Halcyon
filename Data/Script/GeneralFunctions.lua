require 'common'
GeneralFunctions = {}

--[[These are functions/procedures that are useful in a multitude of different maps or situations. Things such as
reseting daily flags, a function to have the pokemon look in a random number of directions, etc.

List of custom variables attached to pokemon:
Importance: used mainly to mark the Hero and the Partner. is equal to 'Hero' if hero and 'Partner' if partner.
nil otherwise, but may be used in future to flag other party members/npcs as being important in someway.

AddBack: Marks the character to be added back when the party is reset,value is the slot to add them back at.
If it's nil then don't add them back. Set it to nil after adding them back
]]--

function GeneralFunctions.UpdateDailyFlags()
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
	
	--reset cafe special
    SV.metano_cafe.CafeSpecial = ""
	SV.metano_cafe.BoughtSpecial = false
	
	--finish fermenting any pending items if there are any
	if SV.metano_cafe.FermentedItem ~= "" then 
		SV.metano_cafe.ItemFinishedFermenting = true
	end
	
	--Reset amount of times audino was summoned on that day 
	SV.TemporaryFlags.AudinoSummonCount = 0
	
	--Reset in-dungeon thief status so shopkeepers won't continue remember your crimes in the next dungeon run
	SV.adventure.Thief = false
	
	--Generate jobs
	MISSION_GEN.ResetBoards()
	MISSION_GEN.RemoveMissionBackReference()
	MISSION_GEN.GenerateBoard(COMMON.MISSION_BOARD_MISSION)
	MISSION_GEN.GenerateBoard(COMMON.MISSION_BOARD_OUTLAW)
	MISSION_GEN.SortMission()
	MISSION_GEN.SortOutlaw()
end 

--to be called at the end of the day. A generic function for generic days (i.e. no cutscene) 
function GeneralFunctions.EndOfDay()
	SV.ChapterProgression.DaysPassed = SV.ChapterProgression.DaysPassed + 1
	GeneralFunctions.UpdateDailyFlags()

end

--this places Common.EndDungeonDay
function GeneralFunctions.EndDungeonRun(result, zone, structure, mapid, entryid, display, fanfare)
	--todo: more sophisticated logic once more stuff is figured out
	--outcome can be things like wipe, success, completed a mission, etc
	DEBUG.EnableDbgCoro() --Enable debugging this coroutine
	
	GAME:EndDungeonRun(result, zone, structure, mapid, entryid, display, fanfare)
	GAME:WaitFrames(20)
	GAME:EnterZone(zone, structure, mapid, entryid)

	--GAME:EnterGroundMap("guild_heros_room", "Main_Entrance_Marker")
end

--given the line to travel between two points, how many frames must the camera move for to get the desired speed?
--2 is standard walking speed... This will mostly be useful for diagonal lines
--will round the result up, so for consistency try to keep the answer as a whole number...
function GeneralFunctions.CalculateCameraFrames(startX, startY, endX, endY, speed)
	local distX = startX - endX
	local distY = startY - endY
	
	local distance = math.sqrt((distX * distX) + (distY * distY))
	
	return math.floor(distance / speed)
	
end 





--randomly returns true or false
function GeneralFunctions.RandBool()
	return math.random(0, 1) == 0
end

--assigns a number value to each direction, useful for figuring out how many turn a direction is from another
function GeneralFunctions.DirToNum(dir)
	--up is 0, upright is 1, ... up left is 7
	local num = -1
	if dir == Direction.Up then
		num = 0
	elseif dir == Direction.UpRight then
		num = 1
	elseif dir == Direction.Right then
		num = 2
	elseif dir == Direction.DownRight then
		num = 3
	elseif dir == Direction.Down then
		num = 4
	elseif dir == Direction.DownLeft then
		num = 5
	elseif dir == Direction.Left then
		num = 6
	elseif dir == Direction.UpLeft then
		num = 7
	end
	
	return num
	
end

function GeneralFunctions.GenderToNum(gender)
	local res = -1
	if gender == Gender.Genderless then
		res = 0
	elseif gender == Gender.Male then
		res = 1
	elseif gender == Gender.Female then
		res = 2
	end
	return res
end

function GeneralFunctions.NumToGender(num)
	local res = Gender.Unknown
	if num == 0 then
		res = Gender.Genderless
	elseif num == 1 then
		res = Gender.Male
	elseif num == 2 then
		res = Gender.Female
	end
	return res
end

--converts a number to a direction
function GeneralFunctions.NumToDir(num)
	local dir = Direction.None
	if num % 8 == 0 then 
		dir = Direction.Up
	elseif num % 8 == 1 then
		dir = Direction.UpRight
	elseif num % 8 == 2 then
		dir = Direction.Right
	elseif num % 8 == 3 then
		dir = Direction.DownRight
	elseif num % 8 == 4 then
		dir = Direction.Down
	elseif num % 8 == 5 then
		dir = Direction.DownLeft
	elseif num % 8 == 6 then
		dir = Direction.Left
	elseif num % 8 == 7 then
		dir = Direction.UpLeft
	end

	return dir
end


function GeneralFunctions.ShakeHead(chara, turnframes, startLeft)
	
	if turnframes == nil then turnframes = 4 end
	if startLeft == nil then startLeft = true end 
	
	initDir = chara.Direction
	local leftDir = GeneralFunctions.NumToDir(GeneralFunctions.DirToNum(chara.Direction) - 1)
	local rightDir = GeneralFunctions.NumToDir(GeneralFunctions.DirToNum(chara.Direction) + 1)
	if startLeft then
		GROUND:CharAnimateTurnTo(chara, leftDir, turnframes)
		GROUND:CharAnimateTurnTo(chara, rightDir, turnframes)
		GROUND:CharAnimateTurnTo(chara, leftDir, turnframes)
		GROUND:CharAnimateTurnTo(chara, rightDir, turnframes)
		GROUND:CharAnimateTurnTo(chara, initDir, turnframes)
	else
		GROUND:CharAnimateTurnTo(chara, rightDir, turnframes)
		GROUND:CharAnimateTurnTo(chara, leftDir, turnframes)
		GROUND:CharAnimateTurnTo(chara, rightDir, turnframes)
		GROUND:CharAnimateTurnTo(chara, leftDir, turnframes)
		GROUND:CharAnimateTurnTo(chara, initDir, turnframes)
	end
	
end

--chara looks around in a rotations amount of directions, turning for turnframes frames, 
--ending facing in enddir direction. if alldirections is true, can look in all directions, otherwise can only face +-2 from original direction
--NOTE:Skemple uses 15 for waits for this sort of generic feature.
function GeneralFunctions.LookAround(chara, rotations, turnframes, allDirections, sound, startLeft, enddir)


	if allDirections == nil then allDirections = true end 
	if sound == nil then sound = true end 
	if startLeft == nil then startLeft = true end 
	if enddir == nil then enddir = chara.Direction end

	local dir = 0
	
	--play the looking around sfx if we want a sound to be made
	if sound then SOUND:PlayBattleSE("EVT_Emote_Confused_2") end

	--if all directions, look in any of the 8 directions randomly (except the one we are already facing)
	--if not all directions, alternate between looking 90 degrees left and right from current direction
	--at the end, face towards the enddir if specified
	if allDirections then 
		for i = 1, rotations, 1 do
			local currentDir = chara.Direction
			local numDir = GeneralFunctions.DirToNum(currentDir)
			local diff = 0
			local rand = 0
			rand = math.random(2, 6)--pick a random turn angle of at least 90 degrees
			rand = (numDir + rand)%8 --calculate chosen direction
			dir = GeneralFunctions.NumToDir(rand)
			GROUND:CharAnimateTurnTo(chara, dir, turnframes)
			GAME:WaitFrames(20)--pause
		end 
	else--this is much less random 
		local leftDir = GeneralFunctions.NumToDir(GeneralFunctions.DirToNum(chara.Direction) - 2)
		local rightDir = GeneralFunctions.NumToDir(GeneralFunctions.DirToNum(chara.Direction) + 2)
		local originalDir = chara.Direction
		local turnLeft = startLeft --start by looking left if that's what's been specified, otherwise start by looking right
		for i = 1, rotations, 1 do
			if turnLeft then
				GROUND:CharAnimateTurn(chara, leftDir, turnframes, turnLeft)
				GAME:WaitFrames(10)--pause
				turnLeft = false
			else
				GROUND:CharAnimateTurn(chara, rightDir, turnframes, turnLeft)
				GAME:WaitFrames(10)--pause
				turnLeft = true
			end
		end
	end
	if enddir ~= Direction.None and enddir ~= dir then--if a direction to end on was specified and we aren't facing that way, turn there 
		GROUND:CharAnimateTurnTo(chara, enddir, turnframes)
	else GAME:WaitFrames(turnframes * 2)--wait for some time based off how long it could have taken to turn if we dont turn at the end 
	end
	GAME:WaitFrames(6)--Wait a short duration before ending

end
	
--This function makes it easy to keep the camera in sync with a character moving
function GeneralFunctions.MoveCharAndCamera(chara, x, y, run, charSpeed, cameraFrames)
	local startX = chara.Position.X
	local startY = chara.Position.Y
	--characters position starts from their top left corner. 
	local camX = x + 8
	local camY = y + 8
	local default = false
	
	--cameraSpeed should only be given when a custom frame count needs to be used for some reason
	--otherwise, calculate the number of frames needed for smooth transition
	if cameraFrames == nil then cameraFrames = GeneralFunctions.CalculateCameraFrames(startX, startY, x, y, charSpeed) end
	--default run to false 
	if run == nil then run = false end 

	local coro1 = TASK:BranchCoroutine(function() GAME:MoveCamera(camX, camY, cameraFrames, false) end)
	local coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(chara, x, y, run, charSpeed) end)
	TASK:JoinCoroutines({coro1, coro2})


end

--easy speed control on camera movements
function GeneralFunctions.MoveCamera(x, y, speed)
	if speed == nil then speed = 2 end
	
	local cameraFrames = GeneralFunctions.CalculateCameraFrames(GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, x, y, speed)
	GAME:MoveCamera(x, y, cameraFrames, false)
end

--old movetoposition behavior
--move diagonially, then on one axis to get to the destination (2 movements)
--only moves in 8 directions 
function GeneralFunctions.EightWayMove(chara, x, y, run, speed)

	local diffX = x - chara.Position.X
	local diffY = y - chara.Position.Y
	
	
	local xSign = 1
	local ySign = 1
	
	if diffX < 0 then xSign = -1 end
	if diffY < 0 then ySign = -1 end

	diffX = math.abs(diffX)
	diffY = math.abs(diffY)
	
	
	local diff = 0 
	
	if diffX < diffY then
		diff = diffX
		GROUND:MoveToPosition(chara, chara.Position.X + (diff * xSign), chara.Position.Y + (diff * ySign), run, speed)
	elseif math.abs(diffX) > math.abs(diffY) then
		diff = diffY
		GROUND:MoveToPosition(chara, chara.Position.X + (diff * xSign), chara.Position.Y + (diff * ySign), run, speed)
	end
	
	GROUND:MoveToPosition(chara, x, y, run, speed)
end

--Opposite of above; move straight then diagonally. Same as OSRS path finding hence the name.
--only moves in 8 directions 
function GeneralFunctions.EightWayMoveRS(chara, x, y, run, speed)

	local diffX = x - chara.Position.X
	local diffY = y - chara.Position.Y

	local xSign = 1
	local ySign = 1
	
	if diffX < 0 then xSign = -1 end
	if diffY < 0 then ySign = -1 end

	diffX = math.abs(diffX)
	diffY = math.abs(diffY)
	
	local diffDiff = math.abs(diffX - diffY)
		
	if diffX < diffY then
		GROUND:MoveToPosition(chara, chara.Position.X, chara.Position.Y + (diffDiff * ySign), run, speed)
	elseif math.abs(diffX) > math.abs(diffY) then
		GROUND:MoveToPosition(chara, chara.Position.X + (diffDiff * xSign), chara.Position.Y, run, speed)
	end
	
	GROUND:MoveToPosition(chara, x, y, run, speed)
end


function GeneralFunctions.SlowAnimateInDirection(chara, animation, animDir, movedir, dist, animspeed, pause_dur)
	local dist_traveled = 0
	
	if animation == nil then animation = 'Walk' end
	if animspeed == nil then animspeed = 1 end
	
end

--shortcut for doing hero dialogue (i.e., no sfx, no nameplate at the start)
function GeneralFunctions.HeroDialogue(chara, str, emotion)
	UI:SetSpeaker('', false, chara.CurrentForm.Species, chara.CurrentForm.Form, chara.CurrentForm.Skin, chara.CurrentForm.Gender)
	UI:SetSpeakerEmotion(emotion)
	UI:WaitShowDialogue(str)
end

--walking in place to "talk"
function GeneralFunctions.HeroSpeak(chara, duration, anim)
	--anim is the animation we do after walking in place
	if anim == nil then anim = 'None' end 
	GROUND:CharSetAnim(chara, "Walk", true)
	GAME:WaitFrames(duration)
	--GROUND:CharSetAnim(chara, anim, true)
	GROUND:CharEndAnim(chara)
end


--wait frames, then move to target location. Intended use is to desync characters that are walking together to make it look more natural
--This function got phased out when I realized I could fit multiple commands into one coroutine
function GeneralFunctions.WaitThenMove(chara, x, y, run, speed, waitFrames)
	GAME:WaitFrames(waitFrames)
	GROUND:MoveToPosition(chara, x, y, run, speed)
end

--generic emote function with standardized SFX and pause duration. Shouldn't ALWAYS be used to emote, but is useful to cut down on lines...
function GeneralFunctions.EmoteAndPause(chara, emote, sound, repetitions)
	local sfx = 'null'
	local emt = 'null'
	local pause = 0
	
	if repetitions == nil then repetitions = 1 end
	
	if emote == 'Happy' then
		emt = "happy"
		sfx = "EVT_Emote_Startled_2"
		pause = 20--this one is accurate
	elseif emote == 'Notice' then --this one is the 3 lines
		emt = "notice"
		sfx = 'EVT_Emote_Exclaim'
		pause = 30--this should be more like 20
	elseif emote == 'Exclaim' then --this one is the !
		emt = "exclaim"
		sfx = 'EVT_Emote_Exclaim_2'
		pause = 20--this should be like, 25? To cover the entirety of it. 30 to give extra time to it...
	elseif emote == 'Glowing' then 
		emt = "glowing"
		sfx = 'EVT_Emote_Startled_2'
		pause = 20--test this one - should be like 22?
	elseif emote == 'Sweating' then
		emt = "sweating"
		sfx = 'EVT_Emote_Sweating'
		pause = 40 --should be like 26
	elseif emote == 'Question' then
		emt = "question"
		sfx = 'EVT_Emote_Confused'
		pause = 40--this is fine
	elseif emote == 'Angry' then
		emt = "angry"
		sfx = 'EVT_Emote_Complain_2'
		pause = 40 --Should be like 20ish for one repetition
		if repetitions == 1 then repetitions = 2 end--Do it twice for default case; once is kinda short and weird looking.
	elseif emote == 'Shock' then
		emt = "shock"
		sfx = 'EVT_Emote_Shock'
		pause = 40--should be like 30?
	else--sweatdrop
		emt = "sweatdrop"
		sfx = 'EVT_Emote_Sweatdrop'
		pause = 40--should be 50
	end
	
	GROUND:CharSetEmote(chara, emt, repetitions)
	
	if sound and sfx ~= 'null' then 
		SOUND:PlayBattleSE(sfx)
	end	
	GAME:WaitFrames(pause)
end


--Some serious spaghetti code being crafted here...
--Precise EmoteAndPause that has pause values that are much closer to the actual duration of the Emote's duration.
--If I had more foresight and care early on, the original EmoteAndPause would have these values
--To avoid breaking all the precise timings that were probably adjusted with manual waits and such in older scripts,
--make a new function for this instead of overwriting the old values.
function GeneralFunctions.EmoteAndPausePrecise(chara, emote, sound, repetitions)
	local sfx = 'null'
	local emt = 'null'
	local pause = 0
	
	if repetitions == nil then repetitions = 1 end
	
	if emote == 'Happy' then
		emt = "happy"
		sfx = "EVT_Emote_Startled_2"
		pause = 20
	elseif emote == 'Notice' then --this one is the 3 lines
		emt = "notice"
		sfx = 'EVT_Emote_Exclaim'
		pause = 20
	elseif emote == 'Exclaim' then --this one is the !
		emt = "exclaim"
		sfx = 'EVT_Emote_Exclaim_2'
		pause = 25
	elseif emote == 'Glowing' then 
		emt = "glowing"
		sfx = 'EVT_Emote_Startled_2'
		pause = 22
	elseif emote == 'Sweating' then
		emt = "sweating"
		sfx = 'EVT_Emote_Sweating'
		pause = 26 --should be like 26
	elseif emote == 'Question' then
		emt = "question"
		sfx = 'EVT_Emote_Confused'
		pause = 40--this is fine
	elseif emote == 'Angry' then
		emt = "angry"
		sfx = 'EVT_Emote_Complain_2'
		pause = 40 --Should be like 20ish for one repetition
		if repetitions == 1 then repetitions = 2 end--Do it twice for default case; once is kinda short and weird looking.
	elseif emote == 'Shock' then
		emt = "shock"
		sfx = 'EVT_Emote_Shock'
		pause = 30--should be like 30?
	else--sweatdrop
		emt = "sweatdrop"
		sfx = 'EVT_Emote_Sweatdrop'
		pause = 50--should be 50
	end
	
	GROUND:CharSetEmote(chara, emt, repetitions)
	
	if sound and sfx ~= 'null' then 
		SOUND:PlayBattleSE(sfx)
	end	
	GAME:WaitFrames(pause)
end
















--generic function to do an animation once then go back to the anim you were doing before (i.e. nod, get up, be surprised) 
--Has standardized wait times
--has some special instances... 
function GeneralFunctions.DoAnimation(chara, anim, sound)
	if sound == nil then sound = false end
	--[[local pause = 0
	--todo: return character to their animation from before. For now just end the anim...
	--local prevAnim = 'None'
	
	if anim == 'Nod' then 
		pause = 20
	elseif anim == 'Wake' then
		pause = 40
	elseif anim == 'Hop' then
		pause = 24
	elseif anim == 'DeepBreath' then
		pause = 80
	end
	]]--
	GROUND:CharWaitAnim(chara, anim)
	GROUND:CharEndAnim(chara)

end

-- Used to get proper pronoun depending on gender of character (gender check command)
-- Form should be given as they, them, their, theirs, themself, or they're.
-- If uppercase is truthy, then the first letter will be capitalized.
function GeneralFunctions.GetPronoun(chara, form, uppercase)
    local gender = chara.CurrentForm.Gender
    local value = ""
    
    if gender == Gender.Female then
        local female_pronouns = {
            ["they"] = "she", -- nominative
            ["them"] = "her", -- objective
            ["their"] = "her", -- possessive
            ["theirs"] = "hers", -- possessive, no following noun
            ["themself"] = "herself", -- reflexive
            ["they're"] = "she's", -- nominative + "be" contraction
            ["are"] = "is", -- "be" present indicative
			["were"] = "was",
			["don't"] = "doesn't"
        }
        value = female_pronouns[form]
    elseif gender == Gender.Male then
        local male_pronouns = {
            ["they"] = "he", -- nominative
            ["them"] = "him", -- objective
            ["their"] = "his", -- possessive
            ["theirs"] = "his", -- possessive, no following noun
            ["themself"] = "himself", -- reflexive
            ["they're"] = "he's", -- nominative + "be" contraction
            ["are"] = "is", -- "be" present indicative
			["were"] = "was",
			["don't"] = "doesn't"
        }
        value = male_pronouns[form]
    else -- if neither male or female, use they/them, so just return the form 
        value = form
    end

    return uppercase and value:gsub("^%l", string.upper) or value
    
end

--used to conjugate certain verbs appropriately, to be used with the above function typically
--this will need to be updated to be more sophisticated as the use cases arrive. For now, KISS.
function GeneralFunctions.Conjugate(chara, verb)
    local gender = chara.CurrentForm.Gender
    local value = verb
    
    if gender ~= Gender.Genderless then 
		if string.sub(verb, -1) == 's' then 
			value = value .. 'es'
		else
			value = value .. 's'
		end
    end

	return value
    
end


function GeneralFunctions.NameStutter(chara)
	--used to get a stutter on a character's name with proper coloring
	local name = chara.Nickname
	local prefix = "[color=#00FFFF]" .. string.sub(name, 1, 1) .. "[color]-"
	
	return prefix .. chara:GetDisplayName()

end

--centers the camera on the given characters. Moves at a rate of speed.
--give no speed for instant speed 
function GeneralFunctions.CenterCamera(charList, startX, startY, speed)
	local totalX = 0
	local totalY = 0
	local length = 0
	local frameDur = 0
	DEBUG.EnableDbgCoro()

	for key, value in pairs(charList) do
		totalX = totalX + value.Position.X + 8--offset char's pos by 8 to get camera on their center
		totalY = totalY + value.Position.Y + 8
		length = length + 1
		--print(value:GetDisplayName() .. "'s position: " .. value.Position.X .. " " .. value.Position.Y)
	end
	
	local avgX = math.floor(totalX / length)
	local avgY = math.floor(totalY / length)
	
	if speed == nil or startX == nil or startY == nil then
		frameDur = 1
	else
		frameDur = GeneralFunctions.CalculateCameraFrames(startX, startY, avgX, avgY, speed)
	end
	
	--print('CenterCamera: X = ' .. avgX .. '    Y = ' .. avgY)
	GAME:MoveCamera(avgX, avgY, frameDur, false)
	
end

--pan the camera back towards the target location, horizontally first then vertically
--give no parameters to center on player
function GeneralFunctions.PanCamera(startX, startY, toPlayer, speed, endX, endY)
	endX = endX or CH('PLAYER').Position.X + 8
	endY = endY or CH('PLAYER').Position.Y + 8
	speed = speed or 1
	startX = startX or GAME:GetCameraCenter().X
	startY = startY or GAME:GetCameraCenter().Y
	if toPlayer == nil then toPlayer = true end
	local difference = 0
	local duration = 0
	
	if endX ~= startX then
		difference = math.abs(endX - startX)
		duration = math.ceil(difference / speed)
		GAME:MoveCamera(endX, startY, duration, false)
	end
	
	if endY ~= startY then
		difference = math.abs(endY - startY)
		duration = math.ceil(difference / speed)
		GAME:MoveCamera(endX, endY, duration, false)
	end
	
	if toPlayer then GAME:MoveCamera(0, 0, 1, true) end
	
	
end

--useful for having characters face constantly towards someone who's moving
--offset is if you want the characters to look at 
function GeneralFunctions.FaceMovingCharacter(chara, target, turnFrames, breakDirection)
	local currentLocX = -999
	local currentLocY = -999
	turnFrames = turnFrames or 4

	breakDirection = breakDirection or Direction.None
	
	GAME:WaitFrames(1)--gives the pokemon a chance to start moving
	while not (currentLocX == target.Position.X and currentLocY == target.Position.Y) do
		if chara.Direction == breakDirection then break end
		GROUND:CharTurnToCharAnimated(chara, target, turnFrames)
		currentLocX = target.Position.X
		currentLocY = target.Position.Y
		GAME:WaitFrames(1)
	end
end


--todo?
function GeneralFunctions.DialogueWithEmote(chara, emote, str)
	
end 

--shorthand function 
function GeneralFunctions.TeleportToMarker(chara, marker)
	GROUND:TeleportTo(chara, marker.Position.X, marker.Position.Y, marker.Direction)
end

--[[

--todo: add some way to interrupt the loop for whatever arbitrary reason
--has characters emote at each other randomly as though they were talking amongst themselves
--this should always be used as a coroutine, as it's intended for background characters
function GeneralFunctions.Converse(charaList, turnWhenEmoting)
	
	--turn towards another while emoting, then turn back afterwards if this is true
	if turnWhenEmoting == nil then turnWhenEmoting = false end
	local length = #charaList
	local rand = 0
	local repetitions = 0
	local chara = 0
	while true do
		--if false then break end--todo
		print(turnWhenEmoting)
		--todo: get current animation
		
		--todo: do a couple little hops before emoting if randomly chosen...
		--local rand = math.random(1, 2)
		
		--if rand == 1 then
			--todo: do the hops
		--end 
		
		--set one of 4 emotes, bias towards picking happy emote
		local index = math.random(1, length)
		--print('index ' .. tostring(index))
		chara = charaList[index]
		
		
		rand = math.random(1, 6)
	--	print('length ' .. tostring(length))
	--	print('emote rand' .. tostring(rand))
		local emote = -1
		if rand == 1 then--exclaim emote
			emote = 3
			repetitions = 1
		elseif rand == 2 then --glowing emote
			emote = 4
			repetitions = 0
		elseif rand == 3 then--question emote
			emote = 6
			repetitions = 1
		else--happy emote
			emote = 1
			repetitions = 0
		end
		
		local olddir = chara.Direction
		local turnTo = 0
		
		--Emote for a random amount of frames, then pause for a random amount of frames before having someone else talk			
		GROUND:CharSetEmote(chara, emote, repetitions)
		
		--turn towards a random person in the conversation
		if turnWhenEmoting then 
			while turnTo == index do--dont turn to ourselves
				turnTo = math.random(1, length)
			--	print('turnto ' .. tostring(turnTo))
			end
			local charTurn = charaList[turnTo]--get the character to turn to
			GROUND:CharTurnToCharAnimated(chara, charTurn, 4)
		end
		
		
		if repetitions == 1 then rand = math.random(0, 40) else rand = math.random(120, 160) end
		GAME:WaitFrames(rand)
		--print('emote wait rand' .. tostring(rand))
		GROUND:CharSetEmote(chara, "", 0)
		
		if turnWhenEmoting then
			GROUND:CharAnimateTurnTo(chara, olddir, 4)
		end
		
		rand = math.random(100, 140)
		--print('wait rand '.. tostring(rand))
		GAME:WaitFrames(rand)
		
		
	end 
end
]]--

--set party to Hero as 1st, partner as 2nd member. 
--Just those two if others is false, allow other party members to remain in 3/4 slot if false
--if spawn is true run spawners for teammates 1 (through 3 if applicable)
--this is somewhat shoddily written, i feel like it will break with the right conditions...
--currently de-equips held items and causes a potential phantom glitch if called on a ground map and then you give control back to player without reinitializing/disabling partner collision...
-- should look into rewriting this, honestly.

--defunct, old version
--[[
function GeneralFunctions.DefaultParty(spawn, others)
	--Clear party 
	local partyCount = GAME:GetPlayerPartyCount()
	local p = 0
	local tbl = 0
	others = others or false
	
	--this depends on partner and hero not being able to be shifted out of slot 1 and 2... keep in mind
    for i = partyCount,1,-1 do
      p = GAME:GetPlayerPartyMember(i-1)
	  GAME:RemovePlayerTeam(i-1)
	  GAME:AddPlayerAssembly(p)
	  tbl = LTBL(p)
	  if tbl.Importance ~= 'Hero' and tbl.Importance ~= 'Partner' and others then
		tbl.AddBack = i
	  end
	end
    
	--set party (player then partner)
	local assemblyCount = GAME:GetPlayerAssemblyCount()
	local found = 1 --start at 1 due to indexing
	local bufferTable = {'dummy', 'dummy', 'dummy', 'dummy'}
	
	for i = 1, assemblyCount, 1 do
		print("i = " .. tostring(i))
		p = GAME:GetPlayerAssemblyMember(i - found)
		tbl = LTBL(p)
		print(p.Importance)
		--print(tbl.Importance)
		--print(p.Nickname)
		if tbl.Importance == 'Hero' then --hero goes in slot 1
			GAME:RemovePlayerAssembly(i-found)
			print("HERO FOUND")
			bufferTable[1] = p
			found = found + 1
		elseif tbl.Importance == 'Partner' then --partner in slot 2
			GAME:RemovePlayerAssembly(i-found)
			print("PARTNER FOUND")
			bufferTable[2] = p
			found = found + 1
			--if spawn then --call teammate 1 spawner
			--	GROUND:SpawnerSetSpawn('TEAMMATE_1', p)
			--	GROUND:SpawnerDoSpawn("TEAMMATE_1", p)
			--end
		elseif tbl.AddBack ~= nil then--misc goons go in remaining slots
			GAME:RemovePlayerAssembly(i-found)
			bufferTable[tbl.AddBack] = p
			found = found + 1
			--if spawn then --WARNING: Most places won't have teammate 2 and 3 spawners. Cafe and zone grounds are probably it.
			--	GROUND:SpawnerSetSpawn('TEAMMATE_' .. tostring(tbl.AddBack - 1), p)
			--	GROUND:SpawnerDoSpawn("TEAMMATE_" .. tostring(tbl.AddBack - 1), p)	
			--end
			tbl.AddBack = nil--clear addback flag
		end
	end 
	
	--add characters back into team in order, set leader to 1st member
	for i = 1, found - 1, 1 do
		print("ADDING CHARACTER BACK!")
		GAME:AddPlayerTeam(bufferTable[i])
	end
	
	GAME:SetTeamLeaderIndex(0)
	
	
	--guests are temporary and are for plot or missions. Delete them all, if they're needed again, whatever put them into your team will place them back in
	local guestCount = GAME:GetPlayerGuestCount()
	for i = 1, guestCount, 1 do 
		local g = GAME:RemovePlayerGuest(i-1)
	end

	
	if spawn then 	
		COMMON.RespawnAllies(true)
		--AI:SetCharacterAI(CH('Teammate1'), "ai.ground_partner", CH('PLAYER'),CH('Teammate1').Position)
	end
	_DATA.Save:UpdateTeamProfile(true)

		
		
end
]]--

--sets the team to be player and partner.
function GeneralFunctions.DefaultParty(spawn, destructive)
	--destructive flag makes it so party members discarded are NOT put in assembly and are straight up deleted.
	--useful for the expedition.
	if destructive == nil then destructive = false end
	
	local hero, partner
	local p, tbl
	local party_count = GAME:GetPlayerPartyCount()
	
	for i = party_count,1,-1 do
		p = GAME:GetPlayerPartyMember(i-1)
		tbl = LTBL(p)
		if tbl.Importance == 'Hero' then 
			hero = p
		elseif tbl.Importance == 'Partner' then
			partner = p
		else--remove them if they aren't the player and partner.
			if not destructive then --DESTROY the party member permanently if destructive
				GAME:AddPlayerAssembly(p)
			end
			GAME:RemovePlayerTeam(i-1)
		end
	end
	
	--Retrieve Player/Partner from assembly if they're there for some reason.
	if hero == nil or partner == nil then
		local assembly_count = GAME:GetPlayerAssemblyCount()
		for i = assembly_count, 1, -1 do 
			p = GAME:GetPlayerAssemblyMember(i-1)
			tbl = LTBL(p) 
			if tbl.Importance == 'Hero' then 
				GAME:RemovePlayerAssembly(i-1)
				GAME:AddPlayerTeam(p)
				--grab hero from the PARTY! Not from the previously established p. They're last at this point.
				hero = GAME:GetPlayerPartyMember(GAME:GetPlayerPartyCount() - 1)
			elseif tbl.Importance == 'Partner' then 
				GAME:RemovePlayerAssembly(i-1)
				GAME:AddPlayerTeam(p)
				--grab partner from the PARTY! Not from the previously established p. They're last at this point.
				partner = GAME:GetPlayerPartyMember(GAME:GetPlayerPartyCount() - 1)			end
		end
	end
	
	--Sanity check. If Hero and Partner are still nil, we have an issue!!
	--This typically is gonna happen if you save and reload scripts in debugging... So encase the slot swapping in the else to avoid bug outs during debugging.
	if hero == nil or partner == nil then
		PrintInfo("Hero or partner was NOT FOUND! Where the hell are they???")
	else
		--Swap the slots of player/partner around until player is slot 0 and partner is slot 1.
		--_DATA.Save.ActiveTeam:GetCharIndex(p) returns a charIndex for the p (character) in question. From there, .Char checks the actual slot.
		 if _DATA.Save.ActiveTeam:GetCharIndex(hero).Char ~= 0 then	
			--A different call is needed if in a dungeon or in overworld, so check if we're in a dungeon or not.
			if RogueEssence.GameManager.Instance.CurrentScene == RogueEssence.Dungeon.DungeonScene.Instance then
				_DUNGEON:SwitchTeam(0, _DATA.Save.ActiveTeam:GetCharIndex(hero).Char)
			else 
				_GROUND:SwitchTeam(0, _DATA.Save.ActiveTeam:GetCharIndex(hero).Char)
			end 
		end
		
		--Given that the party size is 2 at this point, and the previous check would swap player and partner around, this check is probably unneeded.
		--But I'm gonna put it here just in case, and also in case i decide to expand on this functionality in the future somehow.
		if _DATA.Save.ActiveTeam:GetCharIndex(partner).Char ~= 1 then	
			--A different call is needed if in a dungeon or in overworld, so check if we're in a dungeon or not.
			if RogueEssence.GameManager.Instance.CurrentScene == RogueEssence.Dungeon.DungeonScene.Instance then
				_DUNGEON:SwitchTeam(1, _DATA.Save.ActiveTeam:GetCharIndex(partner).Char)
			else 
				_GROUND:SwitchTeam(1, _DATA.Save.ActiveTeam:GetCharIndex(partner).Char)
			end 
		end
	end
	
	--set slot 0 to the leader just in case player was not in slot 0.
	GAME:SetTeamLeaderIndex(0)
		
	--guests are temporary and are for plot or missions. Delete them all, if they're needed again, whatever put them into your team will place them back in
	local guestCount = GAME:GetPlayerGuestCount()
	for i = 1, guestCount, 1 do 
		local g = GAME:RemovePlayerGuest(i-1)
	end

	
	if spawn then 	
		COMMON.RespawnAllies(true)
		--AI:SetCharacterAI(CH('Teammate1'), "ai.ground_partner", CH('PLAYER'),CH('Teammate1').Position)
	end
	_DATA.Save:UpdateTeamProfile(true)

		
		
end


--does a monologue, centering the text, having it appear instantly and turning off the keysound, then turn centering and auto finish off after.
function GeneralFunctions.Monologue(str)
	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:SetAutoFinish(true)
	UI:WaitShowDialogue(str)
	UI:SetAutoFinish(false)
	UI:SetCenter(false)
end 

function GeneralFunctions.Hop(chara, anim, height, duration, pause, sound)
	anim = anim or 'None'
	height = height or 10
	duration = duration or 10
	if pause == nil then pause = true end
	if sound == nil then sound = false end

	local animId = RogueEssence.Content.GraphicsManager.GetAnimIndex(anim)
	GROUND:CharSetAction(chara, RogueEssence.Ground.HopGroundAction(chara.Position, chara.Direction, animId, height, duration))
	
	if sound then
		SOUND:PlayBattleSE("EVT_Emote_Startled")
	end
	
	if pause then 
		GAME:WaitFrames(duration)
	end

end

--do two hops instead of just one
function GeneralFunctions.DoubleHop(chara, anim, height, duration, pause, sound)
	anim = anim or 'None'
	height = height or 10
	duration = duration or 10
	if pause == nil then pause = true end
	
	if sound then
		SOUND:PlayBattleSE("EVT_Emote_Startled_2")
	end
	
	local animId = RogueEssence.Content.GraphicsManager.GetAnimIndex(anim)
	GROUND:CharSetAction(chara, RogueEssence.Ground.HopGroundAction(chara.Position, chara.Direction, animId, height, duration))
	GAME:WaitFrames(duration)--need to pause no matter what here because only one hop will show otherwise
	GROUND:CharSetAction(chara, RogueEssence.Ground.HopGroundAction(chara.Position, chara.Direction, animId, height, duration))

	if pause then --only pause on 2nd hop if pause needed
		GAME:WaitFrames(duration)
	end

end



function GeneralFunctions.Recoil(chara, anim, height, duration, sound, emote)

	anim = anim or 'Hurt'
	height = height or 10
	duration = duration or 10
	if sound == nil then sound = true end
	if emote == nil then emote = true end
	
	if emote then GROUND:CharSetEmote(chara, "shock", 1) end
	if sound then SOUND:PlayBattleSE('EVT_Emote_Startled') end
	local animId = RogueEssence.Content.GraphicsManager.GetAnimIndex(anim)
	GROUND:CharSetAction(chara, RogueEssence.Ground.HopGroundAction(chara.Position, chara.Direction, animId, height, duration))
	GAME:WaitFrames(duration)
	if emote then GROUND:CharSetEmote(chara, "", 0) end
	
end



function GeneralFunctions.PromptSaveAndQuit()
	UI:ResetSpeaker()
	UI:BeginChoiceMenu("What would you like to do?", {"Save and continue.", "Save and quit.", "Cancel"}, 1, 3)
	UI:WaitForChoice()
	local result = UI:ChoiceResult()
	if result == 1 then 
		GAME:GroundSave()
		UI:ResetSpeaker()
		UI:WaitShowDialogue("Game saved!")
		GAME:WaitFrames(10)--prevent mashing issues
	elseif result == 2 then 
		GAME:GroundSave()
		UI:ResetSpeaker()
		UI:WaitShowDialogue("Game saved! Returning to title.")
		GAME:WaitFrames(10)
		GAME:FadeOut(false, 40)
		GAME:RestartToTitle()
	end
end


function GeneralFunctions.PromptSave()
	UI:ResetSpeaker()
	UI:ChoiceMenuYesNo("Would you like to save your game?")
	UI:WaitForChoice()
	local result = UI:ChoiceResult()
	if result then 
		GAME:GroundSave()
		UI:ResetSpeaker()
		UI:WaitShowDialogue("Game saved!")
		GAME:WaitFrames(10)--prevent mashing issues
	end
end

--used for chapter end save and quit prompts. Needs to be its own function as we can't call a map transition after if we choose save and quit.
--this should really only ever be called if the ground you want to enter next is the one you're already on.
--also this is kind of a workaround method due to how map transitions and reset to title works.

function GeneralFunctions.PromptChapterSaveAndQuit(ground, marker, ground_id)
	UI:ResetSpeaker()
	UI:BeginChoiceMenu("What would you like to do?", {"Save and continue.", "Save and quit.", "Cancel"}, 1, 3)
	UI:WaitForChoice()
	local result = UI:ChoiceResult()
	if result == 1 then 
		UI:ResetSpeaker()
		_DATA.Save.NextDest = RogueEssence.Dungeon.ZoneLoc("master_zone", -1, ground_id, 0)--set next destination to whatever map we were going to go to on a continue. Just in case player quits out after selecting this option.
		GAME:GroundSave()
		UI:WaitShowDialogue("Game saved!")
		GAME:EnterGroundMap(ground, marker)
	elseif result == 2 then 
		UI:ResetSpeaker()
		GAME:FadeOut(false, 40)
		_DATA.Save.NextDest = RogueEssence.Dungeon.ZoneLoc("master_zone", -1, ground_id, 0)--set next destination to whatever map we were going to go to on a continue
		GAME:GroundSave()
		UI:WaitShowDialogue("Game saved! Returning to title.")
		GAME:RestartToTitle()
	else
		GAME:EnterGroundMap(ground, marker)
	end
end

--sends all bagged items and money to storage. There is no practical limit on storage size (it stores as many as an int32, so... lol)
function GeneralFunctions.SendInvToStorage(sendItems, sendMoney, keepEquips)
	local itemCount = GAME:GetPlayerBagCount()
	local money = GAME:GetPlayerMoney()
	local item
	
	--only send money/items if we specify it. By default, send items AND money to storage.
	if sendItems == nil then sendItems = true end
	if sendMoney == nil then sendMoney = true end
	if keepEquips == nil then keepEquips = false end
	
	if sendMoney then 
		--move player's money to the bank
		GAME:RemoveFromPlayerMoney(money)
		GAME:AddToPlayerMoneyBank(money)
	end
	
	if sendItems then 
		for i = 1, itemCount, 1 do
			item = GAME:GetPlayerBagItem(0)
			GAME:TakePlayerBagItem(0, true)
			GAME:GivePlayerStorageItem(item)
		end
		
		if not keepEquips then
			--send equipped items to storage
			for i = 1, GAME:GetPlayerPartyCount(), 1 do
				item = GAME:GetPlayerEquippedItem(i-1)
				if item.ID ~= "" then 
					GAME:TakePlayerEquippedItem(i-1, true)
					GAME:GivePlayerStorageItem(item)
				end
			end
		end
	end
end

--used to reward items to the player, sends the item to storage if inv is full
function GeneralFunctions.RewardItem(itemID, money, amount)
	--if money is true, the itemID is instead the amount of money to award
	if money == nil then money = false end 
	
	UI:ResetSpeaker(false)--disable text noise
	UI:SetCenter(true)
	
	
	SOUND:PlayFanfare("Fanfare/Item")
	
	if money then 
		UI:WaitShowDialogue("Team " .. GAME:GetTeamName() .. " received " .. "[color=#00FFFF]" .. itemID .. "[color]" .. STRINGS:Format("\\uE024") .. ".[pause=40]") 
		GAME:AddToPlayerMoney(itemID)
	else	
		local itemEntry = RogueEssence.Data.DataManager.Instance:GetItem(itemID)
		
		--give at least 1 item
		if amount == nil then amount = math.max(1, itemEntry.MaxStack) end 

		local item = RogueEssence.Dungeon.InvItem(itemID, false, amount)
		
		--local article = "a"
		
		--local first_letter = string.upper(string.sub(_DATA:GetItem(item.ID).Name:ToLocal(), 1, 1))
		
		--if first_letter == "A" or first_letter == 'E' or first_letter == 'I' or first_letter == 'O' or first_letter == 'U' then article = 'an' end

		UI:WaitShowDialogue(STRINGS:Format("Team " .. GAME:GetTeamName() .. " received [a/an] " .. item:GetDisplayName() ..".[pause=40]")) 
		
		--bag is full - equipped count is separate from bag and must be included in the calc
		if GAME:GetPlayerBagCount() + GAME:GetPlayerEquippedCount() >= GAME:GetPlayerBagLimit() then
			UI:WaitShowDialogue("The " .. item:GetDisplayName() .. " was sent to storage.")
			GAME:GivePlayerStorageItem(item.ID, amount)
		else
			GAME:GivePlayerItem(item.ID, amount)
		end
	
	end
	UI:SetCenter(false)
	UI:ResetSpeaker()
			
		
end


local function FirstToUpper(str)
	return (str:gsub("^%l", string.upper))
end



--These are depreciated: The text tag [a/an] is replacing them. Capitalize the tag if needed. Remember to encase in a STRINGS:Format() when doing this! ex: UI:WaitShowDialogue(STRINGS:Format("I'd love [a/an] dogshit right about now!"))
--it's the official, standard PMDO way of doing it but these were made before that existed/I was aware of the tag.
--[[
--a or an before an item?
function GeneralFunctions.GetItemArticle(item, uppercase)
	if uppercase == nil then uppercase = false end 
	
	local article = 'a'
	local first_letter = string.upper(string.sub(_DATA:GetItem(item.ID).Name:ToLocal(), 1, 1))

	if first_letter == "A" or first_letter == 'E' or first_letter == 'I' or first_letter == 'O' or first_letter == 'U' then article = 'an' end
	
	if uppercase then article = FirstToUpper(article) end
	
	return article
end

--a or an before the given Color Coded string
function GeneralFunctions.GetColoredStringArticle(str, uppercase)
	if uppercase == nil then uppercase = false end 
	
	local article = 'a'
	local first_letter = string.upper(string.sub(str, 16, 16))

	if first_letter == "A" or first_letter == 'E' or first_letter == 'I' or first_letter == 'O' or first_letter == 'U' then article = 'an' end
	
	if uppercase then article = FirstToUpper(article) end
	
	return article
end
]]--

--gives adventurer points
function GeneralFunctions.RewardPoints(amount, silent)
	if silent == nil then silent = false end
	
	UI:ResetSpeaker(false)--disable text noise. Apparently, sky doesn't actually do this for rewarding points for some reason, but it seems weird to keep it on.
	UI:SetCenter(true)
	
	if not silent then 
		SOUND:PlayFanfare("Fanfare/Item")
		UI:WaitShowDialogue("Team " .. GAME:GetTeamName() .. " earned\n[color=#00FFFF]" .. amount .. "[color] Adventurer Rank Points![pause=40]")
	end
	
	--check if a rank up is needed
	local current_rank = _DATA.Save.ActiveTeam.Rank
	local to_go = _DATA:GetRank(current_rank).FameToNext - _DATA.Save.ActiveTeam.Fame 

	--rank up if there's another rank to go. FameToNext will be 0 or -1 if there's no more ranks after.
	if amount >= to_go and _DATA:GetRank(current_rank).FameToNext > 0 then
		--rank up!
		GeneralFunctions.RankUp(amount - to_go)
	else
		--add points to fame 
		_DATA.Save.ActiveTeam.Fame = _DATA.Save.ActiveTeam.Fame + amount
	end
	UI:ResetSpeaker(true)
	UI:SetCenter(false)
end


--Notifies the player they ranked up, what they rewarded for ranking up, 
function GeneralFunctions.RankUp(leftover_points)
	local current_rank = _DATA.Save.ActiveTeam.Rank
	local next_rank = _DATA:GetRank(current_rank).Next
	
	print(current_rank)
	print(next_rank)
	
	--reset fame, go to next rank
	_DATA.Save.ActiveTeam:SetRank(next_rank)
	_DATA.Save.ActiveTeam.Fame = 0
	
	SOUND:PlayFanfare("Fanfare/RankUp")
	UI:ResetSpeaker()
	UI:SetCenter(true)
	
	UI:WaitShowDialogue("Congratulations!")
	UI:WaitShowDialogue("Team " .. GAME:GetTeamName() .. " went up in rank from the\n[color=#FFA5FF]" .. current_rank:gsub("^%l", string.upper) .. " Rank[color] to the [color=#FFA5FF]" .. next_rank:gsub("^%l", string.upper) .. " Rank[color]!") 
	
	--notify of bag size increase
	if  _DATA:GetRank(current_rank).BagSize < _DATA:GetRank(next_rank).BagSize then
		UI:WaitShowDialogue("The number of items you can store in your Treasure Bag has increased from [color=#00FFFF]" .. tostring(_DATA:GetRank(current_rank).BagSize) .. "[color] to [color=#00FFFF]" .. tostring(_DATA:GetRank(next_rank).BagSize) .. "[color].")
	end

	--depending on the specific rank up achieved, reward the player with different goodies.
	--The goodies and actual rewards are up for change, but this should serve fine for now. Should review in future though.
	local reward_id
	if next_rank == "bronze" then 
		reward_id = "boost_hp_up"
	elseif next_rank == "silver" then 
		reward_id = "boost_protein"
	elseif next_rank == "gold" then 
		reward_id = "boost_iron"
	elseif next_rank == "platinum" then 
		reward_id = "boost_calcium"
	elseif next_rank == "diamond" then 
		reward_id = "boost_zinc"
	elseif next_rank == "super" then 
		reward_id = "boost_carbos"
	elseif next_rank == "ultra" then 
		reward_id = "boost_nectar"
	elseif next_rank == "hyper" then 
		reward_id = "gummi_wonder"
	elseif next_rank == "master" then 
		reward_id = "gummi_wonder"
	elseif next_rank == "guildmaster" then 
		reward_id = "seed_joy"
	elseif next_rank == "grandmaster" then 
		reward_id = "seed_golden"
	else--shouldnt ever happen
		reward_id = "food_grimy"
	end
	
	local item = RogueEssence.Dungeon.InvItem(reward_id, false, 1)
	SOUND:PlayFanfare("Fanfare/Item")
	UI:WaitShowDialogue("For advancing in rank,[pause=10] your team was awarded a " .. item:GetDisplayName() ..".[pause=40]") 
	
	--bag is full - equipped count is separate from bag and most be included in the calc
	if GAME:GetPlayerBagCount() + GAME:GetPlayerEquippedCount() >= GAME:GetPlayerBagLimit() then
		UI:WaitShowDialogue("The " .. item:GetDisplayName() .. " was sent to storage.")
		GAME:GivePlayerStorageItem(item.ID)
	else
		GAME:GivePlayerItem(item.ID)
	end
	
	UI:SetCenter(false)

	
	--silently award any leftover points.
	if leftover_points > 0 then GeneralFunctions.RewardPoints(leftover_points, true) end
end 


--gets the ID of the gummi that matches one of the types of the given pokemon. Chooses the type randomly if they have multiple.
function GeneralFunctions.GetFavoriteGummi(chara)
	local mon = _DATA:GetMonster(chara.CurrentForm.Species)
	local forme = mon.Forms[chara.CurrentForm.Form]
	local typing = forme.Element1
	if forme.Element2 ~= "none" then
		local rand = GeneralFunctions.RandBool()
		if rand then typing = forme.Element2 end
	end
	
	local gummis = {bug = "gummi_green",
					dark = "gummi_black", 
					dragon = "gummi_royal", 
					electric = "gummi_yellow", 
					fairy = "gummi_magenta", 
					fighting = "gummi_orange", 
					fire = "gummi_red", 
					flying = "gummi_sky", 
					ghost = "gummi_purple",
					grass = "gummi_grass", 
					ground = "gummi_brown", 
					ice = "gummi_clear", 
					normal = "gummi_white", 
					poison = "gummi_pink",
					psychic = "gummi_gold",
					rock = "gummi_gray", 
					steel = "gummi_silver", 
					water = "gummi_blue" }
	
	return gummis[typing]
					
end

--have both player and partner turn towards chara at the same time
--shortcut function
function GeneralFunctions.DuoTurnTowardsChar(chara, heroDelay, turnFrames)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	
	turnFrames = turnFrames or 4
	heroDelay = heroDelay or 4
	
	local coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(heroDelay) GROUND:CharTurnToCharAnimated(hero, chara, 4) end)
	local coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)
	
	TASK:JoinCoroutines({coro1, coro2})

end 

--set speaker and emotion beforehand!
function GeneralFunctions.DuoTurnTowardsCharWithDialogue(chara, dialogue, heroDelay, turnFrames)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	
	turnFrames = turnFrames or 4
	heroDelay = heroDelay or 4
	
	local coro1 = TASK:BranchCoroutine(function() GAME:WaitFrames(heroDelay) GROUND:CharTurnToCharAnimated(hero, chara, 4) end)
	local coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)
	UI:WaitShowDialogue(dialogue)
	
	TASK:JoinCoroutines({coro1, coro2})

end 



--feed it a list of pairs of values and weights, it will return a value randomly with regards to the weights
 --[[
	Example:
	local ammo_stock = 
	{
		{{Index = 200, Hidden = 9, Price = 45}, 50},--stick 
		{{Index = 203, Hidden = 9, Price = 45}, 50}--iron thorn 
	}
	
]]--
function GeneralFunctions.WeightedRandom (weights)
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


--initially used for playing tag in numel cutscene, may have uses elsewhere
function GeneralFunctions.RunInCircle(chara, duration, speed, clockwise, run)
	local originalDir = chara.Direction
	local numDir = GeneralFunctions.DirToNum(chara.Direction)
	if clockwise then clockwise = 1 else clockwise = -1 end 
	
	for i = 0, 7, 1 do 
		GROUND:MoveInDirection(chara, GeneralFunctions.NumToDir(numDir + (i * clockwise)), duration, run, speed)
	end
	
	GROUND:EntTurn(chara, originalDir)
	
end



--Halcyon edit for COMMON.GroundInteract; basically just adds a start and end conversation call to it. Removes a charturntochar as well
function GeneralFunctions.GroundInteract(chara, target)
  UI:SetSpeaker(target)
  
  local mon = RogueEssence.Data.DataManager.Instance:GetMonster(target.CurrentForm.Species)
  local form = mon.Forms[target.CurrentForm.Form]
  
  local personality = form:GetPersonalityType(target.Data.Discriminator)
  
  local personality_group = COMMON.PERSONALITY[personality]
  local pool = personality_group.WAIT
  local key = "TALK_WAIT_%04d"
  
  local running_pool = {table.unpack(pool)}
  local valid_quote = false
  local chosen_quote = ""
  
  while not valid_quote and #running_pool > 0 do
    valid_quote = true
    local chosen_idx = math.random(1, #running_pool)
	local chosen_pool_idx = running_pool[chosen_idx]
    chosen_quote = RogueEssence.StringKey(string.format(key, chosen_pool_idx)):ToLocal()
	
    chosen_quote = string.gsub(chosen_quote, "%[hero%]", chara:GetDisplayName())
    
	if not valid_quote then
      -- PrintInfo("Rejected "..chosen_quote)
	  table.remove(running_pool, chosen_idx)
	  chosen_quote = ""
	end
  end
  -- PrintInfo("Selected "..chosen_quote)
  
  
  GeneralFunctions.StartConversation(target, chosen_quote)
  GeneralFunctions.EndConversation(target)
end


--used to start a coroutine to have partner turn towards target NPC while having a conversation start.
--also stops their animations 
function GeneralFunctions.StartConversation(target, dialogue, emotion, npcTurn, changeNPCanimation, changeSpeaker, animation, turnframes)
	if emotion == nil then emotion = 'Normal' end
	if changeSpeaker == nil then changeSpeaker = true end 
	if npcTurn == nil then npcTurn = true end--should NPC turn to face you?
	if changeNPCanimation == nil then changeNPCanimation = true end--should NPC change their animation? useful for flying npcs too
	if animation == nil then animation = 'None' end 
	if turnframes == nil then turnframes = 4 end
	
	
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	partner.IsInteracting = true
	SV.TemporaryFlags.OldDirection = target.Direction
	if changeSpeaker then UI:SetSpeaker(target) end
	UI:SetSpeakerEmotion(emotion)
	GROUND:CharSetAnim(partner, animation, true)
	GROUND:CharSetAnim(hero, animation, true)
	if changeNPCanimation then GROUND:CharSetAnim(target, animation, true) end
		
    GROUND:CharTurnToChar(hero, target)
    if npcTurn then GROUND:CharTurnToChar(target, hero) end
    local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, target, turnframes) end)

    UI:WaitShowDialogue(dialogue)

    TASK:JoinCoroutines({coro1})
	UI:WaitDialog()
	
end 

--call this at the end of an npc conversation, sister function of above StartConversation function 
function GeneralFunctions.EndConversation(target, changeNPCanimation)
	if changeNPCanimation == nil then changeNPCanimation = true end--should NPC change their animation? useful for flying npcs too

	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	
	if target ~= partner then--if partner conversation was started don't turn them back around after
		if SV.TemporaryFlags.OldDirection ~= Direction.None then GROUND:EntTurn(target, SV.TemporaryFlags.OldDirection) end 
		SV.TemporaryFlags.OldDirection = Direction.None -- Clear flag 
	end
	
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	if changeNPCanimation and target ~= partner then GROUND:CharEndAnim(target) end
	
	partner.IsInteracting = false

end





--used to start a conversation between the player and the partner when it's the partner trying to start a conversation w/ the player
function GeneralFunctions.StartPartnerConversation(dialogue, emotion, heroTurn)
	if heroTurn == nil then heroTurn = true end
	if emotion == nil then emotion = 'Normal' end	
	
	
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	partner.IsInteracting = true
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion(emotion)
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
		
    GROUND:CharTurnToCharAnimated(partner, hero, 4)

    UI:WaitShowDialogue(dialogue)
	
	--hero turns towards partner after 1st line of dialogue
	if heroTurn then GROUND:CharTurnToCharAnimated(hero, partner, 4) end
	
end 

--used to start a conversation between the player and the partner that's a YesNo Prompt
function GeneralFunctions.StartPartnerYesNo(dialogue, emotion, heroTurn, defaultToNo)
	if heroTurn == nil then heroTurn = true end
	if emotion == nil then emotion = 'Normal' end	
	if defaultToNo == nil then defaultToNo = true end
	
	
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local result = false
	partner.IsInteracting = true
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion(emotion)
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
		
    GROUND:CharTurnToCharAnimated(partner, hero, 4)

	local coro1 = TASK:BranchCoroutine(function() UI:ChoiceMenuYesNo(dialogue, defaultToNo) 
												  UI:WaitForChoice()
												  result = UI:ChoiceResult() end)
	--hero turns towards partner during their dialogue
	local coro2 = TASK:BranchCoroutine(function() if heroTurn then GROUND:CharTurnToCharAnimated(hero, partner, 4) end end)								  
	TASK:JoinCoroutines({coro1, coro2})

	return result
end 


--character hops twice and makes angry noise 
function GeneralFunctions.Complain(chara, emote)
	if emote == nil then emote = false end 
	
	SOUND:PlayBattleSE('EVT_Emote_Complain_2')
	GeneralFunctions.Hop(chara)
	GeneralFunctions.Hop(chara)
	if emote then GROUND:CharSetEmote(chara, "angry", 0) end 
	
end


--use common.BossTransition for now.
function GeneralFunctions.BossTransition()

end

--do a quick shake in place.
function GeneralFunctions.Shake(chara)
  --GROUND:CharSetAction(CH('PLAYER'), RogueEssence.Ground.FrameGroundAction(CH('PLAYER').Position, CH('PLAYER').Direction, animId, 5))
  GROUND:CharSetDrawEffect(chara, DrawEffect.Trembling)
  GAME:WaitFrames(8)
  GROUND:CharEndDrawEffect(chara, DrawEffect.Trembling)
end

--shake in place until told to stop. Change animation to the first frame of walking while doing so.
--if you don't want that first frame of walk, use GROUND:CharSetDrawEffect and GROUND:CharEndDrawEffect
function GeneralFunctions.StartTremble(chara)
  GROUND:CharSetAction(chara, RogueEssence.Ground.FrameGroundAction(chara.Position, chara.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Walk"), 0))
  GROUND:CharSetDrawEffect(chara, DrawEffect.Trembling)

end 

function GeneralFunctions.StopTremble(chara)
  GROUND:CharEndAnim(chara)
  GROUND:CharEndDrawEffect(chara, DrawEffect.Trembling)

end 

--used to turn towards a specified position which is needed if chara's position is dynamic
function GeneralFunctions.TurnTowardsLocation(chara, targetX, targetY, turnduration)

	local x = chara.Position.X + 8
	local y = chara.Position.Y + 8
	turnduration = turnduration or 4


	--In a normal setting, +y is up, but in pmdo +y is down. So I need to flip the sign on the difference in y between char1 and char2
	local y = -1 * (targetY - y)
	local x = targetX - x
	
	local angle = math.atan(y, x)--this is in radians
	local ratio = math.pi / 8 --for readability

	if angle <= (ratio) and angle >= (-1 * ratio) then 
		GROUND:CharAnimateTurnTo(chara, Direction.Right, turnduration)
	elseif angle > (ratio) and angle < (3 * ratio) then
		GROUND:CharAnimateTurnTo(chara, Direction.UpRight, turnduration)
	elseif angle >= (3 * ratio) and angle <= (5 * ratio) then
		GROUND:CharAnimateTurnTo(chara, Direction.Up, turnduration)
	elseif angle > (5 * ratio) and angle < (7 * ratio) then
		GROUND:CharAnimateTurnTo(chara, Direction.UpLeft, turnduration)
	elseif angle >= (7 * ratio) or angle <= (-7 * ratio) then
		GROUND:CharAnimateTurnTo(chara, Direction.Left, turnduration)
	elseif angle > (-7 * ratio) and angle < (-5 * ratio) then
		GROUND:CharAnimateTurnTo(chara, Direction.DownLeft, turnduration)
	elseif angle >= (-5 * ratio) and angle <= (-3 * ratio) then
		GROUND:CharAnimateTurnTo(chara, Direction.Down, turnduration)
	elseif angle > (-3 * ratio) and angle < (-1 * ratio) then
		GROUND:CharAnimateTurnTo(chara, Direction.DownRight, turnduration)
	else
		--i screwed up with the logic somewhere if one of the above cases isn't selected
		--Spin around like a moron if this statement is reached
		--this should be changed to some sort of error, but i dont know how to log errors properly in PMDO
		GROUND:CharSetAnim(chara, 'Spin', true)
	end
end

function GeneralFunctions.RemoveCharEffects(char)
	char.StatusEffects:Clear();
	char.ProxyAtk = -1;
	char.ProxyDef = -1;
	char.ProxyMAtk = -1;
	char.ProxyMDef = -1;
	char.ProxySpeed = -1;
end

--called whenever to warp the party out, including guests
function GeneralFunctions.WarpOut()
	local player_count = GAME:GetPlayerPartyCount()
	local guest_count = GAME:GetPlayerGuestCount()
	for i = 0, player_count - 1, 1 do 
		local player = GAME:GetPlayerPartyMember(i)
		if not player.Dead then
			GAME:WaitFrames(60)
			local anim = RogueEssence.Dungeon.CharAbsentAnim(player.CharLoc, player.CharDir)
			GeneralFunctions.RemoveCharEffects(player)
			TASK:WaitTask(_DUNGEON:ProcessBattleFX(player, player, _DATA.SendHomeFX))
			TASK:WaitTask(player:StartAnim(anim))
		end
	end

	for i = 0, guest_count - 1, 1 do
		local guest = GAME:GetPlayerGuestMember(i)
		if not guest.Dead then
			GAME:WaitFrames(60)
			local anim = RogueEssence.Dungeon.CharAbsentAnim(guest.CharLoc, guest.CharDir)
			GeneralFunctions.RemoveCharEffects(guest)
			TASK:WaitTask(_DUNGEON:ProcessBattleFX(guest, guest, _DATA.SendHomeFX))
			TASK:WaitTask(guest:StartAnim(anim))
		end
	end
end

--called whenever a mission is completed
function GeneralFunctions.AskMissionWarpOut()
	local function MissionWarpOut()
		GeneralFunctions.WarpOut()
		GAME:WaitFrames(80)
		--Set minimap state back to old setting
		_DUNGEON.ShowMap = SV.TemporaryFlags.PriorMapSetting
		SV.TemporaryFlags.PriorMapSetting = nil
		TASK:WaitTask(_GAME:EndSegment(RogueEssence.Data.GameProgress.ResultType.Escaped))
	end
	
	local function SetMinimap()
		--to prevent accidentally doing something by pressing the button to select yes
		GAME:WaitFrames(10)
		--Set minimap state back to old setting
		_DUNGEON.ShowMap = SV.TemporaryFlags.PriorMapSetting
		SV.TemporaryFlags.PriorMapSetting = nil
	end
	
	local has_ongoing_mission = false
	local curr_floor = GAME:GetCurrentFloor().ID + 1
	local curr_zone = _ZONE.CurrentZoneID
	local curr_segment = _ZONE.CurrentMapID.Segment

	for _, mission in ipairs(SV.TakenBoard) do
		if mission.Floor > curr_floor and mission.Taken and mission.Completion == COMMON.MISSION_INCOMPLETE and curr_zone == mission.Zone and curr_segment == mission.Segment then
			has_ongoing_mission = true
			break
		end
	end


	UI:ResetSpeaker()
	local state = 0
	while state > -1 do
		if state == 0 then
			if has_ongoing_mission then
				UI:ChoiceMenuYesNo("You have more ongoing missions, but would you like to leave the dungeon now?", true)
				UI:WaitForChoice()
				local leave_dungeon = UI:ChoiceResult()
				if leave_dungeon then
					UI:ChoiceMenuYesNo("Do you really want to leave?", true)
					UI:WaitForChoice()
					local leave_confirm = UI:ChoiceResult()
					if leave_confirm then
						state = -1
						MissionWarpOut()
					else
						--pause between textboxes if player de-confirms
						GAME:WaitFrames(20)
					end
				else
					state = -1
					SetMinimap()
				end
			else
				UI:ChoiceMenuYesNo("You have no more ongoing missions beyond this point.\nWould you like to leave the dungeon now?", false)
				UI:WaitForChoice()
				local leave_dungeon = UI:ChoiceResult()
				if leave_dungeon then
						state = -1
						MissionWarpOut()
				else
					state = -1
					SetMinimap()
				end
			end
		end
	end
end

--does a double flash like in a boss transition
function GeneralFunctions.DoubleFlash(sound)
    local center = GAME:GetCameraCenter()
    local emitter = RogueEssence.Content.FlashEmitter()
    emitter.FadeInTime = 2
    emitter.HoldTime = 2
    emitter.FadeOutTime = 2
    emitter.StartColor = Color(0, 0, 0, 0)
    emitter.Layer = DrawLayer.Top
    emitter.Anim = RogueEssence.Content.BGAnimData("White", 0)
    GROUND:PlayVFX(emitter, center.X, center.Y)
    if sound then SOUND:PlayBattleSE("EVT_Battle_Flash") end
    GAME:WaitFrames(16)
    GROUND:PlayVFX(emitter, center.X, center.Y)
    if sound then SOUND:PlayBattleSE("EVT_Battle_Flash") end
end


--debug function used to print plot variables
function GeneralFunctions.PrintPlotVariables()
	print("Chapter = " .. tostring(SV.ChapterProgression.Chapter))
	print("Chapter 1")
	print("PlayedIntroCutscene = " .. tostring(SV.Chapter1.PlayedIntroCutscene))
	print("PartnerEnteredForest = " .. tostring(SV.Chapter1.PartnerEnteredForest))
	print('PartnerCompletedForest = ' .. tostring(SV.Chapter1.ParnterCompletedForest))
	print('PartnerMetHero = ' .. tostring(SV.Chapter1.PartnerMetHero))
	print('TeamCompletedForest = ' .. tostring(SV.Chapter1.TeamCompletedForest))
	print('TeamJoinedGuild = ' .. tostring(SV.Chapter1.TeamJoinedGuild))
	print('MetSnubbull = ' .. tostring(SV.Chapter1.MetSnubbull))
	print('MetZigzagoon = ' .. tostring(SV.Chapter1.MetZigzagoon))
	print('MetCranidosMareep = ' .. tostring(SV.Chapter1.MetCranidosMareep))
	print('MetBreloomGirafarig = ' .. tostring(SV.Chapter1.MetBreloomGirafarig))
	print('MetAudino = ' .. tostring(SV.Chapter1.MetAudino))
	print('PartnerSecondFloorDialogue = ' .. tostring(SV.Chapter1.PartnerSecondFloorDialogue))
	print('TutorialProgression = ' .. tostring(SV.Chapter1.TutorialProgression))
	
	print("Chapter 2")
	print("FirstMorningMeetingDone = " .. tostring(SV.Chapter2.FirstMorningMeetingDone))
	print("StartedTraining = " .. tostring(SV.Chapter2.StartedTraining))
	print("SkippedTutorial = " .. tostring(SV.Chapter2.SkippedTutorial))
	print("FinishedTraining = " .. tostring(SV.Chapter2.FinishedTraining))
	print("FinishedDojoCutscenes = " .. tostring(SV.Chapter2.FinishedDojoCutscenes))
	print("FinishedMarketIntro = " .. tostring(SV.Chapter2.FinishedMarketIntro))
	print("FinishedNumelTantrum = " .. tostring(SV.Chapter2.FinishedNumelTantrum))
	print("FinishedFirstDay = " .. tostring(SV.Chapter2.FinishedFirstDay))
	print("FinishedCameruptRequestScene = " .. tostring(SV.Chapter2.FinishedCameruptRequestScene))
	print("EnteredRiver = " .. tostring(SV.Chapter2.EnteredRiver))
	print("FinishedRiver = " .. tostring(SV.Chapter2.FinishedRiver))
	print("TropiusGaveReviver = " .. tostring(SV.Chapter2.TropiusGaveReviver))
	print("WooperIntro = " .. tostring(SV.Chapter2.WooperIntro))

	print("Chapter 3")
	print("ShowedTitleCard = " .. tostring(SV.Chapter3.ShowedTitleCard))
	print("FinishedOutlawIntro = " .. tostring(SV.Chapter3.FinishedOutlawIntro))
	print("MetTeamStyle = " .. tostring(SV.Chapter3.MetTeamStyle))
	print("FinishedCafeCutscene = " .. tostring(SV.Chapter3.FinishedCafeCutscene))
	print("EnteredCavern = " .. tostring(SV.Chapter3.EnteredCavern))
	print("FailedCavern = " .. tostring(SV.Chapter3.FailedCavern))
	print("EncounteredBoss = " .. tostring(SV.Chapter3.EncounteredBoss))
	print("LostToBoss = " .. tostring(SV.Chapter3.LostToBoss))
	print("EscapedBoss = " .. tostring(SV.Chapter3.EscapedBoss))
	print("DefeatedBoss = " .. tostring(SV.Chapter3.ShowedTitleCard))
	print("ShowedTitleCard = " .. tostring(SV.Chapter3.DefeatedBoss))
	print("FinishedRootScene = " .. tostring(SV.Chapter3.FinishedRootScene))
	print("TropiusGaveWand = " .. tostring(SV.Chapter3.TropiusGaveWand))
	print("BreloomGirafarigConvo = " .. tostring(SV.Chapter3.BreloomGirafarigConvo))

end 

function GeneralFunctions.GetStatEXP(chara)
	print("HP Stat EXP = " .. tostring(chara.MaxHPBonus))
	print("Attack Stat EXP = " .. tostring(chara.AtkBonus))
	print("Defense Stat EXP = " .. tostring(chara.DefBonus))
	print("Sp. Atk Stat EXP = " .. tostring(chara.MAtkBonus))
	print("Sp. Def Stat EXP = " .. tostring(chara.MDefBonus))
	print("Speed Stat EXP = " .. tostring(chara.SpeedBonus))
end


function GeneralFunctions.TableContains(table, val)
	for i=1,#table do
		 if table[i] == val then 
				return true
		 end
	end
	return false
end

function GeneralFunctions.RemoveAllItems()
	local save = _DATA.Save
	local inv_count = save.ActiveTeam:GetInvCount() - 1

  --remove bag items
  for i = inv_count, 0, -1 do
    local entry = _DATA:GetItem(save.ActiveTeam:GetInv(i).ID)
    --if not entry.CannotDrop then
      save.ActiveTeam:RemoveFromInv(i)
    --end
  end
  
  --remove equips
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

function GeneralFunctions.RemoveAllGuests()
	local guest_count = GAME:GetPlayerGuestCount()
	for i = 0, guest_count - 1, 1 do --beam everyone else out
		PrintInfo("REMOVING GUESTS")
		GAME:RemovePlayerGuest(0)
	end
end

function GeneralFunctions.RestoreIdleAnim()
	local player_count = GAME:GetPlayerPartyCount()
	local guest_count = GAME:GetPlayerGuestCount()
	for i = 0, player_count - 1, 1 do 
		local player = GAME:GetPlayerPartyMember(i)
		local anim = RogueEssence.Dungeon.CharAnimIdle(player.CharLoc, player.CharDir)
		TASK:WaitTask(player:StartAnim(anim))
	end

	for i = 0, guest_count - 1, 1 do
		local guest = GAME:GetPlayerGuestMember(i)
		local anim = RogueEssence.Dungeon.CharAnimIdle(guest.CharLoc, guest.CharDir)
		TASK:WaitTask(guest:StartAnim(anim))
	end
end

function GeneralFunctions.TeamTurnTo(char) 
	local player_count = GAME:GetPlayerPartyCount()
	local guest_count = GAME:GetPlayerGuestCount()
	for i = 0, player_count - 1, 1 do 
		local player = GAME:GetPlayerPartyMember(i)
		if not player.Dead then
			DUNGEON:CharTurnToChar(player, char)
		end
	end

	for i = 0, guest_count - 1, 1 do
		local guest = GAME:GetPlayerGuestMember(i)
		if not guest.Dead then
			DUNGEON:CharTurnToChar(guest, char)
		end
	end
end


--When you need a multipaged Choice Menu. Returns the result, so use it as the BeginChoiceMenu, WaitFroChoice, and UIChoiceResult block.
--One potential byproduct of using this menu is that it sets the text speed to instant, then back to normal. If you set text speed before to instant
--it'll get undone by this function potentially, so be aware.
function GeneralFunctions.PagedChoiceMenu(message, choices, defaultchoice, cancelchoice)
	local choice_amount = #choices
	local choice_submenus = {}
	local submenu_length = 10
	local result
	
	--if you see weird - and + 1 with a modulo, its indexing shenanigans.
	if choice_amount > submenu_length then
		--populate choice_submenus 
		for i = 1, choice_amount, 1 do 
			if i % submenu_length == 1 then table.insert(choice_submenus, {}) end --add an empty table in if we need to start a new subtable
			choice_submenus[math.ceil(i / submenu_length)][((i - 1) % submenu_length) + 1] = choices[i]
		end 
		
		for i = 1, #choice_submenus, 1 do
			table.insert(choice_submenus[i], "Prev Page")
			table.insert(choice_submenus[i], "Next Page")
		end
		
		local continue = false 
		local current_submenu = 1
		local total_submenus = #choice_submenus
		local default_cursor_option  = 1--stay on whatever we selected last (next or last page)
		--Loop submenus until player chooses an actual option.
		while not continue do
			UI:BeginChoiceMenu(message, choice_submenus[current_submenu], default_cursor_option, # choice_submenus[current_submenu])
			UI:WaitForChoice()
			result = UI:ChoiceResult()
			UI:SetAutoFinish(true)--so submenus dont have to repeat the entire query.
			
			--prev page 
			if result == #choice_submenus[current_submenu] - 1 then 
				current_submenu = ((current_submenu - 2) % total_submenus) + 1
				default_cursor_option = #choice_submenus[current_submenu] - 1
			--next page 
			elseif result == #choice_submenus[current_submenu] then
				current_submenu = (current_submenu % total_submenus) + 1
				default_cursor_option = #choice_submenus[current_submenu]
			--an actual choice. Need to adjust the result according to the submenu.
			else 
				result = result + ((current_submenu - 1) * submenu_length)
				continue = true 
				UI:SetAutoFinish(false)--set this back to not auto finish. No way to check if it is on or off before we get here, so typical situation we'd want is to turn it back off. Destructive, but what can you do.
			end 
		end 
	else
		UI:BeginChoiceMenu(message, choices, defaultchoice, cancelchoice)
		UI:WaitForChoice()
		result = UI:ChoiceResult()
	end 
	
	--print("result is: " .. tostring(result))
	return result
	
end 


function GeneralFunctions.PrintMissionType(mission)
	local val = mission.Type

	if val == COMMON.MISSION_TYPE_RESCUE then
		PrintInfo("=====RESCUE=====")
  elseif val == COMMON.MISSION_TYPE_ESCORT then
		PrintInfo("=====ESCORT=====")
	elseif val == COMMON.MISSION_TYPE_EXPLORATION then
		PrintInfo("=====EXPLORATION=====")
  elseif val == COMMON.MISSION_TYPE_OUTLAW then 
		PrintInfo("=====OUTLAW=====")
	elseif val == COMMON.MISSION_TYPE_OUTLAW_FLEE then
		PrintInfo("=====OUTLAW_FLEE=====")
	elseif val == COMMON.MISSION_TYPE_OUTLAW_MONSTER_HOUSE then
		PrintInfo("=====OUTLAW_MONSTER_HOUSE=====")
	elseif val == COMMON.MISSION_TYPE_LOST_ITEM then 
		PrintInfo("=====LOST_ITEM=====")
	elseif val == COMMON.MISSION_TYPE_DELIVERY then 
		PrintInfo("=====OUTLAW_MONSTER_HOUSE=====")
  elseif val == COMMON.MISSION_TYPE_OUTLAW_ITEM then 
		PrintInfo("=====OUTLAW_ITEM=====")
  end
end 


function GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
	local hero = CH('PLAYER')
    local partner = CH('Teammate1')
    partner.IsInteracting = true
    GROUND:CharSetAnim(partner, 'None', true)
    GROUND:CharSetAnim(hero, 'None', true)		
    GeneralFunctions.TurnTowardsLocation(hero, obj.Position.X + obj.Width // 2, obj.Position.Y + obj.Height // 2)
    GeneralFunctions.TurnTowardsLocation(partner, obj.Position.X + obj.Width // 2, obj.Position.Y + obj.Height // 2)
	
	
	local state = 0

	while state > - 1 do 
		local has_items = GAME:GetPlayerBagCount() > 0
		local has_equipment = GAME:GetPlayerEquippedCount() > 0
		local has_storage = GAME:GetPlayerStorageCount() > 0
				
		local choices = { { STRINGS:FormatKey('MENU_STORAGE_STORE'), has_items or has_equipment},
		{ STRINGS:FormatKey('MENU_STORAGE_TAKE_ITEM'), has_storage},
		{ STRINGS:FormatKey('MENU_STORAGE_STORE_ALL'), has_items},
		{ STRINGS:FormatKey('MENU_STORAGE_MONEY'), true},
		{ "Save", true},
		{ STRINGS:FormatKey("MENU_CANCEL"), true}}	
	
		UI:ResetSpeaker()
		UI:SetCenter(true)
		UI:SetAutoFinish(true)
		UI:BeginChoiceMenu("What would you like to do?", choices, 1, #choices)
		UI:WaitForChoice()
		local result = UI:ChoiceResult()
		UI:SetCenter(false)
		UI:SetAutoFinish(false)
		
		
		if result == 1 then
			UI:StorageMenu()
			UI:WaitForChoice()
		elseif result == 2 then
			UI:WithdrawMenu()
			UI:WaitForChoice()
		elseif result == 3 then
			GeneralFunctions.SendInvToStorage(true, false, true)
			UI:SetCenter(true)
			UI:WaitShowDialogue("All unequipped items have been stored.")
			UI:SetCenter(false)
		elseif result == 4 then
			UI:BankMenu()
			UI:WaitForChoice()
		elseif result == 5 then
			state = -1
			GeneralFunctions.PromptSaveAndQuit()
		else
			state = -1
		end
	end
	
	partner.IsInteracting = false
	
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	
end