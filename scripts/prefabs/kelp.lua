local assets=
{
	Asset("ANIM", "anim/kelp.zip"),
	Asset("ANIM", "anim/meat_rack_kelp.zip")
}


local prefabs = 
{
	"kelp",
    "kelp_cooked",
    "kelp_dried",
}

local function ondropped(inst)
    local pt = inst:GetPosition()
    local ground = GetWorld()
    local tile = GROUND.GRASS
    if ground and ground.Map then
        tile = ground.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
    end

    local onWater = ground.Map:IsWater(tile)
    if onWater then 
        inst.AnimState:PlayAnimation("idle_water", true)
    else 
        inst.AnimState:PlayAnimation("idle", true)
    end 
end

local function onhitwater(inst)
	if inst.components.blowinwind == nil then
		return
	end
	inst.AnimState:PlayAnimation("idle_water", true)
	inst.components.blowinwind:SetMaxSpeedMult(TUNING.WINDBLOWN_SCALE_MAX.MEDIUM)
	inst.components.blowinwind:SetMinSpeedMult(TUNING.WINDBLOWN_SCALE_MIN.MEDIUM)
end

local function onhitland(inst)
	if inst.components.blowinwind == nil then
		return
	end
	inst.AnimState:PlayAnimation("idle", true)
	inst.components.blowinwind:SetMaxSpeedMult(TUNING.WINDBLOWN_SCALE_MAX.LIGHT)
	inst.components.blowinwind:SetMinSpeedMult(TUNING.WINDBLOWN_SCALE_MIN.LIGHT)
end

local function commonfn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	
	MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("kelp")
    inst.AnimState:SetBuild("kelp")
    inst.AnimState:SetRayTestOnBB(true)
    
    inst.AnimState:SetLayer( LAYER_BACKGROUND )
    inst.AnimState:SetSortOrder( 3 )

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "VEGGIE"
       
    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"
	
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inventoryitem")
    inst:AddComponent("inspectable")
	if IsDLCEnabled and ( IsDLCEnabled(1) or IsDLCEnabled(2) or IsDLCEnabled(3) ) then
		inst:AddComponent("waterproofer")
	end
    
    return inst
end

local function defaultfn(sim)

    local inst = commonfn(sim)
    inst.components.edible.healthvalue = TUNING.HEALING_TINY
    inst.components.edible.hungervalue = TUNING.CALORIES_TINY
    inst.components.edible.sanityvalue = -TUNING.SANITY_SMALL
    inst.components.inventoryitem.atlasname = "images/inventoryimages/kelp.xml"
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)

    inst:AddComponent("cookable")
    inst.components.cookable.product = "kelp_cooked"

    inst:AddComponent("dryable")
    inst.components.dryable:SetProduct("kelp_dried")
    inst.components.dryable:SetDryTime(TUNING.DRY_FAST)
    inst.AnimState:PlayAnimation("idle", true)

	if IsDLCEnabled and ( IsDLCEnabled(2) or IsDLCEnabled(3) ) then
		MakeBlowInHurricane(inst, TUNING.WINDBLOWN_SCALE_MIN.MEDIUM, TUNING.WINDBLOWN_SCALE_MAX.MEDIUM)
		MakeInventoryFloatable(inst, "idle_water", "idle") -- < this replaces the symbols for the ripple, so you still need it.
		inst.components.floatable:SetOnHitWaterFn(onhitwater)
		inst.components.floatable:SetOnHitLandFn(onhitland)
	end

    inst:AddComponent("fertilizer")
    inst.components.fertilizer.fertilizervalue = TUNING.POOP_FERTILIZE
    inst.components.fertilizer.soil_cycles = TUNING.POOP_SOILCYCLES
    inst.components.fertilizer.withered_cycles = TUNING.POOP_WITHEREDCYCLES
	if IsDLCEnabled and ( IsDLCEnabled(2) or IsDLCEnabled(3) ) then
	    inst.components.fertilizer.oceanic = true
	end
	
    return inst
end 


local function cookedfn(sim)
    local inst = commonfn(sim)
    inst.components.edible.foodstate = "COOKED"
    inst.components.edible.healthvalue = TUNING.HEALING_SMALL
    inst.components.edible.hungervalue = TUNING.CALORIES_TINY
    inst.components.edible.sanityvalue = 0--TUNING.SANITY_SMALL
    inst.components.inventoryitem.atlasname = "images/inventoryimages/kelp_cooked.xml"
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
    inst.AnimState:PlayAnimation("cooked", true)
	
	if IsDLCEnabled and ( IsDLCEnabled(2) or IsDLCEnabled(3) ) then
	    MakeInventoryFloatable(inst, "cooked_water", "cooked")
	end
	
    return inst
end 

local function driedfn(sim)
    local inst = commonfn(sim)
    inst.components.edible.foodstate = "DRIED"
    inst.components.edible.healthvalue = TUNING.HEALING_SMALL
    inst.components.edible.hungervalue = TUNING.CALORIES_SMALL
    inst.components.edible.sanityvalue = 0
    inst.components.inventoryitem.atlasname = "images/inventoryimages/kelp_dried.xml"
    inst.components.perishable:SetPerishTime(TUNING.PERISH_PRESERVED)
    inst.AnimState:SetBank("meat_rack_kelp")
    inst.AnimState:SetBuild("meat_rack_kelp")
    inst.AnimState:PlayAnimation("dried_kelp", true)
	
	if IsDLCEnabled and ( IsDLCEnabled(2) or IsDLCEnabled(3) ) then
		MakeInventoryFloatable(inst, "idle_dried_kelp_water", "dried_kelp")
    end
	
    return inst
end 

return Prefab( "common/inventory/kelp", defaultfn, assets, prefabs), 
       Prefab( "common/inventory/kelp_cooked", cookedfn, assets), 
       Prefab( "common/inventory/kelp_dried", driedfn, assets)