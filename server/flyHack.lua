local playersTotalVelocity = {}
local lastPlayersPosition = {}
local playersFlyHackWarnings = {}

local function flyHackDetected(player) -- B0-01
    outputAnticheatLog('Banned player '..getPlayerName(player)..', reason: B0-01', true)
    banPlayer(player, true, false, true, 'o-anticheat', 'B0-01')
end

local function testPlayerFlyHack(player)
    local isOnFoot = not getPedOccupiedVehicle(player)
    if not isOnFoot then return end
    local usingJetpack = isPedWearingJetpack(player)
    if usingJetpack then return end

    local x, y, z = getElementPosition(player)
    lastPlayersPosition[player] = lastPlayersPosition[player] or {x, y, z}
    local zDiff = (z - lastPlayersPosition[player][3])

    local vx, vy, vz = getElementVelocity(player)
    playersTotalVelocity[player] = playersTotalVelocity[player] or 0
    if zDiff > -0.1 then -- only when not falling
        playersTotalVelocity[player] = playersTotalVelocity[player] + math.sqrt(vx^2 + vy^2 + vz^2)
    end

    lastPlayersPosition[player] = {x, y, z}
    if playersTotalVelocity[player] > 15 then
        playersFlyHackWarnings[player] = (playersFlyHackWarnings[player] or 0) + 1
        -- outputAnticheatLog('Possible fly hack detected on player '..getPlayerName(player)..', velocity: '..playersTotalVelocity[player]..' (warning '..playersFlyHackWarnings[player]..')', true)

        if playersFlyHackWarnings[player] > 3 then
            -- flyHackDetected(player)
        end
    end
end

local function flyHackTests()
    for i, player in ipairs(getElementsByType("player")) do
        testPlayerFlyHack(player)
    end
end

local function resetPlayersVelocity()
    for i, player in ipairs(getElementsByType("player")) do
        playersTotalVelocity[player] = 0
    end
end

local function resetPlayersWarnings()
    for i, player in ipairs(getElementsByType("player")) do
        playersFlyHackWarnings[player] = 0
    end
end

function initFlyHackTests()
    if not getAnticheatSetting('flyHack') then return end

    setTimer(flyHackTests, 100, 0)
    setTimer(resetPlayersVelocity, 4000, 0)
    setTimer(resetPlayersWarnings, 60000, 0)

    outputAnticheatLog('Fly hack tests initialized')
end

addEventHandler('onPlayerQuit', root, function()
    playersTotalVelocity[source] = nil
    lastPlayersPosition[source] = nil
    playersFlyHackWarnings[source] = nil
end)