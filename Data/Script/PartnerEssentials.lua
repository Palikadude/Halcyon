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





--[[
partner's dialogue can be changed by walking over markers that indicate where in a map you're standing. This gives you the ability
to have the partner's dialogue be much more dynamic than the normal PMD games. This command is basically just going to a giant
case statement methinks.
]]--
function PartnerEssentials.GetPartnerDialogue(partner)
	
	assert(pcall(load("PartnerEssentials.Chapter_" .. tostring(SV.ChapterProgression.Chapter) .. "_Dialogue(...)"), partner))
	
end



--subfunctions that contain dialogue used in each chapter for partner follow dialogue
function PartnerEssentials.Chapter_1_Dialogue(partner)
	local ground = GAME:GetCurrentGround().AssetName--get ground's internal name
	UI:SetSpeaker(partner)
	GROUND:CharTurnToCharAnimated(partner, CH('PLAYER'), 4)
	GROUND:CharTurnToCharAnimated(CH('PLAYER'), partner, 4)
	--UI:SetSpeakerEmotion('Normal')

	if ground == 'guild_second_floor' then
		UI:WaitShowDialogue("Lots of different Pokémon gather here everyday.[pause=0] I'm sure we'll meet all kinds of Pokémon here!")
		UI:WaitShowDialogue("Before today,[pause=10] this was the only part of the guild's interior I'd seen before.")
		UI:SetSpeakerEmotion("Sad")
		UI:WaitShowDialogue("Without a partner,[pause=10] they didn't even give me a shot to apply for apprenticeship...")
		UI:WaitShowDialogue("So I didn't get to see the upstairs area or the Guildmaster.")
		GAME:WaitFrames(20)
		UI:SetSpeakerEmotion("Inspired")
		UI:WaitShowDialogue("But that's OK![pause=0] We're in a team now and we're gonna go on all kinds of fun adventures!")
		
	elseif ground == 'guild_third_floor_lobby' then
	
	elseif ground == 'guild_dining_room' then
		if SV.Chapter1.MetSnubbull then
			UI:SetSpeakerEmotion("Inspired")
			UI:WaitShowDialogue("I'm excited to eat a meal at a table with all our new guildmates!")
			UI:WaitShowDialogue("I've never eaten at a big table like this before!")
			UI:SetSpeakerEmotion("Normal")
			UI:WaitShowDialogue("I just hope " .. CharacterEssentials.GetCharacterName("Snubbull") .. " is as good as a chef as she claims.")
		else
			UI:SetSpeakerEmotion("Worried")
			UI:WaitShowDialogue("Hmm...[pause=0] This looks like the dining room,[pause=10] I think.")
		end
		
	elseif ground == 'guild_heros_room' then
		UI:WaitShowDialogue("Can you believe we got a room this nice?")
		UI:WaitShowDialogue("The rest of the guild must be this nice as well!")
		UI:WaitShowDialogue("We should go around and say hi to all of our new guildmates while we explore the guild!")
		
	elseif ground == 'guild_bottom_left_bedroom' then 
		if SV.Chapter1.MetBreloomGirafarig then 
		
		else
			UI:WaitShowDialogue("")
		end
		
	elseif in_array(ground, {'guild_bottom_right_bedroom',
							 'guild_top_left_bedroom',
							 'guild_top_right_bedroom'}) then 
		UI:WaitShowDialogue("This looks like one of the other bedrooms.")
		UI:WaitShowDialogue("Nobody seems to be here right now though,[pause=10] let's check some of the other rooms!")
		

	elseif ground == 'guild_bedroom_hallway' then
		UI:WaitShowDialogue("I guess the other rooms on the sides of the hallway are the other guild member's bedrooms.")
		UI:WaitShowDialogue("It's probably OK to pop into them to say hello,[pause=10] right?")
		
	elseif ground == 'guild_storage_hallway' then
	
	elseif ground == 'guild_storage_room' then
		UI:WaitShowDialogue("This looks like the storage room.[pause=0] They probably keep most of the food and supplies here.")
		UI:WaitShowDialogue("Don't touch anything.[pause=0] We might get in trouble if we do...")
		
	else
		UI:WaitShowDialogue('Could not find Chapter 1 Dialogue for this ground. This is a bug.')
		
	end
end



function PartnerEssentials.GetPartnerDungeonDialogue()
end



