VERSION = '0.7.1'

addEvent('anticheat:loadLocker', true)
addEventHandler('anticheat:loadLocker', resourceRoot, function()
    triggerServerEvent('anticheat:loadLocker', resourceRoot)
end)