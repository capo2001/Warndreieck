ESX = exports["es_extended"]:getSharedObject()

-- Event um das Item zurückzugeben, wenn das Prop aufgehoben wird
RegisterNetEvent('warndreieck:giveItem')
AddEventHandler('warndreieck:giveItem', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addInventoryItem(Config.WarndreieckItem, 1)
end)

-- Registriere das Warndreieck als benutzbares Item
ESX.RegisterUsableItem('warndreieck', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.removeInventoryItem('warndreieck', 1)
    TriggerClientEvent('warndreieck:use', source) -- Trigger das Event, um das Warndreieck zu verwenden
end)