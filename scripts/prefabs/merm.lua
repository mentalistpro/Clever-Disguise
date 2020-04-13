local assets =
{
    Asset("ANIM", "anim/merm_build.zip"),
    Asset("ANIM", "anim/merm_guard_build.zip"),
    Asset("ANIM", "anim/merm_guard_small_build.zip"),
    Asset("ANIM", "anim/merm_actions.zip"),
    Asset("ANIM", "anim/merm_guard_transformation.zip"),
    --Asset("ANIM", "anim/ds_pig_boat_jump.zip"),
    Asset("ANIM", "anim/ds_pig_basic.zip"),
    Asset("ANIM", "anim/ds_pig_actions.zip"),
    Asset("ANIM", "anim/ds_pig_attacks.zip"),
    Asset("SOUND", "sound/merm.fsb"),
    Asset("SOUND", "sound/wurt.fsb"),
}

local prefabs =
{
    "tropical_fish",
    "fish",
    "froglegs",
    "mermking",
    "merm_splash",
    "merm_spawn_fx",
}

local loot =
{
    "fish",
    "froglegs",
}

local sw_loot =
{
    "tropical_fish",
    "froglegs",
}

local sounds = {
    attack = "dontstarve/creatures/merm/attack",
    hit = "dontstarve/creatures/merm/hurt",
    death = "dontstarve/creatures/merm/death",
    talk = "dontstarve/characters/wurt/merm/warrior/talk",
    buff = "dontstarve/characters/wurt/merm/warrior/yell",
    --debuff = "dontstarve/characters/wurt/merm/warrior/yell",
}

local sounds_guard = {
    attack = "dontstarve/characters/wurt/merm/warrior/attack",
    hit = "dontstarve/characters/wurt/merm/warrior/hit",
    death = "dontstarve/characters/wurt/merm/warrior/death",
    talk = "dontstarve/characters/wurt/merm/warrior/talk",
    buff = "dontstarve/characters/wurt/merm/warrior/yell",
    --debuff = ,
}

local merm_brain = require "brains/mermbrain"
local merm_guard_brain = require "brains/mermguardbrain"

-----------------------------------------------------------------------------

--[[CONTENT]]
--#1 Target
--#2 Trade
--#3 Mermking
--#4 Sleep
--#5 fn
--#6 guard_postinit
--#7 common_postinit

-----------------------------------------------------------------------------
--#1 Target

local MAX_TARGET_SHARES = 5
local SHARE_TARGET_DIST = 40

local function SpringCombatMod(amt)
    if GetSeasonManager() and GetSeasonManager():IsSpring() then
        return amt * 1.33
    else
        return amt
    end
end

local function FindInvaderFn(guy, inst)
    --I know who is disguising as a merm
    local function test_disguise(test_guy)
        return test_guy.components.inventory and test_guy.components.inventory:EquipHasTag("merm")
    end

    local leader = inst.components.follower and inst.components.follower.leader
    local leader_guy = guy.components.follower and guy.components.follower.leader

    if leader_guy and leader_guy.components.inventoryitem then
        leader_guy = leader_guy.components.inventoryitem:GetGrandOwner()
    end

    return
        --Not a merm character = invader
        (guy:HasTag("character") and not (guy:HasTag("merm")))
        --No mermking in the world
        and not ((GetWorld() and GetWorld().components.mermkingmanager and GetWorld().components.mermkingmanager:HasKing()))
        --Not a leader player = invader
        and not (leader and leader:HasTag("player"))
        --Merm has a pig tag = invader
        and not (leader_guy and (leader_guy:HasTag("merm")) and not guy:HasTag("pig"))
end

local function RetargetFn(inst)
    local defend_dist = inst:HasTag("mermguard") and TUNING.MERM_GUARD_DEFEND_DIST or TUNING.MERM_DEFEND_DIST
    local defenseTarget = inst
    local home = inst.components.homeseeker and inst.components.homeseeker.home

    if home and inst:GetDistanceSqToInst(home) < defend_dist * defend_dist then
        defenseTarget = home
    end

    return FindEntity(defenseTarget or inst, SpringCombatMod(TUNING.MERM_TARGET_DIST), FindInvaderFn)
