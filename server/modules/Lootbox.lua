local config = require 'config'
local bridge = require 'bridge.init'

local Framework = bridge.Framework
local Inventory = bridge.Inventory

local POOL_SIZE = 100

---@class LootboxManager
local LootboxManager = {}

---@type table<string, LootboxEntry>
local lootboxes = {}

---@type table<number, RollItem>
local playerPendingRewards = {}

---@param weight number
---@param thresholds? table<string, number> Optional per-lootbox rarity thresholds
---@return Rarity
local function calculateRarity(weight, thresholds)
    for i = 1, #config.rarityOrder do
        local rarityName = config.rarityOrder[i]
        local minWeight = thresholds and thresholds[rarityName] or config.rarities[rarityName].minWeight
        if weight >= minWeight then
            return rarityName
        end
    end

    return 'legendary'
end

---@param items WeightedLootItem[]
---@return number
local function calculateTotalWeight(items)
    local total = 0
    for i = 1, #items do
        total = total + items[i][1]
    end
    return total
end

---@param item LootItemData
---@param weight number
---@param totalWeight number
---@param thresholds? table<string, number> Optional per-lootbox rarity thresholds
---@return RollItem
local function createRollItem(item, weight, totalWeight, thresholds)
    local rarity = item.rarity or calculateRarity(weight, thresholds)
    local rarityData = config.rarities[rarity]
    local label = item.label
    local image = item.image

    if not label and Inventory and Inventory.getItemLabel then
        label = Inventory.getItemLabel(item.name)
    end

    if not image and Inventory and Inventory.getItemImage then
        image = Inventory.getItemImage(item.name)
    end

    return {
        name = item.name,
        label = label or item.name,
        amount = item.amount,
        image = image or ('%s/%s.%s'):format(config.imagePath, item.name, config.imageExtension),
        rarity = rarity,
        rarityColor = rarityData and rarityData.color or '#ffffff',
        rarityLabel = rarityData and rarityData.label or rarity,
        weight = weight,
        chance = (weight / totalWeight) * 100,
        metadata = item.metadata,
    }
end

