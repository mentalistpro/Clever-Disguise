
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
--#7 Prefabs

local function construction_components(inst)
    inst:AddComponent("constructionbuilder")
    inst.components.constructionbuilder:StopConstruction()
end

AddPrefabPostInit("player_common", construction_components)

-------------------------------------------------------------------------------
--#8 Widgets

AddClassPostConstruct("widgets/containerwidget", function(self)
    local oldfn = self.Open
    function self:Open(container, doer)
        oldfn(self, container, doer)

        local constructionsite = doer.components.constructionbuilder ~= nil and doer.components.constructionbuilder:GetContainer() == container and doer.components.constructionbuilder:GetConstructionSite() or nil
        local constructionmats = constructionsite ~= nil and constructionsite:GetIngredients() or nil
        local InvSlot = require "widgets/invslot"

        for i, v in ipairs(container.components.container.widgetslotpos or {}) do
            local slot = InvSlot(i,
                "images/hud_construction.xml",
                (constructionmats ~= nil and "inv_slot_construction_1.tex" or "inv_slot_construction_2.tex"),
                self.owner,
                container.components.container
            )
            self.inv[i] = self:AddChild(slot)

            slot:SetPosition(v)

            local widget = container.components.container
            if not container.components.container.side_widget then
                if widget.top_align_tip ~= nil then
                    slot.top_align_tip = widget.top_align_tip
                else
                    slot.side_align_tip = (widget.side_align_tip or 0) - v.x
                end
            end

            if constructionmats ~= nil then
                slot:ConvertToConstructionSlot(constructionmats[i], constructionsite:GetSlotCount(i))
            end
        end
    end
end)

