local wasabi_inventory = exports.wasabi_inventory

local Inventory = {}

Inventory.name = 'wasabi_inventory'

local function itemImage(item)
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

---@param source number
---@param item string
---@return number
function Inventory.getItemCount(source, item)
	return wasabi_inventory:GetItemCount(source, item) or 0
end

---@param source number
---@param item string
---@param amount number
---@param metadata? table
---@param slot? number
---@return boolean
function Inventory.removeItem(source, item, amount, metadata, slot)
	return wasabi_inventory:RemoveItem(source, item, amount, metadata, slot) or false
end

---@param source number
---@param item string
---@param amount number
---@param metadata? table
---@return boolean
function Inventory.addItem(source, item, amount, metadata)
	if not Inventory.canCarry(source, item, amount) then
		local coords = GetEntityCoords(GetPlayerPed(source))
		local dropId = wasabi_inventory:CustomDrop("Lootbox Reward", {}, coords)
		if dropId then
			return wasabi_inventory:AddItem(dropId, item, amount, metadata) or false
		end
		return false
	end

	return wasabi_inventory:AddItem(source, item, amount, metadata) or false
end

---@param source number
---@param items {[1]: string, [2]: number, [3]:table}[]
---@return boolean
function Inventory.addItems(source, items)
	local dropId
	local success = true

	for i = 1, #items do
		local name, amount, metadata = items[i][1], items[i][2], items[i][3]

		if Inventory.canCarry(source, name, amount) then
			if not wasabi_inventory:AddItem(source, name, amount, metadata) then
				success = false
			end
		else
			if not dropId then
				local coords = GetEntityCoords(GetPlayerPed(source))
				dropId = wasabi_inventory:CustomDrop("Lootbox Reward", {}, coords)
			end

			if not (dropId and wasabi_inventory:AddItem(dropId, name, amount, metadata)) then
				success = false
			end
		end
	end

	return success
end

---@param item string
---@return string?
function Inventory.getItemLabel(item)
	local itemData = wasabi_inventory:Items(item)
	return itemData and itemData.label
end

---@param item string
---@return string?
function Inventory.getItemImage(item)
	return itemImage(item)
end

---@param source number
---@param item string
---@param amount number
---@return boolean
function Inventory.canCarry(source, item, amount)
	return wasabi_inventory:CanCarryItem(source, item, amount) or false
end

---@param source number
---@param moneyType string
---@param amount number
---@return boolean
function Inventory.addMoney(source, moneyType, amount)
	local moneyItem = moneyType == 'cash' and 'money' or moneyType
	return Inventory.addItem(source, moneyItem, amount)
end

return Inventory
