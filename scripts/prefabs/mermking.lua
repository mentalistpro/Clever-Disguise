local assets =
{
    Asset("ANIM", "anim/merm_king.zip"),
}

local prefabs =
{
    "tropical_fish",
    "fish",
    "froglegs",
    "kelp",
    "seaweed",
    "merm_king_splash",
}

local loot =
{
    "fish",
    "fish",
    "fish",
    "froglegs",
    "kelp",
    "kelp"
}

local sw_loot =
{
    "tropical_fish",
    "tropical_fish",
    "tropical_fish",
    "froglegs",
    "seaweed",
    "seaweed"
}

------------------------------------------------------------------------------

--[[CONTENT]]
--#1 Trade
--#2 Stats
--#3 Combat
--#4 Save/Load
--#5 fn

------------------------------------------------------------------------------
--#1 Trade

local x
if SaveGameIndex and SaveGameIndex:IsModeShipwrecked() then
    x = "seaweed"
else
    x = "kelp"
end

local trading_items =
{
    { prefabs = { x },  min_count = 2, max_count = 4, reset = false, add_filler = false, },
    { prefabs = { x },  min_count = 2, max_count = 3, reset = false, add_filler = false, },
    { prefabs = { "seeds" },         min_count = 4, max_count = 6, reset = false, add_filler = false, },
    { prefabs = { "spoiled_food"  }, min_count = 2, max_count = 4, reset = false, add_filler = false, },
    { prefabs = { "tentaclespots" }, min_count = 1, max_count = 1, reset = false, add_filler = true,  },

    {
      prefabs = { "trinket_12", "trinket_3", "trinket_25", "trinket_17", "trinket_4" },
      min_count = 1, max_count = 1, reset = false, add_filler = true,
    },

    {
        prefabs = { "durian_seeds", "pepper_seeds", "eggplant_seeds", "pumpkin_seeds", "onion_seeds", "garlic_seeds"  },
        min_count = 1, max_count = 2, reset = false, add_filler = true,
    },
}

local trading_filler = { "seeds", x, "seeds", "spoiled_food", "seeds", "seeds"}

local function ShouldAcceptItem(inst, item, giver)
    if giver:HasTag("merm") then
        local can_eat = (item.components.edible and inst.components.eater:CanEat(item))
                    and (inst.components.hunger and inst.components.hunger:GetPercent() < 1)
        return can_eat or item:HasTag("fish")
    end
    return false
end

local function launchitem(item, angle)
    local speed = math.random() * 4 + 2
    angle = (angle + math.random() * 60 - 30) * DEGREES
    item.Physics:SetVel(speed * math.cos(angle), math.random() * 2 + 8, speed * math.sin(angle))
end

