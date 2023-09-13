---@diagnostic disable: duplicate-set-field
QBCore = exports['qb-core']:GetCoreObject()
local ox_inventory = exports.ox_inventory
local PlayerData = {}

function Functions.Notify(text, type)
    QBCore.Functions.Notify(text, type)
end

function Functions.GetItemLabel(itemname)
    if Config.Inventory == "qb" then
        local item = QBCore.Shared.Items[itemname]
        return item and item.label
    elseif Config.Inventory == "ox" then
        local item = ox_inventory:Items(itemname)
        return item and item.label
    end
end

---@diagnostic disable-next-line: param-type-mismatch
AddStateBagChangeHandler('isLoggedIn', nil, function(_bagName, _key, value, _reserved, _replicated)
    if value then
        PlayerData = QBCore.Functions.GetPlayerData()
        if Config.Inventory == "ox" then
            ox_inventory:displayMetadata({
                combination = "Combination"
            })
        end
    else
        table.wipe(PlayerData)
    end
    PlayerLoaded = value
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(newPlayerData)
    local invokingResource = GetInvokingResource()
    if invokingResource and invokingResource ~= 'qb-core' then return end
    PlayerData = newPlayerData
end)

AddEventHandler('onResourceStart', function(resourceName)
    if cache.resource ~= resourceName or not LocalPlayer.state.isLoggedIn then return end
    PlayerData = QBCore.Functions.GetPlayerData()
    PlayerLoaded = true
end)

RegisterNetEvent("police:SetCopCount", function(amount)
    CopCount = amount
end)
