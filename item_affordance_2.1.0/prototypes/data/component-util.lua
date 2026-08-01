local pipetteOverrides = data.raw["mod-data"]["item_affordance-entity-to-item-list"].data
local recycle_tech = data.raw["technology"]["recycling"]
local items = data.raw["item"]
local railPlanners = data.raw["rail-planner"]
local modules = data.raw.module
local ITEM_GROUP_PATTERN = "%w*%[[%w-]+%]"
local ITEM_GROUP_PATTERN_WITH_NEXT = "%w*%[[%w-]+%]%-%w"
local handledItems = {}

local function itemLookup(itemName)
    local item = items[itemName]
    if item then
        return item
    end
    item = railPlanners[itemName]
    if item then
        return item
    end
    return modules[itemName]
end

local function handleItemSubgroup(item_name)
    local item = itemLookup(item_name)

    if item then
        local new_subgroup = item_affordance_subgroup_order[item_name]
        if new_subgroup then
            item.subgroup = new_subgroup
        end
    end
end

local function handleItemOrder(item_name, sample_result)
    handleItemSubgroup(sample_result)
    local sample_item = itemLookup(sample_result)
    if sample_item then
        if item_affordance_afforded_order[sample_result] then
            sample_item.order = item_affordance_afforded_order[sample_result]
        end
        if sample_item.order then
            log(sample_result .. ";;" .. sample_item.order)
        end
    end
    if handledItems[item_name] then
        return
    end
    handledItems[item_name] = true

    if string.find(item_name, "transport%-belt") then
        return
    end

    handleItemSubgroup(item_name)
    local item = itemLookup(item_name)

    if item then
        if item_affordance_component_order[item_name] then
            log(item_name .. ";" .. item_affordance_component_order[item_name])
            item.order = item_affordance_component_order[item_name]
            return
        end

        if item.order then
            --try to respect item groups if possible
            local start_index, end_index = string.find(item.order, ITEM_GROUP_PATTERN_WITH_NEXT)
            if start_index == nil or end_index == nil then
                start_index, end_index = string.find(item.order, ITEM_GROUP_PATTERN)
            end

            if start_index and end_index then
                local possible_order = string.sub(item.order, start_index, end_index) .. "-" .. COMPONENT_ORDER
                if end_index + 1 < string.len(item.order) then
                    possible_order = possible_order .. string.sub(item.order, end_index + 1)
                end

                if sample_item then
                    local sample_order = sample_item.order
                    if sample_order then
                        if possible_order < sample_order then
                            item.order = possible_order
                        else
                            item.order = COMPONENT_ORDER .. "-" .. item.order
                        end
                    else
                        item.order = possible_order
                    end
                else
                    item.order = possible_order
                end
            else
                item.order = COMPONENT_ORDER .. "-" .. item.order
            end
        else
            --for naughty mod authors who dont give thier items an order
            item.order = COMPONENT_ORDER .. "-unknown"
        end
        log(item_name .. ";" .. item.order)
    end
end

local function recycleRecipe(name, details)
    -- remove vanilla recycle recipe
    local recycle_recipe_name = name .. "-recycling"
    if data.raw["recipe"][recycle_recipe_name] then
        data.raw["recipe"][recycle_recipe_name] = nil
    end
    if recycle_tech then
        for i, effect in pairs(recycle_tech["effects"]) do
            if (effect["type"] == "unlock-recipe" and effect["recipe"] == recycle_recipe_name) then
                table.remove(recycle_tech["effects"], i)
                break
            end
        end
    end

    local recall_name = name .. "-recall"
    if data.raw["recipe"][recall_name] then
        data.raw["recipe"][recall_name] = nil
    end
    local recipe = {
        type = "recipe",
        name = recall_name,
        categories = {"adordance-reclaimer"},
        results = {{amount = details.amount, name = details.result, type = "item"}},
        ingredients = {{amount = 1, type = "item", name = details.ingredient}},
        energy_required = 0.002,
        emissions_multiplier = 0,
        maximum_productivity = 0,
        surface_conditions = nil,
        allow_quality = false,
        allow_productivity = false,
        hide_from_stats = true,
        hide_from_bonus_gui = true,
        hidden = true,
        hidden_in_factoriopedia = true,
        auto_recycle = false,
        hide_from_signal_gui = true,
        allowed_module_categories = {"speed", "efficiency"},
        allow_decomposition = true,
        localised_name = {
          "recipe-name.recycling",
          {
            "item-name." .. details.ingredient
          }
        }
    }

    data:extend({recipe})
end

local function fromComponentRecipieStep(parsed_result_name, parsed_recipe_name, component_name, cost, amount)
    cost = cost or 1
    amount = amount or 1
    local recipe = data.raw["recipe"][parsed_recipe_name]

    if recipe then
        recipe.ingredients = {{amount = cost, type = "item", name = component_name}}
        recipe.categories = {"crafting"}
        -- these items are only used for placement, so i don't think it makes sence to have a time cost
        recipe.energy_required = 0.002
        recipe.emissions_multiplier = 0
        recipe.maximum_productivity = 0
        recipe.surface_conditions = nil
        recipe.allow_quality = false
        recipe.allow_productivity = false
        recipe.hide_from_stats = true
        recipe.hide_from_bonus_gui = true
        recipe.allow_decomposition = true
        recipe.allow_as_intermediate = true
        recipe.allow_intermediates = true
        recipe.auto_recycle = false
        recipe.results = {{amount = amount, name = parsed_result_name, type = "item"}}

        if items[parsed_result_name] and items[parsed_result_name].auto_recycle then
            items[parsed_result_name].auto_recycle = false
        end
        recycleRecipe(parsed_recipe_name, {
            ingredient = parsed_result_name,
            amount = cost/amount,
            result = component_name
        })
        return recipe
    end
    return nil