local function TradeItem(inst)
    local item = inst.itemtotrade
    local giver = inst.tradegiver
    local x, y, z = inst.Transform:GetWorldPosition()
    y = 5.5

    local angle
    if giver and giver:IsValid() then
        angle = 180 - giver:GetAngleToPoint(x, 0, z)
    else
        local down = TheCamera:GetDownVec()
        angle = math.atan2(down.z, down.x) / DEGREES
        giver = nil
    end

    local selected_index = math.random(1, #inst.trading_items)
    local selected_item = inst.trading_items[selected_index]
    local reward_count = math.random(selected_item.min_count, selected_item.max_count) * TUNING.MERMKING_EXCHANGERATE
    local filler_min = 2
    local filler_max = 4

    for k = 1, reward_count do
        local reward_item = SpawnPrefab(selected_item.prefabs[math.random(1, #selected_item.prefabs)])
        if reward_item then
            print("reward item is given")
            reward_item.Transform:SetPosition(x, y, z)
            launchitem(reward_item, angle)
        end
    end

    if selected_item.add_filler then
        for i=filler_min, filler_max do
            local filler_item = SpawnPrefab(trading_filler[math.random(1, #trading_filler)])
            if filler_item then
                print("filler item is given")
                filler_item.Transform:SetPosition(x, y, z)
                launchitem(filler_item, angle)
            end
        end
    end

    table.remove(inst.trading_items, selected_index)
    if #inst.trading_items == 0 or selected_item.reset then
        inst.trading_items = deepcopy(trading_items)
    end

    inst.itemtotrade = nil
    inst.tradegiver  = nil

    item:Remove()
end

local function OnGetItemFromPlayer(inst, giver, item)
    if item.components.edible then
        if inst.components.combat.target and inst.components.combat.target == giver then
            inst.components.combat:SetTarget(nil)
        end

        if inst.components.eater:CanEat(item) then
            inst.sg:GoToState("eat")
            inst.components.eater:Eat(item)
        else
            inst.sg:GoToState("trade")
            inst.itemtotrade = item
            inst.tradegiver = giver
        end
    end
end

local function OnRefuseItem(inst, item)
    inst.sg:GoToState("refuse")
end

------------------------------------------------------------------------------
--#2 Stats

local function HungerDelta(inst, data)
    if data.newpercent then
        local increase = false
        if inst.lastpercent_hunger and data.newpercent - inst.lastpercent_hunger > 0 then
            increase = true
        end
        inst.lastpercent_hunger = data.newpercent

        if not inst.components.timer:TimerExists("hungrytalk_cooldown") or data.newpercent == 1 or (increase and not inst.components.timer:TimerExists("hungrytalk_increase_cooldown") ) then

            if data.newpercent <= 0 then
                inst.components.talker:Say(STRINGS.MERM_KING_TALK_HUNGER_STARVING)
            elseif data.newpercent < 0.1 then
                inst.components.talker:Say(STRINGS.MERM_KING_TALK_HUNGER_CLOSE_STARVING)
            elseif data.newpercent < 0.25 then
                inst.components.talker:Say(STRINGS.MERM_KING_TALK_HUNGER_VERY_HUNGRY)
            elseif data.newpercent < 0.5 then
                inst.components.talker:Say(STRINGS.MERM_KING_TALK_HUNGER_HUNGRY)
            elseif data.newpercent < 0.95 then
                inst.components.talker:Say(STRINGS.MERM_KING_TALK_HUNGER_HUNGRISH)
            else
                inst.components.talker:Say(STRINGS.MERM_KING_TALK_HUNGER_FULL)
            end

            local time = Remap(data.newpercent, 1,0, 30,8)
            if increase then
                inst.components.timer:StopTimer("hungrytalk_increase_cooldown")
                inst.components.timer:StartTimer("hungrytalk_increase_cooldown", 10)
            end
            inst.components.timer:StopTimer("hungrytalk_cooldown")
            inst.components.timer:StartTimer("hungrytalk_cooldown", time)
        end

        if data.newpercent <= 0 then
            inst.components.health:StopRegen()
        end

        if data.oldpercent and data.oldpercent == 0 and data.newpercent > data.oldpercent then
            inst.components.health:StartRegen(TUNING.MERM_KING_HEALTH_REGEN, TUNING.MERM_KING_HEALTH_REGEN_PERIOD)
        end
    end

end

local function HealthDelta(inst, data)
    if data.newpercent and inst.components.combat.target then
        if data.newpercent < 0.75 and data.oldpercent > data.newpercent then

            if inst.guards_available == nil then
                inst.guards_available = 4
            end

            if inst.guards_available > 0 and (inst.guards == nil or #inst.guards == 0) and not inst.sg:HasStateTag("calling_guards") and not inst.components.health:IsDead() then
                inst.sg:PushEvent("call_guards")

                if not inst.call_guard_task then
                    inst.call_guard_task = inst:DoTaskInTime(TUNING.TOTAL_DAY_TIME, function()
                        inst.guards_available = 4
                        inst.call_guard_task = nil
                    end)
                end
            end
        end
    end
end

local function OnCreated(inst)
    inst.components.hunger:SetPercent(0.25)
    inst.lastpercent_hunger = 0.25
    inst.guards_available = 4
    inst.guards = {}
end

------------------------------------------------------------------------------
--#3 Combat

local MAX_TARGET_SHARES = 30
local SHARE_TARGET_DIST = 40

local function OnAttacked(inst, data)
    local attacker = data and data.attacker
    if attacker and inst.components.combat:CanTarget(attacker) then
        inst.components.combat:SetTarget(attacker)
        local targetshares = MAX_TARGET_SHARES
        inst.components.combat:ShareTarget(attacker, SHARE_TARGET_DIST, function(sharer)
            return sharer:HasTag("merm") and not sharer:HasTag("player")
        end, targetshares)
    end
end

local function KeepTarget(inst, target)
    if target and not inst:IsNear(target, 75) then
        return false
    end

    if inst.guards and #inst.guards > 0 then
        for i,v in ipairs(inst.guards) do
            if v.components.combat.target == target then
                return true
            end
        end

        return false
    end

    return true
end

local function OnGuardDeath(inst)
    local remove_at = nil
    for i,v in ipairs(inst.king.guards) do
        if v == inst then
            remove_at = i
            break
        end
    end

    if remove_at then
        table.remove(inst.king.guards, remove_at)
    end

    inst.king:RemoveEventCallback("death",  inst.king.OnGuardDeath, inst)
    inst.king:RemoveEventCallback("onremove", inst.king.OnGuardRemoved, inst)
    inst.king:RemoveEventCallback("enterlimbo", inst.king.OnGuardEnterLimbo, inst)
end

local function OnGuardRemoved(inst)
    if inst.king.guards_available < 4 then
        inst.king.guards_available = inst.king.guards_available + 1
    end
    OnGuardDeath(inst)
end

local function OnGuardEnterLimbo(inst)
    inst:Remove()
end

local function CallGuards(inst)
    local merm_positions =
    {
        { x =  2.5, z =  2.5 },
        { x = -2.5, z =  2.5 },
        { x =  2.5, z = -2.5 },
        { x = -2.5, z = -2.5 },
    }

    local x,y,z = inst.Transform:GetWorldPosition()
    inst.guards = {}

    if inst.guards_available == nil then
        inst.guards_available = 4
    end

    for i = 1, inst.guards_available do
        local new_merm = SpawnPrefab("mermguard")
        new_merm.Transform:SetPosition(x + merm_positions[i].x, y, z + merm_positions[i].z)
        new_merm.components.combat:SetTarget(inst.components.combat.target)
        new_merm.king = inst

        local fx = SpawnPrefab("merm_spawn_fx")
        fx.Transform:SetPosition(new_merm.Transform:GetWorldPosition())
        inst.SoundEmitter:PlaySound("dontstarve/characters/wurt/merm/throne/spawn")

        table.insert(inst.guards, new_merm)
        inst:ListenForEvent("death",  OnGuardDeath, new_merm)
        inst:ListenForEvent("onremove", OnGuardRemoved, new_merm)
        inst:ListenForEvent("enterlimbo", OnGuardEnterLimbo, new_merm)
    end

    inst.guards_available = 0
end

local function ReturnMerms(inst)
    if inst.guards == nil then
        inst.guards = {}
    end

    for i,v in ipairs(inst.guards) do
        if v.components.combat.target ~= nil then
            v.components.combat:GiveUp()
        end

        v.return_to_king = true
    end
end

local function OnGiveUpTarget(inst, data)
    ReturnMerms(inst)
end

------------------------------------------------------------------------------
--#4 Save/Load

local function OnSave(inst, data)
    local ents = {}

    if inst.guards_available ~= nil then
        data.guards_available = inst.guards_available
    end

    if inst.guards and #inst.guards then
        data.guards = {}
        for i,v in ipairs(inst.guards) do
            table.insert(data.guards, v.GUID)
            table.insert(ents, v.GUID)
        end
    end

    if inst.call_guard_task then
        data.task_remaining = GetTaskRemaining(inst.call_guard_task)
    end

    return ents
end

local function OnLoadPostPass(inst, newents, savedata)
    if savedata.guards_available then
        inst.guards_available = savedata.guards_available
    end

    inst.guards = {}
    if savedata.guards then
        for i,v in ipairs(savedata.guards) do
            local guard = newents[v].entity
            if guard then
                table.insert(inst.guards, guard)
                guard.king = inst
                guard.return_to_king = true

                inst:ListenForEvent("death",  OnGuardDeath, guard)
                inst:ListenForEvent("onremove", OnGuardRemoved, guard)
                inst:ListenForEvent("enterlimbo", OnGuardEnterLimbo, guard)
            else
                print ("ERROR, COULD NOT FIND GUARD WITH PROVIDED GUID")
            end
        end
    end

    if savedata.task_remaining then
        inst.call_guard_task = inst:DoTaskInTime(savedata.task_remaining,
            function()
                inst.guards_available = 4
                inst.call_guard_task = nil
            end)
    end
end

------------------------------------------------------------------------------
--#5 fn

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()

    MakeLargeBurnableCharacter(inst, "krampus_torso")
    MakeObstaclePhysics(inst, 1)

    inst.AnimState:SetBank("merm_king")
    inst.AnimState:SetBuild("merm_king")
    inst.AnimState:PlayAnimation("idle", true)

    inst:AddTag("character")
    inst:AddTag("merm")
    inst:AddTag("mermking")
    inst:AddTag("wet")

    inst:SetStateGraph("SGmermking")

    -------------------------------------------------

    inst:AddComponent("combat")
    inst.components.combat:SetKeepTargetFunction(KeepTarget)

    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("hungerdelta", function(_, data) HungerDelta(inst, data) end)
    inst:ListenForEvent("healthdelta", function(_, data) HealthDelta(inst, data) end)
    inst:ListenForEvent("oncreated", function() OnCreated(inst) end)
    inst:ListenForEvent("giveuptarget", OnGiveUpTarget)

    inst.OnGuardDeath = OnGuardDeath
    inst.OnGuardRemoved = OnGuardRemoved
    inst.OnGuardEnterLimbo = OnGuardEnterLimbo

    inst.CallGuards = CallGuards
    inst.ReturnMerms = ReturnMerms

    -------------------------------------------------

    inst:AddComponent("eater")
    inst.components.eater:SetVegetarian()

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.MERM_KING_HEALTH)
    inst.components.health:StartRegen(TUNING.MERM_KING_HEALTH_REGEN, TUNING.MERM_KING_HEALTH_REGEN_PERIOD)

    inst:AddComponent("hunger")
    inst.components.hunger:SetMax(TUNING.MERM_KING_HUNGER)
    inst.components.hunger:SetKillRate(TUNING.MERM_KING_HEALTH / TUNING.MERM_KING_HUNGER_KILL_TIME)
    inst.components.hunger:SetRate(TUNING.MERM_KING_HUNGER_RATE)

    inst:AddComponent("lootdropper")
    if SaveGameIndex and SaveGameIndex:IsModeShipwrecked() then
        inst.components.lootdropper:SetLoot(sw_loot)
    else
        inst.components.lootdropper:SetLoot(loot)
    end

    -------------------------------------------------

    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem
    inst.components.trader.deleteitemonaccept = false

    inst.trading_items = deepcopy(trading_items)
    inst.TradeItem = TradeItem

    -------------------------------------------------

    inst:AddComponent("inspectable")
    inst:AddComponent("inventory")
    inst:AddComponent("talker")
    inst:AddComponent("timer")

    -------------------------------------------------

    inst.OnSave = OnSave
    inst.OnLoadPostPass = OnLoadPostPass

    return inst
end

return Prefab("common/characters/mermking", fn, assets, prefabs)

