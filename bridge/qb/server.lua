---@diagnostic disable: duplicate-set-field
QBCore = exports['qb-core']:GetCoreObject()
local ox_inventory = exports.ox_inventory

function Functions.AddItem(src, itemname, count, metadata)
    local xPlayer = QBCore.Functions.GetPlayer(src)
    if not xPlayer then return end
    xPlayer.Functions.AddItem(itemname, count, nil, metadata)
end

function Functions.NotifyClient(src, text)
    TriggerClientEvent("QBCore:Notify", src, text)
end

function Functions.RegisterSafe(storeid, items)
    local config = Config.Store[storeid]
    if not config then return end
    if config.safe.opened and config.safe.id then return end
    if Config.Inventory == "qb" then
        local stashid = RandomStr(2) .. RandomInt(2) .. RandomStr(2)
        for _, v in pairs(items) do
            ---@type string
            local itemname = v[1]
            ---@type number
            local itemCount = v[2]
            local itemInfo = QBCore.Shared.Items[itemname]
            if itemInfo then
                items[#items + 1] = {
                    name = itemInfo.name,
                    amount = tonumber(itemCount),
                    info = {},
                    label = itemInfo.label,
                    description = itemInfo.description ~= nil and itemInfo.description or "",
                    weight = itemInfo.weight,
                    type = itemInfo.type,
                    unique = itemInfo.unique,
                    useable = itemInfo.useable,
                    image = itemInfo.image,
                    slot = #items + 1
                }
            else
                warn("Can't find iteminfo for " .. itemname)
            end
        end
        MySQL.insert.await(
            "INSERT INTO stashitems (stash, items) VALUES (:stash, :items) ON DUPLICATE KEY UPDATE items = :items", {
                ['stash'] = stashid,
                ['items'] = json.encode(items)
            })
        return stashid
    elseif Config.Inventory == "ox" then
        return ox_inventory:CreateTemporaryStash({
            label = "Safe",
            slots = 10,
            maxWeight = 100000,
            items = items
        })
    end
end

function Functions.GetJob(src)
    local xPlayer = QBCore.Functions.GetPlayer(src)
    if not xPlayer then return end
    local job = xPlayer.PlayerData.job
    return job and job.name
end

function Functions.ItemExist(itemname)
    if not itemname then return end
    if Config.Inventory == "qb" then
        return QBCore.Shared.Items[Config.Prize.item]
    elseif Config.Inventory == "ox" then
        return ox_inventory:Items(itemname)
    end
end

function Functions.CreateUseableItem(itemname, cb)
    QBCore.Functions.CreateUseableItem(itemname, function(source, item)
        cb(source, item)
    end)
end
