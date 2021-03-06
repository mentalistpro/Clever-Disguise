local _G = GLOBAL
local IsDLCEnabled = _G.IsDLCEnabled
local Ingredient = _G.Ingredient
local Recipe = _G.Recipe
local RECIPETABS = _G.RECIPETABS
local TECH = _G.TECH

--Pighat
local disguisehat = Recipe(
    "disguisehat",
    {
        Ingredient("twigs", 2),
        Ingredient("pigskin", 1),
        Ingredient("beardhair", 1)
    },
    RECIPETABS.DRESS, TECH.NONE)

    if IsDLCEnabled and ( IsDLCEnabled(1) or IsDLCEnabled(2) or IsDLCEnabled(3) ) then
        disguisehat.game_type = "common"
    end
    disguisehat.atlas = "images/inventoryimages/disguisehat.xml"
    disguisehat.sortkey = 2

--Mermhat
if IsDLCEnabled and ( IsDLCEnabled(2) or IsDLCEnabled(3) ) then
    local mermhat = Recipe(
        "mermhat",
        {
            Ingredient("tropical_fish", 1),
            Ingredient("cutreeds", 1),
            Ingredient("twigs", 2)
        },
        RECIPETABS.DRESS, TECH.NONE, "shipwrecked")
        mermhat.atlas = "images/inventoryimages/mermhat.xml"
        mermhat.sortkey = 1
end

local mermhat = Recipe(
    "mermhat",
    {
        Ingredient("fish", 1),
        Ingredient("cutreeds", 1),
        Ingredient("twigs", 2)
    },
    RECIPETABS.DRESS, TECH.NONE)
    mermhat.atlas = "images/inventoryimages/mermhat.xml"
    mermhat.sortkey = 1

--Mermthrone_construction
local mermthrone_construction = Recipe(
    "mermthrone_construction",
    {
    Ingredient("boards", 5),
    Ingredient("rope", 5),
    },
    RECIPETABS.TOWN, TECH.SCIENCE_ONE)
    mermthrone_construction.placer = "mermthrone_construction_placer"
    mermthrone_construction.atlas = "images/inventoryimages/mermthrone_construction.xml"


---------------------------------------------------------------------

CONSTRUCTION_PLANS =
{
    ["mermthrone_construction"] = { Ingredient("kelp", 20), Ingredient("pigskin", 10), Ingredient("beefalowool", 15) },
}

