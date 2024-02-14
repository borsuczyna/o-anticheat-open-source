local lastPlayersReceivedGameSpeed = {}
local spawnedPlayer = {}

addEventHandler('onPlayerSpawn', root, function()
    spawnedPlayer[source] = true
end)

local function isPlayerSpawned(player)
    return spawnedPlayer[player] == true
end

local function speedHackDetected(player) -- G0-01
    outputAnticheatLog('Banned player '..getPlayerName(player)..', reason: G0-01', true)
    banPlayer(player, true, false, true, 'o-anticheat', 'G0-01')
end

local function speedHackAbuseDetected(player) -- G0-02
    outputAnticheatLog('Banned player '..getPlayerName(player)..', reason: G0-02', true)
    banPlayer(player, true, false, true, 'o-anticheat', 'G0-02')
end

local function speedHackDetection(gameSpeed)
    local serverGameSpeed = ('%.2f'):format(getGameSpeed())
    local clientGameSpeed = ('%.2f'):format(gameSpeed)
    if serverGameSpeed ~= clientGameSpeed then
        speedHackDetected(client)
    end

    lastPlayersReceivedGameSpeed[client] = getTickCount()
end

local function checkSpeedHackPackets()
    for player, lastReceivedGameSpeed in pairs(lastPlayersReceivedGameSpeed) do
        if lastReceivedGameSpeed and getTickCount() - lastReceivedGameSpeed > 20000 and isPlayerSpawned(player) then
            speedHackAbuseDetected(player)
        end
    end
end

addEventHandler('onPlayerQuit', root, function()
    lastPlayersReceivedGameSpeed[source] = nil
end)

addEventHandler('onPlayerResourceStart', resourceRoot, function()
    lastPlayersReceivedGameSpeed[source] = getTickCount()
end)

function initSpeedHackTests()
    if not getAnticheatSetting('speedHack') then return end

    addEvent('anticheat:checkSpeedHack', true)
    addEventHandler('anticheat:checkSpeedHack', resourceRoot, speedHackDetection)
    setTimer(checkSpeedHackPackets, 10000, 0)

    outputAnticheatLog('Speed hack tests initialized')
end