---@param name string
---@param data LootboxData
---@return boolean
function LootboxManager.register(name, data)
    if lootboxes[name] then
        lib.print.warn(('Lootbox "%s" already exists, skipping registration'):format(name))
        return false
    end

    if not data.items or #data.items == 0 then
        lib.print.error(('Lootbox "%s" has no items defined'):format(name))
        return false
    end

    local totalWeight = calculateTotalWeight(data.items)
    local selector = lib.selector:new(data.items)

    lootboxes[name] = {
        label = data.label or name,
        image = data.image,
        description = data.description,
        selector = selector,
        items = data.items,
        totalWeight = totalWeight,
        rarityThresholds = data.rarityThresholds,
    }

    if config.registerUsableItems and data.registerItem ~= false then
        if Framework and Framework.registerUsableItem then
            Framework.registerUsableItem(name, function(source)
                LootboxManager.open(source, name)
            end)
            lib.print.info(('Registered usable item for lootbox: %s'):format(name))
        end
    end

    lib.print.info(('Registered lootbox: %s with %d items (total weight: %.2f)'):format(name, #data.items, totalWeight))
    return true
end

---@param name string
function LootboxManager.unregister(name)
    if not lootboxes[name] then
        lib.print.warn(('Lootbox "%s" does not exist'):format(name))
        return
    end

    lootboxes[name] = nil
    lib.print.info(('Unregistered lootbox: %s'):format(name))
end

---@param name string
---@return LootboxEntry?
function LootboxManager.get(name)
    return lootboxes[name]
end

---@return table<string, LootboxEntry>
function LootboxManager.getAll()
    return lootboxes
end

---@param caseName string
---@return RollItem[]?
function LootboxManager.getPreview(caseName)
    local lootbox = lootboxes[caseName]
    if not lootbox then return nil end

    local preview = {}
    for i = 1, #lootbox.items do
        local weight = lootbox.items[i][1]
        local itemData = lootbox.items[i][2]
        preview[#preview + 1] = createRollItem(itemData, weight, lootbox.totalWeight, lootbox.rarityThresholds)
    end

    table.sort(preview, function(a, b)
        return a.weight > b.weight
    end)

    return preview
end

---@param lootbox LootboxEntry
---@param itemData LootItemData
---@return number weight
local function findWeightForItem(lootbox, itemData)
    for i = 1, #lootbox.items do
        local weight = lootbox.items[i][1]
        local item = lootbox.items[i][2]
        if item.name == itemData.name and item.amount == itemData.amount then
            return weight
        end
    end
    return 1
end

---@param lootbox LootboxEntry
---@return RollItem[], number
local function generateRollPool(lootbox)
    local pool = {}

    for i = 1, POOL_SIZE do
        local selectedItem = lootbox.selector:getRandomWeighted()
        if selectedItem then
            local weight = findWeightForItem(lootbox, selectedItem)
            local rollItem = createRollItem(selectedItem, weight, lootbox.totalWeight, lootbox.rarityThresholds)
            pool[#pool + 1] = rollItem
        end
    end

    local winnerItem = lootbox.selector:getRandomWeighted()
    local winnerWeight = findWeightForItem(lootbox, winnerItem)
    local winnerRollItem = createRollItem(winnerItem, winnerWeight, lootbox.totalWeight, lootbox.rarityThresholds)
    local winnerIndex = math.random(math.floor(POOL_SIZE * 0.7), POOL_SIZE - 5)

    pool[winnerIndex] = winnerRollItem

    return pool, winnerIndex
end

---@param source number
---@param caseName string
---@param skipItemRemoval? boolean
---@return boolean
function LootboxManager.open(source, caseName, skipItemRemoval)
    local lootbox = lootboxes[caseName]
    if not lootbox then
        lib.print.error(('Player %d tried to open non-existent lootbox: %s'):format(source, caseName))
        return false
    end

    if playerPendingRewards[source] then
        lib.print.warn(('Player %d already has a pending reward'):format(source))
        return false
    end

    if not skipItemRemoval then
        if not Inventory then
            lib.print.error('No inventory bridge available')
            return false
        end

        local hasItem = Inventory.getItemCount(source, caseName) >= 1
        if not hasItem then
            lib.print.warn(('Player %d does not have item: %s'):format(source, caseName))
            return false
        end

        local removed = Inventory.removeItem(source, caseName, 1)
        if not removed then
            lib.print.error(('Failed to remove item %s from player %d'):format(caseName, source))
            return false
        end
    end

    local pool, winnerIndex = generateRollPool(lootbox)
    local winner = pool[winnerIndex]

    playerPendingRewards[source] = winner

    TriggerClientEvent('sleepless_lootbox:roll', source, {
        pool = pool,
        winnerIndex = winnerIndex - 1,
        caseName = caseName,
        caseLabel = lootbox.label,
    })

    lib.print.info(('Player %d rolling %s - Winner: %s (index %d)'):format(source, caseName, winner.name, winnerIndex))
    return true
end

---@param source number
function LootboxManager.claimReward(source)
    local reward = playerPendingRewards[source]
    if not reward then
        lib.print.error(('Player %d tried to claim reward but has no pending reward'):format(source))
        return
    end

    playerPendingRewards[source] = nil

    if not Inventory then
        lib.print.error('No inventory bridge available for reward')
        return
    end

    if reward.name == 'money' or reward.name == 'cash' then
        if Inventory.addMoney then
            Inventory.addMoney(source, 'cash', reward.amount)
        else
            Inventory.addItem(source, 'money', reward.amount)
        end
        lib.print.info(('Player %d received $%d from lootbox'):format(source, reward.amount))
        return
    end

    local success = Inventory.addItem(source, reward.name, reward.amount, reward.metadata)
    if success then
        lib.print.info(('Player %d received %dx %s from lootbox'):format(source, reward.amount, reward.name))
    else
        lib.print.error(('Failed to give %dx %s to player %d'):format(reward.amount, reward.name, source))
    end
end

---@param source number
function LootboxManager.cancelPendingReward(source)
    playerPendingRewards[source] = nil
end

function LootboxManager.init()
    local count = 0
    for name, data in pairs(config.lootboxes) do
        LootboxManager.register(name, data)
        count = count + 1
    end

    lib.print.info(('Initialized %d lootboxes from config'):format(count))
end

return LootboxManager
