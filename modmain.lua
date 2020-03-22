PrefabFiles = 
{
    "merm",
    "mermhat",
    "disguisehat"
}

Assets = 
{
    Asset("ATLAS", "images/inventoryimages/mermhat.xml"),
    Asset("ATLAS", "images/inventoryimages/disguisehat.xml"),
}

-----------------------------------------------------------------

--[[CONTENT]]
--#1 Config
--#2 Recipes
--#3 Strings
--#4 AddPrefabPostInit

-----------------------------------------------------------------
--#1 Config
    
--Merm
    TUNING.MERM_DAMAGE = 30
    TUNING.MERM_DAMAGE_KINGBONUS = 40
    TUNING.MERM_HEALTH = 250
    TUNING.MERM_HEALTH_KINGBONUS = 280

    TUNING.MERM_ATTACK_PERIOD = 3 
    TUNING.MERM_DEFEND_DIST = 30
    TUNING.MERM_TARGET_DIST = 10
    TUNING.MERM_RUN_SPEED = 8
    TUNING.MERM_WALK_SPEED = 3

    TUNING.MERM_LOYALTY_MAXTIME = 3 * 480
    TUNING.MERM_LOYALTY_PER_HUNGER = 480/25
    TUNING.MERM_MAX_TARGET_SHARES = 5
    TUNING.MERM_SHARE_TARGET_DIST = 40

--Mermguard
    TUNING.PUNY_MERM_DAMAGE = 20
    TUNING.MERM_GUARD_DAMAGE = 50
    TUNING.PUNY_MERM_HEALTH = 200
    TUNING.MERM_GUARD_HEALTH = 330
    
    TUNING.MERM_GUARD_ATTACK_PERIOD = 3 
    TUNING.MERM_GUARD_DEFEND_DIST = 40
    TUNING.MERM_GUARD_TARGET_DIST = 15
    TUNING.MERM_GUARD_RUN_SPEED = 8
    TUNING.MERM_GUARD_WALK_SPEED = 3

    TUNING.MERM_GUARD_LOYALTY_MAXTIME = 3 * 480
    TUNING.MERM_GUARD_LOYALTY_PER_HUNGER = 480/25
    TUNING.MERM_GUARD_MAX_TARGET_SHARES = 8
    TUNING.MERM_GUARD_SHARE_TARGET_DIST = 60
    
--Mermhat
    TUNING.MERMHAT_PERISH = GetModConfigData("perish")
    
--Merm sanity aura (change it in Wurt mod)
    TUNING.WURT_QOL_BUFF = 0

-----------------------------------------------------------------
--#2 Recipes

local _G = GLOBAL
local IsDLCEnabled = _G.IsDLCEnabled
local Ingredient = _G.Ingredient
local Recipe = _G.Recipe
local RECIPETABS = _G.RECIPETABS
local TECH = _G.TECH

--Mermhat
if IsDLCEnabled and ( IsDLCEnabled(2) or IsDLCEnabled(3) ) then
    local mermhat = Recipe(                                 
        "mermhat", 
        {
            Ingredient("tropical_fish", 1), 
            Ingredient("cutreeds", 1), 
            Ingredient("twigs", 2)
        },
        RECIPETABS.DRESS, TECH.NONE, "shipwrecked")
        mermhat.atlas = "images/inventoryimages/mermhat.xml"
        mermhat.sortkey = 1
end

local mermhat = Recipe(                                 
    "mermhat", 
    {
        Ingredient("fish", 1), 
        Ingredient("cutreeds", 1), 
        Ingredient("twigs", 2)
    },
    RECIPETABS.DRESS, TECH.NONE)    
    mermhat.atlas = "images/inventoryimages/mermhat.xml"
    mermhat.sortkey = 1

--Pighat

