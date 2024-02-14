local protectedExtensions = {
    lua = true,
    luac = true,
    xml = true,
}

local function cancelResourceDeletion(name)
    local targetResource = getResourceFromName(name)
    if not targetResource then return false end

    renameResource(targetResource, name .. '-protected')
    setTimer(function(name)
        local targetResource = getResourceFromName(name .. '-protected')
        if not targetResource then return end

        renameResource(targetResource, name)
    end, 1000, 1, name)

    return true
end

local function cancelFileDeletion(path)
    local success = fileRename(path, path .. '-protected')
    if not success then return false end
    
    setTimer(function(path)
        fileRename(path .. '-protected', path)
    end, 1000, 1, path)

    return true
end

local function antiResourceDelete(sourceResource, functionName, isAllowedByACL, luaFilename, luaLineNumber, resourceName)
    if sourceResource == getThisResource() then return end -- ignore
    
    local protectionSucceeded = cancelResourceDeletion(resourceName)
    local callerResourceName = getResourceName(sourceResource)
    local successMessage = protectionSucceeded and '✅ Successfully protected resource from deletion' or '❌ Failed to protect resource from deletion'

    outputAnticheatLog(('Resource protection - attempt to delete resource `%s`\n%s\nCaller: `%s/%s L%d`\nImmediatly stopping resource\nContact o-anticheat developers or fix backdoor manually!'):format(resourceName, successMessage, callerResourceName, luaFilename, luaLineNumber), true)
    stopResource(sourceResource)
end

local function antiFileDelete(sourceResource, functionName, isAllowedByACL, luaFilename, luaLineNumber, filePath)
    if sourceResource == getThisResource() then return end -- ignore

    if filePath:sub(1, 1) ~= ':' then return end -- only protect files in resource folder
    local extension = filePath:sub(-4)
    if not protectedExtensions[extension] then return end -- only protect specific extensions

    local protectionSucceeded = cancelFileDeletion(filePath)
    local callerResourceName = getResourceName(sourceResource)
    local successMessage = protectionSucceeded and '✅ Successfully protected file from deletion' or '❌ Failed to protect file from deletion'

    outputAnticheatLog(('Resource protection - attempt to delete file `%s`\n%s\nCaller: `%s/%s L%d`\nImmediatly stopping resource\nContact o-anticheat developers or fix backdoor manually!'):format(filePath, successMessage, callerResourceName, luaFilename, luaLineNumber), true)
    stopResource(sourceResource)
end

local function antiFileWrite(sourceResource, functionName, isAllowedByACL, luaFilename, luaLineNumber, filePath)
    if sourceResource == getThisResource() then return end -- ignore

    if filePath:sub(1, 1) ~= ':' then return end -- only protect files in resource folder
    local extension = filePath:sub(-4):gsub('%.', '')
    if not protectedExtensions[extension] then return end -- only protect specific extensions

    local protectionSucceeded = cancelFileDeletion(filePath)
    local callerResourceName = getResourceName(sourceResource)
    local successMessage = protectionSucceeded and '✅ Successfully protected file from deletion' or '❌ Failed to protect file from deletion'

    outputAnticheatLog(('Resource protection - attempt to modify file `%s`\n%s\nCaller: `%s/%s L%d`\nImmediatly stopping resource\nContact o-anticheat developers or fix backdoor manually!'):format(filePath, successMessage, callerResourceName, luaFilename, luaLineNumber), true)
    stopResource(sourceResource)
end

function initResourcesGuard(force)
    if not getAnticheatSetting('resourcesGuard') and not force then return end

    if force then outputAnticheatLog = function(e) print(e) end end

    addDebugHook('preFunction', antiResourceDelete, {'deleteResource'})
    addDebugHook('preFunction', antiFileDelete, {'fileDelete'})
    addDebugHook('preFunction', antiFileWrite, {'fileCopy', 'fileOpen'})
end