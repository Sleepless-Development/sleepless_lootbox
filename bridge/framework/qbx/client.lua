local Framework = {}

Framework.name = 'qbx'

---@return boolean
function Framework.isPlayerLoaded()
    return LocalPlayer.state.isLoggedIn or false
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

AddEventHandler('onResourceStart', function(resource)
    if resource ~= cache.resource then return end
    if Framework.isPlayerLoaded() then
        TriggerEvent('sleepless_lootbox:client:frameworkReady')
    end
end)

return Framework
