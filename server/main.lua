-- Functions
local QRCore = exports['qr-core']:GetCoreObject()

local identifierUsed = GetConvar('es_identifierUsed', 'steam')
local foundResources = {}

local StarterItems = {
    ['water'] = { amount = 5, item = 'water' },
	['bread'] = { amount = 5, item = 'bread' }
}

local function GiveStarterItems(source)
    local Player = QRCore.Functions.GetPlayer(source)
    for k, v in pairs(StarterItems) do
        Player.Functions.AddItem(v.item, v.amount)
    end
end

local function loadHouseData()
    local HouseGarages = {}
    local Houses = {}
    local result = MySQL.Sync.fetchAll('SELECT * FROM houselocations')
    if result[1] ~= nil then
        for k, v in pairs(result) do
            local owned = false
            if tonumber(v.owned) == 1 then
                owned = true
            end
            local garage = v.garage ~= nil and json.decode(v.garage) or {}
            Houses[v.name] = {
                coords = json.decode(v.coords),
                owned = v.owned,
                price = v.price,
                locked = true,
                adress = v.label,
                tier = v.tier,
                garage = garage,
                decorations = {},
            }
            HouseGarages[v.name] = {
                label = v.label,
                takeVehicle = garage,
            }
        end
    end
    TriggerClientEvent("qr-garages:client:houseGarageConfig", -1, HouseGarages)
    TriggerClientEvent("qr-houses:client:setHouseConfig", -1, Houses)
end

RegisterNetEvent('qr-multicharacter:server:disconnect', function(source)
    DropPlayer(source, "You have disconnected from QRCore RedM")
end)

RegisterNetEvent('qr-multicharacter:server:loadUserData', function(cData)
    local src = source
    if QRCore.Player.Login(src, cData.citizenid) then
        print('^2[qr-core]^7 '..GetPlayerName(src)..' (Citizen ID: '..cData.citizenid..') has succesfully loaded!')
        QRCore.Commands.Refresh(src)
        TriggerClientEvent("qr-multicharacter:client:closeNUI", src)
        TriggerClientEvent('qr-spawn:client:setupSpawnUI', src, cData, false)
        TriggerEvent("qr-log:server:CreateLog", "joinleave", "Loaded", "green", "**".. GetPlayerName(src) .. "** ("..cData.citizenid.." | "..src..") loaded..")
	end
end)

RegisterNetEvent('qr-multicharacter:server:createCharacter', function(data, enabledhouses)
    local newData = {}
    local src = source
    local randbucket = (GetPlayerPed(src) .. math.random(1,999))
    newData.cid = data.cid
    newData.charinfo = data
    if QRCore.Player.Login(src, false, newData) then
        SetPlayerRoutingBucket(src, randbucket)
        print('^2[qr-core]^7 '..GetPlayerName(src)..' has succesfully loaded!')
        QRCore.Commands.Refresh(src)
        --[[if enabledhouses then loadHouseData() end]] -- Enable once housing is ready
        TriggerClientEvent("qr-multicharacter:client:closeNUI", src)
        TriggerClientEvent('qr-spawn:client:setupSpawnUI', src, newData, true)
        GiveStarterItems(src)
	end
end)

RegisterNetEvent('qr-multicharacter:server:deleteCharacter', function(citizenid)
    QRCore.Player.DeleteCharacter(source, citizenid)
end)

-- Callbacks

QRCore.Functions.CreateCallback("qr-multicharacter:server:setupCharacters", function(source, cb)
    local license = QRCore.Functions.GetIdentifier(source, 'license')
    local plyChars = {}
    MySQL.Async.fetchAll('SELECT * FROM players WHERE license = @license', {['@license'] = license}, function(result)
        for i = 1, (#result), 1 do
            result[i].charinfo = json.decode(result[i].charinfo)
            result[i].money = json.decode(result[i].money)
            result[i].job = json.decode(result[i].job)
            plyChars[#plyChars+1] = result[i]
        end
        cb(plyChars)
    end)
end)

QRCore.Functions.CreateCallback("qr-multicharacter:server:GetNumberOfCharacters", function(source, cb)
    local license = QRCore.Functions.GetIdentifier(source, 'license')
    local numOfChars = 0
    if next(Config.PlayersNumberOfCharacters) then
        for i, v in pairs(Config.PlayersNumberOfCharacters) do
            if v.license == license then
                numOfChars = v.numberOfChars
                break
            else
                numOfChars = Config.DefaultNumberOfCharacters
            end
        end
    else
        numOfChars = Config.DefaultNumberOfCharacters
    end
    cb(numOfChars)
end)

QRCore.Functions.CreateCallback("qr-multicharacter:server:getSkin", function(source, cb, cid)
    MySQL.Async.fetchAll('SELECT * FROM playerskins WHERE citizenid = ? AND active = ?', {cid, 1}, function(result)
        result[1].skin = json.decode(result[1].skin)
        result[1].clothes = json.decode(result[1].clothes)
        cb(result[1])
    end)
end)

QRCore.Commands.Add("logout", "Logout of Character (Admin Only)", {}, false, function(source)
    QRCore.Player.Logout(source)
    TriggerClientEvent('qr-multicharacter:client:chooseChar', source)
end, 'admin')

QRCore.Commands.Add("closeNUI", "Close Multi NUI", {}, false, function(source)
    TriggerClientEvent('qr-multicharacter:client:closeNUI', source)
end, 'user')
