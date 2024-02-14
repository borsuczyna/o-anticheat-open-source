-- local sx, sy = guiGetScreenSize()
-- local baseX = 2048
-- local zoom = sx < 2048 and math.min(2.2, 2048/sx) or 1 
-- local cascadia = dxCreateFont('data/font.ttf', 11/zoom, false)

-- local shader = dxCreateShader('data/shader.fx')
-- local texture = dxCreateTexture('data/logo.png')
-- local start = getTickCount()
-- dxSetShaderValue(shader, 'gTexture', texture)

-- local smallTextTime = 15000
-- local smallTexts = {
--     'Server protected by o-anticheat ' .. VERSION,
--     'discord.gg/rHTVTWrrW5',
-- }

-- local copyrightsPositions = {
--     {5/zoom, 5/zoom, 25/zoom, 25/zoom},
--     {5/zoom, sy - 30/zoom, 25/zoom, 25/zoom},
--     {sx - 30/zoom, 5/zoom, 25/zoom, 25/zoom},
--     {sx - 30/zoom, sy - 30/zoom, 25/zoom, 25/zoom},
-- }

-- local function renderCopyrightScreen()
--     local interpolate = (getTickCount() - start) / 2500
--     local rot = interpolateBetween(0, 0, 0, 360, 0, 0, interpolate, 'InOutQuad')
--     dxSetShaderTransform(shader, rot, 0, 0)

--     if (copyrightPosition or 1) < 1 or (copyrightPosition or 1) > 4 then
--         copyrightPosition = 1
--         outputDebugString('smartie')
--     end
--     local tx, ty, tw, th = unpack(copyrightsPositions[copyrightPosition or 1])

--     local interpolate = (getTickCount() > start + 2000) and (getTickCount() - start - 2000) / 1000 or 0
--     local x, y = interpolateBetween(sx/2 - 150/zoom, sy/2 - 150/zoom, 0, tx, ty, 0, interpolate, 'InOutQuad')
--     local w, h = interpolateBetween(300/zoom, 300/zoom, 0, tw, th, 0, interpolate, 'InOutQuad')
--     dxDrawImage(x, y, w, h, shader, 0, 0, 0, nil, true)

--     local currentTextId = math.floor((getTickCount() - start - 2500) / smallTextTime)
--     if currentTextId < 0 then return end

--     local interpolate = (getTickCount() - start - 2500) % smallTextTime / smallTextTime
--     local text = smallTexts[currentTextId % #smallTexts + 1]
--     local x = 0
    
--     local textW = dxGetTextWidth(text, 1, cascadia)
--     local x = textW
    
--     if interpolate < 0.1 then
--         x = interpolateBetween(0, 0, 0, textW, 0, 0, interpolate / 0.1, 'InOutQuad')
--     elseif interpolate > 0.9 then
--         x = interpolateBetween(textW, 0, 0, 0, 0, 0, (interpolate - 0.9) / 0.1, 'InOutQuad')
--     end
    
--     if (copyrightPosition or 1) <= 2 then
--         dxDrawText(text, 38/zoom + 1, ty + 1, 38/zoom + x + 1, ty + 25/zoom + 1, 0x88000000, 1, cascadia, 'right', 'center', true, false, true)
--         dxDrawText(text, 38/zoom, ty, 38/zoom + x, ty + 25/zoom, white, 1, cascadia, 'right', 'center', true, false, true)
--     else
--         dxDrawText(text, sx - 38/zoom - x - 1, ty + 1, sx - 38/zoom - 1, ty + 25/zoom + 1, 0x88000000, 1, cascadia, 'left', 'center', true, false, true)
--         dxDrawText(text, sx - 38/zoom - x, ty, sx - 38/zoom, ty + 25/zoom, white, 1, cascadia, 'left', 'center', true, false, true)
--     end
-- end

-- addEventHandler('onClientResourceStart', resourceRoot, function()
--     local required = getElementData(resourceRoot, 'anticheat:showPermissionRequiredScreen')
--     if not required then
--         addEventHandler('onClientRender', root, renderCopyrightScreen, true, 'low-9999')
--     end

--     triggerServerEvent('anticheat:copyrightScreenLoaded', resourceRoot)
-- end)

triggerServerEvent('anticheat:copyrightScreenLoaded', resourceRoot)