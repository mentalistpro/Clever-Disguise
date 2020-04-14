local assets =
{
    Asset("ANIM", "anim/hat_disguise_2.zip"),
}

-----------------------------------------------------------------------------------------
--#1 OnEquip

local function OnEquip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_hat", "hat_disguise", "swap_hat")
    owner.AnimState:Show("HAT")
    owner.AnimState:Hide("HAIR_HAT")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")
    owner.AnimState:Show("HAIRFRONT")
    owner.AnimState:Show("HEAD")
    owner.AnimState:Hide("HEAD_HAIR")

    if owner:HasTag("monster") then
        owner:RemoveTag("monster")
        owner:AddTag("unmonster")
    end

    if owner:HasTag("merm") then
        owner:RemoveTag("merm")
        owner:AddTag("unmerm")
    end

    --Merms and spiders don't recognise you when you wear shamlet mask
    if owner.components.leader then
        owner.components.leader:RemoveFollowersByTag("merm")
        owner.components.leader:RemoveFollowersByTag("spider")
    end
end

-----------------------------------------------------------------------------------------
--#2 OnUnequip

local function OnUnequip(inst, owner)
    owner.AnimState:Hide("HAT")
    owner.AnimState:Hide("HAIR_HAT")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Show("HEAD")
        owner.AnimState:Hide("HEAD_HAIR")
        owner.AnimState:Show("HAIRFRONT")
    end

    if owner:HasTag("unmonster") then
        owner:RemoveTag("unmonster")
        owner:AddTag("monster")
    end

    if owner:HasTag("unmerm") then
        owner:RemoveTag("unmerm")
        owner:AddTag("merm")
    end

    --Pigs feel cheated when you remove shamlet mask.
    if owner.components.leader then
        owner.components.leader:RemoveFollowersByTag("pig")
    end
end

-----------------------------------------------------------------------------------------
--#3 fn()

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("disguisehat") --syname (tex file)
    inst.AnimState:SetBuild("hat_disguise_2") --fname (zip file under /anim)
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("disguise")
    inst:AddTag("hat")
    inst:AddTag("pigman")

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
    inst.opentop = true

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/disguisehat.xml"

    inst:AddComponent("inspectable")
    inst:AddComponent("tradable")

    return inst
end

return  Prefab("common/inventory/disguisehat", fn, assets)
