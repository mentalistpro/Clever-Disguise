require "behaviours/wander"
require "behaviours/follow"
require "behaviours/faceentity"
require "behaviours/chaseandattack"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/findlight"
require "behaviours/panic"
require "behaviours/chattynode"
require "behaviours/leash"

local BrainCommon = require "brains/braincommon"

local SEE_PLAYER_DIST     = 5
local SEE_FOOD_DIST       = 10
local MAX_WANDER_DIST     = 15
local MAX_CHASE_TIME      = 10
local MAX_CHASE_DIST      = 20
local RUN_AWAY_DIST       = 5
local STOP_RUN_AWAY_DIST  = 8

local MIN_FOLLOW_DIST     = 1
local TARGET_FOLLOW_DIST  = 5
local MAX_FOLLOW_DIST     = 9

local SEE_TREE_DIST       = 15
local KEEP_CHOPPING_DIST  = 10

local SEE_ROCK_DIST       = 15
local KEEP_MINING_DIST    = 10

local SEE_HAMMER_DIST     = 15
local KEEP_HAMMERING_DIST = 10

local SEE_THRONE_DISTANCE = 50

local MermBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

-----------------------------------------------------------------------------------------------

--//CONTENT//
--#1 Face Target
--#2 Chop
--#3 Mine
--#4 Hammer
--#5 Eat
--#6 Merm King
--#7 Nodes

-----------------------------------------------------------------------------------------------
--#1 Face Target

local function GetFaceTargetFn(inst)
    return GetClosestInstWithTag("player", inst, SEE_PLAYER_DIST)
end

local function KeepFaceTargetFn(inst, target)
    return inst:GetDistanceSqToInst(target) <= SEE_PLAYER_DIST*SEE_PLAYER_DIST
end

-----------------------------------------------------------------------------------------------
--#2 Chop

local function IsDeciduousTreeMonster(guy)
    return guy.monster and guy.prefab == "deciduoustree"
end

local function FindDeciduousTreeMonster(inst)
    return FindEntity(inst, SEE_TREE_DIST / 3, IsDeciduousTreeMonster, { "workable" })
end

local function KeepChoppingAction(inst)
    local keep_chopping = inst.tree_target ~= nil
        or (inst.components.follower.leader ~= nil and
            inst:IsNear(inst.components.follower.leader, KEEP_CHOPPING_DIST))
        or FindDeciduousTreeMonster(inst) ~= nil
    
    return keep_chopping
end

local function StartChoppingCondition(inst)
    local chop_condition = inst.tree_target ~= nil
        or (inst.components.follower.leader ~= nil and
            inst.components.follower.leader.sg ~= nil and
            inst.components.follower.leader.sg:HasStateTag("chopping"))
        or FindDeciduousTreeMonster(inst) ~= nil

    return chop_condition
end

local function FindTreeToChopAction(inst)
    local target = FindEntity(inst, SEE_TREE_DIST, nil, { "workable" })
    if target ~= nil then
        if inst.tree_target ~= nil then
            target = inst.tree_target
            inst.tree_target = nil
        else
            target = FindDeciduousTreeMonster(inst) or target
        end
        
        return BufferedAction(inst, target, ACTIONS.CHOP)
    end
end

-----------------------------------------------------------------------------------------------
--#3 Mine

local function KeepMiningAction(inst)
    local keep_mining = (inst.components.follower.leader ~= nil and
            inst:IsNear(inst.components.follower.leader, KEEP_MINING_DIST))
    
    return keep_mining
end

local function StartMiningCondition(inst)
    local mine_condition = (inst.components.follower.leader ~= nil and
            inst.components.follower.leader.sg ~= nil and
            inst.components.follower.leader.sg:HasStateTag("mining"))

    return mine_condition
end

local function FindRockToMineAction(inst)
    local target = FindEntity(inst, SEE_ROCK_DIST, nil, { "workable" })
    if target ~= nil then
        return BufferedAction(inst, target, ACTIONS.MINE)
    end
