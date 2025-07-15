-- ==================== QR-MULTICHARACTER SERVER ====================

-- Core Object
local QRCore = exports['qr-core']:GetCoreObject()

-- ==================== DEBUG FUNCTIONS ====================

-- Debug print function
local function DebugPrint(message, debugType)
    if not Config.Debug.enabled then return end
    
    debugType = debugType or 'general'
    
    if debugType == 'server' and not Config.Debug.server then return end
    if debugType == 'events' and not Config.Debug.events then return end
    if debugType == 'performance' and not Config.Debug.performance then return end
    
    local timestamp = os.date('%H:%M:%S')
    print(string.format("^3[DEBUG %s] [%s] %s^0", debugType:upper(), timestamp, message))
end

-- Performance monitoring function
local function DebugPerformance(functionName, startTime)
    if not Config.Debug.enabled or not Config.Debug.performance then return end
    
    local endTime = GetGameTimer()
    local executionTime = endTime - startTime
    DebugPrint(string.format("%s executed in %dms", functionName, executionTime), 'performance')
end

-- ==================== UTILITY FUNCTIONS ====================

-- Give starter items to new characters
local function GiveStarterItems(source)
    local startTime = GetGameTimer()
    DebugPrint(string.format("GiveStarterItems called for %s", GetPlayerName(source)), 'server')
    
    local Player = QRCore.Functions.GetPlayer(source)
    if not Player then 
        local errorMsg = string.format("Failed to get player object for %s when giving starter items", GetPlayerName(source))
        print(string.format("^1[qr-multicharacter] %s^0", errorMsg))
        DebugPrint(errorMsg, 'server')
        return 
    end
    
    DebugPrint(string.format("Found %d starter items to give", #Config.StarterItems), 'server')
    
    for i, item in pairs(Config.StarterItems) do
        if item.item and item.amount then
            Player.Functions.AddItem(item.item, item.amount)
            DebugPrint(string.format("Added item: %s x%d", item.item, item.amount), 'server')
        else
            DebugPrint(string.format("Invalid starter item at index %d", i), 'server')
        end
    end
    
    print(string.format("^2[qr-multicharacter] Starter items given to %s^0", GetPlayerName(source)))
    DebugPerformance("GiveStarterItems", startTime)
end

-- ==================== EVENT HANDLERS ====================

-- Handle player disconnect
RegisterNetEvent('qr-multicharacter:server:disconnect', function()
    local source = source
    local playerName = GetPlayerName(source)
    
    DebugPrint(string.format("Player disconnect event received from %s", playerName), 'events')
    print(string.format("^3[qr-multicharacter] %s disconnected from character selection^0", playerName))
    DropPlayer(source, Config.DisconnectText)
end)

-- Load existing character data
RegisterNetEvent('qr-multicharacter:server:loadUserData', function(characterData)
    local source = source
    local playerName = GetPlayerName(source)
    local startTime = GetGameTimer()
    
    DebugPrint(string.format("LoadUserData event received from %s", playerName), 'events')
    
    if not characterData or not characterData.citizenid then
        local errorMsg = string.format("Invalid character data for %s", playerName)
        print(string.format("^1[qr-multicharacter] %s^0", errorMsg))
        DebugPrint(errorMsg, 'server')
        return
    end
    
    DebugPrint(string.format("Loading character %s for %s", characterData.citizenid, playerName), 'server')
    
    if QRCore.Player.Login(source, characterData.citizenid) then
        print(string.format("^2[qr-multicharacter] %s (ID: %s) loaded successfully^0", playerName, characterData.citizenid))
        DebugPrint(string.format("Character %s loaded successfully", characterData.citizenid), 'server')
        
        -- Refresh commands for the logged-in player
        QRCore.Commands.Refresh(source)
        
        -- Setup spawn UI
        TriggerClientEvent('qr-spawn:client:setupSpawnUI', source, characterData, false)
        
        -- Log the login
        TriggerEvent("qr-log:server:CreateLog", "joinleave", "Character Loaded", "green", 
            string.format("**%s** (%s | %s) loaded character", playerName, characterData.citizenid, source))
            
        DebugPerformance("LoadUserData", startTime)
    else
        local errorMsg = string.format("Failed to login %s with character %s", playerName, characterData.citizenid)
        print(string.format("^1[qr-multicharacter] %s^0", errorMsg))
        DebugPrint(errorMsg, 'server')
    end
end)

-- Create new character
RegisterNetEvent('qr-multicharacter:server:createCharacter', function(characterData)
    local source = source
    local playerName = GetPlayerName(source)
    local startTime = GetGameTimer()
    
    DebugPrint(string.format("CreateCharacter event received from %s", playerName), 'events')
    
    if not characterData then
        local errorMsg = string.format("No character data provided by %s", playerName)
        print(string.format("^1[qr-multicharacter] %s^0", errorMsg))
        DebugPrint(errorMsg, 'server')
        return
    end
    
    DebugPrint(string.format("Creating new character for %s", playerName), 'server')
    
    local newCharacterData = {
        cid = characterData.cid,
        charinfo = characterData
    }
    
    if QRCore.Player.Login(source, false, newCharacterData) then
        print(string.format("^2[qr-multicharacter] %s created new character successfully^0", playerName))
        DebugPrint(string.format("New character created successfully for %s", playerName), 'server')
        
        -- Refresh commands for the new character
        QRCore.Commands.Refresh(source)
        
        -- Give starter items to new character
        GiveStarterItems(source)
        
        -- Log character creation
        TriggerEvent("qr-log:server:CreateLog", "joinleave", "Character Created", "blue", 
            string.format("**%s** (%s) created new character", playerName, source))
            
        DebugPerformance("CreateCharacter", startTime)
    else
        local errorMsg = string.format("Failed to create character for %s", playerName)
        print(string.format("^1[qr-multicharacter] %s^0", errorMsg))
        DebugPrint(errorMsg, 'server')
    end
end)

-- Delete character
RegisterNetEvent('qr-multicharacter:server:deleteCharacter', function(citizenid)
    local source = source
    local playerName = GetPlayerName(source)
    
    DebugPrint(string.format("DeleteCharacter event received from %s", playerName), 'events')
    
    if not citizenid then
        local errorMsg = string.format("No citizen ID provided for deletion by %s", playerName)
        print(string.format("^1[qr-multicharacter] %s^0", errorMsg))
        DebugPrint(errorMsg, 'server')
        return
    end
    
    DebugPrint(string.format("Deleting character %s for %s", citizenid, playerName), 'server')
    
    QRCore.Player.DeleteCharacter(source, citizenid)
    
    print(string.format("^3[qr-multicharacter] %s deleted character %s^0", playerName, citizenid))
    DebugPrint(string.format("Character %s deleted successfully", citizenid), 'server')
    
    -- Log character deletion
    TriggerEvent("qr-log:server:CreateLog", "joinleave", "Character Deleted", "red", 
        string.format("**%s** (%s) deleted character %s", playerName, source, citizenid))
end)

-- ==================== CALLBACKS ====================

-- Setup characters for selection menu
QRCore.Functions.CreateCallback("qr-multicharacter:server:setupCharacters", function(source, cb)
    local startTime = GetGameTimer()
    local playerName = GetPlayerName(source)
    local license = QRCore.Functions.GetIdentifier(source, 'license')
    
    DebugPrint(string.format("setupCharacters callback called by %s", playerName), 'events')
    
    if not license then
        local errorMsg = string.format("No license found for %s", playerName)
        print(string.format("^1[qr-multicharacter] %s^0", errorMsg))
        DebugPrint(errorMsg, 'server')
        cb({})
        return
    end
    
    DebugPrint(string.format("Fetching characters for license: %s", license), 'server')
    
    MySQL.Async.fetchAll('SELECT * FROM players WHERE license = @license', {
        ['@license'] = license
    }, function(result)
        local playerCharacters = {}
        
        if result and #result > 0 then
            DebugPrint(string.format("Found %d characters in database", #result), 'server')
            
            for i = 1, #result do
                local character = result[i]
                
                -- Safely decode JSON data
                character.charinfo = character.charinfo and json.decode(character.charinfo) or {}
                character.money = character.money and json.decode(character.money) or {}
                character.job = character.job and json.decode(character.job) or {}
                
                playerCharacters[#playerCharacters + 1] = character
                DebugPrint(string.format("Processed character %d: %s", i, character.citizenid or "Unknown"), 'server')
            end
            
            print(string.format("^2[qr-multicharacter] Loaded %d characters for %s^0", #result, playerName))
        else
            DebugPrint(string.format("No characters found for %s", playerName), 'server')
            print(string.format("^3[qr-multicharacter] No characters found for %s^0", playerName))
        end
        
        DebugPerformance("setupCharacters", startTime)
        DebugPerformance("setupCharacters", startTime)
        cb(playerCharacters)
    end)
end)

-- Get number of characters allowed for player
QRCore.Functions.CreateCallback("qr-multicharacter:server:GetNumberOfCharacters", function(source, cb)
    local playerName = GetPlayerName(source)
    local license = QRCore.Functions.GetIdentifier(source, 'license')
    local numberOfCharacters = Config.DefaultNumberOfCharacters
    
    DebugPrint(string.format("GetNumberOfCharacters callback called by %s", playerName), 'events')
    
    if not license then
        local errorMsg = string.format("No license found for %s, using default character limit", playerName)
        print(string.format("^1[qr-multicharacter] %s^0", errorMsg))
        DebugPrint(errorMsg, 'server')
        cb(numberOfCharacters)
        return
    end
    
    DebugPrint(string.format("Checking character limits for license: %s", license), 'server')
    
    -- Check for custom character limits
    if Config.PlayersNumberOfCharacters and next(Config.PlayersNumberOfCharacters) then
        for _, playerConfig in pairs(Config.PlayersNumberOfCharacters) do
            if playerConfig.license == license then
                numberOfCharacters = playerConfig.numberOfChars
                DebugPrint(string.format("Custom character limit found: %d", numberOfCharacters), 'server')
                break
            end
        end
    end
    
    print(string.format("^2[qr-multicharacter] %s allowed %d characters^0", playerName, numberOfCharacters))
    DebugPrint(string.format("Character limit for %s: %d", playerName, numberOfCharacters), 'server')
    cb(numberOfCharacters)
end)

-- ==================== ADMIN COMMANDS ====================

-- Logout command for admins
QRCore.Commands.Add("logout", "Logout of Character (Admin Only)", {}, false, function(source)
    local playerName = GetPlayerName(source)
    
    DebugPrint(string.format("Admin logout command used by %s", playerName), 'events')
    
    QRCore.Player.Logout(source)
    TriggerClientEvent('qr-multicharacter:client:chooseChar', source)
    
    print(string.format("^3[qr-multicharacter] Admin %s logged out to character selection^0", playerName))
    
    -- Log admin logout
    TriggerEvent("qr-log:server:CreateLog", "joinleave", "Admin Logout", "orange", 
        string.format("**%s** (%s) used admin logout command", playerName, source))
end, 'admin')

-- Debug toggle command for admins
QRCore.Commands.Add("multidebug", "Toggle Multicharacter Debug Mode", {
    {name = "type", help = "Debug type: all, client, server, events, performance"}
}, false, function(source, args)
    local playerName = GetPlayerName(source)
    local debugType = args[1] and string.lower(args[1]) or "all"
    
    if debugType == "all" then
        Config.Debug.enabled = not Config.Debug.enabled
        Config.Debug.client = Config.Debug.enabled
        Config.Debug.server = Config.Debug.enabled
        Config.Debug.events = Config.Debug.enabled
        Config.Debug.performance = Config.Debug.enabled
        
        TriggerClientEvent('QRCore:Notify', source, 
            string.format("Multicharacter Debug %s", Config.Debug.enabled and "تم التفعيل" or "تم التعطيل"), 
            Config.Debug.enabled and "success" or "error")
            
    elseif debugType == "client" then
        Config.Debug.client = not Config.Debug.client
        TriggerClientEvent('QRCore:Notify', source, 
            string.format("Client Debug %s", Config.Debug.client and "تم التفعيل" or "تم التعطيل"), 
            Config.Debug.client and "success" or "error")
            
    elseif debugType == "server" then
        Config.Debug.server = not Config.Debug.server
        TriggerClientEvent('QRCore:Notify', source, 
            string.format("Server Debug %s", Config.Debug.server and "تم التفعيل" or "تم التعطيل"), 
            Config.Debug.server and "success" or "error")
            
    elseif debugType == "events" then
        Config.Debug.events = not Config.Debug.events
        TriggerClientEvent('QRCore:Notify', source, 
            string.format("Events Debug %s", Config.Debug.events and "تم التفعيل" or "تم التعطيل"), 
            Config.Debug.events and "success" or "error")
            
    elseif debugType == "performance" then
        Config.Debug.performance = not Config.Debug.performance
        TriggerClientEvent('QRCore:Notify', source, 
            string.format("Performance Debug %s", Config.Debug.performance and "تم التفعيل" or "تم التعطيل"), 
            Config.Debug.performance and "success" or "error")
    else
        TriggerClientEvent('QRCore:Notify', source, "استخدم: all, client, server, events, performance", "error")
        return
    end
    
    print(string.format("^3[qr-multicharacter] %s toggled debug mode: %s^0", playerName, debugType))
    DebugPrint(string.format("Debug toggled by %s - Type: %s", playerName, debugType), 'events')
end, 'admin')

-- ==================== RESOURCE INITIALIZATION ====================

-- Initialize resource
CreateThread(function()
    print("^2[qr-multicharacter] Server initialized successfully^0")
    print("^2[qr-multicharacter] Version: 3.0.0 - Cinematic Camera System^0")
    
    -- Display debug status
    if Config.Debug.enabled then
        print("^3[qr-multicharacter] Debug Mode: ENABLED^0")
        if Config.Debug.server then print("^3[qr-multicharacter] - Server Debug: ON^0") end
        if Config.Debug.events then print("^3[qr-multicharacter] - Events Debug: ON^0") end
        if Config.Debug.performance then print("^3[qr-multicharacter] - Performance Debug: ON^0") end
        print("^3[qr-multicharacter] Use /multidebug command to toggle debug modes^0")
    else
        print("^3[qr-multicharacter] Debug Mode: DISABLED (use /multidebug to enable)^0")
    end
end)

-- ==================== RESOURCE MANAGEMENT ====================

-- Force logout all players on resource restart
local function ForceLogoutAllPlayers()
    DebugPrint("Forcing logout for all connected players", 'server')
    
    local players = GetPlayers()
    for _, playerId in pairs(players) do
        local player = tonumber(playerId)
        if player then
            DebugPrint(string.format("Logging out player %d", player), 'server')
            
            -- Clear player data
            if QRCore.Players[player] then
                QRCore.Players[player] = nil
            end
            
            -- Trigger client cleanup and return to character selection
            TriggerClientEvent('qr-multicharacter:client:forceLogout', player)
            
            Wait(100) -- Small delay between players
        end
    end
    
    DebugPrint(string.format("Forced logout completed for %d players", #players), 'server')
end

-- Clean restart function
local function CleanRestart()
    DebugPrint("Performing clean restart of multicharacter system", 'server')
    
    -- Force logout all players first
    ForceLogoutAllPlayers()
    
    -- Wait a moment for clients to process
    Wait(2000)
    
    -- Clear any server-side cache/data
    -- Add any additional server cleanup here
    
    DebugPrint("Clean restart completed", 'server')
end

-- Resource event handlers
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        DebugPrint("QR-Multicharacter stopping - performing clean shutdown", 'server')
        ForceLogoutAllPlayers()
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        DebugPrint("QR-Multicharacter starting - performing clean startup", 'server')
        Wait(3000) -- Wait for core systems to load
        CleanRestart()
    end
end)

-- Admin command to force clean restart
RegisterCommand('cleanrestart', function(source, args)
    local Player = QRCore.Functions.GetPlayer(source)
    if Player and (Player.PlayerData.job.name == 'admin' or Player.PlayerData.group == 'admin') then
        TriggerClientEvent('QRCore:Notify', source, 'بدء إعادة تشغيل نظيفة...', 'primary', 3000)
        CleanRestart()
        TriggerClientEvent('QRCore:Notify', source, 'تم! إعادة التشغيل النظيفة مكتملة', 'success', 5000)
    else
        TriggerClientEvent('QRCore:Notify', source, 'ليس لديك صلاحية لهذا الأمر', 'error', 3000)
    end
end, false)

-- Server initialization
CreateThread(function()
    print("^2[qr-multicharacter] Server initialized with clean restart system^0")
    print("^2[qr-multicharacter] Use '/cleanrestart' for manual clean restart^0")
end)
