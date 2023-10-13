require 'common'
require 'GeneralFunctions'
require 'CharacterEssentials'

--Halcyon Custom work:
--Code in this folder is used to generate, display, and handle randomized missions
--and all that goes with that (rewards, rankups, etc)


--A job is saved as a list of variables, where each variable represents an attribute of the job, such as reward, client, destination floor, etc.
--There are 3 sets of lua lists then. One for the missions taken, one for the missions on the job board, and one for the missions on the outlaw board.
--Each of those lists can only have up to 8 jobs.

--List of mission attributes:
--Client (the pokemon in need of escort, rescue, or the person asking for an outlaw capture). Given as species string
--Target (Pokemon in need of rescue, or the one to escort to, or the mon to be arrested). Given as species string
--Escort Species - should be given as a blank if this is not an escort mission.
--Zone (dungeon)
--Segment (part of the dungeon) - this is typically the default segment
--Floor 
--Reward - given as item name's string. If money, should be given as "Money" and the amount will be based off the difficulty.
--Mission Type - outlaw, escort, or rescue
--Completion status - Incomplete or Complete. When a reward is handed out at the end of the day, any missions that are completed should be removed from the taken board.
--Taken - Was the mission on the board taken? This is also used to suspend missions that were taken off the board
--Difficulty - Letter rank that are hardcoded to represent certain number amounts
--Flavor - Flavor text for the mission, should be a string in strings.resx that can potentially be filled in by blanks.

--Hardcoded number values. Adjust those sorts of things here.
--Difficulty's point ranks
MISSION_GEN = {}

MISSION_GEN.DUNGEON_LIST = {"illuminant_riverbed", "crooked_cavern", "apricorn_grove"}

MISSION_GEN.DIFFICULTY = {}
MISSION_GEN.DIFFICULTY[""] = 0
MISSION_GEN.DIFFICULTY["F"] = 0
MISSION_GEN.DIFFICULTY["E"] = 10
MISSION_GEN.DIFFICULTY["D"] = 15
MISSION_GEN.DIFFICULTY["C"] = 20
MISSION_GEN.DIFFICULTY["B"] = 30
MISSION_GEN.DIFFICULTY["A"] = 50
MISSION_GEN.DIFFICULTY["S"] = 70
MISSION_GEN.DIFFICULTY["STAR_1"] = 100

--dungeon's assigned difficulty
MISSION_GEN.DUNGEON_DIFFICULTY = {}
MISSION_GEN.DUNGEON_DIFFICULTY[""] = "F"--just in case lul
MISSION_GEN.DUNGEON_DIFFICULTY["relic_forest"] = "E"--missions shouldn't be given for relic forest 
MISSION_GEN.DUNGEON_DIFFICULTY["illuminant_riverbed"] = "D"
MISSION_GEN.DUNGEON_DIFFICULTY["crooked_cavern"] = "C"
MISSION_GEN.DUNGEON_DIFFICULTY["apricorn_grove"] = "B"


--order of difficulties. 
MISSION_GEN.DIFF_TO_ORDER = {}
MISSION_GEN.DIFF_TO_ORDER[""] = 1
MISSION_GEN.DIFF_TO_ORDER["F"] = 2
MISSION_GEN.DIFF_TO_ORDER["E"] = 3
MISSION_GEN.DIFF_TO_ORDER["D"] = 4
MISSION_GEN.DIFF_TO_ORDER["C"] = 5
MISSION_GEN.DIFF_TO_ORDER["B"] = 6
MISSION_GEN.DIFF_TO_ORDER["A"] = 7
MISSION_GEN.DIFF_TO_ORDER["S"] = 8
MISSION_GEN.DIFF_TO_ORDER["STAR_1"] = 9

--use this to get back from above.
MISSION_GEN.ORDER_TO_DIFF = {"", "F", "E", "D", "C", "B", "A", "S", "STAR_1"}

--mapping of difficulty to reward amounts for money
MISSION_GEN.DIFF_TO_MONEY = {}
MISSION_GEN.DIFF_TO_MONEY[""] = 0
MISSION_GEN.DIFF_TO_MONEY["F"] = 0
MISSION_GEN.DIFF_TO_MONEY["E"] = 100
MISSION_GEN.DIFF_TO_MONEY["D"] = 150
MISSION_GEN.DIFF_TO_MONEY["C"] = 200
MISSION_GEN.DIFF_TO_MONEY["B"] = 250
MISSION_GEN.DIFF_TO_MONEY["A"] = 300
MISSION_GEN.DIFF_TO_MONEY["S"] = 350
MISSION_GEN.DIFF_TO_MONEY["STAR_1"] = 400

--color coding for mission difficulty letters
MISSION_GEN.DIFF_TO_COLOR = {}
MISSION_GEN.DIFF_TO_COLOR[""] = "[color=#000000]"
MISSION_GEN.DIFF_TO_COLOR["F"] = "[color=#000000]"
MISSION_GEN.DIFF_TO_COLOR["E"] = "[color=#F8F8F8]"
MISSION_GEN.DIFF_TO_COLOR["D"] = "[color=#F8C8C8]"
MISSION_GEN.DIFF_TO_COLOR["C"] = "[color=#40F840]"
MISSION_GEN.DIFF_TO_COLOR["B"] = "[color=#F8C060]"
MISSION_GEN.DIFF_TO_COLOR["A"] = "[color=#00F8F8]"
MISSION_GEN.DIFF_TO_COLOR["S"] = "[color=#F80000]"
MISSION_GEN.DIFF_TO_COLOR["STAR_1"] = "[color=#F8F800]"



MISSION_GEN.COMPLETE = 1
MISSION_GEN.INCOMPLETE = 0

MISSION_GEN.EXPECTED_LEVEL = {}
MISSION_GEN.EXPECTED_LEVEL["illuminant_riverbed"] = 8
MISSION_GEN.EXPECTED_LEVEL["crooked_cavern"] = 10
MISSION_GEN.EXPECTED_LEVEL["apricorn_grove"] = 13


MISSION_GEN.TITLES =  {
	RESCUE_SELF = {
		"MISSION_TITLE_RESCUE_SELF_001",
		"MISSION_TITLE_RESCUE_SELF_002",
		"MISSION_TITLE_RESCUE_SELF_003",
		"MISSION_TITLE_RESCUE_SELF_004",
		"MISSION_TITLE_RESCUE_SELF_005",
		"MISSION_TITLE_RESCUE_SELF_006",
		"MISSION_TITLE_RESCUE_SELF_007",
		"MISSION_TITLE_RESCUE_SELF_008",
		"MISSION_TITLE_RESCUE_SELF_009",
		"MISSION_TITLE_RESCUE_SELF_010"
	},
	RESCUE_FRIEND =	{
		"MISSION_TITLE_RESCUE_FRIEND_001",
		"MISSION_TITLE_RESCUE_FRIEND_002",
		"MISSION_TITLE_RESCUE_FRIEND_003",
		"MISSION_TITLE_RESCUE_FRIEND_004",
		"MISSION_TITLE_RESCUE_FRIEND_005",
		"MISSION_TITLE_RESCUE_FRIEND_006",
		"MISSION_TITLE_RESCUE_FRIEND_007",
		"MISSION_TITLE_RESCUE_FRIEND_008",
		"MISSION_TITLE_RESCUE_FRIEND_009",
		"MISSION_TITLE_RESCUE_FRIEND_010"
	},
	ESCORT = {
		"MISSION_TITLE_ESCORT_001",
		"MISSION_TITLE_ESCORT_002",
		"MISSION_TITLE_ESCORT_003",
		"MISSION_TITLE_ESCORT_004",
		"MISSION_TITLE_ESCORT_005"
	},
	EXPLORATION = {
		"MISSION_TITLE_EXPLORATION_001",
		"MISSION_TITLE_EXPLORATION_002",
		"MISSION_TITLE_EXPLORATION_003",
		"MISSION_TITLE_EXPLORATION_004",
		"MISSION_TITLE_EXPLORATION_005"
	},
	DELIVERY = {
		"MISSION_TITLE_DELIVERY_001",
		"MISSION_TITLE_DELIVERY_002",
		"MISSION_TITLE_DELIVERY_003",
		"MISSION_TITLE_DELIVERY_004",
		"MISSION_TITLE_DELIVERY_005"
	},	
	LOST_ITEM = {
		"MISSION_TITLE_LOST_ITEM_001",
		"MISSION_TITLE_LOST_ITEM_002",
		"MISSION_TITLE_LOST_ITEM_003",
		"MISSION_TITLE_LOST_ITEM_004",
		"MISSION_TITLE_LOST_ITEM_005"
	},
	OUTLAW = {
		"MISSION_TITLE_OUTLAW_001",
		"MISSION_TITLE_OUTLAW_002",
		"MISSION_TITLE_OUTLAW_003",
		"MISSION_TITLE_OUTLAW_004",
		"MISSION_TITLE_OUTLAW_005",
		"MISSION_TITLE_OUTLAW_006",
		"MISSION_TITLE_OUTLAW_007",
		"MISSION_TITLE_OUTLAW_008",
		"MISSION_TITLE_OUTLAW_009",
		"MISSION_TITLE_OUTLAW_010",
	},
	OUTLAW_ITEM = {
		"MISSION_TITLE_OUTLAW_ITEM_001",
		"MISSION_TITLE_OUTLAW_ITEM_002",
		"MISSION_TITLE_OUTLAW_ITEM_003",
		"MISSION_TITLE_OUTLAW_ITEM_004",
		"MISSION_TITLE_OUTLAW_ITEM_005"
	},	
	OUTLAW_MONSTER_HOUSE = {
		"MISSION_TITLE_OUTLAW_MONSTER_HOUSE_001",
		"MISSION_TITLE_OUTLAW_MONSTER_HOUSE_002",
		"MISSION_TITLE_OUTLAW_MONSTER_HOUSE_003",
		"MISSION_TITLE_OUTLAW_MONSTER_HOUSE_004",
		"MISSION_TITLE_OUTLAW_MONSTER_HOUSE_005"
	},	
	OUTLAW_FLEE = {
		"MISSION_TITLE_OUTLAW_FLEE_001",
		"MISSION_TITLE_OUTLAW_FLEE_002",
		"MISSION_TITLE_OUTLAW_FLEE_003",
		"MISSION_TITLE_OUTLAW_FLEE_004",
		"MISSION_TITLE_OUTLAW_FLEE_005"
	},
	
	--For special client/targets
	RIVAL = {
		"MISSION_TITLE_SPECIAL_RIVAL_001",
		"MISSION_TITLE_SPECIAL_RIVAL_002",
		"MISSION_TITLE_SPECIAL_RIVAL_003"
	},
	
	CHILD = {
		"MISSION_TITLE_SPECIAL_CHILD_001",
		"MISSION_TITLE_SPECIAL_CHILD_002",
		"MISSION_TITLE_SPECIAL_CHILD_003"
	},
	FRIEND = {
		"MISSION_TITLE_SPECIAL_FRIEND_001",
		"MISSION_TITLE_SPECIAL_FRIEND_002",
		"MISSION_TITLE_SPECIAL_FRIEND_003"
	},
	LOVER = {
		"MISSION_TITLE_SPECIAL_LOVER_001",
		"MISSION_TITLE_SPECIAL_LOVER_002",
		"MISSION_TITLE_SPECIAL_LOVER_003"
	}	
}

MISSION_GEN.FLAVOR_TOP =  {
	RESCUE_SELF = {
		"MISSION_BODY_TOP_RESCUE_SELF_001",
		"MISSION_BODY_TOP_RESCUE_SELF_002",
		"MISSION_BODY_TOP_RESCUE_SELF_003",
		"MISSION_BODY_TOP_RESCUE_SELF_004",
		"MISSION_BODY_TOP_RESCUE_SELF_005",
		"MISSION_BODY_TOP_RESCUE_SELF_006",
		"MISSION_BODY_TOP_RESCUE_SELF_007",
		"MISSION_BODY_TOP_RESCUE_SELF_008",
		"MISSION_BODY_TOP_RESCUE_SELF_009",
		"MISSION_BODY_TOP_RESCUE_SELF_010"
	},
	RESCUE_FRIEND =	{
		"MISSION_BODY_TOP_RESCUE_FRIEND_001",
		"MISSION_BODY_TOP_RESCUE_FRIEND_002",
		"MISSION_BODY_TOP_RESCUE_FRIEND_003",
		"MISSION_BODY_TOP_RESCUE_FRIEND_004",
		"MISSION_BODY_TOP_RESCUE_FRIEND_005",
		"MISSION_BODY_TOP_RESCUE_FRIEND_006",
		"MISSION_BODY_TOP_RESCUE_FRIEND_007",
		"MISSION_BODY_TOP_RESCUE_FRIEND_008",
		"MISSION_BODY_TOP_RESCUE_FRIEND_009",
		"MISSION_BODY_TOP_RESCUE_FRIEND_010"
	},
	ESCORT = {
		"MISSION_BODY_TOP_ESCORT_001",
		"MISSION_BODY_TOP_ESCORT_002",
		"MISSION_BODY_TOP_ESCORT_003",
		"MISSION_BODY_TOP_ESCORT_004",
		"MISSION_BODY_TOP_ESCORT_005"
	},
	EXPLORATION = {
		"MISSION_BODY_TOP_EXPLORATION_001",
		"MISSION_BODY_TOP_EXPLORATION_002",
		"MISSION_BODY_TOP_EXPLORATION_003",
		"MISSION_BODY_TOP_EXPLORATION_004",
		"MISSION_BODY_TOP_EXPLORATION_005"
	},
	DELIVERY = {
		"MISSION_BODY_TOP_DELIVERY_001",
		"MISSION_BODY_TOP_DELIVERY_002",
		"MISSION_BODY_TOP_DELIVERY_003",
		"MISSION_BODY_TOP_DELIVERY_004",
		"MISSION_BODY_TOP_DELIVERY_005"
	},	
	LOST_ITEM = {
		"MISSION_BODY_TOP_LOST_ITEM_001",
		"MISSION_BODY_TOP_LOST_ITEM_002",
		"MISSION_BODY_TOP_LOST_ITEM_003",
		"MISSION_BODY_TOP_LOST_ITEM_004",
		"MISSION_BODY_TOP_LOST_ITEM_005"
	},
	OUTLAW = {
		"MISSION_BODY_TOP_OUTLAW_001",
		"MISSION_BODY_TOP_OUTLAW_002",
		"MISSION_BODY_TOP_OUTLAW_003",
		"MISSION_BODY_TOP_OUTLAW_004",
		"MISSION_BODY_TOP_OUTLAW_005",
		"MISSION_BODY_TOP_OUTLAW_006",
		"MISSION_BODY_TOP_OUTLAW_007",
		"MISSION_BODY_TOP_OUTLAW_008",
		"MISSION_BODY_TOP_OUTLAW_009",
		"MISSION_BODY_TOP_OUTLAW_010"
	},
	OUTLAW_ITEM = {
		"MISSION_BODY_TOP_OUTLAW_ITEM_001",
		"MISSION_BODY_TOP_OUTLAW_ITEM_002",
		"MISSION_BODY_TOP_OUTLAW_ITEM_003",
		"MISSION_BODY_TOP_OUTLAW_ITEM_004",
		"MISSION_BODY_TOP_OUTLAW_ITEM_005"
	},	
	OUTLAW_MONSTER_HOUSE = {
		"MISSION_BODY_TOP_OUTLAW_MONSTER_HOUSE_001",
		"MISSION_BODY_TOP_OUTLAW_MONSTER_HOUSE_002",
		"MISSION_BODY_TOP_OUTLAW_MONSTER_HOUSE_003",
		"MISSION_BODY_TOP_OUTLAW_MONSTER_HOUSE_004",
		"MISSION_BODY_TOP_OUTLAW_MONSTER_HOUSE_005"
	},	
	OUTLAW_FLEE = {
		"MISSION_BODY_TOP_OUTLAW_FLEE_001",
		"MISSION_BODY_TOP_OUTLAW_FLEE_002",
		"MISSION_BODY_TOP_OUTLAW_FLEE_003",
		"MISSION_BODY_TOP_OUTLAW_FLEE_004",
		"MISSION_BODY_TOP_OUTLAW_FLEE_005"
	}
}

