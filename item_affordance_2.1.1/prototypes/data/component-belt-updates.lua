local componentUtil = require("component-util")
local subgroups = data.raw["item-subgroup"]

if not settings.startup["belt-components"].value then
    return
end

local function modifyBelt(type, name, component, cost, amount, subgroup)
    local item = componentUtil.itemLookup(name)
    if item and data.raw.recipe[name] and data.raw[type][name] then
        componentUtil.assignComponentToEntity(type, name, component, cost)
        if type == "underground-belt" then
            cost = cost * 2
        end

        local recipe = componentUtil.fromComponentRecipie(name, component, cost, amount)
        if mods["space-age"] and recipe then
            table.insert(recipe.categories , "metallurgy")
        end

        if subgroup and subgroups[subgroup] then
            item.subgroup = subgroup
        end
    end
end

local lane_splitter_subgroup = nil
local lane_splitter_cost = not settings.startup["belt-component-cost-lane-splitter"] and 6 or settings.startup["belt-component-cost-lane-splitter"].value

if mods["space-exploration"] and (mods["lane-splitters"] or mods["lane-balancers"]) and data.raw["item-subgroup"]["splitter"] then
    lane_splitter_subgroup = "splitter"
end

for _, tier in ipairs(item_affordance_belt_tiers) do
    local prefix = tier.prefix or ""
    local postfix = tier.postfix or ""

    local beltName = GLOBAL_UTIL.hypenFix(string.format("%stransport-belt%s", prefix, postfix))
    local item = componentUtil.itemLookup(beltName)
    if item == nil then
        -- if you are reading this as an aspiring mod author who wants to add your own belt tier to the game, then please pay attetion to the item and entity naming standards
        -- most of this logic is because of AdvancedBeltsSA
        beltName = GLOBAL_UTIL.hypenFix(string.format("%sbelt%s", prefix, postfix))
        item = componentUtil.itemLookup(beltName)
        if item == nil then
            log("no mating belt for prefix " .. prefix .. " and postfix " .. postfix)
            return
        end
    end

    if item.stack_size < 100 then
        item.stack_size = 100
    end

    if tier.base_override then
        modifyBelt("transport-belt", beltName, tier.base_override, 1)
        beltName = tier.base_override
    end

    local undergroundName = GLOBAL_UTIL.hypenFix(string.format("%sunderground-belt%s", prefix, postfix))
    modifyBelt("underground-belt", undergroundName, beltName, settings.startup["belt-component-cost-underground-belt"].value, 2)
    undergroundName = GLOBAL_UTIL.hypenFix(string.format("%sunderground%s", prefix, postfix))
    modifyBelt("underground-belt", undergroundName, beltName, settings.startup["belt-component-cost-underground-belt"].value, 2)

    local splitterName = GLOBAL_UTIL.hypenFix(string.format("%ssplitter%s", prefix, postfix))
    modifyBelt("splitter", splitterName, beltName, settings.startup["belt-component-cost-splitter"].value)

    local laneSplitterName = GLOBAL_UTIL.hypenFix(string.format("%slane-splitter%s", prefix, postfix))
    modifyBelt("lane-splitter", laneSplitterName, beltName, lane_splitter_cost, 1, lane_splitter_subgroup)
    laneSplitterName = GLOBAL_UTIL.hypenFix(string.format("%slanesplitter%s", prefix, postfix))
    modifyBelt("lane-splitter", laneSplitterName, beltName, lane_splitter_cost, 1, lane_splitter_subgroup)
    if mods["more-belts"] then
        laneSplitterName = GLOBAL_UTIL.hypenFix(string.format("%slane-splitter", postfix))
        modifyBelt("lane-splitter", laneSplitterName, beltName, lane_splitter_cost, 1, lane_splitter_subgroup)
    end

    if settings.startup["belt-component-loaders-enabled"].value then
        --"base game" loaders for any mod that names them correctly
        local baseLoader2Name = GLOBAL_UTIL.hypenFix(string.format("%sloader%s", prefix, postfix))
        modifyBelt("loader", baseLoader2Name, beltName, 80)
        local baseLoader1Name = GLOBAL_UTIL.hypenFix(string.format("%sloader-1x1%s", prefix, postfix))
        modifyBelt("loader-1x1", baseLoader1Name, beltName, 100)
        baseLoader1Name = GLOBAL_UTIL.hypenFix(string.format("%sloader%s", prefix, postfix))
        modifyBelt("loader-1x1", baseLoader1Name, beltName, 100)

        --AAI loaders
        if mods["aai-loaders"] and settings.startup["aai-loaders-mode"].value ~= "graphics-only" then
            local aaiLoaderName = GLOBAL_UTIL.hypenFix(string.format("aai-%s%sloader", prefix, postfix))
            modifyBelt("loader-1x1", aaiLoaderName, beltName, settings.startup["aai-loaders-mode"].value == "lubricated" and 4 or 100)
        end

        --comfortable loaders
        if mods["comfortable-loader"] then
            local comfortableLoaderName = GLOBAL_UTIL.hypenFix(string.format("%scomfortable-loader%s", prefix, postfix))
            modifyBelt("loader-1x1", comfortableLoaderName, beltName, 100)
        end

        --deadlock loaders
        if mods["deadlock-beltboxes-loaders"] then
            local deadlockLoaderName = GLOBAL_UTIL.hypenFix(string.format("%stransport-belt-loader%s", prefix, postfix))
            modifyBelt("loader-1x1", deadlockLoaderName, beltName, 100)
            deadlockLoaderName = GLOBAL_UTIL.hypenFix(string.format("%sbelt-loader%s", prefix, postfix))
            modifyBelt("loader-1x1", deadlockLoaderName, beltName, 100)
        end

        if mods["loaders-modernized"] then
            local modernizedLoaderName = GLOBAL_UTIL.hypenFix(string.format("%smdrn-loader%s", prefix, postfix))
            modifyBelt("loader-1x1", modernizedLoaderName, beltName, 100)
        end

        if mods["Krastorio2"] then
            local krastorioLoaderName = GLOBAL_UTIL.hypenFix(string.format("kr-%sloader%s", prefix, postfix))
            modifyBelt("loader-1x1", krastorioLoaderName, beltName, 100)
        end
    end

    if mods["deadlock-beltboxes-loaders"] then
        local deadlockBeltboxName = GLOBAL_UTIL.hypenFix(string.format("%stransport-belt-beltbox%s", prefix, postfix))
        modifyBelt("furnace", deadlockBeltboxName, beltName, settings.startup["belt-component-cost-beltbox"].value)
        deadlockBeltboxName = GLOBAL_UTIL.hypenFix(string.format("%sbelt-beltbox%s", prefix, postfix))
        modifyBelt("furnace", deadlockBeltboxName, beltName, settings.startup["belt-component-cost-beltbox"].value)
    end

    if mods["5dim_transport"] then
        local underground30Name = GLOBAL_UTIL.hypenFix(string.format("%sunderground-belt-30%s", prefix, postfix))
        modifyBelt("underground-belt", underground30Name, beltName, 16, 2)

        local underground50Name = GLOBAL_UTIL.hypenFix(string.format("%sunderground-belt-50%s", prefix, postfix))
        modifyBelt("underground-belt", underground50Name, beltName, 26, 2)
    end

    if mods["dredgeworks"] then
        local dredgeworksFloatingBeltName = GLOBAL_UTIL.hypenFix(string.format("floating-%stransport-belt%s", prefix, postfix))
        modifyBelt("transport-belt", dredgeworksFloatingBeltName, beltName, 2)
        local item = componentUtil.itemLookup(dredgeworksFloatingBeltName)
        if item then
            local order = item.order
            if order then
                item.order = "zz[floating-belt]-" .. item.order
            else
                item.order = "zz[floating-belt]-unknown"
            end
        end
    end
end

if mods["5dim_transport"] then
    modifyBelt("loader-1x1", "5d-loader-1x1-01", "transport-belt", 100)
    modifyBelt("loader-1x1", "5d-loader-1x1-02", "fast-transport-belt", 100)
    modifyBelt("loader-1x1", "5d-loader-1x1-03", "express-transport-belt", 100)
    if mods["space-age"] then
        modifyBelt("loader-1x1", "5d-loader-1x1-04", "turbo-transport-belt", 100)
    end
end

if mods["loaders-modernized"] and componentUtil.itemLookup("transport-belt") then
    modifyBelt("loader-1x1", "chute-mdrn-loader", "transport-belt", 50)
end