local config = require 'config'

local QBCore = exports['qb-core']:GetCoreObject()

local Inventory = {}

Inventory.name = 'qb-inventory'

---@param source number
---@param item string
---@return number
function Inventory.getItemCount(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return 0 end

    local itemData = Player.Functions.GetItemByName(item)
    return itemData and itemData.amount or 0
end

---@param source number
---@param item string
---@param amount number
---@param metadata? table
---@return boolean
function Inventory.removeItem(source, item, amount, metadata)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return false end

    local hasItem = Inventory.getItemCount(source, item) >= amount
    if not hasItem then return false end

    local success = Player.Functions.RemoveItem(item, amount)
    if success then
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], 'remove', amount)
    end
    return success
end

---@param source number
---@param item string
---@param amount number
---@param metadata? table
---@return boolean
function Inventory.addItem(source, item, amount, metadata)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return false end

    local success = Player.Functions.AddItem(item, amount, nil, metadata)
    if success then
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], 'add', amount)
    end
    return success
end

---@param item string
---@return string?
function Inventory.getItemLabel(item)
    local itemData = QBCore.Shared.Items[item]
    if not itemData then
        lib.print.warn(('Item "%s" not found in QBCore.Shared.Items'):format(item))
        return nil
    end
    return itemData.label
end

---@param item string
---@return string?
function Inventory.getItemImage(item)
    local itemData = QBCore.Shared.Items[item]
    if not itemData then return nil end

    -- QB inventory typically stores images in qb-inventory/html/images/
    if itemData.image then
        return ('%s/%s.%s'):format(config.imagePath, itemData.image, config.imageExtension)
    end

    return ('%s/%s.%s'):format(config.imagePath, item, config.imageExtension)
end

---@param source number
---@param moneyType string
---@param amount number
---@return boolean
function Inventory.addMoney(source, moneyType, amount)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return false end

    return Player.Functions.AddMoney(moneyType, amount, 'lootbox-reward')
end

return Inventory
