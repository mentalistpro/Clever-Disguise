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
    TUNING.MERM_RUNSTRINGSPEED = 8
    TUNING.MERM_WALKSTRINGSPEED = 3

    TUNING.MERM_LOYALTY_MAXTIME = 3 * 480
    TUNING.MERM_LOYALTY_PER_HUNGER = 480/25
    TUNING.MERM_MAX_TARGETSTRINGSHARES = 5
    TUNING.MERMSTRINGSHARE_TARGET_DIST = 40

--Mermguard
    TUNING.PUNY_MERM_DAMAGE = 20
    TUNING.MERM_GUARD_DAMAGE = 50
    TUNING.PUNY_MERM_HEALTH = 200
    TUNING.MERM_GUARD_HEALTH = 330

    TUNING.MERM_GUARD_ATTACK_PERIOD = 3
    TUNING.MERM_GUARD_DEFEND_DIST = 40
    TUNING.MERM_GUARD_TARGET_DIST = 15
    TUNING.MERM_GUARD_RUNSTRINGSPEED = 8
    TUNING.MERM_GUARD_WALKSTRINGSPEED = 3

    TUNING.MERM_GUARD_LOYALTY_MAXTIME = 3 * 480
    TUNING.MERM_GUARD_LOYALTY_PER_HUNGER = 480/25
    TUNING.MERM_GUARD_MAX_TARGETSTRINGSHARES = 8
    TUNING.MERM_GUARDSTRINGSHARE_TARGET_DIST = 60

--Mermhat
    TUNING.MERMHAT_PERISH = GetModConfigData("mermhat_perish")

--Merm sanity aura? (change the aura setting in Wurt mod)
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

local STRINGS = _G.STRINGS

if STRINGS.CHARACTERS.WALANI     == nil then STRINGS.CHARACTERS.WALANI        = { DESCRIBE = {},} end -- DLC002
if STRINGS.CHARACTERS.WARBUCKS   == nil then STRINGS.CHARACTERS.WARBUCKS      = { DESCRIBE = {},} end -- DLC003
if STRINGS.CHARACTERS.WARLY      == nil then STRINGS.CHARACTERS.WARLY         = { DESCRIBE = {},} end -- DLC002
if STRINGS.CHARACTERS.WATHGRITHR == nil then STRINGS.CHARACTERS.WATHGRITHR    = { DESCRIBE = {},} end -- DLC001
if STRINGS.CHARACTERS.WEBBER     == nil then STRINGS.CHARACTERS.WEBBER        = { DESCRIBE = {},} end -- DLC001
if STRINGS.CHARACTERS.WHEELER    == nil then STRINGS.CHARACTERS.WHEELER       = { DESCRIBE = {},} end -- DLC003
if STRINGS.CHARACTERS.WILBA      == nil then STRINGS.CHARACTERS.WILBA         = { DESCRIBE = {},} end -- DLC003
if STRINGS.CHARACTERS.WINONA     == nil then STRINGS.CHARACTERS.WINONA        = { DESCRIBE = {},} end -- DST
if STRINGS.CHARACTERS.WOODLEGS   == nil then STRINGS.CHARACTERS.WOODLEGS      = { DESCRIBE = {},} end -- DLC002
if STRINGS.CHARACTERS.WORMWOOD   == nil then STRINGS.CHARACTERS.WORMWOOD      = { DESCRIBE = {},} end -- DLC003
if STRINGS.CHARACTERS.WORTOX     == nil then STRINGS.CHARACTERS.WORTOX        = { DESCRIBE = {},} end -- DST
if STRINGS.CHARACTERS.WURT       == nil then STRINGS.CHARACTERS.WURT          = { DESCRIBE = {},} end -- DST

--Mermhat
STRINGS.NAMES.MERMHAT = "Clever Disguise"
STRINGS.RECIPE_DESC.MERMHAT = "Merm-ify your friends."

