require("prototypes.data.rebalance-belt-costs").data_rebalance()
require("prototypes.data.component-logistic-container-updates")
require("prototypes.data.component-pipe-updates").data()
if mods["elevated-rails"] then
    require("prototypes.data.component-rail-updates").data()
end
require("prototypes.data.component-simple-updates").data()