end

-----------------------------------------------------------------------------------------------
--#4 Hammer

local function KeepHammeringAction(inst)
    local keep_hammering = (inst.components.follower.leader ~= nil and
            inst:IsNear(inst.components.follower.leader, KEEP_HAMMERING_DIST))
    
    return keep_hammering
end

local function StartHammeringCondition(inst)
    local hammer_condition = (inst.components.follower.leader ~= nil and
            inst.components.follower.leader.sg ~= nil and
            inst.components.follower.leader.sg:HasStateTag("hammering"))

    return hammer_condition
end

local function FindHammerTargetAction(inst)
    local target = FindEntity(inst, SEE_HAMMER_DIST, nil, { "workable" })
    if target ~= nil then
        return BufferedAction(inst, target, ACTIONS.HAMMER)
    end
end

-----------------------------------------------------------------------------------------------
--#5 Eat

local function EatFoodAction(inst)
    if inst.sg:HasStateTag("waking") then
        return
    end

    local target = nil
    if inst.components.inventory ~= nil and inst.components.eater ~= nil then
        target = inst.components.inventory:FindItem(function(item) return inst.components.eater:CanEat(item) end)
    end
    
    if target == nil then
        target = FindEntity(inst, SEE_FOOD_DIST, function(item) return inst.components.eater:CanEat(item) end, { "VEGGIE", "ROUGHAGE"}, { "INLIMBO" })
        --check for scary things near the food
        if target ~= nil and (GetClosestInstWithTag("scarytoprey", target, SEE_PLAYER_DIST) ~= nil) then
            target = nil
        end
    end
    
    if target ~= nil then
        local act = BufferedAction(inst, target, ACTIONS.EAT)
        act.validfn = function() return target.components.inventoryitem == nil or target.components.inventoryitem.owner == nil or target.components.inventoryitem.owner == inst end
        return act
    end
end


-----------------------------------------------------------------------------------------------
--#6 Merm king

--[[local function IsThroneValid(inst)
    if GetWorld().components.mermkingmanager then
        local throne = GetWorld.components.mermkingmanager:GetThrone(inst)
        return throne ~= nil
            and throne:IsValid()
            and not (throne.components.burnable ~= nil and throne.components.burnable:IsBurning())
            and not throne:HasTag("burnt")
            and GetWorld().components.mermkingmanager:ShouldGoToThrone(inst, throne)
    end

    return false
end

local function ShouldGoToThrone(inst)
    if GetWorld().components.mermkingmanager then
        local throne = GetWorld().components.mermkingmanager:GetThrone(inst)
        if throne == nil then
            throne = FindEntity(inst, SEE_THRONE_DISTANCE, nil, { "mermthrone" })
        end

        return throne and GetWorld().components.mermkingmanager:ShouldGoToThrone(inst, throne)
    end

    return false
end

local function GetThronePosition(inst)
    if GetWorld().components.mermkingmanager then
        local throne = GetWorld().components.mermkingmanager:GetThrone(inst)
        if throne then
            return throne:GetPosition()
        end
    end
end]]

-----------------------------------------------------------------------------------------------
--#7 Home

local function GoHomeAction(inst)
    if inst.components.combat.target ~= nil then
        return
    end
    
    local home = inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil
    return home ~= nil
        and home:IsValid()
        and not (home.components.burnable ~= nil and home.components.burnable:IsBurning())
        and not home:HasTag("burnt")
        and BufferedAction(inst, home, ACTIONS.GOHOME)
        or nil
end

local function ShouldGoHome(inst)
    if not GetClock():IsDay() or (inst.components.follower ~= nil and inst.components.follower.leader ~= nil) then
        return false
    end

    --one merm should stay outside
    local home = inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil
    return home == nil
        or home.components.childspawner == nil
        or home.components.childspawner:CountChildrenOutside() > 1
end