end

local function KeepTargetFn(inst, target)
    local defend_dist = inst:HasTag("mermguard") and TUNING.MERM_GUARD_DEFEND_DIST or TUNING.MERM_DEFEND_DIST
    local home = inst.components.homeseeker and inst.components.homeseeker.home
    local follower = inst.components.follower and inst.components.follower.leader

    if home and not follower then
        return home:GetDistanceSqToInst(target) < defend_dist*defend_dist
            and home:GetDistanceSqToInst(inst) < defend_dist*defend_dist
    end

    return inst.components.combat:CanTarget(target)
end

local function OnAttackedByDecidRoot(inst, attacker)
    local share_target_dist = inst:HasTag("mermguard") and TUNING.MERM_GUARD_SHARE_TARGET_DIST or TUNING.MERM_SHARE_TARGET_DIST
    local max_target_shares = inst:HasTag("mermguard") and TUNING.MERM_GUARD_MAX_TARGET_SHARES or TUNING.MERM_MAX_TARGET_SHARES

    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, SpringCombatMod(share_target_dist) * .5, { "_combat", "_health", "merm" }, { "INLIMBO" })
    local num_helpers = 0

    for i, v in ipairs(ents) do
        if v ~= inst and not v.components.health:IsDead() then
            v:PushEvent("suggest_tree_target", { tree = attacker })
            num_helpers = num_helpers + 1
            if num_helpers >= max_target_shares then
                break
            end
        end
    end
end

local function OnAttacked(inst, data)
    local attacker = data and data.attacker
    inst:ClearBufferedAction()

    if attacker and attacker.prefab == "deciduous_root" and attacker.owner then
        OnAttackedByDecidRoot(inst, attacker.owner)

    elseif attacker and inst.components.combat:CanTarget(attacker) and attacker.prefab ~= "deciduous_root" then
        local share_target_dist = inst:HasTag("mermguard") and TUNING.MERM_GUARD_SHARE_TARGET_DIST or TUNING.MERM_SHARE_TARGET_DIST
        local max_target_shares = inst:HasTag("mermguard") and TUNING.MERM_GUARD_MAX_TARGET_SHARES or TUNING.MERM_MAX_TARGET_SHARES

        inst.components.combat:SetTarget(attacker)

        --I help any merms nearby if they are attacked
        if TUNING.MERM_SHARETARGETS == 0 then
            if not attacker:HasTag("mermplayer") then
                inst.components.combat:ShareTarget(attacker, share_target_dist, function(dude)
                    return dude:HasTag("merm") and not dude:HasTag("player")
                end, max_target_shares)
            end
        end
        --I help my house mates if they are attacked
        if inst.components.homeseeker and inst.components.homeseeker.home then
            local home = inst.components.homeseeker.home
            if home and home.components.childspawner and inst:GetDistanceSqToInst(home) <= share_target_dist*share_target_dist then
                max_target_shares = max_target_shares - home.components.childspawner.childreninside
                home.components.childspawner:ReleaseAllChildren(attacker)
            end
            --Who is involved?
            inst.components.combat:ShareTarget(attacker, share_target_dist, function(dude)
                return  --merms living in the same home
                        (dude.components.homeseeker and dude.components.homeseeker.home and dude.components.homeseeker.home == home)
                        --merms who are not following a player; not a player merm.
                    or (dude:HasTag("merm") and not dude:HasTag("player") and not
                        (dude.components.follower and dude.components.follower.leader and dude.components.follower.leader:HasTag("player")))
            end, max_target_shares)
        end
    end
end

local function SuggestTreeTarget(inst, data)
    if data and data.tree and inst:GetBufferedAction() ~= ACTIONS.CHOP then
        inst.tree_target = data.tree
    end
end

local function OnTimerDone(inst, data)
    if data.name == "facetime" then
        inst.components.timer:StartTimer("dontfacetime", 10)
    end
end

-----------------------------------------------------------------------------
--#2 Trade

