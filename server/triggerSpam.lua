local playersEvents = {}
local playersWarnings = {}

local function triggerSpamDetected(player) -- E0-01
    outputAnticheatLog('Banned player '..getPlayerName(player)..', reason: E0-01', true)
    banPlayer(player, true, false, true, 'o-anticheat', 'E0-01')
end

local function catchTriggerEvent(sourceResource, eventName, eventSource, eventClient, luaFilename, luaLineNumber, ...)
    if not eventClient then return end

    playersEvents[eventClient] = (playersEvents[eventClient] or 0) + 1

    if playersEvents[eventClient] > 150 then
        playersWarnings[eventClient] = (playersWarnings[eventClient] or 0) + 1
        playersEvents[eventClient] = 0
        outputAnticheatLog('Possible triggers spam detected on player '..getPlayerName(eventClient)..' (warning '..playersWarnings[eventClient]..')', true)

        if playersWarnings[eventClient] > 10 then
            triggerSpamDetected(eventClient)
        end
    end
end

local function resetPlayersTriggerEvents()
    for player, _ in pairs(playersEvents) do
        playersEvents[player] = 0
    end
end

function initTriggerSpamTests()
    if not getAnticheatSetting('triggerSpam') then return end

    addDebugHook('preEvent', catchTriggerEvent)
    setTimer(resetPlayersTriggerEvents, 10000, 0)
    
    outputAnticheatLog('Trigger spam tests initialized')
end