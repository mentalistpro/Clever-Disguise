name                        = "Clever Disguise"
description                 = "Disguise yourself as a merm"
author                      = "Mentalistpro"
version                     = "2.1"
forumthread                 = ""
api_version                 = 6
priorty                     = -1    --load after Mermhouse Crafting

dont_starve_compatible      = true
reign_of_giants_compatible  = true
shipwrecked_compatible      = true
hamlet_compatible           = true

icon_atlas                  = "modicon.xml"
icon                        = "modicon.tex"

configuration_options =
{
    {
    name = "mermhat_perish",
    label = "Clever Disguise perishes",
    options =   {
                    {description = "Normally", data = 6*480},
                    {description = "Slowly", data = 10*480},
                    {description = "Very Slowly", data = 15*480},
                },
    default = 6*480,
    },

    {
    name = "mermking_rate",
    label = "Generous King",
    options = {
              {description = "Normal", data = 1},
              {description = "Generous", data = 2},
              {description = "Very Generous", data = 4},
              {description = "CHARITY!", data = 8}
              },
    default = 0
    },

    {
    name = "mermguard_friends",
    label = "Friendly Guards",
    options =   {
                    {description = "YES", data = 0},
                    {description = "NO", data = 1},
                },
    default = 1,
    },

    {
    name = "merm_sanity",
    label = "Trustworthy Merms",
    options =   {
                    {description = "YES", data = 0},
                    {description = "NO", data = 1},
                },
    default = 1,
    },

    {
    name = "merm_united",
    label = "United Merms",
    options =   {
                    {description = "YES", data = 0},
                    {description = "NO", data = 1},
                },
    default = 1,
    },
}
