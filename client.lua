local QBCore = exports['qb-core']:GetCoreObject()
local PlayerLoaded = false
local PlayerData = {}
local CurrentStore
local InRegZone, RegZoneID = false, nil
local TempStoreData = {}
local ox_inventory = exports.ox_inventory
local ox_target = exports.ox_target
local qb_target = exports['qb-target']
local CopCount = 0

local function SendDispatch()
    if GetResourceState("ps-dispatch") == "started" then
        exports['ps-dispatch']:StoreRobbery()
    end
end

local function Alert(id)
    local cfg = Config.Store[id]
    if not cfg then return end
    if cfg.alerted then return end
    cfg.alerted = true
    TriggerServerEvent("ran-storerobbery:server:registerAlert", id, true)
    if cfg?.hack?.delayCount then
        SetTimeout(1000 * cfg.hack.delayCount, function()
            SendDispatch()
            QBCore.Functions.Notify("The police has been notified", "error")
        end)
    else
        QBCore.Functions.Notify("The police has been notified", "error")
        SendDispatch()
    end
end

local function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local propmodel = joaat('prop_till_01')

---@param victim number
---@param culprit number
---@return nil
local function EntityDamage(victim, culprit)
    if culprit ~= cache.ped then return end
    if Config.MinPolice > CopCount then return end
    local alerted = false
    if not CurrentStore then return end
    if not TempStoreData then return end
    local cfg = Config.Store[CurrentStore]
    if cfg.alerted then return end
    if next(TempStoreData) == nil then return end
    local model = GetEntityModel(victim)
    if model == propmodel and not alerted then
        return Alert(CurrentStore)
    end
end

local function Enter(self)
    InRegZone = true
    RegZoneID = self.regid
end

local function Exit()
    InRegZone = false
    RegZoneID = nil
end

local function AllStashSearched(id)
    if not id then return end
    local cfg = Config.Store[id]
    if not cfg then return end
    local allsearched = true
    for k, v in pairs(cfg.search) do
        if not v.iscomputer and not v.searched then
            allsearched = false
            break
        end
    end
    return allsearched
end

local function RobRegistar()
    if not CurrentStore then return end
    if not RegZoneID or not InRegZone then
        QBCore.Functions.Notify("You need to stand in front of cashier", "error")
        return
    end
    if Config.MinPolice > CopCount then
        QBCore.Functions.Notify("Not enough cops", "error")
        return
    end
    local ped = cache.ped
    local StoreConfig = Config.Store[CurrentStore]
    if not StoreConfig then return end
    local RegConfig = StoreConfig.registar[RegZoneID]
    if RegConfig.robbed then
        return QBCore.Functions.Notify("There is no money in here", "error")
    end
    if not RegConfig then return end
    if RegConfig.isusing then
        return QBCore.Functions.Notify("Somebody is in the register")
    end
    TriggerServerEvent("ran-storerobbery:server:setUse", CurrentStore, RegZoneID, true)
    local anim = "oddjobs@shop_robbery@rob_till"
    local animname = "loop"
    lib.requestAnimDict(anim)
    TaskPlayAnim(ped, anim, animname, 8.0, 8.0, -1, 3, 1.0, false, false, false)
    local prize = math.floor(math.random(Config.Prize.min, Config.Prize.max))
    local success = exports['ran-minigames']:MineSweep(prize, 10, 3, "left")
    if success then
        local itemName = Config.Inventory == "ox" and ox_inventory:Items(Config.Prize.item).label or
            QBCore.Shared.Items[Config.Prize.item]?.label
        lib.callback("ran-houserobbery:server:getPrize", false, function(cb)
            QBCore.Functions.Notify(
                ("You got %s %s"):format(success,
                    Config.Prize.item and itemName or "Cash"), "success")
        end, success, CurrentStore, RegZoneID)
    end
    TaskPlayAnim(ped, anim, "exit", 8.0, 8.0, -1, 0, 1.0, false, false, false)
    TriggerServerEvent("ran-storerobbery:server:setUse", CurrentStore, RegZoneID, false)
end

local EData = nil

