local config = require 'config'

local ox_inventory = exports.ox_inventory

local Inventory = {}

Inventory.name = 'ox_inventory'

---@param item string
---@return string?
function Inventory.getItemImage(item)
    return ('%s/%s.%s'):format(config.imagePath, item, config.imageExtension)
end

---@param item string
---@return string?
function Inventory.getItemLabel(item)
    local itemData = ox_inventory:Items(item)
    return itemData and itemData.label
end

---@param item string
---@return number
function Inventory.getItemCount(item)
    return ox_inventory:GetItemCount(item) or 0
end

return Inventory
