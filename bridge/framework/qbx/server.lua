local Framework = {}

Framework.name = 'qbx'

---@param item string
---@param cb fun(source: number)
function Framework.registerUsableItem(item, cb)
    exports(item, function(event, itemData, inv, slot, data)
        if event == 'usingItem' then
            return cb(inv.id)
        end
    end)
end

return Framework
