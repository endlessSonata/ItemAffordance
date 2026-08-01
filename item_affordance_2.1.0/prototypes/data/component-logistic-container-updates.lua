local componentUtil = require("component-util")

if settings.startup["all-logistic-container-component-base"].value == "disabled"
    and settings.startup["passive-logistic-container-component-base"].value == "disabled"
    and settings.startup["active-logistic-container-component-base"].value == "disabled" then
       return
end

if mods["5dim_core"] then
    if mods["5dim_storage"] then
        data:extend({
            {
              group = "logistic",
              name = "item-affordance-passive-containers",
              order = "cfa[item-affordance-passive-containers]",
              type = "item-subgroup"
            },
            {
              group = "logistic",
              name = "item-affordance-active-containers",
              order = "cfb[item-affordance-active-containers]",
              type = "item-subgroup"
            }
        })
    elseif data.raw["item-subgroup"]["logistic-pasive"] then
        for _, logisticType in ipairs(item_affordance_allowed_item_groups["all-logistic-container-component"]) do
            local name = logisticType .. "-chest"
            log(name)
            local item = data.raw.item[name]
            if item then
                log(name .. "passive")
                item.subgroup = "logistic-pasive"
            end
        end
    end
end

for _, containerType in ipairs(item_affordance_logistic_container_types) do
    if settings.startup["all-logistic-container-component-base"].value == "disabled" then
        --passive robot chests
        if settings.startup["passive-logistic-container-component-base"].value ~= "disabled" then
            componentUtil.attachComponentsToItem("passive-logistic-container-component",
                item_affordance_allowed_item_groups["passive-logistic-container-component"],
                "logistic-container",
                containerType.prefix,
                containerType.postfix
            )
        end

        --active robot chests
        if settings.startup["active-logistic-container-component-base"].value ~= "disabled" then
            componentUtil.attachComponentsToItem("active-logistic-container-component",
                item_affordance_allowed_item_groups["active-logistic-container-component"],
                "logistic-container",
                containerType.prefix,
                containerType.postfix
            )
        end
    else
        componentUtil.attachComponentsToItem("all-logistic-container-component",
            item_affordance_allowed_item_groups["all-logistic-container-component"],
            "logistic-container",
            containerType.prefix,
            containerType.postfix
        )
    end
end