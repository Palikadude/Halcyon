require 'common'

beginner_lesson = {}

--ledian is the 3rd party member
function beginner_lesson.FindLedian()
	return GAME:GetPlayerGuestMember(0)
end


--owner is the owner of the effect. For example, if the code is for lefties recovery, then the owner might be say, aqua ring, the item lefties, or the ability regenerator (if it worked like that)
--ownerChar is the character that has the particular status/item/ability/whatever. Whoever has the lefties.
--character is the character with the item/ability/status. Whoever has the lefties, they are the target of the effect
--args is a list of arguments passed to the script (see the arg table in the SingleCharScriptEvent effect)
function beginner_lesson.Floor_1_Intro(owner, ownerChar, character, args)
	SV.Tutorial.LastSpeech = "Floor_1_Intro"
	--progression flag is the number of speeches given by ledian. the functions in this document follow the order they're given in the dungeon
	if SV.Tutorial.Progression < 1 then
		local chara = beginner_lesson.FindLedian()
		UI:SetSpeaker(chara)
		UI:WaitShowDialogue("Hwacha![pause=0] Welcome to the dojo's learning area![pause=0] It is time for your first lesson!")
		UI:WaitShowDialogue("Hoiyah![pause=0] On this floor you will learn much about the basics of dungeon crawling!")
		UI:WaitShowDialogue("Volunteers ahead will either help demonstrate learning topics,[pause=10] or may pose as obstacles to conquer!")
		UI:WaitShowDialogue("Be sure to read the signs left by my star pupil![pause=0] They contain vital knowledge essential to dungeon crawling!")
		UI:WaitShowDialogue("You can speak to me at any time to reset the floor if you find yourself stuck![pause=0] Don't be shy,[pause=10] my students!")
		UI:WaitShowDialogue("Onwards,[pause=10] there is much learning to do,[pause=10] kya!")
		SV.Tutorial.Progression = 1
	end
end

function beginner_lesson.Floor_2_Intro(owner, ownerChar, character, args)
	SV.Tutorial.LastSpeech = "Floor_2_Intro"
	if SV.Tutorial.Progression < 2 then 
		local chara = beginner_lesson.FindLedian()
		UI:SetSpeaker(chara)
		UI:WaitShowDialogue("Hwacha![pause=0] On this floor you will learn about different status effects you will encounter in your journeys!")
		UI:WaitShowDialogue("The volunteers ahead will demonstrate moves that apply status moves![pause=0] Use an attack on them and they'll use their move!")
		SV.Tutorial.Progression = 2
	end
end


function beginner_lesson.Floor_3_Intro(owner, ownerChar, character, args)
	SV.Tutorial.LastSpeech = "Floor_3_Intro"
	if SV.Tutorial.Progression < 4 then --set hunger and belly to 0 even if 3rd floor speech given so player can't cheese trial
		--set player/partner hp to half, belly to 0
		local hero = GAME:GetPlayerPartyMember(0)
		local partner = GAME:GetPlayerPartyMember(1)
		hero.HP = hero.MaxHP / 2
		hero.Fullness = 0
		partner.HP = partner.MaxHP / 2
		partner.Fullness = 0
	end
	
	if SV.Tutorial.Progression < 3 then 
		local chara = beginner_lesson.FindLedian()
		UI:SetSpeaker(chara)
		UI:WaitShowDialogue("Hwacha![pause=0] This floor will teach you about wise and proper item use!")
		UI:WaitShowDialogue("Wahtah![pause=0] Your first trial begins here![pause=0] You will need to apply what you learn to make it through the rest of the lesson!")
		UI:WaitShowDialogue("Your health has been cut to half and your belly is completely empty!")
		UI:WaitShowDialogue("Use the food and berries in this room to regain your strength so you may continue on!")
		SV.Tutorial.Progression = 3
	end
end

function beginner_lesson.Floor_3_Wand_Speech(owner, ownerChar, character, args)
	SV.Tutorial.LastSpeech = 'Floor_3_Wand_Speech'
	if SV.Tutorial.Progression < 4 then 
		local chara = beginner_lesson.FindLedian()
		UI:SetSpeaker(chara)
		UI:WaitShowDialogue("Use the wands")
		SV.Tutorial.Progression = 4
	end
end

function beginner_lesson.Floor_3_HeldItem_Speech(owner, ownerChar, character, args)
	SV.Tutorial.LastSpeech = 'Floor_3_HeldItem_Speech'
	if SV.Tutorial.Progression < 5 then
		local chara = beginner_lesson.FindLedian()
		UI:SetSpeaker(chara)
		UI:WaitShowDialogue("Use the held item")
		SV.Tutorial.Progression = 5
	end
end 

function beginner_lesson.Floor_3_ThrownReviver_Speech(owner, ownerChar, character, args)
	SV.Tutorial.LastSpeech = 'Floor_3_ThrownReviver_Speech'
	if SV.Tutorial.Progression < 6 then
		local chara = beginner_lesson.FindLedian()
		UI:SetSpeaker(chara)
		UI:WaitShowDialogue("Use the rev seeds")
		SV.Tutorial.Progression = 6
	end
end 

function beginner_lesson.Floor_4_Intro(owner, ownerChar, character, args)
	SV.Tutorial.LastSpeech = "Floor_4_Intro"
	if SV.Tutorial.Progression < 7 then 
		local chara = beginner_lesson.FindLedian()
		UI:SetSpeaker(chara)
		UI:WaitShowDialogue("Hwacha![pause=0] This floor will teach you about terrain types you will encounter in dungeons!")
		SV.Tutorial.Progression = 7
	end
end

function beginner_lesson.Floor_4_Key_Speech(owner, ownerChar, character, args)
	SV.Tutorial.LastSpeech = 'Floor_4_Key_Speech'
	if SV.Tutorial.Progression < 8 then
		local chara = beginner_lesson.FindLedian()
		UI:SetSpeaker(chara)
		UI:WaitShowDialogue("Grab the keys using the mobile scarf")
		SV.Tutorial.Progression = 8
	end
end 

function beginner_lesson.Floor_5_Intro(owner, ownerChar, character, args)
	SV.Tutorial.LastSpeech = "Floor_5_Intro"
	if SV.Tutorial.Progression < 9 then 
		local chara = beginner_lesson.FindLedian()
		UI:SetSpeaker(chara)
		UI:WaitShowDialogue("Hwacha![pause=0] This is the last floor![pause=0] Your final trial lies ahead!")
		UI:WaitShowDialogue("Use the apricorns to recruit the correct volunteer,[pause=10] and have him bust open the path to the stairs!")
		UI:WaitShowDialogue("You can do it,[pause=10] my students![pause=0] Use all that you've learned so far and you will succeed![pause=0] Hoiyah!")
		SV.Tutorial.Progression = 9
	end
end

--be sure to check function BATTLE_SCRIPT.SenseiInteract(owner, ownerChar, context, args)
--in the event lua for ledian's interact script
	
	
	
