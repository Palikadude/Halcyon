require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'
require 'ground.guild_heros_room.guild_heros_room_helper'

guild_heros_room_ch_3 = {}



--show title card, then do a generic wakeup.
function guild_heros_room_ch_3.FirstMorning()
	GAME:FadeOut(false, 1)
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(CH('Teammate1'))
	UI:ResetSpeaker()
	SOUND:StopBGM()
	SV.Chapter3.ShowedTitleCard = true
	GAME:WaitFrames(60)
	local coro1 = TASK:BranchCoroutine(function() UI:WaitShowTitle("Chapter 3\n\nRivals\n", 20)
												  GAME:WaitFrames(180)
												  UI:WaitHideTitle(20) end)
	local coro2 = TASK:BranchCoroutine(function() UI:WaitShowBG("Chapter_3", 180, 20)
												  GAME:WaitFrames(180)
												  UI:WaitHideBG(20) end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(120)
	guild_heros_room_helper.Morning(true)

end

--The scene before previewing the root
function guild_heros_room_ch_3.PostOutlawBedtalkFirstHalf()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GAME:CutsceneMode(true)
	guild_heros_room_helper.Bedtime(false)
	UI:ResetSpeaker()
	GAME:FadeIn(40)
	
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("relic_forest")

	SOUND:PlayBGM('Goodnight.ogg', true)
	GAME:WaitFrames(40)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("I'm worn out after today.[pause=0] Today was a lot more than I had bargained for.")
	UI:WaitShowDialogue("I still can't believe our first outlaw mission turned into a fight with another adventuring team.")
	UI:WaitShowDialogue("It's amazing the lengths Team [color=#FFA5FF]Style[color] were willing to go just to try to humiliate us.")

	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("I'm glad we were able to beat Team [color=#FFA5FF]Style[color] and all,[pause=10] but I can't get my mind off poor " .. CharacterEssentials.GetCharacterName("Sandile") .. ".")
	UI:WaitShowDialogue("Y'know,[pause=10] when we first confronted him,[pause=10] I was pretty nervous.")
	UI:WaitShowDialogue("I was expecting a showdown with a dangerous criminal!")
	UI:WaitShowDialogue("But it turned out he wasn't such a bad guy...[pause=0] Just someone who made a poor choice.")
	UI:WaitShowDialogue("I know it was our job,[pause=10] and I know he stole that scarf he was wearing...")
	UI:WaitShowDialogue("But I can't help but feel awful about arresting him.")
	UI:WaitShowDialogue("Doing our job was probably the right thing to do,[pause=10] but...")
	
	GAME:WaitFrames(20)
	--GeneralFunctions.StartTremble(partner)
	UI:SetSpeakerEmotion("Teary-Eyed")
	UI:WaitShowDialogue("Seeing him taken away by " .. CharacterEssentials.GetCharacterName("Bisharp") .. ",[pause=10] with that defeated look in his eyes,[pause=10] just made me feel terrible...")
	UI:WaitShowDialogue("It should have been those bullies Team [color=#FFA5FF]Style[color] being led away by " .. CharacterEssentials.GetCharacterName("Bisharp") .. ",[pause=10] not " .. CharacterEssentials.GetCharacterName("Sandile") .. "...")
	
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(" .. partner:GetDisplayName() .. "...)", "Sad")

	GAME:WaitFrames(20)
	--GeneralFunctions.StopTremble(partner)
	GeneralFunctions.ShakeHead(partner, 4)
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("...I don't really wanna think about it anymore tonight.[pause=0] Let's just get some sleep.")
	
	GAME:WaitFrames(40)
	SOUND:FadeOutBGM(60)
	GAME:FadeOut(false, 60)
	GAME:WaitFrames(120)
	GROUND:CharSetAnim(partner, "Laying", true)
	GROUND:CharSetAnim(hero, "Laying", true)
	GAME:FadeIn(60)

	GAME:WaitFrames(60)
	UI:SetSpeaker(partner:GetDisplayName(), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(".........")
	UI:WaitShowDialogue("...Are you still awake,[pause=10] " .. hero:GetDisplayName() .. "?")
	
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("I'm having trouble sleeping...[pause=0] I can't stop thinking about what happened earlier.")
	UI:WaitShowDialogue("Maybe if I tell a story it'll help take my mind off things.")
	
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("relic_forest")
	GAME:WaitFrames(20)
	UI:WaitShowDialogue(CharacterEssentials.GetCharacterName("Relicanth") .. ",[pause=10] the town elder who lives in the pond to the south of town...")
	UI:WaitShowDialogue("Being so old,[pause=10] he knows a lot of the history of the world,[pause=10] as well as plenty of myths and legends.")
	UI:WaitShowDialogue("If he caught me trying to sneak into " .. zone:GetColoredName() .. ",[pause=10] sometimes he'd tell me one of them.")
	UI:WaitShowDialogue("...After yelling at me for trying to sneak into the forest,[pause=10] that is...")
	UI:WaitShowDialogue("Anyways,[pause=10] one time he told me about the legend of the Anima Cores.[pause=0] That story's my favorite!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker('', false, "", -1, "", RogueEssence.Data.Gender.Unknown)
	UI:WaitShowDialogue("(Huh?[pause=0] Anima Cores?)")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner:GetDisplayName(), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	SOUND:PlayBGM('Anima Core.ogg', false)
	UI:WaitShowDialogue("Anima Cores are mystical,[pause=10] living fragments of something greater that exist in hidden places.")
	--cut here to a preview of the root
	GAME:WaitFrames(20)
	GAME:FadeOut(false, 40)
	GAME:EnterGroundMap('first_core_location', 'Main_Entrance_Marker', true)
end 


--After previewing root
function guild_heros_room_ch_3.PostOutlawBedtalkSecondHalf()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GAME:CutsceneMode(true)
	guild_heros_room_helper.Bedtime(false, true)
	--SOUND:PlayBGM('Time Gear Remix.ogg', false)
	UI:SetSpeaker(partner:GetDisplayName(), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	GROUND:CharSetAnim(partner, "Laying", true)
	GROUND:CharSetAnim(hero, "Laying", true)
	GAME:FadeIn(40)

	
	GAME:WaitFrames(40)
	UI:WaitShowDialogue("At least,[pause=10] that's how the legend goes.[pause=0] It's hard to tell whether " ..  CharacterEssentials.GetCharacterName("Relicanth") .. "'s stories are fact or fiction...")
	UI:WaitShowDialogue("But I certainly hope they're true![pause=0] Stories like this are part of the reason I became an adventurer!")
	UI:WaitShowDialogue("Just thinking about mythical things like this gets me so excited!")
	UI:WaitShowDialogue("One day I hope we're able to discover if these stories are true!")
	UI:WaitShowDialogue("If they are,[pause=10] we should do everything we can to protect the Anima Cores so nothing bad happens to them.")
	
	GAME:WaitFrames(20)
	SOUND:FadeOutBGM(60)
	GAME:WaitFrames(60)
	UI:WaitShowDialogue(".........")
	UI:WaitShowDialogue("...Yawn.[pause=0] I'm getting sleepy now.[pause=0] I feel better after telling that story,[pause=10] too.")
	UI:WaitShowDialogue("Let's try to get some sleep.[pause=0] We'll need all our energy for tomorrow's adventures.")


	GAME:WaitFrames(40)
	UI:WaitShowDialogue("Good night,[pause=10] " .. hero:GetDisplayName() .. ".")
	GAME:WaitFrames(40)
	GROUND:CharSetAnim(partner, "EventSleep", true)
	GAME:WaitFrames(40)
	GROUND:CharSetAnim(hero, "EventSleep", true)
	
	GAME:WaitFrames(180)
	SOUND:FadeOutBGM(120)
	GAME:FadeOut(false, 120)
	GAME:CutsceneMode(false)
	GAME:WaitFrames(120)
		
	GAME:EnterGroundMap('first_core_location', 'Main_Entrance_Marker')


end 

function guild_heros_room_ch_3.DemoThanks()
	UI:ResetSpeaker()
	UI:WaitShowDialogue("That's the end of the demo! Thank you so much for playing!")
	UI:WaitShowDialogue("I hope you enjoyed playing the Halcyon demo! More chapters to come in the future!")
	UI:WaitShowDialogue("Special thanks to Audino for all his help with the Origins engine.")
	UI:WaitShowDialogue("Without his help, Halcyon could not have been made!")
	UI:WaitShowDialogue("I'd also like to thank Trio- for helping with mission generation scripts and other scripting odds and ends.")
	UI:WaitShowDialogue("He saved me a lot of time and grief with all the help he provided.")
	UI:WaitShowDialogue("Please check the readme for the full list of credits!")
	UI:WaitShowDialogue("Everyone who helped out did a great job, and I appreciate all that they've done!")
	UI:WaitShowDialogue("If you have any feedback you would like to share, please do so in the relevant Halcyon discord channel!")
	UI:WaitShowDialogue("I'm interested to hear what people think about the game or if they have any suggestions or thoughts!")
	UI:WaitShowDialogue("If you're interesting in contributing to Halcyon as well, please let Palika know!")
	UI:WaitShowDialogue("I would need sprite artists and musicians to help with custom assets now and then...")
	UI:WaitShowDialogue("So if that's up your alley and you're interested, please let me know!")
	UI:WaitShowDialogue("Anyways, you can keep playing Halcyon to complete the randomly generated missions if you feel like.")
	UI:WaitShowDialogue("Nothing can progress the game any further right now, as I need to develop more of the story.")
	UI:WaitShowDialogue("Thank you again for playing! Returning back to normal gameplay... now!")
end