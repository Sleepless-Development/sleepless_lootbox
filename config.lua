local config = {}

-------------------------------------------------
-- General Settings
-------------------------------------------------
config.debug = true

-- image file extension
config.imageExtension = 'webp'

-- image path
config.imagePath = "nui://ox_inventory/web/images"

-- Whether to automatically register lootboxes as usable items
config.registerUsableItems = true

-------------------------------------------------
-- Rarity Configuration
-------------------------------------------------
-- Define rarity tiers and their colors for UI display
-- Items can optionally specify a rarity, or it can be auto-calculated from weight

-- Default rarity odds (weights summing to 100):
--   Common: 80%      (weight 80)
--   Uncommon: 16%    (weight 16)
--   Rare: 3.10%      (weight 3.1)
--   Epic: 0.64%      (weight 0.64)
--   Legendary: 0.26% (weight 0.26)

config.rarities = {
    common = {
        label = 'Common',
        color = '#94999a',
        minWeight = 17, -- Items with weight >= 17 are considered common
    },
    uncommon = {
        label = 'Uncommon',
        color = '#26c057',
        minWeight = 4, -- Items with weight >= 4 are considered uncommon
    },
    rare = {
        label = 'Rare',
        color = '#0aa7e6',
        minWeight = 1, -- Items with weight >= 1 are considered rare
    },
    epic = {
        label = 'Epic',
        color = '#d02e9b',
        minWeight = 0.3, -- Items with weight >= 0.3 are considered epic
    },
    legendary = {
        label = 'Legendary',
        color = '#ffc500',
        minWeight = 0, -- Items with weight < 0.3 are considered legendary
    },
}

-- Order of rarities from most common to least common (for auto-calculation)
config.rarityOrder = { 'common', 'uncommon', 'rare', 'epic', 'legendary' }

-------------------------------------------------
-- Lootbox Definitions
-------------------------------------------------
-- Format: { weight, { name = 'item_name', amount = 1, metadata = {}, rarity = 'optional' } }
-- Weight determines drop chance relative to other items
-- Higher weight = more common
--
-- Example: If you have items with weights 80, 15, 4, 1 (total 100)
--   - 80 weight item has 80% chance
--   - 15 weight item has 15% chance
--   - 4 weight item has 4% chance
--   - 1 weight item has 1% chance

