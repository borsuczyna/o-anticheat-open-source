local function aimbotDetected(chance, base64) -- L0-01
    outputDiscordLogWithImage('Banned player '..getPlayerName(client)..', reason: L0-01', base64)
    banPlayer(client, true, false, true, 'o-anticheat', 'L0-01')
end

function initAimbotTests()
    if not getAnticheatSetting('aimbot') then return end

    addEvent('anticheat:aimbot', true)
    addEventHandler('anticheat:aimbot', root, aimbotDetected)
end