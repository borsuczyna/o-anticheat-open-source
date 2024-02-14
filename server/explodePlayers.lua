local playerExplosions = {}

local function explosionHackDetected(player) -- F0-01
    outputAnticheatLog('Banned player '..getPlayerName(player)..', reason: F0-01', true)
    banPlayer(player, true, false, true, 'o-anticheat', 'F0-01')
end

local function explosionChecks(x, y, z, theType)
    if getElementType(source) ~= 'player' then return end

    if not playerExplosions[source] then
        playerExplosions[source] = 0
    end

    local px, py, pz = getElementPosition(source)
    local players = getElementsWithinRange(x, y, z, 10, 'player')
    local vehicles = getElementsWithinRange(x, y, z, 10, 'vehicle')
    local count = #players + #vehicles
    local streamedPlayers = getElementsWithinRange(px, py, pz, 150, 'player')
    local percentOfExplodedStreamedPlayers = count / (#streamedPlayers - 1) * 100

    if count > 1 then
        playerExplosions[source] = playerExplosions[source] + 1
    end

    if playerExplosions[source] > 5 or (#streamedPlayers > 4 and percentOfExplodedStreamedPlayers > 50) then
        explosionHackDetected(source)
    end
end

local function resetPlayersExplosions()
    for k, v in pairs(getElementsByType('player')) do
        playerExplosions[v] = 0
    end
end

function initExplodePlayersTests()
    if not getAnticheatSetting('explodePlayers') then return end

    addEventHandler('onExplosion', root, explosionChecks)
    setTimer(resetPlayersExplosions, 20000, 0)
    
    outputAnticheatLog('Explode players tests initialized')
end