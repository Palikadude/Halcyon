--[[
    common.lua
    A collection of frequently used functions and values!
]]--

require 'halcyon.menu.member_return'
require 'halcyon.config'


COMMON.MISSION_TYPE_RESCUE = 0
COMMON.MISSION_TYPE_ESCORT = 1
COMMON.MISSION_TYPE_OUTLAW = 2
COMMON.MISSION_TYPE_EXPLORATION = 3
COMMON.MISSION_TYPE_LOST_ITEM = 4
COMMON.MISSION_TYPE_OUTLAW_ITEM = 5
COMMON.MISSION_TYPE_OUTLAW_FLEE = 6
COMMON.MISSION_TYPE_OUTLAW_MONSTER_HOUSE = 7
COMMON.MISSION_TYPE_DELIVERY = 8


COMMON.MISSION_INCOMPLETE = 0
COMMON.MISSION_COMPLETE = 1

COMMON.MISSION_BOARD_MISSION = 0
COMMON.MISSION_BOARD_OUTLAW = 1
COMMON.MISSION_BOARD_TAKEN = 2


-- Used in checks for flee outlaws when ongoing missions and returning back to the same floor
-- It might be better just to have a flag on each mission that marks if it's "valid" but this works
COMMON.FLEE_BACKREFERENCE = -2

COMMON.PERSONALITY = {}

--indexing on these start at 1000
COMMON.PERSONALITY[50] = { --Hero


}

--Partner personalities are below
--default
COMMON.PERSONALITY[51] = { 
	FULL = {1000, 1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010},
	HALF = {1000, 1001, 1002, 1003, 1004},
	PINCH = {1000, 1001, 1002, 1003, 1004},
	WAIT = {1000}
	
}

--Rescue mission on this floor
COMMON.PERSONALITY[52] = {
	FULL = {1020, 1021, 1022, 1023, 1024},
	HALF = {1020, 1021, 1022},
	PINCH = {1020, 1021, 1022},
	WAIT = {1000}
}

--Escort mission on this floor
COMMON.PERSONALITY[53] = {
	FULL = {1030, 1031, 1032, 1033, 1034},
	HALF = {1030, 1031, 1032},
	PINCH = {1030, 1031, 1032},
	WAIT = {1000}
}

--Delivery mission on this floor -- you have the item
COMMON.PERSONALITY[54] = {
	FULL = {1040, 1041, 1042},
	HALF = {1040, 1041},
	PINCH = {1040, 1041},
	WAIT = {1000}
	
	
}--Delivery mission on this floor -- you lack the item
COMMON.PERSONALITY[55] = {
	FULL = {1043, 1044, 1045},
	HALF = {1042, 1043},
	PINCH = {1042, 1043},
	WAIT = {1000}
}

--Lost Item mission on this floor
COMMON.PERSONALITY[56] = {
	FULL = {1050, 1051, 1052, 1053, 1054},
	HALF = {1050, 1051, 1052},
	PINCH = {1050, 1051, 1052},
	WAIT = {1000}
}

--Escort is with you, current floor has no active job
COMMON.PERSONALITY[57] = {
	FULL = {1000, 1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010, 1060, 1061, 1062},
	HALF = {1000, 1001, 1002, 1003, 1004, 1060, 1061},
	PINCH = {1000, 1001, 1002, 1003, 1004, 1060, 1061},
	WAIT = {1000}
}

--Exploration escort is with you, current floor has no active job
COMMON.PERSONALITY[58] = {
	FULL = {1000, 1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010, 1070, 1071, 1072},
	HALF = {1000, 1001, 1002, 1003, 1004, 1070, 1071},
	PINCH = {1000, 1001, 1002, 1003, 1004, 1070, 1071},
	WAIT = {1000}
}


--Outlaw mission on this floor
COMMON.PERSONALITY[59] = {
	FULL = {1080, 1081, 1082, 1083, 1084},
	HALF = {1080, 1081, 1082},
	PINCH = {1080, 1081, 1082},
	WAIT = {1000}
}

--These have 1 or more default ones removed typically, and a few custom ones added in specific to that place.
--Relic Forest - Ch 1
COMMON.PERSONALITY[60] = { 
	FULL = {1001, 1002, 1003, 1004, 1006, 1008, 1009, 1100, 1101, 1102, 1103},
	HALF = {1000, 1001, 1002, 1100, 1101},
	PINCH = {1001, 1002, 1004, 1100, 1101},
	WAIT = {1000}
	
}

--Illuminant Riverbed - Ch 2
COMMON.PERSONALITY[61] = { 
	FULL = {1000, 1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1110, 1111, 1112, 1113},
	HALF = {1000, 1001, 1002, 1003, 1004, 1110, 1111},
	PINCH = {1000, 1001, 1002, 1003, 1004, 1110, 1111},
	WAIT = {1000}
	
}

--Crooked Cavern - Ch 3
COMMON.PERSONALITY[62] = { 
	FULL = {1000, 1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1120, 1121, 1122, 1123},
	HALF = {1000, 1001, 1002, 1003, 1004, 1120, 1121},
	PINCH = {1000, 1001, 1002, 1003, 1004, 1120, 1121},
	WAIT = {1000}
	
}

--Crooked Cavern - Ch 3 - After dying to the boss at least once
COMMON.PERSONALITY[63] = { 
	FULL = {1000, 1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1130, 1131, 1132, 1133},
	HALF = {1000, 1001, 1002, 1003, 1004, 1130, 1131},
	PINCH = {1000, 1001, 1002, 1003, 1004, 1130, 1131},
	WAIT = {1000}

}

