local wasabi_inventory = exports.wasabi_inventory

local Inventory = {}

Inventory.name = 'wasabi_inventory'

---@param item string
---@return string?
function Inventory.getItemImage(item)
    local itemData = wasabi_inventory:Items(item)
    if itemData and itemData.client and type(itemData.client.image) == 'string' then
        local image = itemData.client.image
        if image:find('://', 1, true) then
            return image
        end

        return ('nui://wasabi_inventory/ui/images/%s'):format(image)
    end

    return ('nui://wasabi_inventory/ui/images/%s.png'):format(item)
end

---@param item string
---@return string?
function Inventory.getItemLabel(item)
    local itemData = wasabi_inventory:Items(item)
    return itemData and itemData.label
end

---@param item string
---@return number
function Inventory.getItemCount(item)
    return wasabi_inventory:GetItemCount(item) or 0
end

return Inventory
