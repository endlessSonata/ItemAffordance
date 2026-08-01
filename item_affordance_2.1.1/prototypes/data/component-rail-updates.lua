local componentUtil = require("component-util")

local elevatedSetting = settings.startup["elevated-rail-component-base"].value

return {
    data = function()
        if elevatedSetting == "standard" then
            componentUtil.attachComponentToItem("rail-ramp", "rail-ramp", "rail-support", 5)
        elseif elevatedSetting == "rails" then
            componentUtil.attachComponentToItem("rail-ramp", "rail-ramp", "rail", 100)
            componentUtil.attachComponentToItem("rail-support", "rail-support", "rail", 20)
        end
    end,
    data_updates = function()
        if mods["space-exploration"] then
            if elevatedSetting == "standard" then
                componentUtil.attachComponentToItem("rail-ramp", "se-space-rail-ramp", "se-space-rail-support", 5)
            elseif elevatedSetting == "rails" then
                componentUtil.attachComponentToItem("rail-ramp", "se-space-rail-ramp", "se-space-rail", 100)
                componentUtil.attachComponentToItem("rail-support", "se-space-rail-support", "se-space-rail", 20)
            end
        end
    end
}



