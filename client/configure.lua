local sx, sy = guiGetScreenSize()
local cascadia = dxCreateFont('data/font.ttf', 13, false)
local permissionRequired;
local mouseInside;

function drawCodeBlock(lines, x, y)
    local w = 0
    for _,line in pairs(lines) do
        local lw = dxGetTextWidth(line, 1, cascadia, true)
        if lw > w then
            w = lw
        end
    end

    local h = #lines * 20 + 20
    x = x - w/2
    y = y - h/2

    dxDrawRoundedRectangle(x - 10, y - 5, w + 20, #lines * 20 + 20, 10, 0xff1F1F1F)
    for _,line in pairs(lines) do
        dxDrawText(line, x, y, nil, nil, 0xff7A8080, 1, cascadia, 'left', 'top', false, false, false, true)
        y = y + 20
    end

    return w + 20, #lines * 20
end

function renderPermissionRequiredScreen()
    dxDrawRectangle(0, 0, sx, sy, tocolor(0, 0, 0, 100))
    local w, h = drawCodeBlock({
        '<#569CD6group #8CDCFEname#CCCCCC=#CE9178"Admin"#7A8080>',
        '   ...',
        '   <#569CD6object #8CDCFEname#CCCCCC=#CE9178"resource.' .. getResourceName(resource) .. '"#7A8080></#569CD6object#7A8080>',
        '   ...',
        '</#569CD6group#7A8080>'
    }, sx/2, sy/2)

    dxDrawText(getLanguageString('permissionRequired'):gsub('{1}', permissionRequired), sx/2, sy/2 - h + 25, nil, nil, tocolor(255, 255, 255, 255), 1, cascadia, 'center', 'bottom')
    dxDrawText(getLanguageString('permissionRequiredReload'), sx/2, sy/2 + h - 30, nil, nil, tocolor(255, 255, 255, 255), 1, cascadia, 'center', 'top')

    local text = getLanguageString('clickToCopy')
    local tw = dxGetTextWidth(text, 1, cascadia, true)
    mouseInside = isMouseInPosition(sx/2 - tw/2 - 10, sy/2 + h, tw + 20, 30)
    dxDrawRoundedRectangle(sx/2 - tw/2 - 10, sy/2 + h, tw + 20, 30, 5, tocolor(25, 25, 25, mouseInside and 200 or 100))
    dxDrawText(text, sx/2, sy/2 + h + 15, nil, nil, tocolor(255, 255, 255, 255), 1, cascadia, 'center', 'center')
end

function clickPermissionRequiredScreen(button, state)
    if button == 'left' and state == 'down' and mouseInside then
        local text = '<object name="resource.' .. getResourceName(resource) .. '"></object>'
        setClipboard(text)
        outputChatBox(getLanguageString('copiedToClipboard'):gsub('{1}', text), 0, 255, 0)
    end
end

function showPermissionRequiredScreen(permissionName)
    permissionRequired = permissionName
    showCursor(true)
    addEventHandler('onClientRender', root, renderPermissionRequiredScreen)
    addEventHandler('onClientClick', root, clickPermissionRequiredScreen)
end

addEventHandler('onClientResourceStart', resourceRoot, function()
    local required = getElementData(resourceRoot, 'anticheat:showPermissionRequiredScreen')
    if required then
        showPermissionRequiredScreen(required)
    end
end)

addEvent('anticheat:showPermissionRequiredScreen', true)

function dxDrawRoundedRectangle(x, y, width, height, radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+radius, width-(radius*2), height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawCircle(x+radius, y+radius, radius, 180, 270, color, color, 16, 1, postGUI)
    dxDrawCircle(x+radius, (y+height)-radius, radius, 90, 180, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, (y+height)-radius, radius, 0, 90, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, y+radius, radius, 270, 360, color, color, 16, 1, postGUI)
    dxDrawRectangle(x, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+height-radius, width-(radius*2), radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+width-radius, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y, width-(radius*2), radius, color, postGUI, subPixelPositioning)
end

function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end