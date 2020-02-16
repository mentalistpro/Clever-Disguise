name                        = "Merm King"
author                      = "mentalistpro"
version                     = "0.1"
description                 = "Make Merms Great Again!?!?"
forumthread                 = ""
api_version                 = 6
priority                    = -2    --load after Mermhouse Crafting and Clever Disguise

dont_starve_compatible      = true
reign_of_giants_compatible  = true
shipwrecked_compatible      = true
hamlet_compatible           = true

icon_atlas                  = "modicon.xml"
icon                        = "modicon.tex"

configuration_options = {
    {
    name = "exchange_rate", 
    label = "Exchange rate",
    options = {
              {description = "Less", data = 0},
              {description = "Normal", data = 1},
              {description = "More", data = 2},
              {description = "Plenty", data = 3}
              },
    default = 0
    }
}