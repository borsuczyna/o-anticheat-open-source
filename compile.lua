local doNotCompile = {
    'settings.lua',
    'languages.lua',
}

local function shouldScriptBeCompiled(scriptPath)
    for i, script in ipairs(doNotCompile) do
        if script == scriptPath then
            return false
        end
    end
    return true
end

local function onScriptCompile(pCompiledLUA, pErrors, pScript)
	local compileSuccess = pErrors == 0
	if not compileSuccess then
		outputDebugString("[LUAC]: '"..pScript.."' failed to compile.", 4, 255, 127, 0)
		return false
	end

    if fileExists("compiled/"..pScript) then
        fileDelete("compiled/"..pScript)
    end

	local compiledScript = fileCreate("compiled/"..pScript)
	fileWrite(compiledScript, pCompiledLUA)
	fileClose(compiledScript)

	outputDebugString("[LUAC]: '"..pScript.."' compiled successfully.", 4, 255, 127, 0)

	return true
end

local function compileScript(scriptPath, source)
    local fetchURL = 'https://luac.mtasa.com/?compile=1&debug=0&obfuscate=3'
    fetchRemote(fetchURL, onScriptCompile, source, true, scriptPath)
end

local function copyFile(source, destination)
    local file = fileOpen(source)
    if not file then return end
    local source = fileRead(file, fileGetSize(file))
    fileClose(file)
    
    local file = fileCreate(destination)
    if not file then return end
    fileWrite(file, source)
    fileClose(file)
end

local function compileResource()
    local meta = xmlLoadFile('meta.xml')
    if not meta then return end
    local files = xmlNodeGetChildren(meta)
    
    for i, file in ipairs(files) do
        local nodeName = xmlNodeGetName(file)
        if nodeName == 'script' then
            local scriptPath = xmlNodeGetAttribute(file, 'src')
            if not scriptPath then return end
            
            local compile = shouldScriptBeCompiled(scriptPath)
            if compile then
                local file = fileOpen(scriptPath)
                if not file then return end
                local source = fileRead(file, fileGetSize(file))
                fileClose(file)
                compileScript(scriptPath, source)
            else
                copyFile(scriptPath, 'compiled/'..scriptPath)
            end
        elseif nodeName == 'file' then
            local filePath = xmlNodeGetAttribute(file, 'src')
            if not filePath then return end
            copyFile(filePath, 'compiled/'..filePath)
        end
    end

    -- write new meta

    if fileExists('compiled/meta.xml') then
        fileDelete('compiled/meta.xml')
    end

    local file = fileCreate('compiled/meta.xml')
    if not file then return end
    local metaFile = fileOpen('meta.xml')
    if not metaFile then return end
    local source = fileRead(metaFile, fileGetSize(metaFile))
    fileClose(metaFile)
    fileWrite(file, source)
    fileClose(file)

    xmlUnloadFile(meta)
end

addCommandHandler('compile', function()
    compileResource()
end)