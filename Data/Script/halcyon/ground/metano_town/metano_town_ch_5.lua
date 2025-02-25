require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_town_ch_5 = {}

function metano_town_ch_5.SetupGround()
	GROUND:Hide('Swap_Owner')
	GROUND:Hide('Swap')
	
	local growlithe = CH('Growlithe')
	
	if not SV.Chapter5.TalkedToSnubbull then
		local snubbull =
			CharacterEssentials.MakeCharactersFromList({
				{'Snubbull', 1056, 864, Direction.Up}
			})
	end

	--Move Growlithe from his desk. If you saw Almotz say goodbye to his family, then he'll be at storage with Hyko.
	if SV.Chapter5.SawZigzagoonFamilyCutscene then
		local zigzagoon = 
			CharacterEssentials.MakeCharactersFromList({
				{'Zigzagoon', 1236, 888, Direction.UpLeft}
			})
		
		GROUND:TeleportTo(growlithe, 1260, 912, Direction.UpLeft)
	else
		GROUND:TeleportTo(growlithe, 1216, 916, Direction.DownLeft)
		AI:SetCharacterAI(growlithe, "halcyon.ai.ground_default", RogueElements.Loc(1200, 900), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
	end


	
	local cranidos, mareep, gloom, nidorina, electrike, audino, numel, wooper_girl, wooper_boy,
		  meditite, luxray, machamp, oddish, azumarill, metapod, silcoon = 
		CharacterEssentials.MakeCharactersFromList({
			{'Cranidos', 1180, 1304, Direction.UpLeft},
			{'Mareep', 1204, 1304, Direction.Left},
			{'Gloom', 512, 184, Direction.DownRight},
			{'Nidorina', 536, 208, Direction.UpLeft},
			{'Electrike', 256, 944, Direction.DownRight},
			{'Audino', 1096, 1032, Direction.DownRight},
			{'Numel', 184, 384, Direction.DownLeft},
			{'Wooper_Girl', 328, 1000, Direction.DownLeft},
			{'Wooper_Boy', 328, 1040, Direction.UpLeft},
			{'Meditite', 296, 1020, Direction.Right},
			{'Luxray', 304, 656, Direction.UpLeft},
			{'Machamp', 464, 464, Direction.Left},
			{'Oddish', 472, 648, Direction.Up},
			{'Azumarill', 888, 712, Direction.Down},
			{'Metapod', 'Cafe_Seat_1'},
			{'Silcoon', 'Cafe_Seat_2'}
		})
	
	AI:SetCharacterAI(luxray, "halcyon.ai.ground_default", RogueElements.Loc(luxray.Position.X-16, luxray.Position.Y-16), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
	AI:SetCharacterAI(machamp, "halcyon.ai.ground_default", RogueElements.Loc(machamp.Position.X-16, machamp.Position.Y-16), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)


	
	GAME:FadeIn(20)
	
end


--She is getting supplies from Kec. She goes inside to the storage room after you talk
--to her to get her out of the way
function metano_town_ch_5.Snubbull_Action(chara, activator)

end 

function metano_town_ch_5.Mareep_Action(chara, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GeneralFunctions.StartConversation(chara, "Oh,[pause=10] " .. hero:GetDisplayName() .. " and " .. partner:GetDisplayName() .. "![pause=0] Ca-a-a-an you believe the expedition's finally here?", "Happy")
	UI:SetSpeakerEmotion("Joyous")
	UI:WaitShowDialogue("It's gonna be a bla-a-a-ast![pause=0] We're gonna all have so much fun together!")
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("But we gotta be prepa-a-a-ared![pause=0] The expedition will be tough,[pause=10] so stock up while you ca-a-a-an!")
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_5.Cranidos_Action(chara, activator)
	local item = RogueEssence.Dungeon.InvItem("machine_recall_box")
	GeneralFunctions.StartConversation(chara, "You greenhorns better get all your moves in order before we leave.")
	UI:WaitShowDialogue("The only way you'll be able to remember old moves on the road is a " .. item:GetDisplayName() .. ",[pause=10] and those are a pretty rare find.")
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("I don't wanna hear your bellyaching later because you're too lazy to take care of it now!")
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_5.Audino_Action(chara, activator)

end

function metano_town_ch_5.Growlithe_Action(chara, activator)

end

function metano_town_ch_5.Zigzagoon_Action(chara, activator)

end

function metano_town_ch_5.Mawile_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Word around town is that the guild is leaving on a big expedition today.")
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue("How exciting![pause=0] I'm sure you two are gonna have a lot of fun exploring all sorts of different places!")
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Have a safe trip![pause=0] Be sure to come back in one piece so you can tell me all about it!")
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_5.Electrike_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, CharacterEssentials.GetCharacterName("Wooper_Boy") .. " and " .. CharacterEssentials.GetCharacterName("Wooper_Girl") .. " are still playing with that other Pokémon,[pause=10] huh...?", "Sad")
	UI:WaitShowDialogue(".........")
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("H-heh.[pause=0] Just more t-time I get to spend without them annoying me.")
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("...Alone.")
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_5.Azumarill_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, chara:GetDisplayName() .. " hear that guild is going away for a while.")
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Normally,[pause=10] " .. chara:GetDisplayName() .. " worries about bad Pokémon coming and hurting " .. chara:GetDisplayName() .. " without guild around...")
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("But " .. chara:GetDisplayName() .. " trained really hard in dojo![pause=0] " .. chara:GetDisplayName() .. " not afraid of outlaws anymore!")
	UI:WaitShowDialogue(chara:GetDisplayName() .. " will swim in the water in peace now that " .. chara:GetDisplayName() .. " so strong!")
	GeneralFunctions.EndConversation(chara)
end

--GeneralFunctions.StartConversation(chara, chara:GetDisplayName() .. " hear that guild is going on big expedition.")
--UI:SetSpeakerEmotion("Worried")
--UI:WaitShowDialogue(chara:GetDisplayName() .. " not understand need for big trip though...")
--UI:WaitShowDialogue("Best water for swimming is right here in town![pause=0] Why go anywhere else?")
--GeneralFunctions.EndConversation(chara)

--[[
--free domi blends!
function metano_town_ch_5.Doduo_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Did you hear?[pause=0] " .. CharacterEssentials.GetCharacterName("Shuckle") .. "'s giving away free drinks today!")
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("They're...[pause=30] uh...[pause=30] not very good.")
	GeneralFunctions.EndConversation(chara)
end 

function metano_town_ch_5.Bagon_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "This drink " .. CharacterEssentials.GetCharacterName("Shuckle") .. " doesn't taste very good...", "Sad")
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("...That said,[pause=10] I do feel good after drinking it.[pause=0] It's like I just woke up from a good night's sleep!")
	GeneralFunctions.EndConversation(chara)
end 
]]--

function metano_town_ch_5.Metapod_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, CharacterEssentials.GetCharacterName("Silcoon") .. " and I got a free drink from the café today.")
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("...But we're struggling to enjoy it since we have no good way to hold the bottle.")
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_5.Silcoon_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Did you hear?[pause=0] " .. CharacterEssentials.GetCharacterName("Shuckle") .. "'s giving away free drinks today!")
	UI:WaitShowDialogue("You should head on into the café and grab one while you can!")
	GeneralFunctions.EndConversation(chara)
end


