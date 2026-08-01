_G.COMPONENT_ORDER = ".[COMPONENT]"

-- i do my best to register affordances as early in the load order as possible
_G.DATA_UPDATE_DELAY = mods["boblibrary"] ~= nil or mods["quality"] ~= nil or mods["recycler"] ~= nil or mods["Krastorio2"] ~= nil
_G.DATA_FINAL_DELAY = mods["space-exploration"] ~= nil or mods["5dim_core"] ~= nil or mods["pypostprocessing"] ~= nil or mods["AdvancedBeltsSA"] ~= nil

_G.GLOBAL_UTIL = {
    hypenFix = function(str) return string.gsub(string.gsub(string.gsub(str, "%-%-", "-"), "^%-", ""), "%-$", "") end
}

--sets of items that can be interchanged simply, used in both stages
_G.item_affordance_allowed_item_groups = {}
_G.item_affordance_entity_type_lookup = {}
item_affordance_allowed_item_groups["rail-signal-component"] = {"rail-chain-signal", "rail-signal"}
item_affordance_allowed_item_groups["passive-logistic-container-component"] = {"passive-provider", "storage"}
item_affordance_allowed_item_groups["active-logistic-container-component"] = {"active-provider", "requester", "buffer"}
item_affordance_allowed_item_groups["all-logistic-container-component"] = {}
for _, name in ipairs(item_affordance_allowed_item_groups["passive-logistic-container-component"]) do
  table.insert(item_affordance_allowed_item_groups["all-logistic-container-component"], name)
end
for _, name in ipairs(item_affordance_allowed_item_groups["active-logistic-container-component"]) do
  table.insert(item_affordance_allowed_item_groups["all-logistic-container-component"], name)
end

item_affordance_logistic_order = {}
item_affordance_logistic_order["passive-provider"] = "a"
item_affordance_logistic_order["storage"] = "a"
item_affordance_logistic_order["active-provider"] = "b"
item_affordance_logistic_order["requester"] = "b"
item_affordance_logistic_order["buffer"] = "b"

item_affordance_allowed_item_groups["basic-circuit-network-component"] = {"arithmetic-combinator", "decider-combinator", "constant-combinator", "power-switch", "programmable-speaker", "display-panel"}

item_affordance_allowed_item_groups["aai-control-structure"] = {"tile-scan", "zone-scan", "zone-control", "unit-scan"}
item_affordance_entity_type_lookup["zone-control"] = "roboport"

if mods["aai-programmable-vehicles"] then
  table.insert(item_affordance_allowed_item_groups["aai-control-structure"], "unit-control")
  item_affordance_entity_type_lookup["unit-control"] = "roboport"
  table.insert(item_affordance_allowed_item_groups["aai-control-structure"], "unitdata-scan")
  table.insert(item_affordance_allowed_item_groups["aai-control-structure"], "unitdata-control")
  item_affordance_entity_type_lookup["unitdata-control"] = "roboport"
  table.insert(item_affordance_allowed_item_groups["aai-control-structure"], "path-scan")
  table.insert(item_affordance_allowed_item_groups["aai-control-structure"], "path-control")
  item_affordance_entity_type_lookup["path-control"] = "roboport"
end

if mods["Flow Control"] then
    item_affordance_entity_type_lookup["pipe-elbow"] = "storage-tank"
    item_affordance_entity_type_lookup["pipe-straight"] = "storage-tank"
    item_affordance_entity_type_lookup["pipe-junction"] = "storage-tank"
end

-- types of logistic containers
_G.item_affordance_logistic_container_types = {
    {prefix = "", postfix = "-chest"}
}

if mods["aai-containers"] then
  table.insert(item_affordance_logistic_container_types, {prefix = "aai-strongbox-", postfix = ""})
  table.insert(item_affordance_logistic_container_types, {prefix = "aai-storehouse-", postfix = ""})
  table.insert(item_affordance_logistic_container_types, {prefix = "aai-warehouse-", postfix = ""})
end

if mods["angelsaddons-storage"] then
  table.insert(item_affordance_logistic_container_types, {prefix = "angels-silo-", postfix = ""})
  table.insert(item_affordance_logistic_container_types, {prefix = "angels-warehouse-", postfix = ""})
end

if mods["Warehousing"] then
  table.insert(item_affordance_logistic_container_types, {prefix = "storehouse-", postfix = ""})
  table.insert(item_affordance_logistic_container_types, {prefix = "warehouse-", postfix = ""})
end

if mods["boblogistics"] then
  table.insert(item_affordance_logistic_container_types, {prefix = "bob-", postfix = "-chest-2"})
  table.insert(item_affordance_logistic_container_types, {prefix = "bob-", postfix = "-chest-3"})
end

if mods["Krastorio2"] then
  table.insert(item_affordance_logistic_container_types, {prefix = "kr-", postfix = "-strongbox"})
  table.insert(item_affordance_logistic_container_types, {prefix = "kr-", postfix = "-warehouse"})
end

if mods["pyindustry"] then
  table.insert(item_affordance_logistic_container_types, {prefix = "py-shed-", postfix = ""})
  table.insert(item_affordance_logistic_container_types, {prefix = "py-storehouse-", postfix = ""})
  table.insert(item_affordance_logistic_container_types, {prefix = "py-warehouse-", postfix = ""})
  table.insert(item_affordance_logistic_container_types, {prefix = "py-deposit-", postfix = ""})
end

_G.item_affordance_5d_logistic_container_types = {}

