ESX = exports["es_extended"]:getSharedObject()

local prop = nil
local isPlacingProp = false
local markerCoords = nil

function LoadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end
end

function LoadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end
end

function PlaceWarndreieck()
    local playerPed = PlayerPedId()
    local pos = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)

    -- Warndreieck setzen
    local modelHash = GetHashKey("bzzz_prop_vehicle_triangle_a")
    LoadModel(modelHash)

    local animDict = "anim@scripted@freemode@ig5_collect_weapons@heeled@"
    local animName = "collect_weapon_1h"
    LoadAnimDict(animDict)
    
    TaskPlayAnim(playerPed, animDict, animName, 8.0, -8.0, 3000, 49, 0, false, false, false)
    TriggerEvent('a_hud::StartProgressBar', 3000, 'Warndreieck aufstellen')
    Citizen.Wait(3000)

    prop = CreateObject(modelHash, pos.x, pos.y, pos.z - 1.0, true, true, true)
    SetEntityHeading(prop, heading)
    PlaceObjectOnGroundProperly(prop)

    markerCoords = GetEntityCoords(prop)
    isPlacingProp = false
end

function PickupWarndreieck()
    if not prop then return end

    DeleteEntity(prop)
    TriggerServerEvent('warndreieck:giveItem')
    TriggerEvent('a_hud::AddNotification', 'info', 'Warndreieck', 'Du hast das Warndreieck aufgehoben!', 2500)

    prop = nil
    markerCoords = nil
end

RegisterNetEvent('warndreieck:use')
AddEventHandler('warndreieck:use', function()
    if not isPlacingProp and not prop then
        isPlacingProp = true
        PlaceWarndreieck()
    else
        TriggerEvent('a_hud::AddNotification', 'error', 'Warndreieck', 'Du kannst nur ein Warndreieck gleichzeitig platzieren!', 2500)
    end
end)

-- Nähe zum Marker überwachen und auf E reagieren
Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        if markerCoords then
            local playerPed = PlayerPedId()
            local pos = GetEntityCoords(playerPed)
            local distance = #(pos - markerCoords)

            if distance < 10.0 then
                sleep = 0
                DrawMarker(1, markerCoords.x, markerCoords.y, markerCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.4, 0.4, 255, 0, 0, 0, false, false, 2, false, nil, nil, false)

                if distance < 1.2 then
                    TriggerEvent('a_hud::HelpNotification', 'E', 'Drücke E um das Warndreieck aufzuheben')

                    if IsControlJustPressed(0, 38) then
                        local animDict = "anim@scripted@freemode@ig5_collect_weapons@heeled@"
                        local animName = "collect_weapon_1h"
                        LoadAnimDict(animDict)

                        TaskPlayAnim(playerPed, animDict, animName, 8.0, -8.0, 3000, 49, 0, false, false, false)
                        Citizen.Wait(3000)
                        PickupWarndreieck()
                    end
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

-- Taste zum Platzieren (z. B. Config.UseKey = 38 für E)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(0, Config.UseKey or 38) then
            TriggerServerEvent('warndreieck:useItem')
        end
    end
end)
