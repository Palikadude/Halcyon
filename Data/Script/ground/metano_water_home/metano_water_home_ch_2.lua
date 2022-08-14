require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_water_home_ch_2 = {}

function metano_water_home_ch_2.SetupGround()
	
	
	if not SV.Chapter2.FinishedFirstDay then
	
		local quagsire  = 
			CharacterEssentials.MakeCharactersFromList({
				{'Quagsire', 216, 120, Direction.Down}
			})
	
	else 
		local floatzel  = 
			CharacterEssentials.MakeCharactersFromList({
				{'Floatzel', 188, 96, Direction.Down}
			})
			
		GROUND:CharSetAnim(floatzel, "Sleep", true)
	end
	

	
	GAME:FadeIn(20)
end

function metano_water_home_ch_2.Quagsire_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, CharacterEssentials.GetCharacterName("Wooper_Girl") .. ' and ' .. CharacterEssentials.GetCharacterName('Wooper_Boy') .. " are still out there trying to figure out their plans for the day.", "Worried")
	UI:WaitShowDialogue("Those kids of mine...[pause=0] They're sweet,[pause=10] but they're not the brightest.")
	UI:WaitShowDialogue("I wonder where they get it from?")
	GeneralFunctions.EndConversation(chara)
end 

--floatzel needs to remain asleep, but more importantly needs to not show a portrait as there is no sleeping portrait for him, which is why we need to reimplment startconversation here partially
function metano_water_home_ch_2.Floatzel_Action(chara, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	partner.IsInteracting = true
	
	UI:SetSpeaker(chara:GetDisplayName(),true, "", -1, "", RogueEssence.Data.Gender.Unknown)
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)

	GROUND:CharTurnToChar(hero, chara)
    local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, chara, 4) end)
	
	UI:WaitShowDialogue("...Ooowwaaaa...[pause=0] Lower the drawbridge...")

    TASK:JoinCoroutines({coro1})
	UI:WaitDialog()
	--todo: better sleeping onomatopoeia?
	UI:WaitShowDialogue("...Your king wishes to swim in his royal moat...[pause=0] Fwwwwaaaahhhhh....")
	
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	partner.IsInteracting = false
end

