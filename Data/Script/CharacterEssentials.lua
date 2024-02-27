require 'common'

local function FirstToUpper(str)
	return (str:gsub("^%l", string.upper))
end

local function AdjustNickname(name, characters)
	local nickname = characters[name].nickname
	if not CONFIG.UseNicknames then

		-- Skip Crum
		if nickname == "Crum" then
			return nickname
		end

		local species = characters[name].species
		if species == "nidoran_m" then -- Format Nidoran
			nickname = "Nidoran"
		elseif species == "farfetchd" then -- Format Farfetch'd
			nickname = "Farfetch'd"
		else
			nickname = FirstToUpper(species)
		end
	end
	return nickname
end

CharacterEssentials = {}

local characters = {
		--the guild
		Tropius = {
			species = "tropius",
			nickname = 'Penticus',
			instance = 'Tropius',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		Noctowl = {
			species = "noctowl", 
			nickname = 'Phileas',
			instance = 'Noctowl',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		Zigzagoon = {
			species = "zigzagoon", 
			nickname = 'Almotz',
			instance = 'Zigzagoon',
			gender = Gender.Male,
			form = 0, 
			skin = "normal"
		},
		Growlithe = {
			species = "growlithe",
			nickname = 'Hyko',
			instance = 'Growlithe',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		Mareep = {
			species = "mareep",
			nickname = 'Shuca',
			instance = 'Mareep',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
		Cranidos = {
			species = "cranidos",
			nickname = 'Ganlon',
			instance = 'Cranidos',
			gender = Gender.Male,
			form = 0,
			skin = "normal"	
		},
		
		Snubbull = {
			species = "snubbull",
			nickname = 'Coco',
			instance = 'Snubbull',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		Audino = {
			species = "audino",
			nickname = 'Rin',
			instance = 'Audino',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
		Breloom = {
			species = "breloom",
			nickname = 'Kino',
			instance = 'Breloom',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		Girafarig = {
			species = "girafarig",
			nickname = 'Reinier',
			instance = 'Girafarig',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		Tail = {--girafarig's tail
			species = "girafarig",
			nickname = 'Crum',
			instance = 'Tail',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		
	--Dojo characters
		Ledian = {
			species = "ledian",
			nickname = 'Lotus',
			instance = 'Ledian',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
	
		--can refer to Lotus as either Ledian or Sensei to grab her
		Sensei = {
			species = "ledian",
			nickname = 'Lotus',
			instance = 'Sensei',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
		Gible = {
			species = "gible",
			nickname = 'Totor',
			instance = 'Gible',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		
	--Team Style
		Luxio = {
			species = "luxio",
			nickname = 'Suilux',
			instance = 'Luxio',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
			},
		Glameow = {
			species = "glameow",
			nickname = 'Priscilla',
			instance = 'Glameow',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		Cacnea = {
			species = "cacnea",
			nickname = 'Lummsy',
			instance = 'Cacnea',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		
		
	--Team Round (names are one letter off words that mean fat or round)
		Spheal = { 
			species = "spheal",
			nickname = 'Chumby',
			instance = 'Spheal',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
			},
		Marill = { 
			species = "marill",
			nickname = 'Rolund',
			instance = 'Marill',
			gender = Gender.Male,
			form = 0,
			skin = "normal"	
		},
		Jigglypuff = { 
			species = "jigglypuff",
			nickname = 'Plum',
			instance = 'Jigglypuff',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
	--Team Starlight
		Cleffa = {
			species = "cleffa",
			nickname = 'Primonna',
			instance = 'Cleffa',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},		
		Aggron = {
			species = "aggron",
			nickname = 'Rubble',
			instance = 'Aggron',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		
	--Team Rivals
		Zangoose = {
			species = "zangoose",
			nickname = 'Devian',
			instance = 'Zangoose',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},	
		
		Seviper = {
			species = "seviper",
			nickname = 'Zular',
			instance = 'Seviper',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
	--Team Cadence (their names are corruptions of types of dances)
		Spinda = {
			species = "spinda",
			nickname = 'Ceili',
			instance = 'Spinda',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
		Ludicolo = {
			species = "ludicolo",
			nickname = 'Mirich',
			instance = 'Ludicolo',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		Roselia = {
			species = "roselia",
			nickname = 'Bequa',
			instance = 'Roselia',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
	--Team Flight
		Doduo = {
			species = "doduo",
			nickname = 'Rok',
			instance = 'Doduo',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
	
		Bagon = {
			species = "bagon",
			nickname = 'Tyra',
			instance = 'Bagon',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
	--Team Flutter
		Silcoon = {
			species = 'silcoon',
			nickname = 'Chressa',
			instance = 'Silcoon',
			gender = Gender.Female,
			form = 0,
			skin = 'normal'
		},
		
		Metapod = {
			species = 'metapod',
			nickname = 'Solis',
			instance = 'Metapod',
			gender = Gender.Male,
			form = 0,
			skin = 'normal'
		},
		
	--Vendor/Shop NPCs
		Kangaskhan = {
			species = "kangaskhan",
			nickname = 'Auntie Kanga',
			instance = 'Kangaskhan',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
		Murkrow = {
			species = "murkrow",
			nickname = 'Varko',
			instance = 'Murkrow',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
	
		Slowpoke = {
			species = "slowpoke",
			nickname = 'Ezalor',
			instance = 'Slowpoke',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		Ambipom = {
			species = "ambipom",
			nickname = 'Swigoi',
			instance = 'Ambipom',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		Sneasel = {
			species = "sneasel",
			nickname = 'Katrine',
			instance = 'Sneasel',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
		Kecleon = {
			species = "kecleon",
			nickname = 'Lars',
			instance = 'Kecleon',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		Kecleon_Purple = {
			species = "kecleon",
			nickname = 'Zigs',
			instance = 'Kecleon_Purple',
			gender = Gender.Male,
			form = 1,
			skin = "normal"
		},
		
		Chatot = {
			species = "chatot",
			nickname = 'Falo',
			instance = 'Chatot',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
	
		Shuckle = {
			species = "shuckle",
			nickname = 'Dion',
			instance = 'Shuckle',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},		
		
		Farfetchd = {
			species = "farfetchd",
			nickname = 'Mido',
			instance = "Farfetch'd",
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},	

		Stunky = {
			species = "stunky",
			nickname = 'Rhizo',
			instance = 'Stunky',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		Pelipper_Rescue = {
			species = "pelipper",
			nickname = 'Mael',
			instance = 'Pelipper_Rescue',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		Pelipper_Connect = {
			species = "pelipper",
			nickname = 'Anlin',
			instance = 'Pelipper_Connect',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
	
	
	--Town NPCs - Families
		Furret = {
			species = "furret",
			nickname = 'Jak',
			instance = 'Furret',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		Linoone = {
			species = "linoone", 
			nickname = 'Lebiure',
			instance = 'Linoone',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
	
		Sentret = {
			species = "sentret", 
			nickname = 'Timmi',
			instance = 'Sentret',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
	
		
		
		Luxray = {
			species = "luxray",
			nickname = 'Rulux',
			instance = 'Luxray',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
	
		Manectric = {
			species = "manectric",
			nickname = 'Camentra',
			instance = 'Manectric',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
		Electrike = {
			species = "electrike",
			nickname = 'Trilec',
			instance = 'Electrike',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		
		
		Floatzel = {
			species = "floatzel",
			nickname = 'Tweed',
			instance = 'Floatzel',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		Quagsire = {
			species = "quagsire",
			nickname = 'Maris',
			instance = 'Quagsire',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
		Wooper_Girl = {
			species = "wooper",
			nickname = 'Dee',
			instance = 'Wooper_Girl',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
	
		Wooper_Boy = {
			species = "wooper",
			nickname = 'Dun',
			instance = 'Wooper_Boy',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		
		
		Camerupt = {
			species = "camerupt",
			nickname = 'Dotra',
			instance = 'Camerupt',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
		Numel = {
			species = "numel",
			nickname = 'Nubbor',
			instance = 'Numel',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		
		
		Machamp = {
			species = "machamp",
			nickname = 'Savran',
			instance = 'Machamp',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
			
		Medicham = {
			species = "medicham",
			nickname = 'Nama',
			instance = 'Medicham',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
		Meditite = {
			species = "meditite",
			nickname = 'Stei',
			instance = 'Meditite',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
		
		--begonia flower 
		Vileplume = {
			species = "vileplume",
			nickname = 'Bogen',
			instance = 'Vileplume',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		--Chrysanthemum
		Bellossom = {
			species = "bellossom",
			nickname = 'Chrysi',
			instance = 'Bellossom',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
		--Lavender
		Gloom = {
			species = "gloom", 
			nickname = 'Lavena',
			instance = 'Gloom',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
		--White Lilac
		Oddish = {
			species = "oddish",
			nickname = 'Calil',
			instance = 'Oddish',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
		
		
		Nidoking = {
			species = "nidoking",
			nickname = 'Pawpa',
			instance = 'Nidoking',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		Nidoqueen = {
			species = "nidoqueen",
			nickname = 'Monna',
			instance = 'Nidoqueen',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
		Nidorina = {
			species = "nidorina",
			nickname = 'Dottir',
			instance = 'Nidorina',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
		Nidoran_M = {
			species = "nidoran_m",
			nickname = 'Junior',
			instance = 'Nidoran_M',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
	
	
	--Town NPCs - Other
		Sunflora = {
			species = "sunflora",
			nickname = 'Ciel',
			instance = 'Sunflora',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
		Azumarill = {
			species = "azumarill",
			nickname = 'Loaf',
			instance = 'Azumarill',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		Mawile = {
			species = "mawile",
			nickname = 'Bria',
			instance = 'Mawile',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
	
		Relicanth = {
			species = "relicanth",
			nickname = 'Erleuchtet',
			instance = 'Relicanth',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		--Head of Police
		Bisharp = {
			species = "bisharp",
			nickname = 'Zhayn',
			instance = 'Bisharp',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		--The cops, their actual names shouldn't show up. They're just used for some cutscenes.
		Pawniard_Boy = {
			species = "pawniard",
			nickname = 'Copper',
			instance = 'Pawniard_Boy',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		Pawniard_Girl = {
			species = "pawniard",
			nickname = 'Patty',
			instance = 'Pawniard_Girl',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		
		Gulpin = {
			species = "gulpin",
			nickname = 'Boosmu',
			instance = 'Gulpin',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		Lickitung = {
			species = "lickitung",
			nickname = 'Urgil',
			instance = 'Lickitung',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		--Other Plot Relevant NPCs
		--
		Sandile = {
			species = "sandile",
			nickname = 'Thwait',
			instance = 'Sandile',
			gender = Gender.Male,
			form = 1,--he is scarfed
			skin = "normal"
		},	

		Magcargo = {
			species = "magcargo",
			nickname = 'Morkot',--tzhaar words mishmashed togehter
			instance = 'Magcargo',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		--Inn Passersby
		Makuhita = {
			species = "makuhita",
			nickname = 'Passerby',
			instance = 'Passerby_1',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		--Inn Passersby
		Smeargle = {
			species = "smeargle",
			nickname = 'Passerby',
			instance = 'Passerby_1',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		
		--Inn Passersby
		Skorupi = {
			species = "skorupi",
			nickname = 'Passerby',
			instance = 'Passerby_1',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
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
		local nickname = AdjustNickname(name, characters)
		if length == 1 then--this case is so we can reference characters that aren't on the map. Put them at 0, 0 and hide them
			local monster = RogueEssence.Dungeon.MonsterID(characters[name].species,
															characters[name].form,
															characters[name].skin,
															characters[name].gender)
			chara = RogueEssence.Ground.GroundChar(monster, RogueElements.Loc(0, 0), Direction.Down, nickname, characters[name].instance)
			chara:ReloadEvents()
			GAME:GetCurrentGround():AddTempChar(chara)
			GROUND:Hide(chara.EntName)
			
		elseif length == 2 then --may be inefficient to do a length lookup so often...
			local marker = MRKR(list[i][2])
			local monster = RogueEssence.Dungeon.MonsterID(characters[name].species,
															characters[name].form,
															characters[name].skin,
															characters[name].gender)
			chara = RogueEssence.Ground.GroundChar(monster, RogueElements.Loc(marker.Position.X, marker.Position.Y), marker.Direction, nickname, characters[name].instance)
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
			chara = RogueEssence.Ground.GroundChar(monster, RogueElements.Loc(x, y), direction, nickname, characters[name].instance)
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
function CharacterEssentials.GetCharacterName(name, no_color)
	local nickname = AdjustNickname(name, characters)
	if no_color then
		return nickname
	else
		return "[color=#00FFFF]" .. nickname .. "[color]"
	end
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
	
	local species = "missingno"
	local nickname = "default"
	local instance = "default"
	local gender = Gender.Genderless
	local form = 0--formes 
	local skin = "normal"--shiny?
	
	
	
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
