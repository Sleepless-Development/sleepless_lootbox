local Lootbox = require 'server.modules.Lootbox'
local config = require 'config'

CreateThread(function()
    Wait(1000)

    Lootbox.init()

    lib.print.info('sleepless_lootbox server initialized')
end)

RegisterNetEvent('sleepless_lootbox:claimReward', function()
    local source = source
    Lootbox.claimReward(source)
end)

RegisterNetEvent('sleepless_lootbox:requestPreview', function(caseName)
    local source = source

    if type(caseName) ~= 'string' then
        lib.print.warn(('Player %d sent invalid preview request'):format(source))
        return
    end

    local preview = Lootbox.getPreview(caseName)
    local lootbox = Lootbox.get(caseName)

    if not preview or not lootbox then
        lib.print.warn(('Player %d requested preview for non-existent lootbox: %s'):format(source, caseName))
        return
    end

    TriggerClientEvent('sleepless_lootbox:showPreview', source, {
        caseName = caseName,
        caseLabel = lootbox.label,
        caseImage = lootbox.image,
        description = lootbox.description,
        items = preview,
    })
end)

AddEventHandler('playerDropped', function()
    local source = source
    Lootbox.cancelPendingReward(source)
end)

exports('registerLootbox', function(name, data)
    return Lootbox.register(name, data)
end)

exports('unregisterLootbox', function(name)
    return Lootbox.unregister(name)
end)

exports('getLootbox', function(name)
    return Lootbox.get(name)
end)

exports('getAllLootboxes', function()
    return Lootbox.getAll()
end)

exports('open', function(source, caseName, skipItemRemoval)
    return Lootbox.open(source, caseName, skipItemRemoval)
end)

exports('getPreview', function(caseName)
    return Lootbox.getPreview(caseName)
end)

if config.debug then
    RegisterCommand('lootbox_test', function(source, args)
        local caseName = args[1] or 'gun_case'
        Lootbox.open(source, caseName, true) -- Skip item removal for testing
    end, false)

    -- RegisterCommand('lootbox_preview', function(source, args)
    --     local caseName = args[1] or 'gun_case'
    --     local preview = Lootbox.getPreview(caseName)
    --     if preview then
    --         print(json.encode(preview, { indent = true }))
    --     else
    --         print('Lootbox not found: ' .. caseName)
    --     end
    -- end, false)

    RegisterCommand('lootbox_list', function()
        local all = Lootbox.getAll()
        for name, data in pairs(all) do
            print(('- %s (%s) - %d items'):format(name, data.label, #data.items))
        end
    end, false)
end
