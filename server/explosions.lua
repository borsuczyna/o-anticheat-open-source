local playerExplosions = {}

local function explosionHackDetected(player) -- C0-01
    outputAnticheatLog('Banned player '..getPlayerName(player)..', reason: C0-01', true)
    banPlayer(player, true, false, true, 'o-anticheat', 'C0-01')
end

local function explosionChecks(x, y, z, theType)
    if getElementType(source) ~= 'player' then return end

    if not playerExplosions[source] then
        playerExplosions[source] = 0
    end

    playerExplosions[source] = playerExplosions[source] + 1
    if playerExplosions[source] > 15 then
        explosionHackDetected(source)
        cancelEvent()
    end
end

local function resetPlayersExplosions()
    for k, v in pairs(getElementsByType('player')) do
        playerExplosions[v] = 0
    end
end

function initExplosionsTests()
    if not getAnticheatSetting('explosions') then return end

    addEventHandler('onExplosion', root, explosionChecks)
    setTimer(resetPlayersExplosions, 20000, 0)
    
    outputAnticheatLog('Explosions tests initialized')
end