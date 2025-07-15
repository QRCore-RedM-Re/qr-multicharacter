-- ==================== VARIABLES ====================
local charPed = nil
local previewPed = nil
local currentCharacterIndex = 1
local choosingCharacter = false
local selectingChar = true
local activeCamera = nil
local characters = {}
local isLoadingCharacter = false
local isResourceStarting = true

-- Core Object
local QRCore = exports['qr-core']:GetCoreObject()

-- ==================== CACHE CLEANUP FUNCTIONS ====================
-- Debug print function for client
local function DebugPrint(message, debugType)
    if not Config.Debug.enabled then return end
    
    debugType = debugType or 'general'
    
    if debugType == 'client' and not Config.Debug.client then return end
    if debugType == 'events' and not Config.Debug.events then return end
    if debugType == 'performance' and not Config.Debug.performance then return end
    
    local timestamp = os.date('%H:%M:%S')
    print(string.format("^6[CLIENT DEBUG %s] [%s] %s^0", debugType:upper(), timestamp, message))
end


-- Enhanced CleanupCameras function
local function CleanupCameras()
    DebugPrint("Cleaning up all cameras and restoring normal view", 'client')
    
    if DoesCamExist(activeCamera) then
        DestroyCam(activeCamera, true)
        activeCamera = nil
    end
    
    if DoesCamExist(cinematicCamera) then
        DestroyCam(cinematicCamera, true)
        cinematicCamera = nil
    end
    
    cinematicActive = false
    currentCameraPoint = 1
    RenderScriptCams(false, true, 500, true, true)
    
    -- Reset camera to normal gameplay
    SetGameplayCamRelativeHeading(0.0)
    SetGameplayCamRelativePitch(0.0, 1.0)
end

-- Complete cache cleanup function
local function ClearAllCache()
    DebugPrint("Clearing all multicharacter cache and state", 'client')
    
    -- Reset all variables
    charPed = nil
    previewPed = nil
    currentCharacterIndex = 1
    choosingCharacter = false
    selectingChar = true
    activeCamera = nil
    characters = {}
    isLoadingCharacter = false
    isResourceStarting = true
    
    -- Cleanup cameras
    CleanupCameras()
    
    -- Hide any open contexts
    if lib then
        lib.hideContext()
    end
    
    -- Reset player state
    local playerPed = PlayerPedId()
    if DoesEntityExist(playerPed) then
        FreezeEntityPosition(playerPed, false)
        SetEntityVisible(playerPed, true)
        SetEntityAlpha(playerPed, 255, false)
        SetPlayerInvincible(PlayerId(), false)
    end
    
    -- Force cleanup any preview peds
    if previewPed and DoesEntityExist(previewPed) then
        DeleteEntity(previewPed)
        previewPed = nil
    end
    
    if charPed and DoesEntityExist(charPed) then
        DeleteEntity(charPed)
        charPed = nil
    end
    
    -- Clear screen effects
    DoScreenFadeIn(100)
    
    DebugPrint("Multicharacter cache cleared successfully", 'client')
end

-- ==================== DEBUG FUNCTIONS ====================


-- Performance monitoring function for client
local function DebugPerformance(functionName, startTime)
    if not Config.Debug.enabled or not Config.Debug.performance then return end
    
    local endTime = GetGameTimer()
    local executionTime = endTime - startTime
    DebugPrint(string.format("%s executed in %dms", functionName, executionTime), 'performance')
end

-- ==================== CAMERA CONFIGURATION ====================
-- Camera configuration moved to config.lua

-- Cinematic camera variables
local currentCameraPoint = 1
local cinematicCamera = nil
local cinematicActive = false

-- Performance Config.OPTIMIZATION


-- ==================== UTILITY FUNCTIONS ====================

-- Setup exterior location for character selection
function setupCharacterLocation()
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, -350.0, 750.0, 115.0, false, false, false, true)
    SetEntityHeading(playerPed, 0.0)
    SetEntityVisible(playerPed, false, false)
    FreezeEntityPosition(playerPed, true)
    
    print("^2[qr-multicharacter] Valentine cinematic location setup complete^0")
    return true
