require("prototypes.globals")
require("prototypes.data.component-order-lookup")

if DATA_UPDATE_DELAY and not DATA_FINAL_DELAY then
    require("prototypes.stages.data")
end

if not DATA_FINAL_DELAY then
    require("prototypes.stages.data-updates")
end