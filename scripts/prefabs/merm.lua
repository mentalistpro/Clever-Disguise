require "brains/mermbrain"
require "brains/mermguardbrain"
require "stategraphs/SGmerm"

local assets =
{
    Asset("ANIM", "anim/merm_build.zip"),
    Asset("ANIM", "anim/merm_guard_build.zip"),
    Asset("ANIM", "anim/merm_guard_small_build.zip"),
    Asset("ANIM", "anim/merm_actions.zip"),
    Asset("ANIM", "anim/merm_guard_transformation.zip"),    
    Asset("ANIM", "anim/ds_pig_basic.zip"),
    Asset("ANIM", "anim/ds_pig_actions.zip"),
    Asset("ANIM", "anim/ds_pig_attacks.zip"),
    Asset("SOUND", "sound/merm.fsb"),
}

local prefabs =
{
    "fish",
    "froglegs",
    "merm_spawn_fx",
    "merm_splash",
    "mermking",
    "tropical_fish"
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

local sounds = 
{
    attack = "dontstarve/creatures/merm/attack",
    hit = "dontstarve/creatures/merm/hurt",
    death = "dontstarve/creatures/merm/death",
    talk = "dontstarve/characters/wurt/merm/warrior/talk",
    buff = "dontstarve/characters/wurt/merm/warrior/yell",
}

local sounds_guard =
{
    attack = "dontstarve/characters/wurt/merm/warrior/attack",
    hit = "dontstarve/characters/wurt/merm/warrior/hit",
    death = "dontstarve/characters/wurt/merm/warrior/death",
    talk = "dontstarve/characters/wurt/merm/warrior/talk",
    buff = "dontstarve/characters/wurt/merm/warrior/yell",
} 

-------------------------------------------------------------------------------------------------------------------------

--//CONTENT//
--#1 TUNING
--#2 Chop 
--#3 Combat
--#4 Merm King
--#5 Sleep
--#6 Target
--#7 Trade
--#8 Fn

-------------------------------------------------------------------------------------------------------------------------
--#1 TUNING

local MAX_TARGET_SHARES = 5
local SHARE_TARGET_DIST = 40

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

-------------------------------------------------------------------------------------------------------------------------
--#2 Chop

local function SuggestTreeTarget(inst, data)
    if data ~= nil and data.tree ~= nil and inst:GetBufferedAction() ~= ACTIONS.CHOP then
        inst.tree_target = data.tree
    end
end

-------------------------------------------------------------------------------------------------------------------------
--#3 Combat

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
    if attacker and attacker.prefab == "deciduous_root" and attacker.owner ~= nil then 
        OnAttackedByDecidRoot(inst, attacker.owner)
    
    elseif attacker and inst.components.combat:CanTarget(attacker) and attacker.prefab ~= "deciduous_root" then
        local share_target_dist = inst:HasTag("mermguard") and TUNING.MERM_GUARD_SHARE_TARGET_DIST or TUNING.MERM_SHARE_TARGET_DIST
        local max_target_shares = inst:HasTag("mermguard") and TUNING.MERM_GUARD_MAX_TARGET_SHARES or TUNING.MERM_MAX_TARGET_SHARES
        inst.components.combat:SetTarget(attacker)
        
        if inst.components.homeseeker and inst.components.homeseeker.home then
            local home = inst.components.homeseeker.home
            
            if home and home.components.childspawner and inst:GetDistanceSqToInst(home) <= share_target_dist*share_target_dist then
                max_target_shares = max_target_shares - home.components.childspawner.childreninside
                home.components.childspawner:ReleaseAllChildren(attacker)
            end
            
            inst.components.combat:ShareTarget(attacker, share_target_dist, function(dude)
                return  (dude.components.homeseeker and
                         dude.components.homeseeker.home and
                         dude.components.homeseeker.home == home) or
                        
                        (dude:HasTag("merm") and not 
                         dude:HasTag("player") and not
                         
                        (dude.components.follower and
                         dude.components.follower.leader and
                         dude.components.follower.leader:HasTag("player") ) )
            end, max_target_shares)
        end
    end
end

-------------------------------------------------------------------------------------------------------------------------
--#4 Merm King

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
    inst.Transform:SetScale(1.15, 1.15, 1.15)
end

-------------------------------------------------------------------------------------------------------------------------
--#5 Sleep

local function ShouldSleep(inst)
    return  GetClock():IsDay() and not 
            (inst.components.combat and inst.components.combat.target) and not 
            (inst.components.burnable and inst.components.burnable:IsBurning() ) and not 
            (inst.components.freezable and inst.components.freezable:IsFrozen() ) and not
            (inst.components.homeseeker and inst.components.homeseeker:HasHome() ) and not
            (GetWorld() and GetWorld().components.mermkingmanager and GetWorld().components.mermkingmanager:IsCandidate(inst) ) and
            
            (inst.components.follower == nil or inst.components.follower.leader == nil)
end

local function ShouldWakeUp(inst)
    return  not GetClock():IsDay() or
            (inst.components.combat and inst.components.combat.target) or
            (inst.components.burnable and inst.components.burnable:IsBurning() ) or
            (inst.components.freezable and inst.components.freezable:IsFrozen() ) or
            (inst.components.homeseeker and inst.components.homeseeker:HasHome() ) or
            (GetWorld() and GetWorld().components.mermkingmanager and GetWorld().components.mermkingmanager:IsCandidate(inst) )
end

local function ShouldGuardSleep(inst)
    return false
end

local function ShouldGuardWakeUp(inst)
    return true
end

-------------------------------------------------------------------------------------------------------------------------
--#6 Target

local function SpringCombatMod(amt)
    if IsDLCEnabled(1) or IsDLCEnabled(2) or IsDLCEnabled(3) then
        if GetSeasonManager() and GetSeasonManager():IsSpring() then
            return amt * 1.33
        else
            return amt
        end
    else
        return amt
    end
end

local function FindInvaderFn(guy, inst)
    local function test_disguise(test_guy)
        return test_guy.components.inventory and test_guy.components.inventory:EquipHasTag("merm")
    end
    
    local leader = inst.components.follower and inst.components.follower.leader
    local leader_guy = guy.components.follower and guy.components.follower.leader
    
    if leader_guy and leader_guy.components.inventoryitem then
        leader_guy = leader_guy.components.inventoryitem:GetGrandOwner()
    end

    return  --No merm tag on character = invader
            (guy:HasTag("character") and not guy:HasTag("merm") ) and not
            --No merm king presence = invader
            (GetWorld() and GetWorld().components.mermkingmanager and GetWorld().components.mermkingmanager:HasKing() ) and not
            --No player tag on leader = invader
            (leader and leader:HasTag("player") ) and not
            --No merm tag and has pig tag on leader = invader
            (leader_guy and leader_guy:HasTag("merm") and not guy:HasTag("pig") )
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
        return home:GetDistanceSqToInst(target) < defend_dist*defend_dist and
               home:GetDistanceSqToInst(inst) < defend_dist*defend_dist
    end

    return inst.components.combat:CanTarget(target)
end

local function OnTimerDone(inst, data)
    if data.name == "facetime" then
        inst.components.timer:StartTimer("dontfacetime", 10)
    end
end

-------------------------------------------------------------------------------------------------------------------------
--#7 Trade

local function ShouldAcceptItem(inst, item, giver)
    local giver = GetPlayer()
    
    if inst.components.sleeper and inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end
    
    if inst.sg ~= nil and inst.sg:HasStateTag("busy") then
        return false, "BUSY"
    end 

    if inst:HasTag("mermguard") and inst.king ~= nil then
        return false
    end

    return  --Accept if giver is a merm. Merm guard only accepts if giver is not wearing Clever Disguise.
            (giver:HasTag("merm") and not (giver:HasTag("mermdisguise") and inst:HasTag("mermguard") ) ) 
            --Accept if item is a hat
            and ( (item.components.equippable ~= nil and item.components.equippable.equipslot == EQUIPSLOTS.HEAD) 
            --Accept if item is a food
            or (item.components.edible and inst.components.eater:CanEat(item) ) 
            --Accept if item is a fish and receiver is not mermking candidate
            or (item:HasTag("fish") and not (GetWorld() and GetWorld().components.mermkingmanager and GetWorld().components.mermkingmanager:IsCandidate(inst) ) ) )
end

local function OnGetItemFromPlayer(inst, giver, item)
    local loyalty_max = inst:HasTag("mermguard") and TUNING.MERM_GUARD_LOYALTY_MAXTIME or TUNING.MERM_LOYALTY_MAXTIME
    local loyalty_per_hunger = inst:HasTag("mermguard") and TUNING.MERM_GUARD_LOYALTY_PER_HUNGER or TUNING.MERM_LOYALTY_PER_HUNGER

    if item.components.edible ~= nil then
        if inst.components.combat.target and inst.components.combat.target == giver then
            inst.components.combat:SetTarget(nil)
            
        elseif giver.components.leader ~= nil and not (GetWorld() and GetWorld().components.mermkingmanager and GetWorld().components.mermkingmanager:IsCandidate(inst) ) then
            giver.components.leader:AddFollower(inst)
            
            inst.SoundEmitter:PlaySound("dontstarve/common/makeFriend")
            inst.components.follower:AddLoyaltyTime(item.components.edible:GetHunger() * loyalty_per_hunger)
            inst.components.follower.maxfollowtime = loyalty_max
        end
    end

    if item.components.equippable ~= nil and item.components.equippable.equipslot == EQUIPSLOTS.HEAD then
        local current = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
        if current ~= nil then
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

-------------------------------------------------------------------------------------------------------------------------
--#8 Fn

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
        inst.components.eater:SetVegetarian()
                
        inst:AddComponent("lootdropper")
        inst.components.lootdropper:SetLoot(loot)
        
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
        inst:AddComponent("inspectable")
        inst:AddComponent("inventory")
        inst:AddComponent("knownlocations")
        inst:AddComponent("locomotor")
        --inst:AddComponent("mermcandidate")
        inst:AddComponent("mermkingmanager")
        inst:AddComponent("sleeper")
        inst:AddComponent("timer")

        MakeMediumBurnableCharacter(inst, "pig_torso")
        MakeMediumFreezableCharacter(inst, "pig_torso")
        
        inst:ListenForEvent("attacked", OnAttacked)
        inst:ListenForEvent("suggest_tree_target", SuggestTreeTarget)
        inst:ListenForEvent("timerdone", OnTimerDone)

        if postinit ~= nil then
            postinit(inst)
        end        

        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end

local function merm_postinit(inst)
    inst.AnimState:SetBuild("merm_build")
    inst.sounds = sounds

    local merm_brain = require "brains/mermbrain"
    inst:SetStateGraph("SGmerm")
    inst:SetBrain(merm_brain)

    inst.components.combat:SetAttackPeriod(TUNING.MERM_ATTACK_PERIOD)   
    inst.components.combat:SetDefaultDamage(TUNING.MERM_DAMAGE)
    inst.components.combat:SetRetargetFunction(1, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)  
    
    inst.components.follower.maxfollowtime = TUNING.MERM_LOYALTY_MAXTIME
    
    inst.components.health:SetMaxHealth(TUNING.MERM_HEALTH)
    
    inst.components.locomotor.runspeed =  TUNING.MERM_RUN_SPEED
    inst.components.locomotor.walkspeed = TUNING.MERM_WALK_SPEED
    
    if SaveGameIndex and SaveGameIndex:IsModeShipwrecked() then
        inst.components.lootdropper:SetLoot(sw_loot)
    else
        inst.components.lootdropper:SetLoot(loot)
    end

    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWakeUp)
	
	inst:ListenForEvent("onmermkingcreated", function() 
		inst:DoTaskInTime(math.random()*SLIGHTDELAY,function()
			RoyalUpgrade(inst) 
			inst:PushEvent("onmermkingcreated") 
		end)
	end, GetWorld() )
	
	inst:ListenForEvent("onmermkingdestroyed", function() 
		inst:DoTaskInTime(math.random()*SLIGHTDELAY,function()
			RoyalDowngrade(inst)
			inst:PushEvent("onmermkingdestroyed")  
		end)
	end, GetWorld() )

	if GetWorld() and GetWorld().components.mermkingmanager and GetWorld().components.mermkingmanager:HasKing() then
		RoyalUpgrade(inst)
	end
