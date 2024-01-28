require 'common'
require 'GeneralFunctions'


STATUS_SCRIPT = {}

function STATUS_SCRIPT.Test(owner, ownerChar, context, args)
  PrintInfo("Test")
end


MAP_STATUS_SCRIPT = {}

function MAP_STATUS_SCRIPT.Test(owner, ownerChar, character, status, msg, args)
  PrintInfo("Test")
end


function MAP_STATUS_SCRIPT.ShopGreeting(owner, ownerChar, character, status, msg, args)
  
  if status ~= owner or character ~= nil then
    return
  end
  local found_shopkeep = COMMON.FindNpcWithTable(false, "Role", "Shopkeeper")
  if found_shopkeep and COMMON.CanTalk(found_shopkeep) then
    DUNGEON:CharTurnToChar(found_shopkeep, _DUNGEON.ActiveTeam.Leader)
    UI:SetSpeaker(found_shopkeep)
	GAME:WaitFrames(10)
    --Halcyon tweak: If you talk to kec or enter his shop after stealing, he'll aggro you
    if SV.adventure.Thief then
	  COMMON.ThiefReturn()
    else  
	  UI:WaitShowDialogue(RogueEssence.StringKey(string.format("TALK_SHOP_START_%04d", found_shopkeep.Discriminator)):ToLocal())
	  GAME:WaitFrames(10)
    end
  end
end


function MAP_STATUS_SCRIPT.SetShopkeeperHostile(owner, ownerChar, character, status, msg, args)
  
  if status ~= owner or character ~= nil then
    return
  end
  local found_shopkeep = COMMON.FindNpcWithTable(false, "Role", "Shopkeeper")
  if found_shopkeep then
    local teamIndex = _ZONE.CurrentMap.AllyTeams:IndexOf(found_shopkeep.MemberTeam)
	_DUNGEON:RemoveTeam(RogueEssence.Dungeon.Faction.Friend, teamIndex)
	_DUNGEON:AddTeam(RogueEssence.Dungeon.Faction.Foe, found_shopkeep.MemberTeam)
	local tactic = _DATA:GetAITactic("shopkeeper") -- shopkeeper attack tactic
	found_shopkeep.Tactic = RogueEssence.Data.AITactic(tactic)
	found_shopkeep.Tactic:Initialize(found_shopkeep)
	
	local berserk_idx = "shopkeeper"
	local berserk = RogueEssence.Dungeon.StatusEffect(berserk_idx)
	TASK:WaitTask(found_shopkeep:AddStatusEffect(nil, berserk, false))
  end
  -- force everyone to skip their turn for this entire session
  _DUNGEON:SkipRemainingTurns()
end

ITEM_SCRIPT = {}

function ITEM_SCRIPT.Test(owner, ownerChar, context, args)
  local text = "You got a " .. context.Item:GetDungeonName()
  local notice = _MENU:CreateNotice("Test", text)
  _DUNGEON.PendingLeaderAction = _MENU:ProcessMenuCoroutine(notice)
end

function ITEM_SCRIPT.MissionItemPickup(owner, ownerChar, context, args)
  local mission_num = args.Mission
  local mission = SV.TakenBoard[mission_num]
  if mission.Item == context.Item.Value then
    mission.Completion = COMMON.MISSION_COMPLETE
    SV.TemporaryFlags.MissionCompleted = true
    GAME:WaitFrames(70)
	UI:ResetSpeaker()
    UI:WaitShowDialogue("Yes! You found " .. _DATA:GetMonster(mission.Client):GetColoredName() .. "'s " .. context.Item:GetDungeonName() .. "!")
	  --Clear but remember minimap state
    SV.TemporaryFlags.PriorMapSetting = _DUNGEON.ShowMap
    _DUNGEON.ShowMap = _DUNGEON.MinimapState.None
    
    --Slight pause before asking to warp out 
    GAME:WaitFrames(20)
    GeneralFunctions.AskMissionWarpOut()
  end
end