STRINGS.CHARACTERS.GENERIC.DESCRIBE.MERMHAT      = {"Finally, I can show my face in public."}
STRINGS.CHARACTERS.WARLY.DESCRIBE.MERMHAT        = {"Mon dieu, must I dress as a frog?"}
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.MERMHAT   = {"Tis a deceitful mask."}
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.MERMHAT      = {"This seems rather... fishy."}
STRINGS.CHARACTERS.WEBBER.DESCRIBE.MERMHAT       = {"Hopefully they don't notice the extra legs."}
STRINGS.CHARACTERS.WENDY.DESCRIBE.MERMHAT        = {"We all hide behind our own masks..."}
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.MERMHAT = {"I'm not eager to test out its effectiveness."}
STRINGS.CHARACTERS.WILLOW.DESCRIBE.MERMHAT       = {"Yuck, who'd want a face like that?"}
STRINGS.CHARACTERS.WINONA.DESCRIBE.MERMHAT       = {"Do I look a little green around the gills? Ha!"}
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.MERMHAT     = {"Wolfgang will be biggest and strongest fish man!"}
STRINGS.CHARACTERS.WOODIE.DESCRIBE.MERMHAT       = {"Not sure it'll fit over my luxurious beard."}
STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.MERMHAT     = {"Glub Glub pretend face"}
STRINGS.CHARACTERS.WORTOX.DESCRIBE.MERMHAT       = {"Some would call me two-faced, hyuyu!"}
STRINGS.CHARACTERS.WURT.DESCRIBE.MERMHAT         = {"Make scale-less look like friendly Mermfolk!"}
STRINGS.CHARACTERS.WX78.DESCRIBE.MERMHAT         = {"WARTY CONCEALMENT"}

--Pighat
STRINGS.NAMES.DISGUISEHAT = "Shamlet Mask"
STRINGS.RECIPE_DESC.DISGUISEHAT = "A fresh face."

STRINGS.CHARACTERS.GENERIC.DESCRIBE.DISGUISEHAT      = {"For swindling a swine."}
STRINGS.CHARACTERS.WARLY.DESCRIBE.DISGUISEHAT        = {"It is the icing on the face."}
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.DISGUISEHAT   = {"Öne öf Löki's tricks."}
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.DISGUISEHAT      = {"Doesn't fool me."}
STRINGS.CHARACTERS.WEBBER.DESCRIBE.DISGUISEHAT       = {"I bet we can fool those pigs with this!"}
STRINGS.CHARACTERS.WENDY.DESCRIBE.DISGUISEHAT        = {"Full of deception."}
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.DISGUISEHAT = {"Clever."}
STRINGS.CHARACTERS.WILLOW.DESCRIBE.DISGUISEHAT       = {"Who would fall for that disguise?"}
STRINGS.CHARACTERS.WINONA.DESCRIBE.DISGUISEHAT       = {"Do I look a little pink around the gills? Ha!"}
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.DISGUISEHAT     = {"Hehe. Is funny little pig mask."}
STRINGS.CHARACTERS.WOODIE.DESCRIBE.DISGUISEHAT       = {"Hehe. It's like a halloween mask."}
STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.DISGUISEHAT     = {"Twirly Tail?"}
STRINGS.CHARACTERS.WORTOX.DESCRIBE.DISGUISEHAT       = {"Some would call me two-faced, hyuyu!"}
STRINGS.CHARACTERS.WURT.DESCRIBE.DISGUISEHAT         = {"Disgusting to mermfolk, florp!"}
STRINGS.CHARACTERS.WX78.DESCRIBE.DISGUISEHAT         = {"FACIAL ENCRYPTION."}

STRINGS.CHARACTERS.WAGSTAFF.DESCRIBE.DISGUISEHAT     = {"Theoretically, this is what passes for a disguise here."}
STRINGS.CHARACTERS.WALANI.DESCRIBE.DISGUISEHAT       = {"Ha! It's kinda cute!"}
STRINGS.CHARACTERS.WHEELER.DESCRIBE.DISGUISEHAT      = {"A disguise sneaky enough to fool those city pigs."}
STRINGS.CHARACTERS.WILBA.DESCRIBE.DISGUISEHAT        = {"A MERRY VISAGE"}
STRINGS.CHARACTERS.WOODLEGS.DESCRIBE.DISGUISEHAT     = {"'Tis fer foolin' tha'pigs."}