--Crooked Den - Ch 3 - Boss Fight
COMMON.PERSONALITY[64] = { 
	FULL = {1140, 1141, 1142, 1143, 1144},
	HALF = {1140, 1141, 1142},
	PINCH = {1140, 1141, 1142},
	WAIT = {1000}
	
}

--Apricorn Grove - Ch 4
COMMON.PERSONALITY[65] = { 
	FULL = {1000, 1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1150, 1151, 1152, 1153},
	HALF = {1000, 1001, 1002, 1003, 1004, 1150, 1151},
	PINCH = {1000, 1001, 1002, 1003, 1004, 1150, 1151},
	WAIT = {1000}
	
}

--Apricorn Grove - Ch 4 - Reached the end but did not get the Apricorn
COMMON.PERSONALITY[66] = { 
	FULL = {1000, 1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1160, 1161, 1162, 1163},
	HALF = {1000, 1001, 1002, 1003, 1004, 1160, 1161},
	PINCH = {1000, 1001, 1002, 1003, 1004, 1160, 1161},
	WAIT = {1000}
	
}



--Expedition - Coco Ally Dialogue
COMMON.PERSONALITY[300] = { 
	FULL = {3000, 3001, 3002, 3003, 3004, 3005, 3006, 3007},
	HALF = {3000, 3001, 3002},
	PINCH = {3000, 3001, 3002},
	WAIT = {1000}
}

--Expedition - Rin Ally Dialogue
COMMON.PERSONALITY[301] = { 
	FULL = {3010, 3011, 3012, 3013, 3014, 3015, 3016, 3017},
	HALF = {3010, 3011, 3012},
	PINCH = {3010, 3011, 3012},
	WAIT = {1000}
}

--Expedition - Hyko Ally Dialogue - First segment of Searing Tunnel
COMMON.PERSONALITY[302] = { 
	FULL = {3020, 3021, 3022, 3023, 3024},
	HALF = {3020, 3021, 3022},
	PINCH = {3020, 3021, 3022},
	WAIT = {1000}
}

--Expedition - Hyko Ally Dialogue - Second segment of Searing Tunnel
COMMON.PERSONALITY[303] = { 
	FULL = {3030, 3031, 3032, 3033, 3034},
	HALF = {3030, 3031, 3032},
	PINCH = {3030, 3031, 3032},
	WAIT = {1000}
}

--Expedition - Hyko Ally Dialogue - Searing Tunnel Boss Fight
COMMON.PERSONALITY[304] = { 
	FULL = {3040, 3041, 3042, 3043, 3044},
	HALF = {3040, 3041, 3042},
	PINCH = {3040, 3041, 3042},
	WAIT = {1000}
}

--Expedition - Hyko Ally Dialogue - Searing Tunnel Died to Boss
COMMON.PERSONALITY[305] = { 
	FULL = {3050, 3051, 3052, 3053, 3054},
	HALF = {3050, 3051, 3052},
	PINCH = {3050, 3051, 3052},
	WAIT = {1000}
}

--Expedition - Almotz Ally Dialogue - First segment of Searing Tunnel
COMMON.PERSONALITY[306] = { 
	FULL = {3060, 3061, 3062, 3063, 3064, 3065},
	HALF = {3060, 3061, 3062},
	PINCH = {3060, 3061, 3062},
	WAIT = {1000}
}

--Expedition - Almotz Ally Dialogue - Second segment of Searing Tunnel
COMMON.PERSONALITY[307] = { 
	FULL = {3070, 3071, 3072, 3073, 3074},
	HALF = {3070, 3071, 3072},
	PINCH = {3070, 3071, 3072},
	WAIT = {1000}
}

--Expedition - Almotz Ally Dialogue - Searing Tunnel Boss Fight
COMMON.PERSONALITY[308] = { 
	FULL = {3080, 3081, 3082, 3083, 3084},
	HALF = {3080, 3081, 3082},
	PINCH = {3080, 3081, 3082},
	WAIT = {1000}
}

--Expedition - Almotz Ally Dialogue - Searing Tunnel Died to Boss
COMMON.PERSONALITY[309] = { 
	FULL = {3090, 3091, 3092, 3093, 3094},
	HALF = {3090, 3091, 3092},
	PINCH = {3090, 3091, 3092},
	WAIT = {1000}
}

--Expedition - Ganlon Ally Dialogue - Jerk
COMMON.PERSONALITY[310] = { 
	FULL = {3100, 3101, 3102, 3103, 3104},
	HALF = {3100, 3101, 3102},
	PINCH = {3100, 3101, 3102},
	WAIT = {1000}
}
--Expedition - Ganlon Ally Dialogue - Next To Shuca
COMMON.PERSONALITY[311] = { 
	FULL = {3110, 3111, 3112, 3113, 3114},
	HALF = {3110, 3111, 3112},
	PINCH = {3110, 3111, 3112},
	WAIT = {1000}
}
--Expedition - Ganlon Ally Dialogue - Blushing, talking to Shuca
COMMON.PERSONALITY[312] = { 
	FULL = {3120, 3121, 3122, 3123, 3124},
	HALF = {3120, 3121, 3122},
	PINCH = {3120, 3121, 3122},
	WAIT = {1000}
}

--Expedition - Ganlon Ally Dialogue - Angry, Shuca is critical
COMMON.PERSONALITY[313] = { 
	FULL = {3130, 3131, 3132, 3133, 3134},
	HALF = {3130, 3131, 3132},
	PINCH = {3130, 3131, 3132},
	WAIT = {1000}
}

