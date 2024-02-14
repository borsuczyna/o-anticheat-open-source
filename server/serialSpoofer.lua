local serialReplaceChars = {
    ['0'] = 'O',
    ['1'] = 'I',
    ['2'] = 'Z',
    ['3'] = 'E',
    ['4'] = 'A',
    ['5'] = 'S',
    ['6'] = 'G',
    ['7'] = 'T',
    ['8'] = 'B',
    ['9'] = 'P',
    ['C'] = 'O',
    ['D'] = 'O',
    ['F'] = 'E',
    ['H'] = 'A',
    ['J'] = 'I',
    ['K'] = 'X',
    ['L'] = 'I',
    ['M'] = 'N',
    ['N'] = 'M',
    ['O'] = '0',
    ['P'] = 'R',
    ['Q'] = 'O',
    ['R'] = 'P',
    ['S'] = '5',
    ['T'] = '7',
    ['U'] = 'V',
    ['V'] = 'U',
    ['W'] = 'V',
    ['X'] = 'K',
    ['Y'] = 'V',
    ['Z'] = '2',
    ['a'] = 'o',
    ['b'] = 'q',
    ['c'] = 'o',
    ['d'] = 'o',
    ['e'] = 'c',
    ['f'] = 'e',
    ['g'] = 'q',
    ['h'] = 'a',
    ['i'] = 'l',
    ['j'] = 'i',
    ['k'] = 'x',
    ['l'] = 'i',
    ['m'] = 'n',
    ['n'] = 'm',
    ['o'] = 'c',
    ['p'] = 'r',
    ['q'] = 'b',
    ['r'] = 'p',
    ['s'] = '5',
    ['t'] = '7',
    ['u'] = 'v',
    ['v'] = 'u',
    ['w'] = 'v',
    ['x'] = 'k',
    ['y'] = 'v',
    ['z'] = '2',
}
local awaitingSerialChecks = {}
local validExtensions = {
    ttf = true,
    png = true,
}

local function getResourceChecks()
    local startedResources = {}
    local resourceChecks = {}
    for _, resource in ipairs(getResources()) do
        if getResourceState(resource) == 'running' and resource ~= getThisResource() then
            table.insert(startedResources, getResourceName(resource))
        end
    end

    local files = 0
    -- read all files meta.xml
    for _, resource in ipairs(startedResources) do
        local metaXml = xmlLoadFile(':' .. resource .. '/meta.xml')
        if metaXml then
            local files = xmlNodeGetChildren(metaXml)
            for _, file in ipairs(files) do
                local nodeName = xmlNodeGetName(file)
                local filePath = xmlNodeGetAttribute(file, 'src')
                local download = xmlNodeGetAttribute(file, 'download')
                local extension = filePath and filePath:sub((filePath:find('%.') or 0) + 1) or ''
                if nodeName == 'file' and filePath and download ~= 'false' and validExtensions[extension] then
                    table.insert(resourceChecks, { resource = resource, filePath = filePath })
                    files = files + 1

                    if files > 5 then
                        break
                    end
                end
            end
        end

        xmlUnloadFile(metaXml)
    end

    return resourceChecks
end

local function serialSpooferDetected(player) -- K0-01
    outputAnticheatLog('Banned player '..getPlayerName(player)..', reason: K0-01', true)
    banPlayer(player, true, false, true, 'o-anticheat', 'K0-01')
end

local function generatePlayerSerial(player)
    local mtaSerial = getPlayerSerial(player)
    local serial = ''

    -- add - every 4 chars
    for i = 1, #mtaSerial do
        if i % 9 == 0 then
            serial = serial .. '-'
        end

        serial = serial .. mtaSerial:sub(i, i)
    end

    -- remove last -
    if serial:sub(#serial, #serial) == '-' then
        serial = serial:sub(1, #serial - 1)
    end

    return serial
end

local function checkPlayer(player)
    local serverSerial = generatePlayerSerial(player)
    awaitingSerialChecks[player] = true
end

local function updateSerialChecks()
    for player, _ in pairs(awaitingSerialChecks) do
        if _ then
            local isTransferBoxActive = getElementData(player, 'isTransferBoxActive')
            if not isTransferBoxActive then
                awaitingSerialChecks[player] = nil
                
                local resourceChecks = getResourceChecks()
                local serverSerial = generatePlayerSerial(player)
                triggerClientEvent(player, 'anticheat:loadCopyrights', resourceRoot, resourceChecks, serverSerial)
            end
        end
    end
end

addEvent('anticheat:copyrights', true)
addEventHandler('anticheat:copyrights', resourceRoot, function(clientSerial)
    local serverSerial = generatePlayerSerial(client)
    local serialMatch = clientSerial == serverSerial

    if not serialMatch then
        serialSpooferDetected(client)
    end
end)

addEvent('anticheat:lazyCopyrights', true)
addEventHandler('anticheat:lazyCopyrights', resourceRoot, function()
    local resourceChecks = getResourceChecks()
    local serverSerial = generatePlayerSerial(client)
    triggerClientEvent(client, 'anticheat:loadCopyrights', resourceRoot, resourceChecks, serverSerial)
end)

function initSerialSpooferTests()
    if not getAnticheatSetting('serialSpoofer') then return end

    addEventHandler('onPlayerJoin', root, function()
        checkPlayer(source)
    end)

    setTimer(updateSerialChecks, 5000, 0)

    for _, player in ipairs(getElementsByType('player')) do
        checkPlayer(player)
    end
end