local disguisehat = Recipe(                                 
    "disguisehat", 
    {
        Ingredient("twigs", 2), 
        Ingredient("pigskin", 1), 
        Ingredient("beardhair", 1)
    },
    RECIPETABS.DRESS, TECH.NONE)
    
    if IsDLCEnabled and ( IsDLCEnabled(1) or IsDLCEnabled(2) or IsDLCEnabled(3) ) then
        disguisehat.game_type = "common"
    end
    disguisehat.atlas = "images/inventoryimages/disguisehat.xml"
    disguisehat.sortkey = 2
    
------------------------------------------------------------------------------------------------------------------------
--#3 Strings

local _S = _G.STRINGS

if _S.CHARACTERS.WALANI     == nil then _S.CHARACTERS.WALANI        = { DESCRIBE = {},} end -- DLC002
if _S.CHARACTERS.WARBUCKS   == nil then _S.CHARACTERS.WARBUCKS      = { DESCRIBE = {},} end -- DLC003
if _S.CHARACTERS.WARLY      == nil then _S.CHARACTERS.WARLY         = { DESCRIBE = {},} end -- DLC002
if _S.CHARACTERS.WATHGRITHR == nil then _S.CHARACTERS.WATHGRITHR    = { DESCRIBE = {},} end -- DLC001
if _S.CHARACTERS.WEBBER     == nil then _S.CHARACTERS.WEBBER        = { DESCRIBE = {},} end -- DLC001
if _S.CHARACTERS.WHEELER    == nil then _S.CHARACTERS.WHEELER       = { DESCRIBE = {},} end -- DLC003
if _S.CHARACTERS.WILBA      == nil then _S.CHARACTERS.WILBA         = { DESCRIBE = {},} end -- DLC003
if _S.CHARACTERS.WINONA     == nil then _S.CHARACTERS.WINONA        = { DESCRIBE = {},} end -- DST
if _S.CHARACTERS.WOODLEGS   == nil then _S.CHARACTERS.WOODLEGS      = { DESCRIBE = {},} end -- DLC002
if _S.CHARACTERS.WORMWOOD   == nil then _S.CHARACTERS.WORMWOOD      = { DESCRIBE = {},} end -- DLC003
if _S.CHARACTERS.WORTOX     == nil then _S.CHARACTERS.WORTOX        = { DESCRIBE = {},} end -- DST
if _S.CHARACTERS.WURT       == nil then _S.CHARACTERS.WURT          = { DESCRIBE = {},} end -- DST

--Mermhat

_S.NAMES.MERMHAT = "Clever Disguise"
_S.RECIPE_DESC.MERMHAT = "Merm-ify your friends."

_S.CHARACTERS.GENERIC.DESCRIBE.MERMHAT      = {"Finally, I can show my face in public."}
_S.CHARACTERS.WARLY.DESCRIBE.MERMHAT        = {"Mon dieu, must I dress as a frog?"}
_S.CHARACTERS.WATHGRITHR.DESCRIBE.MERMHAT   = {"Tis a deceitful mask."}
_S.CHARACTERS.WAXWELL.DESCRIBE.MERMHAT      = {"This seems rather... fishy."}
_S.CHARACTERS.WEBBER.DESCRIBE.MERMHAT       = {"Hopefully they don't notice the extra legs."}
_S.CHARACTERS.WENDY.DESCRIBE.MERMHAT        = {"We all hide behind our own masks..."}
_S.CHARACTERS.WICKERBOTTOM.DESCRIBE.MERMHAT = {"I'm not eager to test out its effectiveness."}
_S.CHARACTERS.WILLOW.DESCRIBE.MERMHAT       = {"Yuck, who'd want a face like that?"}
_S.CHARACTERS.WINONA.DESCRIBE.MERMHAT       = {"Do I look a little green around the gills? Ha!"}
_S.CHARACTERS.WOLFGANG.DESCRIBE.MERMHAT     = {"Wolfgang will be biggest and strongest fish man!"}
_S.CHARACTERS.WOODIE.DESCRIBE.MERMHAT       = {"Not sure it'll fit over my luxurious beard."}
_S.CHARACTERS.WORMWOOD.DESCRIBE.MERMHAT     = {"Glub Glub pretend face"}
_S.CHARACTERS.WORTOX.DESCRIBE.MERMHAT       = {"Some would call me two-faced, hyuyu!"}
_S.CHARACTERS.WURT.DESCRIBE.MERMHAT         = {"Make scale-less look like friendly Mermfolk!"}
_S.CHARACTERS.WX78.DESCRIBE.MERMHAT         = {"WARTY CONCEALMENT"}