--Expedition - Ganlon Ally Dialogue - Tender, talking to critical Shuca
COMMON.PERSONALITY[314] = { 
	FULL = {3140, 3141, 3142, 3143, 3144},
	HALF = {3140, 3141, 3142},
	PINCH = {3140, 3141, 3142},
	WAIT = {1000}
}

--Expedition - Shuca Ally Dialogue
COMMON.PERSONALITY[315] = { 
	FULL = {3150, 3151, 3152, 3153, 3154},
	HALF = {3150, 3151, 3152},
	PINCH = {3150, 3151, 3152},
	WAIT = {1000}
}

--Expedition - Shuca Ally Dialogue - Talking to Ganlon
COMMON.PERSONALITY[316] = { 
	FULL = {3160, 3161, 3162, 3163, 3164},
	HALF = {3160, 3161, 3162},
	PINCH = {3160, 3161, 3162},
	WAIT = {1000}
}




--Invalid, default personality. Lets you know there was an error and it defaulted to this as a result.
COMMON.PERSONALITY[999] = {
	FULL = {9999},
	HALF = {9999},
	PINCH = {9999},
	WAIT = {1000}
}


COMMON.ESSENTIALS = {
  { Index = 1, Hidden = 0, Price = 50},
  { Index = 2, Hidden = 0, Price = 150},
  { Index = 6, Hidden = 0, Price = 500},
  { Index = 10, Hidden = 0, Price = 80},
  { Index = 11, Hidden = 0, Price = 80},
  { Index = 12, Hidden = 0, Price = 120},
  { Index = 101, Hidden = 0, Price = 500},
  { Index = 210, Hidden = 0, Price = 400}
}
  
COMMON.UTILITIES = {
  { Index = 37, Hidden = 0, Price = 100},
  { Index = 38, Hidden = 0, Price = 100},
  { Index = 108, Hidden = 0, Price = 80},
  { Index = 110, Hidden = 0, Price = 80},
  { Index = 112, Hidden = 0, Price = 200},
  { Index = 113, Hidden = 0, Price = 80},
  { Index = 114, Hidden = 0, Price = 350},
  { Index = 115, Hidden = 0, Price = 80},
  { Index = 116, Hidden = 0, Price = 80},
  { Index = 117, Hidden = 0, Price = 150},
  { Index = 118, Hidden = 0, Price = 150},
  { Index = 183, Hidden = 0, Price = 120},
  { Index = 184, Hidden = 0, Price = 250},
  { Index = 185, Hidden = 0, Price = 80}
}
  
COMMON.AMMO = {
  { Index = 200, Hidden = 9, Price = 45},
  { Index = 201, Hidden = 9, Price = 90},
  { Index = 202, Hidden = 9, Price = 90},
  { Index = 203, Hidden = 9, Price = 90},
  { Index = 204, Hidden = 9, Price = 360},
  { Index = 207, Hidden = 9, Price = 45},
  { Index = 208, Hidden = 9, Price = 90},
  { Index = 220, Hidden = 9, Price = 180},
  { Index = 221, Hidden = 9, Price = 180},
  { Index = 222, Hidden = 9, Price = 180},
  { Index = 223, Hidden = 9, Price = 180},
  { Index = 225, Hidden = 9, Price = 180},
  { Index = 226, Hidden = 9, Price = 180},
  { Index = 228, Hidden = 9, Price = 180},
  { Index = 231, Hidden = 9, Price = 180},
  { Index = 232, Hidden = 9, Price = 180},
  { Index = 233, Hidden = 9, Price = 180},
  { Index = 234, Hidden = 9, Price = 180}
}
COMMON.ORBS = {
  { Index = 251, Hidden = 0, Price = 150},
  { Index = 252, Hidden = 0, Price = 250},
  { Index = 253, Hidden = 0, Price = 350},
  { Index = 254, Hidden = 0, Price = 200},
  { Index = 256, Hidden = 0, Price = 250},
  { Index = 257, Hidden = 0, Price = 150},
  { Index = 258, Hidden = 0, Price = 150},
  { Index = 259, Hidden = 0, Price = 350},
  { Index = 263, Hidden = 0, Price = 150},
  { Index = 264, Hidden = 0, Price = 300},
  { Index = 265, Hidden = 0, Price = 150},
  { Index = 266, Hidden = 0, Price = 150},
  { Index = 267, Hidden = 0, Price = 250},
  { Index = 268, Hidden = 0, Price = 250},
  { Index = 269, Hidden = 0, Price = 200},
  { Index = 270, Hidden = 0, Price = 200},
  { Index = 271, Hidden = 0, Price = 250},
  { Index = 272, Hidden = 0, Price = 250},
  { Index = 273, Hidden = 0, Price = 250},
  { Index = 274, Hidden = 0, Price = 250},
  { Index = 275, Hidden = 0, Price = 250},
  { Index = 276, Hidden = 0, Price = 250},
  { Index = 277, Hidden = 0, Price = 250},
  { Index = 278, Hidden = 0, Price = 150},
  { Index = 281, Hidden = 0, Price = 350},
  { Index = 282, Hidden = 0, Price = 250},
  { Index = 283, Hidden = 0, Price = 150},
  { Index = 284, Hidden = 0, Price = 150},
  { Index = 286, Hidden = 0, Price = 250},
  { Index = 287, Hidden = 0, Price = 250},
  { Index = 288, Hidden = 0, Price = 150},
  { Index = 289, Hidden = 0, Price = 250}
}
  
