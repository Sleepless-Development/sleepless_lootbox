local ESX = exports['es_extended']:getSharedObject()

local Framework = {}

Framework.name = 'esx'

---@param item string
---@param cb fun(source: number)
function Framework.registerUsableItem(item, cb)
    ESX.RegisterUsableItem(item, function(source)
        cb(source)
    end)
end

return Framework
