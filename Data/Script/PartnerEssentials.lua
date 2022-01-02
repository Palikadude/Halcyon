require 'CharacterEssentials'
PartnerEssentials = {}

--helper function, used if a dialogue bit will be used on multiple maps...
local function in_array(value, array)
    for index = 1, #array do
        if array[index] == value then
            return true
        end
    end

    return false -- We could ommit this part, as nil is like false
end

--This function is called to move partner to a specific marker on loading a new map
function PartnerEssentials.InitializePartnerSpawn(dir, customPosition)
	--Each map has an initial point where the partner spawns. 
	--Set the Partner Spawn variable to default to let the partner spawn there
	--My nomenclature, to keep things consistent, is to just copy the player's spawn marker's name,
	--add _Partner to the end for the partner's marker.
	--You can specify the dir parameter for a custom direction to spawn as if you want.
	--This function also assigns ground partner AI to the partner so they actually follow you.
	
	if GAME:GetPlayerPartyCount() < 2 then return end --do nothing if party is only size 1 
	
	local partner = CH('Teammate1')
	local player = CH('PLAYER')

	
	--in case a custom position is ever needed
	if customPosition ~= nil then 
		dir = dir or partner.Direction
		GROUND:TeleportTo(partner, customPosition.X, customPosition.Y, dir)
	--otherwise use the marker system
	elseif SV.partner.Spawn ~= 'Default' then
		local player = CH('PLAYER')
		local marker = MRKR(SV.partner.Spawn)
		dir = dir or marker.Direction or partner.Direction
		
		
		GROUND:TeleportTo(partner, marker.Position.X, marker.Position.Y, dir)
	end	
	

	AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)
    partner.CollisionDisabled = true
	
end

--when reloading a save, load the partner back in at the proper coordinates.
function PartnerEssentials.LoadGamePartnerPosition(partner)
	print("loading partner in, activating their AI")
	GROUND:TeleportTo(partner, SV.partner.LoadPositionX, SV.partner.LoadPositionY, PartnerEssentials.NumToDir(SV.partner.LoadDirection))--sv doesn't seem to like storing custom classes
	AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)
	AI:EnableCharacterAI(partner)
end

--when saving the game, make note of where the partner is and where they're facing so we can reload them that way.
function PartnerEssentials.SaveGamePartnerPosition(partner)
	SV.partner.LoadPositionX = partner.Position.X
	SV.partner.LoadPositionY = partner.Position.Y
	SV.partner.LoadDirection = PartnerEssentials.DirToNum(partner.Direction)--sv doesnt seem to like storing custom classes
end


--assigns a number value to each direction, useful for figuring out how many turn a direction is from another
function PartnerEssentials.DirToNum(dir)
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
function PartnerEssentials.NumToDir(num)
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



--[[
partner's dialogue can be changed by walking over markers that indicate where in a map you're standing. This gives you the ability
to have the partner's dialogue be much more dynamic than the normal PMD games. This command is basically just going to a giant
case statement methinks.
]]--
function PartnerEssentials.GetPartnerDialogue(partner)
	
	assert(pcall(load("PartnerEssentials.Chapter_" .. tostring(SV.ChapterProgression.Chapter) .. "_Dialogue(...)"), partner))
	
end



