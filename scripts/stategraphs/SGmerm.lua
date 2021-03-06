require("stategraphs/commonstates")

local actionhandlers =
{
    ActionHandler(ACTIONS.GOHOME, "gohome"),
    ActionHandler(ACTIONS.EAT, "eat"),
    ActionHandler(ACTIONS.CHOP, "chop"),
    ActionHandler(ACTIONS.MINE, "mine"),
    ActionHandler(ACTIONS.HAMMER, "hammer"),
    ActionHandler(ACTIONS.FISH, "fishing_pre"),
}


local events=
{
    CommonHandlers.OnLocomote(true,true),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnFreeze(),
    CommonHandlers.OnAttack(),
    CommonHandlers.OnAttacked(),
    CommonHandlers.OnDeath(),

    EventHandler("doaction",
        function(inst, data)
            if not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") then
                if data.action == ACTIONS.CHOP then
                    inst.sg:GoToState("chop", data.target)
                end
            end
        end),

    EventHandler("onarrivedatthrone", function(inst)

        if inst.components.health and inst.components.health:IsDead() then
            return
        end

        local player_close = GetClosestInstWithTag("player", inst, 5)
        if player_close then
            local pos = Vector3(player_close.Transform:GetWorldPosition())
            inst:ForceFacePoint(pos.x, pos.y, pos.z)
        end

        if not inst.sg:HasStateTag("transforming") then
            if GetWorld().components.mermkingmanager and GetWorld().components.mermkingmanager:ShouldTransform(inst) then
                if inst.sg:HasStateTag("sitting") then
                    inst.sg:GoToState("getup")
                elseif not inst.sg:HasStateTag("gettingup") then
                    inst.sg:GoToState("transform_to_king")
                end
            elseif not inst.sg:HasStateTag("sitting") and player_close == nil then
                inst.sg:GoToState("sitdown")
            elseif player_close and inst.sg:HasStateTag("sitting") then
                inst.sg:GoToState("getup")
            end
        end
    end),

    EventHandler("onmermkingcreated", function(inst)
        inst.sg:GoToState("buff")
    end),
    EventHandler("onmermkingdestroyed", function(inst)
        inst.sg:GoToState("debuff")
    end),

    EventHandler("getup", function(inst)
        inst.sg:GoToState("getup")
    end),
}

