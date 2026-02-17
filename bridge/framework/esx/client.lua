local ESX = exports['es_extended']:getSharedObject()

local Framework = {}

Framework.name = 'esx'

---@return boolean
function Framework.isPlayerLoaded()
    return ESX.IsPlayerLoaded() or false
end

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    TriggerEvent('sleepless_lootbox:client:frameworkReady')
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    if ESX.IsPlayerLoaded() then
        TriggerEvent('sleepless_lootbox:client:frameworkReady')
    end
end)

return Framework