--Merm Guard
STRINGS.NAMES.MERMGUARD = "Loyal Merm Guard"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.MERMGUARD        = {"I feel very guarded around these guys..."}
STRINGS.CHARACTERS.WARLY.DESCRIBE.MERMGUARD          = {"A most fearsome fishmonger!"}
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.MERMGUARD     = {"A formidable warrior, to be sure."}
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.MERMGUARD        = {"I'd best try to stay on their good side."}
STRINGS.CHARACTERS.WEBBER.DESCRIBE.MERMGUARD         = {"They look pretty scary!"}
STRINGS.CHARACTERS.WENDY.DESCRIBE.MERMGUARD          = {"Friend or foe?"}
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.MERMGUARD   = {"A royal bodyguard."}
STRINGS.CHARACTERS.WILLOW.DESCRIBE.MERMGUARD         = {"I can't tell which way it's looking."}
STRINGS.CHARACTERS.WINONA.DESCRIBE.MERMGUARD         = {"Just doin' their job."}
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.MERMGUARD       = {"Not as mighty as Wolfgang!"}
STRINGS.CHARACTERS.WOODIE.DESCRIBE.MERMGUARD         = {"They stand on guard for the king."}
STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.MERMGUARD       = {"Friends?"}
STRINGS.CHARACTERS.WORTOX.DESCRIBE.MERMGUARD         = {"The horns are an improvement."}
STRINGS.CHARACTERS.WURT.DESCRIBE.MERMGUARD           = {"Will grow up big and strong like that one day!"}
STRINGS.CHARACTERS.WX78.DESCRIBE.MERMGUARD           = {"YOU WOULD MAKE AN EXCELLENT MINION"}

--Merm Talk
STRINGS.MERM_TALK_FOLLOWWILSON_UNTRANSLATED      = {"Flort glut.", "Blut gloppy Glurtsu!", "Glut Glurtsu flopt!", "Florpy flort."}
STRINGS.MERM_TALK_FOLLOWWILSON                   = {"Will come with you.", "Make Mermfolk strong!", "You help Mermfolk!", "You okay."}
STRINGS.MERM_TALK_FIND_FOOD_UNTRANSLATED         = {"Flort glut.", "Blut gloppy Glurtsu!", "Glort grolt flut.", "Glurt florpy flut!"}
STRINGS.MERM_TALK_FIND_FOOD                      = {"Will come with you.", "Make Mermfolk strong!", "This do fine.", "Find something tasty!"}

STRINGS.MERM_TALK_HELP_CHOP_WOOD_UNTRANSLATED    = {"Flort glut.", "Blut gloppy Glurtsu!", "Grop, groppy, grop!", "Glort blut, florp!"}
STRINGS.MERM_TALK_HELP_CHOP_WOOD                 = {"Will come with you.", "Make Mermfolk strong!", "Chop, choppy, chop!", "Work hard, florp!"}
STRINGS.MERM_TALK_HELP_MINE_ROCK_UNTRANSLATED    = {"Flort glut.", "Blut gloppy Glurtsu!", "Wult wop, florty flort!", "Glort blut, florp!"}
STRINGS.MERM_TALK_HELP_MINE_ROCK                 = {"Will come with you.", "Make Mermfolk strong!", "Break rock, easy!", "Work hard, florp!"}
STRINGS.MERM_TALK_HELP_HAMMER_UNTRANSLATED       = {"Flort glut.", "Blut gloppy Glurtsu!", "Florph! Florph!", "Glort blut, florp!"}
STRINGS.MERM_TALK_HELP_HAMMER                    = {"Will come with you.", "Make Mermfolk strong!", "Smash! Smash!", "Work hard, florp!"}

STRINGS.MERM_TALK_PANICBOSS_UNTRANSLATED         = {"Gloppy flort!", "Gloooorph!! Glurph glot! Glurph glot!", "Flort wult Glurtsu!"}
STRINGS.MERM_TALK_PANICBOSS                      = {"Something coming!", "Aaah!! Bad thing! Bad thing!", "It come to destroy us!"}
STRINGS.MERM_TALK_PANICBOSS_KING_UNTRANSLATED    = {"Glurtsen blut flort!", "Flurph flrot! Gloppy Glurtsam!", "G-glop blut flrot!!"}
STRINGS.MERM_TALK_PANICBOSS_KING                 = {"Rally to King!", "Hurry! Protect kingdom!", "S-stay brave!!"}

STRINGS.MERM_BATTLECRY_UNTRANSLATED              = {"Glorp! Glorpy glup!", "Wult glut!"}
STRINGS.MERM_BATTLECRY                           = {"Glorp! Go away!", "Destroy you!"}
STRINGS.MERM_GUARD_BATTLECRY_UNTRANSLATED        = {"Wult flrot!", "Flort Glurtsu flut!", "GLOT FLOOOORPH!!", "Glurph Glurtsen!"}
STRINGS.MERM_GUARD_BATTLECRY                     = {"To battle!", "For glory of Mermfolk!", "ATTAAAACK!!", "Defend King!"}

------------------------------------------------------------------------------------------------------------------------
--#4 AddPrefabPostInit

