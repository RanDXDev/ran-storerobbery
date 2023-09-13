---@diagnostic disable: duplicate-set-field
ESX = exports["es_extended"]:getSharedObject()
local ox_inventory = exports.ox_inventory

function Functions.GetItemLabel(itemname)
    local item = ox_inventory:Items(itemname)
    return item and item.label
end

function Functions.Notify(text, type)
    ESX.ShowNotification(text, type)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerLoaded = true
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
    PlayerLoaded = false
end)


AddEventHandler('onResourceStart', function(resourceName)
    if cache.resource ~= resourceName or not ESX.IsPlayerLoaded() then return end
    PlayerLoaded = true
end)

RegisterNetEvent('ran-storerobbery:client:setCopCount', function(count)
    CopCount = count
end)
