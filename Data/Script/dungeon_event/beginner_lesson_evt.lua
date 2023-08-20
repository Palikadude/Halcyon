require 'common'

beginner_lesson_evt = {}

--ledian is the 3rd party member
function beginner_lesson_evt.FindLedian()
--this check is needed as Ledian joins the team for floor 4 to allow team mode to work
	if GAME:GetPlayerGuestCount() == 0 then 
		return GAME:GetPlayerPartyMember(1)
	else
		return GAME:GetPlayerGuestMember(0)
	end
end


--owner is the owner of the effect. For example, if the code is for lefties recovery, then the owner might be say, aqua ring, the item lefties, or the ability regenerator (if it worked like that)
--ownerChar is the character that has the particular status/item/ability/whatever. Whoever has the lefties.
--character is the character with the item/ability/status. Whoever has the lefties, they are the target of the effect
--args is a list of arguments passed to the script (see the arg table in the SingleCharScriptEvent effect)
function beginner_lesson_evt.Floor_1_Intro(owner, ownerChar, character, args)
	--progression flag is the number of speeches given by ledian. the functions in this document follow the order they're given in the dungeon
	local chara = beginner_lesson_evt.FindLedian()
	UI:SetSpeaker(chara)
	UI:WaitShowDialogue("Hwacha![pause=0] Welcome to the dojo's learning area![pause=0] It is time for your first lesson!")
	UI:WaitShowDialogue("Hoiyah![pause=0] On this floor you will learn much about the basics of dungeon crawling!")
	UI:WaitShowDialogue("Volunteers ahead will either demonstrate learning topics,[pause=10] or pose as obstacles to conquer!")
	UI:WaitShowDialogue("Be sure to read the signs left by my star pupil![pause=0] They contain vital knowledge essential to dungeon crawling!")
	UI:WaitShowDialogue("You can speak to me at any time to reset the floor if you find yourself stuck![pause=0] Don't be shy,[pause=10] my student!")
	UI:WaitShowDialogue("Onwards![pause=0] There is much learning to do,[pause=10] kya!")
	SV.Tutorial.Progression = 1
end

function beginner_lesson_evt.Floor_2_Intro(owner, ownerChar, character, args)
	local chara = beginner_lesson_evt.FindLedian()
	UI:SetSpeaker(chara)
	UI:WaitShowDialogue("Hwacha![pause=0] On this floor you will learn about different status effects you will encounter on your journeys!")
	UI:WaitShowDialogue("Status effects are buffs or debuffs that affect a Pokémon's ability to battle!")
	UI:WaitShowDialogue("The volunteers ahead will demonstrate moves that apply status moves![pause=0] Attack them and they'll use their move!")
	SV.Tutorial.Progression = 2
end


function beginner_lesson_evt.Floor_3_Intro(owner, ownerChar, character, args)
	local hero = GAME:GetPlayerPartyMember(0)
	if SV.Tutorial.Progression == 3 then --set hunger and belly to 0 if ledian already cut hunger but you haven't passed the trial yet
		--set player hp to half, belly to 0
		hero.HP = hero.MaxHP / 2
		hero.Fullness = 0
	end
	
	local chara = beginner_lesson_evt.FindLedian()
	if SV.Tutorial.Progression == 2 then 
		chara.CharDir = Direction.Up
	end
	UI:SetSpeaker(chara)
	UI:WaitShowDialogue("Hwacha![pause=0] This floor will teach you about wise and proper item use!")
	UI:WaitShowDialogue("Wahtah![pause=0] Your first trial begins here!")
	--ledian assaults you, but only on entering the floor
	if SV.Tutorial.Progression == 2 then
		--todo: tidy up when Audino adds calls for dungeon animations
		GAME:WaitFrames(10)
		local ledianAction = RogueEssence.Dungeon.CharAnimAction()
		ledianAction.BaseFrameType = 8 --chop
		ledianAction.AnimLoc = chara.CharLoc
		ledianAction.CharDir = chara.CharDir
		TASK:WaitTask(chara:StartAnim(ledianAction))
		SOUND:PlayBattleSE('DUN_Attack')
		GAME:WaitFrames(10)
		local heroAction = RogueEssence.Dungeon.CharAnimAction()
		heroAction.BaseFrameType = 4 --hurt
		heroAction.AnimLoc = hero.CharLoc
		heroAction.CharDir = hero.CharDir
		TASK:WaitTask(hero:StartAnim(heroAction))
		SOUND:PlayBattleSE('DUN_Hit_Neutral')
		hero.HP = hero.MaxHP / 2
		hero.Fullness = 0
		GAME:WaitFrames(10)
		TASK:WaitTask(hero:StartAnim(heroAction))
		GAME:WaitFrames(10)
		TASK:WaitTask(hero:StartAnim(heroAction))
		GAME:WaitFrames(20)
	end
	
	UI:WaitShowDialogue("I've cut your health to half and your belly is completely empty!")
	UI:WaitShowDialogue("Use the food and berries in this room to regain your strength so you may continue on!")
	SV.Tutorial.Progression = 3
