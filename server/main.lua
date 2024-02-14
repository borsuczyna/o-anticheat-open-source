fserfunction initAnticheat()
    outputAnticheatLog('Starting anticheat...')
    outputAnticheatLog('Checking permissions...')
    local success = checkPermissions()
    if not success then
        outputAnticheatLog('Permissions check failed!')
        return
    else
        outputAnticheatLog('Permissions check passed...')
    end

    if not checkCopyrightsScreen or checkCopyrightsScreen() ~= getTickCount() then
        outputAnticheatLog('Failed to check for copyrights! Respect my work and do not remove it!', true)
        return
    end

    initLockerChecks()
    initFlyHackTests()
    initVehicleFlyHackTests()
    initExplosionsTests()
    damageMultiplierTests()
    initTriggerSpamTests()
    initExplodePlayersTests()
    initSpeedHackTests()
    initHandlingHackTests()
    initLuaExecutorTests()
    initMassElementDataChangerTests()
    initResourcesGuard()
    initAimbotTests()

    outputAnticheatLog('Anticheat started!', true)
end
