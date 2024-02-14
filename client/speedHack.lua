function speedHackDetection()
    triggerServerEvent('anticheat:checkSpeedHack', resourceRoot, getGameSpeed())
end

addEventHandler('onClientResourceStart', resourceRoot, function()
    if not getAnticheatSetting('speedHack') then return end

    setTimer(speedHackDetection, 10000, 0)
end)