local function SearchCombination(storeid, sid)
    if Config.MinPolice > CopCount then
        QBCore.Functions.Notify("Not enough police", "error")
        return
    end
    local config = Config.Store[storeid]
    if not config then return end
    local searchLoc = config.search[sid]
    if not searchLoc then return end
    if config.cooldown then return end
    if config.combination then
        return QBCore.Functions.Notify("You already got the combination...")
    end
    if searchLoc.searched then
        return QBCore.Functions.Notify("You already search this place...")
    end
    Alert(storeid)
    if searchLoc.iscomputer then
        if not AllStashSearched(storeid) then
            return QBCore.Functions.Notify("You need to search all the cabinet first...", "error")
        end
        local animdict = 'anim@scripted@player@mission@tunf_bunk_ig3_nas_upload@'
        local anim     = 'normal_typing'
        lib.requestAnimDict(animdict)
        TaskPlayAnim(cache.ped, animdict, anim, 8.0, 8.0, -1, 1, 1.0, false, false, false)
        local success = exports['ran-minigames']:OpenTerminal()
        if success then
            local canGet = math.random(1, 100) > 20 and true or false
            if canGet then
                local TimeToWait = math.random(20, 30)
                searchLoc.searched = true
                QBCore.Functions.Notify("You need to wait " .. TimeToWait .. " seconds, to decrypt the code")
                SetTimeout(1000 * TimeToWait, function()
                    lib.callback.await("ran-storerobbery:server:combination", false, storeid, sid, true)
                    QBCore.Functions.Notify("You got the combination key")
                end)
            else
                lib.callback.await("ran-storerobbery:server:combination", false, storeid, sid, false)
                QBCore.Functions.Notify("Unable to get any information about pin from this computer", "error")
            end
        end
        ClearPedTasks(cache.ped)
    else
        QBCore.Functions.Progressbar('search-combination', 'Searching for combination', 5000, false, true,
            { -- Name | Label | Time | useWhileDead | canCancel
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = 'mini@repair',
                anim = 'fixing_a_ped',
                flags = 16,
            }, {}, {}, function() -- Play When Done
                local canGet = math.random(1, 100) > 90 and true or false
                lib.callback.await("ran-storerobbery:server:combination", false, storeid, sid, canGet)
                if canGet then
                    QBCore.Functions.Notify("You got the combination key")
                else
                    QBCore.Functions.Notify("You didn't get anything")
                end
                ClearPedTasks(cache.ped)
            end, function() -- Play When Cancel
                ClearPedTasks(cache.ped)
            end)
    end
end