end

local fromComponentRecipie = function(combo_name, component_name, cost, amount)
    local parsed_result_name = ""
    local parsed_recipe_name = ""
    if type(combo_name) == "string" then
        parsed_result_name = combo_name
        parsed_recipe_name = combo_name
    else
        parsed_result_name = combo_name.item
        parsed_recipe_name = combo_name.recipe
    end
    cost = cost or 1
    amount = amount or 1

    local recipe = fromComponentRecipieStep(parsed_result_name, parsed_recipe_name, component_name, cost, amount)
    if recipe == nil then
        log("Failed to lookup recipie for " .. parsed_recipe_name)
    end
    return recipe
end

local assignComponentToEntity = function(result_type, result_name, component_name, cost, retrieve_base)
    cost = cost or 1
    local component_item = itemLookup(component_name)
    local parsed_item_name = ""
    local parsed_entity_name = ""
    local parsed_retrieve_base = true
    if retrieve_base ~= nil then
        parsed_retrieve_base = retrieve_base
    end
    if type(result_name) == "string" then
        parsed_item_name = result_name
        parsed_entity_name = result_name
    else
        parsed_item_name = result_name.item_name
        parsed_entity_name = result_name.entity_name
    end
    local entity = data.raw[result_type][parsed_entity_name]

    if entity and component_item then
        if settings.startup["affordance-retrieve-base"].value and parsed_retrieve_base then
            entity.minable.results = {{name = component_name, amount = cost, type = "item"}}
            entity.minable.result = nil
            entity.factoriopedia_alternative = parsed_entity_name
        end

        if settings.startup["affordance-place-with-base"].value then
            entity.placeable_by = {{item = component_name, count = cost}}
            local afforded_item = itemLookup(parsed_item_name)

            if afforded_item then
                pipetteOverrides[parsed_entity_name] = parsed_item_name
            else
                log("Failed to register pipette override for " .. parsed_entity_name .. " because " .. parsed_item_name .. " is a nil item")
            end

            -- an item's order seems to matter to an entity's placeable_by
            handleItemOrder(component_name, parsed_item_name)
        end
    elseif settings.startup["affordance-retrieve-base"].value or settings.startup["affordance-place-with-base"].value then
        if component_item == nil then
            log("Failed to assign entity to component for " .. parsed_entity_name .. " because " .. component_name .. " is a nil item")
        end
        if entity == nil then
            log("Failed to assign entity to component for " .. parsed_entity_name .. " because it is a nil entity of type " .. result_type)
        end
    end
end

local attachComponentToItem = function(result_type, result_name, component_name, cost, retrieve_base)
    cost = cost or 1
    local parsed_result_name = ""
    if type(result_name) == "string" then
        parsed_result_name = result_name
    else
        parsed_result_name = result_name.item_name
    end

    log(string.format("[%s][%s][%s]", result_type, parsed_result_name, component_name))
    assignComponentToEntity(result_type, result_name, component_name, cost, retrieve_base)
    fromComponentRecipie(parsed_result_name, component_name, cost)
end

local attachComponentToTile = function(result_name, component_name, cost, rotation_types)
    cost = cost or 1
    local parsed_item_name = ""
    local parsed_entity_name = ""
    if type(result_name) == "string" then
        parsed_item_name = result_name
        parsed_entity_name = result_name
    else
        parsed_item_name = result_name.item_name
        parsed_entity_name = result_name.entity_name
    end

    local rotation_types_to_iterate = rotation_types
    if rotation_types_to_iterate == nil then
        rotation_types_to_iterate = tile_rotation_types
    end

    for _, rotation_type in ipairs(rotation_types_to_iterate) do
        local prefix = rotation_type.prefix or ""
        local postfix = rotation_type.postfix or ""
        local current_result_name = prefix .. parsed_entity_name .. postfix
        log(string.format("[tile][%s][%s]", current_result_name, component_name))
        assignComponentToEntity("tile", {item_name = parsed_item_name, entity_name = current_result_name}, component_name, cost, false)
    end

    fromComponentRecipie(parsed_item_name, component_name, cost)
end

local function attachComponentsToItem(component_setting_name, allowed_values, result_type, prefix, postfix)
    prefix = prefix or ""
    postfix = postfix or ""
    local doComponentAffordanceSettingName = string.format("%ss", component_setting_name)
    if settings.startup[doComponentAffordanceSettingName] and not settings.startup[doComponentAffordanceSettingName].value then
        return
    end

    local component_name = settings.startup[string.format("%s-base", component_setting_name)].value

    for _, result_name in ipairs(allowed_values) do
        if result_name ~= component_name then
            local local_type = result_type
            local lookup_type = item_affordance_entity_type_lookup[result_name]
            if lookup_type ~= nil then
                local_type = lookup_type
            end

            if local_type == nil then
                attachComponentToItem(result_name, result_name, component_name)
            else
                attachComponentToItem(local_type, prefix .. result_name .. postfix, prefix .. component_name .. postfix)
            end
        end
    end
end

return {
  fromComponentRecipie = fromComponentRecipie,
  assignComponentToEntity = assignComponentToEntity,
  attachComponentToItem = attachComponentToItem,
  attachComponentsToItem = attachComponentsToItem,
  attachComponentToTile = attachComponentToTile,
  itemLookup = itemLookup
}