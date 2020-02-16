PrefabFiles = 
{
    "kelp",
    "kelphat",
    "mermking",
    "mermsplashes",
    "mermthrone",
}

Assets = 
{
    Asset("ATLAS", "images/inventoryimages/kelp.xml"),
    Asset("ATLAS", "images/inventoryimages/kelp_cooked.xml"),
    Asset("ATLAS", "images/inventoryimages/kelp_dried.xml"),
    Asset("ATLAS", "images/inventoryimages/kelphat.xml"),
    Asset("ATLAS", "images/inventoryimages/mermthrone_construction.xml"),
    Asset("ATLAS", "minimap/merm_king_carpet.xml"),
    Asset("ATLAS", "minimap/merm_king_carpet_construction.xml"),
    Asset("ATLAS", "minimap/merm_king_carpet_occupied.xml")
}

AddMinimapAtlas("minimap/merm_king_carpet.xml")
AddMinimapAtlas("minimap/merm_king_carpet_construction.xml")
AddMinimapAtlas("minimap/merm_king_carpet_occupied.xml")

-------------------------------------------------------------------------------

--[[CONTENT]]
--#1 Config
--#2 Recipes
--#3 Strings
--#4 Modified drying_rack
--#5 New functions

-------------------------------------------------------------------------------
--#1 Config

TUNING.MOD_MERMKING_EXCHANGE_BONUS = 0
if GetModConfigData("exchange_rate") == 1 then
    TUNING.MOD_MERMKING_EXCHANGE_BONUS = 2
elseif GetModConfigData("exchange_rate") == 2 then
    TUNING.MOD_MERMKING_EXCHANGE_BONUS = 4
elseif GetModConfigData("exchange_rate") == 3 then
    TUNING.MOD_MERMKING_EXCHANGE_BONUS = 6
end

TUNING.MERM_KING_HEALTH = 1000
TUNING.MERM_KING_HEALTH_REGEN_PERIOD = 1
TUNING.MERM_KING_HEALTH_REGEN = 2
TUNING.MERM_KING_HUNGER = 200
TUNING.MERM_KING_HUNGER_KILLTUNINGIME = 480 * 2
TUNING.MERM_KING_HUNGER_RATE = 200 / (480 * 4)

-------------------------------------------------------------------------------
--#2 Recipes

local _G = GLOBAL
local Ingredient = _G.Ingredient
local IsDLCEnabled = _G.IsDLCEnabled
local Recipe = _G.Recipe
local RECIPETABS = _G.RECIPETABS
local RECIPE_GAME_TYPE = _G.RECIPE_GAME_TYPE
local TECH = _G.TECH

--Mermthrone (DIY Royal Kit)

local mermthrone_construction = Recipe(
    "mermthrone_construction", 
    {
    Ingredient("boards", 5), 
    Ingredient("rope", 5),
    },
    RECIPETABS.TOWN, 
    TECH.SCIENCE_ONE)
    mermthrone_construction.placer = "mermthrone_construction_placer"
    mermthrone_construction.atlas = "images/inventoryimages/mermthrone_construction.xml"
    if IsDLCEnabled(2) or IsDLCEnabled(3) then
        mermthrone_construction.gameTUNINGype = "common"
    end

-------------------------------------------------------------------------------
--#3 Strings

local _S = _G.STRINGS

if _S.CHARACTERS.WAGSTAFF == nil then _S.CHARACTERS.WAGSTAFF = { DESCRIBE = {}, } end -- DLC003
if _S.CHARACTERS.WALANI == nil then _S.CHARACTERS.WALANI = { DESCRIBE = {}, } end -- DLC002
if _S.CHARACTERS.WARLY == nil then _S.CHARACTERS.WARLY = { DESCRIBE = {},   } end -- DLC002
if _S.CHARACTERS.WATHGRITHR == nil then _S.CHARACTERS.WATHGRITHR = { DESCRIBE = {}, }  end -- DLC001
if _S.CHARACTERS.WEBBER == nil then _S.CHARACTERS.WEBBER = { DESCRIBE = {}, }  end -- DLC001
if _S.CHARACTERS.WHEELER == nil then _S.CHARACTERS.WHEELER = { DESCRIBE = {}, } end -- DLC003
if _S.CHARACTERS.WILBA == nil then _S.CHARACTERS.WILBA = { DESCRIBE = {}, } end -- DLC003
if _S.CHARACTERS.WINONA == nil then _S.CHARACTERS.WINONA = { DESCRIBE = {}, } end -- DST
if _S.CHARACTERS.WOODLEGS == nil then _S.CHARACTERS.WOODLEGS = { DESCRIBE = {}, } end -- DLC002
if _S.CHARACTERS.WORMWOOD == nil then _S.CHARACTERS.WORMWOOD = { DESCRIBE = {}, }  end -- DLC003
if _S.CHARACTERS.WORTOX == nil then _S.CHARACTERS.WORTOX = { DESCRIBE = {}, }  end -- DST
if _S.CHARACTERS.WURT == nil then _S.CHARACTERS.WURT = { DESCRIBE = {}, } end -- DST

