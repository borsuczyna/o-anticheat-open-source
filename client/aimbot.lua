local sx, sy = guiGetScreenSize()
local aimTotal, aimLocked = 0, 0

local function isPedAiming(ped)
	if isElement(ped) then
		if getElementType(ped) == "player" or getElementType(ped) == "ped" then
			if getPedTask(ped, "secondary", 0) == "TASK_SIMPLE_USE_GUN" or isPedDoingGangDriveby(ped) then
				return true
			end
		end
	end
	return false
end

local function getCroshairScreenPosition()
    -- return sx / 2, sy / 2
    if true then return sx/2, sy/2 end
    if not isPedAiming(localPlayer) then return -5000, -5000 end

    local x, y, z = getPedTargetEnd(localPlayer)
    local sx, sy = getScreenFromWorldPosition(x, y, z)
    if sx and sy then
        return sx, sy
    else
        return -5000, -5000
    end
end

local function testAimbot()
    if not isPedAiming(localPlayer) then return end
    
    aimTotal = aimTotal + 1
    local crossX, crossY = getCroshairScreenPosition()
    dxDrawRectangle(crossX - 5, crossY - 5, 10, 10, tocolor(255, 0, 0))
    local x, y, z = getCameraMatrix()
    for i, player in ipairs(getElementsWithinRange(x, y, z, 100, 'player')) do
        if player ~= localPlayer then
            local px, py, pz = getPedBonePosition(player, 7)
            local vx, vy, vz = getElementVelocity(player)
            local speed = math.sqrt(vx^2 + vy^2 + vz^2)
            local distance = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
            local sx, sy = getScreenFromWorldPosition(px, py, pz)
            if sx and sy and speed > 0.05 then
                local scale = 1 / distance * 10
                
                local isInBox = crossX > sx - 10 * scale and crossX < sx + 10 * scale and crossY > sy - 10 * scale and crossY < sy + 10 * scale
                if isInBox then aimLocked = aimLocked + 1 end

                dxDrawLine(sx - 10 * scale, sy - 10 * scale, sx + 10 * scale, sy - 10 * scale, tocolor(255, isInBox and 255, 0), 2)
                dxDrawLine(sx + 10 * scale, sy - 10 * scale, sx + 10 * scale, sy + 10 * scale, tocolor(255, isInBox and 255, 0), 2)
                dxDrawLine(sx + 10 * scale, sy + 10 * scale, sx - 10 * scale, sy + 10 * scale, tocolor(255, isInBox and 255, 0), 2)
                dxDrawLine(sx - 10 * scale, sy + 10 * scale, sx - 10 * scale, sy - 10 * scale, tocolor(255, isInBox and 255, 0), 2)
            end
        end
    end
end

local function testAimbotTimer()
    local chance = aimLocked / aimTotal * 100
    if chance > 90 and aimTotal > 20 then
        local base64 = getScreenTextureAndDraw(function(sx, sy)
            local text = 'Aimbot detected\nAimbot chance: ' .. chance .. '%'
    
            dxDrawText(text, sx/2 - 1, sy - 20 - 1, nil, nil, tocolor(0, 0, 0, 200), 2, 'default-bold', 'center', 'bottom')
            dxDrawText(text, sx/2, sy - 20, nil, nil, tocolor(255, 255, 255), 2, 'default-bold', 'center', 'bottom')
    
            -- draw all heads 
            local x, y, z = getCameraMatrix()
            for i, player in ipairs(getElementsWithinRange(x, y, z, 100, 'player')) do
                if player ~= localPlayer then
                    local px, py, pz = getPedBonePosition(player, 7)
                    local vx, vy, vz = getElementVelocity(player)
                    local speed = math.sqrt(vx^2 + vy^2 + vz^2)
                    local distance = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
                    local sx, sy = getScreenFromWorldPosition(px, py, pz)
                    if sx and sy then
                        local scale = 1 / distance * 10
                        
                        dxDrawLine(sx - 10 * scale, sy - 10 * scale, sx + 10 * scale, sy - 10 * scale, tocolor(255, 0, 0), 4)
                        dxDrawLine(sx + 10 * scale, sy - 10 * scale, sx + 10 * scale, sy + 10 * scale, tocolor(255, 0, 0), 4)
                        dxDrawLine(sx + 10 * scale, sy + 10 * scale, sx - 10 * scale, sy + 10 * scale, tocolor(255, 0, 0), 4)
                        dxDrawLine(sx - 10 * scale, sy + 10 * scale, sx - 10 * scale, sy - 10 * scale, tocolor(255, 0, 0), 4)
                    end
                end
            end
        end)
        triggerServerEvent('anticheat:aimbot', resourceRoot, chance, base64)
    end

    aimTotal = 0
    aimLocked = 0
end

addEventHandler('onClientResourceStart', resourceRoot, function()
    if not getAnticheatSetting('aimbot') then return end

    setTimer(testAimbotTimer, 40000, 0)
    setTimer(testAimbot, 200, 0)
end)