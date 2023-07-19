require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_fire_home_ch_3 = {}

function metano_fire_home_ch_3.SetupGround()

	if SV.Chapter3.DefeatedBoss then 
		local camerupt  = 
			CharacterEssentials.MakeCharactersFromList({
				{'Camerupt', 112, 104, Direction.UpLeft},

			})
		
	end 
	
	GAME:FadeIn(20)
end

function metano_fire_home_ch_3.Camerupt_Action(chara, activator)
	--too long with no nicknames
	GeneralFunctions.StartConversation(chara, CharacterEssentials.GetCharacterName("Numel") .. " has been better about doing his chores ever since you two rescued him.[pause=0] He's been more considerate too.")
	UI:SetSpeakerEmotion("Teary-Eyed")
	UI:WaitShowDialogue("Sniff...[pause=0] My baby boy...[pause=0] He's growing up so fast...")
	GeneralFunctions.EndConversation(chara)
end 
