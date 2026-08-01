_G.item_affordance_component_order = {}
local STEEL_CHEST = "steel-chest"

item_affordance_component_order["se-space-pipe"] = "a[pipe]-c" .. COMPONENT_ORDER .. "-a[se-space-pipe]"

item_affordance_component_order["rail-signal"] = "b[train-automation]-a[train-stop]-" .. COMPONENT_ORDER .. "-c[rail-signal]"
item_affordance_component_order["rail-chain-signal"] = "b[train-automation]-a[train-stop]-" .. COMPONENT_ORDER .. "-c[rail-chain-signal]"

item_affordance_component_order["rail-support"] = "a[rail]-a[rail]-" .. COMPONENT_ORDER .. "-c[rail-support]"
item_affordance_component_order["se-space-rail-support"] = "a[rail]-b[rail-ramp]-" .. COMPONENT_ORDER .. "-f[se-space-rail-support]"
item_affordance_component_order["rail"] = COMPONENT_ORDER .. "-a[rail]"
item_affordance_component_order["se-space-rail"] = "a[rail]-d" .. COMPONENT_ORDER
item_affordance_component_order["niobium-pipe"] = "pipe[niobium]a"
item_affordance_component_order["ht-pipes"] = "pipe[niobium]c"
item_affordance_component_order["py-overflow-valve"] = "pipe[niobium]-flow-b"

local item = data.raw["item"]
-- special lookups for logistic containers only
for _, name in ipairs(item_affordance_allowed_item_groups["all-logistic-container-component"]) do
    for type, fixes in ipairs(item_affordance_logistic_container_types) do
        local key = fixes.prefix .. name .. fixes.postfix

        if key == name.. "-chest" or key == "bob-" .. name.. "-chest-2" or key == "bob-" .. name.. "-chest-3" then
            item_affordance_component_order[key] = "b[storage]-d" .. COMPONENT_ORDER .. item_affordance_logistic_order[name] .. "-[" .. key .. "]"
        elseif fixes.prefix == "5d-" and nil ~= string.find(fixes.postfix, "-chest") then
            item_affordance_component_order[key] = "b[storage]-da" .. COMPONENT_ORDER .. item_affordance_logistic_order[name] .. "-[" .. key .. "]"
        elseif fixes.prefix == "storehouse-" then
            item_affordance_component_order[key] = "b[storage]-" .. COMPONENT_ORDER .. item_affordance_logistic_order[name] .. "-a[storehouse]"
        elseif fixes.prefix == "warehouse-" then
            item_affordance_component_order[key] = "b[storage]-" .. COMPONENT_ORDER .. item_affordance_logistic_order[name] .. "-b[warehouse]"
        elseif fixes.prefix == "py-shed-" or fixes.prefix == "py-storehouse-" or fixes.prefix == "py-warehouse-" or fixes.prefix == "py-deposit-" then
            item_affordance_component_order[key] = "logistic-container-" .. COMPONENT_ORDER .. item_affordance_logistic_order[name] .. "-a[" .. key .. "]"
        elseif fixes.prefix == "kr-" and fixes.postfix == "-strongbox" then
            item_affordance_component_order[key] = "b[storage]-" .. COMPONENT_ORDER .. item_affordance_logistic_order[name] .. "-a[kr-strongbox]"
        elseif fixes.prefix == "kr-" and fixes.postfix == "-warehouse" then
            item_affordance_component_order[key] = "b[storage]-" .. COMPONENT_ORDER .. item_affordance_logistic_order[name] .. "-b[kr-warehouse]"
        elseif fixes.prefix == "angels-silo-" then
            item_affordance_component_order[key] = "a[silo]-" .. COMPONENT_ORDER .. item_affordance_logistic_order[name]
        elseif fixes.prefix == "angels-warehouse-" then
            item_affordance_component_order[key] = "a[angels-warehouse]-" .. COMPONENT_ORDER .. item_affordance_logistic_order[name]
        elseif item[key] and item[key].order then
            item_affordance_component_order[key] = item[key].order .. "-" .. COMPONENT_ORDER
        elseif item[STEEL_CHEST] and item[STEEL_CHEST].order then
            item_affordance_component_order[key] = item[STEEL_CHEST].order .. COMPONENT_ORDER .. "[" .. key .. "]"
        else
            item_affordance_component_order[key] = COMPONENT_ORDER .. "[" .. key .. "]"
        end
    end
end

