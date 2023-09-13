Functions = {}

if not Framework then
    return error('No framework detected')
end

local scriptPath = ('bridge/%s/client.lua'):format(Framework)
local resourceFile = LoadResourceFile(cache.resource, scriptPath)

if not resourceFile then
    return error(("Unable to find framework bridge for '%s'"):format(Framework))
end

local func, err = load(resourceFile, ('@@%s/%s'):format(cache.resource, scriptPath))

if not func or err then
    return error(err)
end

func()
