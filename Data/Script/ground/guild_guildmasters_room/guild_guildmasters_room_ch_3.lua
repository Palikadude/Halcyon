require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

guild_guildmasters_room_ch_3 = {}


function guild_guildmasters_room_ch_3.Tropius_Action(chara, activator)
	--He gives you a few wands as a one-off to help you with your mission
	if not SV.Chapter3.DefeatedBoss then
		if not SV.Chapter3.TropiusGaveWand then 
			GeneralFunctions.StartConversation(chara, "Howdy,[pause=10] Team " .. GAME:GetTeamName() .. "![pause=0] Congratulations on your first successful mission!", "Happy")
			UI:WaitShowDialogue("I'm sure " .. CharacterEssentials.GetCharacterName("Camerupt") .. ",[pause=10] " .. CharacterEssentials.GetCharacterName("Numel") .. ",[pause=10] and the rest of the town are thankful for what you've done!")
			UI:SetSpeakerEmotion("Normal")
			UI:WaitShowDialogue("Anyways,[pause=10] you have a new mission now,[pause=10] right?[pause=0] You're on the hunt for an outlaw if I'm not mistaken!")
			UI:WaitShowDialogue("Capturing outlaws can be tricky.[pause=0] They're tougher than most Pokémon you encounter in mystery dungeons!")
			UI:WaitShowDialogue("So,[pause=10] I want you to take these to help you with your mission.")
			GAME:WaitFrames(20)
			GeneralFunctions.RewardItem("wand_totter", false, 4)
			GAME:WaitFrames(20)
			UI:SetSpeaker(chara)
			UI:WaitShowDialogue("A good way to deal with strong opponents is to disable or weaken them.")
			UI:WaitShowDialogue("These wands will confuse any opponent you wave them at,[pause=10] which is perfect for a tough enemy like an outlaw!")
			
			GAME:WaitFrames(20)
			UI:SetSpeaker(CH('Teammate1'))
			UI:SetSpeakerEmotion("Inspired")
			GROUND:CharSetEmote(CH('Teammate1'), "happy", 0)
			UI:WaitShowDialogue("Wow![pause=0] Thank you Guildmaster![pause=0] We'll put these to good use!")
			
			GAME:WaitFrames(20)
			GROUND:CharSetEmote(CH('Teammate1'), "", 0)
			UI:SetSpeaker(chara)
			UI:SetSpeakerEmotion("Happy")
			UI:WaitShowDialogue("Of course![pause=0] Good luck with capturing this outlaw![pause=0]\nI know you can do it!")
			SV.Chapter3.TropiusGaveWand = true
		elseif not SV.Chapter3.EnteredCavern then 
			GeneralFunctions.StartConversation(chara, "Good luck capturing that outlaw![pause=0] I know you two can do it!", "Happy")
		else--failed the dungeon at least once 
			GeneralFunctions.StartConversation(chara, "Having trouble capturing that outlaw?[pause=0] They can be pretty tough opponents!")
			UI:WaitShowDialogue("When I first started out as an adventurer,[pause=10] they gave me plenty of trouble too!")
			UI:SetSpeakerEmotion("Happy")
			UI:WaitShowDialogue("Try reevaluating your strategies,[pause=10] and then try again![pause=0] You two can do it!")
		end
	else 
		GeneralFunctions.StartConversation(chara, "Howdy,[pause=10] Team " .. GAME:GetTeamName() .. "![pause=0] Great work capturing your first outlaw!", "Happy")
		UI:WaitShowDialogue("I knew you two were going to do fantastic work in this guild![pause=0] Keep it up and you'll go far!")
	end
	GeneralFunctions.EndConversation(chara)
end


return guild_guildmasters_room_ch_3