MISSION_GEN.FLAVOR_BOTTOM =  {
	RESCUE_SELF = {
		"MISSION_BODY_BOTTOM_RESCUE_SELF_001",
		"MISSION_BODY_BOTTOM_RESCUE_SELF_002",
		"MISSION_BODY_BOTTOM_RESCUE_SELF_003",
		"MISSION_BODY_BOTTOM_RESCUE_SELF_004",
		"MISSION_BODY_BOTTOM_RESCUE_SELF_005",
		"MISSION_BODY_BOTTOM_RESCUE_SELF_006",
		"MISSION_BODY_BOTTOM_RESCUE_SELF_007",
		"MISSION_BODY_BOTTOM_RESCUE_SELF_008",
		"MISSION_BODY_BOTTOM_RESCUE_SELF_009",
		"MISSION_BODY_BOTTOM_RESCUE_SELF_010"
	},
	RESCUE_FRIEND =	{
		"MISSION_BODY_BOTTOM_RESCUE_FRIEND_001",
		"MISSION_BODY_BOTTOM_RESCUE_FRIEND_002",
		"MISSION_BODY_BOTTOM_RESCUE_FRIEND_003",
		"MISSION_BODY_BOTTOM_RESCUE_FRIEND_004",
		"MISSION_BODY_BOTTOM_RESCUE_FRIEND_005",
		"MISSION_BODY_BOTTOM_RESCUE_FRIEND_006",
		"MISSION_BODY_BOTTOM_RESCUE_FRIEND_007",
		"MISSION_BODY_BOTTOM_RESCUE_FRIEND_008",
		"MISSION_BODY_BOTTOM_RESCUE_FRIEND_009",
		"MISSION_BODY_BOTTOM_RESCUE_FRIEND_010"
	},
	ESCORT = {
		"MISSION_BODY_BOTTOM_ESCORT_001",
		"MISSION_BODY_BOTTOM_ESCORT_002",
		"MISSION_BODY_BOTTOM_ESCORT_003",
		"MISSION_BODY_BOTTOM_ESCORT_004",
		"MISSION_BODY_BOTTOM_ESCORT_005"
	},
	EXPLORATION = {
		"MISSION_BODY_BOTTOM_EXPLORATION_001",
		"MISSION_BODY_BOTTOM_EXPLORATION_002",
		"MISSION_BODY_BOTTOM_EXPLORATION_003",
		"MISSION_BODY_BOTTOM_EXPLORATION_004",
		"MISSION_BODY_BOTTOM_EXPLORATION_005"
	},
	DELIVERY = {
		"MISSION_BODY_BOTTOM_DELIVERY_001",
		"MISSION_BODY_BOTTOM_DELIVERY_002",
		"MISSION_BODY_BOTTOM_DELIVERY_003",
		"MISSION_BODY_BOTTOM_DELIVERY_004",
		"MISSION_BODY_BOTTOM_DELIVERY_005"
	},	
	LOST_ITEM = {
		"MISSION_BODY_BOTTOM_LOST_ITEM_001",
		"MISSION_BODY_BOTTOM_LOST_ITEM_002",
		"MISSION_BODY_BOTTOM_LOST_ITEM_003",
		"MISSION_BODY_BOTTOM_LOST_ITEM_004",
		"MISSION_BODY_BOTTOM_LOST_ITEM_005"
	},
	OUTLAW = {
		"MISSION_BODY_BOTTOM_OUTLAW_001",
		"MISSION_BODY_BOTTOM_OUTLAW_002",
		"MISSION_BODY_BOTTOM_OUTLAW_003",
		"MISSION_BODY_BOTTOM_OUTLAW_004",
		"MISSION_BODY_BOTTOM_OUTLAW_005"
	},
	OUTLAW_ITEM = {
		"MISSION_BODY_BOTTOM_OUTLAW_ITEM_001",
		"MISSION_BODY_BOTTOM_OUTLAW_ITEM_002",
		"MISSION_BODY_BOTTOM_OUTLAW_ITEM_003",
		"MISSION_BODY_BOTTOM_OUTLAW_ITEM_004",
		"MISSION_BODY_BOTTOM_OUTLAW_ITEM_005"
	},	
	OUTLAW_MONSTER_HOUSE = {
		"MISSION_BODY_BOTTOM_OUTLAW_MONSTER_HOUSE_001",
		"MISSION_BODY_BOTTOM_OUTLAW_MONSTER_HOUSE_002",
		"MISSION_BODY_BOTTOM_OUTLAW_MONSTER_HOUSE_003",
		"MISSION_BODY_BOTTOM_OUTLAW_MONSTER_HOUSE_004",
		"MISSION_BODY_BOTTOM_OUTLAW_MONSTER_HOUSE_005"
	},	
	OUTLAW_FLEE = {
		"MISSION_BODY_BOTTOM_OUTLAW_FLEE_001",
		"MISSION_BODY_BOTTOM_OUTLAW_FLEE_002",
		"MISSION_BODY_BOTTOM_OUTLAW_FLEE_003",
		"MISSION_BODY_BOTTOM_OUTLAW_FLEE_004",
		"MISSION_BODY_BOTTOM_OUTLAW_FLEE_005"
	}
}
--master pokemon list
--This is a list of all Released Pokemon, minus ones who are in the same evolutionary family as a named character in the game,
--starters, legendaries, and a few other "special" mons (unown for example)
MISSION_GEN.MASTER_POKEMON_LIST = 
{"abra","absol","aerodactyl","aipom","alakazam","alcremie","altaria","amaura","anorith","appletun","applin","arbok","archen","ariados","armaldo","aron","arrokuda","aurorus","axew",
"baltoy","banette","barboach","bastiodon","beedrill","beldum","bellsprout","bibarel","bidoof","blissey","bonsly","bounsweet","bronzong","bronzor","buneary","burmy",
"carnivine","carvanha","cascoon","castform","chandelure","chansey","chatot","cherrim","cherubi","chimecho","chinchou","chingling","clamperl","claydol","clobbopus","cloyster","combee","corphish","corsola","corviknight","cradily","cramorant","crawdaunt","croagunk","crobat","cubchoo","cursola","cutiefly",
"deerling","deino","delibird","dewgong","diglett","ditto","donphan","dragonair","dragonite","drampa","drapion","dratini","drifblim","drifloon","drowzee","dugtrio","dunsparce","duosion","dusclops","dusknoir","duskull","dustox",
"ekans","electabuzz","electivire","electrode","elekid","emolga","espurr","exeggcute","exeggutor","exploud",
"fearow","feebas","finneon","flabebe","floette","florges","flygon","fomantis","forretress","froslass",
"gallade","galvantula","gardevoir","gastly","gastrodon","gengar","geodude","glalie","gligar","gliscor","golbat","goldeen","golduck","golem","golisopod","golurk","goodra","goomy","gorebyss","gothita","gothitelle","gothorita","gourgeist","graveler","grimer","grumpig","gyarados",
"happiny","hariyama","hatenna","hatterene","hattrem","haunter","helioptile","heracross","hippopotas","hippowdon","hitmonchan","hitmonlee","hitmontop","honedge","hoppip","horsea","houndoom","houndour","huntail","hypno",
"illumise","indeedee",
"jangmo_o","joltik","jumpluff","jynx",
"kabuto","kabutops","kadabra","kakuna","kingdra","kingler","kirlia","koffing","krabby","kricketot","kricketune",
"lampent","lanturn","lapras","larvitar","leavanny","lileep","lillipup","litwick","lopunny","loudred","lumineon","lunatone","luvdisc",
"magby","magcargo","magikarp","magmar","magmortar","magnemite","magneton","magnezone","makuhita","mamoswine","mandibuzz","mankey","mantine","mantyke","maractus","mareanie","masquerain","meowstic","metagross","metang","mienfoo","mightyena","milotic","miltank","mime_jr","minccino","minior","minun","misdreavus","mismagius","morgrem","mothim","mr_mime","muk",
"natu","nincada","ninjask","noibat","noivern","nosepass","nuzleaf",
"octillery","omanyte","omastar","onix",
"pachirisu","paras","parasect","phantump","pidgeot","pidgeotto","pidgey","pidove","piloswine","pineco","pinsir","plusle","politoed","poliwag","poliwhirl","poliwrath","ponyta","poochyena","porygon","porygon_z","porygon2","primeape","probopass","psyduck","pumpkaboo","pupitar","purrloin","purugly",
"qwilfish",
"ralts","rapidash","raticate","rattata","remoraid","rhydon","rhyhorn","rhyperior","ribombee","roggenrola",
"sableye","salandit","salazzle","sandshrew","sandslash","sandygast","sawsbuck","scizor","scrafty","scyther","seadra","seaking","seedot","seel","sewaddle","sharpedo","shedinja","shellder","shellos","shieldon","shiftry","shuppet","sinistea","skarmory","skiploom","skorupi","skuntank","slaking","slakoth","sliggoo","slugma","smeargle","smoochum","snorunt","snover","solrock","spearow","spinarak","spiritomb","spoink","stantler","staraptor","staravia","starly","starmie","staryu","steelix","steenee","stoutland","sudowoodo","surskit","swablu","swellow","swinub","swirlix","swoobat",
"taillow","tangela","tangrowth","tauros","teddiursa","tentacool","tentacruel","thievul","togedemaru","togekiss","togepi","togetic","torkoal","toxicroak","trapinch","trubbish","tsareena","tympole","tyranitar","tyrogue",
"ursaring",
"vanillish","vanillite","venomoth","venonat","vespiquen","vibrava","victreebel","vigoroth","volbeat","voltorb",
"wailmer","wailord","weedle","weepinbell","weezing","whimsicott","whiscash","whismur","wobbuffet","woobat","wooloo","wormadam","wynaut",
"xatu",
"yanma","yanmega",
"zubat"}

MISSION_GEN.POKEMON = {
	--weak mons for easy missions
	TIER_LOW = 
	{"abra","amaura","anorith","applin","archen","aron","arrokuda","axew",
	"baltoy","barboach","beldum","bellsprout","bidoof","bonsly","bounsweet","bronzor","buneary","burmy",
	"carvanha","cascoon","cherubi","chinchou","chingling","clamperl","clobbopus","combee","corphish","croagunk","cubchoo","cutiefly",
	"deerling","deino","diglett","dratini","drifloon","drowzee","duskull",
	"ekans","elekid","espurr","exeggcute",
	"feebas","finneon","flabebe","fomantis",
	"gastly","geodude","goldeen","goomy","gothita","grimer",
	"happiny","hatenna","helioptile","hippopotas","honedge","hoppip","horsea","houndour",

	"jangmo_o","joltik",
	"kabuto","kakuna","koffing","krabby","kricketot",
	"larvitar","lileep","lillipup","litwick","luvdisc",
	"magby","magikarp","magnemite","makuhita","mankey","mantyke","mareanie","mienfoo","mime_jr","minccino",
	"natu","nincada","noibat","nosepass",
	"omanyte","onix",
	"paras","phantump","pidgey","pidove","pineco","poliwag","ponyta","poochyena","porygon","psyduck","pumpkaboo","purrloin",

	"ralts","rattata","remoraid","rhyhorn","roggenrola",
	"salandit","sandshrew","sandygast","seedot","seel","sewaddle","shellder","shellos","shieldon","shuppet","sinistea","skorupi","slakoth","slugma","smoochum","snorunt","snover","spearow","spinarak","spoink","starly","staryu","surskit","swablu","swinub","swirlix",
	"taillow","teddiursa","tentacool","togepi","trapinch","trubbish","tympole","tyrogue",

	"vanillite","venonat","voltorb",
	"wailmer","weedle","whismur","woobat","wooloo","wynaut",


	"zubat"},

	--middling mons for medium missions
	TIER_MID = 
	{"aipom","arbok","ariados",
	"beedrill","bibarel",
	"carnivine","castform","chansey","chatot","cherrim","chimecho","corsola","cramorant",
	"delibird","ditto","dragonair","dunsparce","duosion","dustox",
	"electabuzz","emolga",
	"floette",
	"gligar","golbat","gothorita","graveler",
	"hattrem","haunter",
	"illumise","indeedee",
	"jynx",
	"kadabra","kirlia","kricketune",
	"lampent","loudred","lunatone",
	"magmar","magneton","maractus","masquerain","metang","mightyena","miltank","minior","minun","misdreavus","morgrem","mothim","mr_mime",
	"ninjask","nuzleaf",

	"pachirisu","parasect","pidgeotto","piloswine","plusle","poliwhirl","porygon2","pupitar",
	"qwilfish",
	"raticate","ribombee",
	"sableye","scyther","seadra","shedinja","skiploom","sliggoo","smeargle","solrock","stantler","staravia","steenee","sudowoodo",
	"tangela","thievul","togedemaru","togetic","torkoal",

	"vanillish","venomoth","vespiquen","vibrava","vigoroth","volbeat",
	"weepinbell","wobbuffet","wormadam",

	"yanma"
	},

	--strong pokemon for difficult missions
	TIER_HIGH = 
	{"absol","aerodactyl","alakazam","alcremie","altaria","appletun","armaldo","aurorus",
	"banette","bastiodon","blissey","bronzong",
	"chandelure","claydol","cloyster","corviknight","cradily","crawdaunt","crobat","cursola",
	"dewgong","donphan","dragonite","drampa","drapion","drifblim","dugtrio","dusclops","dusknoir",
	"electivire","exeggutor","exploud",
	"fearow","florges","flygon","forretress","froslass",
	"gallade","galvantula","gardevoir","gastrodon","gengar","glalie","gliscor","golduck","golem","golisopod","goodra","gorebyss","gothitelle","gourgeist","grumpig","gyarados",
	"hariyama","hatterene","heracross","hippowdon","hitmonchan","hitmonlee","hitmontop","houndoom","huntail","hypno",

	"jumpluff",
	"kabutops","kingdra","kingler",
	"lanturn","lapras","leavanny","lopunny","lumineon",
	"magcargo","magmortar","magnezone","mamoswine","mandibuzz","mantine","meowstic","metagross","milotic","mismagius","muk",
	"noivern",
	"octillery","omastar",
	"pidgeot","pinsir","politoed","poliwrath","porygon_z","primeape","probopass","purugly",

	"rapidash","rhydon","rhyperior",
	"salazzle","sandslash","sawsbuck","scizor","scrafty","seaking","sharpedo","shiftry","skarmory","skuntank","slaking","spiritomb","staraptor","starmie","steelix","stoutland","swellow","swoobat",
	"tangrowth","tauros","tentacruel","togekiss","toxicroak","tsareena","tyranitar",
	"ursaring",
	"victreebel",
	"wailord","weezing","whimsicott","whiscash",
	"xatu",
	"yanmega",
	}
}

