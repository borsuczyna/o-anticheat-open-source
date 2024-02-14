local playerVehicleFlyHack = {}
local playersFlyHackWarnings = {}

local function flyHackDetected(player) -- B0-02
    outputAnticheatLog('Banned player '..getPlayerName(player)..', reason: B0-02', true)
    banPlayer(player, true, false, true, 'o-anticheat', 'B0-02')
end

local function vehicleFlyHackDetection(isElementLocal, vehicleVelocity, vehicleZVelocity, isUnderPlayer)
    playerVehicleFlyHack[client] = playerVehicleFlyHack[client] or 0

    local addPoints = function(amount)
        playerVehicleFlyHack[client] = playerVehicleFlyHack[client] + amount
    end

    if isElementLocal then addPoints(1) end
    if vehicleVelocity > 0.4 then addPoints(vehicleVelocity/0.4) end
    if vehicleZVelocity > 0.1 then addPoints(vehicleZVelocity/0.2) end
    if isUnderPlayer then addPoints(1) end

    if playerVehicleFlyHack[client] > 15 then
        playerVehicleFlyHack[client] = 0
        playersFlyHackWarnings[client] = (playersFlyHackWarnings[client] or 0) + 1
        outputAnticheatLog('Possible vehicle fly hack detected on player '..getPlayerName(client)..', velocity: '..vehicleVelocity..' (warning '..playersFlyHackWarnings[client]..')', true)

        if playersFlyHackWarnings[client] > 4 then
            flyHackDetected(client)
        end
    end
end

local function resetPlayersPoints()
    for player, value in pairs(playerVehicleFlyHack) do
        if value then
            playerVehicleFlyHack[player] = 0
        end
    end
end

local function resetPlayersWarnings()
    for player, _ in pairs(playersFlyHackWarnings) do
        playersFlyHackWarnings[player] = 0
    end
end

local function onPlayerQuit()
    playerVehicleFlyHack[source] = nil
end

function initVehicleFlyHackTests()
    if not getAnticheatSetting('vehicleFlyHack') then return end
    
    addEvent('anticheat:vehicleFly', true)
    addEventHandler('anticheat:vehicleFly', resourceRoot, vehicleFlyHackDetection)
    addEventHandler('onPlayerQuit', root, onPlayerQuit)
    setTimer(resetPlayersPoints, 5000, 0)
    setTimer(resetPlayersWarnings, 60000, 0)

    outputAnticheatLog('Vehicle fly hack tests initialized')
end