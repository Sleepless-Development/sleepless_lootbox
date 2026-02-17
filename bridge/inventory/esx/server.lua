local config = require 'config'

local ESX = exports['es_extended']:getSharedObject()

local Inventory = {}

Inventory.name = 'esx'

---@param source number
---@param item string
---@return number
function Inventory.getItemCount(source, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return 0 end

    local itemData = xPlayer.getInventoryItem(item)
    return itemData and itemData.count or 0
end

---@param source number
---@param item string
---@param amount number
---@param metadata? table
---@return boolean
function Inventory.removeItem(source, item, amount, metadata)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return false end

    local count = Inventory.getItemCount(source, item)
    if count < amount then return false end

    xPlayer.removeInventoryItem(item, amount)
    return true
end

---@param source number
---@param item string
---@param amount number
---@param metadata? table
---@return boolean
function Inventory.addItem(source, item, amount, metadata)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return false end

    -- Handle money specially
    if item == 'money' then
        xPlayer.addMoney(amount)
        return true
    end

    if item == 'black_money' then
        xPlayer.addAccountMoney('black_money', amount)
        return true
    end

    xPlayer.addInventoryItem(item, amount, metadata)
    return true
end

---@param item string
---@return string?
function Inventory.getItemLabel(item)
    local itemData = ESX.GetItemLabel(item)
    return itemData
end

---@param item string
---@return string?
function Inventory.getItemImage(item)
    -- ESX doesn't have a standard way to get item images
    -- Return nil and let the system use default
    return nil
end

---@param source number
---@param moneyType string
---@param amount number
---@return boolean
function Inventory.addMoney(source, moneyType, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return false end

    if moneyType == 'cash' or moneyType == 'money' then
        xPlayer.addMoney(amount)
    else
        xPlayer.addAccountMoney(moneyType, amount)
    end

    return true
end

return Inventory