end

function beginner_lesson_evt.Floor_3_Wand_Speech(owner, ownerChar, character, args)
	local chara = beginner_lesson_evt.FindLedian()
	local item = RogueEssence.Dungeon.InvItem('orb_cleanse')
	UI:SetSpeaker(chara)
	UI:WaitShowDialogue("Hwacha![pause=0] Now it is time to learn about wands and orbs!")
	UI:WaitShowDialogue("They are versatile items that can manipulate enemies or serve utility![pause=0] Useful against foes you wish not to fight.")
	UI:WaitShowDialogue("Hoiyah![pause=0] The volunteer blocking the path ahead is very strong! You cannot fight him directly!")
	UI:WaitShowDialogue("You must use a wand to move him out of the way instead![pause=0] The wand is sticky however!")
	UI:WaitShowDialogue("Sticky items cannot be used![pause=0] You must use a " .. item:GetDisplayName() .. " to clean them off!")
	UI:WaitShowDialogue("Oohcha![pause=0] Your next trial begins now!")
	SV.Tutorial.Progression = 4
end

function beginner_lesson_evt.Floor_3_HeldItem_Speech(owner, ownerChar, character, args)
	local chara = beginner_lesson_evt.FindLedian()
	local item = RogueEssence.Dungeon.InvItem('held_band_of_passage')
	UI:SetSpeaker(chara)
	UI:WaitShowDialogue("Hwacha![pause=0] Great work so far my student![pause=0] It is now time to learn about held items!")
	UI:WaitShowDialogue("Wahtah![pause=0] Items such as bands and scarves may be given to a Pokémon to gain useful effects!")
	UI:WaitShowDialogue("Some items boost stats while others prevent certain status afflications!")
	UI:WaitShowDialogue("Hoiyah![pause=0] For this trial,[pause=10] you must equip yourself with a " .. item:GetDisplayName() .. " and continue forward!")
	UI:WaitShowDialogue("You won't be allowed to continue on without equipping the band!")
	SV.Tutorial.Progression = 5
end 