--weighting of possible client/target pokemon based on difficulty of mission
MISSION_GEN.DIFF_POKEMON = {
	E = {
		{"TIER_LOW", 10},
		{"TIER_MID", 0},
		{"TIER_HIGH", 0}
		},
	D = {
		{"TIER_LOW", 9},
		{"TIER_MID", 1},
		{"TIER_HIGH", 0}
		},
	C = {
		{"TIER_LOW", 8},
		{"TIER_MID", 2},
		{"TIER_HIGH", 0}
		},
	B = {
		{"TIER_LOW", 7},
		{"TIER_MID", 3},
		{"TIER_HIGH", 0}
		},
	A = {
		{"TIER_LOW", 5},
		{"TIER_MID", 5},
		{"TIER_HIGH", 0}
		},
	S = {
		{"TIER_LOW", 2},
		{"TIER_MID", 7},
		{"TIER_HIGH", 1}
		},
	STAR_1 = {
		{"TIER_LOW", 0},
		{"TIER_MID", 7},
		{"TIER_HIGH", 3}
		}
}

--weighting of each loot table based on difficulty of mission

MISSION_GEN.DIFF_REWARDS = {
	E = {
		{"AMMO_LOW", 5},
		{"AMMO_HIGH", 0},
		{"FOOD_LOW", 5},
		{"FOOD_HIGH", 0},
		{"SEED_LOW", 5},
		{"SEED_HIGH", 0},
		{"HELD_LOW", 0},
		{"HELD_HIGH", 0},
		{"TM_LOW", 0},
		{"TM_MID", 0},
		{"TM_HIGH", 0},
		{"SPECIAL", 0}
		},
	D = {
		{"AMMO_LOW", 5},
		{"AMMO_HIGH", 0},
		{"FOOD_LOW", 5},
		{"FOOD_HIGH", 0},
		{"SEED_LOW", 5},
		{"SEED_HIGH", 0},
		{"HELD_LOW", 2},
		{"HELD_HIGH", 0},
		{"TM_LOW", 0},
		{"TM_MID", 0},
		{"TM_HIGH", 0},
		{"SPECIAL", 0}
		},
	C = {
		{"AMMO_LOW", 5},
		{"AMMO_HIGH", 0},
		{"FOOD_LOW", 5},
		{"FOOD_HIGH", 0},
		{"SEED_LOW", 5},
		{"SEED_HIGH", 0},
		{"HELD_LOW", 3},
		{"HELD_HIGH", 0},
		{"TM_LOW", 2},
		{"TM_MID", 0},
		{"TM_HIGH", 0},
		{"SPECIAL", 0}
		},
	B = {
		{"AMMO_LOW", 5},
		{"AMMO_HIGH", 0},
		{"FOOD_LOW", 5},
		{"FOOD_HIGH", 0},
		{"SEED_LOW", 5},
		{"SEED_HIGH", 0},
		{"HELD_LOW", 4},
		{"HELD_HIGH", 0},
		{"TM_LOW", 3},
		{"TM_MID", 0},
		{"TM_HIGH", 0},
		{"SPECIAL", 0}
		},
	A = {
		{"AMMO_LOW", 5},
		{"AMMO_HIGH", 1},
		{"FOOD_LOW", 5},
		{"FOOD_HIGH", 1},
		{"SEED_LOW", 5},
		{"SEED_HIGH", 1},
		{"HELD_LOW", 5},
		{"HELD_HIGH", 0},
		{"TM_LOW", 3},
		{"TM_MID", 1},
		{"TM_HIGH", 0},
		{"SPECIAL", 0}
		},
	S = {
		{"AMMO_LOW", 4},
		{"AMMO_HIGH", 1},
		{"FOOD_LOW", 4},
		{"FOOD_HIGH", 1},
		{"SEED_LOW", 4},
		{"SEED_HIGH", 1},
		{"HELD_LOW", 4},
		{"HELD_HIGH", 1},
		{"TM_LOW", 2},
		{"TM_MID", 3},
		{"TM_HIGH", 0},
		{"SPECIAL", 0}
		},
	STAR_1 = {
		{"AMMO_LOW", 3},
		{"AMMO_HIGH", 2},
		{"FOOD_LOW", 3},
		{"FOOD_HIGH", 2},
		{"SEED_LOW", 3},
		{"SEED_HIGH", 2},
		{"HELD_LOW", 3},
		{"HELD_HIGH", 2},
		{"TM_LOW", 0},
		{"TM_MID", 4},
		{"TM_HIGH", 1},
		{"SPECIAL", 0}
		}
}



--Weighted list of rewards to choose from for missions
--todo: balance the weightings
MISSION_GEN.REWARDS = {
	--Reward tables of high and low tier loot separated by category (TM, ammo, held items, etc)
	--different mission difficulties have different chances to roll each table
	AMMO_LOW = {
		{"ammo_geo_pebble", 5},
		{"ammo_gravelerock", 5},
		{"ammo_iron_thorn", 5},
		{"ammo_stick", 5},
		{"ammo_silver_spike", 5}
	},
	
	AMMO_HIGH = {
		{"ammo_rare_fossil", 5},
		{"ammo_corsola_twig", 5},
		{"ammo_cacnea_spike", 5},
		{"ammo_golden_thorn", 5}
	},
	--Rare chance for gummis
	FOOD_LOW = {
		{"food_apple", 30},
		{"food_apple_big", 18},
		{"food_banana", 18},
		{"food_chestnut", 12},
		{"gummi_blue", 1},
		{"gummi_black", 1},
		{"gummi_clear", 1}, 
		{"gummi_grass", 1},
		{"gummi_green", 1},
		{"gummi_brown", 1},
		{"gummi_orange", 1},
		{"gummi_gold", 1},
		{"gummi_pink", 1},
		{"gummi_purple", 1},
		{"gummi_red", 1},
		{"gummi_royal", 1},
		{"gummi_silver", 1},
		{"gummi_white", 1},
		{"gummi_yellow", 1},
		{"gummi_sky", 1},
		{"gummi_gray", 1},
		{"gummi_magenta", 1}
	},
	--Better chance for gummis over low tier, small chance for vitamins
	FOOD_HIGH = {
		{"food_apple_big", 30},
		{"food_apple_huge", 18},
		{"food_apple_perfect", 12},
		{"food_banana_big", 18},
		{"gummi_blue", 1},
		{"gummi_black", 1},
		{"gummi_clear", 1}, 
		{"gummi_grass", 1},
		{"gummi_green", 1},
		{"gummi_brown", 1},
		{"gummi_orange", 1},
		{"gummi_gold", 1},
		{"gummi_pink", 1},
		{"gummi_purple", 1},
		{"gummi_red", 1},
		{"gummi_royal", 1},
		{"gummi_silver", 1},
		{"gummi_white", 1},
		{"gummi_yellow", 1},
		{"gummi_sky", 1},
		{"gummi_gray", 1},
		{"gummi_magenta", 1},
		{"boost_calcium", 1},
		{"boost_protein", 1},
		{"boost_hp_up", 1},
		{"boost_zinc", 1},
		{"boost_carbos", 1},
		{"boost_iron", 1},
		{"boost_nectar", 1}
		
	},
	--includes seeds and berries
	SEED_LOW = {
		{'seed_blast', 5},
		{'seed_reviver', 5},
		{'seed_sleep', 5},
		{'seed_warp', 5},
		{'berry_oran', 5},
		{'berry_leppa', 5},
		{'berry_sitrus', 5},
		{'berry_pecha', 5},
		{'berry_cheri', 5},
		{'berry_rawst', 5},
		{'berry_aspear', 5},
		{'berry_chesto', 5},
		{'berry_persim', 5},
		{'berry_lum', 5}
	},
	
	--includes seeds and berries
	SEED_HIGH = {
		{'seed_reviver', 5},
		{'seed_pure', 5},
		{'seed_joy', 2},
		{'berry_sitrus', 5},
		{'berry_lum', 5}
	}, 
	
	HELD_LOW = {
		{'held_power_band', 5},
		{'held_special_band', 5},
		{'held_defense_scarf', 5},
		{'held_zinc_band', 5},
		
		{'held_pecha_scarf', 5},
		{'held_cheri_scarf', 5},
		{'held_rawst_scarf', 5},
		{'held_aspear_scarf', 5},
		{'held_insomniascope', 5},
		{'held_persim_band', 5},
		
		{'held_warp_scarf', 5}
	},
	
	HELD_HIGH = {
		{'held_friend_bow', 2},
		{'held_mobile_scarf', 2},
		{'held_cover_band', 5},
		{'held_scope_lens', 5},
		{'held_trap_scarf', 5},
		{'held_reunion_cape', 5},
		{'held_pierce_band', 5},
		{'held_heal_ribbon', 5},
		{'held_goggle_specs', 5},
		{'held_x_ray_specs', 5},
		{'held_twist_band', 5}
	},
	
	TM_LOW = {
		{'tm_snatch', 5},
		{'tm_sunny_day', 5},
		{'tm_rain_dance', 5},
		{'tm_sandstorm', 5},
		{'tm_hail', 5},
		{'tm_taunt', 5},
		
		{'tm_safeguard', 5},
		{'tm_light_screen', 5},
		{'tm_dream_eater', 5},
		{'tm_nature_power', 5},
		{'tm_swagger', 5},
		{'tm_captivate', 5},
		{'tm_fling', 5},
		{'tm_payback', 5},
		{'tm_reflect', 5},
		{'tm_rock_polish', 5},
		{'tm_pluck', 5},
		{'tm_psych_up', 5},
		{'tm_secret_power', 5},

		{'tm_return', 5},
		{'tm_frustration', 5},
		{'tm_torment', 5},
		{'tm_endure', 5},
		{'tm_echoed_voice', 5},
		{'tm_gyro_ball', 5},
		{'tm_recycle', 5},
		{'tm_false_swipe', 5},
		{'tm_defog', 5},
		{'tm_telekinesis', 5},
		{'tm_double_team', 5},
		{'tm_thunder_wave', 5},
		{'tm_attract', 5},
		{'tm_smack_down', 5},
		{'tm_snarl', 5},
		{'tm_flame_charge', 5},

		{'tm_protect', 5},
		{'tm_round', 5},
		{'tm_rest', 5},
		{'tm_thief', 5},
		{'tm_cut', 5},
		{'tm_whirlpool', 5},
		{'tm_infestation', 5},
		{'tm_roar', 5},
		{'tm_flash', 5},
		{'tm_embargo', 5},
		{'tm_struggle_bug', 5},
		{'tm_quash', 5}},
		
	TM_MID = {

		{'tm_explosion', 5},
		{'tm_will_o_wisp', 5},
		{'tm_facade', 5},
		{'tm_water_pulse', 5},
		{'tm_shock_wave', 5},
		{'tm_brick_break', 5},
		{'tm_calm_mind', 5},
		{'tm_charge_beam', 5},
		{'tm_retaliate', 5},
		{'tm_roost', 5},
		{'tm_acrobatics', 5},
		{'tm_bulk_up', 5},


		{'tm_shadow_claw', 5},

		{'tm_steel_wing', 5},
		{'tm_snarl', 5},
		{'tm_bulldoze', 5},
		{'tm_substitute', 5},
		{'tm_brine', 5},
		{'tm_venoshock', 5},
		{'tm_u_turn', 5},
		{'tm_aerial_ace', 5},
		{'tm_hone_claws', 5},
		{'tm_rock_smash', 5},

		{'tm_hidden_power', 5},
		{'tm_rock_tomb', 5},
		{'tm_strength', 5},
		{'tm_grass_knot', 5},
		{'tm_power_up_punch', 5},
		{'tm_work_up', 5},
		{'tm_incinerate', 5},
		{'tm_bullet_seed', 5},
		{'tm_low_sweep', 5},
		{'tm_volt_switch', 5},
		{'tm_avalanche', 5},
		{'tm_dragon_tail', 5},
		{'tm_silver_wind', 5},
		{'tm_frost_breath', 5},
		{'tm_sky_drop', 5}},
	TM_HIGH = {
		{'tm_earthquake', 5},
		{'tm_hyper_beam', 5},
		{'tm_overheat', 5},
		{'tm_blizzard', 5},
		{'tm_swords_dance', 5},
		{'tm_surf', 5},
		{'tm_dark_pulse', 5},
		{'tm_psychic', 5},
		{'tm_thunder', 5},
		{'tm_shadow_ball', 5},
		{'tm_ice_beam', 5},
		{'tm_giga_impact', 5},
		{'tm_fire_blast', 5},
		{'tm_dazzling_gleam', 5},
		{'tm_flash_cannon', 5},
		{'tm_stone_edge', 5},
		{'tm_sludge_bomb', 5},
		{'tm_focus_blast', 5},

		{'tm_x_scissor', 5},
		{'tm_wild_charge', 5},
		{'tm_focus_punch', 5},
		{'tm_psyshock', 5},
		{'tm_rock_slide', 5},
		{'tm_thunderbolt', 5},
		{'tm_flamethrower', 5},
		{'tm_energy_ball', 5},
		{'tm_scald', 5},
		{'tm_waterfall', 5},
		{'tm_rock_climb', 5},

		{'tm_giga_drain', 5},
		{'tm_dive', 5},
		{'tm_poison_jab', 5},
	
		{'tm_iron_tail', 5},
	
		{'tm_dig', 5},
		{'tm_fly', 5},
		{'tm_dragon_claw', 5},
		{'tm_dragon_pulse', 5},
		{'tm_sludge_wave', 5},
		{'tm_drain_punch', 5}},
	--additional, special, unique rewards. todo
	SPECIAL = {}
}

MISSION_GEN.SPECIAL_CLIENT_RIVAL = "RIVAL"
MISSION_GEN.SPECIAL_CLIENT_CHILD = "CHILD"
MISSION_GEN.SPECIAL_CLIENT_LOVER = "LOVER"
MISSION_GEN.SPECIAL_CLIENT_FRIEND = "FRIEND"


MISSION_GEN.SPECIAL_CLIENT_OPTIONS = {
	MISSION_GEN.SPECIAL_CLIENT_LOVER,
	MISSION_GEN.SPECIAL_CLIENT_RIVAL,
	MISSION_GEN.SPECIAL_CLIENT_CHILD,
	MISSION_GEN.SPECIAL_CLIENT_FRIEND
}

