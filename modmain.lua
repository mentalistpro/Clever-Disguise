PrefabFiles = 
{
	"mermhat"
}

Assets = 
{
    Asset("ATLAS", "images/inventoryimages/mermhat.xml"),
}

-----------------------------------------------------------------

--//CONTENT//
--1. Config
--2. Recipes
--3. Strings

-----------------------------------------------------------------
--1. Config

TUNING.MERMHAT_PERISH = GetModConfigData("perish")

local function ItemIsFish(inst)
	inst:AddTag("fish")
end

AddPrefabPostInit("eel", ItemIsFish)
AddPrefabPostInit("fish", ItemIsFish)
AddPrefabPostInit("tropical_fish", ItemIsFish)

-----------------------------------------------------------------
--2. Recipes

local _G = GLOBAL
local IsDLCEnabled = _G.IsDLCEnabled
local Ingredient = _G.Ingredient
local Recipe = _G.Recipe
local RECIPETABS = _G.RECIPETABS
local TECH = _G.TECH
	
if IsDLCEnabled(2) or IsDLCEnabled(3) then
	local mermhat = Recipe(									--register recipe at ROG/HAM world.
		"mermhat", 
		{
			Ingredient("fish", 1), 
			Ingredient("cutreeds", 1), 
			Ingredient("twigs", 2)
		},
		RECIPETABS.DRESS, TECH.NONE, "common")
		mermhat.atlas = "images/inventoryimages/mermhat.xml"
		
	local mermhat_sw = Recipe(								--register recipe at SW world.
		"mermhat", 
		{
			Ingredient("tropical_fish", 1), 
			Ingredient("cutreeds", 1), 
			Ingredient("twigs", 2)
		},
		RECIPETABS.DRESS, TECH.NONE, "shipwrecked")
		mermhat_sw.atlas = "images/inventoryimages/mermhat.xml"
else
	local mermhat = Recipe(									--register recipe at Vanilla world.
		"mermhat", 
		{
			Ingredient("fish", 1), 
			Ingredient("cutreeds", 1), 
			Ingredient("twigs", 2)
		},
		RECIPETABS.DRESS, TECH.NONE)
		mermhat.atlas = "images/inventoryimages/mermhat.xml"
end

------------------------------------------------------------------------------------------------------------------------
--3. Strings

local _S = _G.STRINGS

if _S.CHARACTERS.WALANI 	== nil then _S.CHARACTERS.WALANI 		= { DESCRIBE = {},} end -- DLC002
if _S.CHARACTERS.WARBUCKS 	== nil then _S.CHARACTERS.WARBUCKS	 	= { DESCRIBE = {},} end -- DLC003
if _S.CHARACTERS.WARLY 		== nil then _S.CHARACTERS.WARLY 		= { DESCRIBE = {},} end -- DLC002
if _S.CHARACTERS.WATHGRITHR == nil then _S.CHARACTERS.WATHGRITHR 	= { DESCRIBE = {},} end -- DLC001
if _S.CHARACTERS.WEBBER 	== nil then _S.CHARACTERS.WEBBER 		= { DESCRIBE = {},} end -- DLC001
if _S.CHARACTERS.WHEELER 	== nil then _S.CHARACTERS.WHEELER 		= { DESCRIBE = {},} end -- DLC003
if _S.CHARACTERS.WILBA 		== nil then _S.CHARACTERS.WILBA 		= { DESCRIBE = {},} end -- DLC003
if _S.CHARACTERS.WINONA	 	== nil then _S.CHARACTERS.WINONA 		= { DESCRIBE = {},} end -- DST
if _S.CHARACTERS.WOODLEGS 	== nil then _S.CHARACTERS.WOODLEGS 		= { DESCRIBE = {},} end -- DLC002
if _S.CHARACTERS.WORMWOOD 	== nil then _S.CHARACTERS.WORMWOOD 		= { DESCRIBE = {},} end -- DLC003
if _S.CHARACTERS.WORTOX 	== nil then _S.CHARACTERS.WORTOX 		= { DESCRIBE = {},} end -- DST
if _S.CHARACTERS.WURT 		== nil then _S.CHARACTERS.WURT 			= { DESCRIBE = {},} end -- DST

--Clever Disguise

_S.NAMES.MERMHAT = "Clever Disguise"
_S.RECIPE_DESC.MERMHAT = "Merm-ify your friends."

