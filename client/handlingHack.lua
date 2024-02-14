function handlingHackDetection()
    local vehicle = getPedOccupiedVehicle(localPlayer)
    if not vehicle or getVehicleController(vehicle) ~= localPlayer then return end
    local handling = getVehicleHandling(vehicle)

    triggerServerEvent('anticheat:checkHandlingHack', resourceRoot, handling)
end

addEventHandler('onClientResourceStart', resourceRoot, function()
    if not getAnticheatSetting('handlingHack') then return end

    setTimer(handlingHackDetection, 10000, 0)
end)