local states=
{
    State{
        name = "fishing_pre",
        tags = {"canrotate", "prefish", "fishing"},
        onenter = function(inst)
            inst.AnimState:PlayAnimation("fish_pre")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst:PerformBufferedAction()
                inst.sg:GoToState("fishing")
            end),
        },
    },

    State{
        name = "fishing",
        tags = {"canrotate", "fishing"},

        onenter = function(inst)
            inst.AnimState:PlayAnimation("fish_loop", true)
            inst.components.fishingrod:WaitForFish()
        end,

        events =
        {
            EventHandler("fishingnibble", function(inst) inst.sg:GoToState("fishing_nibble") end ),
            EventHandler("fishingloserod", function(inst) inst.sg:GoToState("loserod") end),
        },
    },

    State{
        name = "fishing_pst",
        tags = {"canrotate", "fishing"},
        onenter = function(inst)
            inst.AnimState:PushAnimation("fish_loop", true)
            inst.AnimState:PlayAnimation("fish_pst")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "fishing_nibble",
        tags = {"canrotate", "fishing", "nibble"},
        onenter = function(inst)
            inst.AnimState:PushAnimation("fish_loop", true)
            inst.components.fishingrod:Hook()
        end,

        events =
        {
            EventHandler("fishingstrain", function(inst) inst.sg:GoToState("fishing_strain") end),
        },
    },

    State{
        name = "fishing_strain",
        tags = {"canrotate", "fishing"},
        onenter = function(inst)
            inst.components.fishingrod:Reel()
        end,

        events =
        {
            EventHandler("fishingcatch", function(inst, data)
                inst.sg:GoToState("catchfish", data.build)
            end),

            EventHandler("fishingloserod", function(inst)
                inst.sg:GoToState("loserod")
            end),
        },
    },

    State{
        name = "catchfish",
        tags = {"canrotate", "fishing", "catchfish"},
        onenter = function(inst, build)
            inst.AnimState:PlayAnimation("fishcatch")
            inst.AnimState:OverrideSymbol("fish01", build, "fish01")
        end,

        timeline =
        {
            TimeEvent(10*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/Merm/whoosh_throw")
            end),
            TimeEvent(14*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/Merm/spear_water")
            end),
            TimeEvent(34*FRAMES, function(inst)
                inst.components.fishingrod:Collect()
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:RemoveStateTag("fishing")
                inst.sg:GoToState("idle")
            end),
        },

        onexit = function(inst)
            inst.AnimState:ClearOverrideSymbol("fish01")
        end,
    },

    State{
        name = "idle_sit",
        tags = { "idle", "sitting" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("sit_idle")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle_sit")
            end),
        },
    },

    State{
        name = "sitdown",
        tags = { "idle", "sitting" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("sit")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle_sit")
            end),
        },
        timeline=
        {
            TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentacle_splat" ,nil,.5) end),
        },
    },

    State{
        name = "getup",
        tags = { "busy", "gettingup", "nospellcasting" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("getup")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if GetWorld().components.mermkingmanager and GetWorld().components.mermkingmanager:ShouldTransform(inst) then
                    inst.sg:GoToState("transform_to_king")
                else
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },

    State{
        name = "transform_to_king",
        tags = { "busy", "transforming", "nospellcasting"},

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("transform_to_king_pre")
        end,

        timeline =
        {
            TimeEvent(9 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/attack")
            end),
            TimeEvent(30 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/characters/wurt/merm/transform_pre")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                GetWorld():PushEvent("oncandidatekingarrived", {candidate = inst})
            end),
        },

    },

    State{
        name = "chop",
        tags = { "chopping" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("atk")
        end,

        timeline =
        {
            TimeEvent(13 * FRAMES, function(inst)
                inst:PerformBufferedAction()
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    },

    State{
        name = "mine",
        tags = { "mining" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("atk")
        end,

        timeline =
        {
            TimeEvent(13 * FRAMES, function(inst)

                if inst.bufferedaction ~= nil then
                    local target = inst.bufferedaction.target

                    if target ~= nil and target:IsValid() then
                        local frozen = target:HasTag("frozen")
                        local moonglass = target:HasTag("moonglass")

                        if target.Transform ~= nil then
                            local mine_fx = (frozen and "mining_ice_fx") or (moonglass and "mining_moonglass_fx") or "mining_fx"
                            SpawnPrefab(mine_fx).Transform:SetPosition(target.Transform:GetWorldPosition())
                        end

                        inst.SoundEmitter:PlaySound((frozen and "dontstarve_DLC001/common/iceboulder_hit") or (moonglass and "turnoftides/common/together/moon_glass/mine") or "dontstarve/wilson/use_pick_rock")
                    end
                end

                inst:PerformBufferedAction()
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    },

    State{
        name = "hammer",
        tags = { "hammering" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("atk")
        end,

        timeline =
        {
            TimeEvent(13 * FRAMES, function(inst)
                inst:PerformBufferedAction()
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    },

    State{
        name = "buff",
        tags = { "busy" },

        onenter = function(inst)
            inst.Physics:Stop()

            if inst:HasTag("guard") then
                inst.AnimState:PlayAnimation("transform_pre")
            else
                inst.AnimState:PlayAnimation("buff")
            end
            local fx = SpawnPrefab("merm_splash")
            inst.SoundEmitter:PlaySound("dontstarve/characters/wurt/merm/buff")
            fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        end,

        timeline =
        {
            TimeEvent(9 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound(inst.sounds.buff)
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    },
    State{
        name = "debuff",
        tags = { "busy" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("debuff")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    },

    State{
        name = "eat",
        tags = {"busy"},

        onenter = function(inst)
            if inst.components.locomotor ~= nil then
                inst.components.locomotor:StopMoving()
            end
            inst.AnimState:PlayAnimation("eat")
        end,

        timeline =
        {
            TimeEvent(10*FRAMES, function(inst) inst:PerformBufferedAction() end),
            TimeEvent(2*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/eat") end),
            TimeEvent(11*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/beefalo/chew") end),
            TimeEvent(21*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/beefalo/chew") end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },
}

CommonStates.AddWalkStates(states,
{
    walktimeline = {
        TimeEvent(0*FRAMES, PlayFootstep ),
        TimeEvent(12*FRAMES, PlayFootstep ),
    },
})
CommonStates.AddRunStates(states,
{
    runtimeline = {
        TimeEvent(0*FRAMES, PlayFootstep ),
        TimeEvent(10*FRAMES, PlayFootstep ),
    },
})

CommonStates.AddSleepStates(states,
{
    sleeptimeline =
    {
        TimeEvent(35*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/sleep") end ),
    },
})

CommonStates.AddCombatStates(states,
{
    attacktimeline =
    {
        TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.attack) end),
        TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh") end),
        TimeEvent(13*FRAMES, function(inst) inst.components.combat:DoAttack() end),
    },
    hittimeline =
    {
        TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/hurt") end),
    },
    deathtimeline =
    {
        TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/death") end),
    },
})

CommonStates.AddIdle(states)
CommonStates.AddSimpleActionState(states, "gohome", "pig_pickup", 4*FRAMES, {"busy"})
CommonStates.AddSimpleState(states, "refuse", "pig_reject", { "busy" })
CommonStates.AddFrozenStates(states)

return StateGraph("merm", states, events, "idle", actionhandlers)