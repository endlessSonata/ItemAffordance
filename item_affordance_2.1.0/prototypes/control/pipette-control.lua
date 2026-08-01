if not settings.startup["affordance-place-with-base"].value then
    return
end

-- this patch was originally written by Shemp:
-- https://mods.factorio.com/mod/item_affordance/discussion/69ae16dfa15769a7e3ac4788
-- i have made some slight changes, but this would not have been possible without thier input

-- Maps entity name -> item name
local pipetteOverrides = prototypes["mod_data"]["item_affordance-entity-to-item-list"].data

local function handleAutocraft(player, name, quality)
    local recipe = prototypes.recipe[name]
    if recipe and pipetteOverrides[name] then
        local products = recipe.products
        local ingredients = recipe.ingredients
        local inventory = player.get_main_inventory()
        if products and products[1] and 1 == #(products)
        and ingredients and ingredients[1] and 1 == #(ingredients)
        and inventory and inventory.can_insert({name=products[1].name, count=(products[1].amount or 1), quality=quality})
        and inventory.get_item_count({name=products[1].name, quality=quality}) < 1
        and inventory.get_item_count({name=ingredients[1].name, quality=quality}) > (ingredients[1].amount or 1) then
            inventory.remove({name=ingredients[1].name, count=(ingredients[1].amount or 1), quality=quality})
            inventory.insert({name=products[1].name, count=(products[1].amount or 1), quality=quality})
        end
    end
end

local function delayedPipette(player, name, quality)
    local proto = prototypes.item[name]
    if proto and player.valid and player.connected then
        local success = player.clear_cursor()
        if success then
            player.pipette(proto, quality, true)
        end
    end
end

local function getTaskQueue()
    return storage.taskQueue
end

local function enqueueTask(task, delay, data)
    local tick = delay + game.tick
    local entry = {
        task = task,
        data = data,
    }

    local queue = getTaskQueue()
    if queue[tick] then
        table.insert(queue[tick], entry)
    else
        queue[tick] = {entry}
    end
end

local function handleTick()
    local queue = getTaskQueue()
    local tasks = queue[game.tick]
    if tasks then
        for _, entry in pairs(tasks) do
            if entry.task == "iaPipette" then
                delayedPipette(entry.data.player,
                    entry.data.name,
                    entry.data.quality)
            end
        end
        queue[game.tick] = nil
    end
end
script.on_event(defines.events.on_tick, handleTick)

script.on_event("item_affordance-pipette", function(e)
    if not settings.get_player_settings(e.player_index)["affordance-pipette-overrides"].value then return end
    local player = game.get_player(e.player_index)
    if player == nil or not player.is_cursor_empty() then return end

    local entity = player.selected
    if entity then
        local name = entity.name
        if name and (name == "entity-ghost" or name == "tile-ghost") and entity.ghost_name then
            name = entity.ghost_name
        end
        if pipetteOverrides[name] then
            local data = {
                player = player,
                name = pipetteOverrides[name],
                quality = entity.quality,
            }
            if settings.get_player_settings(e.player_index)["affordance-pipette-autocraft"].value then
                handleAutocraft(data.player, data.name, data.quality)
            end
            enqueueTask("iaPipette", 1, data)
        end
    end
end)

-- Ensure the queue exists before on_tick touches it
local function setupStorage()
    storage.taskQueue = storage.taskQueue or {}
end
script.on_init(setupStorage)
script.on_configuration_changed(setupStorage)