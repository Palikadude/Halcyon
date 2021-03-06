require 'common'
GeneralFunctions = {}

--[[These are functions/procedures that are useful in a multitude of different maps or situations. Things such as
reseting daily flags, a function to have the pokemon look in a random number of randections, etc.

List of custom variables attached to pokemon:
Importance: used mainly to mark the Hero and the Partner. is equal to 'Hero' if hero and 'Partner' if partner.
nil otherwise, but may be used in future to flag other party members/npcs as being important in someway.

AddBack: Marks the character to be added back when the party is reset,value is the slot to add them back at.
If it's nil then don't add them back. Set it to nil after adding them back
]]--

function GeneralFunctions.ResetDailyFlags()
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
end 

--to be called at the end of the day. A generic function for generic days (i.e. no cutscene) 
function GeneralFunctions.EndOfDay()
	SV.ChapterProgression.DaysPassed = SV.ChapterProgression.DaysPassed + 1
	GeneralFunctions.ResetDailyFlags()

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
function GeneralFunctions.LookAround(chara, rotations, turnframes, allDirections, sound, startLeft, enddir)


	if allDirections == nil then allDirections = true end 
	if sound == nil then sound = true end 
	if startLeft == nil then startLeft = true end 
	if enddir == nil then enddir = chara.Direction end

	local dir = 0
	
	--play the looking around sfx if we want a sound to be made
	if sound then SOUND:PlaySE("EVT_Emote_Confused_2") end

	--if all directions, look in any of the 8 directions randomly (except the one we are already facing)
	--if not all directions, alternate between looking 90 degrees left and right from current direction
	--at the end, face towards the enddir if specified
	if allDirections then 
		for i = 1, rotations, 1 do
			local currentDir = chara.Direction
			local numDir = GeneralFunctions.DirToNum(currentDir)
			local diff = 0
			local rand = 0
			repeat
				rand = math.random(0, 7)--pick a random direction
				diff = math.abs(numDir - rand)
			until (diff > 1 and diff < 7)--chosen direction must be at least 90 degrees different 
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
		emt = 1
		sfx = "EVT_Emote_Startled_2"
		pause = 20--test this one 
	elseif emote == 'Notice' then --this one is the 3 lines
		emt = 2
		sfx = 'EVT_Emote_Exclaim'
		pause = 30
	elseif emote == 'Exclaim' then --this one is the !
		emt = 3
		sfx = 'EVT_Emote_Exclaim_2'
		pause = 20
	elseif emote == 'Glowing' then 
		emt = 4
		sfx = 'EVT_Emote_Startled_2'
		pause = 20--test this one
	elseif emote == 'Sweating' then
		emt = 5
		sfx = 'EVT_Emote_Sweating'
		pause = 40 
	elseif emote == 'Question' then
		emt = 6
		sfx = 'EVT_Emote_Confused'
		pause = 40
	elseif emote == 'Angry' then
		emt = 7
		sfx = 'EVT_Emote_Complain_2'
		pause = 40 --test this one
	elseif emote == 'Shock' then
		emt = 8
		sfx = 'EVT_Emote_Shock'
		pause = 40
	else--sweatdrop
		emt = 9
		sfx = 'EVT_Emote_Sweatdrop'
		pause = 40
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
	local pause = 0
	--todo: return character to their animation from before. For now just set them back to None
	local prevAnim = 'None'
	
	if anim == 'Nod' then 
		pause = 20
	elseif anim == 'Wake' then
		pause = 40
	elseif anim == 'Hop' then
		pause = 24
	elseif anim == 'DeepBreath' then
		pause = 80
	end

	GROUND:CharWaitAnim(chara, anim)
	--GAME:WaitFrames(pause)
	GROUND:CharSetAnim(chara, prevAnim, true)
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
	toPlayer = toPlayer or true
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
		GROUND:CharSetEmote(chara, -1, 0)
		
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
function GeneralFunctions.DefaultParty(spawn, others, in_dungeon)
	--Clear party 
	local partyCount = GAME:GetPlayerPartyCount()
	local p = 0
	local tbl = 0
	others = others or false
	in_dungeon = in_dungeon or false
	
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
		p = GAME:GetPlayerAssemblyMember(i - found)
		tbl = LTBL(p)
		--print(tbl.Importance)
		--print(p.Nickname)
		GAME:RemovePlayerAssembly(i-found)
		if tbl.Importance == 'Hero' then --hero goes in slot 1
			bufferTable[1] = p
			found = found + 1
		elseif tbl.Importance == 'Partner' then --partner in slot 2
			bufferTable[2] = p
			found = found + 1
			--if spawn then --call teammate 1 spawner
			--	GROUND:SpawnerSetSpawn('TEAMMATE_1', p)
			--	GROUND:SpawnerDoSpawn("TEAMMATE_1", p)
			--end
		elseif tbl.AddBack ~= nil then--misc goons go in remaining slots
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
		GAME:AddPlayerTeam(bufferTable[i])
	end
	
	--TODO: Remove this when audino updates set team leader index to work in dungeons. Only dungeon init scripts should have the in dungeon parameter set
	if in_dungeon then
		_DATA.Save.ActiveTeam.LeaderIndex = 0
	else 
		GAME:SetTeamLeaderIndex(0)--this doesn't work in dungeons right now
	end
	
	
	--guests are temporary and are for plot or missions. Delete them all, if they're needed again, whatever put them into your team will place them back in
	local guestCount = GAME:GetPlayerGuestCount()
	for i = 1, guestCount, 1 do 
		local g = GAME:RemovePlayerGuest(i-1)
	end

	
	if spawn then 	
		COMMON.RespawnAllies()
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

	
	GROUND:CharHopAnim(chara, anim, height, duration)
	
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
	
	GROUND:CharHopAnim(chara, anim, height, duration)
	GAME:WaitFrames(duration)--need to pause no matter what here because only one hop will show otherwise
	GROUND:CharHopAnim(chara, anim, height, duration)

	if pause then --only pause on 2nd hop if pause needed
		GAME:WaitFrames(duration)
	end