local function SetupStore(id)
    local cfg = Config.Store[id]
    if not cfg then return end
    if cfg.cooldown then return end
    EData = AddEventHandler('entityDamaged', EntityDamage)
    local interior = GetInteriorAtCoords(cfg.coords.x, cfg.coords.y, cfg.coords.z)
    RefreshInterior(interior)
    repeat
        Wait(500)
    until IsInteriorReady(interior)
    local function UpdateConfig()
        if not lib.table.matches(cfg, Config.Store[id]) then
            cfg = Config.Store[id]
        end
    end
    TempStoreData.registar = {}
    for k, v in pairs(cfg.registar) do
        TempStoreData.registar[k] = {}
        TempStoreData.registar[k].zone = lib.zones.sphere({
            coords = v.coords.xyz,
            radius = 1.0,
            regid = k,
            onEnter = Enter,
            onExit = Exit
        })
    end
    local function Hack(self)
        if cfg.hack.isusing then return end
        if cfg.cooldown then return end
        local success = exports['ran-minigames']:MemoryCard()
        TriggerServerEvent("ran-storerobbery:server:setHackUse", id, true)
        if success then
            TriggerServerEvent("ran-houserobbery:server:setHackedState", self.storeid)
            Wait(500)
            Alert(id)
        end
        TriggerServerEvent("ran-storerobbery:server:setHackUse", id, false)
    end
    local function OpenPinPrompt()
        local input = lib.inputDialog("Pin", {
            {
                type = 'number',
                label = "Pin Number",
            }
        })
        if not input then return end
        if not input[1] then
            return QBCore.Functions.Notify("You need to fill the pin...", "error")
        end
        local num = tonumber(input[1])
        if num == cfg.combination then
            lib.callback.await("ran-storerobbery:server:setSafeState", false, CurrentStore, true)
            return QBCore.Functions.Notify("You unlocked the safe", "success")
        else
            return QBCore.Functions.Notify("Wrong pin number...", "error")
        end
    end
    local function InsideSafe(self)
        if Config.MinPolice > CopCount then return end
        if cfg.cooldown then return end
        ---@type vector3
        local coords = self.coords
        if cfg.safe.isopened then
            DrawText3D(coords.x, coords.y, coords.z, "[~g~E~w~] Open Safe")
        else
            DrawText3D(coords.x, coords.y, coords.z, "[~r~E~w~] Try pin")
        end
        if IsControlJustPressed(0, 46) then
            if cfg.safe.isopened and cfg.safe.id then
                if Config.Inventory == "qb" then
                    TriggerServerEvent("inventory:server:OpenInventory", "stash", cfg.safe.id,
                        { maxweight = 1000000, slots = 10 })
                    TriggerEvent("inventory:client:SetCurrentStash", cfg.safe.id)
                elseif Config.Inventory == "ox" then
                    ox_inventory:openInventory("stash", cfg.safe.id)
                end
            else
                OpenPinPrompt()
            end
        end
    end
    if cfg.hack then
        local options = {
            {
                label = "Hack",
                canInteract = function()
                    return not cfg.hack.hacked and not cfg.hack.isusing and not cfg.alerted and not cfg.cooldown
                end,
                storeid = id,
                distance = 1.0,
                icon = "fas fa-laptop",
            }
        }
        if Config.Target == "qb" then
            options[1].action = Hack
            options[1].item = "trojan_usb"
            local length = cfg.hack.size.x
            local width = cfg.hack.size.y
            TempStoreData.hack = qb_target:AddBoxZone('ran_robbery_hack', cfg.hack.coords, length,
                width, {
                    name = 'ran_robbery_hack',
                    heading = cfg.hack.rotation,
                    minZ = cfg.hack.coords.z - cfg.hack.size.z,
                    maxZ = cfg.hack.coords.z + cfg.hack.size.z
                }, options)
        elseif Config.Target == "ox" then
            options[1].items = {
                ['trojan_usb'] = 1
            }
            options[1].onSelect = Hack
            TempStoreData.hack = ox_target:addBoxZone({
                coords = cfg.hack.coords,
                size = cfg.hack.size,
                rotation = cfg.hack.rotation,
                options = options
            })
        end
    end
    if cfg.search then
        TempStoreData.search = {}
        for k, v in pairs(cfg.search) do
            ---@type OxTargetOption[] | any[]
            local options = {}
            if v.iscomputer then
                options = {
                    {
                        label = "Search for combination",
                        distance = 2.0,
                        icon = "fa-solid fa-magnifying-glass",
                        canInteract = function()
                            return not cfg.combination and not cfg.cooldown
                        end,
                    },
                    {
                        label = "Look at the combination",
                        distance = 2.0,
                        icon = "fa-solid fa-computer",
                        canInteract = function()
                            return cfg.search[k].founded and AllStashSearched(id) and not cfg.cooldown
                        end,
                    }
                }
                if Config.Target == "qb" then
                    options[1].action = function()
                        SearchCombination(CurrentStore, k)
                    end
                    options[1].item = "trojan_usb"
                    options[2].action = function()
                        QBCore.Functions.Notify("The pin is " .. cfg.combination)
                    end
                elseif Config.Target == "ox" then
                    options[1].onSelect = function()
                        SearchCombination(CurrentStore, k)
                    end
                    options[1].items = {
                        ['trojan_usb'] = 1
                    }
                    options[2].onSelect = function()
                        QBCore.Functions.Notify("The pin is " .. cfg.combination)
                    end
                end
            else
                options = {
                    {
                        label = "Search for combination",
                        distance = 1.0,
                        icon = "fa-solid fa-magnifying-glass",
                        canInteract = function()
                            return not cfg.combination and not cfg.cooldown
                        end,
                    }
                }
                if Config.Target == "qb" then
                    options[1].action = function()
                        SearchCombination(CurrentStore, k)
                    end
                elseif Config.Target == "ox" then
                    options[1].onSelect = function()
                        SearchCombination(CurrentStore, k)
                    end
                end
            end
            if Config.Target == "qb" then
                local length = v.size.x
                local width = v.size.y
                local minZ = v.coords.z - v.size.z
                local maxZ = v.coords.z + v.size.z
                TempStoreData.search[k] = qb_target:AddBoxZone('ran_robbery_search_' .. k, v.coords.xyz, length, width, {
                    name = 'ran_robbery_search_' .. k,
                    heading = v.rotation,
                    minZ = minZ,
                    maxZ = maxZ
                }, {
                    options = options,
                })
            elseif Config.Target == "ox" then
                TempStoreData.search[k] = exports.ox_target:addBoxZone({
                    coords = v.coords,
                    size = v.size,
                    rotation = v.rotation,
                    options = options,
                    drawSprite = false,
                })
            end
        end
    end
    if cfg.safe then
        TempStoreData.safe = lib.zones.sphere({
            coords = cfg.safe.coords.xyz,
            radius = 1.0,
            inside = InsideSafe
        })
    end
    CreateThread(function()
        while CurrentStore == id do
            UpdateConfig()
            Wait(500)
        end
    end)
