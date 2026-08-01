local componentUtil = require("component-util")

if not settings.startup["belt-components"].value then
    return
end

local BASE = {{}}
local LEFT_RIGHT = {
    {postfix = "-left"},
    {postfix = "-right"}
}

componentUtil.attachComponentToTile("hazard-concrete", "concrete", 1, LEFT_RIGHT)
componentUtil.attachComponentToTile("refined-hazard-concrete", "refined-concrete", 1, LEFT_RIGHT)

if mods["Dectorio"] then
    componentUtil.attachComponentToTile("dect-concrete-grid", "concrete", 1, BASE)

    for _, value in ipairs({"deepwater", "water-green", "deepwater-green"}) do
        componentUtil.attachComponentToTile({item_name = "dect-base-" .. value, entity_name = value}, "dect-base-water", 1, BASE)
    end

    for _, value in ipairs({"danger", "emergency", "caution", "radiation", "defect", "operations", "safety"}) do
        componentUtil.attachComponentToTile("dect-paint-" .. value, "concrete", 1, LEFT_RIGHT)
        componentUtil.attachComponentToTile("dect-paint-refined-" .. value, "refined-concrete", 1, LEFT_RIGHT)
    end

    for _, value in ipairs({"red", "green", "blue", "orange", "yellow", "pink", "purple", "black", "brown", "cyan", "acid"}) do
        componentUtil.attachComponentToTile({item_name = "dect-" .. value .. "-refined-concrete", entity_name = value .. "-refined-concrete"}, "refined-concrete", 1, BASE)
    end

    for i = 2, 7, 1 do
        componentUtil.attachComponentToTile("dect-base-dirt-" .. i, "dect-base-dirt-1", 1, BASE)
    end
    for i = 1, 3, 1 do
        componentUtil.attachComponentToTile("dect-base-sand-" .. i, "dect-base-dirt-1", 1, BASE)
    end
    for i = 1, 4, 1 do
        componentUtil.attachComponentToTile("dect-base-grass-" .. i, "dect-base-dirt-1", 1, BASE)
    end
    for i = 0, 3, 1 do
        componentUtil.attachComponentToTile("dect-base-red-desert-" .. i, "dect-base-dirt-1", 1, BASE)
    end
    componentUtil.attachComponentToTile("dect-base-dry-dirt", "dect-base-dirt-1", 1, BASE)
end