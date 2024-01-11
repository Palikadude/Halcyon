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
	local coro1 = TASK:BranchCoroutine(function() UI:WaitShowTitle("Chapter 4\n\nA Real Adventure\n", 20)
												  GAME:WaitFrames(180)
												  UI:WaitHideTitle(20) end)
	local coro2 = TASK:BranchCoroutine(function() UI:WaitShowBG("Chapter_4", 180, 20)
												  GAME:WaitFrames(180)
												  UI:WaitHideBG(20) end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(120)
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
	UI:WaitShowDialogue("Today was absolutely amazing,[pause=10] " .. hero:GetDisplayName() .. "![pause=0] I had so much fun!")
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("Our first real adventure went so well![pause=0] We even found a treasure and got to keep it!")
	UI:WaitShowDialogue("Working together with you and our teammates...[pause=0] It couldn't have been any better!")
	UI:WaitShowDialogue("With the expedition coming up too,[pause=10] I'm so excited about everything![pause=0] Aren't you?")

	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(Things have been exciting lately.[pause=0] It seems that excitement has helped " .. partner:GetDisplayName() .. " get " .. GeneralFunctions.GetPronoun(partner, "their") .. " mind off of " .. CharacterEssentials.GetCharacterName("Sandile") .. ",[pause=10] too.)", "Normal")
	GeneralFunctions.HeroDialogue(hero, "(It's been a lot of fun adventuring with " .. partner:GetDisplayName() .. "!)", "Normal")
	GeneralFunctions.HeroDialogue(hero, "(Life in the guild has been a blast so far...[pause=0] I'd like to keep going on adventures with " .. partner:GetDisplayName() .. "!)", "Happy")
	
	GAME:WaitFrames(20)
	GeneralFunctions.DoAnimation(hero, "Nod")
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("I'm glad you agree![pause=0] Let's keep going on great adventures,[pause=10] " .. hero:GetDisplayName() .. "!")
	
	GROUND:CharSetEmote(partner, "glowing", 0)
	GAME:WaitFrames(40)
	GROUND:CharSetEmote(hero, "glowing", 0)
	GAME:WaitFrames(60)
	GROUND:CharSetEmote(partner, "", 0)
	GROUND:CharSetEmote(hero, "", 0)
	GAME:WaitFrames(40)
	GROUND:EntTurn(partner, Direction.UpLeft)
	GAME:WaitFrames(90)
	GROUND:CharTurnToChar(partner, hero)
	SOUND:FadeOutBGM(120)
	--SOUND:PlayBattleSE('EVT_Emote_Exclaim_Idea')
	--GeneralFunctions.EmoteAndPause(
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Hey,[pause=10] " .. hero:GetDisplayName() .. "...")
	UI:WaitShowDialogue("Do you remember right before we joined the guild,[pause=10] how I promised to help solve your amnesia?")
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("We've been so busy with guild activities that we haven't had a chance to look into it at all...")
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("But I haven't forgotten about it![script=0]", {function() return GeneralFunctions.Hop(partner) end})
	
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("That being said...")
	UI:WaitShowDialogue(hero:GetDisplayName() .. ",[pause=10] have you managed to remember anything about how you ended up in " .. zone:GetColoredName() .. "?")
	GAME:WaitFrames(20)
	
	GeneralFunctions.HeroDialogue(hero, "(Hmm...[pause=0] I haven't given it any thought,[pause=10] actually.)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(I'd been so caught up in doing guild work with " .. partner:GetDisplayName() .. " that it slipped my mind entirely!)", "Worried")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(But,[pause=10] now that I stop and think about it...[pause=0] I still haven't remembered anything.)", "Sad")
	GAME:WaitFrames(20)
	GeneralFunctions.ShakeHead(hero)
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("That's unfortunate...[pause=0] I thought that was the case,[pause=10] but I was hoping you had remembered something.")
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("What about those strange feelings,[pause=10] like the one you had at Luminous Spring?[pause=0] Any idea on that?")
	
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(I haven't felt sick like I did at Luminous Spring since we were there.[pause=0] I still don't know why I felt that way.)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(There was also how I felt touching the obelisk in " .. zone:GetColoredName() .. ",[pause=10] but I don't know anything about that either...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(Hmm...)", "Worried")
	
	GAME:WaitFrames(60)
	SOUND:PlayBattleSE('EVT_Emote_Exclaim_Idea')
	GeneralFunctions.EmoteAndPause(hero, "Exclaim", false)
	
	SOUND:PlayBGM('I Saw Something Again....ogg', false)
	GeneralFunctions.HeroDialogue(hero, "(Wait![pause=0] Those aren't the only times I've felt that way![pause=0] I've gotten a strange feeling a few other times!)", "Surprised")
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(I felt strange when I came to the guild for the first time,[pause=10] when I heard about the expedition earlier,[pause=10] and...)", "Normal")
	GAME:WaitFrames(40)
	GeneralFunctions.HeroDialogue(hero, "(...And when I met " .. partner:GetDisplayName() .. ".)", "Worried")
	GAME:WaitFrames(20)
	
	GeneralFunctions.HeroDialogue(hero, "(The tension I felt those times wasn't as strong as with the obelisk and Luminous Spring,[pause=10] but the feeling was similar.)", "Normal")
	
	GAME:WaitFrames(20)
	GeneralFunctions.HeroSpeak(hero, 60)
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("So you've felt strange more than just those two times,[pause=10] huh?")	
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("If that's the case,[pause=10] maybe there is meaning to those feelings after all.")
	UI:WaitShowDialogue("I doubt you'd feel strange that often for no reason,[pause=10] right?")
	GAME:WaitFrames(20)
	
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("It's just...[pause=0] I can't think of what those moments share in common...[pause=0] They're all so different!")
	UI:WaitShowDialogue("I don't get why the feelings would be stronger some times and weaker other times either.")
	UI:WaitShowDialogue("So I have no clue what the meaning behind your strange feelings could be...")
	GAME:WaitFrames(20)
	
	GeneralFunctions.HeroDialogue(hero, "(.........)", "Sad")
	GAME:WaitFrames(20)
	
	SOUND:FadeOutBGM(120)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("However,[pause=10] just because we can't figure anything else out now doesn't mean we won't solve this!")
	UI:WaitShowDialogue("Lately I've felt that we can do anything when we work together.")
	UI:WaitShowDialogue("So I'm confident that we'll be able to figure this all out together.")
	UI:WaitShowDialogue("But with the expedition coming up,[pause=10] we should concentrate on that first.")
	UI:WaitShowDialogue("We'll get to the bottom of this though![pause=0] I promise,[pause=10] " .. hero:GetDisplayName() .. "!")
	GAME:WaitFrames(20)
	
	GeneralFunctions.HeroDialogue(hero, "(It's frustrating we won't be able to make any progress on this soon...)", "Worried")
	GeneralFunctions.HeroDialogue(hero, "(But with the expedition approaching,[pause=10] it makes sense to focus on that for now.)", "Normal")
	GAME:WaitFrames(20)
	GeneralFunctions.DoAnimation(hero, "Nod")
	GAME:WaitFrames(40)
	
	SOUND:PlayBGM('Goodnight.ogg', true)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("...Well,[pause=10] it's getting pretty late.[pause=0] Staying up stressing more won't do us any good.")
	UI:WaitShowDialogue("We should get some sleep so we can put in a good day tomorrow.")
	
	GAME:WaitFrames(40)
	GROUND:CharSetAnim(partner, "Laying", true)
	GAME:WaitFrames(60)
	GROUND:CharSetAnim(hero, "Laying", true)
	GAME:WaitFrames(40)
	UI:SetSpeaker(partner:GetDisplayName(), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	UI:WaitShowDialogue("Good night,[pause=10] " .. hero:GetDisplayName() .. ".")
	GAME:WaitFrames(40)
	GROUND:CharSetAnim(partner, "EventSleep", true)
	GAME:WaitFrames(40)
	GROUND:CharSetAnim(hero, "EventSleep", true)
	GAME:WaitFrames(180)
	SOUND:FadeOutBGM(120)
	GAME:FadeOut(false, 120)	
	
	SV.Chapter4.FinishedBedtimeCutscene = true
	SV.ChapterProgression.CurrentStoryDungeon = ''--Clear the current story dungeon flag
	SV.TemporaryFlags.MorningAddress = true
	SV.TemporaryFlags.MorningWakeup = true
	GeneralFunctions.EndOfDay()
	--Need to pass 4 (add 3 because of how when it checks the days passed parameter) days before chapter 5 starts
	SV.ChapterProgression.DaysToReach = SV.ChapterProgression.DaysPassed + 3
	GAME:CutsceneMode(false)
	GAME:EnterGroundMap('guild_heros_room', 'Main_Entrance_Marker')

	

end