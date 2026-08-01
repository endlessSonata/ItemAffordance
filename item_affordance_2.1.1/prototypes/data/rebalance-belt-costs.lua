local componentUtil = require("component-util")
local recipes = data.raw.recipe
local items = data.raw.item
local modules = data.raw.module

local function multiplyRecipieBatch(recipe, cost_mult, result_mult)
    if not recipe then
        return
    end

    if recipe.energy_required then
        recipe.energy_required = recipe.energy_required * cost_mult
    else
        recipe.energy_required = 0.5 * cost_mult
    end

    if recipe.overload_multiplier then
        recipe.overload_multiplier = recipe.overload_multiplier * cost_mult
    end

    if recipe.ingredients then
        for _, ingredient in ipairs(recipe.ingredients) do
            if ingredient.amount then
                ingredient.amount = ingredient.amount * cost_mult
            end
        end
    end

    if recipe.results then
        for _, result in ipairs(recipe.results) do
            if result.amount then
                result.amount = result.amount * result_mult
            end
            if result.amount_min then
                result.amount_min = result.amount_min * result_mult
            end
            if result.amount_max then
                result.amount_max = result.amount_max * result_mult
            end
        end
    end
end

local function handleRecipe(name, mult, additional)
    local recipe = recipes[name]
    if recipe then
        multiplyRecipieBatch(recipe, mult.input or 1, mult.output or 1)
        for _, ingredient in ipairs(additional) do
            local item = componentUtil.itemLookup(ingredient.name)
            if item then
                ingredient.type = "item"
                table.insert(recipe.ingredients, ingredient)
            end
        end
    end
end

local skip_belts = not settings.startup["belt-components"].value or not settings.startup["belt-component-rebalance"].value

return {
    data_rebalance = function()
        if skip_belts then
            return
        end

        if mods["pycoalprocessing"] then
            handleRecipe("transport-belt", {input = 6, output = 5}, {{name = "copper-plate", amount = 2}})
            handleRecipe("fast-transport-belt", {input = 12, output = 10}, {{name = "advanced-circuit", amount = 1}, {name = "chromium", amount = 1}})
            handleRecipe("express-transport-belt", {input = 40, output = 20}, {{name = "advanced-circuit", amount = 3}})
        elseif mods["bobelectronics"] then
            handleRecipe("transport-belt", {input = 10, output = 10}, {{name = "bob-basic-circuit-board", amount = 1}})
            handleRecipe("fast-transport-belt", {input = 16, output = 14}, {{name = "electronic-circuit", amount = 3}})
            handleRecipe("express-transport-belt", {input = 36, output = 30}, {{name = "advanced-circuit", amount = 5}})
        elseif mods["Krastorio2"] then
            handleRecipe("transport-belt", {input = 6, output = 5}, {{name = "kr-iron-beam", amount = 1}})
            handleRecipe("fast-transport-belt", {input = 8, output = 7}, {{name = "electronic-circuit", amount = 2}})
            handleRecipe("express-transport-belt", {input = 10, output = 9}, {{name = "kr-electronic-components", amount = 5}})
            handleRecipe("kr-advanced-transport-belt", {input = 10, output = 7}, {{name = "advanced-circuit", amount = 1}})
            handleRecipe("kr-superior-transport-belt", {input = 12, output = 7}, {{name = "processing-unit", amount = 1}})
        else
            --vanilla recipes
            handleRecipe("transport-belt", {input = 6, output = 5}, {{name = "copper-plate", amount = 2}})
            handleRecipe("fast-transport-belt", {input = 12, output = 10}, {{name = "electronic-circuit", amount = 1}})
            handleRecipe("express-transport-belt", {input = 36, output = 30}, {{name = "advanced-circuit", amount = 5}})
        end

        if mods["space-age"] then
            handleRecipe("turbo-transport-belt", {input = 60, output = 50}, {{name = "processing-unit", amount = 7}})
        end

        if mods["AdvancedBeltsSA"] then
            handleRecipe("extreme-belt", {input = 60, output = 50}, {{name = "superconductor", amount = 10}})
            handleRecipe("ultimate-belt", {input = 30, output = 25}, {{name = "supercapacitor", amount = 10}})
            handleRecipe("high-speed-belt", {input = 12, output = 10}, {{name = "quantum-processor", amount = 1}})
        end

        if mods["boblogistics"] then
            handleRecipe("bob-turbo-transport-belt", {input = 36, output = 30}, {{name = "processing-unit", amount = 7}})

            if componentUtil.itemLookup("bob-advanced-processing-unit") then
                handleRecipe("bob-ultimate-transport-belt", {input = 38, output = 34}, {{name = "bob-advanced-processing-unit", amount = 7}})
            else
                handleRecipe("bob-ultimate-transport-belt", {input = 38, output = 34}, {{name = "processing-unit", amount = 9}})
            end
        end

        if mods["more-belts"] then
            handleRecipe("ddi-transport-belt-mk4", {input = 60, output = 50}, {{name = "advanced-circuit", amount = 7}})
            handleRecipe("ddi-transport-belt-mk5", {input = 60, output = 50}, {{name = "processing-unit", amount = 7}})
            handleRecipe("ddi-transport-belt-mk6", {input = 60, output = 55}, {{name = "productivity-module", amount = 1}})
            handleRecipe("ddi-transport-belt-mk7", {input = 60, output = 55}, {{name = "productivity-module-2", amount = 1}})
            handleRecipe("ddi-transport-belt-mk8", {input = 60, output = 55}, {{name = "productivity-module-3", amount = 1}})
        end
    end,
    data_updates_rebalance = function()
        if skip_belts then
            return
        end

        if mods["space-exploration"] then
            handleRecipe("se-space-transport-belt", {input = 12, output = 10}, {{name = "advanced-circuit", amount = 2}})
            handleRecipe("se-deep-space-transport-belt-black", {input = 12, output = 10}, {{name = "se-heavy-assembly", amount = 1}, {name = "se-naquium-cube", amount = 2}})
        end

        if mods["promethium-belts"] or mods["promethium-belts-rebalance"] then
            handleRecipe("promethium-transport-belt", {input = 60, output = 50}, {{name = "quantum-processor", amount = 3}})
        end
    end
}
