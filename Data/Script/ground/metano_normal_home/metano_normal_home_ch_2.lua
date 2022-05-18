require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_normal_home_ch_2 = {}

function metano_normal_home_ch_2.SetupGround()
	local linoone, sentret  = 
		CharacterEssentials.MakeCharactersFromList({
			{'Linoone', 202, 166, Direction.Left},
			{'Sentret', 256, 116, Direction.Down}
		})
	
	GROUND:CharSetAnim(sentret, "Sleep", true)
	
	GAME:FadeIn(20)
end

function metano_normal_home_ch_2.Linoone_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Placeholder.")
	GeneralFunctions.EndConversation(chara)
end 

function metano_normal_home_ch_2.Sentret_Action(chara, activator)
	local linoone = CH('Linoone')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local olddir = linoone.Direction
	UI:SetSpeaker(linoone)
	UI:SetSpeakerEmotion("Normal")
	GeneralFunctions.EmoteAndPause(linoone, "Exclaim", true)
	GROUND:CharTurnToCharAnimated(linoone, hero, 4)
	UI:WaitShowDialogue("Hey![pause=0] What are you two doing over there?")
	
	GeneralFunctions.DuoTurnTowardsChar(linoone)
	
	UI:WaitShowDialogue(CharacterEssentials.GetCharacterName('Sentret') .. " is down for his nap.[pause=0] Please don't wake him up!")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	GROUND:CharSetEmote(partner, 5, 1)
	UI:WaitShowDialogue("O-oh.[pause=0] Sorry ma'am!")
	GROUND:CharAnimateTurnTo(linoone, olddir, 4)
end