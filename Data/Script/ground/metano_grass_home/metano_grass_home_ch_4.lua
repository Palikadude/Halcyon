require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_grass_home_ch_4 = {}

function metano_grass_home_ch_4.SetupGround()
	if not SV.Chapter4.FinishedGrove then
		local vileplume  = 
			CharacterEssentials.MakeCharactersFromList({
				{'Vileplume', 120, 192, Direction.Up}
			})
	else 
		local vileplume  = 
			CharacterEssentials.MakeCharactersFromList({
				{'Vileplume', 96, 136, Direction.Down},
				{'Bellossom', 96, 192, Direction.Up}
			})
	end
	
	GAME:FadeIn(20)
end

function metano_grass_home_ch_4.Vileplume_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then 
		GeneralFunctions.StartConversation(chara, "With the increase in mystery dungeons and outlaws lately,[pause=10] it amazes me how the town can remain so calm.", "Worried")
		UI:WaitShowDialogue("Things are getting so dangerous,[pause=10] it's all I can think about...")
		GeneralFunctions.EndConversation(chara)
	else
		metano_grass_home_ch_4.Bellossom_Vileplume_Conversation(chara)
	end
end 

function metano_grass_home_ch_4.Bellossom_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then 
		--N/A
	else
		metano_grass_home_ch_4.Bellossom_Vileplume_Conversation(chara)
	end
end


function metano_grass_home_ch_4.Bellossom_Vileplume_Conversation(chara)
	local bellossom = CH('Bellossom')
	local vileplume = CH('Vileplume')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	
	partner.IsInteracting = true
	GROUND:CharSetAnim(vileplume, 'None', true)
	GROUND:CharSetAnim(bellossom, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharSetAnim(partner, 'None', true)
	UI:SetSpeaker(vileplume)
	UI:SetSpeakerEmotion("Worried")
    GROUND:CharTurnToChar(hero, chara)
    local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)
	UI:WaitShowDialogue("Things just seem so dire lately,[pause=10] honey...[pause=0] The danger in the world is bringing me down...")
    TASK:JoinCoroutines({coro1})

	GAME:WaitFrames(20)
	UI:SetSpeaker(bellossom)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Oh dear,[pause=10] you shouldn't worry so much![pause=0] You overthink things!")
	UI:WaitShowDialogue("You just need to think about these sorts of things less!")

	GAME:WaitFrames(20)
	GROUND:CharSetEmote(vileplume, "sweating", 1)
	UI:SetSpeaker(vileplume)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("I wish it were that easy...")

	GROUND:CharEndAnim(vileplume)
	GROUND:CharEndAnim(bellossom)
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	partner.IsInteracting = false
end

--[[function metano_grass_home_ch_4.Bellossom_Vileplume_Conversation(chara, activator)
	local bellossom = CH('Bellossom')
	local vileplume = CH('Vileplume')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	
	partner.IsInteracting = true
	GROUND:CharSetAnim(vileplume, 'None', true)
	GROUND:CharSetAnim(bellossom, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharSetAnim(partner, 'None', true)
	UI:SetSpeaker(vileplume)
	UI:SetSpeakerEmotion("Worried")
    GROUND:CharTurnToChar(hero, chara)
    local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)
	UI:WaitShowDialogue("Things just seem so dire lately,[pause=10] honey...[pause=0] The danger in the world is bringing me down...")
    TASK:JoinCoroutines({coro1})

	GAME:WaitFrames(20)
	UI:SetSpeaker(bellossom)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Oh dear,[pause=10] you shouldn't worry so much![pause=0] Everything's gonna be just fine!")
	UI:WaitShowDialogue("And if something bad does happen,[pause=10] me and the kids will always be with you![pause=0] We're a family!")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(vileplume)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("That's...[pause=30] true![pause=0] That does make me feel better about everything that's been going on.")
	UI:WaitShowDialogue("Thanks honey.[pause=0] I don't know what I'd do without you.")
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(bellossom)
	UI:SetSpeakerEmotion("Joyous")
	UI:WaitShowDialogue("Of course dear![pause=0] We're always here for you,[pause=10] don't ever forget that!")

	GROUND:CharEndAnim(medicham)
	GROUND:CharEndAnim(machamp)
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	partner.IsInteracting = false
end]]--