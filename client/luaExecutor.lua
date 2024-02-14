local luaExecutorDictionary = { -- check in lowercase
    outputChatBox = {
        arg = 1,
        check = {
            'codigo lua executado',
            'codigo lua executado com sucesso',
            'lua executada com sucesso',
            'lua code executed',
        },
    },
    addCommandHandler = {
        arg = 1,
        check = {
            'painellua',
        },
    },
    guiCreateLabel = {
        arg = 5,
        check = {
            'Lua Executor',
        },
    },
}

local function luaExecutorDetected() -- I0-01
    triggerServerEvent('anticheat:luaExecutorDetected', resourceRoot)
end

local function antiLuaExecutorCheck(sourceResource, functionName, isAllowedByACL, luaFilename, luaLineNumber, ...)
    local args = {...}
    local argCount = #args
    local functionData = luaExecutorDictionary[functionName]

    if functionData and argCount >= functionData.arg then
        for _, check in ipairs(functionData.check) do
            if string.find(string.lower(args[1]), check) then
                luaExecutorDetected()
            end
        end
    end

    if functionName == 'loadstring' then
        local resourceName = getResourceName(sourceResource)
        if not isResourceLoadstringAllowed(resourceName) then
            luaExecutorDetected()
        end
    end
end

function initAntiLuaExecutor()
    if not getAnticheatSetting('luaExecutor') then return end

    local functions = {'loadstring'}
    for k in pairs(luaExecutorDictionary) do
        table.insert(functions, k)
    end

    addDebugHook('preFunction', antiLuaExecutorCheck, functions)
end

addEventHandler('onClientResourceStart', resourceRoot, initAntiLuaExecutor)