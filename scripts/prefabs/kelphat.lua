local assets = 
{ 
    Asset("ANIM", "anim/hat_kelp.zip"),
}

-----------------------------------------------------------------------------------------

local function OnEquip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_hat", "hat_kelp", "swap_hat")
	owner.AnimState:Show("HAT")
	owner.AnimState:Hide("HAIR_HAT")
	owner.AnimState:Show("HAIR_NOHAT")
	owner.AnimState:Show("HAIR")
	if owner:HasTag("player") then
	  owner.AnimState:Show("HEAD")
	  owner.AnimState:Hide("HEAD_HAIR")
	end
end

local function OnUnequip(inst, owner)
	owner.AnimState:Hide("HAT")
	owner.AnimState:Hide("HAIR_HAT")
	owner.AnimState:Show("HAIR_NOHAT")
	owner.AnimState:Show("HAIR")
	if owner:HasTag("player") then
	  owner.AnimState:Show("HEAD")
	  owner.AnimState:Hide("HEAD_HAIR")
    end
end

-----------------------------------------------------------------------------------------
    
local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	
	MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("kelphat") --syname (tex file)
    inst.AnimState:SetBuild("hat_kelp") --fname (zip file under /anim)
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("hat")
	inst:AddTag("show_spoilage")
	inst:AddTag("wet")
		
	inst:AddComponent("dapperness")
	inst.components.dapperness.dapperness = TUNING.DAPPERNESS_TINY
	
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
	
	if IsDLCEnabled and ( IsDLCEnabled(1) or IsDLCEnabled(2) or IsDLCEnabled(3) ) then
		inst:AddComponent("insulator")
		inst.components.insulator:SetSummer()
		inst.components.insulator:SetInsulation(TUNING.INSULATION_SMALL)
	end
		
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/kelphat.xml"

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable:SetOnPerishFn(inst.Remove)
	
    inst:AddComponent("inspectable")
    inst:AddComponent("tradable")
	
    return inst
end

return  Prefab("common/inventory/kelphat", fn, assets)
