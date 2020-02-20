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
local SEE_FOOD_DIST       = 5
local MAX_WANDER_DIST     = 15
local MAX_CHASE_TIME      = 25
local MAX_CHASE_DIST      = 40
local RUN_AWAY_DIST       = 5
local STOP_RUN_AWAY_DIST  = 8

local MIN_FOLLOW_DIST     = 1
local TARGET_FOLLOW_DIST  = 5
local MAX_FOLLOW_DIST     = 9

local SEE_TREE_DIST       = 20
local KEEP_CHOPPING_DIST  = 10

local SEE_ROCK_DIST       = 20
local KEEP_MINING_DIST    = 10

local SEE_HAMMER_DIST     = 20
local KEEP_HAMMERING_DIST = 10

local FACETIME_BASE       = 2
local FACETIME_RAND       = 2

local MermBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)


-----------------------------------------------------------------------------------------------

--//CONTENT//
--#1 Chop
--#2 Eat
--#3 Face Target
--#4 Hammer
--#5 Home
--#6 Mine
--#7 Speech
--#8 Nodes

-----------------------------------------------------------------------------------------------
--#1 Chop

local function IsDeciduousTreeMonster(guy)
    return guy.monster and guy.prefab == "deciduoustree"
end

local function FindDeciduousTreeMonster(inst)
    return FindEntity(inst, SEE_TREE_DIST / 3, IsDeciduousTreeMonster, 
        function(item) 
            return item.components.workable and item.components.workable.action == ACTIONS.CHOP 
        end)
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
    local target = FindEntity(inst, SEE_TREE_DIST, 
        function(item) 
            return item.components.workable and item.components.workable.action == ACTIONS.CHOP 
        end)
        
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
--#2 Eat

local function EatFoodAction(inst)
    if inst.sg:HasStateTag("waking") then
        return
    end

    local target = nil
    if inst.components.inventory ~= nil and inst.components.eater ~= nil then
        target = inst.components.inventory:FindItem(function(item) return inst.components.eater:CanEat(item) end)
    end
    
    if target == nil then
        target = FindEntity(inst, SEE_FOOD_DIST, 
                    function(item) 
                        return inst.components.eater:CanEat(item) 
                    end, { "VEGGIE", "ROUGHAGE"}, { "INLIMBO" })
                    
        --check for scary things near the food
        if target ~= nil and (GetClosestInstWithTag("scarytoprey", target, SEE_PLAYER_DIST) ~= nil) then
            target = nil
        end
    end
    
    if target ~= nil then
        local act = BufferedAction(inst, target, ACTIONS.EAT)
        act.validfn = function() 
                        return  target.components.inventoryitem == nil or 
                                target.components.inventoryitem.owner == nil or 
                                target.components.inventoryitem.owner == inst 
                      end
        return act
    end
end

-----------------------------------------------------------------------------------------------
--#3 Face Target

local function GetFaceTargetFn(inst)
    if inst.components.timer:TimerExists("dontfacetime") then
        return nil
    end
    
    local shouldface =  inst.components.follower.leader or 
                        GetClosestInstWithTag("player", inst, SEE_PLAYER_DIST)              
    if shouldface and not inst.components.timer:TimerExists("facetime") then
        inst.components.timer:StartTimer("facetime", FACETIME_BASE + math.random()*FACETIME_RAND)
    end
    
    return shouldface
end

local function KeepFaceTargetFn(inst, target)
    if inst.components.timer:TimerExists("dontfacetime") then
        return nil
    end    
    
    local keepface = (inst.components.follower.leader and inst.components.follower.leader == target) or 
                     (target:IsValid() and inst:IsNear(target, SEE_PLAYER_DIST))    
    if not keepface then
        inst.components.timer:StopTimer("facetime")
    end
    
    return keepface
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
    local target = FindEntity(inst, SEE_HAMMER_DIST, 
                    function(item) 
                        return item.components.workable and item.components.workable.action == ACTIONS.HAMMER 
                    end)
                    
    if target ~= nil then
        return BufferedAction(inst, target, ACTIONS.HAMMER)
    end
end

-----------------------------------------------------------------------------------------------
--#5 Home

local function GetNoLeaderHomePos(inst)
    if inst.components.follower and inst.components.follower.leader ~= nil then
        return nil
    end
    return inst.components.knownlocations:GetLocation("home")
end

-----------------------------------------------------------------------------------------------
--#6 Mine

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
    local target = FindEntity(inst, SEE_ROCK_DIST, 
        function(item) 
            return item.components.workable and item.components.workable.action == ACTIONS.MINE 
        end)
        
    if target ~= nil then
        return BufferedAction(inst, target, ACTIONS.MINE)
    end
end

-----------------------------------------------------------------------------------------------
--#7 Speech



-----------------------------------------------------------------------------------------------
--#8 Nodes

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
        WhileNode(function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),
        WhileNode(function() return self.inst.components.combat.target == nil or not self.inst.components.combat:InCooldown() end, "AttackMomentarily",
            ChaseAndAttack(self.inst, SpringCombatMod(MAX_CHASE_TIME), SpringCombatMod(MAX_CHASE_DIST))),
        WhileNode(function() return self.inst.components.combat.target ~= nil and self.inst.components.combat:InCooldown() end, "Dodge",
            RunAway(self.inst, function() return self.inst.components.combat.target end, RUN_AWAY_DIST, STOP_RUN_AWAY_DIST)),

        WhileNode(function() 
                if not self.inst.king or (not self.inst.king:IsValid() or (self.inst.king.components.health and self.inst.king.components.health:IsDead())) then
                    self.inst.return_to_king = false
                    self.inst.king = nil
                end

                return self.inst.return_to_king 
            end, "ShouldGoToThrone",
            PriorityNode({
                Leash(self.inst, function() return self.inst.king:GetPosition() end, 
                2, 2, true),
                IfNode(function() return true end, "IsThroneValid",
                    ActionNode(function()
                        local fx = SpawnPrefab("merm_spawn_fx")
                        fx.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
                        self.inst.SoundEmitter:PlaySound("dontstarve/characters/wurt/merm/buff") -- Splash sound
                        self.inst:Remove()
                    end)
                ),
            }, .25)),

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

        ChattyNode(self.inst, "MERM_TALK_FIND_FOOD",
            DoAction(self.inst, EatFoodAction, "Eat Food")),

        ChattyNode(self.inst, "MERM_TALK_FOLLOWWILSON",
          Follow(self.inst, function() return self.inst.components.follower.leader end, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST)),

        IfNode(function() return self.inst.components.follower.leader ~= nil end, "HasLeader",
            ChattyNode(self.inst, "MERM_TALK_FOLLOWWILSON",
                FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn ))),

        FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),
        Wander(self.inst, GetNoLeaderHomePos, MAX_WANDER_DIST),
    }, .25)

    self.bt = BT(self.inst, root)
end

return MermBrain
