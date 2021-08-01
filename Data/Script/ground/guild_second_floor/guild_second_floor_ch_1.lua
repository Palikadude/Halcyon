require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'

guild_second_floor_ch_1 = {}




function guild_second_floor_ch_1.MeetNoctowl()
	local partner = CH('Teammate1')
	local hero = CH('PLAYER')
	--swap the partner and hero's spawn points, as the partner is leading in this instance
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	
	--set up background pokemon
	--team rollout
	local marker1 = MRKR("Left_Trio_1")
	local marker2 = MRKR("Left_Trio_2")
	local marker3 = MRKR("Left_Trio_3")
	
	--todo: turn into templates?
	local jigglypuff = GROUND:CreateCharacter("Jigglypuff", "Jigglypuff", marker1.Position.X, marker1.Position.Y, "", "")
	local spheal = GROUND:CreateCharacter("Spheal", "Spheal", marker2.Position.X, marker2.Position.Y, "", "")
	local marill = GROUND:CreateCharacter("Marill", "Marill", marker3.Position.X, marker3.Position.Y, "", "")

	--Team 
	marker1 = MRKR("Generic_Spawn_Duo_1")
	marker2 = MRKR("Generic_Spawn_Duo_2")
	
	local cleffa = GROUND:CreateCharacter("Cleffa", "Cleffa", marker1.Position.X, marker1.Position.Y, "", "")
	local aggron = GROUND:CreateCharacter("Aggron", "Aggron", marker2.Position.X, marker2.Position.Y, "", "")

	--Tsundere team
	marker1 = MRKR("Right_Duo_1")
	marker2 = MRKR("Right_Duo_2")
	
	local mareep = GROUND:CreateCharacter("Mareep", "Mareep", marker1.Position.X, marker1.Position.Y, "", "")
	local cranidos = GROUND:CreateCharacter("Cranidos", "Cranidos", marker2.Position.X, marker2.Position.Y, "", "")
	
	
	--team style. Spawn them and noctowl offscreen.
	local luxio = GROUND:CreateCharacter("Luxio", "Luxio", 480, 280, "", "")
	local glameow = GROUND:CreateCharacter("Glameow", "Glameow", 512, 280, "", "")
	local cacnea = GROUND:CreateCharacter("Cacnea", "Cacnea", 544, 280, "", "")
	local luxio = GROUND:CreateCharacter("Noctowl", "Noctowl", 480, 280, "", "")

	GROUND:SpawnerSetSpawn("TEAMMATE_1", jigglypuff)
	local chara = GROUND:SpawnerDoSpawn("TEAMMATE_1")
	chara = GROUND:SpawnerDoSpawn("Spheal")
	chara = GROUND:SpawnerDoSpawn("Marill")
	chara = GROUND:SpawnerDoSpawn("Cleffa")
	chara = GROUND:SpawnerDoSpawn("Aggron")
	chara = GROUND:SpawnerDoSpawn("Mareep")
	chara = GROUND:SpawnerDoSpawn("Cranidos")
	chara = GROUND:SpawnerDoSpawn("Luxio")
	chara = GROUND:SpawnerDoSpawn("Glameow")
	chara = GROUND:SpawnerDoSpawn("Cacnea")
	chara = GROUND:SpawnerDoSpawn("Noctowl")

	
	GAME:FadeIn(20)



end