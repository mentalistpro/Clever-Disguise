local assets = 
{ 
    Asset("ANIM", "anim/hat_merm.zip"),
}

-----------------------------------------------------------------------------------------

--[[CONTENT]]
--#1 OnEquip
--#2 OnUnequip
--#3 fn()

-----------------------------------------------------------------------------------------
--#1 OnEquip

local function OnEquip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_hat", "hat_merm", "swap_hat")
    owner.AnimState:Show("HAT")
    owner.AnimState:Hide("HAIR_HAT")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")
    
    if owner:HasTag("player") then
        owner.AnimState:Show("HEAD")
        owner.AnimState:Hide("HEAD_HAIR")
    end
    
    --If worn, you are a merm
    if (owner:HasTag("player") or owner:HasTag("pig") ) and not owner:HasTag("merm")  then
        owner:AddTag("merm")
        owner:AddTag("mermdisguise")
    end 
    
    --Monsters are not monsters
    if owner:HasTag("monster") then
        owner:RemoveTag("monster")
        owner:AddTag("unmonster")     
    end
    
    --Friendly pigs and spiders no longer follow when disguise is on.
    if owner.components.leader then
        owner.components.leader:RemoveFollowersByTag("pig")
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
    end

    if owner:HasTag("mermdisguise") then
        owner:RemoveTag("merm")
        owner:RemoveTag("mermdisguise")
    end

    if owner:HasTag("unmonster") then
        owner:RemoveTag("unmonster")
        owner:AddTag("monster")       
    end
    
    --Friendly merms no longer follow when disguise is off.
    if owner.components.leader then
        owner.components.leader:RemoveFollowersByTag("merm")
    end
end

-----------------------------------------------------------------------------------------
--#3 fn()
    
local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("mermhat") --syname (tex file)
    inst.AnimState:SetBuild("hat_merm") --fname (zip file under /anim)
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("disguise")
    inst:AddTag("hat")
    inst:AddTag("merm")
    inst:AddTag("show_spoilage")
    
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
    inst.components.equippable.dapperness = 0
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/mermhat.xml"
    
    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.MERMHAT_PERISH)
    inst.components.perishable:StartPerishing()
    inst.components.perishable:SetOnPerishFn(inst.Remove)
    
    inst:AddComponent("inspectable")
    inst:AddComponent("tradable")
    
    return inst
end

return  Prefab("common/inventory/mermhat", fn, assets)
