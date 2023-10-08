require 'common'
require 'PartnerEssentials'
require 'GeneralFunctions'
require 'CharacterEssentials'

metano_cave_ch_4 = {}

function metano_cave_ch_4.SetupGround()

	if SV.Chapter4.FinishedGrove then
		local oddish = 	
			CharacterEssentials.MakeCharactersFromList({
				{'Oddish', 272, 136, Direction.Right}
			})
		
		AI:SetCharacterAI(oddish, "ai.ground_talking", false, 60, 60, 0, false, 'Default', {CH('Sunflora')})
		
		--She is trying to ignore oddish
		GROUND:EntTurn(CH('Sunflora'), Direction.Down)
	end 
	
	GAME:FadeIn(20)
end

function metano_cave_ch_4.Sunflora_Action(chara, activator)
	if not SV.Chapter4.FinishedGrove then
		GeneralFunctions.StartConversation(chara, "...The guild is mounting an expedition soon,[pause=10] huh?", "Worried", true, false)
		UI:WaitShowDialogue("...It's been so long since...")
		UI:WaitShowDialogue(".........")
		UI:WaitShowDialogue("...Don't mind me.[pause=0] Enjoy yourselves on the expedition.")
	else
		GeneralFunctions.StartConversation(chara, "...Could you get this child out of here?", "Worried", true, false)
		UI:SetSpeakerEmotion("Pain")
		UI:WaitShowDialogue("I'd prefer to be alone,[pause=10] but she doesn't seem to understand...")
	end
	GeneralFunctions.EndConversation(chara, false)
end 

function metano_cave_ch_4.Oddish_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Hi weird lady![pause=0] I hope you're doing OK in here![pause=0]\nI brought you some flowers to cheer you up!", "Happy", false)
	UI:WaitShowDialogue("You should come outside and see my mom's garden sometime!")
	UI:WaitShowDialogue("There's all kinds of pretty flowers I think would make you feel happy there!")
	GeneralFunctions.EndConversation(chara)
end