--Order matters for these! First is the client, second is the target
--Titles are random from a small list. Each pair has a unique body text however included in the data below.
--Number represents that mon's gender, 1 for male, 2 for female, 0 for genderless
MISSION_GEN.SPECIAL_LOVER_PAIRS = {
	TIER_LOW = {
		{'volbeat', 1, 'illumise', 2, "MISSION_BODY_SPECIAL_LOVER_001"},
		{'minun', 1, 'plusle', 2, "MISSION_BODY_SPECIAL_LOVER_002"},
		{'mareep', 2, 'wooloo', 1, "MISSION_BODY_SPECIAL_LOVER_003"},
		{'luvdisc', 2, 'luvdisc', 2, "MISSION_BODY_SPECIAL_LOVER_004"}	
	},
	TIER_MID = {
		{'miltank', 2, 'tauros', 1, "MISSION_BODY_SPECIAL_LOVER_005"},
		{'venomoth', 1, 'butterfree', 2, "MISSION_BODY_SPECIAL_LOVER_006"},
		{'liepard', 2, 'persian', 1, "MISSION_BODY_SPECIAL_LOVER_007"},
		{'dustox', 1, 'beautifly', 2, "MISSION_BODY_SPECIAL_LOVER_008"},
		{'glalie', 1, 'froslass', 2, "MISSION_BODY_SPECIAL_LOVER_009"},
		{'ribombee', 2, 'masquerain', 1, "MISSION_BODY_SPECIAL_LOVER_010"},
		{'maractus', 2, 'cacturne', 1, "MISSION_BODY_SPECIAL_LOVER_011"},---my prickly love!
		{'lanturn', 1, 'lumineon', 2, "MISSION_BODY_SPECIAL_LOVER_012"}
	},
	TIER_HIGH = {
		{'tyranitar', 1, 'altaria', 2, "MISSION_BODY_SPECIAL_LOVER_013"},--reference to an old idea i had
		{'gyarados', 1, 'milotic', 2, "MISSION_BODY_SPECIAL_LOVER_014"},
		{'gardevoir', 2, 'gallade', 1, "MISSION_BODY_SPECIAL_LOVER_015"}
	}

}

MISSION_GEN.SPECIAL_CHILD_PAIRS = {
	TIER_LOW = {
		{'clefable', 2, 'cleffa', 2, "MISSION_BODY_SPECIAL_CHILD_001"},
		{'wigglytuff', 1, 'igglybuff', 1, "MISSION_BODY_SPECIAL_CHILD_002"},
		{'togekiss', 2, 'togepi', 1, "MISSION_BODY_SPECIAL_CHILD_003"},
		{'roserade', 2, 'budew', 2, "MISSION_BODY_SPECIAL_CHILD_004"},
		{'chimecho', 2, 'chingling', 1, "MISSION_BODY_SPECIAL_CHILD_005"},
		{'sudowoodo', 1, 'bonsly', 1, "MISSION_BODY_SPECIAL_CHILD_006"},
		{'mr_mime', 1, 'mime_jr', 1, "MISSION_BODY_SPECIAL_CHILD_007"},
		{'raticate', 1, 'rattata', 2, "MISSION_BODY_SPECIAL_CHILD_008"},--hes still not so good at gnawing!
		{'leavanny', 2, 'sewaddle', 2, "MISSION_BODY_SPECIAL_CHILD_009"}
	},
	TIER_MID = {
		{'appletun', 2, 'applin', 1, "MISSION_BODY_SPECIAL_CHILD_010"},
		{'aggron', 1, 'aron', 1, "MISSION_BODY_SPECIAL_CHILD_011"},--probably munched too much metal!
		{'jynx', 2, 'smoochum', 2, "MISSION_BODY_SPECIAL_CHILD_012"},
		{'magmortar', 2, 'magby', 2, "MISSION_BODY_SPECIAL_CHILD_013"},
		{'electivire', 1, 'elekid', 1, "MISSION_BODY_SPECIAL_CHILD_014"},
		{'tsareena', 2, 'bounsweet', 2, "MISSION_BODY_SPECIAL_CHILD_015"},
		{'hatterene', 2, 'hatenna', 2, "MISSION_BODY_SPECIAL_CHILD_016"},
		{'gothitelle', 2, 'gothita', 2, "MISSION_BODY_SPECIAL_CHILD_017"},
		{'dugtrio', 1, 'diglett', 1, "MISSION_BODY_SPECIAL_CHILD_018"}
	},	
	TIER_HIGH = {
		{'tyranitar', 2, 'larvitar', 1, "MISSION_BODY_SPECIAL_CHILD_019"},
		{'salamence', 1, 'bagon', 2, "MISSION_BODY_SPECIAL_CHILD_020"},
		{'dragonite', 2, 'dratini', 2, "MISSION_BODY_SPECIAL_CHILD_021"},
		{'noivern', 1, 'noibat', 1, "MISSION_BODY_SPECIAL_CHILD_022"},
		{'goodra', 2, 'goomy', 1, "MISSION_BODY_SPECIAL_CHILD_023"}
	}
	
	
	
	
}

MISSION_GEN.SPECIAL_FRIEND_PAIRS = {
	TIER_LOW = {
		{'applin', 1, 'cherubi', 2, "MISSION_BODY_SPECIAL_FRIEND_001"},--We both get mistaken for fruit! What if someone ate him!?
		{'mantyke', 2, 'remoraid', 1, "MISSION_BODY_SPECIAL_FRIEND_002"},--My best friend is missing! I'll never be able to evolve without him!
		{'magikarp', 1, 'feebas', 2, "MISSION_BODY_SPECIAL_FRIEND_003"},--feebas is the only one who understands what it's like to be dogshit!
		{'poliwag', 2, 'lotad', 1, "MISSION_BODY_SPECIAL_FRIEND_004"},--frog and his lilypad. I have no lilypad now, save him!
		{'teddiursa', 1, 'combee', 2, "MISSION_BODY_SPECIAL_FRIEND_005"}, --Without Combee, I have no honey! Please find them!
		{'woobat', 2, 'zubat', 1, "MISSION_BODY_SPECIAL_FRIEND_006"},--we both use ultrasonic waves to see!
		{'trubbish', 1, 'grimer', 1, "MISSION_BODY_SPECIAL_FRIEND_007"},--we both love eating garbage!
		{'shroomish', 1, 'paras', 1, "MISSION_BODY_SPECIAL_FRIEND_008"},--we both love to spread spores!
		{'chansey', 2, 'togepi', 2, "MISSION_BODY_SPECIAL_FRIEND_009"},--cares for togepi because its an egg
		{'salandit', 1, 'combee', 1, "MISSION_BODY_SPECIAL_FRIEND_010"}--they relate in being useless
	},
	TIER_MID = {
		{'lunatone', 0, 'solrock', 0, "MISSION_BODY_SPECIAL_FRIEND_011"},
		{'emolga', 2, 'pachirisu', 2, "MISSION_BODY_SPECIAL_FRIEND_012"},
		{'spinda', 2, 'hypno', 1, "MISSION_BODY_SPECIAL_FRIEND_013"}, --Hypno went missing; only he can help stop my dizziness
		{'cramorant', 1, 'pelipper', 2, "MISSION_BODY_SPECIAL_FRIEND_014"},
		{'magnemite', 0, 'nosepass', 1, "MISSION_BODY_SPECIAL_FRIEND_015"},--We're both sensitive to magnetism!
		{'dustox', 1, 'lampent', 2, "MISSION_BODY_SPECIAL_FRIEND_016"}
	},
	TIER_HIGH = {
		{'lilligant', 2, 'kricketune', 1, "MISSION_BODY_SPECIAL_FRIEND_017"},--I can't dance without Kricketune's music!
		{'wigglytuff', 2, 'exploud', 1, "MISSION_BODY_SPECIAL_FRIEND_018"}, --we love making loud, silly noises together!
		{'beedrill', 1, 'florges', 2, "MISSION_BODY_SPECIAL_FRIEND_019"},--without my flower, i have no meaning!
		{'dunsparce', 1, 'dugtrio', 1, "MISSION_BODY_SPECIAL_FRIEND_020"},--we both love to burrow!
		{'whimsicott', 2, 'jumpluff', 2, "MISSION_BODY_SPECIAL_FRIEND_021"}
	}
}

MISSION_GEN.SPECIAL_RIVAL_PAIRS = {
	TIER_LOW = {
		{'koffing', 1, 'stunky', 2, "MISSION_BODY_SPECIAL_RIVAL_001"},--they compete to see whose odor is stronger
		{'krabby', 1, 'corphish', 1, "MISSION_BODY_SPECIAL_RIVAL_002"},--compare claw strength
		{'shuppet', 2, 'duskull', 1, "MISSION_BODY_SPECIAL_RIVAL_003"},--we like to see who can pull better pranks!
		{'pidgey', 2, 'spearow', 2, "MISSION_BODY_SPECIAL_RIVAL_004"},--we compete at flying!
		{'kabuto', 1, 'omanyte', 1, "MISSION_BODY_SPECIAL_RIVAL_005"}, --we've been rivals since our ancestors' time!
		{'joltik', 2, 'spinarak', 1, "MISSION_BODY_SPECIAL_RIVAL_006"},--We like to see who can spin the better web!
		{'tyrogue', 1, 'makuhita', 1, "MISSION_BODY_SPECIAL_RIVAL_007"},--my punching bag training partner!
		{'lillipup', 2, 'poochyena', 1, "MISSION_BODY_SPECIAL_RIVAL_008"}

},
	
	TIER_MID = {
		{'vigoroth', 1, 'primeape', 1, "MISSION_BODY_SPECIAL_RIVAL_009"},--full of energy!
		{'sawsbuck', 1, 'stantler', 1, "MISSION_BODY_SPECIAL_RIVAL_010"},--butt antlers!
		{'jangmo_o', 1, 'axew', 1, "MISSION_BODY_SPECIAL_RIVAL_011"},
		{'mareanie', 2, 'corsola', 2, "MISSION_BODY_SPECIAL_RIVAL_012"}

	},
	
	TIER_HIGH = {
		{'heracross', 1, 'pinsir', 1, "MISSION_BODY_SPECIAL_RIVAL_013"},
		{'slowking', 1, 'slowbro', 1, "MISSION_BODY_SPECIAL_RIVAL_014"},--slowbro may not be as smart as me, but we're still great friends!
		{'magmortar', 2, 'electivire', 1, "MISSION_BODY_SPECIAL_RIVAL_015"}, --we need to settle who is stronger!
		{'cradily', 2, 'armaldo', 1, "MISSION_BODY_SPECIAL_RIVAL_016"}, --we've been rivals since our ancestors' time!
		{'bastiodon', 2, 'rampardos', 1, "MISSION_BODY_SPECIAL_RIVAL_017"}, --we've been rivals since our ancestors' time!
		{'archeops', 1, 'aerodactyl', 2, "MISSION_BODY_SPECIAL_RIVAL_018"}, --we've been rivals since our ancestors' time!
		{'swellow', 2, 'staraptor', 1, "MISSION_BODY_SPECIAL_RIVAL_019"}--brave birds!

	}
}



MISSION_GEN.SPECIAL_OUTLAW = {

}


MISSION_GEN.LOST_ITEMS = {
	"mission_lost_scarf",
	"mission_lost_specs",
	"mission_lost_band"
}

MISSION_GEN.STOLEN_ITEMS = {
	"mission_stolen_scarf",
	"mission_stolen_band",
	"mission_stolen_specs"
}

MISSION_GEN.DELIVERABLE_ITEMS = {
	"berry_oran",
	"berry_leppa",
	"food_apple",
	"berry_pecha",
	"berry_cheri"
}

--"order" of dungeons
MISSION_GEN.DUNGEON_ORDER = {}
MISSION_GEN.DUNGEON_ORDER[""] = 99999--empty missions should get shoved towards the end 
MISSION_GEN.DUNGEON_ORDER["relic_forest"] = 1
MISSION_GEN.DUNGEON_ORDER["illuminant_riverbed"] = 2
MISSION_GEN.DUNGEON_ORDER["crooked_cavern"] = 3
MISSION_GEN.DUNGEON_ORDER["apricorn_grove"] = 4



--Do the stairs go up or down? Blank string if up, B if down
MISSION_GEN.STAIR_TYPE = {}
MISSION_GEN.STAIR_TYPE[""] = ""
MISSION_GEN.STAIR_TYPE["relic_forest"] = ""
MISSION_GEN.STAIR_TYPE["illuminant_riverbed"] = ""
MISSION_GEN.STAIR_TYPE["crooked_cavern"] = "B"
MISSION_GEN.STAIR_TYPE["apricorn_grove"] = ""




function MISSION_GEN.WeightedRandom (weights)
    local summ = 0
    for i, value in pairs (weights) do
        summ = summ + value[2]
    end
    if summ == 0 then return end
    -- local value = math.random (summ) -- for integer weights only
    local rand = summ*math.random ()
    summ = 0
    for i, value in pairs (weights) do
        summ = summ + value[2]
        if rand <= summ then
            return value[1]--, weight
        end
    end
end


function MISSION_GEN.has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end



function MISSION_GEN.ResetBoards()
--jobs on the mission board.
SV.MissionBoard =
{
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	}

}

--Jobs on the outlaw board.
SV.OutlawBoard =
{
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	}
}

end

