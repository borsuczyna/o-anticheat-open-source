local playersWarnings = {}
local maxWeaponsLoss = {
    [1] = 30,
    [2] = 30,
    [3] = 30,
    [4] = 12,
    [5] = 30,
    [6] = 30,
    [7] = 30,
    [8] = 30,
    [9] = 100,
    [10] = 8,
    [11] = 12,
    [12] = 8,
    [13] = 8,
    [14] = 8,
    [15] = 8,
    [16] = 95,
    [17] = 3,
    [18] = 4,
    [22] = 27,
    [23] = 27,
    [24] = 55,
    [25] = 55,
    [26] = 55,
    [27] = 85,
    [28] = 50,
    [29] = 70,
    [30] = 75,
    [31] = 75,
    [32] = 50,
    [33] = 30,
    [34] = 45,
    [35] = 90,
    [36] = 90,
    [37] = 100,
    [41] = 30,
    [42] = 30,
}

local function damageMultiplierDetected(player) -- D0-01
    outputAnticheatLog('Banned player '..getPlayerName(player)..', reason: D0-01', true)
    banPlayer(player, true, false, true, 'o-anticheat', 'D0-01')
end

local function damageMultiplierChecks(attacker, weapon, bodypart, loss)
    if attacker and getElementType(attacker) ~= 'player' then return end
    local maxLoss = maxWeaponsLoss[weapon]
    if not maxLoss then return end

    if loss > maxLoss then
        cancelEvent()
        
        playersWarnings[attacker] = (playersWarnings[attacker] or 0) + 1
        outputAnticheatLog('Damage multiplier detected on '..getPlayerName(attacker)..', weapon: '..weapon..', bodypart: '..bodypart..', loss: '..loss..', (warning '..playersWarnings[attacker] ..')', true)

        if playersWarnings[attacker] >= 5 then
            damageMultiplierDetected(attacker)
        end
    end
end

function damageMultiplierTests()
    if not getAnticheatSetting('damageMultiplier') then return end

    addEventHandler('onPlayerDamage', root, damageMultiplierChecks)

    outputAnticheatLog('Damage multiplier tests initialized')
end