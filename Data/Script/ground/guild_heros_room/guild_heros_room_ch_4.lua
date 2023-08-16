require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'
require 'ground.guild_heros_room.guild_heros_room_helper'

guild_heros_room_ch_4 = {}


function guild_heros_room_ch_4.ShowTitleCard()
	GAME:FadeOut(false, 1)
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(CH('Teammate1'))
	UI:ResetSpeaker()
	SOUND:StopBGM()
	GAME:WaitFrames(60)
	local coro1 = TASK:BranchCoroutine(function() UI:WaitShowTitle("Chapter 4\n\nTO BE NAMED\n", 20)
												  GAME:WaitFrames(180)
												  UI:WaitHideTitle(20) end)
	local coro2 = TASK:BranchCoroutine(function() UI:WaitShowBG("Chapter_3", 180, 20)
												  GAME:WaitFrames(180)
												  UI:WaitHideBG(20) end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(60)
	SV.Chapter4.ShowedTitleCard = true
	guild_heros_room_helper.Morning(true)
end

function guild_heros_room_ch_4.PostGroveBedtalk()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GAME:CutsceneMode(true)
	guild_heros_room_helper.Bedtime(false)
	UI:ResetSpeaker()
	GAME:FadeIn(40)
	
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("relic_forest")

	--partner is excited about the day.
	--getting to explore a new place, getting the apricorn, actually being able to keep it.
	--even met new teammates that helped get the treasure
	--so happy with how things have been turning out, hopes the player is enjoying themselves too
	--excitement for the expedition on top of all this
	---thanks the player for forming the team.
	--hero is happy to be apart of the team as well. happy partner isnt thinking about thwait Really enjoying life as a pokemon
	--partner is reminded... has hero remembered anything else that's important?
	--no. nothing new remembered or realized.
	--dang, unfortunate... any more meaning to the strange feelings?
	--hero thinks it over, hasn't really figured anything else out yet.
	--come to think of it... i felt a bit strange hearing the expedition announcement.
	--actually, i felt strange joining the guild and meeting the partner too!
	--it's a different kind of strangeness, but there's no other way to put it really than "strange".
	--What could it all mean. Tells the partner
	--wow, really! That's weird...
	--Is there some sort of connection? Or do you just feel that way because you're a Pokemon now, or because you just felt happy?
	--Hard to say. Could just be excitement after all. After this expedition, we should see if we can do anything to learn more about your past.
	--it's getting late... Good night, player.

--[[Wow today was great im having so much fun and im so happy about things rn i hope u are too
Yes me human me enjoy pokemon world this is awesome. also im happy that ur happy
partner really doesnt need to thank the player for forming the team i think its unneeded on further thought and copies the original too hard
partner's joy fades a bit and they change topics to players amnesia
has the player remembered anything else, anything else about the strange feelings?
player notes he got caught up in the fun it slipped his mind. Thinks about it a bit, but doesn't really have anything new.
Thinks about when he feels strange besides the times he told the partner, they muse a bit on it, then resolve to look into it once the expedition is through
]]--

	SOUND:PlayBGM('Goodnight.ogg', true)
	GAME:WaitFrames(40)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Today was absolutely amazing,[pause=10] " .. hero:GetDisplayName() .. "![pause=0] I had so much fun!")
	UI:WaitShowDialogue("Our first true adventure went so well![pause=0] We even found a treasure and got to keep it!")
	UI:WaitShowDialogue("Working together with you and our teammates...[pause=0] It couldn't have been any better!")
	UI:WaitShowDialogue("With the expedition coming up too,[pause=10] I'm happy with how things are going![pause=0] Don't you feel the same way,[pause=10] " .. hero:GetDisplayName() .. "?")

	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(Things have been exciting for us lately.[pause=0] It's been a lot of fun adventuring with " .. parnter:GetDisplayName() .. "!)", "Normal")
	GeneralFunctions.HeroDialogue(hero, "(Life in the guild has been a blast so far...[pause=0] I'd like to keep going on adventures with " .. partner:GetDisplayName() .. "!", "Happy")
	
	GAME:WaitFrames(20)
	GeneralFunctions.DoAnimation(hero, "Nod")
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("I'm glad you agree![pause=0] Let's keep on adventuring,[pause=10] " .. hero:GetDisplayName() .. "!")
	
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(partner, "glowing", 0)
	GROUND:CharSetEmote(hero, "glowing", 0)
	GAME:WaitFrames(60)
	GROUND:CharSetEmote(partner, "", 0)
	GROUND:CharSetEmote(hero, "", 0)
	SOUND:FadeOutBGM()
	--SOUND:PlayBattleSE('EVT_Emote_Exclaim_Idea')
	--GeneralFunctions.EmoteAndPause(
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("That being said...[pause=0] " .. hero:GetDisplayName() .. ",[pause=10] I've been wondering...")
	UI:WaitShowDialogue("Have you managed to remember anything about how you ended up in " .. zone:GetColoredName() .. "?")
	GAME:WaitFrames(20)
	


end