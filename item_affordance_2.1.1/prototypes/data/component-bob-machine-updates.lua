local componentUtil = require("component-util")

local setting = settings.startup["bob-machine-components"]
if setting == nil or not setting.value then
    return
end



componentUtil.attachComponentToItem("boiler", "bob-oil-boiler", "bob-boiler-2")
componentUtil.attachComponentToItem("boiler", "bob-oil-boiler-2", "bob-boiler-3")
componentUtil.attachComponentToItem("boiler", "bob-oil-boiler-3", "bob-boiler-4")
componentUtil.attachComponentToItem("boiler", "bob-oil-boiler-4", "bob-boiler-5")

componentUtil.attachComponentToItem("assembling-machine", "bob-stone-chemical-furnace", "stone-furnace")
componentUtil.attachComponentToItem("assembling-machine", "bob-stone-mixing-furnace", "stone-furnace")

componentUtil.attachComponentToItem("assembling-machine", "bob-steel-chemical-furnace", "steel-furnace")
componentUtil.attachComponentToItem("assembling-machine", "bob-steel-mixing-furnace", "steel-furnace")
componentUtil.attachComponentToItem("furnace", "bob-fluid-furnace", "steel-furnace")
componentUtil.attachComponentToItem("assembling-machine", "bob-fluid-chemical-furnace", "steel-furnace")
componentUtil.attachComponentToItem("assembling-machine", "bob-fluid-mixing-furnace", "steel-furnace")

componentUtil.attachComponentToItem("assembling-machine", "bob-electric-mixing-furnace", "electric-furnace")
componentUtil.attachComponentToItem("assembling-machine", "bob-electric-chemical-furnace", "electric-furnace")
componentUtil.attachComponentToItem("assembling-machine", "bob-electric-chemical-mixing-furnace", "bob-electric-furnace-2")
componentUtil.attachComponentToItem("assembling-machine", "bob-electric-chemical-mixing-furnace-2", "bob-electric-furnace-3")

local item = componentUtil.itemLookup("boiler")
if item then
    item.order = COMPONENT_ORDER .. "-a[boiler]"
end

item = componentUtil.itemLookup("stone-furnace")
if item then
    item.order = COMPONENT_ORDER .. "-a[stone-furnace]"
end
