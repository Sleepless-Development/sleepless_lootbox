local Framework = {}

Framework.name = 'qbx'

---@param item string
---@param cb fun(source: number)
function Framework.registerUsableItem(item, cb)
    exports.qbx_core:CreateUseableItem(item, function(source)
        cb(source)
    end)
end

return Framework