--Pighat

_S.NAMES.DISGUISEHAT = "Shamlet Mask"
_S.RECIPE_DESC.DISGUISEHAT = "A fresh face."

_S.CHARACTERS.GENERIC.DESCRIBE.DISGUISEHAT      = {"For swindling a swine."}
_S.CHARACTERS.WARLY.DESCRIBE.DISGUISEHAT        = {"It is the icing on the face."}
_S.CHARACTERS.WATHGRITHR.DESCRIBE.DISGUISEHAT   = {"Öne öf Löki's tricks."}
_S.CHARACTERS.WAXWELL.DESCRIBE.DISGUISEHAT      = {"Doesn't fool me."}
_S.CHARACTERS.WEBBER.DESCRIBE.DISGUISEHAT       = {"I bet we can fool those pigs with this!"}
_S.CHARACTERS.WENDY.DESCRIBE.DISGUISEHAT        = {"Full of deception."}
_S.CHARACTERS.WICKERBOTTOM.DESCRIBE.DISGUISEHAT = {"Clever."}
_S.CHARACTERS.WILLOW.DESCRIBE.DISGUISEHAT       = {"Who would fall for that disguise?"}
_S.CHARACTERS.WINONA.DESCRIBE.DISGUISEHAT       = {"Do I look a little pink around the gills? Ha!"}
_S.CHARACTERS.WOLFGANG.DESCRIBE.DISGUISEHAT     = {"Hehe. Is funny little pig mask."}
_S.CHARACTERS.WOODIE.DESCRIBE.DISGUISEHAT       = {"Hehe. It's like a halloween mask."}
_S.CHARACTERS.WORMWOOD.DESCRIBE.DISGUISEHAT     = {"Twirly Tail?"}
_S.CHARACTERS.WORTOX.DESCRIBE.DISGUISEHAT       = {"Some would call me two-faced, hyuyu!"}
_S.CHARACTERS.WURT.DESCRIBE.DISGUISEHAT         = {"Disgusting to mermfolk, florp!"}
_S.CHARACTERS.WX78.DESCRIBE.DISGUISEHAT         = {"FACIAL ENCRYPTION."}

_S.CHARACTERS.WAGSTAFF.DESCRIBE.DISGUISEHAT     = {"Theoretically, this is what passes for a disguise here."}
_S.CHARACTERS.WALANI.DESCRIBE.DISGUISEHAT       = {"Ha! It's kinda cute!"}
_S.CHARACTERS.WHEELER.DESCRIBE.DISGUISEHAT      = {"A disguise sneaky enough to fool those city pigs."}
_S.CHARACTERS.WILBA.DESCRIBE.DISGUISEHAT        = {"A MERRY VISAGE"}
_S.CHARACTERS.WOODLEGS.DESCRIBE.DISGUISEHAT     = {"'Tis fer foolin' tha'pigs."}

--Merm Guard

_S.NAMES.MERMGUARD = "Loyal Merm Guard"

