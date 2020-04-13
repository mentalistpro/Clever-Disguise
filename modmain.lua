PrefabFiles =
{
    "disguisehat",
    "kelp",
    "kelphat",
    "mermhat",
    "mermking",
    "mermsplashes",
    "mermthrone",
    "merm",
}

Assets =
{
    Asset("ATLAS", "images/inventoryimages/kelp.xml"),
    Asset("ATLAS", "images/inventoryimages/kelp_cooked.xml"),
    Asset("ATLAS", "images/inventoryimages/kelp_dried.xml"),
    Asset("ATLAS", "images/inventoryimages/kelphat.xml"),
    Asset("ATLAS", "images/inventoryimages/mermhat.xml"),
    Asset("ATLAS", "images/inventoryimages/disguisehat.xml"),
    Asset("ATLAS", "images/inventoryimages/mermthrone_construction.xml"),
    Asset("ATLAS", "minimap/merm_king_carpet.xml"),
    Asset("ATLAS", "minimap/merm_king_carpet_construction.xml"),
    Asset("ATLAS", "minimap/merm_king_carpet_occupied.xml"),
    Asset("ANIM", "anim/player_construct.zip"),   --for prefabs/player_common.lua
    Asset("ATLAS", "images/hud_construction.xml"),
}

AddMinimapAtlas("minimap/merm_king_carpet.xml")
AddMinimapAtlas("minimap/merm_king_carpet_construction.xml")
AddMinimapAtlas("minimap/merm_king_carpet_occupied.xml")

modimport("modrecipes.lua") --mod recipes
modimport("modstrings.lua") --mod strings
modimport("modtunings.lua") --mod TUNING

-----------------------------------------------------------------

--[[CONTENT]]
--#1 Global functions
--#2 AddPrefabPostInit
--  #2.1-2   Fish tags & foodtype
--  #2.3     Mermkingmanager
--  #2.4     Mermgurad
--  #2.5-6   Pigmens' NormalRetargetfn
--  #2.7     Drying rack

-----------------------------------------------------------------
--#1 Global functions

function ReplacePrefab(original_inst, name)
    local x,y,z = original_inst.Transform:GetWorldPosition()

    local replacement_inst = SpawnPrefab(name)
    replacement_inst.Transform:SetPosition(x,y,z)
    original_inst:Remove()

    return replacement_inst
end

local function OnUpdatePlacedObjectPhysicsRadius(inst, data)
    local x, y, z = inst.Transform:GetWorldPosition()
    local mindist = math.huge
    for i, v in ipairs(TheSim:FindEntities(x, y, z, 2, { "character", "locomotor" }, { "INLIMBO" })) do
        if v.entity:IsVisible() then
            local d = v:GetDistanceSqToPoint(x, y, z)
            d = d > 0 and (v.Physics ~= nil and math.sqrt(d) - v.Physics:GetRadius() or math.sqrt(d)) or 0
            if d < mindist then
                if d <= 0 then
                    mindist = 0
                    break
                end
                mindist = d
            end
        end
    end
    local radius = math.clamp(mindist, 0, inst.physicsradiusoverride)
    if radius > 0 then
        if radius ~= data.radius then
            data.radius = radius
            inst.Physics:SetCapsule(radius, 2)
            inst.Physics:Teleport(x, y, z)
        end
        if data.ischaracterpassthrough then
            data.ischaracterpassthrough = false
            inst.Physics:CollidesWith(COLLISION.CHARACTERS)
        end
        if radius >= inst.physicsradiusoverride then
            inst._physicstask:Cancel()
            inst._physicstask = nil
        end
    end
end

function PreventCharacterCollisionsWithPlacedObjects(inst)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.ITEMS)
    --inst.Physics:CollidesWith(COLLISION.GIANTS)
    if inst._physicstask ~= nil then
        inst._physicstask:Cancel()
    end
    local data = { radius = inst.physicsradiusoverride, ischaracterpassthrough = true }
    inst._physicstask = inst:DoPeriodicTask(.5, OnUpdatePlacedObjectPhysicsRadius, nil, data)
    OnUpdatePlacedObjectPhysicsRadius(inst, data)
end

-----------------------------------------------------------------
--#2 AddPrefabPostInit

local _G = GLOBAL
local FindEntity = _G.FindEntity
local GetPlayer = _G.GetPlayer
local IsDLCEnabled = _G.IsDLCEnabled

--2.1 Add new fish tag
local function ItemIsFish(inst) inst:AddTag("fish") end
AddPrefabPostInit("eel", ItemIsFish)
AddPrefabPostInit("fish", ItemIsFish)
AddPrefabPostInit("tropical_fish", ItemIsFish)

--2.2 Add new food categories
AddPrefabPostInit("honey", function(inst) inst.components.edible.foodtype = "HONEY" end)
AddPrefabPostInit("ice", function(inst) inst.components.edible.foodtype = "ICE" end)

--2.3 Add mermkingmanager in the world
AddPrefabPostInit("cave", function(inst) inst:AddComponent("mermkingmanager") end)
AddPrefabPostInit("forest", function(inst) inst:AddComponent("mermkingmanager") end)

--2.4 Spawn mermguard in mermwatchtower
AddPrefabPostInit("mermwatchtower", function(inst) inst.components.childspawner.childname = "mermguard" end)

--2.5 Pigs target merms
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

--2.6 Royal pigguards target merms
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

--2.7 Modified drying rack
local function ModDryingRack(inst)
    --//Add drying kelp anim
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

    --//Add dried kelp anim
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

GLOBAL.CHEATS_ENABLED = true
GLOBAL.require( 'debugkeys' )