end

-- Reset location settings
function resetCharacterLocation()
    local playerPed = PlayerPedId()
    FreezeEntityPosition(playerPed, false)
    SetEntityVisible(playerPed, true, false)
    
    print("^2[qr-multicharacter] Character location reset complete^0")
end

-- Open character selection menu (exported for other resources)
function openCharacterSelection()
    DebugPrint("openCharacterSelection called by external resource", 'client')
    TriggerEvent('qr-multicharacter:client:chooseChar')
end

-- Get current character count
function getCurrentCharacterCount()
    local count = #characters
    DebugPrint(string.format("getCurrentCharacterCount returned: %d", count), 'client')
    return count
end

-- Check if character selection is active
function isInCharacterSelection()
    DebugPrint(string.format("isInCharacterSelection: %s", tostring(choosingCharacter)), 'client')
    return choosingCharacter
end

-- Force cleanup (useful for other resources)
function forceCleanup()
    DebugPrint("forceCleanup called by external resource", 'client')
    cleanupResources()
    choosingCharacter = false
    selectingChar = true
end

-- ==================== CLEANUP FUNCTIONS ====================

-- Clean up function for better resource management
local function cleanupResources()
    if DoesEntityExist(charPed) then
        SetEntityAsMissionEntity(charPed, true, true)
        DeleteEntity(charPed)
        charPed = nil
    end
    
    if DoesEntityExist(previewPed) then
        SetEntityAsMissionEntity(previewPed, true, true)
        DeleteEntity(previewPed)
        previewPed = nil
    end
    
    -- Enhanced camera cleanup
    if DoesCamExist(activeCamera) then
        DestroyCam(activeCamera, true)
        activeCamera = nil
    end
    
    if DoesCamExist(cinematicCamera) then
        DestroyCam(cinematicCamera, true)
        cinematicCamera = nil
    end
    
    cinematicActive = false
    RenderScriptCams(false, false, 0, true, true)
    
    -- Additional cleanup for resource restart
    if isResourceStarting then
        SetGameplayCamRelativeHeading(0.0)
        SetGameplayCamRelativePitch(0.0, 1.0)
        currentCameraPoint = 1
    end
end


-- ==================== CAMERA FUNCTIONS ====================

-- Start cinematic camera tour
local function startCinematicTour()
    cinematicActive = true
    currentCameraPoint = 1
    
    print("^2[qr-multicharacter] Starting Valentine cinematic tour^0")
    
    CreateThread(function()
        while cinematicActive and choosingCharacter do
            local point = Config.Camera.Cinematic.points[currentCameraPoint]
            
            if cinematicCamera then
                DestroyCam(cinematicCamera, true)
            end
            
            -- Create new camera at current point
            cinematicCamera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
            SetCamCoord(cinematicCamera, point.coords.x, point.coords.y, point.coords.z)
            SetCamRot(cinematicCamera, point.rotation.x, point.rotation.y, point.rotation.z, 2)
            SetCamFov(cinematicCamera, point.fov)
            SetCamActive(cinematicCamera, true)
            
            -- Calculate next camera point
            local nextPoint = currentCameraPoint + 1
            if nextPoint > #Config.Camera.Cinematic.points then
                nextPoint = 1 -- Loop back to first point
            end
            
            local nextCamPoint = Config.Camera.Cinematic.points[nextPoint]
            
            -- Interpolate camera movement
            RenderScriptCams(true, true, point.duration, true, true)
            
            -- Smooth movement to next position
            local startTime = GetGameTimer()
            local duration = point.duration
            
            while (GetGameTimer() - startTime) < duration and cinematicActive do
                local progress = (GetGameTimer() - startTime) / duration
                
                -- Smooth interpolation
                local currentX = point.coords.x + (nextCamPoint.coords.x - point.coords.x) * progress
                local currentY = point.coords.y + (nextCamPoint.coords.y - point.coords.y) * progress
                local currentZ = point.coords.z + (nextCamPoint.coords.z - point.coords.z) * progress
                
                local currentRotX = point.rotation.x + (nextCamPoint.rotation.x - point.rotation.x) * progress
                local currentRotY = point.rotation.y + (nextCamPoint.rotation.y - point.rotation.y) * progress
                local currentRotZ = point.rotation.z + (nextCamPoint.rotation.z - point.rotation.z) * progress
                
                local currentFov = point.fov + (nextCamPoint.fov - point.fov) * progress
                
                SetCamCoord(cinematicCamera, currentX, currentY, currentZ)
                SetCamRot(cinematicCamera, currentRotX, currentRotY, currentRotZ, 2)
                SetCamFov(cinematicCamera, currentFov)
                
                Wait(16) -- ~60 FPS smooth movement
            end
            
            -- Move to next point
            currentCameraPoint = nextPoint
            
            if not cinematicActive then break end
        end
    end)
