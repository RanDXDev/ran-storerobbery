---@diagnostic disable: duplicate-set-field
ESX = exports["es_extended"]:getSharedObject()
local ox_inventory = exports.ox_inventory

function Functions.CreateUseableItem(itemname, cb)
    ESX.RegisterUsableItem(itemname, function(playerid, _, metadata)
        cb(playerid, metadata)
    end)
end

function Functions.NotifyClient(src, text)
    TriggerClientEvent('esx:showNotification', src, text)
end

function Functions.AddItem(src, itemname, count, metadata)
    ox_inventory:AddItem(src, itemname, count, metadata)
end

function Functions.RegisterSafe(storeid, items)
    return ox_inventory:CreateTemporaryStash({
        label = "Safe",
        slots = 10,
        maxWeight = 100000,
        items = items
    })
end

function Functions.GetJob(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    local job = xPlayer.getJob()
    return job and job.name
end

function Functions.ItemExist(itemname)
    if not itemname then return end
    return ox_inventory:Items(itemname)
end

function Functions.AddMoney(src, type, amount)
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    if type == "cash" then
        type = "money"
    end
    xPlayer.addAccountMoney(type, amount)
end

function SetCopCount()
    local police = ESX.GetExtendedPlayers('job', 'police')
    TriggerClientEvent("ran-storerobbery:client:setCopCount", -1, #police)
    SetTimeout(10000, SetCopCount)
end

CreateThread(function()
    Wait(1000)
    SetCopCount()
end)