--Generate a board. Board_type should be given as "Mission" or "Outlaw".
--Job/Outlaw Boards should be cleared before being regenerated.
function MISSION_GEN.GenerateBoard(board_type)
	local jobs_to_make = math.random(5, 7)--Todo: jobs generated is based on your rank or how many dungeons you've done.
	local assigned_combos = {}--floor/dungeon combinations that already have had missions genned for it. Need to consider already genned missions and missions on taken board.
	

	-- All seen Pokemon in the pokedex
	--local seen_pokemon = {}

	--for entry in luanet.each(_DATA.Save.Dex) do
	--	if entry.Value == RogueEssence.Data.GameProgress.UnlockState.Discovered then
	--		table.insert(seen_pokemon, entry.Key)
	--	end
	--end

	--print( seen_pokemon[ math.random( #seen_pokemon ) ] )
	


	--default to mission.
	local mission_type = COMMON.MISSION_BOARD_MISSION
	if board_type == COMMON.MISSION_BOARD_OUTLAW then mission_type = COMMON.MISSION_BOARD_OUTLAW end
	
	--get list of potential dungeons for missions, remove any that haven't been completed yet.
	local dungeon_candidates = MISSION_GEN.ShallowCopy(MISSION_GEN.DUNGEON_LIST)
	for i = #dungeon_candidates, 1, -1 do
		if _DATA.Save:GetDungeonUnlock(dungeon_candidates[i]) ~= RogueEssence.Data.GameProgress.UnlockState.Completed then
			table.remove(dungeon_candidates, i)
		end
	end
	
	--failsafe. Just quit if no dungeons are eligible.
	if #dungeon_candidates == 0 then return end
	
	--generate jobs
	for i = 1, jobs_to_make, 1 do 
		--choose a dungeon, client, target, item, etc
		local dungeon = dungeon_candidates[math.random(1, #dungeon_candidates)]
		local client = ""
		local item = ""
		local special = ""
		local title = "Default title."
		local flavor = "Default flavor text.\nHow did you see this? Tell Palika, please!"


		--generate the objective.
		local objective 
		if mission_type == COMMON.MISSION_BOARD_OUTLAW then 
			local roll = math.random(1, 10)
			if roll <= 5 then
				objective = COMMON.MISSION_TYPE_OUTLAW
			elseif roll <= 8 then 
				objective = COMMON.MISSION_TYPE_OUTLAW_ITEM
			elseif roll <= 9 then 
				objective = COMMON.MISSION_TYPE_OUTLAW_MONSTER_HOUSE
			else
				objective = COMMON.MISSION_TYPE_OUTLAW_FLEE
			end
		else
			local roll = math.random(1, 10)
			if roll <= 2 then 
				--if there's already an escort or exploration mission generated for this dungeon, don't gen another one and just make it a rescue.
				if roll == 1 then
					objective = COMMON.MISSION_TYPE_EXPLORATION 
				else
					objective = COMMON.MISSION_TYPE_ESCORT
				end

				--only check from 1 to i-1 to save time.
				for j = 1, i-1, 1 do 
					if SV.MissionBoard[j].Zone == dungeon and (SV.MissionBoard[j].Type == COMMON.MISSION_TYPE_ESCORT or SV.MissionBoard[j].Type == COMMON.MISSION_TYPE_EXPLORATION) then
						objective = COMMON.MISSION_TYPE_RESCUE
						break
					end 
				end 
				
				for j = 1, 8, 1 do
					if SV.TakenBoard[j].Zone == dungeon and (SV.TakenBoard[j].Type == COMMON.MISSION_TYPE_ESCORT or SV.TakenBoard[j].Type == COMMON.MISSION_TYPE_EXPLORATION) then
						objective = COMMON.MISSION_TYPE_RESCUE
						break
					end
				end
			elseif roll <= 4 then
				objective = COMMON.MISSION_TYPE_DELIVERY
			elseif roll <= 6 then
				objective = COMMON.MISSION_TYPE_LOST_ITEM
			else
				objective = COMMON.MISSION_TYPE_RESCUE
			end
		end

		if objective == COMMON.MISSION_TYPE_DELIVERY then
			item = MISSION_GEN.DELIVERABLE_ITEMS[math.random(1, #MISSION_GEN.DELIVERABLE_ITEMS)]
		elseif objective == COMMON.MISSION_TYPE_OUTLAW_ITEM then
			item = MISSION_GEN.STOLEN_ITEMS[math.random(1, #MISSION_GEN.STOLEN_ITEMS)]
		elseif objective == COMMON.MISSION_TYPE_LOST_ITEM then
			item = MISSION_GEN.LOST_ITEMS[math.random(1, #MISSION_GEN.LOST_ITEMS)]
		end


		local difficulty = MISSION_GEN.DUNGEON_DIFFICULTY[dungeon]
		local offset = 0
		--up the difficulty by 1 if its an outlaw or escort mission.
		local difficult_objectives = { COMMON.MISSION_TYPE_ESCORT, COMMON.MISSION_TYPE_EXPLORATION, COMMON.MISSION_TYPE_OUTLAW, COMMON.MISSION_TYPE_OUTLAW_FLEE, COMMON.MISSION_TYPE_OUTLAW_ITEM }
		if GeneralFunctions.TableContains(difficult_objectives, objective) then
			offset = 1
		--up the difficulty by 2 if its an outlaw monster house
		elseif objective == COMMON.MISSION_TYPE_OUTLAW_MONSTER_HOUSE then
			offset = 2
		end
		difficulty = MISSION_GEN.ORDER_TO_DIFF[MISSION_GEN.DIFF_TO_ORDER[difficulty]+offset]
		
		
		
		--Generate a tier, then the client
		local tier = MISSION_GEN.WeightedRandom(MISSION_GEN.DIFF_POKEMON[difficulty])
		local client_candidates = MISSION_GEN.POKEMON[tier]
		client = client_candidates[math.random(1, #client_candidates)]
		
		--50% chance that the client and target are the same. Target is the escort if its an escort mission.
		--It is possible for this to roll the same target as the client again, which is fine.
		--Always give a target if objective is escort or a outlaw stole an item.
		--Target should always be client for 
		local target = client
		local target_candidates = MISSION_GEN.POKEMON[tier]
		if math.random(1, 2) == 1 or objective == COMMON.MISSION_TYPE_ESCORT or objective == COMMON.MISSION_TYPE_OUTLAW_ITEM then 
			target = target_candidates[math.random(1, #target_candidates)]	
			--print(target_candidates[1]) --to give an idea of what tier we rolled
		end
		
		--if its a generic outlaw mission, or a monster house / fleeing outlaw, Zhayn is the client. Normal mons only ask you to go after their stolen items.
		if objective == COMMON.MISSION_TYPE_OUTLAW or objective == COMMON.MISSION_TYPE_OUTLAW_FLEE or objective == COMMON.MISSION_TYPE_OUTLAW_MONSTER_HOUSE then
			client = "zhayn"
		end
		
		--if it's a delivery, exploration, or lost item, target and client should match.
		if objective == COMMON.MISSION_TYPE_EXPLORATION or objective == COMMON.MISSION_TYPE_DELIVERY or objective == COMMON.MISSION_TYPE_LOST_ITEM then
			target = client
		end
		
		
		--Reroll target if target is ghost and target is a fleeing outlaw, that shit would be too obnoxious to deal with
		local target_type_1 = _DATA:GetMonster(target).Forms[0].Element1
		local target_type_2 = _DATA:GetMonster(target).Forms[0].Element2
		while objective == COMMON.MISSION_TYPE_OUTLAW_FLEE and (target_type_1 == "ghost" or target_type_2 == "ghost") do
			print(target .. ": Rerolling cowardly ghost outlaw!!!")
			target = target_candidates[math.random(1, #target_candidates)]	
			target_type_1 = _DATA:GetMonster(target).Forms[0].Element1
			target_type_2 = _DATA:GetMonster(target).Forms[0].Element2
			print("new target is " .. target)
		end
		
		--Roll for genders. Use base form because it PROBABLY won't ever matter.
		--because Scriptvars doesnt like saving genders instead of regular structures, use 1/2/0 for m/f/genderless respectively, and convert when needed
		local client_gender
		
		if client == "zhayn" then--Zhayn is a special exception
			client_gender = 0
		else
			client_gender = _DATA:GetMonster(client).Forms[0]:RollGender(_ZONE.CurrentGround.Rand)
			client_gender = GeneralFunctions.GenderToNum(client_gender)
		end 
		
		local target_gender = _DATA:GetMonster(target).Forms[0]:RollGender(_ZONE.CurrentGround.Rand)
	
		target_gender = GeneralFunctions.GenderToNum(target_gender)

		--Special cases
		--Roll for the main 3 rescue special cases 
		if objective == COMMON.MISSION_TYPE_RESCUE and math.random(1, 10) <= 2 then
			local special_candidates = {}
			special = MISSION_GEN.SPECIAL_CLIENT_OPTIONS[math.random(1, #MISSION_GEN.SPECIAL_CLIENT_OPTIONS)]
			if special == MISSION_GEN.SPECIAL_CLIENT_CHILD then
				special_candidates = MISSION_GEN.SPECIAL_CHILD_PAIRS[tier]
			elseif special == MISSION_GEN.SPECIAL_CLIENT_LOVER then
				special_candidates = MISSION_GEN.SPECIAL_LOVER_PAIRS[tier]
			elseif special == MISSION_GEN.SPECIAL_CLIENT_RIVAL then
				special_candidates = MISSION_GEN.SPECIAL_RIVAL_PAIRS[tier]
			elseif special == MISSION_GEN.SPECIAL_CLIENT_FRIEND then
				special_candidates = MISSION_GEN.SPECIAL_FRIEND_PAIRS[tier]
			end
				
		
			--Set variables with special client/target info
			local special_choice = special_candidates[math.random(1, #special_candidates)]
			client = special_choice[1]
			client_gender = special_choice[2]
			target = special_choice[3]
			target_gender = special_choice[4]
			
			local special_title_candidates = MISSION_GEN.TITLES[special]
			title = RogueEssence.StringKey(special_title_candidates[math.random(1, #special_title_candidates)]):ToLocal()

			flavor = RogueEssence.StringKey(special_choice[5]):ToLocal()
			
	
		end


		
		
		--generate reward with hardcoded list of weighted rewards
		local reward = "money"
		--1/4 chance you get money instead of an item
		
		if math.random(1, 4) > 1 then 
			reward = MISSION_GEN.WeightedRandom(MISSION_GEN.REWARDS[MISSION_GEN.WeightedRandom(MISSION_GEN.DIFF_REWARDS[difficulty])])
		end
		
		--1/3 chance you get a bonus reward. Bonus reward is always an item, never money 
		local bonus_reward = ""
		
		if math.random(1,3) == 1 then 
			bonus_reward = MISSION_GEN.WeightedRandom(MISSION_GEN.REWARDS[MISSION_GEN.WeightedRandom(MISSION_GEN.DIFF_REWARDS[difficulty])])
		end 
		
		--get the zone, and max floors (counted floors of relevant segments)
		local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get(dungeon)
		
		
		--segment is typically 0. If needed, add more advanced logic here in the future to pick relevant segments for a given zone.
		local segment = 0
		


		--Choose a random title that's appropriate.
		local title_candidates = {}
		
		if special == "" then -- get title if special didn't already generate it
			if objective == COMMON.MISSION_TYPE_RESCUE and client ~= target then
				title_candidates = MISSION_GEN.TITLES["RESCUE_FRIEND"]
			elseif objective == COMMON.MISSION_TYPE_RESCUE and client == target then
				title_candidates = MISSION_GEN.TITLES["RESCUE_SELF"]
			elseif objective == COMMON.MISSION_TYPE_ESCORT then
				title_candidates = MISSION_GEN.TITLES["ESCORT"]
			elseif objective == COMMON.MISSION_TYPE_EXPLORATION then
				title_candidates = MISSION_GEN.TITLES["EXPLORATION"]
			elseif objective == COMMON.MISSION_TYPE_LOST_ITEM then
				title_candidates = MISSION_GEN.TITLES["LOST_ITEM"]
			elseif objective == COMMON.MISSION_TYPE_DELIVERY then
				title_candidates = MISSION_GEN.TITLES["DELIVERY"]
			elseif objective == COMMON.MISSION_TYPE_OUTLAW then
				title_candidates = MISSION_GEN.TITLES["OUTLAW"]
			elseif objective == COMMON.MISSION_TYPE_OUTLAW_ITEM then
				title_candidates = MISSION_GEN.TITLES["OUTLAW_ITEM"]
			elseif objective == COMMON.MISSION_TYPE_OUTLAW_MONSTER_HOUSE then
				title_candidates = MISSION_GEN.TITLES["OUTLAW_MONSTER_HOUSE"]
			elseif objective == COMMON.MISSION_TYPE_OUTLAW_FLEE then
				title_candidates = MISSION_GEN.TITLES["OUTLAW_FLEE"]			
			end
			title = RogueEssence.StringKey(title_candidates[math.random(1, #title_candidates)]):ToLocal()
			
			--string substitutions, if needed.
			if string.find(title, "%[target%]") then
				title = string.gsub(title, "%[target%]", _DATA:GetMonster(target):GetColoredName())
			end 
			
			if string.find(title, "%[dungeon%]") then
				title = string.gsub(title, "%[dungeon%]", _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get(dungeon):GetColoredName())
			end 
			
			if string.find(title, "%[item%]") then
				title = string.gsub(title, "%[item%]",  _DATA:GetItem(item):GetColoredName())
			end
		end 
		
		
		
		--Flavor text generation
		local flavor_top_candidates = {}
		local flavor_bottom_candidates = {}
		
		if special == "" then -- get flavor if special didn't already generate it 
			if objective == COMMON.MISSION_TYPE_RESCUE and client ~= target then
				flavor_top_candidates = MISSION_GEN.FLAVOR_TOP["RESCUE_FRIEND"]
				flavor_bottom_candidates = MISSION_GEN.FLAVOR_BOTTOM["RESCUE_FRIEND"]
			elseif objective == COMMON.MISSION_TYPE_RESCUE and client == target then
				flavor_top_candidates = MISSION_GEN.FLAVOR_TOP["RESCUE_SELF"]
				flavor_bottom_candidates = MISSION_GEN.FLAVOR_BOTTOM["RESCUE_SELF"]
			elseif objective == COMMON.MISSION_TYPE_ESCORT then
				flavor_top_candidates = MISSION_GEN.FLAVOR_TOP["ESCORT"]
				flavor_bottom_candidates = MISSION_GEN.FLAVOR_BOTTOM["ESCORT"]
			elseif objective == COMMON.MISSION_TYPE_EXPLORATION then
				flavor_top_candidates = MISSION_GEN.FLAVOR_TOP["EXPLORATION"]
				flavor_bottom_candidates = MISSION_GEN.FLAVOR_BOTTOM["EXPLORATION"]
			elseif objective == COMMON.MISSION_TYPE_LOST_ITEM then
				flavor_top_candidates = MISSION_GEN.FLAVOR_TOP["LOST_ITEM"]
				flavor_bottom_candidates = MISSION_GEN.FLAVOR_BOTTOM["LOST_ITEM"]
			elseif objective == COMMON.MISSION_TYPE_DELIVERY then
				flavor_top_candidates = MISSION_GEN.FLAVOR_TOP["DELIVERY"]
				flavor_bottom_candidates = MISSION_GEN.FLAVOR_BOTTOM["DELIVERY"]
			elseif objective == COMMON.MISSION_TYPE_OUTLAW then
				flavor_top_candidates = MISSION_GEN.FLAVOR_TOP["OUTLAW"]
				flavor_bottom_candidates = MISSION_GEN.FLAVOR_BOTTOM["OUTLAW"]
			elseif objective == COMMON.MISSION_TYPE_OUTLAW_ITEM then
				flavor_top_candidates = MISSION_GEN.FLAVOR_TOP["OUTLAW_ITEM"]
				flavor_bottom_candidates = MISSION_GEN.FLAVOR_BOTTOM["OUTLAW_ITEM"]
			elseif objective == COMMON.MISSION_TYPE_OUTLAW_MONSTER_HOUSE then
				flavor_top_candidates = MISSION_GEN.FLAVOR_TOP["OUTLAW_MONSTER_HOUSE"]
				flavor_bottom_candidates = MISSION_GEN.FLAVOR_BOTTOM["OUTLAW_MONSTER_HOUSE"]
			elseif objective == COMMON.MISSION_TYPE_OUTLAW_FLEE then
				flavor_top_candidates = MISSION_GEN.FLAVOR_TOP["OUTLAW_FLEE"]
				flavor_bottom_candidates = MISSION_GEN.FLAVOR_BOTTOM["OUTLAW_FLEE"]
			end
			flavor = RogueEssence.StringKey(flavor_top_candidates[math.random(1, #flavor_top_candidates)]):ToLocal() .. '\n' .. RogueEssence.StringKey(flavor_bottom_candidates[math.random(1, #flavor_bottom_candidates)]):ToLocal()
		
			--string substitutions, if needed.
			if string.find(flavor, "%[target%]") then
				flavor = string.gsub(flavor, "%[target%]", _DATA:GetMonster(target):GetColoredName())
			end
			
			if string.find(flavor, "%[dungeon%]") then
				flavor = string.gsub(flavor, "%[dungeon%]", _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get(dungeon):GetColoredName())
			end
						
			if string.find(flavor, "%[item%]") then
				flavor = string.gsub(flavor, "%[item%]",  _DATA:GetItem(item):GetColoredName())
			end
			
		end 



		
		--mission floor should be in last 45% of the dungeon
		--don't pick a floor that's already been chosen for another mission in a dungeon
		--It's smart; it'll only randomly choose floors that haven't been used up yet. If all floors are used up that are possible, only then is the job thrown out.
		local used_floors = {}
		for j = 1, 8, 1 do 
			if SV.OutlawBoard[j].Zone == dungeon then
				table.insert(used_floors, 1, SV.OutlawBoard[j].Floor)
			end
			if SV.MissionBoard[j].Zone == dungeon then
				table.insert(used_floors, 1, SV.MissionBoard[j].Floor)
			end
			if SV.TakenBoard[j].Zone == dungeon then
				table.insert(used_floors, 1, SV.TakenBoard[j].Floor)
			end
		end
				
		local floor_candidates = MISSION_GEN.Generate_List_Range(math.floor(zone.CountedFloors * .55), zone.CountedFloors)
		MISSION_GEN.array_sub(used_floors, floor_candidates)	
		 
		

		local mission_floor = -1
		if #floor_candidates > 0 then
			mission_floor = floor_candidates[math.random(1, #floor_candidates)]
		end
		
		if mission_floor == -1 then print("Can't generate job, no more floors available!") end
		
		--don't generate this particular job slot if no more are available for the dungeon.
		if mission_floor ~= -1 then 
			if mission_type == COMMON.MISSION_BOARD_OUTLAW then
				SV.OutlawBoard[i].Client = client
				SV.OutlawBoard[i].Target = target
				SV.OutlawBoard[i].Flavor = flavor
				SV.OutlawBoard[i].Title = title
				SV.OutlawBoard[i].Zone = dungeon
				SV.OutlawBoard[i].Segment = segment
				SV.OutlawBoard[i].Reward = reward
				SV.OutlawBoard[i].Floor = mission_floor
				SV.OutlawBoard[i].Type = objective
				SV.OutlawBoard[i].Completion = MISSION_GEN.INCOMPLETE
				SV.OutlawBoard[i].Taken = false
				SV.OutlawBoard[i].Difficulty = difficulty
				SV.OutlawBoard[i].Item = item
				SV.OutlawBoard[i].Special = special
				SV.OutlawBoard[i].ClientGender = client_gender
				SV.OutlawBoard[i].TargetGender = target_gender
				SV.OutlawBoard[i].BonusReward = bonus_reward
			else 
				SV.MissionBoard[i].Client = client
				SV.MissionBoard[i].Target = target
				SV.MissionBoard[i].Flavor = flavor
				SV.MissionBoard[i].Title = title
				SV.MissionBoard[i].Zone = dungeon
				SV.MissionBoard[i].Segment = segment
				SV.MissionBoard[i].Reward = reward
				SV.MissionBoard[i].Floor = mission_floor
				SV.MissionBoard[i].Type = objective
				SV.MissionBoard[i].Completion = MISSION_GEN.INCOMPLETE
				SV.MissionBoard[i].Taken = false
				SV.MissionBoard[i].Difficulty = difficulty
				SV.MissionBoard[i].Item = item
				SV.MissionBoard[i].Special = special		
				SV.MissionBoard[i].ClientGender = client_gender
				SV.MissionBoard[i].TargetGender = target_gender
				SV.MissionBoard[i].BonusReward = bonus_reward
			end
		end
			
	end
	
end

function MISSION_GEN.JobSortFunction(j1, j2)
	--if they're the same dungeon, then check floors. Otherwise, dungeon order takes presidence. 
	if MISSION_GEN.DUNGEON_ORDER[j1.Zone] == MISSION_GEN.DUNGEON_ORDER[j2.Zone] then
		return j1.Floor < j2.Floor 
	else 
		return MISSION_GEN.DUNGEON_ORDER[j1.Zone] < MISSION_GEN.DUNGEON_ORDER[j2.Zone]
	end
end

--used to get the minus of one list minus another list
function MISSION_GEN.array_sub(t1, t2)
  local t = {}
  for i = 1, #t1 do
    t[t1[i]] = true;
  end
  for i = #t2, 1, -1 do
    if t[t2[i]] then
      table.remove(t2, i);
    end
  end
end

--used to get an array of a range. For figuring out floor candidates
function MISSION_GEN.Generate_List_Range(low, up)
	local array = {}
	local count = 1
	for i = low, up, 1 do
		array[count] = i
		count = count + 1
	end
	return array
end

function MISSION_GEN.SortTaken()
	table.sort(SV.TakenBoard, MISSION_GEN.JobSortFunction)
end

function MISSION_GEN.SortMission()
	table.sort(SV.MissionBoard, MISSION_GEN.JobSortFunction)
end

function MISSION_GEN.SortOutlaw()
	table.sort(SV.OutlawBoard, MISSION_GEN.JobSortFunction)
end

--Used to copy job from one board to another (mainly for taking jobs)
function MISSION_GEN.ShallowCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end


JobMenu = Class('JobMenu')

--jobs is a job board 
--job type should be taken, mission, or outlaw
--job number should be 1-8
function JobMenu:initialize(job_type, job_number, parent_board_menu)
  assert(self, "JobMenu:initialize(): Error, self is nil!")
  self.menu = RogueEssence.Menu.ScriptableMenu(32, 32, 256, 176, function(input) self:Update(input) end)
  --self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(jobs[i], RogueElements.Loc(16, 8 + 14 * (i-1))))
    
  local job 
  
  self.job_number = job_number
  
  self.job_type = job_type
  
  self.parent_board_menu = parent_board_menu
  
  --get relevant board
  local job
  if job_type == COMMON.MISSION_BOARD_TAKEN then
		job = SV.TakenBoard[job_number]
  elseif job_type == COMMON.MISSION_BOARD_OUTLAW then
  	job = SV.OutlawBoard[job_number]
  else --default to mission board
  	job = SV.MissionBoard[job_number]
  end
  
  self.taken = job.Taken
  
  self.flavor = job.Flavor
  --Zhayn is the only non-species name that'll show up here. So he is hardcoded in as an exception here.
  --TODO: Unhardcode this by adding in a check if string is not empty and if its not a species name, then add the color coding around it for  proper names.
  self.client = ""
  if job.Client == 'zhayn' then 
	self.client = '[color=#00FFFF]Zhayn[color]' 
  elseif job.Client ~= "" then 
	self.client = _DATA:GetMonster(job.Client):GetColoredName() 
  end

  self.target = ""
  if job.Target ~= '' then self.target = _DATA:GetMonster(job.Target):GetColoredName() end
  
	self.item = ""
	if job.Item ~= '' then self.item = _DATA:GetItem(job.Item):GetColoredName() end
  
  self.objective = ""
  self.type = job.Type
  self.taken_count = MISSION_GEN.GetTakenCount()
  
  if self.type == COMMON.MISSION_TYPE_RESCUE then
		self.objective = "Rescue " .. self.target .. "."
  elseif self.type == COMMON.MISSION_TYPE_ESCORT then
    self.objective = "Escort " .. self.client .. " to " .. self.target .. "."
	elseif self.type == COMMON.MISSION_TYPE_EXPLORATION then
		self.objective = "Explore with " .. self.client .. "."
  elseif self.type == COMMON.MISSION_TYPE_OUTLAW or self.type == COMMON.MISSION_TYPE_OUTLAW_FLEE or self.type == COMMON.MISSION_TYPE_OUTLAW_MONSTER_HOUSE then 
		self.objective = "Arrest " .. self.target .. "."
	elseif self.type == COMMON.MISSION_TYPE_LOST_ITEM then 
		self.objective = "Find " .. self.item .. " for " .. self.client .. "."
	elseif self.type == COMMON.MISSION_TYPE_DELIVERY then 
		self.objective = "Deliver " .. self.item .. " to " .. self.client .. "."
  elseif self.type == COMMON.MISSION_TYPE_OUTLAW_ITEM then 
		self.objective = "Reclaim " .. self.item .. " from " .. self.target .. "."
  end
  
  
  self.zone = ""
  if job.Zone ~= "" then self.zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get(job.Zone):GetColoredName() end
  
  self.floor = ""
  if job.Floor ~= -1 then self.floor = MISSION_GEN.STAIR_TYPE[job.Zone] .. '[color=#00FFFF]' .. tostring(job.Floor) .. "[color]F" end
  
  self.difficulty = ""
  if job.Difficulty ~= "" then self.difficulty = MISSION_GEN.DIFF_TO_COLOR[job.Difficulty] .. job.Difficulty .. "[color]   (" .. tostring(MISSION_GEN.DIFFICULTY[job.Difficulty]) .. ")" end 
  
  
  
  
  self.reward = ""
  if job.Reward ~= '' then
	--special case for money
	if job.Reward == "money" then
		self.reward = '[color=#00FFFF]' .. MISSION_GEN.DIFF_TO_MONEY[job.Difficulty] .. '[color]' .. STRINGS:Format("\\uE024")
	else 
		self.reward = RogueEssence.Dungeon.InvItem(job.Reward, false, RogueEssence.Data.DataManager.Instance:GetItem(job.Reward).MaxStack):GetDisplayName()
    end
  end
  
  --add in the ??? for a bonus reward if one exists
  if job.BonusReward ~= "" then
	self.reward = self.reward .. ' + ?'
  end
  
  
	self:DrawJob()
  

end

function JobMenu:DrawJob()
  --Standard menu divider. Reuse this whenever you need a menu divider at the top for a title.
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuDivider(RogueElements.Loc(8, 8 + 12), self.menu.Bounds.Width - 8 * 2))

  --Standard title. Reuse this whenever a title is needed.
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText("Job Summary", RogueElements.Loc(16, 8)))
  
  --Accepted element 
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuDivider(RogueElements.Loc(8, self.menu.Bounds.Height - 24), self.menu.Bounds.Width - 8 * 2))
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText("Accepted: " .. self.taken_count .. "/8", RogueElements.Loc(96, self.menu.Bounds.Height - 20)))


  
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(self.flavor, RogueElements.Loc(16, 24)))
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText("Client:", RogueElements.Loc(16, 54)))
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText("Objective:", RogueElements.Loc(16, 68)))
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText("Place:", RogueElements.Loc(16, 82)))
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText("Difficulty:", RogueElements.Loc(16, 96)))
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText("Reward:", RogueElements.Loc(16, 110))) 

  local client = self.client 
  --Don't show "Zhayn" if the nickname mod is enabled. Need to still save it internally as Zhayn though for other processes.
  if not CONFIG.UseNicknames then
	client = string.gsub(client, "Zhayn", "Bisharp")
  end
  
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(client, RogueElements.Loc(68, 54)))
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(self.objective, RogueElements.Loc(68, 68)))
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(self.zone .. " " .. self.floor, RogueElements.Loc(68, 82)))
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(self.difficulty, RogueElements.Loc(68, 96)))
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(self.reward, RogueElements.Loc(68, 110)))
end 



--for use with submenu
function JobMenu:DeleteJob()
	local mission = SV.TakenBoard[self.job_number]
	local back_ref = mission.BackReference
	if back_ref > 0 and back_ref ~= nil then
		local outlaw_arr = {
			COMMON.MISSION_TYPE_OUTLAW,
			COMMON.MISSION_TYPE_OUTLAW_ITEM,
			COMMON.MISSION_TYPE_OUTLAW_FLEE,
			COMMON.MISSION_TYPE_OUTLAW_MONSTER_HOUSE
		}

		if GeneralFunctions.TableContains(outlaw_arr, mission.Type) then 
			SV.OutlawBoard[back_ref].Taken = false
		else
			SV.MissionBoard[back_ref].Taken = false
		end
	end 
	
	SV.TakenBoard[self.job_number] = {
										Client = "",
										Target = "",
										Flavor = "",
										Title = "",
										Zone = "",
										Segment = -1,
										Floor = -1,
										Reward = "",
										Type = -1,
										Completion = -1,
										Taken = false,
										Difficulty = "",
										Item = "",
										Special = "",
										ClientGender = -1,
										TargetGender = -1,
										BonusReward = "",
										BackReference = -1
									}
	
	MISSION_GEN.SortTaken()
	if self.parent_board_menu ~= nil then 
		--redraw board with potentially changed information from job board
		self.parent_board_menu.menu.MenuElements:Clear()
		self.parent_board_menu:RefreshSelf()
		self.parent_board_menu:DrawBoard()
		
		--redraw selection board with potentially changed information
		if self.parent_board_menu.parent_selection_menu ~= nil then 
			self.parent_board_menu.parent_selection_menu.menu.MenuElements:Clear()
			self.parent_board_menu.parent_selection_menu:DrawMenu()
		end
		
	end
	_MENU:RemoveMenu()
	
	--If we accessed the job via the main menu, then close the main menu if we've deleted our last job. Only need it here because only on total job deletion should the main menu ever need to change.
	if self.parent_board_menu.parent_main_menu ~= nil then 
		if self.taken_count == 1 then--1 instead of 0 as the taken_count of the last job that was just deleted would be 1
			_MENU:RemoveMenu()
		end
	end
	
end

--for use with submenu
--flips taken status of self, and also updates the appropriate SV var's taken value
function JobMenu:FlipTakenStatus()
	self.taken = not self.taken
	if self.job_type == COMMON.MISSION_BOARD_TAKEN then
		SV.TakenBoard[self.job_number].Taken = self.taken
	elseif self.job_type == COMMON.MISSION_BOARD_OUTLAW then
		SV.OutlawBoard[self.job_number].Taken = self.taken
	else 
		SV.MissionBoard[self.job_number].Taken = self.taken
	end
	if self.parent_board_menu ~= nil then 
		--redraw board with potentially changed information from job board
		self.parent_board_menu.menu.MenuElements:Clear()
		self.parent_board_menu:RefreshSelf()
		self.parent_board_menu:DrawBoard()
	end
end 

--for use with submenu
--adds the current job to the taken board, then sorts it. Then close the menu
function JobMenu:AddJobToTaken()
	--this should already be true if we get to this point, but just in case, check if the last job slot is empty
	if SV.TakenBoard[8].Client == "" then
		if self.job_type == COMMON.MISSION_BOARD_OUTLAW then
			--Need to copy the table rather than just pass the pointer, or you can dupe missions which is not good
			SV.TakenBoard[8] = MISSION_GEN.ShallowCopy(SV.OutlawBoard[self.job_number])
		elseif self.job_type == COMMON.MISSION_BOARD_MISSION then
			SV.TakenBoard[8] = MISSION_GEN.ShallowCopy(SV.MissionBoard[self.job_number])
		end 
		SV.TakenBoard[8].BackReference = self.job_number
		MISSION_GEN.SortTaken()
	end
	
	if self.parent_board_menu ~= nil then 
		--redraw board with potentially changed information from job board
		self.parent_board_menu.menu.MenuElements:Clear()
		self.parent_board_menu:RefreshSelf()
		self.parent_board_menu:DrawBoard()
		
		--redraw selection board with potentially changed information
		if self.parent_board_menu.parent_selection_menu ~= nil then 
			self.parent_board_menu.parent_selection_menu.menu.MenuElements:Clear()
			self.parent_board_menu.parent_selection_menu:DrawMenu()
		end
	end
	

	_MENU:RemoveMenu()
end

function JobMenu:OpenSubMenu()
	if self.job_type ~= COMMON.MISSION_BOARD_TAKEN and self.taken then 
		--This is a job from the board that was already taken!
	else 
		--create prompt menu
		local choices = {}
		--print(self.job_type .. " taken: " .. tostring(self.taken))
		if self.job_type == COMMON.MISSION_BOARD_TAKEN then
			local choice_str = "Take Job"
			if self.taken then
				choice_str = 'Suspend'
			end
			choices = {	{choice_str, true, function() self:FlipTakenStatus() _MENU:RemoveMenu() _MENU:RemoveMenu() end},
						{"Delete", true, function() self:DeleteJob() _MENU:RemoveMenu() end},
						{"Cancel", true, function() _MENU:RemoveMenu() _MENU:RemoveMenu() end} }
			
		else --outlaw/mission boards
			--we already made a check above to see if this is a job board and not taken 
			--only selectable if there's room on the taken board for the job and we haven't already taken this mission
			choices = {{"Take Job", SV.TakenBoard[8].Client == "" and not self.taken, function() self:FlipTakenStatus() 
																								 self:AddJobToTaken() _MENU:RemoveMenu() end },
					   {"Cancel", true, function() _MENU:RemoveMenu() _MENU:RemoveMenu() end} }
		end 
	
		submenu = RogueEssence.Menu.ScriptableSingleStripMenu(232, 138, 24, choices, 0, function() _MENU:RemoveMenu() _MENU:RemoveMenu() end) 
		_MENU:AddMenu(submenu, true)
		
	end
end

function JobMenu:Update(input)
    assert(self, "BaseState:Begin(): Error, self is nil!")
  if input:JustPressed(RogueEssence.FrameInput.InputType.Confirm) then  
	if self.job_type ~= COMMON.MISSION_BOARD_TAKEN and self.taken then 
		--This is a job from the board that was already taken! Play a cancel noise.
		_GAME:SE("Menu/Cancel")
	else 
		--This job has not yet been taken.  This block will never be hit because the submenu will automatically open.
	end
  elseif input:JustPressed(RogueEssence.FrameInput.InputType.Cancel) or input:JustPressed(RogueEssence.FrameInput.InputType.Menu) then
    _GAME:SE("Menu/Cancel")
    _MENU:RemoveMenu()
	--open job menu for that particular job
  else

  end
end 



BoardMenu = Class('BoardMenu')

--board type should be taken, mission, or outlaw 
function BoardMenu:initialize(board_type, parent_selection_menu, parent_main_menu)
  assert(self, "BoardMenu:initialize(): Error, self is nil!")
    
  self.menu = RogueEssence.Menu.ScriptableMenu(32, 32, 256, 176, function(input) self:Update(input) end)
  self.cursor = RogueEssence.Menu.MenuCursor(self.menu)
  
  self.board_type = board_type
  
  --For refreshing the parent selection menu
  self.parent_selection_menu = parent_selection_menu
  
  --for refreshing the main menu (esc menu) if we accessed the board menu via that
  self.parent_main_menu = parent_main_menu
  
  if self.board_type == COMMON.MISSION_BOARD_TAKEN then
	self.jobs = SV.TakenBoard
  elseif self.board_type == COMMON.MISSION_BOARD_OUTLAW then
  	self.jobs = SV.OutlawBoard
  else --default to mission board
  	self.jobs = SV.MissionBoard
  end

  self.total_items = #self.jobs
  --get total job count
  --todo: make this less bad 
  for i = #self.jobs, 1, -1 do 
	if self.jobs[i].Client ~= "" then break else self.total_items = self.total_items - 1 end
  end
  
  self.current_item = 0
  self.cursor.Loc = RogueElements.Loc(9, 27)
  self.page = 1--1 or 2
  self.taken_count = MISSION_GEN.GetTakenCount()
  self.total_pages = math.ceil(self.total_items / 4)


  self:DrawBoard()

end

--refresh information from results of job menu
function BoardMenu:RefreshSelf()
  print("Debug: Refreshing self!")
  if self.board_type == COMMON.MISSION_BOARD_TAKEN then
	self.jobs = SV.TakenBoard
  elseif self.board_type == COMMON.MISSION_BOARD_OUTLAW then
  	self.jobs = SV.OutlawBoard
  else --default to mission board
  	self.jobs = SV.MissionBoard
  end
  print("Boardtype: " .. self.board_type)
  
  self.total_items = #self.jobs
  --get total job count
  --todo: make this less bad 
  for i = #self.jobs, 1, -1 do 
	if self.jobs[i].Client ~= "" then break else self.total_items = self.total_items - 1 end
  end
 
  --in the event of deleting the last item on the board, move the cursor to accomodate.
  if self:GetSelectedJobIndex() > self.total_items then 
	print("On refresh self, needed to adjust current item!")
	self.current_item = (self.total_items - 1) % 4
	
	--move cursor to reflect new current item location
	self.cursor:ResetTimeOffset()
    self.cursor.Loc = RogueElements.Loc(9, 27 + 28 * self.current_item)
  end
  
  self.total_pages = math.ceil(self.total_items / 4)

  --go to page 1 if we now only have 1 page
  if self.page == 2 and self.total_pages == 1 then
	self.page = 1
  end

  --refresh taken count
  self.taken_count = MISSION_GEN.GetTakenCount()
  
  --if there are no more missions and we're on the taken screen, close the menu.  
  if SV.TakenBoard[1].Client == "" and self.board_type == COMMON.MISSION_BOARD_TAKEN then 
	  _MENU:RemoveMenu()
  end
end 


--NOTE: Board is hardcoded to have 4 items a page, and only to have up to 8 total items to display.
--If you want to edit this, you'll probably have to change most instances of the number 4 here and some references to page. Sorry!
function BoardMenu:DrawBoard()
  --Standard menu divider. Reuse this whenever you need a menu divider at the top for a title.
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuDivider(RogueElements.Loc(8, 8 + 12), self.menu.Bounds.Width - 8 * 2))

  --Standard title. Reuse this whenever a title is needed.
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText("Notice Board", RogueElements.Loc(16, 8)))
  
  --page element
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText("(" .. tostring(self.page) .. "/" .. tostring(self.total_pages) .. ")", RogueElements.Loc(self.menu.Bounds.Width - 35, 8)))

	
  --Accepted element 
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuDivider(RogueElements.Loc(8, self.menu.Bounds.Height - 24), self.menu.Bounds.Width - 8 * 2))
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText("Accepted: " .. tostring(self.taken_count) .. "/8", RogueElements.Loc(96, self.menu.Bounds.Height - 20)))


  self.menu.MenuElements:Add(self.cursor)
  
  --populate 4 self.jobs on a page
  for i = (4 * self.page) - 3, 4 * self.page, 1 do 
	--stop populating self.jobs if we hit a job that's empty
    if self.jobs[i].Client == "" then break end 
	
	
	local title = self.jobs[i].Title
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get(self.jobs[i].Zone):GetColoredName()
    local floor =  MISSION_GEN.STAIR_TYPE[self.jobs[i].Zone] ..'[color=#00FFFF]' .. tostring(self.jobs[i].Floor) .. "[color]F"
    local difficulty = MISSION_GEN.DIFF_TO_COLOR[self.jobs[i].Difficulty] .. self.jobs[i].Difficulty .. "[color]" 
	
	local icon = ""
	if self.board_type == COMMON.MISSION_BOARD_TAKEN then
		if self.jobs[i].Taken then 
			icon = STRINGS:Format("\\uE10F")--open letter
		else
			icon = STRINGS:Format("\\uE10E")--closed letter
		end
	else 
		if self.jobs[i].Taken then 
			icon = STRINGS:Format("\\uE10E")--closed letter
		else
			icon = STRINGS:Format("\\uE110")--paper
		end
	end
	
	local location = zone .. " " .. floor

	
	--color everything red if job is taken and this is a job board
	if self.jobs[i].Taken and self.board_type ~= COMMON.MISSION_BOARD_TAKEN then
		location = string.gsub(location, '%b[]', '')
		title = string.gsub(title, '%b[]', '')
		difficulty = string.gsub(difficulty, '%b[]', '')

		difficulty = "[color=#FF0000]" .. difficulty .. "[color]"
		title = "[color=#FF0000]" .. title .. "[color]"
		location = "[color=#FF0000]" .. location .. "[color]"
	end
	
	--modulo the iterator so that if we're on the 2nd page it goes to the right spot
	
	self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(icon, RogueElements.Loc(21, 26 + 28 * ((i-1) % 4))))
	self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(title, RogueElements.Loc(33, 26 + 28 * ((i-1) % 4))))
	self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(location, RogueElements.Loc(33, 38 + 28 * ((i-1) % 4))))
	self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(difficulty, RogueElements.Loc(self.menu.Bounds.Width - 33, 38 + 28 * ((i-1) % 4))))

  end
end 


function BoardMenu:Update(input)
    assert(self, "BaseState:Begin(): Error, self is nil!")
  if input:JustPressed(RogueEssence.FrameInput.InputType.Confirm) then
	--open the selected job menu
	_GAME:SE("Menu/Confirm")
	local job_menu = JobMenu:new(self.board_type, self:GetSelectedJobIndex(), self)
	_MENU:AddMenu(job_menu.menu, false)
	job_menu:OpenSubMenu()
  elseif input:JustPressed(RogueEssence.FrameInput.InputType.Cancel) or input:JustPressed(RogueEssence.FrameInput.InputType.Menu) then
    _GAME:SE("Menu/Cancel")
    _MENU:RemoveMenu()
	--open job menu for that particular job
  else
    moved = false
    if RogueEssence.Menu.InteractableMenu.IsInputting(input, LUA_ENGINE:MakeLuaArray(Dir8, { Dir8.Down, Dir8.DownLeft, Dir8.DownRight })) then
      moved = true
      self.current_item = (self.current_item + 1) % 4
	  
	  --if we try to move the cursor to an empty slot on a down press, then move it to the space for the first job on the page.
	  if self:GetSelectedJobIndex() > self.total_items then 
		local new_current = 0
		--undo moved flag if we didn't actually move
		if new_current == (self.current_item - 1) % 4 then
			moved = false
		end
		self.current_item = new_current
	  end
	  
    elseif RogueEssence.Menu.InteractableMenu.IsInputting(input, LUA_ENGINE:MakeLuaArray(Dir8, { Dir8.Up, Dir8.UpLeft, Dir8.UpRight })) then
      moved = true
      self.current_item = (self.current_item - 1) % 4
	  
	  --if we try to move the cursor to an empty slot on an up press, then move it to the space for the last job on the page.
	  if self:GetSelectedJobIndex() > self.total_items then 
		local new_current = (self.total_items % 4) - 1
		--undo moved flag if we didn't actually move
		if new_current == (self.current_item + 1 ) % 4 then
			moved = false
		end
		self.current_item = new_current
	  end
	  
	elseif RogueEssence.Menu.InteractableMenu.IsInputting(input, LUA_ENGINE:MakeLuaArray(Dir8, {Dir8.Left, Dir8.Right})) then
	  --go to other menu if there are more options on the 2nd menu
	  if self.total_pages > 1 then 
	    --change the page
	    if self.page == 1 then self.page = 2 else self.page = 1 end
		moved = true
		
	  --if we try to move the cursor to an empty slot on a side press, then move it to the space for the last job on the page.
	    if self:GetSelectedJobIndex() > self.total_items then 
			local new_current = (self.total_items % 4) - 1
			self.current_item = new_current
		end
		
		
		self.menu.MenuElements:Clear()
		self:DrawBoard()
	  end
    end
    if moved then
      _GAME:SE("Menu/Select")
      self.cursor:ResetTimeOffset()
      self.cursor.Loc = RogueElements.Loc(9, 27 + 28 * self.current_item)
    end
  end
end 

--gets current job index based on the current item and the page. if self.page is 2, and current item is 0, returned answer should be 5.
function BoardMenu:GetSelectedJobIndex()
	return self.current_item + (4 * (self.page - 1) + 1)
	
end








------------------------
-- Board Selection Menu
------------------------
BoardSelectionMenu = Class('BoardSelectionMenu')

--Used to choose between viewing the board, your job list, or to cancel
function BoardSelectionMenu:initialize(board_type)
  assert(self, "BoardSelectionMenu:initialize(): Error, self is nil!")
  
  --I'm bad at this. Need different menu sizes depending on the board 
  if board_type == COMMON.MISSION_BOARD_OUTLAW then
	self.menu = RogueEssence.Menu.ScriptableMenu(24, 22, 128, 60, function(input) self:Update(input) end)
  else
  	self.menu = RogueEssence.Menu.ScriptableMenu(24, 22, 119, 60, function(input) self:Update(input) end)

  end 
  self.cursor = RogueEssence.Menu.MenuCursor(self.menu)
  self.board_type = board_type
  
  self.current_item = 0
  self.cursor.Loc = RogueElements.Loc(9, 8)
  
  self:DrawMenu()

end

--refreshes information and draws to the menu. This is important in case there's a change to the taken board
function BoardSelectionMenu:DrawMenu()
  
  --color this red if there's no jobs and mark there's no jobs to view.
  self.board_populated = true
  local board_name = ""
  if self.board_type == COMMON.MISSION_BOARD_OUTLAW then
	if SV.OutlawBoard[1].Client == '' then 
		board_name = "[color=#FF0000]Outlaw Notice Board[color]"
		self.board_populated = false
	else
		board_name = "Outlaw Notice Board" 
	end
  else
	if SV.MissionBoard[1].Client == '' then 
		board_name = "[color=#FF0000]Job Bulletin Board[color]"
		self.board_populated = false
	else
		board_name = "Job Bulletin Board" 
	end	
  end
  
  --color this red if there's no jobs, mark there's no jobs taken
  self.job_list = "Job List"
  self.taken_populated = true 
  if SV.TakenBoard[1].Client == "" then
	self.job_list = "[color=#FF0000]Job List[color]"
	self.taken_populated = false 
  end
  
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(board_name, RogueElements.Loc(21, 8)))
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(self.job_list, RogueElements.Loc(21, 22)))
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText("Exit", RogueElements.Loc(21, 36)))

  self.menu.MenuElements:Add(self.cursor)
end 


function BoardSelectionMenu:Update(input)

 if input:JustPressed(RogueEssence.FrameInput.InputType.Confirm) then
	if self.current_item == 0 then --open relevant job menu 
		if self.board_populated then 
			_GAME:SE("Menu/Confirm")
			local board_menu = BoardMenu:new(self.board_type, self)
			_MENU:AddMenu(board_menu.menu, false)
		else
			_GAME:SE("Menu/Cancel")
		end
	elseif self.current_item == 1 then--open taken missions
		if self.taken_populated then
			_GAME:SE("Menu/Confirm")
			local board_menu = BoardMenu:new(COMMON.MISSION_BOARD_TAKEN, self)
			_MENU:AddMenu(board_menu.menu, false)
		else
		    _GAME:SE("Menu/Cancel")
		end
	else 
		_GAME:SE("Menu/Cancel")
		_MENU:RemoveMenu()
	end 
  elseif input:JustPressed(RogueEssence.FrameInput.InputType.Cancel) or input:JustPressed(RogueEssence.FrameInput.InputType.Menu) then
    _GAME:SE("Menu/Cancel")
    _MENU:RemoveMenu()
	--open job menu for that particular job
  else
    moved = false
    if RogueEssence.Menu.InteractableMenu.IsInputting(input, LUA_ENGINE:MakeLuaArray(Dir8, { Dir8.Down, Dir8.DownLeft, Dir8.DownRight })) then
      moved = true
      self.current_item = (self.current_item + 1) % 3
	  
    elseif RogueEssence.Menu.InteractableMenu.IsInputting(input, LUA_ENGINE:MakeLuaArray(Dir8, { Dir8.Up, Dir8.UpLeft, Dir8.UpRight })) then
      moved = true
      self.current_item = (self.current_item - 1) % 3
	end
	
    if moved then
      _GAME:SE("Menu/Select")
      self.cursor:ResetTimeOffset()
      self.cursor.Loc = RogueElements.Loc(9, 8 + 14 * self.current_item)
    end
  end
end 




------------------------
-- DungeonJobList  Menu
------------------------
DungeonJobList = Class('DungeonJobList')

--Used to see what jobs are in this dungeon
function DungeonJobList:initialize()
  assert(self, "DungeonJobList:initialize(): Error, self is nil!")
  
  self.menu = RogueEssence.Menu.ScriptableMenu(32, 32, 256, 176, function(input) self:Update(input) end)
  self.dungeon = ""
  
  --This menu should only be accessible from dungeons, but add this as a check just in case we somehow access this menu from outside a dungeon.
  if RogueEssence.GameManager.Instance.CurrentScene == RogueEssence.Dungeon.DungeonScene.Instance then
	self.dungeon = _ZONE.CurrentZoneID
  end
  
  self.jobs = SV.TakenBoard
  self.job_count = 0
  
  for i = 1, 8, 1 do
    if SV.TakenBoard[i].Client == "" then 
	  break 
    elseif SV.TakenBoard[i].Zone ~= '' and SV.TakenBoard[i].Zone == self.dungeon then 
	  self.job_count = self.job_count + 1 
	end
  end 
  self:DrawMenu()

end

--refreshes information and draws to the menu. This is important in case there's a change to the taken board
function DungeonJobList:DrawMenu()
    --Standard menu divider. Reuse this whenever you need a menu divider at the top for a title.
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuDivider(RogueElements.Loc(8, 8 + 12), self.menu.Bounds.Width - 8 * 2))

  --Standard title. Reuse this whenever a title is needed.
  self.menu.MenuElements:Add(RogueEssence.Menu.MenuText("Mission Objectives", RogueElements.Loc(16, 8)))
  
  --how many jobs have we populated so far
  local count = 0
  
  --populate jobs that are in this dungeon
  for i = 1, 8, 1 do 
	--stop populating if we hit a job that's empty
    if self.jobs[i].Client == "" then break end 
	
	--only look at jobs in the current dungeon that aren't suspended
	if self.jobs[i].Zone == self.dungeon and self.jobs[i].Taken then 	
		local floor =  MISSION_GEN.STAIR_TYPE[self.jobs[i].Zone] ..'[color=#00FFFF]' .. tostring(self.jobs[i].Floor) .. "[color]F"
		local objective = ""
		local icon = ""
		local goal = self.jobs[i].Type
		
		local target = _DATA:GetMonster(self.jobs[i].Target):GetColoredName()
	
		local client = ""
		if self.jobs[i].Client == "zhayn" then 
			client = "[color=#00FFFF]Zhayn[color]"
		else 
			client = _DATA:GetMonster(self.jobs[i].Client):GetColoredName()
		end
		
		local item = "" 
		if self.jobs[i].Item ~= "" then
			item = _DATA:GetItem(self.jobs[i].Item):GetColoredName()
		end
		
		if goal == COMMON.MISSION_TYPE_RESCUE then
			objective = "Rescue " .. target .. "."
		elseif goal == COMMON.MISSION_TYPE_ESCORT then 
			objective = "Escort " .. client .. " to " .. target .. "."
		elseif goal == COMMON.MISSION_TYPE_OUTLAW then
			objective = "Arrest " .. target .. "."
		elseif goal == COMMON.MISSION_TYPE_EXPLORATION then
			objective = "Explore with " .. client .. "."
		elseif goal == COMMON.MISSION_TYPE_LOST_ITEM then 
			objective = "Find " .. item .. " for " .. client .. "."
		elseif goal == COMMON.MISSION_TYPE_OUTLAW_ITEM then
			objective = "Reclaim " .. item .. " from " .. target .. "."
		elseif goal == COMMON.MISSION_TYPE_OUTLAW_FLEE then
			objective = "Arrest cowardly " .. target .. "."
		elseif goal == COMMON.MISSION_TYPE_OUTLAW_MONSTER_HOUSE then
			objective = "Arrest big boss " .. target .. "."
		elseif goal == COMMON.MISSION_TYPE_DELIVERY then
			objective = "Deliver " .. item .. " to " .. client .. "."
		end
		
		
		
		if self.jobs[i].Completion == COMMON.MISSION_INCOMPLETE then 
			icon = STRINGS:Format("\\uE10F")--open letter
		else
			icon = STRINGS:Format("\\uE10A")--check mark
		end

		

		
		self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(icon, RogueElements.Loc(16, 24 + 14 * count)))
		self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(floor, RogueElements.Loc(28, 24 + 14 * count)))
		self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(objective, RogueElements.Loc(60, 24 + 14 * count)))
		
		count = count + 1
	end

  end
  
  --put a special message if no jobs dependent on story progression.
  local message = ""
  if count == 0 then 
	--partner only relic forest
    if SV.ChapterProgression.Chapter == 1 and self.dungeon == 'relic_forest' and not SV.Chapter1.PartnerCompletedForest then
		message = "Explore the forest."
	--partner+hero relic forest
	elseif SV.ChapterProgression.Chapter == 1 and self.dungeon == 'relic_forest' and SV.Chapter1.PartnerCompletedForest then
		message = "Get back to Metano Town."
	--Illuminant Riverbed
	elseif SV.ChapterProgression.Chapter == 2 and self.dungeon == 'illuminant_riverbed' and not SV.Chapter2.FinishedRiver then
		message = 'Rescue ' .. CharacterEssentials.GetCharacterName('Numel') .. "."
	--Crooked Cavern, before seeing the boss
	elseif SV.ChapterProgression.Chapter == 3 and self.dungeon == 'crooked_cavern' and not SV.Chapter3.EncounteredBoss then 
		message = 'Apprehend ' .. CharacterEssentials.GetCharacterName('Sandile') .. "."
	--Crooked cavern, at the boss
	elseif SV.ChapterProgression.Chapter == 3 and self.dungeon == 'crooked_cavern' and SV.Chapter3.EncounteredBoss and not SV.Chapter3.DefeatedBoss and _ZONE.CurrentMapID.Segment == 1 then 
		message = 'Defeat Team [color=#FFA5FF]Style[color]!'
	--crooked cavern, lost to boss, on the way back.
	elseif SV.ChapterProgression.Chapter == 3 and self.dungeon == 'crooked_cavern' and SV.Chapter3.EncounteredBoss and not SV.Chapter3.DefeatedBoss and _ZONE.CurrentMapID.Segment == 0 then 
		message = 'Get back to the end of the cavern.'
	elseif SV.ChapterProgression.Chapter == 4 and self.dungeon == 'apricorn_grove' and not SV.Chapter4.ReachedGlade and not SV.Chapter4.FinishedGrove then
		message = 'Try to find something of interest.'
	elseif SV.ChapterProgression.Chapter == 4 and self.dungeon == 'apricorn_grove' and SV.Chapter4.ReachedGlade and not SV.Chapter4.FinishedGrove then
		message = 'Return to the large Apricorn tree with enough\nPokémon to reach a big Apricorn.'
	else
		message = "Go as far as you can."
	end 
	self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(message, RogueElements.Loc(16, 12 + 14)))
  end 

  
  
  