function beginner_lesson_evt.Floor_3_ThrownReviver_Speech(owner, ownerChar, character, args)
	local chara = beginner_lesson_evt.FindLedian()
	UI:SetSpeaker(chara)
	local sticks = STRINGS:Format('\\uE0A1')..'[color=#FFCEFF]Sticks[color]'
	local stick = STRINGS:Format('\\uE0A1')..'[color=#FFCEFF]Stick[color]'
	local rock = STRINGS:Format('\\uE0A0')..'[color=#FFCEFF]Gravelerock[color]'
	local seed = STRINGS:Format('\\uE0A4')..'[color=#FFCEFF]Reviver Seeds[color]'
	UI:WaitShowDialogue("Hwacha![pause=0] Some items such as " .. sticks .. " and " .. rock .. " can be thrown at foes to deal damage!")
	UI:WaitShowDialogue("They are useful for damaging enemies that are far away from you![pause=0] Be sure not to throw them at teammates!")
	UI:WaitShowDialogue("Hoiyah![pause=0] I also want to tell you about " .. seed .. "!")
	UI:WaitShowDialogue("They are rare,[pause=10] but allow you to revive a teammate who has just fainted!")
	UI:WaitShowDialogue("They are invaluable on difficult journeys![pause=0] Be sure to use them wisely!")
	UI:WaitShowDialogue("Wahtah![pause=0] For this trial,[pause=10] you must throw a " .. stick .. " at the volunteer ahead!")
	UI:WaitShowDialogue("After,[pause=10] you must use " .. seed .. " to revive us from the volunteer's powerful counterattack!")
	UI:WaitShowDialogue("Oohcha![pause=0] It may be scary,[pause=10] but you must show no fear in the face of danger,[pause=10] my student!") 
	SV.Tutorial.Progression = 6
end 

function beginner_lesson_evt.Floor_4_Intro(owner, ownerChar, character, args)
	--move ledian into the actual team for the team mode section 
	if SV.Tutorial.Progression < 7 then
		p = GAME:GetPlayerGuestMember(0)
		GAME:RemovePlayerGuest(0)
		GAME:AddPlayerTeam(p)
		p:RefreshTraits()
		--todo: update this when audino adds an update
		_DUNGEON:RegenerateTurnMap()
	end
	
	local chara = beginner_lesson_evt.FindLedian()
	UI:SetSpeaker(chara)
	UI:WaitShowDialogue("Hwacha![pause=0] This floor will teach you about terrain types you will encounter in dungeons!")
	UI:WaitShowDialogue("Terrain includes obstacles such as water, lava, and walls!")
	UI:WaitShowDialogue("Hoiyah![pause=0] You must learn how terrain affects dungeon navigation to be successful adventurers!")
	SV.Tutorial.Progression = 7
end

function beginner_lesson_evt.Floor_4_Key_Speech(owner, ownerChar, character, args)
	local chara = beginner_lesson_evt.FindLedian()
	UI:SetSpeaker(chara)
	UI:WaitShowDialogue("Hwacha![pause=0] Time for this floor's trial![pause=0] I have joined your party for this one!")
	UI:WaitShowDialogue("There are keys across different types of terrains in this next room!")
	UI:WaitShowDialogue("You must use Team Mode to direct me across the terrains to pick up the keys so you may progress!")
	UI:WaitShowDialogue("Hoiyah![pause=0] Press " .. STRINGS:LocalKeyString(7)  .. " to toggle Team Mode![pause=0] I await your directions,[pause=10] my student!")
	SV.Tutorial.Progression = 8
end 

function beginner_lesson_evt.Floor_5_Intro(owner, ownerChar, character, args)
	--move Ledian back to the guest table
	if SV.Tutorial.Progression < 9 then
		p = GAME:GetPlayerPartyMember(1)
		GAME:RemovePlayerTeam(1)
		GAME:AddPlayerGuest(p)
		p:RefreshTraits()
		--todo: update this when audino adds an update
		_DUNGEON:RegenerateTurnMap()
	end
	
	local chara = beginner_lesson_evt.FindLedian()
	UI:SetSpeaker(chara)
	UI:WaitShowDialogue("Hwacha![pause=0] This is the last floor![pause=0] Your final trial lies ahead!")
	UI:WaitShowDialogue("Use the Apricorns to recruit the correct volunteer,[pause=10] and have him bust open the path to the stairs!")
	UI:WaitShowDialogue("You can do it,[pause=10] my student![pause=0] Use all that you've learned so far and you will succeed![pause=0] Hoiyah!")
	SV.Tutorial.Progression = 9
end





--be sure to check function BATTLE_SCRIPT.SenseiInteract(owner, ownerChar, context, args)
--in the event lua for ledian's interact script
	
	
	
