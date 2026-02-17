local config = require 'config'

local ox_inventory = exports.ox_inventory

local Inventory = {}

Inventory.name = 'ox_inventory'

---@param source number
---@param item string
---@return number
function Inventory.getItemCount(source, item)
    return ox_inventory:GetItemCount(source, item) or 0
end

---@param source number
---@param item string
---@param amount number
---@param metadata? table
---@param slot? number
---@return boolean
function Inventory.removeItem(source, item, amount, metadata, slot)
    return ox_inventory:RemoveItem(source, item, amount, metadata, slot) or false
end

---@param source number
---@param item string
---@param amount number
---@param metadata? table
---@return boolean
function Inventory.addItem(source, item, amount, metadata)
    if not Inventory.canCarry(source, item, amount) then
        local dropId = ox_inventory:CreateDropFromPlayer(source)
        if dropId then
            return ox_inventory:AddItem(dropId, item, amount, metadata) or false
        end
        return false
    end

    return ox_inventory:AddItem(source, item, amount, metadata) or false
end

---@param item string
---@return string?
function Inventory.getItemLabel(item)
    local itemData = ox_inventory:Items(item)
    return itemData and itemData.label
end

---@param item string
---@return string?
function Inventory.getItemImage(item)
    local itemData = ox_inventory:Items(item)
    if not itemData then return nil end

    -- ox_inventory stores images in web/images/
    if itemData.client and itemData.client.image then
        return itemData.client.image
    end

    -- Default ox_inventory image path
    return ('%s/%s.%s'):format(config.imagePath, item, config.imageExtension)
end

---@param source number
---@param item string
---@param amount number
---@return boolean
function Inventory.canCarry(source, item, amount)
    return ox_inventory:CanCarryItem(source, item, amount) or false
end

---@param source number
---@param moneyType string
---@param amount number
---@return boolean
function Inventory.addMoney(source, moneyType, amount)
    -- ox_inventory uses 'money' item for cash
    local moneyItem = moneyType == 'cash' and 'money' or moneyType
    return Inventory.addItem(source, moneyItem, amount)
end

return Inventory