config.lootboxes = {
    ['gun_case'] = {
        label = 'Gun Case',
        description = 'Contains various firearms',
        -- Optional: Override rarity thresholds for this specific lootbox
        -- rarityThresholds = {
        --     common = 17,
        --     uncommon = 4,
        --     rare = 1,
        --     epic = 0.3,
        --     legendary = 0,
        -- },
        items = {
            -- Common weapons (~80% total)
            -- bonusItems are awarded alongside the main item but not displayed in the UI
            { 40, {
                name = 'WEAPON_PISTOL',
                amount = 1,
                bonusItems = {
                    { name = 'ammo-9', amount = 50 },
                }
            } },
            { 40, {
                name = 'WEAPON_SNSPISTOL',
                amount = 1,
                bonusItems = {
                    { name = 'ammo-9', amount = 50 },
                }
            } },

            -- Uncommon weapons (~16% total)
            { 8, {
                name = 'WEAPON_VINTAGEPISTOL',
                amount = 1,
                bonusItems = {
                    { name = 'ammo-9', amount = 75 },
                }
            } },
            { 8, {
                name = 'WEAPON_COMBATPISTOL',
                amount = 1,
                bonusItems = {
                    { name = 'ammo-9', amount = 75 },
                }
            } },

            -- Rare weapons (~3.1% total)
            { 1.5, {
                name = 'WEAPON_HEAVYPISTOL',
                amount = 1,
                bonusItems = {
                    { name = 'ammo-45', amount = 100 },
                }
            } },
            { 1.6, {
                name = 'WEAPON_PISTOLXM3',
                amount = 1,
                bonusItems = {
                    { name = 'ammo-9', amount = 100 },
                }
            } },

            -- Epic weapons (~0.64% total)
            { 0.34, {
                name = 'WEAPON_APPISTOL',
                amount = 1,
                bonusItems = {
                    { name = 'ammo-9', amount = 150 },
                    { name = 'armour', amount = 1 },
                }
            } },
            { 0.3, {
                name = 'WEAPON_MACHINEPISTOL',
                amount = 1,
                bonusItems = {
                    { name = 'ammo-9', amount = 150 },
                    { name = 'armour', amount = 1 },
                }
            } },

            -- Legendary weapons (~0.26% total)
            { 0.13, {
                name = 'WEAPON_COMBATPDW',
                amount = 1,
                bonusItems = {
                    { name = 'ammo-9', amount = 250 },
                    { name = 'armour', amount = 2 },
                }
            } },
            { 0.1, {
                name = 'WEAPON_CARBINERIFLE',
                amount = 1,
                bonusItems = {
                    { name = 'ammo-rifle', amount = 250 },
                    { name = 'armour',     amount = 2 },
                }
            } },
            { 0.03, {
                name = 'WEAPON_RPG',
                amount = 1,
                bonusItems = {
                    { name = 'ammo-rocket', amount = 5 },
                    { name = 'armour',      amount = 3 },
                    { name = 'money',       amount = 5000 },
                }
            } },
        },
    },

    ['supply_crate'] = {
        label = 'Supply Crate',
        description = 'Contains useful supplies and materials',
        items = {
            -- Common supplies (~80% total)
            { 40,   { name = 'bread', amount = 5 } },
            { 40,   { name = 'water', amount = 5 } },

            -- Uncommon supplies (~16% total)
            { 8,    { name = 'bandage', amount = 3 } },
            { 8,    { name = 'medkit', amount = 1 } },

            -- Rare supplies (~3.1% total)
            { 1.6,  { name = 'armour', amount = 1 } },
            { 1.5,  { name = 'lockpick', amount = 2 } },

            -- Epic (~0.64% total)
            { 0.34, { name = 'radio', amount = 1 } },
            { 0.3,  { name = 'drill', amount = 1 } },

            -- Legendary (~0.26% total)
            { 0.26, { name = 'thermite', amount = 1 } },
        },
    },

    ['vip_case'] = {
        label = 'VIP Case',
        description = 'Premium rewards for VIP members',
        items = {
            -- Common (~80% total)
            { 40,   { name = 'armour', amount = 5 } },
            { 40,   { name = 'medkit', amount = 3 } },

            -- Uncommon - money rewards (~16% total)
            { 8,    { name = 'money', amount = 10000 } },
            { 8,    { name = 'money', amount = 25000 } },

            -- Rare (~3.1% total)
            { 1.6,  { name = 'money', amount = 50000 } },
            { 1.5,  { name = 'money', amount = 75000 } },

            -- Epic (~0.64% total)
            { 0.64, { name = 'WEAPON_PISTOL_MK2', amount = 1 } },

            -- Legendary (~0.26% total)
            { 0.26, { name = 'WEAPON_SPECIALCARBINE', amount = 1 } },
        },
    },

    --[[
        Example: Custom Reward Types (Vehicles, Bank, etc.)

        To use custom reward types, register a hook for each type in your own resource.
        Each reward type gets its own handler function.

        Example hook registration (in your own server script):

        -- Register a handler for 'vehicle' reward types
        exports.sleepless_lootbox:registerRewardHook('vehicle', function(source, reward, caseName)
            -- reward.rewardData contains: { model = 'adder', garage = 'legion' }
            local data = reward.rewardData
            -- e.g., exports['qbx_vehicles']:CreatePlayerVehicle(source, data.model, data.garage)
            return true -- Return true to indicate we handled this reward
        end)

        -- Register a handler for 'bank' reward types
        exports.sleepless_lootbox:registerRewardHook('bank', function(source, reward, caseName)
            local data = reward.rewardData
            -- e.g., exports['qbx_core']:AddMoney(source, 'bank', data.amount)
            return true
        end)

        -- You can remove a hook later if needed
        exports.sleepless_lootbox:removeRewardHook('vehicle')
    ]]

    ['vehicle_crate'] = {
        label = 'Vehicle Crate',
        description = 'Win a brand new vehicle!',
        items = {
            -- Common vehicles (~80% total)
            { 40, {
                name = 'vehicle_blista',
                label = 'Blista',
                amount = 1,
                image = 'nui://ox_inventory/web/images/vehicle_crate.webp', -- Custom image for display
                rewardType = 'vehicle',
                rewardData = { model = 'blista', garage = 'legion' },
            } },
            { 40, {
                name = 'vehicle_prairie',
                label = 'Prairie',
                amount = 1,
                image = 'nui://ox_inventory/web/images/vehicle_crate.webp',
                rewardType = 'vehicle',
                rewardData = { model = 'prairie', garage = 'legion' },
            } },

            -- Uncommon vehicles (~16% total)
            { 8, {
                name = 'vehicle_buffalo',
                label = 'Buffalo',
                amount = 1,
                image = 'nui://ox_inventory/web/images/vehicle_crate.webp',
                rewardType = 'vehicle',
                rewardData = { model = 'buffalo', garage = 'legion' },
            } },
            { 8, {
                name = 'vehicle_sultan',
                label = 'Sultan',
                amount = 1,
                image = 'nui://ox_inventory/web/images/vehicle_crate.webp',
                rewardType = 'vehicle',
                rewardData = { model = 'sultan', garage = 'legion' },
            } },

            -- Rare vehicles (~3.1% total)
            { 1.6, {
                name = 'vehicle_elegy2',
                label = 'Elegy RH8',
                amount = 1,
                image = 'nui://ox_inventory/web/images/vehicle_crate.webp',
                rewardType = 'vehicle',
                rewardData = { model = 'elegy2', garage = 'legion' },
            } },
            { 1.5, {
                name = 'vehicle_comet2',
                label = 'Comet',
                amount = 1,
                image = 'nui://ox_inventory/web/images/vehicle_crate.webp',
                rewardType = 'vehicle',
                rewardData = { model = 'comet2', garage = 'legion' },
            } },

            -- Epic vehicles (~0.64% total)
            { 0.64, {
                name = 'vehicle_zentorno',
                label = 'Zentorno',
                amount = 1,
                image = 'nui://ox_inventory/web/images/vehicle_crate.webp',
                rarity = 'epic',
                rewardType = 'vehicle',
                rewardData = { model = 'zentorno', garage = 'legion' },
            } },

            -- Legendary vehicles (~0.26% total)
            { 0.26, {
                name = 'vehicle_adder',
                label = 'Adder',
                amount = 1,
                image = 'nui://ox_inventory/web/images/vehicle_crate.webp',
                rarity = 'legendary',
                rewardType = 'vehicle',
                rewardData = { model = 'adder', garage = 'legion' },
            } },
        },
    },
}

-------------------------------------------------
-- Server Settings
-------------------------------------------------
config.server = {
    -- Enable version checking on server start
    versionCheckEnabled = true,
}

return config
