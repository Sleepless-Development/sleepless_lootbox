---@meta

-----------------------------------------------------------
-- Example ox_inventory item definitions for sleepless_lootbox
-- This file is for reference only and is NOT loaded at runtime.
--
-- Copy the relevant entries into your ox_inventory item
-- definitions (e.g. ox_inventory/data/items.lua).
--
-- IMPORTANT (ox_core users):
--   Lootbox case items MUST include a server.export entry
--   so that ox_inventory triggers this resource when used.
--   The format is: "sleepless_lootbox.<item_name>"
-----------------------------------------------------------

local ox = {
    -------------------------------------------------
    -- Lootbox Case Items
    -- These require server.export for ox_core/ox_inventory
    -------------------------------------------------

    ["gun_case"] = {
        label = "Gun Case",
        description = "Contains various firearms",
        weight = 500,
        stack = true,
        close = false,
        consume = 0,
        server = {
            export = "sleepless_lootbox.gun_case",
        },
        buttons = {
            {
                label = 'Preview Case',
                action = function(slot)
                    exports.ox_inventory:closeInventory()
                    exports.sleepless_lootbox:preview('gun_case')
                end
            },
        },
    },

    ["supply_crate"] = {
        label = "Supply Crate",
        description = "Contains useful supplies and materials",
        weight = 1000,
        stack = true,
        close = false,
        consume = 0,
        server = {
            export = "sleepless_lootbox.supply_crate",
        },
        buttons = {
            {
                label = 'Preview Case',
                action = function(slot)
                    exports.ox_inventory:closeInventory()
                    exports.sleepless_lootbox:preview('supply_crate')
                end
            },
        },
    },

    ["vip_case"] = {
        label = "VIP Case",
        description = "Premium rewards for VIP members",
        weight = 500,
        stack = true,
        close = false,
        consume = 0,
        server = {
            export = "sleepless_lootbox.vip_case",
        },
        buttons = {
            {
                label = 'Preview Case',
                action = function(slot)
                    exports.ox_inventory:closeInventory()
                    exports.sleepless_lootbox:preview('vip_case')
                end
            },
        },
    },
}


-----------------------------------------------------------
-- Example qb-core shared item definitions for sleepless_lootbox
-- This file is for reference only and is NOT loaded at runtime.
--
-- Copy the relevant entries into your qb-core shared items
-- (e.g. qb-core/shared/items.lua).
--
-- NOTE: Lootbox case items MUST have useable = true so that
-- QBCore.Functions.CreateUseableItem works correctly.
-----------------------------------------------------------

-------------------------------------------------
-- Lootbox Case Items
-- These require useable = true
-------------------------------------------------

local qb = {
    ["gun_case"] = {
        name = "gun_case",
        label = "Gun Case",
        weight = 500,
        type = "item",
        image = "gun_case.png",
        unique = false,
        useable = true,
        shouldClose = true,
        combinable = nil,
        description = "Contains various firearms",
    },

    ["supply_crate"] = {
        name = "supply_crate",
        label = "Supply Crate",
        weight = 1000,
        type = "item",
        image = "supply_crate.png",
        unique = false,
        useable = true,
        shouldClose = true,
        combinable = nil,
        description = "Contains useful supplies and materials",
    },

    ["vip_case"] = {
        name = "vip_case",
        label = "VIP Case",
        weight = 500,
        type = "item",
        image = "vip_case.png",
        unique = false,
        useable = true,
        shouldClose = true,
        combinable = nil,
        description = "Premium rewards for VIP members",
    },
}
