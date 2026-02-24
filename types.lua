---@meta

---@alias Rarity 'common' | 'uncommon' | 'rare' | 'epic' | 'legendary'

-------------------------------------------------
-- External Types
-------------------------------------------------

---@class OxSelector
---@field new fun(self: OxSelector, items: WeightedLootItem[]): OxSelector Create a new selector
---@field getRandomWeighted fun(self: OxSelector): LootItemData Get a random item based on weights

-------------------------------------------------
-- Loot Item Types
-------------------------------------------------

---@class BonusItem
---@field name string Item spawn name
---@field amount number Amount to give
---@field metadata? table<string, any> Optional item metadata

---@class LootItemData
---@field name string Item spawn name
---@field amount number Amount to give
---@field metadata? table<string, any> Optional item metadata
---@field rarity? Rarity Optional rarity for UI display (auto-calculated from weight if not provided)
---@field label? string Item label (auto-fetched from inventory if not provided)
---@field image? string Custom image URL (auto-fetched from inventory if not provided)
---@field bonusItems? BonusItem[] Optional bonus items to award alongside the main item (not displayed in UI)
---@field rewardType? string Custom reward type (e.g., 'vehicle', 'weapon', etc.). Default is 'item'. Custom types require a reward hook to handle them.
---@field rewardData? table<string, any> Custom data for reward hooks (e.g., vehicle model, garage, etc.)

---@alias WeightedLootItem { [1]: number, [2]: LootItemData } Weight and item data tuple

-------------------------------------------------
-- Lootbox Types
-------------------------------------------------

---@class LootboxData
---@field label string Display name for the lootbox
---@field image? string Custom image for the lootbox
---@field description? string Optional description for the lootbox
---@field items WeightedLootItem[] Array of weighted loot items
---@field registerItem? boolean Whether to register as usable item (default: true)
---@field rarityThresholds? table<Rarity, number> Optional per-lootbox rarity weight thresholds

---@class LootboxEntry
---@field label string Display name
---@field image? string Custom image URL
---@field description? string Optional description
---@field selector OxSelector The ox_lib selector instance
---@field items WeightedLootItem[] Raw items array for preview
---@field totalWeight number Total weight of all items
---@field rarityThresholds? table<Rarity, number> Optional per-lootbox rarity weight thresholds

-------------------------------------------------
-- Roll Types
-------------------------------------------------

---@class RollItem
---@field name string Item spawn name
---@field label string Item display label
---@field amount number Amount
---@field image string Image URL
---@field rarity Rarity Rarity tier
---@field rarityColor string Hex color for the rarity
---@field rarityLabel string Display label for the rarity
---@field weight number Original weight
---@field chance number Percentage chance (0-100)
---@field metadata? table<string, any> Optional item metadata
---@field bonusItems? BonusItem[] Optional bonus items to award alongside the main item
---@field rewardType? string Custom reward type (e.g., 'vehicle', 'item')
---@field rewardData? table<string, any> Custom data for reward hooks

---@class RollData
---@field pool RollItem[] Array of items for the roller
---@field winnerIndex number Index of the winning item (1-based for Lua, 0-based sent to UI)
---@field winner RollItem The winning item data
---@field caseName string The lootbox identifier
---@field caseLabel string The lootbox display label

-------------------------------------------------
-- Client State
-------------------------------------------------

---@class ClientLootboxState
---@field isRolling boolean Whether a roll is in progress
---@field currentCase? string Name of the current case being rolled

-------------------------------------------------
-- Bridge Types
-------------------------------------------------

---@class FrameworkBridge
---@field name string Framework name identifier
---@field registerUsableItem fun(item: string, cb: fun(source: number)) Register a usable item

---@class InventoryBridge
---@field name string Inventory name identifier
---@field getItemCount fun(source: number, item: string): number Get item count
---@field removeItem fun(source: number, item: string, amount: number, metadata?: table): boolean Remove item
---@field addItem fun(source: number, item: string, amount: number, metadata?: table): boolean Add item
---@field addMoney? fun(source: number, moneyType: string, amount: number): boolean Add money to player
---@field getItemLabel fun(item: string): string? Get item label
---@field getItemImage fun(item: string): string? Get item image URL

-------------------------------------------------
-- Config Types
-------------------------------------------------

---@class LootboxConfig
---@field poolSize number Number of items in the roller pool
---@field animationDuration number Duration of roll animation in ms
---@field defaultImage string Default image for items without one
---@field rarityThresholds table<Rarity, number> Weight thresholds for auto-rarity calculation
---@field sounds LootboxSoundConfig Sound configuration
---@field ui LootboxUIConfig UI configuration

---@class LootboxSoundConfig
---@field enabled boolean Whether sounds are enabled
---@field volume number Sound volume (0-1)

---@class LootboxUIConfig
---@field showChances boolean Show percentage chances in preview
---@field celebrationDuration number Duration of win celebration in ms

-------------------------------------------------
-- Exports
-------------------------------------------------

exports.sleepless_lootbox = {}

--- `client`
--- Open the preview modal for a lootbox
---@param caseName string The lootbox name to preview
function exports.sleepless_lootbox:preview(caseName) end

--- `client`
--- Check if a roll is currently in progress
---@return boolean
function exports.sleepless_lootbox:isRolling() end

--- `server`
--- Register a new lootbox
---@param name string Unique lootbox identifier
---@param data LootboxData Lootbox configuration
---@return boolean success Whether registration was successful
function exports.sleepless_lootbox:registerLootbox(name, data) end

--- `server`
--- Unregister a lootbox
---@param name string Lootbox identifier to remove
function exports.sleepless_lootbox:unregisterLootbox(name) end

--- `server`
--- Get a lootbox by name
---@param name string Lootbox identifier
---@return LootboxEntry?
function exports.sleepless_lootbox:getLootbox(name) end

--- `server`
--- Get all registered lootboxes
---@return table<string, LootboxEntry>
function exports.sleepless_lootbox:getAllLootboxes() end

--- `server`
--- Open a lootbox for a player (handles item removal, rolling, and reward)
---@param source number Player server ID
---@param caseName string Lootbox identifier
---@param skipItemRemoval? boolean If true, won't try to remove the case item from inventory
---@return boolean success Whether the case was opened successfully
function exports.sleepless_lootbox:open(source, caseName, skipItemRemoval) end

--- `server`
--- Get preview data for a lootbox (items and chances)
---@param caseName string Lootbox identifier
---@return RollItem[]? items Array of items with chances, or nil if not found
function exports.sleepless_lootbox:getPreview(caseName) end

--- `server`
--- Register a custom reward hook for a specific reward type (vehicles, etc.)
--- The hook receives (source, reward, caseName) and should return true if it handled the reward
---@param rewardType string The reward type to handle (e.g., 'vehicle')
---@param hook fun(source: number, reward: RollItem, caseName: string): boolean?
function exports.sleepless_lootbox:registerRewardHook(rewardType, hook) end

--- `server`
--- Remove a custom reward hook for a specific reward type
---@param rewardType string The reward type to remove
function exports.sleepless_lootbox:removeRewardHook(rewardType) end
