local componentUtil = require("component-util")
local recipes = data.raw.recipe

local function assignPipeToGround(pipe_name, pipe_to_ground_name, cost)
    componentUtil.assignComponentToEntity("pipe-to-ground", pipe_to_ground_name, pipe_name, cost)
    componentUtil.fromComponentRecipie(pipe_to_ground_name, pipe_name, cost * 2, 2)
end

return {
    data = function()
        if not settings.startup["pipe-components"].value then
            return
        end

        if data.raw.technology["foundry"] and mods["5dim_core"] == nil then
            local effects = data.raw.technology["foundry"].effects
            local removeIndex = nil
            local maxIndex = nil
            for index, value in ipairs(effects) do
                if value.type == "unlock-recipe" and value.recipe == "casting-pipe-to-ground" then
                    removeIndex = index
                end
                maxIndex = index
            end
            if removeIndex ~= nil then
                effects[removeIndex] = nil
                if removeIndex ~= maxIndex then
                    effects[removeIndex] = effects[maxIndex]
                    effects[maxIndex] = nil
                end
            end
            recipes["casting-pipe-to-ground"] = nil
        end

        if mods["Flow Control"] then
            componentUtil.attachComponentToItem("storage-tank", "pipe-elbow", "pipe")
            componentUtil.attachComponentToItem("storage-tank", "pipe-junction", "pipe")
            componentUtil.attachComponentToItem("storage-tank", "pipe-straight", "pipe")
        end

        if mods["5dim_transport"] then
            assignPipeToGround("pipe", "5d-pipe-to-ground-mk1-30", 16)
            assignPipeToGround("pipe", "5d-pipe-to-ground-mk1-50", 26)
        end

        if mods["angelspetrochem"] then
            componentUtil.attachComponentToItem("valve", "angels-valve-one-way", "angels-valve-inspector")
            componentUtil.attachComponentToItem("valve", "angels-valve-overflow", "angels-valve-inspector")
            componentUtil.attachComponentToItem("valve", "angels-valve-top-up", "angels-valve-inspector")
        end

        if mods["Krastorio2"] then
            assignPipeToGround("kr-steel-pipe", "kr-steel-pipe-to-ground", 8)
        end

        if mods["pyindustry"] then
            if mods["pycoalprocessing"] then
                assignPipeToGround("niobium-pipe", "niobium-pipe-to-ground", 5)
            else
                assignPipeToGround("niobium-pipe", "niobium-pipe-to-ground", 4)
            end

            if mods["pyhightech"] then
                assignPipeToGround("ht-pipes", "ht-pipes-to-ground", 5)
            end

            componentUtil.attachComponentToItem("valve", "py-underflow-valve", "py-overflow-valve")
        end
    end,
    data_updates = function()
        if not settings.startup["pipe-components"].value then
            return
        end
        assignPipeToGround("pipe", "pipe-to-ground", 4)

        if mods["valves"] then
            componentUtil.attachComponentToItem("valve", "valves-top_up", "valves-one_way")
            componentUtil.attachComponentToItem("valve", "valves-overflow", "valves-one_way")
        end

        if mods["boblogistics"] then
            assignPipeToGround("bob-copper-pipe", "bob-copper-pipe-to-ground", 4)
            assignPipeToGround("bob-stone-pipe", "bob-stone-pipe-to-ground", 4)
            assignPipeToGround("bob-bronze-pipe", "bob-bronze-pipe-to-ground", 8)
            assignPipeToGround("bob-steel-pipe", "bob-steel-pipe-to-ground", 8)
            assignPipeToGround("bob-plastic-pipe", "bob-plastic-pipe-to-ground", 10)
            assignPipeToGround("bob-brass-pipe", "bob-brass-pipe-to-ground", 10)
            assignPipeToGround("bob-titanium-pipe", "bob-titanium-pipe-to-ground", 12)
            assignPipeToGround("bob-ceramic-pipe", "bob-ceramic-pipe-to-ground", 12)
            assignPipeToGround("bob-tungsten-pipe", "bob-tungsten-pipe-to-ground", 12)
            assignPipeToGround("bob-nitinol-pipe", "bob-nitinol-pipe-to-ground", 14)
            assignPipeToGround("bob-copper-tungsten-pipe", "bob-copper-tungsten-pipe-to-ground", 14)

            componentUtil.attachComponentToItem("valve", "bob-overflow-valve", "pipe", 2)
            componentUtil.attachComponentToItem("valve", "bob-topup-valve", "pipe", 2)
            componentUtil.attachComponentToItem("valve", "bob-valve", "pipe", 2)

            componentUtil.attachComponentToItem("storage-tank", "bob-small-storage-tank", "bob-small-inline-storage-tank")
            componentUtil.attachComponentToItem("storage-tank", "bob-storage-tank-all-corners", "storage-tank")
            componentUtil.attachComponentToItem("storage-tank", "bob-storage-tank-all-corners-2", "bob-storage-tank-2")
            componentUtil.attachComponentToItem("storage-tank", "bob-storage-tank-all-corners-3", "bob-storage-tank-3")
            componentUtil.attachComponentToItem("storage-tank", "bob-storage-tank-all-corners-4", "bob-storage-tank-4")
        end

        if mods["space-exploration"] then
            assignPipeToGround("se-space-pipe", "se-space-pipe-to-ground", 5)

            componentUtil.attachComponentToItem("storage-tank", "se-space-pipe-long-j-3", "se-space-pipe", 2)
            componentUtil.attachComponentToItem("storage-tank", "se-space-pipe-long-j-5", "se-space-pipe", 3)
            componentUtil.attachComponentToItem("storage-tank", "se-space-pipe-long-j-7", "se-space-pipe", 4)
            componentUtil.attachComponentToItem("storage-tank", "se-space-pipe-long-s-9", "se-space-pipe", 5)
            componentUtil.attachComponentToItem("storage-tank", "se-space-pipe-long-s-15", "se-space-pipe", 8)
        end
    end
}