--subfunctions that contain dialogue used in each chapter for partner follow dialogue
--TODO: Think of a way to make this less Yandere-Dev
--ground names as a key into a table perhaps? Might get kind of funky when it comes to flag or marker conditionals... At least separate by grounds I think.
function PartnerEssentials.Chapter_1_Dialogue(partner)
	local ground = GAME:GetCurrentGround().AssetName--get ground's internal name
	UI:SetSpeaker(partner)
	GROUND:CharTurnToCharAnimated(partner, CH('PLAYER'), 4)
	GROUND:CharTurnToCharAnimated(CH('PLAYER'), partner, 4)
	UI:SetSpeakerEmotion('Normal')

	if ground == 'guild_second_floor' then
		--PartnerSecondFloorDialogue flag is 0-3, 0 happens once, 1 is a default message, and 2 and 3 are after speaking to guildmates. it cycles through available dialogues
		if SV.Chapter1.PartnerSecondFloorDialogue == 0 then
			UI:WaitShowDialogue("This is where the guild posts jobs and requests for adventurers to take.")
			UI:WaitShowDialogue("Lots of different Pokémon gather here everyday.[pause=0] I'm sure we'll meet all kinds of Pokémon here!")
			GAME:WaitFrames(20)
			UI:WaitShowDialogue("You know...[pause=0] Before today,[pause=10] this was the only part of the guild's interior I'd seen.")
			UI:SetSpeakerEmotion("Sad")
			UI:WaitShowDialogue("Without a partner,[pause=10] they didn't even give me a shot to become an apprentice...")
			UI:WaitShowDialogue("So I never saw the upstairs area or the Guildmaster until today.")
			GAME:WaitFrames(20)
			UI:SetSpeakerEmotion("Inspired")
			UI:WaitShowDialogue("But that's OK![pause=0] We're with the guild now and that's all that matters!")
			UI:WaitShowDialogue("We're going to make a fantastic team " .. CH('PLAYER'):GetDisplayName() .. "![pause=0] I know we're gonna do great!")
			SV.Chapter1.PartnerSecondFloorDialogue = 1
		elseif SV.Chapter1.PartnerSecondFloorDialogue == 1 then
			UI:WaitShowDialogue("This is where the guild posts jobs and requests for adventurers to take.")
			UI:WaitShowDialogue("Lots of different Pokémon gather here everyday.[pause=0] I'm sure we'll meet all kinds of Pokémon here!")
			if SV.Chapter1.MetCranidosMareep then 
				SV.Chapter1.PartnerSecondFloorDialogue = 2
			elseif SV.Chapter1.MetZigzagoon then
				SV.Chapter1.PartnerSecondFloorDialogue = 3
			end
		elseif SV.Chapter1.PartnerSecondFloorDialogue == 2 then--mareep/cranidos dialogue
			UI:SetSpeakerEmotion("Angry")
			GROUND:CharSetEmote(partner, 7, 0)
			UI:WaitShowDialogue("That " .. CharacterEssentials.GetCharacterName('Cranidos') .. "...[pause=0] What a bully!")
			UI:WaitShowDialogue("I still can't believe how disrespectful he was!")
			GAME:WaitFrames(20)
			GROUND:CharSetEmote(partner, -1, 0)
			UI:SetSpeakerEmotion("Normal")
			UI:WaitShowDialogue(CharacterEssentials.GetCharacterName('Mareep') .. " was very kind though.[pause=0] I'm curious what she has to show us about outlaws.")
			UI:SetSpeakerEmotion("Happy")
			UI:WaitShowDialogue("She must be good at dealing with bad Pokémon if she can keep " .. CharacterEssentials.GetCharacterName('Cranidos') .. " in check,[pause=10] haha!")
			if SV.Chapter1.MetZigzagoon then 
				SV.Chapter1.PartnerSecondFloorDialogue = 3
			else
				SV.Chapter1.PartnerSecondFloorDialogue = 1
			end
		elseif SV.Chapter1.PartnerSecondFloorDialogue == 3 then
			UI:SetSpeakerEmotion('Worried')
			UI:WaitShowDialogue("Do you think " .. CharacterEssentials.GetCharacterName('Zigzagoon') .. " is going to put us in his almanac?")
			UI:SetSpeakerEmotion("Normal")
			UI:WaitShowDialogue("We'll have to check it out after a while to see,[pause=10] I guess.[pause=0] I want to know what he'd write about us!")
			SV.Chapter1.PartnerSecondFloorDialogue = 1
		end
	elseif ground == 'guild_third_floor_lobby' then
		UI:WaitShowDialogue("This looks like the lobby area...")
		UI:WaitShowDialogue("Doesn't look like anyone's here though.[pause=0] Let's look in the other rooms!")
	elseif ground == 'guild_dining_room' then
		if SV.Chapter1.MetSnubbull then
			UI:SetSpeakerEmotion("Inspired")
			UI:WaitShowDialogue("I'm excited to eat a meal with all our new guildmates!")
			UI:WaitShowDialogue("I've never eaten at a big table like this before!")
			UI:SetSpeakerEmotion("Normal")
			UI:WaitShowDialogue("I just hope " .. CharacterEssentials.GetCharacterName("Snubbull") .. " is as good as a chef as she claims.")
		else
			UI:WaitShowDialogue("Oh,[pause=10] this must be the dining hall.[pause=0] You think the food here is any good?")
		end
		
	elseif ground == 'guild_heros_room' then
		if SV.Chapter1.MetSnubbull and SV.Chapter1.MetZigzagoon and SV.Chapter1.MetCranidosMareep and SV.Chapter1.MetBreloomGirafarig and SV.Chapter1.MetAudino then
			UI:WaitShowDialogue("Yawn...[pause=0] I'm getting pretty sleepy...")
			UI:WaitShowDialogue("Let's get some shut-eye so we're ready for the start of our training tomorrow!")
		else 
			UI:SetSpeakerEmotion("Inspired")
			UI:WaitShowDialogue("Can you believe we got a room this nice?")
			UI:WaitShowDialogue("The rest of the guild must be this nice as well!")
			UI:SetSpeakerEmotion("Normal")
			UI:WaitShowDialogue("We should go explore the guild and say hi to all of our new guildmates!")
		end
	elseif ground == 'guild_bottom_left_bedroom' then 
		if SV.Chapter1.MetBreloomGirafarig then
			UI:SetSpeakerEmotion("Stunned")
			UI:WaitShowDialogue("These two are quite a couple of characters,[pause=10] aren't they...?")
			UI:WaitShowDialogue("Especially that " .. CharacterEssentials.GetCharacterName("Girafarig") .. "...[pause=0] I still don't know what to think of him...")
			GAME:WaitFrames(20)
			UI:SetSpeakerEmotion("Happy")
			UI:WaitShowDialogue("Well,[pause=10] they're both friendly anyways.[pause=0] I guess that's all that matters.")
		else
			UI:WaitShowDialogue("Oh,[pause=10] there's a couple of Pokémon over there![pause=0] Let's say hello!")
		end
		
	elseif in_array(ground, {'guild_bottom_right_bedroom',
							 'guild_top_left_bedroom'}) then 
		UI:WaitShowDialogue("This looks like one of the bedrooms.")
		UI:WaitShowDialogue("Nobody seems to be here right now though,[pause=10] let's check some of the other rooms!")
		
	elseif ground == 'guild_top_right_bedroom' then
		if SV.Chapter1.MetSnubbull and SV.Chapter1.MetZigzagoon and SV.Chapter1.MetCranidosMareep and SV.Chapter1.MetBreloomGirafarig and SV.Chapter1.MetAudino then
			UI:WaitShowDialogue("Looks like " .. CharacterEssentials.GetCharacterName("Audino") .. " finally finished all her chores.")
			UI:WaitShowDialogue("Let her sleep,[pause=10] it's probably best we go get some now too.")
		else
			UI:WaitShowDialogue("This looks like one of the bedrooms.")	
			UI:WaitShowDialogue("Nobody seems to be here right now though,[pause=10] let's check some of the other rooms!")
		end
	
	elseif ground == 'guild_bedroom_hallway' then
		UI:WaitShowDialogue("I guess the rooms on the sides of the hallway are the other guild members' bedrooms.")
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue("I hope we wouldn't be intrusive if we went in.")
		
	elseif ground == 'guild_storage_hallway' then
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue("Do you think that " .. CharacterEssentials.GetCharacterName("Audino") .. " goes this crazy every night?")
		UI:WaitShowDialogue("I somehow get the feeling you're not the first Pokémon she's crashed into...")
	elseif ground == 'guild_storage_room' then
		UI:WaitShowDialogue("This looks like the storage room.[pause=0] They probably keep most of the food and supplies here.")
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue("I wouldn't touch anything.[pause=0] We don't want to get in trouble...")
		
	else
		UI:WaitShowDialogue('Could not find Chapter 1 Dialogue for this ground. This is a bug. Tell Palika.')
		
	end
end


function PartnerEssentials.Chapter_2_Dialogue(partner)
	local ground = GAME:GetCurrentGround().AssetName--get ground's internal name
	UI:SetSpeaker(partner)
	GROUND:CharTurnToCharAnimated(partner, CH('PLAYER'), 4)
	GROUND:CharTurnToCharAnimated(CH('PLAYER'), partner, 4)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Chapter 2 Dialogue message.")
end
function PartnerEssentials.GetPartnerDungeonDialogue()
end