function ITEM_SCRIPT.OutlawItemPickup(owner, ownerChar, context, args)
  local mission_num = args.Mission
  local mission = SV.TakenBoard[mission_num]
  if mission.Item == context.Item.Value then
    SV.OutlawItemPickedUp = true
  end
end

REFRESH_SCRIPT = {}

function REFRESH_SCRIPT.Test(owner, ownerChar, character, args)
  PrintInfo("Test")
end


SKILL_CHANGE_SCRIPT = {}

function SKILL_CHANGE_SCRIPT.Test(owner, character, skillIndices, args)
  PrintInfo("Test")
end

GROUND_ITEM_EVENT_SCRIPT = {}

-- context.Item - The current inventory being used (InvItem)
-- context.Owner - The current ground user that used the item (GroundChar)
-- context.User = The party member that the item is going to apply its effect to (Character)
-- Reimplementation of the GummiEvent (BattleEvent) in PMDC.Dungeon but for ground usage
function GROUND_ITEM_EVENT_SCRIPT.GroundGummiEvent(context, args)
  assert(args.TargetElement ~= nil, "Gummi type needs to be initialized")
  local form_data = context.User.BaseForm
  local form = _DATA:GetMonster(form_data.Species).Forms[form_data.Form]
  local target_element = args.TargetElement
  local sound = ""
  if args.Sound == nil then
    sound = "DUN_Gummi"
  else
    sound = args.Sound
  end
  
  --what type boosts what stat.
  local gummi_stat = {
	water = RogueEssence.Data.Stat.HP,
	dark = RogueEssence.Data.Stat.HP,
	normal = RogueEssence.Data.Stat.HP,

	ice = RogueEssence.Data.Stat.MDef,
	grass = RogueEssence.Data.Stat.MDef,
	fairy = RogueEssence.Data.Stat.MDef,

	dragon = RogueEssence.Data.Stat.Attack,
	ground = RogueEssence.Data.Stat.Attack,
	fighting = RogueEssence.Data.Stat.Attack,

	psychic = RogueEssence.Data.Stat.MAtk,
	ghost = RogueEssence.Data.Stat.MAtk,
	fire = RogueEssence.Data.Stat.MAtk,
	
	poison = RogueEssence.Data.Stat.Defense,
	steel = RogueEssence.Data.Stat.Defense,
	rock = RogueEssence.Data.Stat.Defense,

	electric = RogueEssence.Data.Stat.Speed,
	flying = RogueEssence.Data.Stat.Speed,
	bug = RogueEssence.Data.Stat.Speed
  }

  local type_matchup = PMDC.Dungeon.PreTypeEvent.CalculateTypeMatchup(target_element, context.User.Element1)
  type_matchup = type_matchup + PMDC.Dungeon.PreTypeEvent.CalculateTypeMatchup(target_element, context.User.Element2)
  -- print("Type matchup: " .. tostring(type_matchup) .. " with " .. target_element)
  local heal = 5
  local boosted = false
  
  UI:ResetSpeaker()
  SOUND:PlayBattleSE(sound)
  if target_element == _DATA.DefaultElement or context.User.Element1 == target_element or context.User.Element2 == target_element then
	--type match
	heal = 20
    boosted = BoostStat(RogueEssence.Data.Stat.HP, 2, context.User) or boosted
    boosted = BoostStat(RogueEssence.Data.Stat.Attack, 2, context.User) or boosted
    boosted = BoostStat(RogueEssence.Data.Stat.Defense, 2, context.User) or boosted
    boosted = BoostStat(RogueEssence.Data.Stat.MAtk, 2, context.User) or boosted
    boosted = BoostStat(RogueEssence.Data.Stat.MDef, 2, context.User) or boosted
    boosted = BoostStat(RogueEssence.Data.Stat.Speed, 2, context.User) or boosted
  elseif type_matchup > PMDC.Dungeon.PreTypeEvent.NRM_2 then
  --Super effective
	heal = 10
	--this is a messy way of doing this visually cleanly to the user, but i couldn't come up with something smarter. I guess you could put it all in a table but that's the same shit really.
	local hp_boost = 1
	local atk_boost = 1
	local def_boost = 1
	local spatk_boost = 1
	local spdef_boost = 1
	local speed_boost = 1
	
	if gummi_stat[args.TargetElement] == RogueEssence.Data.Stat.HP then hp_boost = 2 end
	if gummi_stat[args.TargetElement] == RogueEssence.Data.Stat.Attack then atk_boost = 2 end
	if gummi_stat[args.TargetElement] == RogueEssence.Data.Stat.Defense then def_boost = 2 end
	if gummi_stat[args.TargetElement] == RogueEssence.Data.Stat.MAtk then spatk_boost = 2 end
	if gummi_stat[args.TargetElement] == RogueEssence.Data.Stat.MDef then spdef_boost = 2 end
	if gummi_stat[args.TargetElement] == RogueEssence.Data.Stat.Speed then speed_boost = 2 end
	
	--print(tostring(hp_boost) .. tostring(atk_boost) .. tostring(def_boost) .. tostring(spatk_boost) .. tostring(spdef_boost) .. tostring(speed_boost))
	
    boosted = BoostStat(RogueEssence.Data.Stat.HP, hp_boost, context.User) or boosted
    boosted = BoostStat(RogueEssence.Data.Stat.Attack, atk_boost, context.User) or boosted
    boosted = BoostStat(RogueEssence.Data.Stat.Defense, def_boost, context.User) or boosted
    boosted = BoostStat(RogueEssence.Data.Stat.MAtk, spatk_boost, context.User) or boosted
    boosted = BoostStat(RogueEssence.Data.Stat.MDef, spdef_boost, context.User) or boosted
    boosted = BoostStat(RogueEssence.Data.Stat.Speed, speed_boost, context.User) or boosted
  elseif type_matchup == PMDC.Dungeon.PreTypeEvent.NRM_2 then
  --neutral
    heal = 10
    boosted = BoostStat(gummi_stat[args.TargetElement], 2, context.User) or boosted
  elseif type_matchup > PMDC.Dungeon.PreTypeEvent.N_E_2 then 
  --Not very effective 
    heal = 5
    boosted = BoostStat(gummi_stat[args.TargetElement], 1, context.User) or boosted
  else
  --No effect
	heal = 5
  end

  if not boosted then
    UI:WaitShowDialogue(RogueEssence.Text.FormatGrammar(RogueEssence.StringKey("MSG_NOTHING_HAPPENED"):ToLocal()))
  end

  if args.PrintGummiFillBelly then
    if heal > 15 then
      UI:WaitShowDialogue(RogueEssence.Text.FormatGrammar(RogueEssence.StringKey("MSG_HUNGER_FILL"):ToLocal(), context.User:GetDisplayName(false)))
    elseif heal > 5 then
      UI:WaitShowDialogue(RogueEssence.Text.FormatGrammar(RogueEssence.StringKey("MSG_HUNGER_FILL_MIN"):ToLocal(), context.User:GetDisplayName(false)))
    end
  end

  context.User.Fullness = context.User.Fullness + heal
  if context.User.Fullness >= context.User.MaxFullness then
    context.User.Fullness = context.User.MaxFullness
    context.User.FullnessRemainder = 0
  end
  
  	--print("HP Stat EXP = " .. tostring(context.User.MaxHPBonus))
	--print("Attack Stat EXP = " .. tostring(context.User.AtkBonus))
	--print("Defense Stat EXP = " .. tostring(context.User.DefBonus))
	--print("Sp. Atk Stat EXP = " .. tostring(context.User.MAtkBonus))
	--print("Sp. Def Stat EXP = " .. tostring(context.User.MDefBonus))
	--print("Speed Stat EXP = " .. tostring(context.User.SpeedBonus))