local function ShouldAcceptItem(inst, item, giver)
    local giver = GetPlayer()
    --I don't accept if I'm a guard and king is here
    if inst:HasTag("mermguard") and inst.king then
        return false
    end

    --I don't accept if I'm busy
    if inst.sg ~= nil and inst.sg:HasStateTag("busy") then
        --Sleeping is not busy
        if inst.sg:HasStateTag("sleeping") then
            return true
        end
        return false, "BUSY"
    end

    if inst.components.sleeper and inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end

    --I don't accept items if I'm a guard and giver is wearin mermhat
    if TUNING.MERMGUARD_BEFRIENDABLE == 1 then
        if giver:HasTag("mermdisguise") and inst:HasTag("mermguard") then
            return false
        end
    end

    return --I accept hat
           (item.components.equippable and item.components.equippable.equipslot == EQUIPSLOTS.HEAD)
           --I accept food
           or (item.components.edible and inst.components.eater:CanEat(item))
           --I accept fish if I'm not mermcandidate
           or (item:HasTag("fish") and not (GetWorld() and GetWorld().components.mermkingmanager and GetWorld().components.mermkingmanager:IsCandidate(inst)))
end

local function OnGetItemFromPlayer(inst, giver, item)
    local loyalty_max = inst:HasTag("mermguard") and TUNING.MERM_GUARD_LOYALTY_MAXTIME or TUNING.MERM_LOYALTY_MAXTIME
    local loyalty_per_hunger = inst:HasTag("mermguard") and TUNING.MERM_GUARD_LOYALTY_PER_HUNGER or TUNING.MERM_LOYALTY_PER_HUNGER

    --I eat
    if item.components.edible then
        --I stop targetting giver
        if inst.components.combat.target and inst.components.combat.target == giver then
            inst.components.combat:SetTarget(nil)
        --I make friends
        elseif giver.components.leader and not (GetWorld() and GetWorld().components.mermkingmanager and GetWorld().components.mermkingmanager:IsCandidate(inst)) then
            giver.components.leader:AddFollower(inst)
            inst.SoundEmitter:PlaySound("dontstarve/common/makeFriend")
            inst.components.follower:AddLoyaltyTime(item.components.edible:GetHunger() * loyalty_per_hunger)
            inst.components.follower.maxfollowtime = loyalty_max
        end
    end

    -- I also wear hats
    if item.components.equippable and item.components.equippable.equipslot == EQUIPSLOTS.HEAD then
        local current = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
        if current then
            inst.components.inventory:DropItem(current)
        end
        inst.components.inventory:Equip(item)
        inst.AnimState:Show("hat")
    end
end

local function OnRefuseItem(inst, item)
    inst.sg:GoToState("refuse")
    if inst.components.sleeper and inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end
end

local function CalcSanityAura(inst, observer)
    if inst.components.follower and inst.components.follower.leader == observer and GetPlayer().prefab == "wurt" then
        return TUNING.SANITYAURA_SMALL
    elseif inst.components.follower and inst.components.follower.leader == observer then
        return TUNING.SANITYAURA_TINY
    end

    return 0
end

-----------------------------------------------------------------------------
--#3 Mermking

local function OnEat(inst, data)
    if GetWorld() and GetWorld().components.mermkingmanager and GetWorld().components.mermkingmanager:IsCandidate(inst) then
        if data.food and data.food.components.edible then
            inst.components.mermcandidate:AddCalories(data.food)
        end
    end
end

local function RoyalUpgrade(inst)
    if inst.components.health:IsDead() then
        return
    end

    inst.components.health:SetMaxHealth(TUNING.MERM_HEALTH_KINGBONUS)
    inst.components.combat:SetDefaultDamage(TUNING.MERM_DAMAGE_KINGBONUS)
    inst.Transform:SetScale(1.05, 1.05, 1.05)
end

local function RoyalDowngrade(inst)
    if inst.components.health:IsDead() then
        return
    end

    inst.components.health:SetMaxHealth(TUNING.MERM_HEALTH)
    inst.components.combat:SetDefaultDamage(TUNING.MERM_DAMAGE)
    inst.Transform:SetScale(1, 1, 1)
end

local function RoyalGuardDowngrade(inst)
    if inst.components.health:IsDead() then
        return
    end

    inst.components.health:SetMaxHealth(TUNING.PUNY_MERM_HEALTH)
    inst.components.combat:SetDefaultDamage(TUNING.PUNY_MERM_DAMAGE)
    inst.AnimState:SetBuild("merm_guard_small_build")
    inst.Transform:SetScale(0.9, 0.9, 0.9)