local function IsHomeOnFire(inst)
    return inst.components.homeseeker
        and inst.components.homeseeker.home
        and inst.components.homeseeker.home.components.burnable
        and inst.components.homeseeker.home.components.burnable:IsBurning()
end

local function GetNoLeaderHomePos(inst)
    if inst.components.follower and inst.components.follower.leader ~= nil then
        return nil
    end

    return inst.components.knownlocations:GetLocation("home")
end

-----------------------------------------------------------------------------------------------
--#7 Nodes

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

function MermBrain:OnStart()
    local root = PriorityNode(
    {
        --[[IfNode(function() return GetWorld().components.mermkingmanager and GetWorld().components.mermkingmanager.king end,"panic with king",
            BrainCommon.PanicWhenScared(self.inst, .25, "MERM_TALK_PANICBOSS_KING")),
        IfNode(function() return not GetWorld().components.mermkingmanager or not GetWorld().components.mermkingmanager.king  end,"panic with no king",
            BrainCommon.PanicWhenScared(self.inst, .25, "MERM_TALK_PANICBOSS")),]]
        WhileNode(function() return self.inst.components.hauntable ~= nil and self.inst.components.hauntable.panic end, "PanicHaunted", Panic(self.inst)),
        WhileNode(function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),
        WhileNode(function() return self.inst.components.combat.target == nil or not self.inst.components.combat:InCooldown() end, "AttackMomentarily",
            ChaseAndAttack(self.inst, SpringCombatMod(MAX_CHASE_TIME), SpringCombatMod(MAX_CHASE_DIST))),
        WhileNode(function() return self.inst.components.combat.target ~= nil and self.inst.components.combat:InCooldown() end, "Dodge",
            RunAway(self.inst, function() return self.inst.components.combat.target end, RUN_AWAY_DIST, STOP_RUN_AWAY_DIST)),

        ChattyNode(self.inst, "MERM_TALK_FIND_FOOD",
            DoAction(self.inst, EatFoodAction, "Eat Food")),

        --[[WhileNode(function() return ShouldGoToThrone(self.inst) and self.inst.components.combat.target == nil end, "ShouldGoToThrone",
            PriorityNode({
                Leash(self.inst, GetThronePosition, 0.2, 0.2, true),
                IfNode(function() return IsThroneValid(self.inst) end, "IsThroneValid",
                    ActionNode(function() self.inst:PushEvent("onarrivedatthrone") end)
                ),
            }, .25)),]]

        IfNode(function() return StartChoppingCondition(self.inst) end, "chop", 
                WhileNode(function() return KeepChoppingAction(self.inst) end, "keep chopping",
                    LoopNode{
                        ChattyNode(self.inst, "MERM_TALK_HELP_CHOP_WOOD",
                            DoAction(self.inst, FindTreeToChopAction ))})),

        IfNode(function() return StartMiningCondition(self.inst) end, "mine", 
                WhileNode(function() return KeepMiningAction(self.inst) end, "keep mining", 
                    LoopNode{
                        ChattyNode(self.inst, "MERM_TALK_HELP_MINE_ROCK",
                            DoAction(self.inst, FindRockToMineAction ))})),

        ChattyNode(self.inst, "MERM_TALK_FOLLOWWILSON",
          Follow(self.inst, function() return self.inst.components.follower.leader end, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST)),

        IfNode(function() return self.inst.components.follower.leader ~= nil end, "HasLeader",
            ChattyNode(self.inst, "MERM_TALK_FOLLOWWILSON",
                FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn ))),

        WhileNode( function() return IsHomeOnFire(self.inst) end, "HomeOnFire", Panic(self.inst)), 
        WhileNode(function() return ShouldGoHome(self.inst) end, "ShouldGoHome",
            DoAction(self.inst, GoHomeAction, "Go Home", true)),

        FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),
        Wander(self.inst, GetNoLeaderHomePos, MAX_WANDER_DIST),
    }, .25)

    self.bt = BT(self.inst, root)
end

return MermBrain
