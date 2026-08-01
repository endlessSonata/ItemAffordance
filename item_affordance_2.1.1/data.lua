require("prototypes.globals")
require("prototypes.data.component-order-lookup")
require("prototypes.data.pipette-data")
require("prototypes.data.reclaim-data")

if not DATA_UPDATE_DELAY and not DATA_FINAL_DELAY then
    require("prototypes.stages.data")
end

