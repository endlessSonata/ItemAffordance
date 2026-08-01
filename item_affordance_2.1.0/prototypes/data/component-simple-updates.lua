local componentUtil = require("component-util")
local items = data.raw["item"]

return {
    data = function()
        if settings.startup["rail-signal-component-base"].value ~= "disabled" then
            componentUtil.attachComponentsToItem("rail-signal-component",
                item_affordance_allowed_item_groups["rail-signal-component"]
            )
        end

        if settings.startup["basic-circuit-network-component-base"].value ~= "disabled" then
            componentUtil.attachComponentsToItem("basic-circuit-network-component",
                item_affordance_allowed_item_groups["basic-circuit-network-component"]
            )

            if mods["Dectorio"] then
                componentUtil.attachComponentToItem("lamp", "dect-small-lamp-glow", "small-lamp")
            end
        end

        if mods["angelsaddons-storage"] and data.raw.item["angels-silo"] then
            for i = 1, 6, 1 do
                componentUtil.attachComponentToItem("container", "angels-silo-ore" .. i, "angels-silo")
            end
            componentUtil.attachComponentToItem("container", "angels-silo-coal", "angels-silo")
        end

        if mods["aai-programmable-structures"] and settings.startup["aai-control-structure-component-base"].value ~= "disabled" then
            componentUtil.attachComponentsToItem("aai-control-structure-component",
                item_affordance_allowed_item_groups["aai-control-structure"],
                "radar"
            )
        end

        if mods["Dectorio"] then
            for _, value in ipairs({"dead-grey-trunk", "dead-tree-desert", "dry-hairy-tree", "dry-tree"}) do
                componentUtil.attachComponentToItem("tree", {entity_name = value, item_name = "dect-base-" .. value}, "dect-base-dead-dry-hairy-tree", 1, false)
            end
            for i = 2, 9, 1 do
                componentUtil.attachComponentToItem("tree", {entity_name = "tree-0" .. i, item_name = "dect-base-tree-0" .. i}, "dect-base-tree-01", 1, false)
            end
            for _, value in ipairs({"2-red", "8-red", "9-red", "6-brown", "8-brown", "9-brown"}) do
                componentUtil.attachComponentToItem("tree", {entity_name = "tree-0", item_name = "dect-base-tree-0" .. value}, "dect-base-tree-01", 1, false)
            end
        end

        if mods["5dim_logistic"] and settings.startup["5dim-roboport-components"].value then
            local mini5droboport_tiers = {"10"}
            for i = 1, 9, 1 do
                table.insert(mini5droboport_tiers, "0" .. i)
            end
            for _, type in ipairs({"5d-roboport-logistic-", "5d-roboport-construction-", "5d-roboport-compact-"}) do
                for _, tier in ipairs(mini5droboport_tiers) do
                    componentUtil.attachComponentToItem("roboport", type .. tier, "5d-roboport-charging-" .. tier)
                end
            end
        end
    end,
    data_updates = function()
        if settings.startup["electric-pole-components"].value then
            local small_pole = items["small-electric-pole"]

            if mods["pycoalprocessing"] == nil then
                if small_pole then
                    small_pole.order = COMPONENT_ORDER .. "-a[small-electric-pole]"
                end
                componentUtil.attachComponentToItem("electric-pole", "big-electric-pole", "medium-electric-pole", 2)
            end

            if mods["dredgeworks"] then
                componentUtil.attachComponentToItem("electric-pole", "wire-buoy", "medium-electric-pole", 2)
            end

            if mods["bobpower"] then
                componentUtil.attachComponentToItem("electric-pole", "bob-big-electric-pole-2", "bob-medium-electric-pole-2", 2)
                componentUtil.attachComponentToItem("electric-pole", "bob-big-electric-pole-3", "bob-medium-electric-pole-3", 2)
                componentUtil.attachComponentToItem("electric-pole", "bob-big-electric-pole-4", "bob-medium-electric-pole-4", 2)
            end
        end

        if mods["kry-inserters"] then
            componentUtil.attachComponentToItem("inserter", "burner-long-inserter", "burner-inserter")
            componentUtil.attachComponentToItem("inserter", "long-handed-inserter", "inserter")
            componentUtil.attachComponentToItem("inserter", "long-fast-inserter", "fast-inserter")
            componentUtil.attachComponentToItem("inserter", "long-bulk-inserter", "bulk-inserter")
            componentUtil.attachComponentToItem("inserter", "long-stack-inserter", "stack-inserter")

            if mods["dredgeworks"] then
                componentUtil.attachComponentToItem("inserter", "floating-burner-long-inserter", "floating-burner-inserter")
                componentUtil.attachComponentToItem("inserter", "floating-long-handed-inserter", "floating-inserter")
                componentUtil.attachComponentToItem("inserter", "floating-long-fast-inserter", "floating-fast-inserter")
                componentUtil.attachComponentToItem("inserter", "floating-long-bulk-inserter", "floating-bulk-inserter")
                componentUtil.attachComponentToItem("inserter", "floating-long-stack-inserter", "floating-stack-inserter")
            end
        end
    end
}