end

-- Stop cinematic camera
local function stopCinematicTour()
    cinematicActive = false
    if DoesCamExist(cinematicCamera) then
        DestroyCam(cinematicCamera, true)
        cinematicCamera = nil
    end
    RenderScriptCams(false, false, 1000, true, true)
    print("^2[qr-multicharacter] Valentine cinematic tour stopped^0")
end

-- ==================== CHARACTER FUNCTIONS ====================

-- Forward declarations
local selectCharacter, createNewCharacter, disconnectPlayer, deleteCharacterConfirm, showCharacterMenu, showCharacterOptions

-- Select and load character
function selectCharacter(characterData)
    if isLoadingCharacter then
        lib.notify({
            title = Locale('char_loading'),
            description = Locale('char_loading_desc'),
            type = 'warning'
        })
        return
    end
    
    selectingChar = false
    choosingCharacter = false
    
    -- Stop cinematic tour and clean up resources
    stopCinematicTour()
    cleanupResources()
    lib.hideContext()
    
    -- Quick fade for smooth transition
    DoScreenFadeOut(Config.OPTIMIZATION.FADE_DURATION)
    Wait(300)
    
    -- Load character data
    TriggerServerEvent('qr-multicharacter:server:loadUserData', characterData)
    
    -- Load character appearance and clothes
    Wait(500)
    TriggerServerEvent("qr_appearance:loadSkin")
    Wait(200)
    TriggerServerEvent("qr_clothes:LoadClothes", 1)
    Wait(200)
    
    DoScreenFadeIn(Config.OPTIMIZATION.FADE_DURATION)
end

-- Create new character
function createNewCharacter()
    local input = lib.inputDialog('🎭 **' .. Locale('char_create_title') .. '**', {
        {
            type = 'input', 
            label = Locale('char_create_firstname'), 
            description = Locale('char_create_firstname_desc'), 
            required = true, 
            min = 2, 
            max = 15,
            icon = 'user'
        },
        {
            type = 'input', 
            label = Locale('char_create_lastname'), 
            description = Locale('char_create_lastname_desc'), 
            required = true, 
            min = 2, 
            max = 15,
            icon = 'user'
        },
        {
            type = 'date', 
            label = Locale('char_create_birthdate'), 
            description = Locale('char_create_birthdate_desc'), 
            required = true, 
            format = 'DD/MM/YYYY', 
            returnString = true,
            icon = 'calendar'
        },
        {
            type = 'select', 
            label = Locale('char_create_gender'), 
            description = Locale('char_create_gender_desc'), 
            required = true, 
            icon = 'venus-mars',
            options = {
                {value = 0, label = '👨 ' .. Locale('gender_male')},
                {value = 1, label = '👩 ' .. Locale('gender_female')}
            }
        },
        {
            type = 'select', 
            label = Locale('char_create_nationality'), 
            description = Locale('char_create_nationality_desc'), 
            required = true,
            icon = 'flag',
            options = {
                {value = 'american', label = '🇺🇸 American'},
                {value = 'british', label = '🇬🇧 British'},
                {value = 'french', label = '🇫🇷 French'},
                {value = 'german', label = '🇩🇪 German'},
                {value = 'italian', label = '🇮🇹 Italian'},
                {value = 'spanish', label = '🇪🇸 Spanish'},
                {value = 'mexican', label = '🇲🇽 Mexican'},
                {value = 'canadian', label = '🇨🇦 Canadian'},
                {value = 'other', label = '🌍 Other'}
            }
        }
    })
    
    if not input then 
        showCharacterMenu()
        return 
    end
    
    local characterData = {
        firstname = input[1],
        lastname = input[2],
        birthdate = input[3],
        gender = input[4],
        nationality = input[5]
    }
    
    -- Stop cinematic tour and transition to character creator
    stopCinematicTour()
    DoScreenFadeOut(Config.OPTIMIZATION.FADE_DURATION)
    Wait(100)
    cleanupResources()
    
    TriggerEvent("qr_appearance:OpenCreator")
    TriggerServerEvent('qr-multicharacter:server:createCharacter', characterData)
    
    Wait(200)
    DoScreenFadeIn(Config.OPTIMIZATION.FADE_DURATION)
