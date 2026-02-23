local Ox = require '@ox_core.lib.init'

local Framework = {}

Framework.name = 'ox'

---@return boolean
function Framework.isPlayerLoaded()
    return OxPlayer.charId ~= nil
end

CreateThread(function()
    while not Framework.isPlayerLoaded() do
        Wait(100)
    end
    TriggerEvent('sleepless_lootbox:client:frameworkReady')
end)

AddEventHandler('ox:playerLoaded', function(playerId, isNew)
    TriggerEvent('sleepless_lootbox:client:frameworkReady')
end)

AddEventHandler('onResourceStart', function(resource)
    if resource ~= cache.resource then return end
    if Framework.isPlayerLoaded() then
        TriggerEvent('sleepless_lootbox:client:frameworkReady')
    end
end)

return Framework
