local playersElementDataChanges = {}

local function massElementDataChangeDetected(player) -- J0-01
    outputAnticheatLog('Banned player '..getPlayerName(player)..', reason: J0-01', true)
    banPlayer(player, true, false, true, 'o-anticheat', 'J0-01')
end

local function protectedElementDataChanged(key, oldValue, newValue) -- J0-02
    outputAnticheatLog('Banned player '..getPlayerName(client)..', reason: J0-02 ('..tostring(key)..', '..tostring(oldValue)..', '..tostring(newValue)..')', true)
    banPlayer(client, true, false, true, 'o-anticheat', 'J0-02')
end

local function elementDataChanged(key, oldValue, newValue)
    if not client then return end

    if source == root then
        cancelEvent()
        outputAnticheatLog('Player '..getPlayerName(client)..' tried to change element data of root element (key: '..tostring(key)..', old value: '..tostring(oldValue)..', new value: '..tostring(newValue)..')', true)
        -- massElementDataChangeDetected(client)
        return
    end

    playersElementDataChanges[client] = (playersElementDataChanges[client] or 0) + 1

    if playersElementDataChanges[client] > 20 then
        massElementDataChangeDetected(client)
        return
    end

    local isProtected = isElementDataProtected(key)
    if isProtected then
        protectedElementDataChanged(key, oldValue, newValue)
        return
    end
end

local function resetPlayerElementDataChanges(player)
    playersElementDataChanges[player] = 0
end

function initMassElementDataChangerTests()
    if not getAnticheatSetting('massElementDataChanger') then return end
    
    addEventHandler('onElementDataChange', root, elementDataChanged)
    setTimer(resetPlayerElementDataChanges, 20000, 0, root)

    outputAnticheatLog('Mass element data changer tests initialized')
end