end

local function mermguard_postinit(inst)
    inst.AnimState:SetBuild("merm_guard_build")
    inst.sounds = sounds_guard

    local merm_guard_brain = require "brains/mermguardbrain"
    inst:SetStateGraph("SGmerm")
    inst:SetBrain(merm_guard_brain)
    
    inst:AddTag("mermguard")
    inst:AddTag("guard")

    inst.components.combat:SetAttackPeriod(TUNING.MERM_GUARD_ATTACK_PERIOD) 
    inst.components.combat:SetDefaultDamage(TUNING.MERM_GUARD_DAMAGE)
    inst.components.combat:SetRetargetFunction(1, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)  
    
    inst.components.follower.maxfollowtime = TUNING.MERM_GUARD_LOYALTY_MAXTIME
    
    inst.components.health:SetMaxHealth(TUNING.MERM_GUARD_HEALTH)
    
    inst.components.locomotor.runspeed =  TUNING.MERM_GUARD_RUN_SPEED
    inst.components.locomotor.walkspeed = TUNING.MERM_GUARD_WALK_SPEED

    if SaveGameIndex and SaveGameIndex:IsModeShipwrecked() then
        inst.components.lootdropper:SetLoot(sw_loot)
    else
        inst.components.lootdropper:SetLoot(loot)
    end
    
    inst.components.sleeper:SetSleepTest(ShouldGuardSleep)
    inst.components.sleeper:SetWakeTest(ShouldGuardWakeUp)
	
	inst:ListenForEvent("onmermkingcreated", function() 
		inst:DoTaskInTime(math.random()*SLIGHTDELAY,function()  
            RoyalGuardUpgrade(inst) 
            inst:PushEvent("onmermkingcreated") 
        end)
    end, GetWorld() )
	
    inst:ListenForEvent("onmermkingdestroyed", function()
        inst:DoTaskInTime(math.random()*SLIGHTDELAY,function() 
            RoyalGuardDowngrade(inst) 
            inst:PushEvent("onmermkingdestroyed") 
        end)
    end, GetWorld() )

    inst:DoTaskInTime(0,function()
        if not (GetWorld() and GetWorld().components.mermkingmanager and GetWorld().components.mermkingmanager:HasKing() ) then
            RoyalGuardDowngrade(inst)
        end
    end)
end

return MakeMerm("merm", assets, prefabs, merm_postinit),
       MakeMerm("mermguard", assets, prefabs, mermguard_postinit)
	   