end

-- Disconnect from server
function disconnectPlayer()
    lib.alertDialog({
        header = '⚠️ **' .. Locale('disconnect_confirm_title') .. '**',
        content = Locale('disconnect_confirm_msg'),
        centered = true,
        cancel = true,
        labels = {
            confirm = Locale('disconnect_confirm'),
            cancel = Locale('char_delete_cancel')
        }
    }, function(confirmed)
        if confirmed then
            cleanupResources()
            TriggerServerEvent('qr-multicharacter:server:disconnect')
        else
            lib.showContext('character_menu')
        end
    end)
end

-- Delete character with confirmation
function deleteCharacterConfirm(citizenid, characterName)
    local input = lib.inputDialog('⚠️ **' .. Locale('char_delete_title') .. '**', {
        {
            type = 'input', 
            label = Locale('char_delete_type_confirm'), 
            description = Locale('char_delete_confirm_desc', characterName),
            required = true,
            placeholder = 'DELETE',
            icon = 'exclamation-triangle'
        }
    }, {allowCancel = true})
    
    if not input then 
        lib.showContext('character_menu')
        return 
    end
    
    if input[1] == 'DELETE' then
        TriggerServerEvent('qr-multicharacter:server:deleteCharacter', citizenid)
        
        lib.notify({
            title = Locale('char_deleted'),
            description = '**' .. characterName .. '** ' .. Locale('char_delete_success_msg'),
            type = 'success',
            duration = 3000
        })
        
        Wait(1000)
        TriggerEvent('qr-multicharacter:client:chooseChar')
    else
        lib.notify({
            title = Locale('char_delete_cancelled'),
            description = Locale('char_delete_cancelled_msg'),
            type = 'error',
            duration = 3000
        })
        lib.showContext('character_menu')
    end
end

-- ==================== MENU FUNCTIONS ====================

-- Helper function to get character display information
local function getCharacterInfo(character)
    local charInfo = character.charinfo or {}
    local name = (charInfo.firstname or 'Unknown') .. ' ' .. (charInfo.lastname or 'Unknown')
    local jobLabel = character.job and character.job.label or 'Unemployed'
    local money = character.money and character.money.cash or 0
    local level = character.metadata and character.metadata.level or 1
    
    local playTime = 'New Character'
    if character.metadata and character.metadata.playtime then
        local hours = math.floor(character.metadata.playtime / 60)
        playTime = hours .. ' hours played'
    end
    
    return {
        name = name,
        jobLabel = jobLabel,
        money = money,
        level = level,
        playTime = playTime,
        charInfo = charInfo
    }
end

