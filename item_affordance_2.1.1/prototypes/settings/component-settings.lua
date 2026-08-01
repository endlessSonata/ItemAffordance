local function doAffordanceComponentsOn(name, order)
    return {
        type = "bool-setting",
        name = name,
        setting_type = "startup",
        order = string.format("%s[%s]", order, name),
        default_value = true
    }
end

local function beltComponentCost(type_name, order, default_value)
    local name = "belt-component-cost-" .. type_name
    return {
        type = "int-setting",
        name = name,
        minimum_value = 3,
        maximum_value = 100,
        setting_type = "startup",
        order = string.format("a%s[%s]", order, name),
        default_value = default_value
    }
end

local function listWithDisabled(list)
    local newList = {"disabled"}
    for _, name in ipairs(list) do
      table.insert(newList, name)
    end
    return newList
end

data:extend({
    {
        type = "bool-setting",
        name = "affordance-place-with-base",
        setting_type = "startup",
        order = "Za[affordance-place-with-base]",
        default_value = true
    },
    {
        type = "bool-setting",
        name = "affordance-retrieve-base",
        setting_type = "startup",
        order = "Zb[affordance-retrieve-base]",
        default_value = true
    },
    doAffordanceComponentsOn("tile-components", "Zc"),
    doAffordanceComponentsOn("belt-components", "a"),
    {
        type = "bool-setting",
        name = "belt-component-rebalance",
        setting_type = "startup",
        order = "aa[belt-component-rebalance]",
        default_value = true
    },
    beltComponentCost("underground-belt", "b", 5),
    beltComponentCost("splitter", "c", 8)
})
if mods["lane-splitters"] or mods["lane-balancers"] then
    data:extend({beltComponentCost("lane-splitter", "c", 6)})
end
if mods["deadlock-beltboxes-loaders"] then
    data:extend({beltComponentCost("beltbox", "d", 12)})
end
data:extend({
    {
        type = "bool-setting",
        name = "belt-component-loaders-enabled",
        setting_type = "startup",
        order = "ae[belt-component-loaders-enabled]",
        default_value = true
    },
    doAffordanceComponentsOn("pipe-components", "b"),
    doAffordanceComponentsOn("electric-pole-components", "d"),
    {
        type = "string-setting",
        name = "rail-signal-component-base",
        setting_type = "startup",
        default_value = "rail-signal",
        allowed_values = listWithDisabled(item_affordance_allowed_item_groups["rail-signal-component"]),
        order = "ca[rail-signal-component-base]"
    }
})
if mods["elevated-rails"] then
    data:extend({
        {
            type = "string-setting",
            name = "elevated-rail-component-base",
            setting_type = "startup",
            default_value = "standard",
            allowed_values = {"disabled", "standard", "rails"},
            order = "d[elevated-rail-component-base]"
        }
    })
end
data:extend({
    {
        type = "string-setting",
        name = "passive-logistic-container-component-base",
        setting_type = "startup",
        default_value = "passive-provider",
        allowed_values = listWithDisabled(item_affordance_allowed_item_groups["passive-logistic-container-component"]),
        order = "fb[passive-logistic-container-component-base]"
    },
    {
        type = "string-setting",
        name = "active-logistic-container-component-base",
        setting_type = "startup",
        default_value = "active-provider",
        allowed_values = listWithDisabled(item_affordance_allowed_item_groups["active-logistic-container-component"]),
        order = "fc[active-logistic-container-component-base]"
    },
    {
        type = "string-setting",
        name = "all-logistic-container-component-base",
        setting_type = "startup",
        default_value = "disabled",
        allowed_values = listWithDisabled(item_affordance_allowed_item_groups["all-logistic-container-component"]),
        order = "fd[all-logistic-container-component-base]"
    },
    {
        type = "string-setting",
        name = "basic-circuit-network-component-base",
        setting_type = "startup",
        default_value = "decider-combinator",
        allowed_values = listWithDisabled(item_affordance_allowed_item_groups["basic-circuit-network-component"]),
        order = "ga[basic-circuit-network-component-base]"
    }
})

if mods["aai-programmable-structures"] then
    data:extend({
        {
            type = "string-setting",
            name = "aai-control-structure-component-base",
            setting_type = "startup",
            default_value = "tile-scan",
            allowed_values = listWithDisabled(item_affordance_allowed_item_groups["aai-control-structure"]),
            order = "ha[aai-control-structure-base]"
        }
    })
end

if mods["bobassembly"] or mods["bobplates"] or mods["bobpower"] then
    data:extend({doAffordanceComponentsOn("bob-machine-components", "i")})
end

if mods["5dim_logistic"] then
    data:extend({doAffordanceComponentsOn("5dim-roboport-components", "i")})
end