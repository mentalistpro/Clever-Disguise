local assets =
{
    Asset("ANIM", "anim/merm_king_carpet.zip"),
    Asset("ANIM", "anim/merm_king_carpet_construction.zip"),
    Asset("ANIM", "anim/ui_construction_4x1.zip"),
}

local prefabs =
{
    "mermthrone",
    "mermking"
}

------------------------------------------------------------------------------------

--//CONTENT//
--#1 Physical properties
--#2 Container
--#3 Mermthrone_constuction_fn()
--#4 Mermking
--#5 Mermthrone_fn()

------------------------------------------------------------------------------------
--#1 Physical properties

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
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.ITEMS)
    inst.SoundEmitter:PlaySound("dontstarve/characters/wurt/merm/throne/place")
end

------------------------------------------------------------------------------------
--#2 Container

local slotpos = {}

for x = -1.5, 1.5, 1 do
    table.insert(slotpos, Vector3(x * 110, 8, 0))
end

local function itemtest(inst, item, slot)
    local doer = inst.entity:GetParent()
    return doer ~= nil
        and doer.components.constructionbuilder ~= nil
        and doer.components.constructionbuilder:GetIngredientForSlot(slot) == item.prefab
end

local widgetbuttoninfo = {
    text = STRINGS.ACTIONS.APPLYCONSTRUCTION,
    position =  Vector3(0, -94, 0),
    fn = function(inst)
        if inst.components.container ~= nil then
            BufferedAction(inst.components.container.opener, inst, ACTIONS.APPLYCONSTRUCTION):Do()
        end
    end,
    validfn = function(inst)
        return inst.components.container ~= nil and not inst.components.container:IsEmpty()
    end
}

------------------------------------------------------------------------------------
--#3 Mermthrone_constuction fn()

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

    MakeObstaclePhysics(inst, 1.5)

    MakeLargeBurnable(inst, nil, nil, true)
    MakeMediumPropagator(inst)

    inst.AnimState:SetBank("merm_king_carpet_construction")
    inst.AnimState:SetBuild("merm_king_carpet_construction")
    inst.AnimState:PlayAnimation("idle", true)

    inst:AddComponent("container")
    inst.components.container:SetNumSlots(#slotpos)
    inst.components.container.widgetslotpos = slotpos
    inst.components.container.widgetanimbank = "ui_construction_4x1"
    inst.components.container.widgetanimbuild = "ui_construction_4x1"
    inst.components.container.widgetpos = Vector3(300, 0, 0)
    inst.components.container.itemtestfn = itemtest
    inst.components.container.side_align_tip = 50
    inst.components.container.type = "cooker"
    inst.components.container.widgetbuttoninfo = widgetbuttoninfo
    inst.components.container.top_align_tip = 50

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

-----------------------------------------------------------------------------------------------------------------------------------
--#4 Mermking

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

-----------------------------------------------------------------------------------------------------------------------------------
--#5 Mermthrone_fn()

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

return  Prefab("mermthrone", fn, assets, prefabs),
        Prefab("mermthrone_construction", construction_fn, assets, prefabs),
        MakePlacer("mermthrone_construction_placer", "merm_king_carpet_construction", "merm_king_carpet_construction", "idle")