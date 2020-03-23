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
    Asset("ATLAS", "minimap/merm_king_carpet_occupied.xml"),
    --Asset("ANIM", "anim/player_construct.zip"),   --for prefabs/player_common.lua
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

--//PostInit
--#5 Actions
--#6 Stategraphs
--#7 Prefab

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
TUNING.MERM_KING_HUNGER_KILL_TIME = 480 * 2
TUNING.MERM_KING_HUNGER_RATE = 200 / (480 * 4)

function ReplacePrefab(original_inst, name)
    local x,y,z = original_inst.Transform:GetWorldPosition()
    
    local replacement_inst = SpawnPrefab(name)
    replacement_inst.Transform:SetPosition(x,y,z)
    original_inst:Remove()

    return replacement_inst
end

-------------------------------------------------------------------------------
--#2 Recipes

local _G = GLOBAL
local Ingredient = _G.Ingredient
local IsDLCEnabled = _G.IsDLCEnabled
local Recipe = _G.Recipe
local RECIPETABS = _G.RECIPETABS
local RECIPE_GAME_TYPE = _G.RECIPE_GAME_TYPE
local TECH = _G.TECH

--Mermthrone_construction

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
    
CONSTRUCTION_PLANS =
{
    ["mermthrone_construction"] = { Ingredient("kelp", 20), Ingredient("pigskin", 10), Ingredient("beefalowool", 15) },
}

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
--#5 Actions

local Action = _G.Action
local ActionHandler = _G.ActionHandler

--ACTIONS.CONSTRUCT

local CONSTRUCT = Action({},    --data                  --> I wrote it below instead.
                        3,      --priority              --> Higher number = higher priorty, see actions.lua
                        nil,    --instant               --> This is not an instant action.
                        false,  --right mouse button    --> This is not operated by right mouse button.
                        nil)    --distance              --> There is no function checking distance of the action.
    CONSTRUCT.str = "Build"
    CONSTRUCT.strfn = function(act)
        return act.invobject ~= nil and act.target:HasTag("constructionsite") and "STORE" or nil
    end
    CONSTRUCT.id = "CONSTRUCT"
    CONSTRUCT.fn = function(act)
        local target = act.target
        if target == nil or act.doer == nil or act.doer.components.constructionbuilder == nil then
            return false
        elseif act.doer.components.constructionbuilder:IsConstructingAny() then
            return true
        elseif act.doer.components.constructionbuilder:CanStartConstruction() then
            if not CanEntitySeeTarget(act.doer, target) then
                return true
            end
            local item = act.invobject
            local success, reason
            if item ~= nil and item.components.constructionplans ~= nil and target.components.constructionsite == nil then
                target, reason = item.components.constructionplans:StartConstruction(target)
                if target == nil then
                    return false, reason
                end
                item:Remove()
                item = nil
            end
            success, reason = act.doer.components.constructionbuilder:StartConstruction(target)
            if not success then
                return false, reason
            end
            --Try to store whatever was on our mouse pointer
            if item ~= nil and item.components.inventoryitem ~= nil and act.doer.components.inventory ~= nil then
                local container = act.doer.components.constructionbuilder.constructioninst
                container = container ~= nil and container.components.container or nil
                if container ~= nil and container:IsOpenedBy(act.doer) then
                    local slot
                    for i, v in ipairs(CONSTRUCTION_PLANS[target.prefab] or {}) do
                        if v.type == item.prefab then
                            slot = i
                            break
                        end
                    end
                    if slot ~= nil and container:CanTakeItemInSlot(item, slot) then
                        item = item.components.inventoryitem:RemoveFromOwner(container.acceptsstacks)
                        if item ~= nil and not container:GiveItem(item, slot, nil, false) then
                            if act.doer.components.playercontroller ~= nil and
                                act.doer.components.playercontroller.isclientcontrollerattached then
                                act.doer.components.inventory:GiveItem(item)
                            else
                                act.doer.components.inventory:GiveActiveItem(item)
                            end
                        end
                    elseif act.doer.components.talker ~= nil then
                        act.doer.components.talker:Say(GetActionFailString(act.doer, "CONSTRUCT", "NOTALLOWED"))
                    end
                end
            end
            return true
        end
    end

--ACTIONS.STOPCONSTRUCTION

local STOPCONSTRUCTION = Action({},3,nil,false)
    STOPCONSTRUCTION.str = "Stop Building"
    STOPCONSTRUCTION.stroverridefn = function(act)
        if act.invobject == nil and act.target ~= nil and act.target.constructionname ~= nil then
            local name = STRINGS.NAMES[string.upper(act.target.constructionname)]
            return name ~= nil and subfmt(STRINGS.ACTIONS.STOPCONSTRUCTION.GENERIC_FMT, { name = name }) or nil
        end
    end
    STOPCONSTRUCTION.id = "STOPCONSTRUCTION"
    STOPCONSTRUCTION.fn = function(act)
        if act.doer ~= nil and act.doer.components.constructionbuilder ~= nil then
            act.doer.components.constructionbuilder:StopConstruction()
        end
        return true
    end

--ACTIONS.APPLYCONSTRUCTION

local APPLYCONSTRUCTION = Action({},3,nil,false)
    APPLYCONSTRUCTION.str = "Build"
    APPLYCONSTRUCTION.id = "APPLYCONSTRUCTION"
    APPLYCONSTRUCTION.fn = function(act)
        if act.doer ~= nil and
            act.doer.components.constructionbuilder ~= nil and
            act.doer.components.constructionbuilder:IsConstructing(act.target) then
            if act.target.components.container ~= nil and not act.target.components.container:IsEmpty() then
                return act.doer.components.constructionbuilder:FinishConstruction()
            elseif act.doer.components.talker ~= nil then
                act.doer.components.talker:Say(GetActionFailString(act.doer, "CONSTRUCT", "EMPTY"))
            end
            return true
        end
    end

