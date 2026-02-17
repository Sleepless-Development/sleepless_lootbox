local config = require 'config'

if not config.server.versionCheckEnabled then return end

local resourceName = 'sleepless_lootbox'

local function checkVersion()
    PerformHttpRequest('https://api.github.com/repos/sleepless-development/sleepless_lootbox/releases/latest', function(status, response)
        if status ~= 200 then
            lib.print.warn('Failed to check for updates')
            return
        end

        local data = json.decode(response)
        if not data or not data.tag_name then
            lib.print.warn('Failed to parse version data')
            return
        end

        local latestVersion = data.tag_name:gsub('v', '')
        local currentVersion = GetResourceMetadata(cache.resource, 'version', 0)

        if not currentVersion then
            lib.print.warn('Could not determine current version')
            return
        end

        if latestVersion ~= currentVersion then
            lib.print.warn(('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'):format())
            lib.print.warn(('  %s is outdated!'):format(resourceName))
            lib.print.warn(('  Current: v%s | Latest: v%s'):format(currentVersion, latestVersion))
            lib.print.warn(('  Download: https://github.com/sleepless-development/%s/releases'):format(resourceName))
            lib.print.warn(('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'):format())
        else
            lib.print.info(('%s v%s - Up to date'):format(resourceName, currentVersion))
        end
    end, 'GET', '', { ['Content-Type'] = 'application/json' })
end

CreateThread(function()
    Wait(2000)
    checkVersion()
end)
