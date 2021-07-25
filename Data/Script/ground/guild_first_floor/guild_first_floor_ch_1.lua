require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'

guild_first_floor_ch_1 = {}

function guild_first_floor_ch_1.EnterGuild()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	--swap the partner and hero's spawn points, as the partner is leading in this instance
	local leftPos = hero.Position
	local rightPos = partner.Position
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	GAME:MoveCamera(648, 1208, 1, false)
	GROUND:TeleportTo(partner, leftPos.X, leftPos.Y, Direction.Up)
	GROUND:TeleportTo(hero, rightPos.X, rightPos.Y, Direction.Up)
	GAME:FadeIn(20)
	
	--wow we're inside a tree!
	--do a little hop
	GAME:WaitFrames(20)
	GROUND:CharSetAnim(partner, 'Hurt', true)
	SOUND:PlayBattleSE('EVT_Emote_Startled')
	GROUND:CharSetEmote(partner, 8, 1)	GeneralFunctions.HeroDialogue(hero, "(Wow![pause=0] The guild is all inside a tree!?)", "Surprised")
	GAME:WaitFrames(20)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("I was shocked the first time I came inside the guild too!")
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:WaitShowDialogue("It's incredible that an entire guild was built inside a tree,[pause=10] isn't it?")
	

end