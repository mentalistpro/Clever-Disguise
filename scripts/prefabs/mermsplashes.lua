local assets =
{
    Asset("ANIM", "anim/merm_king_splash.zip"),
    Asset("ANIM", "anim/merm_spawn_fx.zip"),
    Asset("ANIM", "anim/merm_splash.zip")
}

local prefabs =
{
    "merm_king_splash",
    "merm_spawn_fx",
    "merm_splash"
}

local function MakeSplash (name, postinit)
    local function fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()

        inst.AnimState:SetFinalOffset(1)

        inst:AddTag("NOCLICK")
        inst:AddTag("wet")

        return inst
    end

    return Prefab("common/objects/"..name, fn, assets, prefabs)
end

local function merm_king_splash_postinit(inst)
    inst.AnimState:SetBank("merm_king_splash")
    inst.AnimState:SetBuild("merm_king_splash")
    inst.AnimState:PlayAnimation("merm_king_splash")
end

local function merm_spawn_fx_postinit(inst)
    inst.AnimState:SetBank("merm_spawn_fx")
    inst.AnimState:SetBuild("merm_spawn_fx")
    inst.AnimState:PlayAnimation("splash")
end

local function merm_splash_postinit(inst)
    inst.AnimState:SetBank("merm_splash")
    inst.AnimState:SetBuild("merm_splash")
    inst.AnimState:PlayAnimation("merm_splash")
end

return  MakeSplash("merm_king_splash", merm_king_splash_postinit),
        MakeSplash("merm_spawn_fx", merm_spawn_fx_postinit),
        MakeSplash("merm_splash", merm_splash_postinit)
