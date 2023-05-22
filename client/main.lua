local charPed = nil
local choosingCharacter = false
local currentSkin = nil
local currentClothes = nil
local selectingChar = true
local PlayerSkins = {}
local PlayerClothes = {}
local characters = {}
local QRCore = exports['qr-core']:GetCoreObject()

local cams = {
    {
        type = "customization",
        x = -561.8157,
        y = -3780.966,
        z = 239.0805,
        rx = -4.2146,
        ry = -0.0007,
        rz = -87.8802,
        fov = 30.0
    },
    {
        type = "selection",
        x = -562.8157,
        y = -3776.266,
        z = 239.0805,
        rx = -4.2146,
        ry = -0.0007,
        rz = -87.8802,
        fov = 30.0
    }
}

-- Handlers

AddEventHandler('onResourceStop', function(resource)
    if (GetCurrentResourceName() == resource) then
        DeleteEntity(charPed)
        SetModelAsNoLongerNeeded(charPed)
    end
end)

-- Functions

-- local function skyCam(bool)
--     if bool then
--         DoScreenFadeIn(1000)
--         SetTimecycleModifier('hud_def_blur')
--         SetTimecycleModifierStrength(1.0)
--         cam = CreateCam("DEFAULT_SCRIPTED_CAMERA")
--         SetCamCoord(cam, -555.925, -3778.709, 238.597)
--         SetCamRot(cam, -20.0, 0.0, 83)
--         SetCamActive(cam, true)
--         RenderScriptCams(true, false, 1, true, true)
--         fixedCam = CreateCam("DEFAULT_SCRIPTED_CAMERA")
--         SetCamCoord(fixedCam, -561.206, -3776.224, 239.597)
--         SetCamRot(fixedCam, -20.0, 0, 270.0)
--         SetCamActive(fixedCam, true)
--         SetCamActiveWithInterp(fixedCam, cam, 3900, true, true)
--         Wait(3900)
--         DestroyCam(groundCam)
--         InterP = true
--     else
--         SetTimecycleModifier('default')
--         SetCamActive(cam, false)
--         DestroyCam(cam, true)
--         RenderScriptCams(false, false, 1, true, true)
--         FreezeEntityPosition(PlayerPedId(), false)
--     end
-- end

local function openCharMenu(bool)
    QRCore.Functions.TriggerCallback("qr-multicharacter:server:GetNumberOfCharacters", function(result)
        SetNuiFocus(bool, bool)
        SendNUIMessage({
            action = "ui",
            toggle = bool,
            nChar = result,
        })
        choosingCharacter = bool
        -- Wait(100)
        -- skyCam(bool)
    end)
end


RegisterNetEvent('qr-multicharacter:client:closeNUI', function()
    DeleteEntity(charPed)
    SetNuiFocus(false, false)
end)

RegisterNetEvent('qr-multicharacter:client:chooseChar', function()
    SetEntityVisible(PlayerPedId(), false, false)
    SetNuiFocus(false, false)
    DoScreenFadeOut(10)
    Wait(1000)
    GetInteriorAtCoords(-558.9098, -3775.616, 238.59, 137.98)
    FreezeEntityPosition(PlayerPedId(), true)
    SetEntityCoords(PlayerPedId(), -562.91,-3776.25,237.63)
    Wait(1500)
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
    Wait(10)
    openCharMenu(true)
    while selectingChar do
        Wait(1)
        local coords = GetEntityCoords(PlayerPedId())
    end
end)

-- NUI

RegisterNUICallback('closeUI', function()
    openCharMenu(false)
end)

RegisterNUICallback('disconnectButton', function()
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)
    TriggerServerEvent('qr-multicharacter:server:disconnect')
end)

RegisterNUICallback('selectCharacter', function(data) -- When a char is selected and confirmed to use
    CreateThread(function()
        selectingChar = false
        local cData = data.cData
        DoScreenFadeOut(10)
        TriggerServerEvent('qr-multicharacter:server:loadUserData', cData)
        openCharMenu(false)
        local model = IsPedMale(charPed) and 'mp_male' or 'mp_female'
        SetEntityAsMissionEntity(charPed, true, true)
        DeleteEntity(charPed)
        Wait(5000)
        TriggerServerEvent("qr_appearance:loadSkin")
        Wait(500)
        TriggerServerEvent("qr_clothes:LoadClothes", 1)
        SetModelAsNoLongerNeeded(model)
    end)
end)

RegisterNUICallback('setupCharacters', function() -- Present char info
    QRCore.Functions.TriggerCallback("qr-multicharacter:server:setupCharacters", function(result)
        SendNUIMessage({
            action = "setupCharacters",
            characters = result
        })
    end)
end)

RegisterNUICallback('removeBlur', function()
    SetTimecycleModifier('default')
end)

RegisterNUICallback('createNewCharacter', function(data) -- Creating a char
    DoScreenFadeOut(150)
    Wait(200)
    DestroyAllCams(true)
    DeleteEntity(charPed)
    TriggerEvent("qr_appearance:OpenCreator")
    SetModelAsNoLongerNeeded(charPed)
    TriggerServerEvent('qr-multicharacter:server:createCharacter', data)
    Wait(1000)
    DoScreenFadeIn(1000)
end)

RegisterNUICallback('removeCharacter', function(data) -- Removing a char
    TriggerServerEvent('qr-multicharacter:server:deleteCharacter', data.citizenid)
    TriggerEvent('qr-multicharacter:client:chooseChar')
end)