end

function GROUND_ITEM_EVENT_SCRIPT.GroundWonderGummiEvent(context, args)
  -- { Heal = 20, Msg = true, Change = 2, BoostedStat = "none" }
  GROUND_ITEM_EVENT_SCRIPT.GroundVitaminEvent(context, args)
  GROUND_ITEM_EVENT_SCRIPT.GroundRestoreBellyEvent(context, args)
end

-- Reimplementation of the RestoreBellyEvent (BattleEvent) in PMDC.Dungeon but for ground usage
function GROUND_ITEM_EVENT_SCRIPT.GroundRestoreBellyEvent(context, args)

  local MIN_MAX_FULLNESS = 50;
  local MAX_MAX_FULLNESS = 150;

  local heal = args.Heal
  local msg = args.Msg
  local add_max_belly = args.AddMaxBelly
  local need_full_belly = args.NeedFullBelly

  if add_max_belly == nil then add_max_belly = 0 end

  local full_belly = context.User.Fullness == context.User.MaxFullness

  context.User.Fullness = context.User.Fullness + heal

  if heal < 0 then
    if msg then
      if context.User.Fullness <= 0 then
        UI:WaitShowDialogue(RogueEssence.Text.FormatGrammar(RogueEssence.StringKey("MSG_HUNGER_EMPTY"):ToLocal(), context.User:GetDisplayName(true)))
      else
        UI:WaitShowDialogue(RogueEssence.Text.FormatGrammar(RogueEssence.StringKey("MSG_HUNGER_DROP"):ToLocal(), context.User:GetDisplayName(false)))
      end
    end
    --SOUND:PlayBattleSE("DUN_Hunger")
  else
    if msg then
      UI:WaitShowDialogue(RogueEssence.Text.FormatGrammar(RogueEssence.StringKey("MSG_HUNGER_FILL"):ToLocal(), context.User:GetDisplayName(false)))
    end
  end

  if add_max_belly ~= 0 and (full_belly or not need_full_belly) then
    if msg then
      if add_max_belly < 0 then
        UI:WaitShowDialogue(RogueEssence.Text.FormatGrammar(RogueEssence.StringKey("MSG_MAX_HUNGER_DROP"):ToLocal(), context.User:GetDisplayName(false)))
      else
        UI:WaitShowDialogue(RogueEssence.Text.FormatGrammar(RogueEssence.StringKey("MSG_MAX_HUNGER_BOOST"):ToLocal(), context.User:GetDisplayName(false)))
      end
    end

    context.User.MaxFullness = context.User.MaxFullness + add_max_belly
    if context.User.MaxFullness < MIN_MAX_FULLNESS then
      context.User.MaxFullness = MIN_MAX_FULLNESS
    end

    if context.User.MaxFullness > MAX_MAX_FULLNESS then
      context.User.MaxFullness = MAX_MAX_FULLNESS
    end
  end

  if context.User.Fullness < 0 then
    context.User.Fullness = 0
  end

  if context.User.Fullness >= context.User.MaxFullness then
    context.User.Fullness = context.User.MaxFullness
    context.User.FullnessRemainder = 0
  end
