require 'common'
CharacterEssentials = {}

local characters = {
		--the guild
		Tropius = {
			species = 357,
			nickname = 'Penticus',
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
			nickname = 'Almotz',
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
			nickname = 'Shuca',
			instance = 'Mareep',
			gender = Gender.Female,
			form = 0,
			skin = 0
		},
		
		Cranidos = {
			species = 408,
			nickname = 'Ganlon',
			instance = 'Cranidos',
			gender = Gender.Male,
			form = 0,
			skin = 0	
		},
		
		Snubbull = {
			species = 209,
			nickname = 'Coco',
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
		
		
	--Dojo characters
		Ledian = {
			species = 166,
			nickname = 'Lotus',
			instance = 'Ledian',
			gender = Gender.Female,
			form = 0,
			skin = 0
		},
	
		--can refer to Lotus as either Ledian or Sensei to grab her
		Sensei = {
			species = 166,
			nickname = 'Lotus',
			instance = 'Sensei',
			gender = Gender.Female,
			form = 0,
			skin = 0
		},
		
		Gible = {
			species = 443,
			nickname = 'Totor',
			instance = 'Gible',
			gender = Gender.Male,
			form = 0,
			skin = 0
		},
		
		
	--Team Style
		Luxio = {
			species = 404,
			nickname = 'Suilux',
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
		
		
		
	--Team Round (names are one letter off words that mean fat or round)
		Spheal = { 
			species = 363,
			nickname = 'Chumby',
			instance = 'Spheal',
			gender = Gender.Male,
			form = 0,
			skin = 0
			},
		Marill = { 
			species = 183,
			nickname = 'Rolund',
			instance = 'Marill',
			gender = Gender.Male,
			form = 0,
			skin = 0	
		},
		Jigglypuff = { 
			species = 39,
			nickname = 'Plum',
			instance = 'Jigglypuff',
			gender = Gender.Female,
			form = 0,
			skin = 0
		},
		
	--Team Starlight
		Cleffa = {
			species = 173,
			nickname = 'Primonna',
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
		},
		
		
	--Team Rivals
		Zangoose = {
			species = 335,
			nickname = 'Devian',
			instance = 'Zangoose',
			gender = Gender.Male,
			form = 0,
			skin = 0
		},	
		
		Seviper = {
			species = 336,
			nickname = 'Zular',
			instance = 'Seviper',
			gender = Gender.Male,
			form = 0,
			skin = 0
		},
		
	--Team Cadence (their names are corruptions of types of dances)
		Spinda = {
			species = 327,
			nickname = 'Ceili',
			instance = 'Spinda',
			gender = Gender.Female,
			form = 0,
			skin = 0
		},
		
		Ludicolo = {
			species = 272,
			nickname = 'Mirich',
			instance = 'Ludicolo',
			gender = Gender.Male,
			form = 0,
			skin = 0
		},
		
		Roselia = {
			species = 315,
			nickname = 'Bequa',
			instance = 'Roselia',
			gender = Gender.Female,
			form = 0,
			skin = 0
		},
		
	--Team Flight
		Doduo = {
			species = 84,
			nickname = 'Rok',
			instance = 'Doduo',
			gender = Gender.Male,
			form = 0,
			skin = 0
		},
	
		Bagon = {
			species = 371,
			nickname = 'Tyra',
			instance = 'Bagon',
			gender = Gender.Female,
			form = 0,
			skin = 0
		},
	
		
	--Vendor/Shop NPCs
		Kangaskhan = {
			species = 115,
			nickname = 'Auntie Kanga',
			instance = 'Kangaskhan',
			gender = Gender.Female,
			form = 0,
			skin = 0
		},
		
		Murkrow = {
			species = 198,
			nickname = 'Varko',
			instance = 'Murkrow',
			gender = Gender.Male,
			form = 0,
			skin = 0
		},
	
		Slowpoke = {
			species = 79,
			nickname = 'Ezalor',
			instance = 'Slowpoke',
			gender = Gender.Male,
			form = 0,
			skin = 0
		},
		
		Ambipom = {
			species = 424,
			nickname = 'Swigoi',
			instance = 'Ambipom',
			gender = Gender.Male,
			form = 0,
			skin = 0
		},
		
		Sneasel = {
			species = 215,
			nickname = 'Katrine',
			instance = 'Sneasel',
			gender = Gender.Female,
			form = 0,
			skin = 0
		},
		
		Kecleon = {
			species = 352,
			nickname = 'Lars',
			instance = 'Kecleon',
			gender = Gender.Male,
			form = 0,
			skin = 0
		},
		
		Kecleon_Purple = {
			species = 352,
			nickname = 'Zigs',
			instance = 'Kecleon_Purple',
			gender = Gender.Male,
			form = 1,
			skin = 0
		},
		
		Chatot = {
			species = 441,
			nickname = 'Falo',
			instance = 'Chatot',
			gender = Gender.Male,
			form = 0,
			skin = 0
		},
	
		Shuckle = {
			species = 213,
			nickname = 'Dion',
			instance = 'Shuckle',
			gender = Gender.Male,
			form = 0,
			skin = 0
		},
		
	
	
	--Town NPCs - Families
		Furret = {
			species = 162,
			nickname = 'Jak',
			instance = 'Furret',
			gender = Gender.Male,
			form = 0,
			skin = 0
		},
		
		Linoone = {
			species = 264, 
			nickname = 'Lebiure',
			instance = 'Linoone',
			gender = Gender.Female,
			form = 0,
			skin = 0
		},
	
		Sentret = {
			species = 161, 
			nickname = 'Timmi',
			instance = 'Sentret',
			gender = Gender.Male,
			form = 0,
			skin = 0
		},
	
		
		
		Luxray = {
			species = 405,
			nickname = 'Rulux',
			instance = 'Luxray',
			gender = Gender.Male,
			form = 0,
			skin = 0
		},
	
		Manectric = {
			species = 310,
			nickname = 'Camentra',
			instance = 'Manectric',
			gender = Gender.Female,
			form = 0,
			skin = 0
		},
		
		Electrike = {
			species = 309,
			nickname = 'Trilec',
			instance = 'Electrike',
			gender = Gender.Male,
			form = 0,
			skin = 0
		},
		
		
		
		Floatzel = {
			species = 419,
			nickname = 'Tweed',
			instance = 'Floatzel',
			gender = Gender.Male,
			form = 0,
			skin = 0
		},
		
		Quagsire = {
			species = 195,
			nickname = 'Maris',
			instance = 'Quagsire',
			gender = Gender.Female,
			form = 0,
			skin = 0
		},
		
		Wooper_Girl = {
			species = 194,
			nickname = 'Dee',
			instance = 'Wooper_Girl',
			gender = Gender.Female,
			form = 0,
			skin = 0
		},
	
		Wooper_Boy = {
			species = 194,
			nickname = 'Dun',
			instance = 'Wooper_Boy',
			gender = Gender.Male,
			form = 0,
			skin = 0
		},
		
		
		
		Camerupt = {
			species = 323,
			nickname = 'Dotra',
			instance = 'Camerupt',
			gender = Gender.Female,
			form = 0,
			skin = 0
		},
		
		Numel = {
			species = 322,
			nickname = 'Nubbor',
			instance = 'Numel',
			gender = Gender.Male,
			form = 0,
			skin = 0
		},
		
		
		
		Machamp = {
			species = 68,
			nickname = 'Savran',
			instance = 'Machamp',
			gender = Gender.Male,
			form = 0,
			skin = 0
		},
			
		Medicham = {
			species = 308,
			nickname = 'Nama',
			instance = 'Medicham',
			gender = Gender.Female,
			form = 0,
			skin = 0
		},
		
		Meditite = {
			species = 307,
			nickname = 'Stei',
			instance = 'Meditite',
			gender = Gender.Female,
			form = 0,
			skin = 0
		},
		
		
		--begonia flower 
		Vileplume = {
			species = 45,
			nickname = 'Bogen',
			instance = 'Vileplume',
			gender = Gender.Male,
			form = 0,
			skin = 0
		},
		
		--Chrysanthemum
		Bellossom = {
			species = 182,
			nickname = 'Chrysi',
			instance = 'Bellossom',
			gender = Gender.Female,
			form = 0,
			skin = 0
		},
		
		--Lavender
		Gloom = {
			species = 44, 
			nickname = 'Lavena',
			instance = 'Gloom',
			gender = Gender.Female,
			form = 0,
			skin = 0
		},
		
		--White Lilac
		Oddish = {
			species = 43,
			nickname = 'Calil',
			instance = 'Oddish',
			gender = Gender.Female,
			form = 0,
			skin = 0
		},
		
		
		
		Nidoking = {
			species = 34,
			nickname = 'Pawpa',
			instance = 'Nidoking',
			gender = Gender.Male,
			form = 0,
			skin = 0
		},
		
		Nidoqueen = {
			species = 31,
			nickname = 'Monna',
			instance = 'Nidoqueen',
			gender = Gender.Female,
			form = 0,
			skin = 0
		},
		
		Nidorina = {
			species = 30,
			nickname = 'Dottir',
			instance = 'Nidorina',
			gender = Gender.Female,
			form = 0,
			skin = 0
		},
		
		Nidoran_M = {
			species = 32,
			nickname = 'Junior',
			instance = 'Nidoran_M',
			gender = Gender.Male,
			form = 0,
			skin = 0
		},
	
	
	--Town NPCs - Other
		Sunflora = {
			species = 192,
			nickname = 'Ciel',
			instance = 'Sunflora',
			gender = Gender.Female,
			form = 0,
			skin = 0
		},
		
		Azumarill = {
			species = 184,
			nickname = 'Loaf',
			instance = 'Azumarill',
			gender = Gender.Male,
			form = 0,
			skin = 0
		},
		
		Mawile = {
			species = 303,
			nickname = 'Bria',
			instance = 'Mawile',
			gender = Gender.Female,
			form = 0,
			skin = 0
		},
	
		Relicanth = {
			species = 369,
			nickname = 'Erleuchtet',
			instance = 'Relicanth',
			gender = Gender.Male,
			form = 0,
			skin = 0
		},
		
		Bisharp = {
			species = 625,
			nickname = 'Zhayn',
			instance = 'Bisharp',
			gender = Gender.Male,
			form = 0,
			skin = 0
		},
		
		
		Gulpin = {
			species = 316,
			nickname = 'Boosmu',
			instance = 'Gulpin',
			gender = Gender.Male,
			form = 0,
			skin = 0
		},
		
		Lickitung = {
			species = 108,
			nickname = 'Urgil',
			instance = 'Lickitung',
			gender = Gender.Male,
			form = 0,
			skin = 0
		},
		
		--Other Plot Relevant NPCs
		--
		Sandile = {
			species = 551,
			nickname = 'Thwait',
			instance = 'Sandile',
			gender = Gender.Male,
			form = 0,
			skin = 0
		},
		
		--Inn Passersby
		Snorlax = {
			species = 143,
			nickname = 'Passerby',
			instance = 'Passerby_1',
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
