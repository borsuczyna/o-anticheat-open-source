function vehicleFlyHackDetection(collider, damageImpulseMag, bodyPart, x, y, z, nx, ny, nz)
    local collidedWithMe = collider and collider == localPlayer
    if not collidedWithMe then return end

    local vehicleVelocity = Vector3(getElementVelocity(source)).length
    local vehicleZVelocity = ({getElementVelocity(source)})[3]
    local x, y, z = getElementPosition(localPlayer)
    local vx, vy, vz = getElementPosition(source)
    local isUnderPlayer = z > vz + 1
    local groundZ = getGroundPosition(vx, vy, vz)
    local isAboveGround = vz > groundZ + 3
    if not isAboveGround then return end
    
    triggerServerEvent('anticheat:vehicleFly', resourceRoot, isElementLocal(source), vehicleVelocity, vehicleZVelocity, isUnderPlayer)
end

addEventHandler('onClientResourceStart', resourceRoot, function()
    if not getAnticheatSetting('vehicleFlyHack') then return end

    addEventHandler('onClientVehicleCollision', root, vehicleFlyHackDetection)
end)