COMMON.SPECIAL = {
  { Index = 455, Hidden = 3, Price = 4000},
  { Index = 260, Hidden = 0, Price = 1000},
  { Index = 250, Hidden = 0, Price = 150}
}
  

----------------------------------------------------------
-- Convenience Scription Functions
----------------------------------------------------------
function COMMON.RespawnAllies(reviveAll)
  GROUND:RefreshPlayer()
 
  local party = GAME:GetPlayerPartyTable()
  local playeridx = GAME:GetTeamLeaderIndex()
  local partnerPosition = nil
  local partnerDirection = nil
 
 --custom Halcyon addition to handle partner respawning 
  local partner = CH('Teammate1')
  if partner ~= nil then
	partnerPosition = partner.Position
	partnerDirection = partner.Direction
  end
	
  --Halcyon change: reviveAll parameter. If false, only respawn player+partner. If true, then revive player+Teammates1-3
  --Place player teammates
  if reviveAll == nil then reviveAll = false end
  local allies = 1
  if reviveAll then 
	allies = 3
  end
  
  for i = 1,allies,1
  do
    GROUND:RemoveCharacter("Teammate" .. tostring(i))
  end
  local total = 1
  for i,p in ipairs(party) do
    if i ~= (playeridx + 1) and i <= allies + 1  then --Indices in lua tables begin at 1. Only spawn Teammate1 if reviveAll was false
      GROUND:SpawnerSetSpawn("TEAMMATE_" .. tostring(total),p)
      local chara = GROUND:SpawnerDoSpawn("TEAMMATE_" .. tostring(total))
      --GROUND:GiveCharIdleChatter(chara)
      total = total + 1
    end
  end
  
  partner = CH('Teammate1')

  --custom Halcyon addition: Move partner to their original Position and direction
  if partner ~= nil and partnerPosition ~= nil and partnerDirection ~= nil then 
	GROUND:TeleportTo(partner, partnerPosition.X, partnerPosition.Y, partnerDirection)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
    partner.CollisionDisabled = true 
  end
	
end

function COMMON.RespawnGuests()
	local guests = GAME:GetPlayerGuestCount()
	for i=1, guests, 1 do 
		GROUND:RemoveCharacter("Guest" .. tostring(i))
		local g = GAME:GetPlayerGuestMember(i-1)
		GROUND:SpawnerSetSpawn("GUEST_" .. tostring(i), g)
		local chara = GROUND:SpawnerDoSpawn("GUEST_" .. tostring(i))
	end
end 

function COMMON.ShowTeamAssemblyMenu(init_fun)
  SOUND:PlaySE("Menu/Skip")
  UI:AssemblyMenu()
  UI:WaitForChoice()
  result = UI:ChoiceResult()
  if result then
    GAME:WaitFrames(10)
	SOUND:PlayBattleSE("EVT_Assembly_Bell")
	GAME:FadeOut(false, 40)
	init_fun()
    GAME:FadeIn(40)
  end
end





function COMMON.MakeWhoosh(center, y, tier, reversed)
    local whoosh1 = RogueEssence.Content.FiniteOverlayEmitter()
    whoosh1.FadeIn = 30
    whoosh1.TotalTime = 90
    whoosh1.RepeatX = true
	if reversed then
		whoosh1.Movement = RogueElements.Loc(-360, 0)
	else
		whoosh1.Movement = RogueElements.Loc(360, 0)
	end
    whoosh1.Layer = DrawLayer.Top
    whoosh1.Anim = RogueEssence.Content.BGAnimData("Pre_Battle", 1, tier, tier)
	GROUND:PlayVFX(whoosh1, center.X, center.Y + y)
end

--Slightly tweaked Halcyon version.
function COMMON.BossTransition()
	--Heal everyone in the party before the boss fight.
	local chara
	for i = 0, GAME:GetPlayerPartyCount() - 1, 1 do
		chara = GAME:GetPlayerPartyMember(i)
		chara:FullRestore()
	end

    local center = GAME:GetCameraCenter()
    SOUND:FadeOutBGM(20)
    local emitter = RogueEssence.Content.FlashEmitter()
    emitter.FadeInTime = 2
    emitter.HoldTime = 2
    emitter.FadeOutTime = 2
    emitter.StartColor = Color(0, 0, 0, 0)
    emitter.Layer = DrawLayer.Top
    emitter.Anim = RogueEssence.Content.BGAnimData("White", 0)
    GROUND:PlayVFX(emitter, center.X, center.Y)
    SOUND:PlayBattleSE("EVT_Battle_Flash")
    GAME:WaitFrames(16)
    GROUND:PlayVFX(emitter, center.X, center.Y)
    SOUND:PlayBattleSE("EVT_Battle_Flash")
    GAME:WaitFrames(46)
    
    SOUND:PlayBattleSE('EVT_Battle_Transition')
	COMMON.MakeWhoosh(center, -32, 0, false)
    GAME:WaitFrames(5)
	COMMON.MakeWhoosh(center, -64, 0, true)
	COMMON.MakeWhoosh(center, 0, 0, true)
    GAME:WaitFrames(5)
	COMMON.MakeWhoosh(center, -112, 1, false)
	COMMON.MakeWhoosh(center, 48, 1, false)
    GAME:WaitFrames(5)
	COMMON.MakeWhoosh(center, -144, 2, true)
	COMMON.MakeWhoosh(center, 80, 2, true)
    GAME:WaitFrames(5)
	COMMON.MakeWhoosh(center, -176, 3, false)
	COMMON.MakeWhoosh(center, 112, 3, false)
    GAME:WaitFrames(40)
    GAME:FadeOut(true, 30)
    GAME:WaitFrames(120)
	
	
