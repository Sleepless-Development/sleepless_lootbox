local context = lib.context

local function isResourceStarted(resource)
    local state = GetResourceState(resource)
    return state == 'started' or state == 'starting'
end

local function loadFramework()
    if isResourceStarted('qbx_core') then
        return require(('bridge.framework.qbx.%s'):format(context))
    elseif isResourceStarted('qb-core') then
        return require(('bridge.framework.qb.%s'):format(context))
    elseif isResourceStarted('es_extended') then
        return require(('bridge.framework.esx.%s'):format(context))
    end

    lib.print.warn('No supported framework detected')
    return nil
end

local function loadInventory()
    if isResourceStarted('ox_inventory') then
        return require(('bridge.inventory.ox.%s'):format(context))
    elseif isResourceStarted('qb-inventory') then
        return require(('bridge.inventory.qb.%s'):format(context))
    elseif isResourceStarted('esx_inventory') then
        return require(('bridge.inventory.esx.%s'):format(context))
    end

    lib.print.warn('No supported inventory detected')
    return nil
end

local Framework = loadFramework()
local Inventory = loadInventory()

if Framework then
    lib.print.info(('Loaded framework bridge: %s'):format(Framework.name))
end

if Inventory then
    lib.print.info(('Loaded inventory bridge: %s'):format(Inventory.name))
end

return {
    Framework = Framework,
    Inventory = Inventory,
}