end

local function RoyalGuardUpgrade(inst)
    if inst.components.health:IsDead() then
        return
    end

    inst.components.health:SetMaxHealth(TUNING.MERM_GUARD_HEALTH)
    inst.components.combat:SetDefaultDamage(TUNING.MERM_GUARD_DAMAGE)
    inst.AnimState:SetBuild("merm_guard_build")
    inst.Transform:SetScale(1, 1, 1)
    inst.Transform:SetScale(1.15, 1.15, 1.15)
end

-----------------------------------------------------------------------------
--#4 Sleep

local function ShouldGuardSleep(inst)
    return false
end

local function ShouldGuardWakeUp(inst)
    return true
end

local function ShouldSleep(inst)
    return  GetClock():IsDay()
        and not (inst.components.combat and inst.components.combat.target)
        and not (inst.components.burnable and inst.components.burnable:IsBurning() )
        and not (inst.components.freezable and inst.components.freezable:IsFrozen() )
        and not (inst.components.homeseeker and inst.components.homeseeker:HasHome() )
        and not (GetWorld() and GetWorld().components.mermkingmanager and GetWorld().components.mermkingmanager:IsCandidate(inst))
        and (inst.components.follower == nil or inst.components.follower.leader == nil)
end

local function ShouldWakeUp(inst)
    return  GetClock():IsDay()
        and not (inst.components.combat and inst.components.combat.target)
        and not (inst.components.burnable and inst.components.burnable:IsBurning() )
        and not (inst.components.freezable and inst.components.freezable:IsFrozen() )
        and not (inst.components.homeseeker and inst.components.homeseeker:HasHome() )
        and not (GetWorld() and GetWorld().components.mermkingmanager and GetWorld().components.mermkingmanager:IsCandidate(inst))
end

-----------------------------------------------------------------------------
--#5 fn

local function MakeMerm(name, assets, prefabs, postinit)
    local function fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddDynamicShadow()

        MakeCharacterPhysics(inst, 50, .5)

        inst.DynamicShadow:SetSize(1.5, .75)
        inst.Transform:SetFourFaced()
        inst.Transform:SetScale(1, 1, 1)
        inst.AnimState:SetBank("pigman")
        inst.AnimState:Hide("hat")

        inst:AddTag("character")
        inst:AddTag("merm")
        inst:AddTag("wet")

        inst:AddComponent("combat")
        inst.components.combat.hiteffectsymbol = "pig_torso"

        inst:AddComponent("eater")
        inst.components.eater.ablefoods = { "VEGGIE", "SEEDS", "HONEY", "ICE" }
        inst.components.eater.foodprefs = { "VEGGIE", "SEEDS", "HONEY", "ICE" }

        inst:AddComponent("lootdropper")
        if SaveGameIndex and SaveGameIndex:IsModeShipwrecked() then
            inst.components.lootdropper:SetLoot(sw_loot)
        else
            inst.components.lootdropper:SetLoot(loot)
        end

        if TUNING.MERM_SANITYAURA == 0 then
            inst:AddComponent("sanityaura")
            inst.components.sanityaura.aurafn = CalcSanityAura
        end

        inst:AddComponent("talker")
        inst.components.talker.fontsize = 35
        inst.components.talker.font = TALKINGFONT
        inst.components.talker.offset = Vector3(0, -400, 0)

        inst:AddComponent("trader")
        inst.components.trader:SetAcceptTest(ShouldAcceptItem)
        inst.components.trader.onaccept = OnGetItemFromPlayer
        inst.components.trader.onrefuse = OnRefuseItem
        inst.components.trader.deleteitemonaccept = false

        inst:AddComponent("follower")
        inst:AddComponent("health")
        inst:AddComponent("inventory")
        inst:AddComponent("inspectable")
        inst:AddComponent("knownlocations")
        inst:AddComponent("locomotor")
        inst:AddComponent("sleeper")
        inst:AddComponent("mermcandidate")
        inst:AddComponent("timer")

        MakeMediumBurnableCharacter(inst, "pig_torso")
        MakeMediumFreezableCharacter(inst, "pig_torso")

        inst:ListenForEvent("timerdone", OnTimerDone)
        inst:ListenForEvent("attacked", OnAttacked)
        inst:ListenForEvent("suggest_tree_target", SuggestTreeTarget)

        if postinit ~= nil then
            postinit(inst)
        end

        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end