end 


function DungeonJobList:Update(input)

 if input:JustPressed(RogueEssence.FrameInput.InputType.Confirm) then
	_GAME:SE("Menu/Cancel")
    _MENU:RemoveMenu()
  elseif input:JustPressed(RogueEssence.FrameInput.InputType.Cancel) then
    _GAME:SE("Menu/Cancel")
    _MENU:RemoveMenu()
  elseif input:JustPressed(RogueEssence.FrameInput.InputType.Menu) then
    _GAME:SE("Menu/Cancel")
    _MENU:RemoveMenu()
  end
end 

--How many missions are taken? Probably shoulda just had a variable that kept track, but oh well...
function MISSION_GEN.GetTakenCount()
	local count = 0
	for i = 1, 8, 1 do
		if SV.TakenBoard[i].Client == "" then 
			break 
		else
			count = count + 1 
		end 
	end 
	return count
end

function MISSION_GEN.RemoveMissionBackReference()
	for mission_num, _ in pairs(SV.TakenBoard) do
		SV.TakenBoard[mission_num].BackReference = -1
	end
end

function MISSION_GEN.GetDebugMissionInfo(board, slot)
	if board == "outlaw" then
		print("client = " .. SV.OutlawBoard[slot].Client)
		print("target = " .. SV.OutlawBoard[slot].Target)
		print("flavor = " .. SV.OutlawBoard[slot].Flavor)
		print("title = " .. SV.OutlawBoard[slot].Title)
		print("zone = " .. SV.OutlawBoard[slot].Zone)
		print("segment = " .. SV.OutlawBoard[slot].Segment)
		print("floor = " .. SV.OutlawBoard[slot].Floor)
		print("reward = " .. SV.OutlawBoard[slot].Reward)
		print("type = " .. SV.OutlawBoard[slot].Type)
		print("Completion = " .. SV.OutlawBoard[slot].Completion)
		print("Taken = " .. tostring(SV.OutlawBoard[slot].Taken))
		print("Difficulty = " .. SV.OutlawBoard[slot].Difficulty)
		print("item = " .. SV.OutlawBoard[slot].Item)
		print("Special = " .. SV.OutlawBoard[slot].Special)
		local client_gender = SV.OutlawBoard[slot].ClientGender
		if client_gender == 1 then
			print("ClientGender = male")
		elseif client_gender == 2 then
			print("ClientGender = female")
		elseif client_gender == 0 then
			print("ClientGender = genderless")
		else 
			print("Non valid gender!!!!!!")
		end
		
		local target_Gender = SV.OutlawBoard[slot].ClientGender
		if target_Gender == 1 then
			print("TargetGender = male")
		elseif target_Gender == 2 then
			print("TargetGender = female")
		elseif target_Gender == 0 then
			print("TargetGender = genderless")
		else 
			print("Non valid gender!!!!!!")
		end
		print("Bonus = " .. SV.OutlawBoard[slot].BonusReward)

	elseif board == "mission" then
		print("client = " .. SV.MissionBoard[slot].Client)
		print("target = " .. SV.MissionBoard[slot].Target)
		print("flavor = " .. SV.MissionBoard[slot].Flavor)
		print("title = " .. SV.MissionBoard[slot].Title)
		print("zone = " .. SV.MissionBoard[slot].Zone)
		print("segment = " .. SV.MissionBoard[slot].Segment)
		print("floor = " .. SV.MissionBoard[slot].Floor)
		print("reward = " .. SV.MissionBoard[slot].Reward)
		print("type = " .. SV.MissionBoard[slot].Type)
		print("Completion = " .. SV.MissionBoard[slot].Completion)
		print("Taken = " .. tostring(SV.MissionBoard[slot].Taken))
		print("Difficulty = " .. SV.MissionBoard[slot].Difficulty)
		print("item = " .. SV.MissionBoard[slot].Item)
		print("Special = " .. SV.MissionBoard[slot].Special)
		local client_gender = SV.MissionBoard[slot].ClientGender
		if client_gender == 1 then
			print("ClientGender = male")
		elseif client_gender == 2 then
			print("ClientGender = female")
		elseif client_gender == 0 then
			print("ClientGender = genderless")
		else 
			print("Non valid gender!!!!!!")
		end
		
		local target_Gender = SV.MissionBoard[slot].ClientGender
		if target_Gender == 1 then
			print("TargetGender = male")
		elseif target_Gender == 2 then
			print("TargetGender = female")
		elseif target_Gender == 0 then
			print("TargetGender = genderless")
		else 
			print("Non valid gender!!!!!!")
		end
		print("Bonus = " .. SV.MissionBoard[slot].BonusReward)
	else
		print("client = " .. SV.TakenBoard[slot].Client)
		print("target = " .. SV.TakenBoard[slot].Target)
		print("flavor = " .. SV.TakenBoard[slot].Flavor)
		print("title = " .. SV.TakenBoard[slot].Title)
		print("zone = " .. SV.TakenBoard[slot].Zone)
		print("segment = " .. SV.TakenBoard[slot].Segment)
		print("floor = " .. SV.TakenBoard[slot].Floor)
		print("reward = " .. SV.TakenBoard[slot].Reward)
		print("type = " .. SV.TakenBoard[slot].Type)
		print("Completion = " .. SV.TakenBoard[slot].Completion)
		print("Taken = " .. tostring(SV.TakenBoard[slot].Taken))
		print("Difficulty = " .. SV.TakenBoard[slot].Difficulty)
		print("item = " .. SV.TakenBoard[slot].Item)
		print("Special = " .. SV.TakenBoard[slot].Special)
		print("BackReference = " .. SV.TakenBoard[slot].BackReference)
		local client_gender = SV.TakenBoard[slot].ClientGender
		if client_gender == 1 then
			print("ClientGender = male")
		elseif client_gender == 2 then
			print("ClientGender = female")
		elseif client_gender == 0 then
			print("ClientGender = genderless")
		else 
			print("Non valid gender!!!!!!")
		end
		
		local target_Gender = SV.TakenBoard[slot].ClientGender
		if target_Gender == 1 then
			print("TargetGender = male")
		elseif target_Gender == 2 then
			print("TargetGender = female")
		elseif target_Gender == 0 then
			print("TargetGender = genderless")
		else 
			print("Non valid gender!!!!!!")
		end
		print("Bonus = " .. SV.TakenBoard[slot].BonusReward)
	end
end