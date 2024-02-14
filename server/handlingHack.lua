local lastPlayersReceivedHandling = {}

local function handlingHackDetected(player) -- H0-01
    outputAnticheatLog('Banned player '..getPlayerName(player)..', reason: H0-01', true)
    banPlayer(player, true, false, true, 'o-anticheat', 'H0-01')
end

local function handlingHackAbuseDetected(player) -- H0-02
    outputAnticheatLog('Banned player '..getPlayerName(player)..', reason: H0-02', true)
    banPlayer(player, true, false, true, 'o-anticheat', 'H0-02')
end

local function compareHandlings(handling1, handling2)
    for key, value in pairs(handling1) do
        if type(value) == 'string' then
            if handling2[key] ~= value then
                return false
            end
        elseif type(value) == 'number' then
            if ('%.2f'):format(handling2[key]) ~= ('%.2f'):format(value) then
                return false
            end
        elseif type(value) == 'table' then
            if not compareHandlings(value, handling2[key]) then
                return false
            end
        elseif type(value) == 'boolean' then
            if handling2[key] ~= value then
                return false
            end
        elseif type(value) == 'nil' then
            if handling2[key] ~= value then
                return false
            end
        else
            outputDebugString('Unknown handling type: '..type(value))
        end
    end

    return true
end

local function handlingHackDetection(handling)
    local serverHandling = getVehicleHandling(getPedOccupiedVehicle(client))
    local doesMatch = compareHandlings(handling, serverHandling)

    if not doesMatch then
        handlingHackDetected(client)
    end

    lastPlayersReceivedHandling[client] = getTickCount()
end

local function checkHandlingHackPackets()
    for player, lastReceivedHandling in pairs(lastPlayersReceivedHandling) do
        if lastReceivedHandling and getTickCount() - lastReceivedHandling > 20000 and getPedOccupiedVehicle(player) then
            handlingHackAbuseDetected(player)
        end
    end
end

addEventHandler('onPlayerVehicleEnter', root, function(vehicle)
    if not getAnticheatSetting('handlingHack') then return end

    lastPlayersReceivedHandling[source] = getTickCount()
end)

addEventHandler('onVehicleStartEnter', root, function(player)
    if not getAnticheatSetting('handlingHack') then return end

    lastPlayersReceivedHandling[player] = getTickCount()
end)

addEventHandler('onPlayerQuit', root, function()
    lastPlayersReceivedHandling[source] = nil
end)

function initHandlingHackTests()
    if not getAnticheatSetting('handlingHack') then return end

    addEvent('anticheat:checkHandlingHack', true)
    addEventHandler('anticheat:checkHandlingHack', resourceRoot, handlingHackDetection)
    setTimer(checkHandlingHackPackets, 10000, 0)

    outputAnticheatLog('Speed hack tests initialized')
end