_S.CHARACTERS.GENERIC.DESCRIBE.MERMGUARD        = {"I feel very guarded around these guys..."}
_S.CHARACTERS.WARLY.DESCRIBE.MERMGUARD          = {"A most fearsome fishmonger!"}
_S.CHARACTERS.WATHGRITHR.DESCRIBE.MERMGUARD     = {"A formidable warrior, to be sure."}
_S.CHARACTERS.WAXWELL.DESCRIBE.MERMGUARD        = {"I'd best try to stay on their good side."}
_S.CHARACTERS.WEBBER.DESCRIBE.MERMGUARD         = {"They look pretty scary!"}
_S.CHARACTERS.WENDY.DESCRIBE.MERMGUARD          = {"Friend or foe?"}
_S.CHARACTERS.WICKERBOTTOM.DESCRIBE.MERMGUARD   = {"A royal bodyguard."}
_S.CHARACTERS.WILLOW.DESCRIBE.MERMGUARD         = {"I can't tell which way it's looking."}
_S.CHARACTERS.WINONA.DESCRIBE.MERMGUARD         = {"Just doin' their job."}
_S.CHARACTERS.WOLFGANG.DESCRIBE.MERMGUARD       = {"Not as mighty as Wolfgang!"}
_S.CHARACTERS.WOODIE.DESCRIBE.MERMGUARD         = {"They stand on guard for the king."}
_S.CHARACTERS.WORMWOOD.DESCRIBE.MERMGUARD       = {"Friends?"}
_S.CHARACTERS.WORTOX.DESCRIBE.MERMGUARD         = {"The horns are an improvement."}
_S.CHARACTERS.WURT.DESCRIBE.MERMGUARD           = {"Will grow up big and strong like that one day!"}
_S.CHARACTERS.WX78.DESCRIBE.MERMGUARD           = {"YOU WOULD MAKE AN EXCELLENT MINION"}

--Merm Talk

_S.MERM_TALK_FOLLOWWILSON_UNTRANSLATED      = {"Flort glut.", "Blut gloppy Glurtsu!", "Glut Glurtsu flopt!", "Florpy flort."}
_S.MERM_TALK_FOLLOWWILSON                   = {"Will come with you.", "Make Mermfolk strong!", "You help Mermfolk!", "You okay."}
_S.MERM_TALK_FIND_FOOD_UNTRANSLATED         = {"Flort glut.", "Blut gloppy Glurtsu!", "Glort grolt flut.", "Glurt florpy flut!"}
_S.MERM_TALK_FIND_FOOD                      = {"Will come with you.", "Make Mermfolk strong!", "This do fine.", "Find something tasty!"}

_S.MERM_TALK_HELP_CHOP_WOOD_UNTRANSLATED    = {"Flort glut.", "Blut gloppy Glurtsu!", "Grop, groppy, grop!", "Glort blut, florp!"}
_S.MERM_TALK_HELP_CHOP_WOOD                 = {"Will come with you.", "Make Mermfolk strong!", "Chop, choppy, chop!", "Work hard, florp!"}
_S.MERM_TALK_HELP_MINE_ROCK_UNTRANSLATED    = {"Flort glut.", "Blut gloppy Glurtsu!", "Wult wop, florty flort!", "Glort blut, florp!"}
_S.MERM_TALK_HELP_MINE_ROCK                 = {"Will come with you.", "Make Mermfolk strong!", "Break rock, easy!", "Work hard, florp!"}
_S.MERM_TALK_HELP_HAMMER_UNTRANSLATED       = {"Flort glut.", "Blut gloppy Glurtsu!", "Florph! Florph!", "Glort blut, florp!"}
_S.MERM_TALK_HELP_HAMMER                    = {"Will come with you.", "Make Mermfolk strong!", "Smash! Smash!", "Work hard, florp!"}

_S.MERM_TALK_PANICBOSS_UNTRANSLATED         = {"Gloppy flort!", "Gloooorph!! Glurph glot! Glurph glot!", "Flort wult Glurtsu!"}
_S.MERM_TALK_PANICBOSS                      = {"Something coming!", "Aaah!! Bad thing! Bad thing!", "It come to destroy us!"}
_S.MERM_TALK_PANICBOSS_KING_UNTRANSLATED    = {"Glurtsen blut flort!", "Flurph flrot! Gloppy Glurtsam!", "G-glop blut flrot!!"}
_S.MERM_TALK_PANICBOSS_KING                 = {"Rally to King!", "Hurry! Protect kingdom!", "S-stay brave!!"}

