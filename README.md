# sleepless_lootbox

![](https://img.shields.io/github/downloads/Sleepless-Development/sleepless_lootbox/total?logo=github)
![](https://img.shields.io/github/downloads/Sleepless-Development/sleepless_lootbox/latest/total?logo=github)
![](https://img.shields.io/github/contributors/Sleepless-Development/sleepless_lootbox?logo=github)
![](https://img.shields.io/github/v/release/Sleepless-Development/sleepless_lootbox?logo=github)

A CS:GO-style lootbox/case opening system for FiveM with weight-based loot pools.

## Features

- 🎰 **CS:GO-style roller animation** - Smooth spinning animation
- ⚖️ **Weight-based loot system** - Uses `ox_lib` selector for flexible drop rates
- 👀 **Preview system** - Players can view case contents and drop chances before opening
- 🎨 **Rarity system** - Visual rarity tiers (Common, Uncommon, Rare, Epic, Legendary)
- 🔧 **Framework agnostic** - Supports ESX, QBCore, Qbox, and ox_core out of the box
- 📦 **Multiple inventory support** - Works with ox_inventory, qb-inventory
- 🎁 **Metadata support** - Items can include custom metadata
- 📝 **Config + Runtime API** - Define lootboxes in config or register them dynamically via exports

## Dependencies

- [ox_lib](https://github.com/communityox/ox_lib) (required)
- A supported framework (ESX, QBCore, Qbox, or ox_core)
- A supported inventory system

## Installation

1. Download and extract to your resources folder
2. Add `ensure sleepless_lootbox` to your server.cfg (after ox_lib and your framework)
3. Configure lootboxes in `config.lua`
4. Build the UI (if not pre-built):
   ```bash
   cd web
   npm install
   npm run build
   ```

## Configuration

### Basic Lootbox Definition

```lua
config.lootboxes = {
    ['gun_case'] = {
        label = 'Gun Case',
        description = 'Contains various firearms',
        items = {
            -- Format: { weight, { name, amount, metadata?, rarity? } }
            { 80, { name = 'WEAPON_PISTOL', amount = 1 } },
            { 15, { name = 'WEAPON_SMG', amount = 1 } },
            { 4, { name = 'WEAPON_RIFLE', amount = 1 } },
            { 1, { name = 'WEAPON_RPG', amount = 1 } },
        },
    },
}
```

### Weight System

Weights determine the relative drop chance of each item:
- Higher weight = more common
- Example: Items with weights 80, 15, 4, 1 (total 100) have 80%, 15%, 4%, and 1% chances respectively
- Weights don't need to add up to 100 - they're calculated relative to the total weight of all items

### Rarity Auto-Calculation

If you don't specify a `rarity` on an item, it's automatically calculated based on the weight:

| Rarity    | Weight Threshold |
|-----------|------------------|
| Common    | weight >= 17     |
| Uncommon  | weight >= 4      |
| Rare      | weight >= 1      |
| Epic      | weight >= 0.3    |
| Legendary | weight < 0.3     |

You can customize these thresholds in `config.lua`.

## Exports

### Server Exports

```lua
-- Register a new lootbox at runtime
exports.sleepless_lootbox:registerLootbox(name, data)

-- Unregister a lootbox
exports.sleepless_lootbox:unregisterLootbox(name)

-- Get lootbox data
exports.sleepless_lootbox:getLootbox(name)

-- Get all registered lootboxes
exports.sleepless_lootbox:getAllLootboxes()

-- Open a lootbox for a player
-- Set skipItemRemoval to true if you handle item removal yourself
exports.sleepless_lootbox:open(source, caseName, skipItemRemoval)

-- Get preview data for a lootbox (items with chances)
exports.sleepless_lootbox:getPreview(caseName)
```

### Client Exports

```lua
-- Request to show the preview modal for a case
exports.sleepless_lootbox:preview(caseName)

-- Check if a roll is currently in progress
exports.sleepless_lootbox:isRolling()

-- Close the lootbox UI
exports.sleepless_lootbox:close()
```

## Usage Examples

### Register a lootbox from another resource

```lua
-- server side
exports.sleepless_lootbox:registerLootbox('mystery_box', {
    label = 'Mystery Box',
    description = 'Who knows what\'s inside?',
    registerItem = true, -- Auto-register as usable item
    items = {
        { 50, { name = 'bread', amount = 5 } },
        { 30, { name = 'water', amount = 3 } },
        { 15, { name = 'bandage', amount = 2 } },
        { 5, { name = 'medkit', amount = 1, rarity = 'rare' } },
    },
})
```

### Open a case via custom trigger (e.g., ox_target)

```lua
-- server side
RegisterNetEvent('myresource:openCase', function(caseName)
    local src = source
    -- skipItemRemoval = true because we handle it ourselves
    exports.sleepless_lootbox:open(src, caseName, true)
end)
```

### Item with Metadata

```lua
{ 1, { 
    name = 'weapon_pistol', 
    amount = 1, 
    rarity = 'legendary',
    metadata = {
        serial = 'ABC123',
        durability = 100,
    }
} }
```

## UI Development

The UI is built with React and Vite. For development:

```bash
cd web
npm install
npm run dev
```

For production build:

```bash
npm run build
```

## Debug Commands

When `config.debug = true`:

| Command | Description |
|---------|-------------|
| `/lootbox_test [caseName]` | Test open a case without removing the item |
| `/lootbox_preview [caseName]` | Preview a case's contents (client) |
| `/lootbox_list` | List all registered lootboxes |
| `/lootbox_test_ui` | Test the UI with dummy data (client) |
| `/lootbox_test_preview` | Test the preview UI with dummy data (client) |

## ox_core Setup

When using **ox_core**, usable items are handled through **ox_inventory** item definitions rather than the framework itself. For each lootbox item you want players to be able to use, you need to add a `server.export` entry in your ox_inventory item definitions pointing to this resource:

```lua
-- ox_inventory/data/items.lua
["gun_case"] = {
    label = 'Gun Case',
    weight = 500,
    server = {
        export = "sleepless_lootbox.gun_case"
    }
},
```

The export name must match the format `sleepless_lootbox.<item_name>`, where `<item_name>` is the lootbox name defined in your config or registered via exports. This is handled automatically by the bridge when `config.registerUsableItems` is enabled — you just need to make sure the item definitions include the `server.export`.

> **📄 Reference:** See [`_items.lua`](_items.lua) for a complete set of example ox_inventory item definitions covering all default lootbox cases and their contents. This file is not loaded at runtime — it's purely for reference. Copy the relevant entries into your `ox_inventory/data/items.lua`.

## QBCore

When using **QBCore** lootbox case items must be defined in your shared items (`qb-core/shared/items.lua`) with `useable = true` so that the framework can register them as usable items:

```lua
-- qb-core/shared/items.lua
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
```

The `useable = true` flag is what allows `QBCore.Functions.CreateUseableItem` to register the callback. When `config.registerUsableItems` is enabled, the resource handles this automatically — you just need to make sure the item definitions exist with `useable = true`.

> **📄 Reference:** See [`_items.lua`](_items.lua) for a complete set of example qb-core shared item definitions covering all default lootbox cases and their contents. This file is not loaded at runtime — it's purely for reference. Copy the relevant entries into your `qb-core/shared/items.lua`.

## Documentation

For full documentation, visit: https://sleeplessdevelopment.dev/lootbox

## Support

- [Discord](https://discord.gg/A2bDPbfgNP)
- [GitHub Issues](https://github.com/Sleepless-Development/sleepless_lootbox/issues)

## License

MIT License - See [LICENSE](LICENSE) for details.