end



function GeneralFunctions.Recoil(chara, anim, height, duration, sound)

	anim = anim or 'Hurt'
	height = height or 10
	duration = duration or 10
	if sound == nil then sound = true end
	
	GROUND:CharSetEmote(chara, 8, 1)
	SOUND:PlayBattleSE('EVT_Emote_Startled')
	GROUND:CharHopAnim(chara, anim, height, duration)
	GAME:WaitFrames(duration)
	GROUND:CharSetEmote(chara, -1, 0)
	
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
		GAME:WaitFrames(20)
	elseif result == 2 then 
		GAME:GroundSave()
		UI:ResetSpeaker()
		UI:WaitShowDialogue("Game saved! Returning to title.")
		GAME:WaitFrames(20)
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
		GAME:WaitFrames(20)
	end
end

--used for chapter end save and quit prompts. Needs to be its own function as we can't call a map transition after if we choose save and quit.
--this should really only ever be called if the ground you want to enter next is the one you're already on.
--also this is kind of a workaround method due to how map transitions and reset to title works.

function GeneralFunctions.PromptChapterSaveAndQuit(ground, marker)
	UI:ResetSpeaker()
	UI:BeginChoiceMenu("What would you like to do?", {"Save and continue.", "Save and quit.", "Cancel"}, 1, 3)
	UI:WaitForChoice()
	local result = UI:ChoiceResult()
	if result == 1 then 
		GAME:GroundSave()
		UI:ResetSpeaker()
		UI:WaitShowDialogue("Game saved!")
		GAME:EnterGroundMap(ground, marker)
	elseif result == 2 then 
		GAME:GroundSave()
		UI:ResetSpeaker()
		UI:WaitShowDialogue("Game saved! Returning to title.")
		GAME:FadeOut(false, 40)
		GAME:RestartToTitle()
	end