end


function COMMON.UnlockWithFanfare(dungeon_id)
  if not GAME:DungeonUnlocked(dungeon_id) then
    UI:WaitShowDialogue(STRINGS:FormatKey("DLG_NEW_AREA_TO"))
    GAME:UnlockDungeon(dungeon_id)
	local zone = RogueEssence.Data.DataManager.Instance.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get(dungeon_id)
    SOUND:PlayFanfare("Fanfare/NewArea")
    UI:WaitShowDialogue(STRINGS:FormatKey("DLG_NEW_AREA", zone:GetColoredName()))
  end

end


function COMMON.DungeonInteract(chara, target, action_cancel, turn_cancel)
  action_cancel.Cancel = true
  -- TODO: create a charstate for being unable to talk and have talk-interfering statuses cause it
  if COMMON.CanTalk(target) then
    
    UI:SetSpeaker(target)
    local mon = _DATA:GetMonster(target.BaseForm.Species)
    local form = mon.Forms[target.BaseForm.Form]
    local ratio = target.HP * 100 // target.MaxHP
    
    local personality = form:GetPersonalityType(target.Discriminator)
    
    local key_pool = {}
    
    
    local personality_group = COMMON.PERSONALITY[personality]
    if personality_group ~= nil then
      local num_pool = {}
      local key = ""
      if ratio <= 25 then
        UI:SetSpeakerEmotion("Pain")
        num_pool = personality_group.PINCH
        key = "TALK_PINCH_%04d"
      elseif ratio <= 50 then
        UI:SetSpeakerEmotion("Worried")
        num_pool = personality_group.HALF
        key = "TALK_HALF_%04d"
      else
        num_pool = personality_group.FULL
        key = "TALK_FULL_%04d"
      end
      
      for ii = 1, #num_pool, 1 do
        local chosen_pool_idx = num_pool[ii]
        local formatted_key = string.format(key, chosen_pool_idx)
        table.insert(key_pool, formatted_key)
      end
      
    else
    
      local key = ""
      if target:GetStatusEffect("confuse") ~= nil then
        UI:SetSpeakerEmotion("Dizzy")
        key = "TALK_%02d_DIZZY_%03d"
      elseif ratio <= 25 then
        UI:SetSpeakerEmotion("Pain")
        key = "TALK_%02d_PINCH_%03d"
      elseif ratio <= 50 then
        UI:SetSpeakerEmotion("Worried")
        key = "TALK_%02d_HALF_%03d"
      else
        key = "TALK_%02d_FULL_%03d"
      end
    
      local pool_idx = 0
      while true do
      
        local formatted_key = string.format(key, personality, pool_idx)
        if not RogueEssence.StringKey.HasValue(formatted_key) then
          break
        end
        
        table.insert(key_pool, formatted_key)
      
        pool_idx = pool_idx + 1
      end
    end
    
    
    local running_pool = {}
    
    for ii = 1, #key_pool, 1 do
	  
      local formatted_key = key_pool[ii]

      local valid_quote = true
      local test_quote = RogueEssence.StringKey(formatted_key):ToLocal()
  	
      test_quote = string.gsub(test_quote, "%[player%]", chara:GetDisplayName(true))
      test_quote = string.gsub(test_quote, "%[myname%]", target:GetDisplayName(true))
      
      if string.find(test_quote, "%[move%]") then
        local moves = {}
  	    for move_idx = 0, 3 do
  	      if target.BaseSkills[move_idx].SkillNum ~= "" then
  	        table.insert(moves, target.BaseSkills[move_idx].SkillNum)
  	      end
  	    end
  	    if #moves > 0 then
  	      local chosen_move = _DATA:GetSkill(moves[math.random(1, #moves)])
  	      test_quote = string.gsub(test_quote, "%[move%]", chosen_move:GetIconName())
  	    else
  	      valid_quote = false
  	    end
      end
      
      if string.find(test_quote, "%[kind%]") then
  	    if GAME:GetCurrentFloor().TeamSpawns.CanPick then
          local team_spawn = GAME:GetCurrentFloor().TeamSpawns:Pick(GAME.Rand)
  	      local chosen_list = team_spawn:ChooseSpawns(GAME.Rand)
          
  	      if chosen_list.Count > 0 then
  	        local chosen_mob = chosen_list[math.random(0, chosen_list.Count-1)]
  	        local mon = _DATA:GetMonster(chosen_mob.BaseForm.Species)
            test_quote = string.gsub(test_quote, "%[kind%]", mon:GetColoredName())
  	      else
  	        valid_quote = false
  	      end
  	    else
  	      valid_quote = false
  	    end
      end
      
      if string.find(test_quote, "%[item%]") then
        if GAME:GetCurrentFloor().ItemSpawns.CanPick then
          local item = GAME:GetCurrentFloor().ItemSpawns:Pick(GAME.Rand)
          test_quote = string.gsub(test_quote, "%[item%]", item:GetDisplayName())
  	    else
  	      valid_quote = false
  	    end
      end
  	
  	  if valid_quote then
        table.insert(running_pool, test_quote)
  	  end
    end
	
    local chosen_idx = math.random(1, #running_pool)
    local chosen_quote = running_pool[chosen_idx]
	
    local oldDir = target.CharDir
    DUNGEON:CharTurnToChar(target, chara)
  
    UI:WaitShowDialogue(STRINGS:Format(chosen_quote))
  
    target.CharDir = oldDir
  else
  
    UI:ResetSpeaker()
  
    local chosen_quote = RogueEssence.StringKey("TALK_CANT"):ToLocal()
    chosen_quote = string.gsub(chosen_quote, "%[myname%]", target:GetDisplayName(true))
  
    UI:WaitShowDialogue(chosen_quote)
  
  end
  
  --characters can comment on:

  --flavour for the dungeon (talk about the area and its lore)
  --being able to evolve
  --nearly reaching the end of the dungeon
  --being hungry
  --out of PP
  --being able to recruit someone
  --tutorial tips
  ---gaining EXP while in assembly
  ---apricorns
  ---sleeping pokemon
  --commenting on how long they've been on the team
  ---I know we just met, but...
  ---We've been together for over 10 floors now, don't leave me now!
  --beginning a fight "do you think we can take them?"
  --upon recruitment "explore the world, you say?  I'm in!" "yay, friends!" "fine, I'll come with you.  just don't slow me down" "oh my... you smell heavenly.  can I come with you?"
  --"you look tasty- I mean X, can I come with you?", "Team X, huh?  I like the sound of that!", "you lot seem smart/wise, I think you have what it takes to reach the top."
  --when/after someone faints "X isn't with us anymore... but we have to keep going."
  --"if you faint as the leader, I'll gladly take your place."
  --specific personalities for mechanical creatures
  --specific personalities for childish creatures
  --verbal tics (chirp/tweet, meow, woof/arf, squeak, pika)
  --third-person dialogue
  --burned "ow, ow ,ow!  hot, hot!, hot!"
  --paralyzed "I can't feel my legs..." (check body type for this)
  --when there's only 2 members left, and no means to summon more recruits "we're the only ones left." "come on!  we can't give up!"
  --"I wonder what [fainted mon] would've done..."
  --lore on the legendary guildmasters
  ---
  --the rise of recent disasters- mystery dungeons
  --the guildmaster's treasures?
  --a challenge that no one has passed yet; people stopped bothering
  --but as the disasters appear, the pokemon begin to search for a leader
  --At low HP: "X's resolve is being tested..."
  --isn't my fur just luxurious? (vain personality)
  --first priority is for phrases that occur at each break point
  --would you like to hear a song? (if knows sing, round, or perish song)
  --"so it's just us now, huh?" (two pokemon, one or more has fainted)
  --We're going to be okay, right?  Tell me we're going to be okay.
  --Hey... if I don't make it out of here, tell (assembly mon) I love her.
  --talk about how one of their moves is a type, and it will be super-effective on an enemy found on the floor
  --rumors spread of a treasure in a dangerous location
  ----actually a trap; an ambush spot
  --My body wasn't ready for this...
  --Hey, what is it like to have arms?
  --That Red apricorn you have there.  We can use it to recruit a Fire-type Pokemon.
  --Let's find a strong Fire-type Pokemon to give that Red Apricorn to.
  --That Oran Berry we just picked up should help us in a pinch.
  --Those Mankeys are fighting-type Pokemon.  We should hit them with Flying type moves!
  --So why are you in this exploration? [Treasure][Meet Pokemon][Guildmaster][I dunno]
  --To set foot in this dungeon... you're either very brave, or foolhardy.
  --I've gotta hand it to you. Not many Exploration teams make it this far.
  --Too bad I don't have any hands.
  --You know what's weird?  We've been talking all this time and those (visible Pokemon) over there haven't made a single step towards us.  Do you think they're just that polite?
  --I don't like the look that (enemy pokemon) is giving me...
  --But enough talk, we need to get to the next floor.
  --But enough talk, we've got a situation here! (if multiple enemies are in sight)
  --Anyways, we need to keep moving.
  --Finally!  The stairs! (cheer when the stairs come into view, and load this dialogue up in time)
  --sleep
  --"Zzz...[pause=0] another five minutes please..."
  --"Zzz...[pause=10] Zzz..."
  --decoy
  --"...What?"
  --"...What's a \"decoy\"?"
  --"Do I look like I know what a \"decoy\" is?"
  --"Hey Einstein, I'm on your side!"
  --"Is there something on my face?"

  --evolve
  --"Hey, I think I'm ready to evolve now!"
  --"Hey, I think I can evolve into a {0} now!"
  --"I sense something... getting ready to evolve now"
  --"Did you know?  I'm ready to evolve now!"
  --"What should I evolve into?  Any ideas?"
  --"Oh, I just can't wait till I evolve!"
  --"I'm getting excited just thinking about it!"
  --"I swear to god when I evolve, I am going to kill you all!"

  --"Let's make it all the way to the end!"
  --"I wanna be...[pause=0]\nthe very best..."
  --"You teach me, and I'll teach you."
  --"I'll rescue you and if I do you gotta rescue me."
  --"Who should we recruit next?"
  --"Some apricorns can only recruit certain types of Pokémon.[pause=0] You know that, yes?"
  --"Rumor has it that whoever reaches the summit will be given the title of Guildmaster."
  --"So why do they call you the {0} Pokémon?", DataManager.Instance.GetMonster(character.BaseForm.Species).Title.ToLocal()

  --"Press {0} if you want me to lead the team.", (ii + 1).ToString()
  --"press 1 if you feel bad for [fainted mon]"

  
end


function COMMON.GroundInteract(chara, target)
  GROUND:CharTurnToChar(target, chara)
  UI:SetSpeaker(target)
  
  local mon = RogueEssence.Data.DataManager.Instance:GetMonster(target.CurrentForm.Species)
  local form = mon.Forms[target.CurrentForm.Form]
  
  local personality = form:GetPersonalityType(target.Data.Discriminator)
  
  local personality_group = COMMON.PERSONALITY[personality]
  local pool = personality_group.WAIT
  local key = "TALK_WAIT_%04d"
  
  local running_pool = {table.unpack(pool)}
  local valid_quote = false
  local chosen_quote = ""
  
  while not valid_quote and #running_pool > 0 do
    valid_quote = true
    local chosen_idx = math.random(1, #running_pool)
	local chosen_pool_idx = running_pool[chosen_idx]
    chosen_quote = RogueEssence.StringKey(string.format(key, chosen_pool_idx)):ToLocal()
	
    chosen_quote = string.gsub(chosen_quote, "%[hero%]", chara:GetDisplayName())
    
	if not valid_quote then
      -- PrintInfo("Rejected "..chosen_quote)
	  table.remove(running_pool, chosen_idx)
	  chosen_quote = ""
	end
  end
  -- PrintInfo("Selected "..chosen_quote)
  
  
  UI:WaitShowDialogue(chosen_quote)
end


function COMMON.EnterDungeonMissionCheck(zoneId, segmentID)
  for name, mission in pairs(SV.TakenBoard) do
    PrintInfo("Checking Mission: "..tostring(name))
    if mission.Taken and mission.Completion == COMMON.MISSION_INCOMPLETE and zoneId == mission.Zone and segmentID == mission.Segment and mission.Client ~= "" then
      if mission.Type == COMMON.MISSION_TYPE_ESCORT or mission.Type == COMMON.MISSION_TYPE_EXPLORATION then -- escort
        -- add escort to team
        local player_count = GAME:GetPlayerPartyCount()
        local guest_count = GAME:GetPlayerGuestCount()
		
		--check to see if an escort is already in the team. If so, stop right here and don't assign him back in.
		--This is mostly relevant for coming out the front and going back in at Apricorn Grove.
		for i = 0, guest_count - 1, 1 do 
			local guest_tbl = LTBL(GAME:GetPlayerGuestMember(i))
			if guest_tbl.Escort ~= nil then return end 
		end 
		
        if player_count + guest_count >= 4 then
          SOUND:StopBGM()
          local state = 0
          while state > -1 do
            UI:ResetSpeaker()
            UI:WaitShowDialogue("Have one of your team members return to the guild to make room for your client, " .. _DATA:GetMonster(mission.Client):GetColoredName() .. ".")
            local MemberReturnMenu = CreateMemberReturnMenu()
            local menu = MemberReturnMenu:new()
            UI:SetCustomMenu(menu.menu)
            UI:WaitForChoice()
            local member = menu.members[menu.current_item]
            UI:ChoiceMenuYesNo("Send " .. member:GetDisplayName(true) .. " back to the guild?", false)
            UI:WaitForChoice()

            local send_home = UI:ChoiceResult()
            if send_home then 
              local slot = menu.slots[menu.current_item]
              GAME:AddPlayerAssembly(member);
              GAME:RemovePlayerTeam(slot)
              state = -1
            end
          end
        end
		
		--Set max team size to 3 as the guest is "taking" up a party slot
		RogueEssence.Dungeon.ExplorerTeam.MAX_TEAM_SLOTS = 3

        local mon_id = RogueEssence.Dungeon.MonsterID(mission.Client, 0, "normal", GeneralFunctions.NumToGender(mission.ClientGender))
        -- set the escort level 20% less than the expected level
        local level = math.floor(MISSION_GEN.EXPECTED_LEVEL[mission.Zone] * 0.80)
        local new_mob = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, level, "", -1)
        local tactic = _DATA:GetAITactic("stick_together")
        new_mob.Tactic = RogueEssence.Data.AITactic(tactic);
        _DATA.Save.ActiveTeam.Guests:Add(new_mob)
        local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("EscortInteract")
        new_mob.ActionEvents:Add(talk_evt)
      
        local tbl = LTBL(new_mob)
        tbl.Escort = name
        UI:ResetSpeaker()
        UI:WaitShowDialogue("Added [color=#00FF00]".. new_mob.Name .."[color] to the party as a guest.")
      end
    end
  end
  
  --play music if zone current map exists. It seems to me that current map check would otherwise fail if we're in a dungeon's ground temporarily (for example, coming out the front of Apricorn Grove)
  if _ZONE.CurrentMap ~= nil then 
	SOUND:PlayBGM(_ZONE.CurrentMap.Music, true)
  end 
end

function COMMON.EndRescue(zone, result, rescue, segmentID)
  COMMON.EndDayCycle()
  local zoneId = 'master_zone'
  local structureId = -1
  local mapId = 21
  local entryId = 2
  -- SV.partner.Spawn = 'Rescue_Spawn_Partner'
  GAME:EndDungeonRun(result, zoneId, structureId, mapId, entryId, true, true)
  SV.General.Rescue = result
  GAME:EnterZone(zoneId, structureId, mapId, entryId)
  -- GAME:EnterGroundMap("post_office", "Rescue_Spawn", true)
end


function COMMON.Rescued(zone, name, mail)
  if _DATA.CurrentReplay ~= nil then
    SOUND:PlayBattleSE("EVT_Title_Intro")
    GAME:FadeOut(true, 0)
    GAME:FadeIn(20)
    SOUND:PlayBGM("C05. Rescue.ogg", true)
	_DUNGEON:LogMsg(STRINGS:FormatKey("MSG_RESCUED_BY", name))
  else
    local team = RogueEssence.Dungeon.ExplorerTeam()
    team.Name = mail.RescuedBy
    SOUND:PlayBattleSE("EVT_Title_Intro")
    GAME:FadeOut(true, 0)
    GAME:FadeIn(20)
    SOUND:PlayBGM("C05. Rescue.ogg", true)
    TASK:WaitTask(_MENU:SetDialogue(STRINGS:FormatKey("MSG_RESCUES_LEFT", _DATA.Save.RescuesLeft)))
    GAME:WaitFrames(10)
  end
  
  local player_count = GAME:GetPlayerPartyCount()
  for i = 0, player_count - 1, 1 do 
    local player = GAME:GetPlayerPartyMember(i)
    if player:GetStatusEffect("critical_health") ~= nil then
      TASK:WaitTask(player:RemoveStatusEffect("critical_health"))
    end
  end

  local rescue_idx = "rescued"
  local rescue_status = RogueEssence.Dungeon.MapStatus(rescue_idx)
  rescue_status:LoadFromData()
  TASK:WaitTask(_DUNGEON:AddMapStatus(rescue_status))
end


function COMMON.ExitDungeonMissionCheck(result, rescue, zoneId, segmentID)
  local exited = false
  for name, mission in ipairs(SV.TakenBoard) do
    PrintInfo("Checking Mission: "..tostring(name))
    if mission.Taken and mission.Completion == COMMON.MISSION_INCOMPLETE and zoneId == mission.Zone and segmentID == mission.Segment then
      if mission.Type == COMMON.MISSION_TYPE_ESCORT or mission.Type == COMMON.MISSION_TYPE_EXPLORATION then -- escort
          -- remove the escort from the party
        local escort = COMMON.FindMissionEscort(name)
        if escort then
          --Set max team size to 4 as the guest is no longer "taking" up a party slot
          RogueEssence.Dungeon.ExplorerTeam.MAX_TEAM_SLOTS = 4
          _DUNGEON:RemoveChar(escort)
        end
      end
    end
  end
  
  --Remove any lost/stolen items. If the item's ID starts with "mission" then delete it on exiting the dungeon.
  	local itemCount = GAME:GetPlayerBagCount()
	local item
	
	local i = 0
	while i <= itemCount - 1 do 
		item = GAME:GetPlayerBagItem(i)
		if string.sub(item.ID, 1, 7) == "mission" then
			GAME:TakePlayerBagItem(i, true)
			itemCount = itemCount - 1
		else
			i = i + 1 
		end
	end
	
	--send equipped items to storage
	for i = 1, GAME:GetPlayerPartyCount(), 1 do
		item = GAME:GetPlayerEquippedItem(i-1)
		if string.sub(item.ID, 1, 7) == "mission" then
			GAME:TakePlayerEquippedItem(i-1, true)
		end
	end

  if rescue == true then
    COMMON.EndRescue(zone, result, segmentID)
    exited = true
  end
  
  return exited
	
end


function COMMON.CanTalk(chara)
  if chara:GetStatusEffect("sleep") ~= nil then
    return false
  end
  if chara:GetStatusEffect("freeze") ~= nil then
    return false
  end
  if chara:GetStatusEffect("confuse") ~= nil then
    return false
  end
  return true
end

function COMMON.EndDayCycle()
  --reshuffle items

  
  SV.base_shop = { }
  
  math.randomseed(GAME:GetDailySeed())
  --roll a random index from 1 to length of category
  --add the item in that index category to the shop
  --2 essentials, always
  local type_count = 2
	for ii = 1, type_count, 1 do
		local base_data = COMMON.ESSENTIALS[math.random(1, #COMMON.ESSENTIALS)]
		table.insert(SV.base_shop, base_data)
	end
  
  --1-2 ammo, always
  type_count = math.random(1, 2)
	for ii = 1, type_count, 1 do
		local base_data = COMMON.AMMO[math.random(1, #COMMON.AMMO)]
		table.insert(SV.base_shop, base_data)
	end
  
  --2-3 utilities, always
  type_count = math.random(3, 4)
	for ii = 1, type_count, 1 do
		local base_data = COMMON.UTILITIES[math.random(1, #COMMON.UTILITIES)]
		table.insert(SV.base_shop, base_data)
	end
  
  --1-2 orbs, always
  type_count = math.random(1, 2)
	for ii = 1, type_count, 1 do
		local base_data = COMMON.ORBS[math.random(1, #COMMON.ORBS)]
		table.insert(SV.base_shop, base_data)
	end
  
  --1-2 special item, always
  type_count = 1
	for ii = 1, type_count, 1 do
		local base_data = COMMON.SPECIAL[math.random(1, #COMMON.SPECIAL)]
		table.insert(SV.base_shop, base_data)
	end
  
  
  local catalog = {}
  
  for ii = 1, #COMMON_GEN.TRADES_RANDOM, 1 do
	local base_data = COMMON_GEN.TRADES_RANDOM[ii]
	table.insert(catalog, base_data)
  end

  SV.base_trades = { }
  type_count = 5
	for ii = 1, type_count, 1 do
		local idx = math.random(1, #catalog)
		local base_data = catalog[idx]
		table.insert(SV.base_trades, base_data)
		table.remove(catalog, idx)
	end
end