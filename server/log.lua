function outputAnticheatLog(message, important)
    local logFile = getSetting('logFile')
    if not fileExists(logFile) then
        local file = fileCreate(logFile)
        fileClose(file)
    end

    local file = fileOpen(logFile)
    local fileSize = fileGetSize(file)
    local time = os.date('%d/%m/%Y %H:%M:%S')
    fileSetPos(file, fileSize)
    fileWrite(file, '[' .. time .. '] ' .. message .. '\n')
    fileClose(file)

    if important then
        outputDiscordLog(message)
    end
    -- outputDebugString('[o-anticheat] ' .. message)
end