end

--sends all bagged items and money to storage. There is no practical limit on storage size (it stores as many as an int32, so... lol)
function GeneralFunctions.SendInvToStorage()
	local itemCount = GAME:GetPlayerBagCount()
	local money = GAME:GetPlayerMoney()
	
	--move player's money to the bank
	GAME:RemoveFromPlayerMoney(money)
	GAME:AddToPlayerMoneyBank(money)
	
	for i = 1, itemCount, 1 do
		local item = GAME:GetPlayerBagItem(0)
		GAME:TakePlayerBagItem(0)
		GAME:GivePlayerStorageItem(item)
	end
end

--used to reward items to the player, sends the item to storage if inv is full
function GeneralFunctions.RewardItem(itemID, money, hiddenValue)
	--if money is true, the itemID is instead the amount of money to award
	if money == nil then money = false end 
	
	UI:ResetSpeaker(false)--disable text noise
	UI:SetCenter(true)
	
	
	SOUND:PlayFanfare("Fanfare/Item")
	
	if money then 
		UI:WaitShowDialogue("Team " .. GAME:GetTeamName() .. " received " .. "[color=#00FFFF]" .. itemID .. "[color=#00FFFF]" .. STRINGS:Format("\\uE024") .. ".[pause=40]") 
		GAME:AddToPlayerMoney(itemID)
	else	
		local itemEntry = RogueEssence.Data.DataManager.Instance:GetItem(itemID)
		
		if hiddenValue == nil then hiddenValue = itemEntry.MaxStack end 

		local item = RogueEssence.Dungeon.InvItem(itemID, false, hiddenValue)

		UI:WaitShowDialogue("Team " .. GAME:GetTeamName() .. " received a " .. item:GetDisplayName() ..".[pause=40]") 
		
		--bag is full
		if GAME:GetPlayerBagCount() == GAME:GetPlayerBagLimit() then
			UI:WaitShowDialogue("The " .. item:GetDisplayName() .. " was sent to storage.")
			GAME:GivePlayerStorageItem(item.ID, 1, false, hiddenValue)
		else
			GAME:GivePlayerItem(item.ID, 1, false, hiddenValue)
		end
	
	end
	UI:SetCenter(false)
	UI:ResetSpeaker()
			
		
end

--gets the ID of the gummi that matches one of the types of the given pokemon. Chooses the type randomly if they have multiple.
function GeneralFunctions.GetFavoriteGummi(chara)
	local mon = _DATA:GetMonster(chara.CurrentForm.Species)
	local forme = mon.Forms[chara.CurrentForm.Form]
	local typing = forme.Element1
	if forme.Element2 ~= 0 then
		local rand = GeneralFunctions.RandBool()
		if rand then typing = forme.Element2 end
	end
	
	local gummis = {80, --bug
					77, --dark 
					87, --dragon 
					90, --electric 
					93, --fairy 
					82, --fighting 
					86, --fire 
					91, --flying 
					85, --ghost
					79, --grass 
					81, --ground 
					78, --ice 
					89, --normal 
					84, --poison
					83, --psychic
					92, --rock 
					88,--steel 
					76} --water 
	
	return gummis[typing]
					
end

--have both player and partner turn towards chara at the same time
--shortcut function
function GeneralFunctions.DuoTurnTowardsChar(chara, turnFrames)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	
	turnFrames = turnFrames or 4
	
	local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(hero, chara, 4) end)
	local coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)
	
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

--character hops twice and makes angry noise 
function GeneralFunctions.Complain(chara, emote)
	if emote == nil then emote = false end 
	
	SOUND:PlayBattleSE('EVT_Emote_Complain_2')
	GeneralFunctions.Hop(chara)
	GeneralFunctions.Hop(chara)
	if emote then GROUND:CharSetEmote(chara, 7, 0) end 
	
end




