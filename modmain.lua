local _G = GLOBAL
local _S = _G.STRINGS
local _T = TUNING
local Ingredient = _G.Ingredient
local IsDLCEnabled = _G.IsDLCEnabled
local Recipe = _G.Recipe
local RECIPETABS = _G.RECIPETABS
local RECIPE_GAME_TYPE = _G.RECIPE_GAME_TYPE
local TECH = _G.TECH

PrefabFiles = 
{
	"mermking",
    "mermsplashes",
	"mermthrone"
}

Assets = 
{
	Asset("ATLAS", "images/inventoryimages/mermthrone.xml"),
	Asset("ATLAS", "images/inventoryimages/turf_marsh.xml"),
	Asset("ATLAS", "minimap/merm_king_carpet.xml"),
	Asset("ATLAS", "minimap/merm_king_carpet_construction.xml"),
	Asset("ATLAS", "minimap/merm_king_carpet_occupied.xml")
}

AddMinimapAtlas("minimap/merm_king_carpet.xml")
AddMinimapAtlas("minimap/merm_king_carpet_construction.xml")
AddMinimapAtlas("minimap/merm_king_carpet_occupied.xml")


TUNING.MOD_MERMKING_EXCHANGE_BONUS = 0
if GetModConfigData("exchange_rate") == 1 then
	TUNING.MOD_MERMKING_EXCHANGE_BONUS = 2
elseif GetModConfigData("exchange_rate") == 2 then
	TUNING.MOD_MERMKING_EXCHANGE_BONUS = 4
elseif GetModConfigData("exchange_rate") == 3 then
	TUNING.MOD_MERMKING_EXCHANGE_BONUS = 6
end

if _S.CHARACTERS.WAGSTAFF == nil then _S.CHARACTERS.WAGSTAFF = { DESCRIBE = {},	} end -- DLC003
if _S.CHARACTERS.WALANI == nil then _S.CHARACTERS.WALANI = { DESCRIBE = {},	} end -- DLC002
if _S.CHARACTERS.WARLY == nil then _S.CHARACTERS.WARLY = { DESCRIBE = {},	} end -- DLC002
if _S.CHARACTERS.WATHGRITHR == nil then _S.CHARACTERS.WATHGRITHR = { DESCRIBE = {}, }  end -- DLC001
if _S.CHARACTERS.WEBBER == nil then _S.CHARACTERS.WEBBER = { DESCRIBE = {}, }  end -- DLC001
if _S.CHARACTERS.WHEELER == nil then _S.CHARACTERS.WHEELER = { DESCRIBE = {}, } end -- DLC003
if _S.CHARACTERS.WILBA == nil then _S.CHARACTERS.WILBA = { DESCRIBE = {}, } end -- DLC003
if _S.CHARACTERS.WINONA == nil then _S.CHARACTERS.WINONA = { DESCRIBE = {}, } end -- DST
if _S.CHARACTERS.WOODLEGS == nil then _S.CHARACTERS.WOODLEGS = { DESCRIBE = {}, } end -- DLC002
if _S.CHARACTERS.WORMWOOD == nil then _S.CHARACTERS.WORMWOOD = { DESCRIBE = {}, }  end -- DLC003
if _S.CHARACTERS.WORTOX == nil then _S.CHARACTERS.WORTOX = { DESCRIBE = {}, }  end -- DST
if _S.CHARACTERS.WURT == nil then _S.CHARACTERS.WURT = { DESCRIBE = {}, } end -- DST

------------------------------------------------------------------------------------------------------------------------------
--DIY Royalty Kit

local mermthrone_construction = Recipe(
	"mermthrone_construction", 
	{
	Ingredient("boards", 5), 
	Ingredient("tentaclespots", 1), 
	Ingredient("spear", 2),
	},
	RECIPETABS.TOWN, 
	TECH.SCIENCE_TWO)
	mermthrone_construction.placer = "mermthrone_construction_placer"
	mermthrone_construction.atlas = "images/inventoryimages/mermthrone_construction.xml"
	if IsDLCEnabled(2) or IsDLCEnabled(3) then
		mermthrone_construction.game_type = "common"
	end
	
	_S.NAMES.MERMTHRONE_CONSTRUCTION = "DIY Royalty Kit"
	_S.RECIPE_DESC.MERMTHRONE_CONSTRUCTION = "Usher in a new Merm Monarchy."

	_S.CHARACTERS.GENERIC.DESCRIBE.MERMTHRONE_CONSTRUCTION = {"Just what is she planning?"}
	_S.CHARACTERS.WARLY.DESCRIBE.MERMTHRONE_CONSTRUCTION = {"You have all the ingredients you need?"}
	_S.CHARACTERS.WATHGRITHR.DESCRIBE.MERMTHRONE_CONSTRUCTION = {"The little beast toils away."}
	_S.CHARACTERS.WAXWELL.DESCRIBE.MERMTHRONE_CONSTRUCTION = {"What is that little creature up to?"}
	_S.CHARACTERS.WEBBER.DESCRIBE.MERMTHRONE_CONSTRUCTION = {"Can we help?"}
	_S.CHARACTERS.WENDY.DESCRIBE.MERMTHRONE_CONSTRUCTION = {"I don't know why you bother."}
	_S.CHARACTERS.WICKERBOTTOM.DESCRIBE.MERMTHRONE_CONSTRUCTION = {"Careful not to get a splinter, dear."}
	_S.CHARACTERS.WILLOW.DESCRIBE.MERMTHRONE_CONSTRUCTION = {"What's all this stuff for?"}
	_S.CHARACTERS.WINONA.DESCRIBE.MERMTHRONE_CONSTRUCTION = {"Whatcha makin' there, kid?"}
	_S.CHARACTERS.WOLFGANG.DESCRIBE.MERMTHRONE_CONSTRUCTION = {"Tiny fish girl seems very busy."}
	_S.CHARACTERS.WOODIE.DESCRIBE.MERMTHRONE_CONSTRUCTION = {"You look like you've got this under control."}
	_S.CHARACTERS.WORMWOOD.DESCRIBE.MERMTHRONE_CONSTRUCTION = {"Making something"}
	_S.CHARACTERS.WORTOX.DESCRIBE.MERMTHRONE_CONSTRUCTION = {"My my, what mischief are you making?"}
	_S.CHARACTERS.WURT.DESCRIBE.MERMTHRONE_CONSTRUCTION = {"There lots of Kings in fairy stories... look easy to make!"}
	_S.CHARACTERS.WX78.DESCRIBE.MERMTHRONE_CONSTRUCTION = {"THE GREEN ONE IS DOING SOMETHING USELESS"}
	
