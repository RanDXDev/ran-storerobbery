local qb = GetResourceState('qb-core')
local esx = GetResourceState('es_extended')
local ox = GetResourceState('ox_core')
Framework = ox == 'started' and 'ox' or qb == 'started' and 'qb' or esx == 'started' and 'esx' or nil
