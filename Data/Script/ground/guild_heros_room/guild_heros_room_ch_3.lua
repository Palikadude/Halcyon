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
	local coro2 = TASK:BranchCoroutine(function() UI:WaitShowBG("Chapter_2", 180, 20)
												  GAME:WaitFrames(180)
												  UI:WaitHideBG(20) end)
	TASK:JoinCoroutines({coro1, coro2})
	
	GAME:WaitFrames(120)
	guild_heros_room_helper.Morning(true)

end


function guild_heros_room_ch_3.PostOutlawBedtalk()
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
	UI:WaitShowDialogue("Y'know,[pause=10] when we first confronted him,[pause=10] I was pretty nervous.[pause=0] I was expecting a showdown with a dangerous criminal!")
	UI:WaitShowDialogue("But it turned out he wasn't such a bad guy...[pause=0] Just someone who made a poor choice.")
	UI:WaitShowDialogue("I know it was our job,[pause=10] and I know he stole that scarf he was wearing...")
	UI:WaitShowDialogue("But I can't help but feel awful about arresting him.[pause=0] Doing our job was probably the right thing to do,[pause=10] but...")
	
	GAME:WaitFrames(20)
	GeneralFunctions.StartTremble(partner)
	UI:SetSpeakerEmotion("Teary-Eyed")
	UI:WaitShowDialogue("Seeing him taken away by " .. CharacterEssentials.GetCharacterName("Bisharp") .. ",[pause=10] with that defeated look in his eyes,[pause=10] just made me feel terrible...")
	UI:WaitShowDialogue("It should have been those bullies Team [color=#FFA5FF]Style[color] being led away by " .. CharacterEssentials.GetCharacterName("Bisharp") .. ",[pause=10] not " .. CharacterEssentials.GetCharacterName("Sandile") .. "...")
	
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(" .. partner:GetDisplayName() .. "...)", "Sad")

	GAME:WaitFrames(20)
	GeneralFunctions.StopTremble(partner)
	GeneralFunctions.ShakeHead(partner, 4)
	GAME:WaitFrames(10)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
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
	UI:WaitShowDialogue("...Maybe if I tell a story it'll help take my mind off things.")
	
	GAME:WaitFrames(20)
	UI:WaitShowDialogue(CharacterEssentials.GetCharacterName("Relicanth") .. ",[pause=10] the town elder who lives in the pond to the south of town...")
	UI:WaitShowDialogue("Being so old,[pause=10] he knows a lot of the history of the world,[pause=10] as well as plenty of myths and legends.")
	UI:WaitShowDialogue("If he caught me trying to sneak into Relic Forest,[pause=10] sometimes he'd tell me one of them.")
	UI:WaitShowDialogue("...After yelling at me for trying to sneak into the forest,[pause=10] that is...")
	UI:WaitShowDialogue("Anyways,[pause=10] one time he told me about the legend of the Anima Roots.[pause=0] That story was always my favorite!")
	
	GAME:WaitFrames(20)
	GeneralFunctions.HeroDialogue(hero, "(Huh?[pause=0] Anima Roots?)", "Worried")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner:GetDisplayName(), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	SOUND:PlayBGM('Time Gear Remix.ogg', true)
	UI:SetSpeaker(partner)
	UI:WaitShowDialogue("He told me that Anima Roots are these mystical,[pause=10] living fragments of something greater that exist in hidden places around the world.")
	UI:WaitShowDialogue("Nobody really knows where they are,[pause=10] but " .. CharacterEssentials.GetCharacterName("Relicanth") ..  " says they could be in all sorts of different places.")
	UI:WaitShowDialogue("They could be in a dangerous volcano...[pause=0] In a ruined,[pause=10] ancient city lost to time...")
	UI:WaitShowDialogue("...Or they could be in a place as regular as a forest.")
	
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("Whereever they are in the world,[pause=10] they each serve a very important purpose.")
	UI:WaitShowDialogue("According to " .. CharacterEssentials.GetCharacterName("Relicanth") .. ",[pause=10] Anima Roots are responsible for allowing a region of the world to sustain life.")
	UI:WaitShowDialogue("If something was to destroy a region's Anima Root...[pause=0] Well,[pause=10] " ..  CharacterEssentials.GetCharacterName("Relicanth") .. " didn't seem too sure what would happen.")
	UI:WaitShowDialogue("But if I had to guess,[pause=10] that region of the world would probably lose its ability to sustain life properly.")
	UI:WaitShowDialogue("It would be an absolute disaster if something ever happened to one of them.")

	GAME:WaitFrames(40)
	UI:WaitShowDialogue("At least,[pause=10] that's how the legend goes.[pause=0] It's hard to tell whether " ..  CharacterEssentials.GetCharacterName("Relicanth") .. "'s stories are fact or fiction...")
	UI:WaitShowDialogue("But I certainly hope they're true![pause=0] These sorts of stories are part of the reason I wanted to become an adventurer!")
	UI:WaitShowDialogue("Just thinking about mythical things like this gets me so excited!")
	UI:WaitShowDialogue("One day I hope we're able to discover if these stories are true!")
	UI:WaitShowDialogue("If they are,[pause=10] we'll have to do everything we can to protect the Anima Roots so nothing bad ever happens to them.")
	
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
	GAME:WaitFrames(60)
	


end 