_S.MERM_BATTLECRY_UNTRANSLATED              = {"Glorp! Glorpy glup!", "Wult glut!"}
_S.MERM_BATTLECRY                           = {"Glorp! Go away!", "Destroy you!"}
_S.MERM_GUARD_BATTLECRY_UNTRANSLATED        = {"Wult flrot!", "Flort Glurtsu flut!", "GLOT FLOOOORPH!!", "Glurph Glurtsen!"}
_S.MERM_GUARD_BATTLECRY                     = {"To battle!", "For glory of Mermfolk!", "ATTAAAACK!!", "Defend King!"}

------------------------------------------------------------------------------------------------------------------------
--#4 AddPrefabPostInit

--//Fish tags
local function ItemIsFish(inst)
    inst:AddTag("fish")
end

AddPrefabPostInit("eel", ItemIsFish)
AddPrefabPostInit("fish", ItemIsFish)
AddPrefabPostInit("tropical_fish", ItemIsFish)

--//Pigs target merms
local FindEntity = _G.FindEntity
local GetPlayer = _G.GetPlayer

local function NormalRetargetfn_new(inst)
    return FindEntity(inst, TUNING.PIG_TARGET_DIST,
    function(guy)
        if not guy.LightWatcher or guy.LightWatcher:IsInLight() then
            return (guy:HasTag("monster") or guy:HasTag("merm") ) and guy.components.health and not guy.components.health:IsDead() and inst.components.combat:CanTarget(guy) and not 
            (inst.components.follower.leader ~= nil and guy:HasTag("abigail"))
        end
    end)
end

local prefabs = {"pigman", "wildbore"} --no need to touch prefabs/pigguard.lua

for k,v in pairs(prefabs) do
    AddPrefabPostInit(v, function(inst)   
        if inst.components.combat then
            inst.components.combat:SetRetargetFunction(3, NormalRetargetfn_new)
        end
    end)
end

--//Royal pigguards target merms
local function NormalRetargetFn_royal_new(inst)
    return FindEntity(inst, TUNING.CITY_PIG_GUARD_TARGET_DIST,
        function(guy)
            if not guy.LightWatcher or guy.LightWatcher:IsInLight() then

                if guy == GetPlayer() and inst:HasTag("angry_at_player") and guy.components.health and not guy.components.health:IsDead() and inst.components.combat:CanTarget(guy) and inst.components.combat.target ~= GetPlayer() then
                    inst.sayline(inst, getSpeechType(inst,STRINGS.CITY_PIG_GUARD_TALK_ANGRY_PLAYER))
                end

                return (guy:HasTag("monster") or guy:HasTag("merm") or (guy == GetPlayer() and inst:HasTag("angry_at_player"))  ) and guy.components.health and not guy.components.health:IsDead() and inst.components.combat:CanTarget(guy) and not 
                (inst.components.follower.leader ~= nil and guy:HasTag("abigail"))
            end
        end)
end

local prefabs = {"pigman_royalguard", "pigman_royalguard_2"} --no need to touch prefabs/pigguard.lua

for k,v in pairs(prefabs) do
    AddPrefabPostInit(v, function(inst)   
        if inst.components.combat then
            inst.components.combat:SetRetargetFunction(3, NormalRetargetFn_royal_new)
        end
    end)
end

--//Spawn mermguard in mermwatchtower -- previously, it spawns normal merms in Mermhouse Crafting
local function MermguardReturns(inst)
    inst.components.childspawner.childname = "mermguard"
end

AddPrefabPostInit("mermwatchtower", MermguardReturns) 

--//Add new food category "HONEY"
AddPrefabPostInit("honey", 
    function(inst)
        inst.components.edible.foodtype = "HONEY"
    end
)
