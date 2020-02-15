local assets =
{
    Asset("ANIM", "anim/merm_king_carpet.zip"),
    Asset("ANIM", "anim/merm_king_carpet_construction.zip")
}

local prefabs =
{
    "mermthrone",
    "mermking"
}

local function OnConstructed(inst, doer)
    local concluded = true
    for i, v in ipairs(CONSTRUCTION_PLANS[inst.prefab] or {}) do
        if inst.components.constructionsite:GetMaterialCount(v.type) < v.amount then
            concluded = false
            break
        end
    end

    if concluded then
        local new_throne = ReplacePrefab(inst, "mermthrone")
        GetWorld():PushEvent("onthronebuilt", {throne = new_throne})
        new_throne.SoundEmitter:PlaySound("dontstarve/characters/wurt/merm/throne/build")
    end
end

local function ondeconstruct_common(inst)
    GetWorld():PushEvent("onthronedestroyed", {throne = inst})
end

local function onburnt_common(inst)
    GetWorld():PushEvent("onthronedestroyed", {throne = inst})
end

local function onhammered_common(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    inst.components.lootdropper:DropLoot()
    SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function onhammered_construction(inst, worker)
    onhammered_common(inst, worker)
    inst:Remove()
end

local function onhammered_regular(inst, worker)
    onhammered_common(inst, worker)
    GetWorld():PushEvent("onthronedestroyed", {throne = inst})
    inst:Remove()
end

local function onhit_construction(inst, worker)
     if not inst:HasTag("burnt") then
         inst.AnimState:PlayAnimation("hit")
         inst.AnimState:PushAnimation("idle", true)
     end
end

local function onconstruction_built(inst)
    PreventCharacterCollisionsWithPlacedObjects(inst)
    inst.SoundEmitter:PlaySound("dontstarve/characters/wurt/merm/throne/place")
end

local function onsave(inst, data)
    if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        data.burnt = true
    end
end

local function onload(inst, data)
    if data ~= nil and data.burnt then
        inst.components.burnable.onburnt(inst)
    end
end

local function construction_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()

    inst.Transform:SetScale(0.9, 0.9, 0.9)

    inst.MiniMapEntity:SetIcon("merm_king_carpet_construction.tex")
    inst:AddTag("constructionsite")

    inst:SetPhysicsRadiusOverride(1.5)
    MakeObstaclePhysics(inst, inst.physicsradiusoverride)

    MakeHauntableWork(inst)
    MakeLargeBurnable(inst, nil, nil, true)
    MakeMediumPropagator(inst)

    inst.AnimState:SetBank("merm_king_carpet_construction")
    inst.AnimState:SetBuild("merm_king_carpet_construction")
    inst.AnimState:PlayAnimation("idle", true)

    inst:AddComponent("constructionsite")
    inst.components.constructionsite:SetConstructionPrefab("construction_container")
    inst.components.constructionsite:SetOnConstructedFn(OnConstructed)

    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered_construction)
    inst.components.workable:SetOnWorkCallback(onhit_construction)

    inst:ListenForEvent("onbuilt", onconstruction_built)

    inst.OnSave = onsave
    inst.OnLoad = onload

    return inst
end

local function OnMermKingCreated(inst, data)
    if data and data.throne == inst then
        inst.components.workable:SetWorkable(false)
        
        inst:RemoveComponent("propagator")
        inst:RemoveComponent("burnable")
        
        inst.MiniMapEntity:SetIcon("merm_king_carpet_occupied.tex")
    end
end

local function OnMermKingDestroyed(inst, data)
    if data and data.throne == inst then
        
        if inst.components.workable then
            inst.components.workable:SetWorkable(true)
        end

        MakeLargeBurnable(inst, nil, nil, true)
        MakeMediumPropagator(inst)

        if inst.components.burnable then
            inst.components.burnable.canlight = true
        end
        inst.MiniMapEntity:SetIcon("merm_king_carpet.png")
    end
end

-- This exists in case the throne gets removed some way other than hammering
local function OnThroneRemoved(inst)
    if GetWorld().components.mermkingmanager and GetWorld().components.mermkingmanager:IsThrone(inst) then
        GetWorld():PushEvent("onthronedestroyed", {throne = inst})
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()

    inst.Transform:SetScale(0.9, 0.9, 0.9)

    inst.MiniMapEntity:SetIcon("merm_king_carpet.tex")

    inst.AnimState:SetBank("merm_king_carpet")
    inst.AnimState:SetBuild("merm_king_carpet")
    inst.AnimState:PlayAnimation("idle", true)

    inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
    inst.AnimState:SetLayer( LAYER_BACKGROUND )
    inst.AnimState:SetSortOrder( 3 )

    inst:AddTag("mermthrone")

    inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered_regular)

    MakeHauntableWork(inst)
    MakeLargeBurnable(inst, nil, nil, true)
    MakeMediumPropagator(inst)

    inst:ListenForEvent("onburnt", onburnt_common)
    inst:ListenForEvent("ondeconstructstructure", ondeconstruct_common)
    inst:ListenForEvent("onmermkingcreated",   function (world, data) OnMermKingCreated(inst, data)   end, GetWorld())
    inst:ListenForEvent("onmermkingdestroyed", function (world, data) OnMermKingDestroyed(inst, data) end, GetWorld())
    inst:ListenForEvent("onremove", OnThroneRemoved)

    inst:DoTaskInTime(0, function()
        if GetWorld().components.mermkingmanager and GetWorld().components.mermkingmanager:HasKing() then
            OnMermKingCreated(inst, {throne = GetWorld().components.mermkingmanager:GetMainThrone() })
        end
    end)

    inst.OnSave = onsave
    inst.OnLoad = onload

    return inst
end

local function invalid_placement_fn(player, placer)
    if placer and placer.mouse_blocked then
        return
    end

    if player and player.components.talker then
        player.components.talker:Say(GetString(player, "ANNOUNCE_CANTBUILDHERE_THRONE"))
    end
end

return  Prefab("mermthrone", fn, assets, prefabs),
        Prefab("mermthrone_construction", construction_fn, assets, prefabs),
        MakePlacer("mermthrone_construction_placer", "merm_king_carpet_construction", "merm_king_carpet_construction", "idle", nil, nil, nil, nil, nil, nil, nil, nil, invalid_placement_fn)