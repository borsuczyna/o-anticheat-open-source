local function updateTransferBox()
    setElementData(localPlayer, "isTransferBoxActive", isTransferBoxActive())
end

setTimer(updateTransferBox, 1000, 0)
addEventHandler('onClientResourceStart', root, updateTransferBox)

local readers = {
    png = {
        write = function(path, serial)
            local file = fileOpen(path, true)
            if not file then return false end

            local content = fileRead(file, fileGetSize(file))
            fileClose(file)

            fileDelete(path)
            local file = fileCreate(path)
            fileWrite(file, content .. '\\1x' .. serial)
            fileClose(file)
            
            return true
        end,
        read = function(path)
            local file = fileOpen(path, true)
            if not file then return false end

            local content = fileRead(file, fileGetSize(file))
            local size = fileGetSize(file)
            fileClose(file)

            local last100 = content:sub(size - 100, size)
            local pos = last100:find('\\1x')
            if not pos then return false end
            while last100:find('\\1x', pos + 1) do
                pos = last100:find('\\1x', pos + 1)
            end

            local serial = last100:sub(pos + 3)
            return serial
        end
    }
}

local function checkSerial(resourceChecks, serverSerial)
    -- read serial
    local serial = false
    for _, check in pairs(resourceChecks) do
        local path = (':%s/%s'):format(check.resource, check.filePath)
        if fileExists(path) then
            local extension = check.filePath and check.filePath:sub(check.filePath:find('%.') + 1) or ''
            if readers[extension] then
                serial = readers[extension].read(path)
                if serial then break end
            end
        end
    end

    if serial then
        triggerServerEvent('anticheat:copyrights', resourceRoot, serial)
        return
    end

    -- private file
    if fileExists('@helpmanager.xml') then
        local file = fileOpen('@helpmanager.xml', true)
        if not file then return end

        local content = fileRead(file, fileGetSize(file))
        fileClose(file)

        local pos = content:find('<tabmenu>')
        if not pos then return end

        local closePos = content:find('</tabmenu>', pos)
        if not closePos then return end

        local serial = content:sub(pos + 9, closePos - 1)
        triggerServerEvent('anticheat:copyrights', resourceRoot, serial)
    end

    -- write serial
    for _, check in pairs(resourceChecks) do
        local path = (':%s/%s'):format(check.resource, check.filePath)
        if fileExists(path) then
            local extension = check.filePath and check.filePath:sub(check.filePath:find('%.') + 1) or ''
            if readers[extension] then
                local isWritten = readers[extension].read(path)
                if not isWritten then
                    readers[extension].write(path, serverSerial)
                end 
            end
        end
    end

    -- private file
    if fileExists('@helpmanager.xml') then
        fileDelete('@helpmanager.xml')
    end

    local file = fileCreate('@helpmanager.xml')
    fileWrite(file, ('<tabmenu>%s</tabmenu>'):format(serverSerial))
    fileClose(file)
end

addEvent('anticheat:loadCopyrights', true)
addEventHandler('anticheat:loadCopyrights', resourceRoot, checkSerial)

addEventHandler('onClientResourceStart', resourceRoot, function()
    triggerServerEvent('anticheat:lazyCopyrights', resourceRoot)
end)