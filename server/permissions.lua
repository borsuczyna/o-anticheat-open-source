local requiredPermissions = {
    'function.kickPlayer',
    'function.banPlayer',
    'function.fetchRemote',
    'function.renameResource',
    'function.stopResource',
    'function.startResource',
}

function checkPermissions()
    for _, permission in ipairs(requiredPermissions) do
        if not hasObjectPermissionTo(resource, permission) then
            setElementData(resourceRoot, 'anticheat:showPermissionRequiredScreen', permission)
            return false
        end
    end

    return true
end