--4.1 Add fish tags
local function ItemIsFish(inst) inst:AddTag("fish") end
AddPrefabPostInit("eel", ItemIsFish)
AddPrefabPostInit("fish", ItemIsFish)
AddPrefabPostInit("tropical_fish", ItemIsFish)

--4.2 Add food categories
AddPrefabPostInit("honey", function(inst) inst.components.edible.foodtype = "HONEY" end)
AddPrefabPostInit("ice", function(inst) inst.components.edible.foodtype = "ICE" end)

--4.3 Add mermguard in mermwatchtower
AddPrefabPostInit("mermwatchtower", function(inst) inst.components.childspawner.childname = "mermguard" end)

--4.4 Add mermkingmanager in the world
AddPrefabPostInit("world", function(inst) inst:AddComponent("mermkingmanager") end)

--4.5 Pigs target merms, see original pigman.lua
local FindEntity = _G.FindEntity
local GetPlayer = _G.GetPlayer

local function NormalRetargetfn(inst)
    return FindEntity(inst, TUNING.PIG_TARGET_DIST, function(guy)
        if not guy.LightWatcher or guy.LightWatcher:IsInLight() then
            return (guy:HasTag("monster") or guy:HasTag("merm") ) and guy.components.health
                    and not guy.components.health:IsDead() and inst.components.combat:CanTarget(guy)
                    and not (inst.components.follower.leader ~= nil and guy:HasTag("abigail"))
        end
    end)
end

local prefabs = {"pigman", "wildbore"} --no need to apply to pigtorch pigguards

for k,v in pairs(prefabs) do
    AddPrefabPostInit(v, function(inst)
        if inst.components.combat then
            inst.components.combat:SetRetargetFunction(3, NormalRetargetfn)
        end
    end)
end

--4.6 Royal pigguards target merms, see original pigmancity.lua
if IsDLCEnabled and IsDLCEnabled(3) then
    local function NormalRetargetFn_royal(inst)
        return FindEntity(inst, TUNING.CITY_PIG_GUARD_TARGET_DIST, function(guy)
            if not guy.LightWatcher or guy.LightWatcher:IsInLight() then
                if guy == GetPlayer() and inst:HasTag("angry_at_player") and guy.components.health
                 and not guy.components.health:IsDead() and inst.components.combat:CanTarget(guy)
                 and inst.components.combat.target ~= GetPlayer() then
                    inst.sayline(inst, getSpeechType(inst,STRINGS.CITY_PIG_GUARD_TALK_ANGRY_PLAYER))
                end

                return  (guy:HasTag("monster") or guy:HasTag("merm") or (guy == GetPlayer() and inst:HasTag("angry_at_player")) )
                        and guy.components.health and not guy.components.health:IsDead() and inst.components.combat:CanTarget(guy)
                        and not (inst.components.follower.leader ~= nil and guy:HasTag("abigail"))
            end
        end)
    end

    local prefabs = {"pigman_royalguard", "pigman_royalguard_2"} --no need to touch prefabs/pigguard.lua

    for k,v in pairs(prefabs) do
        AddPrefabPostInit(v, function(inst)
            if inst.components.combat then
                inst.components.combat:SetRetargetFunction(3, NormalRetargetFn_royal)
            end
        end)
    end
end

--4.7 Pigcity citizens flee away from merms, see original citybigbrain.lua
local require = _G.require
local TheSim:FindEntities = _G.TheSim:FindEntities
local Transform = _G.Transform
local Vector3 = _G.Vector3

if IsDLCEnabled and IsDLCEnabled(3) then
    local function shouldPanic(inst)
        local x,y,z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x,y,z, 20, nil,{"city_pig"},{"hostile", "merm", "LIMBO"})
        if #ents > 0 then
            print("CAUSE PANIC")
            dumptable(ents,1,1,1)
            return true
        end

        if inst.components.combat.target then
            local threat = inst.components.combat.target
            if threat then
                local myPos = Vector3(inst.Transform:GetWorldPosition() )
                local threatPos = Vector3(threat.Transform:GetWorldPosition() )
                local dist = distsq(threatPos, myPos)
                if dist < FAR_ENOUGH*FAR_ENOUGH then
                    if dist > STOP_RUN_AWAY_DIST*STOP_RUN_AWAY_DIST then
                        return true
                    end
                else
                    inst.components.combat:GiveUp()
                end
            end
        end
        return false
    end

    AddBrainPostInit("citypigbrain", shouldPanic)
end