end

function GROUND_ITEM_EVENT_SCRIPT.GroundVitaminEvent(context, args)
  local lookup_table = {}

  lookup_table["hp"] = RogueEssence.Data.Stat.HP
  lookup_table["attack"] = RogueEssence.Data.Stat.Attack
  lookup_table["defense"] = RogueEssence.Data.Stat.Defense
  lookup_table["special_attack"] = RogueEssence.Data.Stat.MAtk
  lookup_table["special_defense"] = RogueEssence.Data.Stat.MDef
  lookup_table["speed"] = RogueEssence.Data.Stat.Speed
  lookup_table["none"] = RogueEssence.Data.Stat.None

  assert(lookup_table[args.BoostedStat] ~= nil, "Stat type needs to be initialized")
  assert(args.Change ~= nil, "Change amount needs to be initialized")
  local sound = ""
  if args.Sound == nil then
    sound = "DUN_Drink"
  else
    sound = args.Sound
  end

  local boosted = false
  local boosted_stat = lookup_table[args.BoostedStat]
  local change = args.Change

  UI:ResetSpeaker()
  SOUND:PlayBattleSE(sound)
  if boosted_stat ~= RogueEssence.Data.Stat.None then
    boosted = boosted or BoostStat(boosted_stat, change, context.User)
  else
    boosted = BoostStat(RogueEssence.Data.Stat.HP, change, context.User) or boosted
    boosted = BoostStat(RogueEssence.Data.Stat.Attack, change, context.User) or boosted
    boosted = BoostStat(RogueEssence.Data.Stat.Defense, change, context.User) or boosted
    boosted = BoostStat(RogueEssence.Data.Stat.MAtk, change, context.User) or boosted
    boosted = BoostStat(RogueEssence.Data.Stat.MDef, change, context.User) or boosted
    boosted = BoostStat(RogueEssence.Data.Stat.Speed, change, context.User) or boosted
  end

  if not boosted then
    UI:WaitShowDialogue(RogueEssence.Text.FormatGrammar(RogueEssence.StringKey("MSG_NOTHING_HAPPENED"):ToLocal()))
  end
  
    --print("HP Stat EXP = " .. tostring(context.User.MaxHPBonus))
	--print("Attack Stat EXP = " .. tostring(context.User.AtkBonus))
	--print("Defense Stat EXP = " .. tostring(context.User.DefBonus))
	--print("Sp. Atk Stat EXP = " .. tostring(context.User.MAtkBonus))
	--print("Sp. Def Stat EXP = " .. tostring(context.User.MDefBonus))
	--print("Speed Stat EXP = " .. tostring(context.User.SpeedBonus))
