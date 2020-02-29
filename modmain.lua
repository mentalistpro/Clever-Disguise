PrefabFiles = 
{
    "merm"
}

Assets = 
{
}

-----------------------------------------------------------------

--//CONTENT//
--1. Config
--2. Strings
--3. AddPrefabPostInit

-----------------------------------------------------------------
--1. Config

local seg_time = 30
local total_day_time = seg_time*16

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

    TUNING.MERM_LOYALTY_MAXTIME = 3 * total_day_time
    TUNING.MERM_LOYALTY_PER_HUNGER = total_day_time/25
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

    TUNING.MERM_GUARD_LOYALTY_MAXTIME = 3 * total_day_time
    TUNING.MERM_GUARD_LOYALTY_PER_HUNGER = total_day_time/25
    TUNING.MERM_GUARD_MAX_TARGET_SHARES = 8
    TUNING.MERM_GUARD_SHARE_TARGET_DIST = 60
	
------------------------------------------------------------------------------------------------------------------------
--2. Strings

local _G = GLOBAL
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
--3. AddPrefabPostInit

--Fish tags

local function ItemIsFish(inst)
    inst:AddTag("fish")
end

AddPrefabPostInit("eel", ItemIsFish)
AddPrefabPostInit("fish", ItemIsFish)
AddPrefabPostInit("tropical_fish", ItemIsFish)

--Pigs target merms

local FindEntity = _G.FindEntity

local function NormalKeepTargetFn_new(inst)
    return FindEntity(inst, TUNING.PIG_TARGET_DIST,
	function(guy)
		if not guy.LightWatcher or guy.LightWatcher:IsInLight() then
			return (guy:HasTag("monster") or guy:HasTag("merm") ) and guy.components.health and not guy.components.health:IsDead() and inst.components.combat:CanTarget(guy) and not 
			(inst.components.follower.leader ~= nil and guy:HasTag("abigail"))
		end
	end)
end

local prefabs = {"pigman", "wildbore"} --no need to touch pigguard functions

for k,v in pairs(prefabs) do
	AddPrefabPostInit(v, function(inst)   
		if inst.components.combat then
			inst.components.combat:SetRetargetFunction(3, NormalKeepTargetFn_new)
		end
	end)
end