-----------------------------------------------------------------------------
--#6 guard_postinit

local SLIGHTDELAY = 1

local function guard_postinit(inst)
    inst:SetBrain(merm_guard_brain)
    inst:SetStateGraph("SGmerm")
    inst.AnimState:SetBuild("merm_guard_build")
    inst.sounds = sounds_guard

    inst:AddTag("mermguard")
    inst:AddTag("guard")

    inst.components.combat:SetDefaultDamage(TUNING.MERM_GUARD_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.MERM_GUARD_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(1, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)

    inst.components.follower.maxfollowtime = TUNING.MERM_GUARD_LOYALTY_MAXTIME
    inst.components.health:SetMaxHealth(TUNING.MERM_GUARD_HEALTH)

    inst.components.locomotor.runspeed =  TUNING.MERM_GUARD_RUN_SPEED
    inst.components.locomotor.walkspeed = TUNING.MERM_GUARD_WALK_SPEED

    inst.components.sleeper:SetSleepTest(ShouldGuardSleep)
    inst.components.sleeper:SetWakeTest(ShouldGuardWakeUp)

    --//Mermking things
    inst:ListenForEvent("onmermkingcreated", function()
        inst:DoTaskInTime(math.random()*SLIGHTDELAY, function()
            RoyalGuardUpgrade(inst)
            inst:PushEvent("onmermkingcreated")
        end)
    end, GetWorld())

    inst:ListenForEvent("onmermkingdestroyed", function()
        inst:DoTaskInTime(math.random()*SLIGHTDELAY, function()
            RoyalGuardDowngrade(inst)
            inst:PushEvent("onmermkingdestroyed")
        end)
    end, GetWorld())

    inst:DoTaskInTime(0,function()
        if not (GetWorld() and GetWorld().components.mermkingmanager and GetWorld().components.mermkingmanager:HasKing()) then
            RoyalGuardDowngrade(inst)
        end
    end)
end

-----------------------------------------------------------------------------
--#7 common_postinit

local function common_postinit(inst)
    inst:SetBrain(merm_brain)
    inst:SetStateGraph("SGmerm")
    inst.AnimState:SetBuild("merm_build_2")
    inst.sounds = sounds

    inst.components.combat:SetDefaultDamage(TUNING.MERM_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.MERM_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(1, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)

    inst.components.follower.maxfollowtime = TUNING.MERM_LOYALTY_MAXTIME
    inst.components.health:SetMaxHealth(TUNING.MERM_HEALTH)

    inst.components.locomotor.runspeed = TUNING.MERM_RUN_SPEED
    inst.components.locomotor.walkspeed = TUNING.MERM_WALK_SPEED

    inst.components.sleeper:SetNocturnal(true)
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWakeUp)

    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("suggest_tree_target", SuggestTreeTarget)

    --//Mermking things
    inst:ListenForEvent("onmermkingcreated", function()
        inst:DoTaskInTime(math.random()*SLIGHTDELAY, function()
            RoyalUpgrade(inst)
            inst:PushEvent("onmermkingcreated")
        end)
    end, GetWorld())

    inst:ListenForEvent("onmermkingdestroyed", function()
        inst:DoTaskInTime(math.random()*SLIGHTDELAY, function()
            RoyalDowngrade(inst)
            inst:PushEvent("onmermkingdestroyed")
        end)
    end, GetWorld())

    inst:ListenForEvent("oneat", OnEat)

    if GetWorld() and GetWorld().components.mermkingmanager and GetWorld().components.mermkingmanager:HasKing() then
        RoyalUpgrade(inst)
    end
end

-----------------------------------------------------------------------------

return MakeMerm("merm", assets, prefabs, common_postinit),
       MakeMerm("mermguard", assets, prefabs, guard_postinit)