--Add new actions in global
AddAction(CONSTRUCT)
AddAction(STOPCONSTRUCTION)
AddAction(APPLYCONSTRUCTION)

--Add new actions in character
AddStategraphActionHandler("wilson", ActionHandler(CONSTRUCT , 
    function(inst, action)
        return (action.target == nil or not action.target:HasTag("constructionsite")) and "startconstruct" or "construct"
    end)
)

-------------------------------------------------------------------------------
--#6 Stategraphs

local State = _G.State
local TimeEvent = _G.TimeEvent
local EventHandler = _G.EventHandler
local FRAMES = _G.FRAMES

--startconstruct_state
local startconstruct_state = State({
    name = "startconstruct",
    onenter = function(inst)
        inst.sg:GoToState("construct", true)
    end,
})

--construct_state
local construct_state = State({
    name = "construct",  
    tags = { "doing", "busy", "nodangle" },
    onenter = function(inst, timeout)
        inst.components.locomotor:Stop()
        inst.SoundEmitter:PlaySound("dontstarve/wilson/make_trap", "make")
        inst.sg:SetTimeout(timeout)
        inst.sg.statemem.delayed = true
        inst.AnimState:PlayAnimation("build_pre")
        inst.AnimState:PushAnimation("build_loop", true)
    end,
    timeline = {
        TimeEvent(4 * FRAMES, function(inst)
            if inst.sg.statemem.delayed then
                inst.sg:RemoveStateTag("busy")
            end
        end),
        TimeEvent(9 * FRAMES, function(inst)
            if not (inst.sg.statemem.delayed or inst:PerformBufferedAction()) then
                inst.sg:RemoveStateTag("busy")
            end
        end),
    },
    ontimeout = function(inst)
        if not inst.sg.statemem.delayed then
            inst.SoundEmitter:KillSound("make")
            inst.AnimState:PlayAnimation("build_pst") --construct_pst is missing
        elseif not inst:PerformBufferedAction() then
            inst.SoundEmitter:KillSound("make")
            inst.AnimState:PlayAnimation("build_pst")
        end
    end,
    events = {
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },
    onexit = function(inst)
        if not inst.sg.statemem.constructing then
            inst.SoundEmitter:KillSound("make")
        end
    end,
})

--constructing_state
local constructing_state = State({
    name = "constructing",
    tags = { "doing", "busy", "nodangle" },
    onenter = function(inst)
        inst.components.locomotor:Stop()
        if not inst.SoundEmitter:PlayingSound("make") then
            inst.SoundEmitter:PlaySound("dontstarve/wilson/make_trap", "make")
        end
        if not inst.AnimState:IsCurrentAnimation("build_loop") then  --construct_loop is missing
            if inst.AnimState:IsCurrentAnimation("build_loop") then
                inst.AnimState:PlayAnimation("build_pst")
                inst.AnimState:PushAnimation("build_loop", true) --construct_loop is missing
            else
                inst.AnimState:PlayAnimation("build_loop", true) --construct_loop is missing
            end
        end
    end,
    timeline = {
        TimeEvent(FRAMES, function(inst)
            inst.sg:RemoveStateTag("busy")
        end),
    },
    onupdate = function(inst)
        if not CanEntitySeeTarget(inst, inst) then
            inst.AnimState:PlayAnimation("build_pst") --construct_pst is missing
            inst.sg:GoToState("idle", true)
        end
    end,
    events = {
        EventHandler("stopconstruction", function(inst)
            inst.AnimState:PlayAnimation("build_pst") --construct_pst is missing
            inst.sg:GoToState("idle", true)
        end),
    },
    onexit = function(inst)
        if not inst.sg.statemem.constructing then
            inst.SoundEmitter:KillSound("make")
            inst.components.constructionbuilder:StopConstruction()
        end
    end,
})

--construct_pst_state
local construct_pst_state = State({
    name = "construct_pst",
    tags = { "doing", "busy", "nodangle" },
    onenter = function(inst)
        inst.components.locomotor:Stop()
        if not inst.SoundEmitter:PlayingSound("make") then
            inst.SoundEmitter:PlaySound("dontstarve/wilson/make_trap", "make")
        end
        inst.AnimState:PlayAnimation("build_pre")
        inst.AnimState:PushAnimation("build_loop", true)
        inst.sg:SetTimeout(inst:HasTag("fastbuilder") and .5 or 1)
    end,
    ontimeout = function(inst)
        inst.sg:RemoveStateTag("busy")
        inst.AnimState:PlayAnimation("build_pst")
        inst.sg.statemem.finished = true
        inst.components.constructionbuilder:OnFinishConstruction()
    end,
    events = {
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },
    onexit = function(inst)
        inst.SoundEmitter:KillSound("make")
        if not inst.sg.statemem.finished then
            inst.components.constructionbuilder:StopConstruction()
        end
    end,
})

--Add new states in character
AddStategraphState("wilson", startconstruct_state)
AddStategraphState("wilson", construct_state)
AddStategraphState("wilson", constructing_state)
AddStategraphState("wilson", construct_pst_state)

-------------------------------------------------------------------------------
--#7 Prefab

local function construction_components(inst)
    inst:AddComponent("constructionbuilderuidata")
    inst:AddComponent("constructionbuilder")
    inst.components.constructionbuilder:StopConstruction()
end

AddPrefabPostInit("player_common", construction_components)