------------------------------------------------------------------------------------------------------------------------------
--Marsh Turf
	
local turf_marsh = Recipe(
	"turf_marsh", 
	{
	Ingredient("cutreeds", 1), 
	Ingredient("spoiled_food", 2),
	},
	RECIPETABS.TOWN, 
	TECH.SCIENCE_TWO)
	turf_marsh.placer = "turf_marsh_placer"
	turf_marsh.atlas = "images/inventoryimages/turf_marsh.xml"
	if IsDLCEnabled(2) or IsDLCEnabled(3) then
		turf_marsh.game_type = "common"
	end
	
	_S.NAMES.TURF_MARSH = "Marsh Turf"
	_S.RECIPE_DESC.TURF_MARSH = "Home is where the marsh is."

	_S.CHARACTERS.GENERIC.DESCRIBE.TURF_MARSH = {"A chunk of ground."}
	_S.CHARACTERS.WAGSTAFF.DESCRIBE.TURF_MARSH = {"A spongy consistency."}
	_S.CHARACTERS.WALANI.DESCRIBE.TURF_MARSH = {"Goopy..."}
	_S.CHARACTERS.WARLY.DESCRIBE.TURF_MARSH = {"It's like an ingredient for the ground."}
	_S.CHARACTERS.WATHGRITHR.DESCRIBE.TURF_MARSH = {"A piece öf the battlefield."}
	_S.CHARACTERS.WAXWELL.DESCRIBE.TURF_MARSH = {"What is that little creature up to?"}
	_S.CHARACTERS.WEBBER.DESCRIBE.TURF_MARSH = {"Some pretty average earth."}
	_S.CHARACTERS.WENDY.DESCRIBE.TURF_MARSH = {"Some ground."}
	_S.CHARACTERS.WHEELER.DESCRIBE.TURF_MARSH = {"Do I really need to drag this dirt around with me?"}
	_S.CHARACTERS.WICKERBOTTOM.DESCRIBE.TURF_MARSH = {"The ground. You step on it."}
	_S.CHARACTERS.WILBA.DESCRIBE.TURF_MARSH = {"'TIS ALL FWOOSHED"}
	_S.CHARACTERS.WILLOW.DESCRIBE.TURF_MARSH = {"The ground is boring."}
	_S.CHARACTERS.WINONA.DESCRIBE.TURF_MARSH = {"That's a chunk of squishy ground."}
	_S.CHARACTERS.WOLFGANG.DESCRIBE.TURF_MARSH = {"Step stones."}
	_S.CHARACTERS.WOODIE.DESCRIBE.TURF_MARSH = {"Just some ground, eh?"}
	_S.CHARACTERS.WOODLEGS.DESCRIBE.TURF_MARSH = {"Me ain't no ground lubber."}
	_S.CHARACTERS.WORMWOOD.DESCRIBE.TURF_MARSH = {"Squishy"}
	_S.CHARACTERS.WORTOX.DESCRIBE.TURF_MARSH = {"Floor or ceiling, depending on your perspective."}
	_S.CHARACTERS.WURT.DESCRIBE.TURF_MARSH = {"Ground bit."}
	_S.CHARACTERS.WX78.DESCRIBE.TURF_MARSH = {"THE GROUND"}
	
------------------------------------------------------------------------------------------------------------
--. Tuning

local seg_time = 30
local total_day_time = seg_time*16
_T.TOTAL_DAY_TIME  = total_day_time

_T.MERM_KING_HEALTH = 1000
_T.MERM_KING_HEALTH_REGEN_PERIOD = 1
_T.MERM_KING_HEALTH_REGEN = 2
_T.MERM_KING_HUNGER = 200
_T.MERM_KING_HUNGER_KILL_TIME = total_day_time * 2
_T.MERM_KING_HUNGER_RATE = 200 / (total_day_time * 4)

------------------------------------------------------------------------------------------------------------
--. _S
	
--//Merm King//

_S.MERM_KING_TALK_HUNGER_STARVING = "Hungry... HUNGRY! HUNGRYYYY!!!"
_S.MERM_KING_TALK_HUNGER_CLOSE_STARVING = "Treachery... villainy! To let King waste away like this..."
_S.MERM_KING_TALK_HUNGER_VERY_HUNGRY = "What take so long? Make offerings to your King!"
_S.MERM_KING_TALK_HUNGER_HUNGRY = "King desires food!"
_S.MERM_KING_TALK_HUNGER_HUNGRISH = "King feeling a bit peckish..."
_S.MERM_KING_TALK_HUNGER_FULL =  "Have done well. Now go."
	
	