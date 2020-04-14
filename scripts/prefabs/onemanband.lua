local assets =
{
    Asset("ANIM", "anim/armor_onemanband.zip"),
    Asset("ANIM", "anim/swap_one_man_band.zip"),
}

local function band_disable(inst)
    if inst.updatetask then
        inst.updatetask:Cancel()
        inst.updatetask = nil
    end
end

local function CalcDapperness(inst, owner)
    return -TUNING.DAPPERNESS_SMALL -(owner.components.leader:CountFollowers() * TUNING.SANITYAURA_SMALL)
end

local banddt = 1
local function band_update(inst)
    local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
    if owner and owner.components.leader then
        local x,y,z = owner.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x,y,z, 12, nil, {"werepig"}, {"pig", "merm"})

        for k,v in pairs(ents) do
            if v.components.follower and not v.components.follower.leader
                and not owner.components.leader:IsFollower(v) and owner.components.leader.numfollowers < 10 then

                if v:HasTag("merm") then
                    if v:HasTag("mermguard") then
                        if owner:HasTag("merm") and not owner:HasTag("mermdisguise") and TUNING.MERMGUARD_BEFRIENDABLE == 0 then
                            owner.components.leader:AddFollower(v)
                        end
                    else
                        if owner:HasTag("merm") or (GetWorld().components.mermkingmanager and GetWorld().components.mermkingmanager:HasKing()) then
                            owner.components.leader:AddFollower(v)
                        end
                    end
                else
                    owner.components.leader:AddFollower(v)
                end
            end
        end

        for k,v in pairs(owner.components.leader.followers) do
            if k.components.follower then
                if k:HasTag("pig") then
                    k.components.follower:AddLoyaltyTime(3)

                elseif k:HasTag("merm") then
                    if k:HasTag("mermguard") then
                        if owner:HasTag("merm") and not owner:HasTag("mermdisguise") and TUNING.MERMGUARD_BEFRIENDABLE == 0 then
                            k.components.follower:AddLoyaltyTime(3)
                        end
                    else
                        if owner:HasTag("merm") or (GetWorld().components.mermkingmanager and GetWorld().components.mermkingmanager:HasKing()) then
                            k.components.follower:AddLoyaltyTime(3)
                        end
                    end
                end
            end
        end
    end
end

local function band_enable( inst )
    inst.updatetask = inst:DoPeriodicTask(banddt, band_update, 1)
end

local function band_perish( inst )
    band_disable(inst)
    inst:Remove()
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "swap_one_man_band", "swap_body")
    inst.components.fueled:StartConsuming()
    band_enable(inst)
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst.components.fueled:StopConsuming()
    band_disable(inst)
end

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)

    inst:AddTag("band")

    inst.AnimState:SetBank("onemanband")
    inst.AnimState:SetBuild("armor_onemanband")
    inst.AnimState:PlayAnimation("anim")


    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.foleysound = "dontstarve/wilson/onemanband"

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = "ONEMANBAND"
    inst.components.fueled:InitializeFuelLevel(TUNING.ONEMANBAND_PERISHTIME)
    inst.components.fueled:SetDepletedFn(band_perish)

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable.dapperfn = CalcDapperness

    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )

    return inst
end

return Prefab("common/inventory/onemanband", fn, assets)
