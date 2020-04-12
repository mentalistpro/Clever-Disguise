PrefabFiles =
{
    "merm",
    "mermhat",
    "disguisehat"
}

Assets =
{
    Asset("ATLAS", "images/inventoryimages/mermhat.xml"),      --Clever Disguise
    Asset("ATLAS", "images/inventoryimages/disguisehat.xml"),  --Shamlet Mask
}

modimport("modrecipes.lua") --mod recipes
modimport("modstrings.lua") --mod strings
modimport("modtunings.lua") --mod TUNING

-----------------------------------------------------------------

local _G = GLOBAL
local FindEntity = _G.FindEntity
local GetPlayer = _G.GetPlayer
local IsDLCEnabled = _G.IsDLCEnabled

--#1 Add new fish tag
local function ItemIsFish(inst) inst:AddTag("fish") end
AddPrefabPostInit("eel", ItemIsFish)
AddPrefabPostInit("fish", ItemIsFish)
AddPrefabPostInit("tropical_fish", ItemIsFish)

--#2 Add new food categories
AddPrefabPostInit("honey", function(inst) inst.components.edible.foodtype = "HONEY" end)
AddPrefabPostInit("ice", function(inst) inst.components.edible.foodtype = "ICE" end)

--#3 Add mermkingmanager in the world
AddPrefabPostInit("world", function(inst) inst:AddComponent("mermkingmanager") end)

--#4 Spawn mermguard in mermwatchtower
AddPrefabPostInit("mermwatchtower", function(inst) inst.components.childspawner.childname = "mermguard" end)

--#5 Pigs target merms
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

--#6 Royal pigguards target merms
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