end


local function ResetStore(id)
    if TempStoreData.hack then
        if Config.Target == "ox" then
            ox_target:removeZone(TempStoreData.hack)
        elseif Config.Target == "qb" then
            qb_target:RemoveZone(TempStoreData.hack?.name)
        end
    end
    if TempStoreData.registar then
        for _, v in pairs(TempStoreData.registar) do
            if v.zone then
                v.zone:remove()
            end
        end
    end
    if TempStoreData.search then
        for _, v in pairs(TempStoreData.search) do
            if Config.Target == "qb" then
                qb_target:RemoveZone(v.name)
            elseif Config.Target == "ox" then
                ox_target:removeZone(v)
            end
        end
    end
    if TempStoreData.safe then
        TempStoreData.safe:remove()
    end
    if EData then
        RemoveEventHandler(EData)
        EData = nil
    end
    table.wipe(TempStoreData)
end

local function ConfigContext()
    local pnis = promise.new()
    local opts = {}
    for k, v in pairs(Config.Store) do
        opts[#opts + 1] = {
            title = ("Config Number: [%s]"):format(k),
            description = ("Hack: %s | Register: %s | Robbed: %s"):format(v.hack and true or false, #v.registar,
                v.alerted or false),
            onSelect = function()
                pnis:resolve(k)
            end,
        }
    end
    lib.registerContext({
        id = "ran_storerobbery_config_context",
        title = "Config",
        options = opts,
        onExit = function()
            pnis:resolve(false)
        end
    })
    lib.showContext('ran_storerobbery_config_context')
    return Citizen.Await(pnis)
end

lib.callback.register("ran-storerobbery:client:openConfigContext", function()
    return ConfigContext()
end)

lib.callback.register("ran-storerobbery:client:resetStore", function()
    if not CurrentStore then return end
    local cfg = Config.Store[CurrentStore]
    if not cfg then return end
    if cfg.cooldown then
        QBCore.Functions.Notify("This store is already on cooldown", "error")
        return
    end
    if not cfg.alerted then
        QBCore.Functions.Notify("This store is not even robbed...", "error")
        return
    end
    local alert = lib.alertDialog({
        header = "Confirmation",
        content = "Are you sure you want to reset the store?",
        centered = true,
        cancel = true
    })
    if alert == "confirm" then
        return CurrentStore
    elseif alert == "cancel" then
        return false
    end
end)

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

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName or not LocalPlayer.state.isLoggedIn then return end
    PlayerData = QBCore.Functions.GetPlayerData()
    PlayerLoaded = true
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(newPlayerData)
    local invokingResource = GetInvokingResource()
    if invokingResource and invokingResource ~= 'qb-core' then return end
    PlayerData = newPlayerData
end)

RegisterNetEvent("ran-storerobbery:client:setConfigs", function(cfg)
    Config.Store = cfg
end)

RegisterNetEvent("ran-storerobbery:client:setStoreConfig", function(id, cfg)
    if not id or not cfg then return end
    if not type(cfg) == "table" then return end
    if not Config.Store[id] then return end
    Config.Store[id] = cfg
end)

RegisterNetEvent("police:SetCopCount", function(amount)
    CopCount = amount
end)

CreateThread(function()
    while true do
        if PlayerLoaded then
            local pos = GetEntityCoords(cache.ped)
            for k, v in pairs(Config.Store) do
                local pos2 = v.coords
                local dist = #(pos - pos2)
                if dist <= 20.0 and CurrentStore ~= k then
                    CurrentStore = k
                    SetupStore(k)
                elseif dist >= 20.0 and CurrentStore == k then
                    ResetStore(k)
                    table.wipe(TempStoreData)
                    CurrentStore = nil
                end
            end
        end
        Wait(1000)
    end
end)

CreateThread(function()
    local options = {
        {
            label = "Grab Cash",
            canInteract = function(entity, distance, coords, name, bone)
                return entity and GetEntityHealth(entity) < 1000 and CurrentStore and not Config.Store[CurrentStore]
                    .cooldown
            end,
            icon = "fa-solid fa-cash-register",
        }
    }
    if Config.Target == "qb" then
        options[1].action = RobRegistar
        qb_target:AddTargetModel('prop_till_01', {
            options = options
        })
    elseif Config.Target == "ox" then
        options[1].onSelect = RobRegistar
        ox_target:addModel('prop_till_01', options)
    end
end)
