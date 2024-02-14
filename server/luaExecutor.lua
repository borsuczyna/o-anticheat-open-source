local function luaExecutorDetected(player) -- I0-01
    outputAnticheatLog('Banned player '..getPlayerName(player)..', reason: I0-01', true)
    banPlayer(player, true, false, true, 'o-anticheat', 'I0-01')
end

function initLuaExecutorTests()
    if not getAnticheatSetting('luaExecutor') then return end

    addEvent('anticheat:luaExecutorDetected', true)
    addEventHandler('anticheat:luaExecutorDetected', resourceRoot, luaExecutorDetected)
    
    outputAnticheatLog('Lua executor tests initialized')
end