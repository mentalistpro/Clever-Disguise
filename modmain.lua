local _G = GLOBAL
local _S = _G.STRINGS
local IsDLCEnabled = _G.IsDLCEnabled
local Ingredient = _G.Ingredient
local Recipe = _G.Recipe
local RECIPETABS = _G.RECIPETABS
local TECH = _G.TECH
	
PrefabFiles = 
{
	"mermhat"
}

Assets = 
{
    Asset("ATLAS", "images/inventoryimages/mermhat.xml"),
    Asset("IMAGE", "images/inventoryimages/mermhat.tex")
}

------------------------------------------------------------------------------------------------------------------------
--Config

TUNING.MOD_MERMHAT_PERISH = GetModConfigData("perish")

------------------------------------------------------------------------------------------------------------------------
--Recipe

if IsDLCEnabled(3) then
	local mermhat = Recipe("mermhat",
	{ 
	Ingredient("fish", 1), 
	Ingredient("cutreeds", 1), 
	Ingredient("twigs", 2) 
	}, 
	RECIPETABS.DRESS, TECH.NONE, "common")
	mermhat.atlas = "images/inventoryimages/mermhat.xml"	
	mermhat.image = "mermhat.tex"

	local mermhat_sw = Recipe("mermhat",
	{ 
	Ingredient("tropical_fish", 1), 
	Ingredient("cutreeds", 1), 
	Ingredient("twigs", 2) 
	}, 
	RECIPETABS.DRESS, TECH.NONE, "shipwrecked") 
	mermhat_sw.atlas = "images/inventoryimages/mermhat.xml"
	mermhat_sw.image = "mermhat.tex"
	
elseif IsDLCEnabled(2) then
	local mermhat = Recipe("mermhat",
	{ 
	Ingredient("fish", 1), 
	Ingredient("cutreeds", 1), 
	Ingredient("twigs", 2) 
	}, 
	RECIPETABS.DRESS, TECH.NONE, "rog") 
	mermhat.atlas = "images/inventoryimages/mermhat.xml"	
	mermhat.image = "mermhat.tex"
	
	local mermhat_sw = Recipe("mermhat",
	{ 
	Ingredient("tropical_fish", 1), 
	Ingredient("cutreeds", 1), 
	Ingredient("twigs", 2) 
	}, 
	RECIPETABS.DRESS, TECH.NONE, "shipwrecked") 
	mermhat_sw.atlas = "images/inventoryimages/mermhat.xml"
	mermhat_sw.image = "mermhat.tex"
	
else
	local mermhat = Recipe("mermhat",
	{ 
	Ingredient("fish", 1), 
	Ingredient("cutreeds", 1), 
	Ingredient("twigs", 2) 
	}, 
	RECIPETABS.DRESS, TECH.NONE)
	mermhat.atlas = "images/inventoryimages/mermhat.xml"
end

------------------------------------------------------------------------------------------------------------------------
--Strings

_S.NAMES.MERMHAT = "Clever Disguise"
_S.RECIPE_DESC.MERMHAT = "Merm-ify your friends."

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