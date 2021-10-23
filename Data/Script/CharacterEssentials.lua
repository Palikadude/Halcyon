require 'common'
CharacterEssentials = {}

local characters = {
		--the guild
		Tropius = {
			species = 357,
			nickname = 'Pernicus',
			instance = 'Tropius',
			gender = Gender.Male,
			form = 0,
			skin = 0
		},
		Noctowl = {
			species = 164, 
			nickname = 'Phileas',
			instance = 'Noctowl',
			gender = Gender.Male,
			form = 0,
			skin = 0
		},
		Zigzagoon = {
			species = 263, 
			nickname = '???',
			instance = 'Zigzagoon',
			gender = Gender.Male,
			form = 0, 
			skin = 0
		},
		Growlithe = {
			species = 58,
			nickname = 'Hyko',
			instance = 'Growlithe',
			gender = Gender.Male,
			form = 0,
			skin = 0
		},
		Mareep = {
			species = 179,
			nickname = '???',
			instance = 'Mareep',
			gender = Gender.Female,
			form = 0,
			skin = 0
		},
		
		Cranidos = {
			species = 408,
			nickname = '???',
			instance = 'Cranidos',
			gender = Gender.Male,
			form = 0,
			skin = 0	
		},
		
		Snubbull = {
			species = 209,
			nickname = '???',
			instance = 'Snubbull',
			gender = Gender.Female,
			form = 0,
			skin = 0
		},
		Audino = {
			species = 531,
			nickname = 'Rin',
			instance = 'Audino',
			gender = Gender.Female,
			form = 0,
			skin = 0
		},
		
		Breloom = {
			species = 286,
			nickname = 'Kino',
			instance = 'Breloom',
			gender = Gender.Male,
			form = 0,
			skin = 0
		},
		
		Girafarig = {
			species = 203,
			nickname = 'Reinier',
			instance = 'Girafarig',
			gender = Gender.Male,
			form = 0,
			skin = 0
		},
		
		Tail = {--girafarig's tail
			species = 203,
			nickname = 'Crum',
			instance = 'Tail',
			gender = Gender.Male,
			form = 0,
			skin = 0
		},
		
		
		
	--Team Style
		Luxio = {
			species = 404,
			nickname = '???',
			instance = 'Luxio',
			gender = Gender.Male,
			form = 0,
			skin = 0
			},
		Glameow = {
			species = 431,
			nickname = 'Priscilla',
			instance = 'Glameow',
			gender = Gender.Female,
			form = 0,
			skin = 0
		},
		Cacnea = {
			species = 331,
			nickname = 'Lummsy',
			instance = 'Cacnea',
			gender = Gender.Male,
			form = 0,
			skin = 0
		},
		
		
		
	--Team Round
		Spheal = { 
			species = 363,
			nickname = '???',
			instance = 'Spheal',
			gender = Gender.Male,
			form = 0,
			skin = 0
			},
		Marill = { 
			species = 183,
			nickname = '???',
			instance = 'Marill',
			gender = Gender.Female,
			form = 0,
			skin = 0	
		},
		Jigglypuff = { 
			species = 39,
			nickname = '???',
			instance = 'Jigglypuff',
			gender = Gender.Female,
			form = 0,
			skin = 0
		},
		
	--Team ???
		Cleffa = {
			species = 173,
			nickname = '???',
			instance = 'Cleffa',
			gender = Gender.Female,
			form = 0,
			skin = 0
		},		
		Aggron = {
			species = 306,
			nickname = 'Rubble',
			instance = 'Aggron',
			gender = Gender.Male,
			form = 0,
			skin = 0
		}
	}


--creates character from stored data and returns them
function CharacterEssentials.MakeCharactersFromList(list, retTable)
	retTable = retTable or false--return a table of chars rather than multiple chars if this is true
	local charTable = {}
	local chara = 0
	local length = 0
	for i = 1, #list, 1 do
		local name = list[i][1]
		length = #list[i]
		if length == 1 then--this case is so we can reference characters that aren't on the map. Put them at 0, 0 and hide them
			local monster = RogueEssence.Dungeon.MonsterID(characters[name].species,
															characters[name].form,
															characters[name].skin,
															characters[name].gender)
			chara = RogueEssence.Ground.GroundChar(monster, RogueElements.Loc(0, 0), Direction.Down, characters[name].nickname, characters[name].instance)
			chara:ReloadEvents()
			GAME:GetCurrentGround():AddTempChar(chara)
			GROUND:Hide(chara.EntName)
			
		elseif length == 2 then --may be inefficient to do a length lookup so often...
			local marker = MRKR(list[i][2])
			local monster = RogueEssence.Dungeon.MonsterID(characters[name].species,
															characters[name].form,
															characters[name].skin,
															characters[name].gender)
			chara = RogueEssence.Ground.GroundChar(monster, RogueElements.Loc(marker.Position.X, marker.Position.Y), marker.Direction, characters[name].nickname, characters[name].instance)
			chara:ReloadEvents()
			GAME:GetCurrentGround():AddTempChar(chara)
		else
			local x = list[i][2]
			local y = list[i][3]
			local direction = list[i][4]
			local monster = RogueEssence.Dungeon.MonsterID(characters[name].species,
															characters[name].form,
															characters[name].skin,
															characters[name].gender)
			chara = RogueEssence.Ground.GroundChar(monster, RogueElements.Loc(x, y), direction, characters[name].nickname, characters[name].instance)
			chara:ReloadEvents()
			GAME:GetCurrentGround():AddTempChar(chara)

		end
		chara:OnMapInit()
		local result = RogueEssence.Script.TriggerResult()
		TASK:WaitTask(chara:RunEvent(RogueEssence.Script.LuaEngine.EEntLuaEventTypes.EntSpawned, result, chara))
		charTable[i] = chara
	end
	if retTable then 
		return charTable 
	else
		return table.unpack(charTable)
	end
end




--get a character's name without having to create them
function CharacterEssentials.GetCharacterName(name)
	return "[color=#00FFFF]" .. characters[name].nickname .. "[color]"
end 



--[[
function CharacterEssentials.MakeCharacterAtMarker(charName, markerName)
	local marker = MRKR(markerName)
	local p = CharacterEssentials.GetCharacter(charName, marker.Position.X, marker.Position.Y, marker.Direction)
	GAME:GetCurrentGround():AddTempChar(p)
	return chara
end
--get a character whose data is stored in this script
--can give either species name (if they're the only one) or actual name
function CharacterEssentials.GetCharacter(name, x, y, direction)
	
	if x == nil then x = 0 end 
	if y == nil then y = 0 end
	--if dir == nil then dir = Direction.Down end--down is a good default direction
	
	local species = 0
	local nickname = "default"
	local instance = "default"
	local gender = Gender.Genderless
	local form = 0--formes 
	local skin = 0--shiny?
	
	
	
	species = characters[name].species
	nickname = characters[name].nickname
	instance = characters[name].instance
	gender = characters[name].gender
	form = characters[name].form
	skin = characters[name].skin
	local monster = RogueEssence.Dungeon.MonsterID(species, form, skin, gender)
	local chara = RogueEssence.Ground.GroundChar(monster, RogueElements.Loc(x, y), direction, nickname, instance)
	return chara
--TASK:BranchCoroutine(function() CharacterEssentials.MakeCharacter('Spheal', 'Generic_Spawn_1') end)
end
]]--
