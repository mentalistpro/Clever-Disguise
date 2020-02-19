local assets = 
{ 
    Asset("ANIM", "anim/hat_merm.zip"),
}

-----------------------------------------------------------------------------------------
-- Equipped

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
    
    --Characters and pigs are now merms
    if (owner:HasTag("player") or owner:HasTag("pig")) and not owner:HasTag("merm") then
      owner:AddTag("temporary_merm")
      owner:AddTag("merm")
      owner:AddTag("mermguard")
      owner:AddTag("mermfluent")  --//TODO: remove soon - need new tool to interpret merm language.  
    end 
    
    --Monsters are not monsters
    if owner:HasTag("monster") then
      owner:RemoveTag("monster")
      owner:AddTag("unmonster")     
    end
    
    if owner:HasTag("playermonster") then
      owner:RemoveTag("playermonster")
      owner:AddTag("unplayermonster")   
    end
    
    --Spiders are not spiders   
    if owner:HasTag("spiderwhisperer") then
      owner:RemoveTag("spiderwhisperer")
      owner:AddTag("unspiderwhisperer") 
    end
    
    --Royal pigs are not royal pigs
    if owner:HasTag("pigroyalty") then
      owner:RemoveTag("pigroyalty")
      owner:AddTag("unpigroyalty")  
    end
	
    --Friendly pigs no longer follow when disguise is on.
    if owner.components.leader then
      owner.components.leader: RemoveFollowersByTag ("pig")
    end	
end

-----------------------------------------------------------------------------------------
-- Unequipped

local function OnUnequip(inst, owner)
    owner.AnimState:Hide("HAT")
    owner.AnimState:Hide("HAIR_HAT")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")
    if owner:HasTag("player") then
      owner.AnimState:Show("HEAD")
      owner.AnimState:Hide("HEAD_HAIR")
    end

    if owner:HasTag("temporary_merm") then
      owner:RemoveTag("merm")
      owner:RemoveTag("mermguard")
      owner:RemoveTag("mermfluent") 
    end

    if owner:HasTag("unmonster") then
      owner:RemoveTag("unmonster")
      owner:AddTag("monster")       
    end
    
    if owner:HasTag("unplayermonster") then
      owner:RemoveTag("unplayermonster")
      owner:AddTag("playermonster") 
    end
    
    if owner:HasTag("unspiderwhisperer") then
      owner:RemoveTag("unspiderwhisperer")
      owner:AddTag("spiderwhisperer")   
    end
    
    if owner:HasTag("unpigroyalty") then
      owner:RemoveTag("unpigroyalty")
      owner:AddTag("pigroyalty")    
    end
    
    --Friendly merms no longer follow when disguise is off.
    if owner.components.leader then
      owner.components.leader: RemoveFollowersByTag ("merm")
    end
end

-----------------------------------------------------------------------------------------
    
local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("mermhat") --syname (tex file)
    inst.AnimState:SetBuild("hat_merm") --fname (zip file under /anim)
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("hat")
    inst:AddTag("open_top_hat")
    inst:AddTag("show_spoilage")
    inst:AddTag("merm")
    
    inst:AddComponent("inspectable")
    inst:AddComponent("tradable")
    
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
    inst.components.equippable.dapperness = 0
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/mermhat.xml"
    
    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.MOD_MERMHAT_PERISH)
    inst.components.perishable:StartPerishing()
    inst.components.perishable:SetOnPerishFn(inst.Remove)
    
    return inst
end

return  Prefab("common/inventory/mermhat", fn, assets)
