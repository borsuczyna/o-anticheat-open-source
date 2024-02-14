local loadLockerQueue = {}

function onPlayerResourceStart(startedResource)
	if startedResource == getThisResource() then
        loadLockerQueue[source] = getTickCount() + 60000 * 4
        triggerClientEvent(source, 'anticheat:loadLocker', resourceRoot)
    end
end

addEvent('anticheat:loadLocker', true)
addEventHandler('anticheat:loadLocker', root, function()
    if source ~= resourceRoot then -- A0-01 - Invalid locker source
        outputAnticheatLog('Banned player '..getPlayerName(client)..', reason: A0-01', true)
        banPlayer(client, true, false, true, 'o-anticheat', 'A0-01')
    end

    if loadLockerQueue[client] then
        loadLockerQueue[client] = nil
        outputAnticheatLog('Player '..getPlayerName(client)..' loaded anticheat successfully')
    else -- A0-02 - Locker not in queue
        -- outputAnticheatLog('Banned player '..getPlayerName(client)..', reason: A0-02', true)
        -- banPlayer(client, true, false, true, 'o-anticheat', 'A0-02')
    end
end)

function refreshAnticheat()
    for player, time in pairs(loadLockerQueue) do
        if time and type(time) == 'number' and time < getTickCount() then -- A0-03 - Locker did not respond
            outputAnticheatLog('Kicked player '..getPlayerName(player)..', reason: A0-03', true)
            kickPlayer(player, 'o-anticheat', 'A0-03')
            -- banPlayer(player, true, false, true, 'o-anticheat', 'A0-03')
            loadLockerQueue[player] = nil
        end
    end
end

function initLockerTimer()
    setTimer(refreshAnticheat, 1000, 0)
end

function initLockerChecks()
    if not getAnticheatSetting('lockerCheck') then return end

    addEventHandler('onPlayerResourceStart', root, onPlayerResourceStart)
    initLockerTimer()
    
    outputAnticheatLog('Locker tests initialized')
end

addEventHandler('onPlayerQuit', root, function()
    loadLockerQueue[source] = nil
end)