end

function BoostStat(stat, change, target)
  local prev_stat = 0
  local new_stat = 0

  local lookup_table = {}

  lookup_table[RogueEssence.Data.Stat.HP] = function()
    prev_stat = target.MaxHP
    target.MaxHPBonus = math.min(target.MaxHPBonus + change, PMDC.Data.MonsterFormData.MAX_STAT_BOOST)
	--if the boost given is not enough to get a visual stat point, keep boosting until it is.
    --while (target.MaxHP == prev_stat and target.MaxHPBonus <  PMDC.Data.MonsterFormData.MAX_STAT_BOOST) do
    --  target.MaxHPBonus = target.MaxHPBonus + 1
    --end
    target.HP = target.MaxHP
    new_stat = target.MaxHP
  end

  lookup_table[RogueEssence.Data.Stat.Attack] = function()
    prev_stat = target.BaseAtk
    target.AtkBonus = math.min(target.AtkBonus + change, PMDC.Data.MonsterFormData.MAX_STAT_BOOST)
    --while (target.BaseAtk == prev_stat and target.AtkBonus < PMDC.Data.MonsterFormData.MAX_STAT_BOOST) do
    --  target.AtkBonus = target.AtkBonus + 1
    --end
    new_stat = target.BaseAtk
  end

  lookup_table[RogueEssence.Data.Stat.Defense] = function()
    prev_stat = target.BaseDef
    target.DefBonus = math.min(target.DefBonus + change, PMDC.Data.MonsterFormData.MAX_STAT_BOOST)
    --while (target.BaseDef == prev_stat and target.DefBonus < PMDC.Data.MonsterFormData.MAX_STAT_BOOST) do
    --  target.DefBonus = target.DefBonus + 1
    --end
    new_stat = target.BaseDef
  end

  lookup_table[RogueEssence.Data.Stat.MAtk] = function()
    prev_stat = target.BaseMAtk
    target.MAtkBonus = math.min(target.MAtkBonus + change, PMDC.Data.MonsterFormData.MAX_STAT_BOOST)
    --while (target.BaseMAtk == prev_stat and target.MAtkBonus < PMDC.Data.MonsterFormData.MAX_STAT_BOOST) do
    --  target.MAtkBonus = target.MAtkBonus + 1
    --end
    new_stat = target.BaseMAtk
  end

  lookup_table[RogueEssence.Data.Stat.MDef] = function()
    prev_stat = target.BaseMDef
    target.MDefBonus = math.min(target.MDefBonus + change, PMDC.Data.MonsterFormData.MAX_STAT_BOOST)
    --while (target.BaseMDef == prev_stat and target.MDefBonus < PMDC.Data.MonsterFormData.MAX_STAT_BOOST) do
    --  target.MDefBonus = target.MDefBonus + 1
    --end
    new_stat = target.BaseMDef
  end

  lookup_table[RogueEssence.Data.Stat.Speed] = function()
    prev_stat = target.BaseSpeed
    target.SpeedBonus = math.min(target.SpeedBonus + change, PMDC.Data.MonsterFormData.MAX_STAT_BOOST)
    --while (target.BaseSpeed == prev_stat and target.SpeedBonus < PMDC.Data.MonsterFormData.MAX_STAT_BOOST) do
    --  target.SpeedBonus = target.SpeedBonus + 1
    --end
    new_stat = target.BaseSpeed
  end

  lookup_table[stat]()

  if new_stat > prev_stat then
    UI:WaitShowDialogue(RogueEssence.Text.FormatGrammar(RogueEssence.StringKey("MSG_STAT_BOOST"):ToLocal(), target:GetDisplayName(false), RogueEssence.Text.ToLocal(stat), tostring(new_stat - prev_stat)))
    return true
  else
    return false
  end
 
