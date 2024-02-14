local waitingPlayers = {}

function checkCopyrightsScreen()
    local xml = xmlLoadFile('meta.xml')
    local childs = xmlNodeGetChildren(xml)
    for i, child in ipairs(childs) do
        if xmlNodeGetName(child) == 'script' then
            local src = xmlNodeGetAttribute(child, 'src')
            if src == 'client/copyright.lua' then
                return getTickCount()
            end
        end
    end

    return false
end

addEvent('anticheat:copyrightScreenLoaded', true)
addEventHandler('anticheat:copyrightScreenLoaded', resourceRoot, function()
    waitingPlayers[client] = nil
end)

local function checkPlayersCopyrightScreen()
    for player, tick in pairs(waitingPlayers) do
        if isElement(player) then
            if tick and getTickCount() - tick > 10000 then
                kickPlayer(player, 'Copyrights screen was removed! Respect my work!')
            end
        else
            waitingPlayers[player] = nil
        end
    end
end

addEventHandler('onPlayerResourceStart', resourceRoot, function()
    waitingPlayers[source] = getTickCount()
end)

addEventHandler('onResourceStart', resourceRoot, function()
    setTimer(checkPlayersCopyrightScreen, 10000, 0)
end)