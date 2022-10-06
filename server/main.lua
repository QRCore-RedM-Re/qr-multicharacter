-- Functions
local identifierUsed = GetConvar('es_identifierUsed', 'steam')
local foundResources = {}

local StarterItems = {
    ['apple'] = { amount = 1, item = 'apple' }
}


local function GiveStarterItems(source)
    local Player = exports['qr-core']:GetPlayer(source)
    for k, v in pairs(StarterItems) do
        Player.Functions.AddItem(v.item, 1)
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
    if exports['qr-core']:Login(src, cData.citizenid) then
        print('^2[qr-core]^7 '..GetPlayerName(src)..' (Citizen ID: '..cData.citizenid..') has succesfully loaded!')
        exports['qr-core']:RefreshCommands(src)
        TriggerClientEvent("qr-multicharacter:client:closeNUI", src)
        TriggerClientEvent('qr-spawn:client:setupSpawnUI', src, cData, false)
        TriggerEvent("qr-log:server:CreateLog", "joinleave", "Loaded", "green", "**".. GetPlayerName(src) .. "** ("..cData.citizenid.." | "..src..") loaded..")
	end
end)

RegisterNetEvent('qr-multicharacter:server:createCharacter', function(data, enabledhouses)
    local newData = {}
    local src = source
    newData.cid = data.cid
    newData.charinfo = data
    if exports['qr-core']:Login(src, false, newData) then
        exports['qr-core']:ShowSuccess(GetCurrentResourceName(), GetPlayerName(src)..' has succesfully loaded!')
        exports['qr-core']:RefreshCommands(src)
        --[[if enabledhouses then loadHouseData() end]] -- Enable once housing is ready
        TriggerClientEvent("qr-multicharacter:client:closeNUI", src)
        TriggerClientEvent('qr-spawn:client:setupSpawnUI', src, newData, true)
        GiveStarterItems(src)
	end
end)

RegisterNetEvent('qr-multicharacter:server:deleteCharacter', function(citizenid)
    exports['qr-core']:DeleteCharacter(source, citizenid)
end)

-- Callbacks

exports['qr-core']:CreateCallback("qr-multicharacter:server:setupCharacters", function(source, cb)
    local license = exports['qr-core']:GetIdentifier(source, 'license')
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

exports['qr-core']:CreateCallback("qr-multicharacter:server:GetNumberOfCharacters", function(source, cb)
    local license = exports['qr-core']:GetIdentifier(source, 'license')
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

exports['qr-core']:AddCommand("logout", "Logout of Character (Admin Only)", {}, false, function(source)
    exports['qr-core']:Logout(source)
    TriggerClientEvent('qr-multicharacter:client:chooseChar', source)
end, 'admin')

exports['qr-core']:AddCommand("closeNUI", "Close Multi NUI", {}, false, function(source)
    TriggerClientEvent('qr-multicharacter:client:closeNUI', source)
end, 'user')
