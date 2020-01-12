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
	"mermking"
}
--[[Assets = {
	Asset("ATLAS", "images/inventoryimages/mermthrone.xml"),
	Asset("ATLAS", "images/inventoryimages/turf_marsh.xml"),
   }

AddMinimapAtlas("minimap/mermthrone-0.xml")
AddMinimapAtlas("minimap/mermthrone-1.xml")
AddMinimapAtlas("minimap/mermthrone-2.xml")


if STRINGS.CHARACTERS.WAGSTAFF == nil then STRINGS.CHARACTERS.WAGSTAFF = { DESCRIBE = {},	} end -- DLC003
if STRINGS.CHARACTERS.WALANI == nil then STRINGS.CHARACTERS.WALANI = { DESCRIBE = {},	} end -- DLC002
if STRINGS.CHARACTERS.WARLY == nil then STRINGS.CHARACTERS.WARLY = { DESCRIBE = {},	} end -- DLC002
if STRINGS.CHARACTERS.WATHGRITHR == nil then STRINGS.CHARACTERS.WATHGRITHR = { DESCRIBE = {}, }  end -- DLC001
if STRINGS.CHARACTERS.WEBBER == nil then STRINGS.CHARACTERS.WEBBER = { DESCRIBE = {}, }  end -- DLC001
if STRINGS.CHARACTERS.WHEELER == nil then STRINGS.CHARACTERS.WHEELER = { DESCRIBE = {}, } end -- DLC003
if STRINGS.CHARACTERS.WILBA == nil then STRINGS.CHARACTERS.WILBA = { DESCRIBE = {}, } end -- DLC003
if STRINGS.CHARACTERS.WINONA == nil then STRINGS.CHARACTERS.WINONA = { DESCRIBE = {}, } end -- DST
if STRINGS.CHARACTERS.WOODLEGS == nil then STRINGS.CHARACTERS.WOODLEGS = { DESCRIBE = {}, } end -- DLC002
if STRINGS.CHARACTERS.WORMWOOD == nil then STRINGS.CHARACTERS.WORMWOOD = { DESCRIBE = {}, }  end -- DLC003
if STRINGS.CHARACTERS.WORTOX == nil then STRINGS.CHARACTERS.WORTOX = { DESCRIBE = {}, }  end -- DST
if STRINGS.CHARACTERS.WURT == nil then STRINGS.CHARACTERS.WURT = { DESCRIBE = {}, } end -- DST

-https://dontstarve.fandom.com/wiki/Seawreath

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
	
	STRINGS.NAMES.MERMTHRONE_CONSTRUCTION = "DIY Royalty Kit"
	STRINGS.RECIPE_DESC.MERMTHRONE_CONSTRUCTION = "Usher in a new Merm Monarchy."

	STRINGS.CHARACTERS.GENERIC.DESCRIBE.MERMTHRONE_CONSTRUCTION = {"Just what is she planning?"}
	STRINGS.CHARACTERS.WARLY.DESCRIBE.MERMTHRONE_CONSTRUCTION = {"You have all the ingredients you need?"}
	STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.MERMTHRONE_CONSTRUCTION = {"The little beast toils away."}
	STRINGS.CHARACTERS.WAXWELL.DESCRIBE.MERMTHRONE_CONSTRUCTION = {"What is that little creature up to?"}
	STRINGS.CHARACTERS.WEBBER.DESCRIBE.MERMTHRONE_CONSTRUCTION = {"Can we help?"}
	STRINGS.CHARACTERS.WENDY.DESCRIBE.MERMTHRONE_CONSTRUCTION = {"I don't know why you bother."}
	STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.MERMTHRONE_CONSTRUCTION = {"Careful not to get a splinter, dear."}
	STRINGS.CHARACTERS.WILLOW.DESCRIBE.MERMTHRONE_CONSTRUCTION = {"What's all this stuff for?"}
	STRINGS.CHARACTERS.WINONA.DESCRIBE.MERMTHRONE_CONSTRUCTION = {"Whatcha makin' there, kid?"}
	STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.MERMTHRONE_CONSTRUCTION = {"Tiny fish girl seems very busy."}
	STRINGS.CHARACTERS.WOODIE.DESCRIBE.MERMTHRONE_CONSTRUCTION = {"You look like you've got this under control."}
	STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.MERMTHRONE_CONSTRUCTION = {"Making something"}
	STRINGS.CHARACTERS.WORTOX.DESCRIBE.MERMTHRONE_CONSTRUCTION = {"My my, what mischief are you making?"}
	STRINGS.CHARACTERS.WURT.DESCRIBE.MERMTHRONE_CONSTRUCTION = {"There lots of Kings in fairy stories... look easy to make!"}
	STRINGS.CHARACTERS.WX78.DESCRIBE.MERMTHRONE_CONSTRUCTION = {"THE GREEN ONE IS DOING SOMETHING USELESS"}
	
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
	
	STRINGS.NAMES.TURF_MARSH = "Marsh Turf"
	STRINGS.RECIPE_DESC.TURF_MARSH = "Home is where the marsh is."

	STRINGS.CHARACTERS.GENERIC.DESCRIBE.TURF_MARSH = {"A chunk of ground."}
	STRINGS.CHARACTERS.WAGSTAFF.DESCRIBE.TURF_MARSH = {"A spongy consistency."}
	STRINGS.CHARACTERS.WALANI.DESCRIBE.TURF_MARSH = {"Goopy..."}
	STRINGS.CHARACTERS.WARLY.DESCRIBE.TURF_MARSH = {"It's like an ingredient for the ground."}
	STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.TURF_MARSH = {"A piece öf the battlefield."}
	STRINGS.CHARACTERS.WAXWELL.DESCRIBE.TURF_MARSH = {"What is that little creature up to?"}
	STRINGS.CHARACTERS.WEBBER.DESCRIBE.TURF_MARSH = {"Some pretty average earth."}
	STRINGS.CHARACTERS.WENDY.DESCRIBE.TURF_MARSH = {"Some ground."}
	STRINGS.CHARACTERS.WHEELER.DESCRIBE.TURF_MARSH = {"Do I really need to drag this dirt around with me?"}
	STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.TURF_MARSH = {"The ground. You step on it."}
	STRINGS.CHARACTERS.WILBA.DESCRIBE.TURF_MARSH = {"'TIS ALL FWOOSHED"}
	STRINGS.CHARACTERS.WILLOW.DESCRIBE.TURF_MARSH = {"The ground is boring."}
	STRINGS.CHARACTERS.WINONA.DESCRIBE.TURF_MARSH = {"That's a chunk of squishy ground."}
	STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.TURF_MARSH = {"Step stones."}
	STRINGS.CHARACTERS.WOODIE.DESCRIBE.TURF_MARSH = {"Just some ground, eh?"}
	STRINGS.CHARACTERS.WOODLEGS.DESCRIBE.TURF_MARSH = {"Me ain't no ground lubber."}
	STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.TURF_MARSH = {"Squishy"}
	STRINGS.CHARACTERS.WORTOX.DESCRIBE.TURF_MARSH = {"Floor or ceiling, depending on your perspective."}
	STRINGS.CHARACTERS.WURT.DESCRIBE.TURF_MARSH = {"Ground bit."}
	STRINGS.CHARACTERS.WX78.DESCRIBE.TURF_MARSH = {"THE GROUND"}]]
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
--. Strings
	
--//Merm King//

_S.MERM_KING_TALK_HUNGER_STARVING = "Hungry... HUNGRY! HUNGRYYYY!!!"
_S.MERM_KING_TALK_HUNGER_CLOSE_STARVING = "Treachery... villainy! To let King waste away like this..."
_S.MERM_KING_TALK_HUNGER_VERY_HUNGRY = "What take so long? Make offerings to your King!"
_S.MERM_KING_TALK_HUNGER_HUNGRY = "King desires food!"
_S.MERM_KING_TALK_HUNGER_HUNGRISH = "King feeling a bit peckish..."
_S.MERM_KING_TALK_HUNGER_FULL =  "Have done well. Now go."
	
	