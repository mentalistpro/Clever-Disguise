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
    "onemanband",
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

modimport("scripts_mod/modactions.lua") --mod actions
modimport("scripts_mod/modrecipes.lua") --mod recipes
modimport("scripts_mod/modstrings.lua") --mod strings
modimport("scripts_mod/modtunings.lua") --mod TUNING

-----------------------------------------------------------------

--[[CONTENT]]
--#1 AddPrefabPostInit
--  #1.1-2   Fish, foodtype
--  #1.3     Meatrack
--  #1.4     Mermkingmanager
--  #1.5     Mermgurad
--  #1.6-7   NormalRetargetfn for pigs
--  #1.8     Onemanband

-----------------------------------------------------------------
--#1 AddPrefabPostInit

local _G = GLOBAL
local FindEntity = _G.FindEntity
local GetPlayer = _G.GetPlayer
local IsDLCEnabled = _G.IsDLCEnabled

--1.1 Add new fish tag
    local function ItemIsFish(inst) inst:AddTag("fish") end
    AddPrefabPostInit("eel", ItemIsFish)
    AddPrefabPostInit("fish", ItemIsFish)
    AddPrefabPostInit("tropical_fish", ItemIsFish)

--1.2 Add new food categories
    AddPrefabPostInit("honey", function(inst) inst.components.edible.foodtype = "HONEY" end)
    AddPrefabPostInit("ice", function(inst) inst.components.edible.foodtype = "ICE" end)

--1.3 Modified drying rack
    local function ModifiedDryingRack(inst)
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

    AddPrefabPostInit("meatrack", ModifiedDryingRack)

--1.4 Add mermkingmanager in the world
    AddPrefabPostInit("cave", function(inst) inst:AddComponent("mermkingmanager") end)          --DLC001
    AddPrefabPostInit("forest", function(inst) inst:AddComponent("mermkingmanager") end)        --DLC001
    AddPrefabPostInit("shipwrecked", function(inst) inst:AddComponent("mermkingmanager") end)   --DLC002
    AddPrefabPostInit("volcanolevel", function(inst) inst:AddComponent("mermkingmanager") end)  --DLC002
    AddPrefabPostInit("porkland", function(inst) inst:AddComponent("mermkingmanager") end)      --DLC003
    --//TODO: Missing SW, HAM prefabs volcano, pig city, sea

--1.5 Spawn mermguard in mermwatchtower
    AddPrefabPostInit("mermwatchtower", function(inst) inst.components.childspawner.childname = "mermguard" end)

--1.6 Pigs target merms
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

--1.7 Royal pigguards target merms
    if IsDLCEnabled and IsDLCEnabled(3) then
        local function NormalRetargetFn_royal(inst)
            return FindEntity(inst, TUNING.CITY_PIG_GUARD_TARGET_DIST, function(guy)
                if not guy.LightWatcher or guy.LightWatcher:IsInLight() then
                    if guy == GetPlayer() and inst:HasTag("angry_at_player") and guy.components.health
                     and not guy.components.health:IsDead() and inst.components.combat:CanTarget(guy)
                     and inst.components.combat.target ~= GetPlayer() then
                        inst.sayline(inst, _G.getSpeechType(inst,STRINGS.CITY_PIG_GUARD_TALK_ANGRY_PLAYER))
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

--1.8 One man band attracts merms
    --Directly replace prefabs/onemandband.lua


