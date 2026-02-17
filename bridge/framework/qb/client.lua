local QBCore = exports['qb-core']:GetCoreObject()

local Framework = {}

Framework.name = 'qb'

---@return boolean
function Framework.isPlayerLoaded()
    local playerData = QBCore.Functions.GetPlayerData()
    return playerData and playerData.citizenid ~= nil
end

CreateThread(function()
    while not Framework.isPlayerLoaded() do
        Wait(100)
    end
    TriggerEvent('sleepless_lootbox:client:frameworkReady')
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    TriggerEvent('sleepless_lootbox:client:frameworkReady')
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    -- Player logged out
end)

AddEventHandler('onResourceStart', function(resource)
    if resource ~= cache.resource then return end
    if Framework.isPlayerLoaded() then
        TriggerEvent('sleepless_lootbox:client:frameworkReady')
    end
end)

return Framework
