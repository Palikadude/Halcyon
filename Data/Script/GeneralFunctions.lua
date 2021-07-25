require 'common'
GeneralFunctions = {}

--[[These are functions/procedures that are useful in a multitude of different maps or situations. Things such as
reseting daily flags, a function to have the pokemon look in a random number of randections, etc.


]]--

function GeneralFunctions.ResetDailyFlags()
	SV.DailyFlags = 
	{
	  RedMerchantItem = -1,
	  RedMerchantBought = false,
	  GreenMerchantItem = -1,
	  GreenMerchantBought = false
	}
end 


--to be called at the end of the day 
function GeneralFunctions.EndOfDay()
	SV.ChapterProgression.DaysPassed = SV.ChapterProgression.DaysPassed + 1
	GeneralFunctions.ResetDailyFlags()

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
	return GAME.Rand:Next(0, 1) == 0
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
				rand = GAME.Rand:Next(0, 7)--pick a random direction
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
				GAME:WaitFrames(12)--pause
				turnLeft = false
			else
				GROUND:CharAnimateTurn(chara, rightDir, turnframes, turnLeft)
				GAME:WaitFrames(12)--pause
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

	local coro1 = TASK:BranchCoroutine(GAME:_MoveCamera(camX, camY, cameraFrames, false))
	GROUND:MoveToPosition(chara, x, y, run, charSpeed)
	TASK:JoinCoroutines({coro1})


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
	GROUND:CharSetAnim(chara, anim, true)
end


--wait frames, then move to target location. Intended use is to desync characters that are walking together to make it look more natural
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
		pause = 20
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
	elseif anim == 'DeepBreath' then
		pause = 80
	end

	GROUND:CharSetAnim(chara, anim, false)
	GAME:WaitFrames(pause)
	GROUND:CharSetAnim(chara, prevAnim, true)
end

function GeneralFunctions.GetPronoun(chara, form, uppercase)
--used to get proper pronoun depending on gender of character (gender check command)
	--form should be given as they, them, their, theirs, themself, or they're
	local gender = chara.CurrentForm.Gender
	local value = 'shart'
	
	if uppercase == nil then uppercase = false end 
	
	if gender == Gender.Female then
		if form == 'they' then value = 'she'
		elseif form == 'them' then value = 'her'
		elseif form == 'their' then value = 'her'
		elseif form == 'theirs' then value = 'hers'
		elseif form == 'themself' then value = 'herself'
		elseif form == "they're" then value = "she's"
		elseif form == "are" then value = "is"
		end
	elseif gender == Gender.Male then
		if form == 'they' then value = 'he'
		elseif form == 'them' then value = 'him'
		elseif form == 'their' then value = 'his'
		elseif form == 'theirs' then value = 'his'
		elseif form == 'themself' then value = 'himself'
		elseif form == "they're" then value = "he's"
		elseif form == "are" then value = "is"
		end
	else--if not male or female, it's a they so just return the form 
		value = form
	end
	
	print(uppercase)
	if uppercase then
		return value:gsub("^%l", string.upper)
	else	
		return value
	end
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
		print(value:GetDisplayName() .. "'s position: " .. value.Position.X .. " " .. value.Position.Y)
	end
	
	local avgX = math.floor(totalX / length)
	local avgY = math.floor(totalY / length)
	
	if speed == nil or startX == nil or startY == nil then
		frameDur = 1
	else
		frameDur = GeneralFunctions.CalculateCameraFrames(startX, startY, avgX, avgY, speed)
	end
	
	print('CenterCamera: X = ' .. avgX .. '    Y = ' .. avgY)
	GAME:MoveCamera(avgX, avgY, frameDur, false)
	
end

--useful for having characters face constantly towards someone who's moving
function GeneralFunctions.FaceMovingCharacter(chara, target)
	local currentLocX = -999
	local currentLocY = -999
	while not (currentLocX == target.Position.X and currentLocY == target.Position.Y) do
		GROUND:CharTurnToChar(chara, target)
		currentLocX = target.Position.X
		currentLocY = target.Position.Y
		GAME:WaitFrames(4)
	end
end


function GeneralFunctions.DialogueWithEmote(chara, emote, str)

end  