--Mermthrone_construction

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
_S.CHARACTERS.WX78.DESCRIBE.MERMTHRONE_CONSTRUCTION = {"THE GREEN ONE IS DOING SOMETHING USELESS"}

--Mermthrone

_S.NAMES.MERMTHRONE = "Royal Tapestry"

_S.CHARACTERS.GENERIC.DESCRIBE.MERMTHRONE = {"Looks fit for a swamp king!"}
_S.CHARACTERS.WARLY.DESCRIBE.MERMTHRONE = {"Très royal!"}
_S.CHARACTERS.WATHGRITHR.DESCRIBE.MERMTHRONE = {"Have you chosen a chieftain?"}
_S.CHARACTERS.WAXWELL.DESCRIBE.MERMTHRONE = {"Not especially impressive for a 'throne'."}
_S.CHARACTERS.WEBBER.DESCRIBE.MERMTHRONE = {"Hey, can we be the king? We can take turns!"}
_S.CHARACTERS.WENDY.DESCRIBE.MERMTHRONE = {"The Frogs Who Desired a King..."}
_S.CHARACTERS.WICKERBOTTOM.DESCRIBE.MERMTHRONE = {"The 'if it fits, it sits' method of choosing a monarch. I'm familiar."}
_S.CHARACTERS.WILLOW.DESCRIBE.MERMTHRONE = {"I shouldn't burn it... but I want to..."}
_S.CHARACTERS.WINONA.DESCRIBE.MERMTHRONE = {"Not bad handiwork."}
_S.CHARACTERS.WOLFGANG.DESCRIBE.MERMTHRONE = {"Big chair looks very inviting."}
_S.CHARACTERS.WOODIE.DESCRIBE.MERMTHRONE = {"I'm from a Commonwealth, myself."}
_S.CHARACTERS.WORMWOOD.DESCRIBE.MERMTHRONE = {"Place for big Glub Glub"}
_S.CHARACTERS.WORTOX.DESCRIBE.MERMTHRONE = {"A mat made for a monarch."}
_S.CHARACTERS.WX78.DESCRIBE.MERMTHRONE = {"THIS IS WHERE THEY DEPOSIT THEIR ROYALTY"}


--Merm king quotes

_S.MERM_KINGTUNINGALK_HUNGER_STARVING = "Hungry... HUNGRY! HUNGRYYYY!!!"
_S.MERM_KINGTUNINGALK_HUNGER_CLOSE_STARVING = "Treachery... villainy! To let King waste away like this..."
_S.MERM_KINGTUNINGALK_HUNGER_VERY_HUNGRY = "What take so long? Make offerings to your King!"
_S.MERM_KINGTUNINGALK_HUNGER_HUNGRY = "King desires food!"
_S.MERM_KINGTUNINGALK_HUNGER_HUNGRISH = "King feeling a bit peckish..."
_S.MERM_KINGTUNINGALK_HUNGER_FULL =  "Have done well. Now go."
    
-------------------------------------------------------------------------------
--#4 Modified drying_rack

local function ModDryingRack(inst)

    local oldonstartdrying = inst.components.dryer.onstartcooking
    local onstartdrying = function(inst, dryable, ...)
        if dryable == "kelp" then
            inst.AnimState:PlayAnimation("drying_pre")
            inst.AnimState:PushAnimation("drying_loop", true)
            inst.AnimState:OverrideSymbol("swap_dried", "meat_rack_kelp", "kelp")
            return
        end

        return oldonstartdrying(inst, dryable, ...)
    end

    local oldsetdone = inst.components.dryer.oncontinuedone
    local setdone = function(inst, product, ...)
        if product == "kelp_dried" then
            inst.AnimState:PlayAnimation("idle_full")
            inst.AnimState:OverrideSymbol("swap_dried", "meat_rack_kelp", "kelp_dried")
            return
        end

        return oldsetdone(inst, product, ...)
    end

    inst.components.dryer:SetStartDryingFn(onstartdrying)
    inst.components.dryer:SetContinueDryingFn(onstartdrying)
    inst.components.dryer:SetDoneDryingFn(setdone)
    inst.components.dryer:SetContinueDoneFn(setdone)
end
 
AddPrefabPostInit("meatrack", ModDryingRack)
    
AddPrefabPostInit("merm", function(inst) inst:AddComponent("mermcandidate") end)

-------------------------------------------------------------------------------
--#5 New functions

function ReplacePrefab(original_inst, name)
    local x,y,z = original_inst.Transform:GetWorldPosition()
    
    local replacement_inst = SpawnPrefab(name)
    replacement_inst.Transform:SetPosition(x,y,z)
    original_inst:Remove()

    return replacement_inst
end