_G.item_affordance_afforded_order = {}
-- special lookups for logistic containers only
for _, name in ipairs(item_affordance_allowed_item_groups["all-logistic-container-component"]) do
    for type, fixes in ipairs(item_affordance_logistic_container_types) do
        local key = fixes.prefix .. name .. fixes.postfix

        if key == name .. "-chest"
        or key == "bob-" .. name .. "-chest-2"
        or key == "bob-" .. name .. "-chest-3"
        or key == "kr-" .. name .. "-strongbox"
        or key == "kr-" .. name .. "-warehouse" then
            item_affordance_afforded_order[key] = "b[storage]-da" .. item_affordance_logistic_order[name] .. "-[" .. key .. "]"
        elseif fixes.prefix == "5d-" and nil ~= string.find(fixes.postfix, "-chest") then
            item_affordance_afforded_order[key] = "b[storage]-db" .. item_affordance_logistic_order[name] .. "-[" .. key .. "]"
        elseif fixes.prefix == "py-shed-"
        or fixes.prefix == "py-storehouse-"
        or fixes.prefix == "py-warehouse-"
        or fixes.prefix == "py-deposit-" then
            item_affordance_afforded_order[key] = "logistic-container-" .. item_affordance_logistic_order[name] .. "-a[" .. key .. "]"
        end
    end
end

item_affordance_afforded_order["niobium-pipe-to-ground"] = "pipe[niobium]b"
item_affordance_afforded_order["ht-pipes-to-ground"] = "pipe[niobium]d"
item_affordance_afforded_order["py-underflow-valve"] = "pipe[niobium]-flow-c"

if mods["Dectorio"] then
    for _, value in ipairs({"red", "green", "blue", "orange", "yellow", "pink", "purple", "black", "brown", "cyan", "acid"}) do
        local name = "dect-" .. value .. "-refined-concrete"
        item_affordance_afforded_order[name] = "z[" .. name .. "]"
    end
end

if mods["space-exploration"] then
    for _, tier in ipairs(item_affordance_belt_tiers) do
        local prefix = tier.prefix or ""
        local postfix = tier.postfix or ""
        local splitterName = GLOBAL_UTIL.hypenFix(string.format("%ssplitter%s", prefix, postfix))
        local laneSplitterName = GLOBAL_UTIL.hypenFix(string.format("%slane-splitter%s", prefix, postfix))
        item_affordance_component_order[splitterName] = "c[splitter]-" .. tier.order .. "[" .. laneSplitterName .."]"
        item_affordance_afforded_order[splitterName] = item_affordance_component_order[splitterName]
        item_affordance_component_order[laneSplitterName] = "d[lane-splitter]-" .. tier.order  .. "[" .. laneSplitterName .."]"
        item_affordance_afforded_order[laneSplitterName] = item_affordance_component_order[laneSplitterName]
    end
end

_G.item_affordance_subgroup_order = {}

local setting = settings.startup["elevated-rail-component-base"]

if setting and setting.value == "rails" and data.raw["item-subgroup"]["rail"] then
    item_affordance_subgroup_order["rail-support"] = "rail"
    item_affordance_subgroup_order["rail-ramp"] = "rail"

    item_affordance_subgroup_order["se-space-rail-support"] = "rail"
    item_affordance_subgroup_order["se-space-rail-ramp"] = "rail"
end

setting = settings.startup["bob-machine-components"]

if setting and setting.value and data.raw["item-subgroup"]["bob-smelting-machine"] then
    item_affordance_subgroup_order["bob-fluid-furnace"] = "bob-smelting-machine"
end

if mods["boblogistics"] then
    for _, tier in ipairs(item_affordance_belt_tiers) do
        local prefix = tier.prefix or ""
        local postfix = tier.postfix or ""
        if tier.bob_subgroup and data.raw["item-subgroup"][tier.bob_subgroup] then
            for _, name in ipairs({"%sloader%s", "%sloader-1x1%s", "%stransport-belt-beltbox%s", "floating-%stransport-belt%s", "%slane-splitter%s", "aai-%s%sloader", "%scomfortable-loader%s", "%stransport-belt-loader%s", "%smdrn-loader%s", "kr-%sloader%s"}) do
                item_affordance_subgroup_order[GLOBAL_UTIL.hypenFix(string.format(name, prefix, postfix))] = tier.bob_subgroup
            end
        end
    end
end

if mods["5dim_storage"] then
    for _, containerType in ipairs(item_affordance_5d_logistic_container_types) do
        item_affordance_subgroup_order[containerType.prefix .. settings.startup["all-logistic-container-component-base"].value .. containerType.postfix] = "item-affordance-passive-containers"
        item_affordance_subgroup_order[containerType.prefix .. settings.startup["passive-logistic-container-component-base"].value .. containerType.postfix] = "item-affordance-passive-containers"
        item_affordance_subgroup_order[containerType.prefix .. settings.startup["active-logistic-container-component-base"].value .. containerType.postfix] = "item-affordance-active-containers"
    end
end