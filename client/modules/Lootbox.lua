local config = require 'config'

---@class ClientLootboxManager
local LootboxManager = {}

---@type boolean
local isRolling = false

---@type string?
local currentCase = nil

---@param action string
---@param data any
local function sendNUI(action, data)
    SendNUIMessage({
        action = action,
        data = data,
    })
end

---@param visible boolean
local function setNUIFocus(visible)
    SetNuiFocus(visible, visible)
    SetNuiFocusKeepInput(false)
end

---@return boolean
function LootboxManager.isRolling()
    return isRolling
end

---@return string?
function LootboxManager.getCurrentCase()
    return currentCase
end

---@param data table
function LootboxManager.startRoll(data)
    if isRolling then
        lib.print.warn('Already rolling, ignoring new roll request')
        return
    end

    isRolling = true
    currentCase = data.caseName

    sendNUI('setVisible', true)
    setNUIFocus(true)

    Wait(100)

    sendNUI('startRoll', {
        pool = data.pool,
        winnerIndex = data.winnerIndex,
        caseName = data.caseName,
        caseLabel = data.caseLabel
    })

    lib.print.debug(('Started roll for case: %s'):format(data.caseName))
end

---@param winner table
function LootboxManager.onRollComplete(winner)
    lib.print.debug(('Roll complete - Winner: %s x%d'):format(winner.name, winner.amount))

    TriggerServerEvent('sleepless_lootbox:claimReward')
end

function LootboxManager.closeUI()
    isRolling = false
    currentCase = nil

    sendNUI('setVisible', false)
    sendNUI('reset', {})
    setNUIFocus(false)
end

---@param caseName string
function LootboxManager.requestPreview(caseName)
    TriggerServerEvent('sleepless_lootbox:requestPreview', caseName)
end

---@param data table
function LootboxManager.showPreview(data)
    sendNUI('setVisible', true)
    setNUIFocus(true)

    sendNUI('showPreview', {
        caseName = data.caseName,
        caseLabel = data.caseLabel,
        caseImage = data.caseImage,
        description = data.description,
        items = data.items,
    })
end

function LootboxManager.closePreview()
    sendNUI('closePreview', {})
    sendNUI('setVisible', false)
    setNUIFocus(false)
end

RegisterNUICallback('rollComplete', function(data, cb)
    LootboxManager.onRollComplete(data.winner)
    cb({})
end)

RegisterNUICallback('close', function(_, cb)
    LootboxManager.closeUI()
    cb({})
end)

RegisterNUICallback('closePreview', function(_, cb)
    LootboxManager.closePreview()
    cb({})
end)

RegisterNUICallback('ready', function(_, cb)
    lib.print.debug('NUI ready')
    cb({})
end)

return LootboxManager
