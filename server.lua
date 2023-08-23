local QBCore = exports['qb-core']:GetCoreObject()

local function SetupStore()
    TriggerClientEvent("ran-storerobbery:client:setConfigs", -1, Config.Store)
end

local function SendLog(title, content)

end

local function GenerateCombination()
    return QBCore.Shared.RandomInt(4)
end

RegisterNetEvent("ran-storerobbery:server:getConfig", function()
    local src = source
    TriggerClientEvent("ran-storerobbery:client:setConfigs", src, Config.Store)
end)

RegisterNetEvent("ran-storerobbery:server:setUse", function(storeid, regid, status)
    local storeConfig = Config.Store[storeid]
    if not storeConfig then return end
    local regConfig = storeConfig.registar[regid]
    if not regConfig then return end
    regConfig.isusing = status
    TriggerClientEvent("ran-storerobbery:client:setStoreConfig", -1, storeid, storeConfig)
end)

AddEventHandler('onResourceStart', function(resource)
    if resource ~= cache.resource then return end
    SetupStore()
end)

RegisterNetEvent("ran-houserobbery:server:setHackedState", function(storeid)
    local cfg = Config.Store[storeid]
    if not cfg then
        warn("No config found for " .. storeid)
        return
    end
    cfg.hack.hacked = true
    TriggerClientEvent("ran-storerobbery:client:setStoreConfig", -1, storeid, cfg)
end)

lib.callback.register("ran-houserobbery:server:getPrize", function(source, prize, storeid, regid)
    local config = Config.Store[storeid]
    if not config then return end
    local regConfig = config.registar[regid]
    if not regConfig then return end
    regConfig.robbed = true
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if not xPlayer then return end
    if Config.Prize.item then
        xPlayer.Functions.AddItem(Config.Prize.item, prize, nil, nil)
    else
        xPlayer.Functions.AddMoney('cash', prize, 'rob')
    end
    QBCore.Debug(xPlayer)
    TriggerClientEvent("ran-storerobbery:client:setStoreConfig", -1, storeid, config)
    return true
end)

lib.callback.register("ran-storerobbery:server:combination", function(source, storeid, sid, status)
    local cfg = Config.Store[storeid]
    if not cfg then return end
    local scfg = cfg.search[sid]
    if not scfg then return end
    if status then
        local combination = GenerateCombination()
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if not xPlayer then return end
        xPlayer.Functions.AddItem('stickynote', 1, nil, {
            combination = combination
        })
        cfg.combination = combination
    end
    scfg.searched = true
    print(lib.table.matches(cfg, Config.Store[storeid]))
    TriggerClientEvent("ran-storerobbery:client:setStoreConfig", -1, storeid, cfg)
    return true
end)
