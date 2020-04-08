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
    name = "perish",
    label = "Perishability",
    options =   {
                    {description = "Default (Fast)", data = 6*480},
                    {description = "Medium", data = 10*480},
                    {description = "Slow", data = 15*480},
                },
    default = 6*480,
    }
}
