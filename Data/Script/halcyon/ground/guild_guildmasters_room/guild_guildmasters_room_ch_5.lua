require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

guild_guildmasters_room_ch_5 = {}

function guild_guildmasters_room_ch_5.SetupGround()

	local tropius = CH('Tropius')
	GROUND:TeleportTo(tropius, 280, 168, Direction.DownRight)


	local noctowl, girafarig, breloom = 
		CharacterEssentials.MakeCharactersFromList({
			{"Noctowl", 296, 224, Direction.UpRight},
			{"Girafarig", 280, 208, Direction.Right},
			{"Breloom", 296, 200, Direction.Right}
		})
		
		
	GAME:FadeIn(20)
	
end


function guild_guildmasters_room_ch_5.Tropius_Action(chara, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')

	GeneralFunctions.StartConversation(chara, "...We'll want to stay in a group for as long as we can.[pause=0] Though we may need to split up out of necessity...", "Normal", false)
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(chara, hero, 4)
	UI:WaitShowDialogue("Ah,[pause=10] Team " .. GAME:GetTeamName() .. "![pause=0] Have you finished your preparations for the expedition?")
	UI:ChoiceMenuYesNo("We won't return to Metano Town for quite some time,[pause=10] so are you sure you're completely ready?", true)
	UI:WaitForChoice()
	local result = UI:ChoiceResult()
	GAME:WaitFrames(20)
	if result then
		UI:WaitShowDialogue("Just a reminder,[pause=10] the expedition is for guild members only.")
		UI:WaitShowDialogue("That means you can't bring along any Pokémon from the " .. _DATA:GetMonster('audino'):GetColoredName() .. " Assembly.")
		UI:ChoiceMenuYesNo("With that in mind,[pause=10] are you absolutely sure that you're all set?", true)
		UI:WaitForChoice()
		result = UI:ChoiceResult()
		GAME:WaitFrames(20)
		if result then
			UI:SetSpeaker(partner)
			UI:SetSpeakerEmotion("Happy")
			UI:WaitShowDialogue("Yup![pause=0] We're all ready to go,[pause=10] Guildmaster!")
			GAME:WaitFrames(20)
			
			UI:SetSpeaker(chara)		
			UI:SetSpeakerEmotion("Happy")
			UI:WaitShowDialogue("Great![pause=0] In that case,[pause=10] you can wait here with us until the other apprentices are done preparing.")
			UI:WaitShowDialogue("Once everyone's gathered,[pause=10] " .. CharacterEssentials.GetCharacterName("Noctowl") .. " and I will go over the plans.")
			UI:WaitShowDialogue("But until then,[pause=10] just relax![pause=0] We have a long journey ahead,[pause=10] so rest while you still can!")
			GAME:WaitFrames(20)
			
			--Set flags needed for the expedition, and send home characters in slots 3/4.
			GAME:SetCanRecruit(false)--disable recruiting for duration of expedition
			SV.Chapter5.ReadyForExpedition = true
			GeneralFunctions.DefaultParty(false)
			
			SOUND:FadeOutBGM(60)
			GAME:FadeOut(false, 60)
			GAME:WaitFrames(60)
			GeneralFunctions.EndConversation(chara)
			GAME:EnterGroundMap("guild_third_floor_lobby", "Main_Entrance_Marker")
			
		else
			UI:SetSpeaker(partner)
			UI:SetSpeakerEmotion("Sad")
			GROUND:CharSetEmote(partner, "sweating", 1)
			UI:WaitShowDialogue("Wh-whoops.[pause=0] I guess we're not ready,[pause=10] in that case.[pause=0] Sorry,[pause=10] Guildmaster...")
			GAME:WaitFrames(20)
			
			UI:SetSpeaker(chara)
			UI:SetSpeakerEmotion("Happy")
			UI:WaitShowDialogue("That's alright![pause=0] There's still plenty of time!")
			UI:SetSpeakerEmotion("Normal")
			UI:WaitShowDialogue("Head back into town and finish your preparations.[pause=0] Whenever you're ready,[pause=10] come back here and let me know!")
		end		
	else 
		UI:SetSpeaker(partner)
		UI:SetSpeakerEmotion("Sad")
		GROUND:CharSetEmote(partner, "sweating", 1)
		UI:WaitShowDialogue("Not yet.[pause=0] Sorry,[pause=10] Guildmaster...")
		GAME:WaitFrames(20)
		
		UI:SetSpeaker(chara)
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("That's alright![pause=0] There's still plenty of time!")
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("Head back into town and finish your preparations.[pause=0] Whenever you're ready,[pause=10] come back here and let me know!")
	end
	GROUND:CharAnimateTurnTo(chara, Direction.DownRight, 4)
	GeneralFunctions.EndConversation(chara)
end

function guild_guildmasters_room_ch_5.Noctowl_Action(chara, activator)
	local ruins = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('cloven_ruins')
	local mountain = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('mount_windswept')
--	GeneralFunctions.StartConversation(chara, "According to your map,[pause=10] " .. ruins:GetColoredName() .. " lies just beyond " .. mountain:GetColoredName() .. ".", "Normal", false)
--	UI:WaitShowDialogue("As such,[pause=10] we will need to travel through the mountain no matter what route we take.")
	--GeneralFunctions.StartConversation(chara, "...If we take this more roundabout route,[pause=10] the raw distance traveled would be greater.", "Normal", false)
	--UI:WaitShowDialogue("However,[pause=10] such a course would allow us to navigate around some of the mystery dungeons you two encountered while scouting.")
	--UI:WaitShowDialogue("That should make it the most efficient path to " .. ruins:GetColoredName() .. ".")
	GeneralFunctions.StartConversation(chara, "...Your plotted route is quite promising.[pause=0] It will allow us to arrive at the ruins in about a week's time.", "Normal", false)
	UI:WaitShowDialogue("However...[pause=0] There are improvements that can be made to expedite our journey.")
	UI:WaitShowDialogue("For instance,[pause=10] if we travel through this pass here,[pause=10] we can reach the steppe half a day earlier.[pause=0] Furthermore...")
	
	GeneralFunctions.EndConversation(chara)
end

function guild_guildmasters_room_ch_5.Breloom_Action(chara, activator)
	--local ruins = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('cloven_ruins')
	--local mountain = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('mount_windswept')
	--GeneralFunctions.StartConversation(chara, "..." .. ruins:GetColoredName() .. " lies just past " .. mountain:GetColoredName() .. ",[pause=10] so there's no avoiding that mystery dungeon.", "Normal", false)
	--UI:SetSpeakerEmotion("Worried")
	--UI:WaitShowDialogue("It's unfortunate,[pause=10] given how harsh that place is![pause=0] Even for me and " .. CharacterEssentials.GetCharacterName("Girafarig") .. ",[pause=10] getting through was a struggle!")
	--GeneralFunctions.StartConversation(chara, "...That's why me and " .. CharacterEssentials.GetCharacterName("Girafarig") .. " decided to call the ruins that.", "Normal", false)
	--UI:SetSpeakerEmotion("Happy")
	--UI:WaitShowDialogue("Pretty clever,[pause=10] huh?")
	GeneralFunctions.StartConversation(chara, "...That mystery dungeon in particular was harsh.[pause=0] Even for me and " .. CharacterEssentials.GetCharacterName("Girafarig") .. ",[pause=10] getting through was a struggle!", "Worried", false)
	UI:WaitShowDialogue("But the ruins lie just past it...[pause=0] So there's no choice but to climb it!")
	GeneralFunctions.EndConversation(chara)
end

--something about mystery dungeons being required
function guild_guildmasters_room_ch_5.Girafarig_Action(chara, activator)
	--GeneralFunctions.StartConversation(chara, "...Woah " .. CharacterEssentials.GetCharacterName("Noctowl") .. ",[pause=10] your map skills are even better than " .. CharacterEssentials.GetCharacterName("Tail") .. "'s!", "Normal", false)
	GeneralFunctions.StartConversation(chara, "...We searched all around the ruins,[pause=10] but we couldn't make heads in tails of it![pause=0] It's a total mystery!", "Worried", false)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("...[pause=30]But if we put all of our heads together,[pause=10] I know we can solve it! (todo improve this line a bit)")
	GeneralFunctions.EndConversation(chara)
end

return guild_guildmasters_room_ch_5


--[[
>have to go through mystery dungeons
>this route is efficient
>we're so clever!
>phileas suggests some improvements?
>Kino and Reinier are demonstrated to be pretty competent despite their demeanor
>hints about what their strategy is going to be (stay together -> split into teams)

]]--