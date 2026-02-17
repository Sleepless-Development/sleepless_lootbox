local QBCore = exports['qb-core']:GetCoreObject()

local Framework = {}

Framework.name = 'qb'

---@param item string
---@param cb fun(source: number)
function Framework.registerUsableItem(item, cb)
    QBCore.Functions.CreateUseableItem(item, function(source)
        cb(source)
    end)
end

return Framework
