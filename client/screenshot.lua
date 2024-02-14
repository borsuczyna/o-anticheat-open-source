local sx, sy = guiGetScreenSize()

function getScreenTexture()
    local screenSource = dxCreateScreenSource(sx, sy)
    dxUpdateScreenSource(screenSource, true)
    local pixels = dxGetTexturePixels(screenSource)
    local png = dxConvertPixels(pixels, 'png')
    local base64 = base64Encode(png)

    destroyElement(screenSource)
    return base64
end

function getScreenTextureAndDraw(callback)
    local screenSource = dxCreateScreenSource(sx, sy)
    dxUpdateScreenSource(screenSource, true)
    local rt = dxCreateRenderTarget(sx, sy, true)
    dxSetRenderTarget(rt, true)
    dxDrawImage(0, 0, sx, sy, screenSource)
    callback(sx, sy)
    dxSetRenderTarget()
    local pixels = dxGetTexturePixels(rt)
    local png = dxConvertPixels(pixels, 'png')
    local base64 = base64Encode(png)

    destroyElement(screenSource)
    destroyElement(rt)
    return base64
end