local Lootbox = require 'client.modules.Lootbox'

RegisterNetEvent('sleepless_lootbox:roll', function(data)
    Lootbox.startRoll(data)
end)

RegisterNetEvent('sleepless_lootbox:showPreview', function(data)
    Lootbox.showPreview(data)
end)

exports('isRolling', function()
    return Lootbox.isRolling()
end)

exports('preview', function(caseName)
    if type(caseName) ~= 'string' then
        lib.print.error('preview: caseName must be a string')
        return
    end

    Lootbox.requestPreview(caseName)
end)

exports('close', function()
    Lootbox.closeUI()
end)

RegisterNUICallback('escape', function(_, cb)
    if Lootbox.isRolling() then
        -- Don't allow closing during roll
        cb({ allow = false })
        return
    end

    Lootbox.closeUI()
    cb({ allow = true })
end)

local config = require 'config'

if config.debug then
    RegisterCommand('lootbox_preview', function(_, args)
        local caseName = args[1] or 'gun_case'
        Lootbox.requestPreview(caseName)
    end, false)

    RegisterCommand('lootbox_test_ui', function()
        local dummyPool = {}
        local rarities = { 'common', 'common', 'common', 'uncommon', 'uncommon', 'rare', 'epic', 'legendary' }

        for i = 1, 100 do
            local rarity = rarities[math.random(#rarities)]
            dummyPool[i] = {
                name = 'test_item_' .. i,
                label = 'Test Item ' .. i,
                amount = math.random(1, 5),
                image = 'nui://ox_inventory/web/images/water.webp',
                rarity = rarity,
                weight = rarity == 'common' and 50 or rarity == 'uncommon' and 20 or rarity == 'rare' and 10 or rarity == 'epic' and 5 or 1,
                chance = 1,
            }
        end

        Lootbox.startRoll({
            pool = dummyPool,
            winnerIndex = math.random(70, 95),
            caseName = 'test_case',
            caseLabel = 'Test Case',
        })
    end, false)

    RegisterCommand('lootbox_test_preview', function()
        local dummyItems = {}
        local rarities = { 'common', 'uncommon', 'rare', 'epic', 'legendary' }
        local weights = { 50, 20, 10, 5, 1 }

        for i = 1, 10 do
            local idx = math.min(i, #rarities)
            dummyItems[i] = {
                name = 'test_item_' .. i,
                label = 'Test Item ' .. i,
                amount = math.random(1, 5),
                image = 'nui://ox_inventory/web/images/water.webp',
                rarity = rarities[idx],
                weight = weights[idx],
                chance = weights[idx],
            }
        end

        Lootbox.showPreview({
            caseName = 'test_case',
            caseLabel = 'Test Case',
            description = 'A test case for debugging',
            items = dummyItems,
        })
    end, false)
end

AddEventHandler('onResourceStop', function(resource)
    if resource == cache.resource then
        Lootbox.closeUI()
    end
end)
