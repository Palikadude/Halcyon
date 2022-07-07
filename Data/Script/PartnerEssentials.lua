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
	local hero = CH('PLAYER')
	partner.IsInteracting = true
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
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
			UI:WaitShowDialogue("We're going to make a fantastic team " .. hero:GetDisplayName() .. "![pause=0] I know we're gonna do great!")
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

	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	partner.IsInteracting = false

end


function PartnerEssentials.Chapter_2_Dialogue(partner)
	local ground = GAME:GetCurrentGround().AssetName--get ground's internal name
	UI:SetSpeaker(partner)
	local hero = CH('PLAYER')
	partner.IsInteracting = true
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:SetSpeakerEmotion('Normal')
	
	--yes i know this is yandere dev shit i dont know how better to structure this. a lua table doesn't really make sense here without having to do a bunch of extra bullshit that i feel makes it less categorized/ordered.
	--can redo this with a better approach if a good one can be figured out.
	if ground == 'guild_heros_room' then 
		if SV.TemporaryFlags.JustWokeUp then 
			UI:SetSpeakerEmotion("Happy")
			UI:WaitShowDialogue("Good morning,[pause=10] " .. hero:GetDisplayName() .. "!")
			if not SV.Chapter2.FirstMorningMeetingDone then 
				UI:SetSpeakerEmotion("Normal")
				UI:WaitShowDialogue("We'd better get over to the morning meeting before we miss something![pause=0] Let's go!")
			end
		elseif not SV.Chapter2.FinishedFirstDay then 
			UI:SetSpeakerEmotion("Worried")
			UI:WaitShowDialogue("It would have been nice if we could have slept in a bit longer...")
			UI:SetSpeakerEmotion("Normal")
			UI:WaitShowDialogue("Ah well.[pause=0] We have more important things to do than sleep,[pause=10] anyway.")
			UI:WaitShowDialogue("Let's head over to the dojo for training,[pause=10] " .. hero:GetDisplayName() .. ".")
		else
			UI:SetSpeakerEmotion("Determined")
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone].Entries[53]
			UI:WaitShowDialogue("Now's not the time for rest,[pause=10] " .. hero:GetDisplayName() .. "!")
			UI:SetSpeakerEmotion("Normal")
			UI:WaitShowDialogue("We've got to get over to " .. zone:GetColoredName() .. " to find " .. CharacterEssentials.GetCharacterName("Numel") .. "![pause=0] Let's go!")	
		end
	
	elseif ground == 'guild_bottom_left_bedroom' then
		if not SV.Chapter2.FinishedFirstDay then 
			UI:SetSpeakerEmotion("Worried")
			UI:WaitShowDialogue("I'm still not one-hundred percent sure who has which bedroom...")
			UI:WaitShowDialogue("But given we saw them in here the other day,[pause=10] I think this is " .. CharacterEssentials.GetCharacterName("Breloom") .. " and " .. CharacterEssentials.GetCharacterName("Girafarig") .. "'s room.")		
			UI:WaitShowDialogue("...As nice as they are,[pause=10] I'm still a bit creeped out by " .. CharacterEssentials.GetCharacterName("Tail") .. ",[pause=10] if I'm being honest.")
		else 
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone].Entries[53]
			UI:SetSpeakerEmotion("Determined")
			UI:WaitShowDialogue("Come on " .. hero:GetDisplayName() .. "![pause=0] We have better things to do than poke around in " .. CharacterEssentials.GetCharacterName("Breloom") .. " and " .. CharacterEssentials.GetCharacterName("Girafarig") .. "'s room!")
			UI:SetSpeakerEmotion("Normal")
			UI:WaitShowDialogue("We've got to get over to " .. zone:GetColoredName() .. " to find " .. CharacterEssentials.GetCharacterName("Numel") .. "![pause=0] Let's go!")	
		end
	elseif ground == 'guild_bottom_right_bedroom' then
		if not SV.Chapter2.FinishedFirstDay then 
			UI:SetSpeakerEmotion("Worried")
			UI:WaitShowDialogue("Hmm...[pause=0] Given all the books and paper strewn about,[pause=10] I would guess this is " .. CharacterEssentials.GetCharacterName('Zigzagoon') .. "'s room.")
			UI:WaitShowDialogue("I think " .. CharacterEssentials.GetCharacterName("Growlithe") .. " mentioned to me once that " .. CharacterEssentials.GetCharacterName('Zigzagoon') .. " was his partner,[pause=10] so this must be his room too.")
			UI:SetSpeakerEmotion("Normal")
			UI:WaitShowDialogue("While we're here,[pause=10] why don't we take a quick peek at that almanac " .. CharacterEssentials.GetCharacterName("Zigzagoon") .. " has been working on?")
			UI:WaitShowDialogue("I bet there's some useful knowledge in there!")
		else
			UI:WaitShowDialogue("Looking at the almanac before we head out?[pause=0] Good idea!")
			UI:WaitShowDialogue("I'm sure some info in there could help us out in our rescue![pause=0] Don't take too long though!")
		end
	elseif ground == 'guild_top_left_bedroom' then
		if not SV.Chapter2.FinishedFirstDay then 
			UI:SetSpeakerEmotion("Worried")
			UI:WaitShowDialogue("Given who the other bedrooms belong to,[pause=10] this must be " .. CharacterEssentials.GetCharacterName("Mareep") .. " and " .. CharacterEssentials.GetCharacterName("Cranidos") .. "'s room.")
			UI:SetSpeakerEmotion("Pain")
			UI:WaitShowDialogue("We'd better leave.[pause=0] I don't want to get into an argument with " ..CharacterEssentials.GetCharacterName("Cranidos") .. " if he catches us in here...")
		else 
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone].Entries[53]
			UI:SetSpeakerEmotion("Determined")
			UI:WaitShowDialogue("Come on " .. hero:GetDisplayName() .. "![pause=0] We have better things to do than poke around in " .. CharacterEssentials.GetCharacterName("Mareep") .. " and " .. CharacterEssentials.GetCharacterName("Cranidos") .. "'s room!")
			UI:SetSpeakerEmotion("Normal")
			UI:WaitShowDialogue("We've got to get over to " .. zone:GetColoredName() .. " to find " .. CharacterEssentials.GetCharacterName("Numel") .. "![pause=0] Let's go!")	
		end
	elseif ground == 'guild_top_right_bedroom' then
		if not SV.Chapter2.FinishedFirstDay then 
			UI:SetSpeakerEmotion("Worried")
			UI:WaitShowDialogue("I think I saw " .. CharacterEssentials.GetCharacterName("Snubbull") .. " going into this room last night...")
			UI:SetSpeakerEmotion("Normal")
			UI:WaitShowDialogue("I think that " .. CharacterEssentials.GetCharacterName("Audino") .. " is her partner,[pause=10] so this must be their room.")
			UI:WaitShowDialogue("Those two sure do a lot of the work around the guild itself,[pause=10] don't they?")
			UI:WaitShowDialogue("Maybe that's why they're a pair.")
		else 
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone].Entries[53]
			UI:SetSpeakerEmotion("Determined")
			UI:WaitShowDialogue("Come on " .. hero:GetDisplayName() .. "![pause=0] We have better things to do than poke around in " .. CharacterEssentials.GetCharacterName("Audino") .. " and " .. CharacterEssentials.GetCharacterName("Snubbull") .. "'s room!")
			UI:SetSpeakerEmotion("Normal")
			UI:WaitShowDialogue("We've got to get over to " .. zone:GetColoredName() .. " to find " .. CharacterEssentials.GetCharacterName("Numel") .. "![pause=0] Let's go!")	
		end
	elseif in_array(ground, {'guild_bedroom_hallway',
							 'guild_third_floor_lobby',
							 'guild_second_floor',
							 'guild_first_floor',
							 'guild_storage_hallway'}) then 
		if not SV.Chapter2.FinishedNumelTantrum then 
			UI:WaitShowDialogue("Let's head over to Ledian Dojo for our training,[pause=10] " .. hero:GetDisplayName() .. "!")
			UI:WaitShowDialogue(CharacterEssentials.GetCharacterName("Noctowl") .. " said it was across the bridge to the guild,[pause=10] then down a ladder to the east.")
		elseif not SV.Chapter2.FinishedFirstDay then
			UI:WaitShowDialogue("Let's head on upstairs towards the dining room and get some dinner,[pause=10] " .. hero:GetDisplayName()  .. "![pause=0] I'm starving!")
		else
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone].Entries[53]
			UI:WaitShowDialogue(hero:GetDisplayName() .. "![pause=0] We have to rescue " .. CharacterEssentials.GetCharacterName("Numel") .. "!")
			UI:WaitShowDialogue("We should prepare ourselves in town,[pause=10] then head north out of town to " .. zone:GetColoredName() .. " to find him!")
		end
							 
	elseif ground == 'guild_dining_room' then
		if not SV.Chapter2.FinishedFirstDay then
			UI:SetSpeakerEmotion("Happy")
			UI:WaitShowDialogue("I sure hope " .. CharacterEssentials.GetCharacterName("Snubbull") .. " makes something tasty tonight.")
			UI:WaitShowDialogue("I don't know what kind of things she makes,[pause=10] but I hope there are some Candied Orans for desert.")
			UI:SetSpeakerEmotion("Joyous")
			UI:WaitShowDialogue("They're my favorite!")
		else 
			UI:SetSpeakerEmotion("Happy")
			UI:WaitShowDialogue("Dinner last night was great![pause=0] " ..  CharacterEssentials.GetCharacterName('Snubbull') .. " is a great chef after all!")
			UI:WaitShowDialogue("I know we have a mission to do now and all...[br]But my mind can't help but think about what's for dinner tonight while I'm in here!")
		end
	elseif ground == 'guild_guildmasters_room' then
		if not SV.Chapter2.FinishedFirstDay then
			UI:SetSpeakerEmotion("Inspired")
			UI:WaitShowDialogue("The Guildmaster was an amazing adventurer who ventured all over the world before he made the guild.")
			UI:WaitShowDialogue("His exploits are part of the reason I wanted to become an adventurer so bad!")
			UI:SetSpeakerEmotion("Worried")
			UI:WaitShowDialogue("I'm not sure why he settled down to create the guild though.")
			UI:SetSpeakerEmotion("Joyous")
			UI:WaitShowDialogue("If I was in his position,[pause=10] I'd want to explore and adventure my entire life![pause=0] Haha!")  
		elseif not SV.Chapter2.TropiusGaveReviver then 
			UI:SetSpeakerEmotion("Worried")
			UI:WaitShowDialogue("I wonder if the Guildmaster can help us at all with our mission?[pause=0] Maybe he has some advice or something.")
		else
			local itemname = RogueEssence.Dungeon.InvItem(101):GetDisplayName()
			UI:SetSpeakerEmotion("Happy")
			UI:WaitShowDialogue("It was kind of the Guildmaster to give us that " .. itemname .. ".")
			UI:WaitShowDialogue("It'll come in handy if one of us gets into a bad situation.")
		end
	elseif ground == 'guild_storage_room' then
		if not SV.Chapter2.FinishedFirstDay then 
			UI:SetSpeakerEmotion("Worried")
			UI:WaitShowDialogue("I know we shouldn't touch anything in here,[pause=10] but...")
			UI:SetSpeakerEmotion("Normal")
			UI:WaitShowDialogue("I can't help but wonder what kind of stuff is stored here besides food.")
			UI:WaitShowDialogue("Do you think there's anything cool in here?")
		else 
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone].Entries[53]
			UI:SetSpeakerEmotion("Determined")
			UI:WaitShowDialogue("Come on " .. hero:GetDisplayName() .. "![pause=0] We have more important things to do than knock around in storage!")
			UI:SetSpeakerEmotion("Normal")
			UI:WaitShowDialogue("We've got to get over to " .. zone:GetColoredName() .. " to find " .. CharacterEssentials.GetCharacterName("Numel") .. "![pause=0] Let's go!")	
		end
	elseif ground == 'ledian_dojo' then
		if not SV.Chapter2.FinishedFirstDay then 
			UI:SetSpeakerEmotion("Inspired")
			UI:WaitShowDialogue("This dojo is great![pause=0] I'm glad there's a place like this for us to train!")
			UI:WaitShowDialogue("I still got some energy if you want to train some more,[pause=10] " .. hero:GetDisplayName() .. "!")
			UI:WaitShowDialogue("We need to do all the training we can if we want to become great adventurers!")
		else
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone].Entries[53]
			UI:WaitShowDialogue("It might be a good idea to warmup with some training here before we head out to " .. zone:GetColoredName() .. ".")
			UI:WaitShowDialogue("We don't want to take too long though.[pause=0] " .. CharacterEssentials.GetCharacterName("Numel") .. " needs us!")
		end
	elseif ground == 'metano_fire_home' then
		if not SV.Chapter2.FinishedFirstDay then 
			UI:WaitShowDialogue("This house belongs to the family that was just arguing outside.")
			UI:SetSpeakerEmotion("Worried")
			UI:WaitShowDialogue("I hope they can make up with each other soon...")
		else 
			UI:SetSpeakerEmotion("Determined")
			UI:WaitShowDialogue("Come on " .. hero:GetDisplayName() .. ".[pause=0] Let's go bring " .. CharacterEssentials.GetCharacterName("Camerupt") .. "'s baby boy home.")
		end 
	elseif ground == 'metano_electric_home' then
		if not SV.Chapter2.FinishedFirstDay then 
			UI:WaitShowDialogue("This house belongs to a family of Electric-types.")
			UI:SetSpeakerEmotion("Worried")
			UI:WaitShowDialogue("They're nice enough,[pause=10] but the father is pretty standoffish.") 
		else
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone].Entries[53]
			UI:WaitShowDialogue(hero:GetDisplayName() .. "![pause=0] We have to rescue " .. CharacterEssentials.GetCharacterName("Numel") .. "!")
			UI:WaitShowDialogue("We should prepare ourselves in town,[pause=10] then head north out of town to " .. zone:GetColoredName() .. " to find him!")
		end
	elseif ground == 'metano_water_home' then
		if not SV.Chapter2.FinishedFirstDay then
			UI:WaitShowDialogue("A family of Water-types live here.")
			UI:SetSpeakerEmotion("Happy")
			UI:WaitShowDialogue("Must be nice having your house right next to a river if you're a Water-type!")
		else
			UI:SetSpeakerEmotion("Happy")
			UI:WaitShowDialogue("Heh,[pause=10] looks like someone is having pleasant dreams.")
		end
	elseif ground == 'metano_normal_home' then
		if not SV.Chapter2.FinishedFirstDay then
			UI:WaitShowDialogue("A Normal-type family owns this house.")
			UI:WaitShowDialogue("You can usually find the dad napping in the sun in town and the mom's nose in a book.")
		else 
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone].Entries[53]
			UI:WaitShowDialogue(hero:GetDisplayName() .. "![pause=0] We have to rescue " .. CharacterEssentials.GetCharacterName("Numel") .. "!")
			UI:WaitShowDialogue("We should prepare ourselves in town,[pause=10] then head north out of town to " .. zone:GetColoredName() .. " to find him!")
		end
	elseif ground == 'metano_rock_home' then
		if not SV.Chapter2.FinishedFirstDay then 
			UI:WaitShowDialogue("A family of Fighting-types own this house.")
			UI:WaitShowDialogue("You can usually see them meditating or training somewhere in town.")
		else 
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone].Entries[53]
			UI:WaitShowDialogue(hero:GetDisplayName() .. "![pause=0] We have to rescue " .. CharacterEssentials.GetCharacterName("Numel") .. "!")
			UI:WaitShowDialogue("We should prepare ourselves in town,[pause=10] then head north out of town to " .. zone:GetColoredName() .. " to find him!")
		end
	elseif ground == 'metano_grass_home' then
		if not SV.Chapter2.FinishedFirstDay then 
			UI:WaitShowDialogue("This house belongs to a family of Grass-types.")
			UI:SetSpeakerEmotion("Happy")
			UI:WaitShowDialogue("They have a beautiful garden outside their house,[pause=10] don't you think?")
		else 
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone].Entries[53]
			UI:WaitShowDialogue(hero:GetDisplayName() .. "![pause=0] We have to rescue " .. CharacterEssentials.GetCharacterName("Numel") .. "!")
			UI:WaitShowDialogue("We should prepare ourselves in town,[pause=10] then head north out of town to " .. zone:GetColoredName() .. " to find him!")
		end
	elseif ground == 'metano_inn' then
		if not SV.Chapter2.FinishedFirstDay then 
			UI:WaitShowDialogue("This is an inn ran by a lovely couple.[pause=0] They're both really kind!")
			UI:WaitShowDialogue("All sorts of Pokémon passing through town stay here.[pause=0] It's a good place to meet new Pokémon!")
		else 
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone].Entries[53]
			UI:WaitShowDialogue(hero:GetDisplayName() .. "![pause=0] We have to rescue " .. CharacterEssentials.GetCharacterName("Numel") .. "!")
			UI:WaitShowDialogue("We should prepare ourselves in town,[pause=10] then head north out of town to " .. zone:GetColoredName() .. " to find him!")
		end
	elseif ground == 'metano_cave' then
		if not SV.Chapter2.FinishedFirstDay then
			UI:WaitShowDialogue("This hermit has lived in this cave for a long time.[pause=0] I don't know much else about her though.")
			UI:SetSpeakerEmotion("Worried")
			UI:WaitShowDialogue("I don't believe I've ever seen her outside...[pause=0] It's strange since [color=#00FF00]Sunflora[color] usually enjoy the sun.")
		else 
			UI:SetSpeakerEmotion("Worried")
			UI:WaitShowDialogue("I worry about the hermit in here sometimes...[pause=0] She's always in here after all.")
			UI:WaitShowDialogue("Do you think she even knows one of the town children has gone missing?")
		end
	elseif ground == 'metano_altere_transition' then
		if not SV.Chapter2.FinishedFirstDay then
			UI:WaitShowDialogue("This is the town outskirts.[pause=0] Altere Pond is just south of here.")
			UI:WaitShowDialogue("It's a nice place to relax,[pause=10] away from the hustle of the town.")
		else 
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone].Entries[53]
			UI:SetSpeakerEmotion("Worried")
			UI:WaitShowDialogue("What are we doing here,[pause=10] " .. hero:GetDisplayName() .. "?")
			UI:SetSpeakerEmotion("Normal")
			UI:WaitShowDialogue("We need to get over to " .. zone:GetColoredName() .. " and find " .. CharacterEssentials.GetCharacterName("Numel") .. ".[pause=0] We have to head north,[pause=10] not south!")
		end
	elseif ground == 'altere_pond' then
		if not SV.Chapter2.FinishedFirstDay then 
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone].Entries[50]
			UI:SetSpeakerEmotion("Worried")
			UI:WaitShowDialogue("Whatever you do...[pause=0] Don't tell " .. CharacterEssentials.GetCharacterName("Relicanth") .. " we were in " .. zone:GetColoredName() .. ".")
			UI:SetSpeakerEmotion("Pain")
			UI:WaitShowDialogue("He will chew us out for hours if he knew.[pause=0] Believe me,[pause=10] I know from experience.")
		else 
			local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone].Entries[53]
			UI:SetSpeakerEmotion("Worried")
			UI:WaitShowDialogue("What are we doing here,[pause=10] " .. hero:GetDisplayName() .. "?")
			UI:SetSpeakerEmotion("Normal")
			UI:WaitShowDialogue("We need to get over to " .. zone:GetColoredName() .. " and find " .. CharacterEssentials.GetCharacterName("Numel") .. ".[pause=0] We have to head north,[pause=10] not south!")
		end
	elseif ground == 'post_office' then
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue("Looks like the post office isn't working right now...")
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("Guess we'll have to come back another time.")
	elseif ground == 'metano_town' then
		--metano town uses a series of touch objects to mark where the player/partner is on the map so the partner can comment on specific surroundings.
		local location = SV.metano_town.Locale
		if not SV.Chapter2.FinishedTraining then 
			UI:WaitShowDialogue("Let's head over to Ledian Dojo for our training,[pause=10] " .. hero:GetDisplayName() .. "!")
			UI:WaitShowDialogue(CharacterEssentials.GetCharacterName("Noctowl") .. " said it was across the bridge to the guild,[pause=10] then down a ladder to the east.")
		elseif not SV.Chapter2.FinishedFirstDay then  --day 1
			if location == 'North Houses' or location == 'South Houses' then 
				UI:WaitShowDialogue("This is where most of the townfolk live.")
				if SV.Chapter2.FinishedNumelTantrum then 
					UI:SetSpeakerEmotion("Worried")
					UI:WaitShowDialogue("That scene earlier was a bit alarming...[pause=0] That sort of stuff rarely happens in Metano Town.")
					UI:SetSpeakerEmotion("Normal")
					UI:WaitShowDialogue("Regardless,[pause=10] Pokémon here are very welcoming,[pause=10] so don't be shy about going into their homes.")
				else 
					UI:WaitShowDialogue("Pokémon here are very welcoming,[pause=10] so don't be shy about going into their homes.")
				end
			elseif location == 'Guild' then 
				if not SV.Chapter2.FinishedNumelTantrum then
					UI:WaitShowDialogue("We still have some time before we need to head back inside the guild.")
					UI:WaitShowDialogue("Let's go explore town some more!")
				else
					UI:WaitShowDialogue("It's starting to get late.[pause=0] Let's head back inside the guild for dinner whenever you're ready,[pause=10] " .. hero:GetDisplayName() .. ".")	
				end
			elseif location == 'Cafe' then 
				UI:SetSpeakerEmotion("Surprised")
				UI:WaitShowDialogue("Oh![pause=0] I almost forgot about the café!")
				UI:SetSpeakerEmotion("Happy")
				UI:WaitShowDialogue("The café is the most popular spot in town!")
				UI:WaitShowDialogue("The owner " .. CharacterEssentials.GetCharacterName("Shuckle") .. " makes all sorts of delicious smoothies and snacks![pause=0] They're really good!")
				UI:SetSpeakerEmotion("Worried")
				UI:WaitShowDialogue("It looks like it isn't open right now though...[pause=0] That's a shame...")
				UI:SetSpeakerEmotion("Inspired")
				UI:WaitShowDialogue("We have to come back once it's open though![pause=0] I'm telling you,[pause=10] it's tasty stuff!")
			elseif location == 'Cave' then 
				UI:WaitShowDialogue("A hermit lives in that musty cave in the cliffside there.[pause=0] She's not very fond of visitors though.")
			elseif location == 'Exploration' then
				UI:WaitShowDialogue("This is the main exit out of town.[pause=0] For most of our future adventures,[pause=10] we would leave town this way.")
			elseif location == 'Post' then
				UI:WaitShowDialogue("That oddly shaped building over there is the Pelipper Post Office.[pause=0] We can send and receive mail there!")
			elseif location == 'Well' then 
				UI:WaitShowDialogue("The cliff is a common hangout spot.[pause=0] You can see all of Metano Town from up here!")
				UI:WaitShowDialogue("The parents don't like their children playing up here though.")
				UI:WaitShowDialogue("They don't want them falling down the cliffside after all!")
			elseif location == 'Merchants' then 
				UI:SetSpeakerEmotion("Worried")
				UI:WaitShowDialogue("Usually there's a pair of rival merchants here,[pause=10] selling items while they bicker with each other.")
				UI:WaitShowDialogue("But I haven't seen them there for a few days.[pause=0] I wonder where they could be?")
			elseif location == 'Dojo' then 
				if not SV.Chapter2.FinishedTraining then
					UI:WaitShowDialogue("Hey,[pause=10] there's a ladder over there,[pause=10] " .. hero:GetDisplayName() "!")
					UI:WaitShowDialogue("That must be the entrance to the dojo.[pause=0] Let's head on down!")
				else 
					UI:SetSpeakerEmotion("Worried")
					UI:WaitShowDialogue("Still can't believe that there's an entire cavern and dojo down that ladder...")
					UI:SetSpeakerEmotion("Joyous")
					GROUND:CharSetEmote(partner, 4, 0)
					UI:WaitShowDialogue("I've passed by it so many times,[pause=10] but I've never gone down there before today![pause=0] Haha!")
					GROUND:CharSetEmote(partner, -1, 0)
				end
			elseif location == 'Market' then 
				UI:WaitShowDialogue("The market has all sorts of cool shops and vendors!")
				UI:WaitShowDialogue("It's the most exciting part of town![pause=0] Besides the guild,[pause=10] of course.")
				UI:WaitShowDialogue("If we make any money from adventuring,[pause=10] this is probably where we're going to spend it.")
			else
				UI:WaitShowDialogue("No dialogue assigned for this section of town. Let Palika know where you got this message.")
			end
						
		else--day 2
			if in_array(location, {'Guild', 'North Houses', 'South Houses', 'Post', 'Merchants', 'Well', 'Exploration', 'Cave'}) then 
				local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone].Entries[53]
				UI:WaitShowDialogue(hero:GetDisplayName() .. "![pause=0] We have to rescue " .. CharacterEssentials.GetCharacterName("Numel") .. "!")
				UI:WaitShowDialogue("We should prepare ourselves in town,[pause=10] then head north out of town to " .. zone:GetColoredName() .. " to find him!")
			elseif location == 'Cafe' then 
				UI:SetSpeakerEmotion("Worried")
				UI:WaitShowDialogue("The café is still closed,[pause=10] huh?")
				UI:SetSpeakerEmotion("Normal")
				UI:WaitShowDialogue("I hope it's open again soon.[pause=0] I really want you to try some of their treats!")
			elseif location == 'Dojo' then
				local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone].Entries[53]			
				UI:WaitShowDialogue("Perhaps we should head into the dojo for a warmup before we head out to " .. zone:GetColoredName() .. "?")
			elseif location == 'Market' then 
				local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone].Entries[53]			
				UI:WaitShowDialogue("The market is probably the best place for us to make our preparations.")
				UI:WaitShowDialogue("When we're done here,[pause=10] let's make a beeline for " .. zone:GetColoredName() .. "![pause=0] " .. CharacterEssentials.GetCharacterName("Numel") .. " needs us!")
			else
				UI:WaitShowDialogue("No dialogue assigned for this section of town. Let Palika know where you got this message.")
			end
		end
	
	
	else	
		UI:WaitShowDialogue("Chapter 2 dialogue not found for this ground/scenario. Please notify Palika.")
	end
	
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	partner.IsInteracting = false
end



function PartnerEssentials.GetPartnerDungeonDialogue()
end