end


function AddStat(stat, context)
  local prev_stat = 0
  local new_stat = 0
  local lookup_table = {}
  lookup_table[RogueEssence.Data.Stat.HP] = function()
    if context.User.MaxHPBonus < PMDC.Data.MonsterFormData.MAX_STAT_BOOST then
      prev_stat = context.User.MaxHP
      context.User.MaxHPBonus = context.User.MaxHPBonus + 1
      context.User.HP = context.User.MaxHP
      new_stat = context.User.MaxHP
    end
  end

  lookup_table[RogueEssence.Data.Stat.Attack] = function()
    if context.User.AtkBonus < PMDC.Data.MonsterFormData.MAX_STAT_BOOST then
      prev_stat = context.User.BaseAtk
      context.User.AtkBonus = context.User.AtkBonus + 1
      new_stat = context.User.BaseAtk
    end
  end

  lookup_table[RogueEssence.Data.Stat.Defense] = function()
    if context.User.DefBonus < PMDC.Data.MonsterFormData.MAX_STAT_BOOST then
      prev_stat = context.User.BaseDef
      context.User.DefBonus = context.User.DefBonus + 1
      new_stat = context.User.BaseDef
    end
  end

  lookup_table[RogueEssence.Data.Stat.MAtk] = function()
    if context.User.MAtkBonus < PMDC.Data.MonsterFormData.MAX_STAT_BOOST then
      prev_stat = context.User.MAtkBonus
      context.User.MAtkBonus = context.User.MAtkBonus + 1
      new_stat = context.User.MAtkBonus
    end
  end

  lookup_table[RogueEssence.Data.Stat.MDef] = function()
    if context.User.MDefBonus < PMDC.Data.MonsterFormData.MAX_STAT_BOOST then
      prev_stat = context.User.BaseMDef
      context.User.MDefBonus = context.User.MDefBonus + 1
      new_stat = context.User.BaseMDef
    end
  end

  lookup_table[RogueEssence.Data.Stat.Speed] = function()
    if context.User.SpeedBonus < PMDC.Data.MonsterFormData.MAX_STAT_BOOST then
      prev_stat = context.User.BaseSpeed
      context.User.SpeedBonus = context.User.SpeedBonus + 1
      new_stat = context.User.BaseSpeed
    end
  end

  lookup_table[stat]()
  if new_stat - prev_stat > 0 then
    UI:WaitShowDialogue(RogueEssence.Text.FormatGrammar(RogueEssence.StringKey("MSG_STAT_BOOST"):ToLocal(), context.User:GetDisplayName(false), RogueEssence.Text.ToLocal(stat), tostring(new_stat - prev_stat)))
  end
end