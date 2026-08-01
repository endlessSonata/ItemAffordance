require("prototypes.data.component-belt-updates")
require("prototypes.data.rebalance-belt-costs").data_updates_rebalance()
require("prototypes.data.component-pipe-updates").data_updates()
if mods["elevated-rails"] then
    require("prototypes.data.component-rail-updates").data_updates()
end
require("prototypes.data.component-simple-updates").data_updates()
require("prototypes.data.component-bob-machine-updates")
require("prototypes.data.component-tile-updates")