-- Show character options menu (Enter, Delete, Back)
function showCharacterOptions(character)
    local info = getCharacterInfo(character)
    
    local options = {
        {
            title = '🎮 **' .. Locale('char_enter') .. '**',
            description = Locale('char_enter_desc'),
            icon = 'sign-in-alt',
            iconColor = 'green',
            onSelect = function()
                selectCharacter(character)
            end
        },
        {
            title = '🗑️ **' .. Locale('char_delete') .. '**',
            description = Locale('char_delete_warning_desc'),
            icon = 'trash',
            iconColor = 'red',
            onSelect = function()
                deleteCharacterConfirm(character.citizenid, info.name)
            end
        },
        {
            title = '⬅️ **' .. Locale('char_back_to_list') .. '**',
            description = Locale('char_back_to_list_desc'),
            icon = 'arrow-left',
            iconColor = 'blue',
            onSelect = function()
                showCharacterMenu()
            end
        }
    }
    
    lib.registerContext({
        id = 'character_options',
        title = '👤 **' .. info.name .. '**',
        menu = 'character_menu',
        options = options
    })
    
    lib.showContext('character_options')
end

-- Main character selection menu
function showCharacterMenu()
    QRCore.Functions.TriggerCallback("qr-multicharacter:server:setupCharacters", function(result)
        if not result then 
            lib.notify({
                title = Locale('error_loading_chars'),
                description = Locale('error_loading_chars'),
                type = 'error'
            })
            return 
        end
        
        characters = result
        local options = {}
        
        -- Add existing characters
        for i, character in pairs(result) do
            local info = getCharacterInfo(character)
            
            table.insert(options, {
                title = '👤 **' .. info.name .. '**',
                description = '**' .. Locale('char_job') .. ':** ' .. info.jobLabel .. ' | **' .. Locale('char_level') .. ':** ' .. info.level .. '\n**' .. Locale('char_cash') .. ':** $' .. info.money .. ' | **' .. info.playTime .. '**',
                icon = 'user',
                iconColor = 'blue',
                onSelect = function()
                    showCharacterOptions(character)
                end,
                metadata = {
                    {label = Locale('char_id'), value = character.citizenid or 'N/A'},
                    {label = Locale('char_created'), value = info.charInfo.birthdate or Locale('unknown')},
                    {label = Locale('char_nationality'), value = info.charInfo.nationality or Locale('unknown')},
                    {label = Locale('char_gender'), value = (info.charInfo.gender == 1) and Locale('gender_female') or Locale('gender_male')}
                }
            })
        end
        
        -- Add separator if there are characters
        if #result > 0 then
            table.insert(options, {
                title = '─────────────────',
                description = '',
                icon = 'minus',
                iconColor = 'gray',
                disabled = true
            })
        end
        
        -- Add create new character option
        if #result < Config.MaxCharacters then
            table.insert(options, {
                title = '➕ **' .. Locale('char_create_new') .. '**',
                description = Locale('char_create_new_desc', #result, Config.MaxCharacters),
                icon = 'plus',
                iconColor = 'green',
                onSelect = function()
                    createNewCharacter()
                end
            })
        else
            table.insert(options, {
                title = '❌ **' .. Locale('char_limit_reached_title') .. '**',
                description = Locale('char_limit_reached', Config.MaxCharacters),
                icon = 'ban',
                iconColor = 'red',
                disabled = true
            })
        end
        
        -- Add disconnect option
        table.insert(options, {
            title = '🚪 **' .. Locale('disconnect') .. '**',
            description = Locale('disconnect_desc'),
            icon = 'sign-out-alt',
            iconColor = 'red',
            onSelect = function()
                disconnectPlayer()
            end
        })
        
        lib.registerContext({
            id = 'character_menu',
            title = '🎭 **' .. Locale('char_select_title') .. '** (' .. #result .. '/' .. Config.MaxCharacters .. ')',
            canClose = false,
            options = options
        })
        
        lib.showContext('character_menu')
    end)
end

-- ==================== MENU MANAGEMENT ====================

-- Open/close character menu
local function openCharMenu(bool)
    if bool then
        QRCore.Functions.TriggerCallback("qr-multicharacter:server:GetNumberOfCharacters", function(result)
            choosingCharacter = bool
            startCinematicTour()
            showCharacterMenu()
        end)
    else
        choosingCharacter = false
        stopCinematicTour()
        cleanupResources()
        lib.hideContext()
    end
end

-- ==================== EVENT HANDLERS ====================

-- Resource cleanup on stop
AddEventHandler('onResourceStop', function(resource)
    if (GetCurrentResourceName() == resource) then
        cleanupResources()
    end
end)

-- Resource initialization
AddEventHandler('onClientResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    print("^2[qr-multicharacter] Resource started successfully^0")
end)

-- Cleanup event for character selection end
RegisterNetEvent('qr-multicharacter:client:closeNUI', function()
    -- Legacy event kept for compatibility - performs cleanup
    cleanupResources()
    lib.hideContext()
end)

-- Main character selection event
RegisterNetEvent('qr-multicharacter:client:chooseChar', function()
    local startTime = GetGameTimer()
    DebugPrint("Character selection event triggered", 'events')
    
    -- Smooth transition
    DoScreenFadeOut(Config.OPTIMIZATION.FADE_DURATION)
    Wait(300)
    
    -- Setup location and clear loading screens
    DebugPrint("Setting up character selection location", 'client')
    setupCharacterLocation()
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
    
    -- Fade back in and show menu
    DoScreenFadeIn(Config.OPTIMIZATION.FADE_DURATION)
    Wait(200)
    DebugPrint("Opening character menu", 'client')
    openCharMenu(true)
    
    DebugPerformance("chooseChar", startTime)
    
    -- Selection loop
    CreateThread(function()
        while selectingChar do
            Wait(Config.OPTIMIZATION.MENU_UPDATE_DELAY)
            if not choosingCharacter then
                break
            end
        end
        resetCharacterLocation()
    end)
end)

-- Force logout event (called from server during restart)
RegisterNetEvent('qr-multicharacter:client:forceLogout', function()
    DebugPrint("Received force logout - cleaning up and returning to character selection", 'events')
    
    -- Clear all cache first
    ClearAllCache()
    
    Wait(1000)
    
    -- Show notification
    lib.notify({
        title = Locale('restart_notification'),
        description = Locale('restart_redirect_msg'),
        type = 'info',
        duration = 4000
    })
    
    Wait(2000)
    
    -- Trigger character selection
    TriggerEvent('qr-multicharacter:client:chooseChar')
end)

-- ==================== BACKWARDS COMPATIBILITY ====================
-- No legacy events needed - all functionality migrated to ox_lib

-- ==================== EXPORTS FOR OTHER RESOURCES ====================

-- Export functions for use by other resources
exports('setupCharacterLocation', setupCharacterLocation)
exports('resetCharacterLocation', resetCharacterLocation)
exports('openCharacterSelection', openCharacterSelection)
exports('getCurrentCharacterCount', getCurrentCharacterCount)
exports('isInCharacterSelection', isInCharacterSelection)
exports('forceCleanup', forceCleanup)

-- ==================== RESOURCE MANAGEMENT ====================

-- Resource stop cleanup
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        DebugPrint("QR-Multicharacter stopping - performing full cleanup", 'client')
        ClearAllCache()
    end
end)

-- Resource start cleanup
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        DebugPrint("QR-Multicharacter starting - clearing any residual state", 'client')
        Wait(2000) -- Wait for other resources to load
        ClearAllCache()
        isResourceStarting = true
    end
end)

-- Clear cache command for admins
RegisterCommand('clearmulticache', function()
    if QRCore.Functions.GetPlayerData().job and QRCore.Functions.GetPlayerData().job.name == 'admin' then
        ClearAllCache()
        lib.notify({
            title = Locale('cache_cleared'),
            description = Locale('multi_cache_success'),
            type = 'success'
        })
    end
end, false)

-- Initialize with clean state
CreateThread(function()
    -- Initial cleanup on resource start
    Wait(3000) -- Ensure everything is loaded
    ClearAllCache()
    
    DebugPrint("QR-Multicharacter client initialized with clean state", 'client')
    print("^2[qr-multicharacter] Client initialized successfully^0")
    print("^2[qr-multicharacter] Cache cleared and ready for use^0")
end)