if mods["5dim_storage"] then
  table.insert(item_affordance_5d_logistic_container_types, {prefix = "5d-", postfix = "-chest-02"})
  table.insert(item_affordance_5d_logistic_container_types, {prefix = "5d-", postfix = "-chest-03"})
  table.insert(item_affordance_5d_logistic_container_types, {prefix = "5d-", postfix = "-chest-04"})
  table.insert(item_affordance_5d_logistic_container_types, {prefix = "5d-", postfix = "-chest-05"})
  table.insert(item_affordance_5d_logistic_container_types, {prefix = "5d-", postfix = "-chest-06"})
  table.insert(item_affordance_5d_logistic_container_types, {prefix = "5d-", postfix = "-chest-07"})
  table.insert(item_affordance_5d_logistic_container_types, {prefix = "5d-", postfix = "-chest-08"})
  table.insert(item_affordance_5d_logistic_container_types, {prefix = "5d-", postfix = "-chest-09"})
  table.insert(item_affordance_5d_logistic_container_types, {prefix = "5d-", postfix = "-chest-10"})

  for _,v in ipairs(item_affordance_5d_logistic_container_types) do
      table.insert(item_affordance_logistic_container_types, v)
  end

  table.insert(item_affordance_5d_logistic_container_types, {prefix = "", postfix = "-chest"})
end

--belt tiers, only used in prototype stage
_G.item_affordance_belt_tiers = {
    {prefix = "", order = "a", bob_subgroup = "bob-logistic-tier-1"},
    {prefix = "fast-", order = "b", bob_subgroup = "bob-logistic-tier-2"},
    {prefix = "express-", order = "c", bob_subgroup = "bob-logistic-tier-3"}
}

if mods["space-age"] then
    if mods["more-belts"] then
        table.insert(item_affordance_belt_tiers, {prefix = "turbo-", base_override = "ddi-transport-belt-mk4", order = "d"})
    else
        table.insert(item_affordance_belt_tiers, {prefix = "turbo-", order = "d"})
    end
end

if mods["space-exploration"] then
    table.insert(item_affordance_belt_tiers, {prefix = "se-space-", order = "e"})
    table.insert(item_affordance_belt_tiers, {prefix = "se-deep-space-", postfix = "-black-", order = "f"})
    table.insert(item_affordance_belt_tiers, {prefix = "se-deep-space-", postfix = "-blue-", base_override = "se-deep-space-transport-belt-black", order = "g"})
    table.insert(item_affordance_belt_tiers, {prefix = "se-deep-space-", postfix = "-cyan-", base_override = "se-deep-space-transport-belt-black", order = "h"})
    table.insert(item_affordance_belt_tiers, {prefix = "se-deep-space-", postfix = "-green-", base_override = "se-deep-space-transport-belt-black", order = "i"})
    table.insert(item_affordance_belt_tiers, {prefix = "se-deep-space-", postfix = "-magenta-", base_override = "se-deep-space-transport-belt-black", order = "j"})
    table.insert(item_affordance_belt_tiers, {prefix = "se-deep-space-", postfix = "-red-", base_override = "se-deep-space-transport-belt-black", order = "k"})
    table.insert(item_affordance_belt_tiers, {prefix = "se-deep-space-", postfix = "-white-", base_override = "se-deep-space-transport-belt-black", order = "l"})
    table.insert(item_affordance_belt_tiers, {prefix = "se-deep-space-", postfix = "-yellow-", base_override = "se-deep-space-transport-belt-black", order = "m"})
end

if mods["5dim_transport"] then
    if mods["space-age"] == nil then
        table.insert(item_affordance_belt_tiers, {prefix = "5d-", postfix = "-04"})
    end
    table.insert(item_affordance_belt_tiers, {prefix = "5d-", postfix = "-05"})
    table.insert(item_affordance_belt_tiers, {prefix = "5d-", postfix = "-06"})
    table.insert(item_affordance_belt_tiers, {prefix = "5d-", postfix = "-07"})
    table.insert(item_affordance_belt_tiers, {prefix = "5d-", postfix = "-08"})
    table.insert(item_affordance_belt_tiers, {prefix = "5d-", postfix = "-09"})
    table.insert(item_affordance_belt_tiers, {prefix = "5d-", postfix = "-10"})
end

if mods["more-belts"] then
    table.insert(item_affordance_belt_tiers, {prefix = "ddi-", postfix = "-mk4-"})
    table.insert(item_affordance_belt_tiers, {prefix = "ddi-", postfix = "-mk5-"})
    table.insert(item_affordance_belt_tiers, {prefix = "ddi-", postfix = "-mk6-"})
    table.insert(item_affordance_belt_tiers, {prefix = "ddi-", postfix = "-mk7-"})
    table.insert(item_affordance_belt_tiers, {prefix = "ddi-", postfix = "-mk8-"})
end

if mods["promethium-belts"] or mods["promethium-belts-rebalance"] then
    table.insert(item_affordance_belt_tiers, {prefix = "promethium-"})
end

if mods["boblogistics"] then
    table.insert(item_affordance_belt_tiers, {prefix = "bob-basic-"})
    table.insert(item_affordance_belt_tiers, {prefix = "bob-turbo-"})
    table.insert(item_affordance_belt_tiers, {prefix = "bob-ultimate-"})
end

if mods["Krastorio2"] then
    table.insert(item_affordance_belt_tiers, {prefix = "kr-advanced-"})
    table.insert(item_affordance_belt_tiers, {prefix = "kr-superior-"})
end

if mods["AdvancedBeltsSA"] then
    table.insert(item_affordance_belt_tiers, {prefix = "extreme-"})
    table.insert(item_affordance_belt_tiers, {prefix = "ultimate-"})
    table.insert(item_affordance_belt_tiers, {prefix = "high-speed-"})
end