_S.CHARACTERS.GENERIC.DESCRIBE.MERMHAT 		= {"Finally, I can show my face in public."}
_S.CHARACTERS.WARLY.DESCRIBE.MERMHAT 		= {"Mon dieu, must I dress as a frog?"}
_S.CHARACTERS.WATHGRITHR.DESCRIBE.MERMHAT 	= {"Tis a deceitful mask."}
_S.CHARACTERS.WAXWELL.DESCRIBE.MERMHAT 		= {"This seems rather... fishy."}
_S.CHARACTERS.WEBBER.DESCRIBE.MERMHAT 		= {"Hopefully they don't notice the extra legs."}
_S.CHARACTERS.WENDY.DESCRIBE.MERMHAT 		= {"We all hide behind our own masks..."}
_S.CHARACTERS.WICKERBOTTOM.DESCRIBE.MERMHAT = {"I'm not eager to test out its effectiveness."}
_S.CHARACTERS.WILLOW.DESCRIBE.MERMHAT 		= {"Yuck, who'd want a face like that?"}
_S.CHARACTERS.WINONA.DESCRIBE.MERMHAT 		= {"Do I look a little green around the gills? Ha!"}
_S.CHARACTERS.WOLFGANG.DESCRIBE.MERMHAT		= {"Wolfgang will be biggest and strongest fish man!"}
_S.CHARACTERS.WOODIE.DESCRIBE.MERMHAT 		= {"Not sure it'll fit over my luxurious beard."}
_S.CHARACTERS.WORMWOOD.DESCRIBE.MERMHAT 	= {"Glub Glub pretend face"}
_S.CHARACTERS.WORTOX.DESCRIBE.MERMHAT 		= {"Some would call me two-faced, hyuyu!"}
_S.CHARACTERS.WURT.DESCRIBE.MERMHAT 		= {"Make scale-less look like friendly Mermfolk!"}
_S.CHARACTERS.WX78.DESCRIBE.MERMHAT 		= {"WARTY CONCEALMENT"}

--Merm Guard

_S.NAMES.MERMGUARD = "Loyal Merm Guard"

_S.CHARACTERS.GENERIC.DESCRIBE.MERMGUARD 		= {"I feel very guarded around these guys..."}
_S.CHARACTERS.WARLY.DESCRIBE.MERMGUARD 			= {"A most fearsome fishmonger!"}
_S.CHARACTERS.WATHGRITHR.DESCRIBE.MERMGUARD 	= {"A formidable warrior, to be sure."}
_S.CHARACTERS.WAXWELL.DESCRIBE.MERMGUARD 		= {"I'd best try to stay on their good side."}
_S.CHARACTERS.WEBBER.DESCRIBE.MERMGUARD 		= {"They look pretty scary!"}
_S.CHARACTERS.WENDY.DESCRIBE.MERMGUARD 			= {"Friend or foe?"}
_S.CHARACTERS.WICKERBOTTOM.DESCRIBE.MERMGUARD 	= {"A royal bodyguard."}
_S.CHARACTERS.WILLOW.DESCRIBE.MERMGUARD 		= {"I can't tell which way it's looking."}
_S.CHARACTERS.WINONA.DESCRIBE.MERMGUARD 		= {"Just doin' their job."}
_S.CHARACTERS.WOLFGANG.DESCRIBE.MERMGUARD		= {"Not as mighty as Wolfgang!"}
_S.CHARACTERS.WOODIE.DESCRIBE.MERMGUARD 		= {"They stand on guard for the king."}
_S.CHARACTERS.WORMWOOD.DESCRIBE.MERMGUARD 		= {"Friends?"}
_S.CHARACTERS.WORTOX.DESCRIBE.MERMGUARD 		= {"The horns are an improvement."}
_S.CHARACTERS.WURT.DESCRIBE.MERMGUARD 			= {"Will grow up big and strong like that one day!"}
_S.CHARACTERS.WX78.DESCRIBE.MERMGUARD 			= {"YOU WOULD MAKE AN EXCELLENT MINION"}

--MERM_TALK_PANICBOSS_KING
--MERM_TALK_PANICBOSS
--MERM_TALK_FIND_FOOD
--MERM_TALK_HELP_CHOP_WOOD
--MERM_TALK_HELP_MINE_ROCK
--MERM_TALK_HELP_HAMMER
--MERM_TALK_FOLLOWWILSON
