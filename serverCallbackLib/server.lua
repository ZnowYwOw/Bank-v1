ZnowYVRP7 = {}
ZnowYVRP7.ServerCallbacks = {}

RegisterServerEvent('ZnowYVRP7:triggerServerCallback')
AddEventHandler('ZnowYVRP7:triggerServerCallback', function(name, requestId, ...)
	local _source = source

	ZnowYVRP7.TriggerServerCallback(name, requestID, _source, function(...)
		TriggerClientEvent('ZnowYVRP7:serverCallback', _source, requestId, ...)
	end, ...)
end)

ZnowYVRP7.RegisterServerCallback = function(name, cb)
	ZnowYVRP7.ServerCallbacks[name] = cb
end

ZnowYVRP7.TriggerServerCallback = function(name, requestId, source, cb, ...)
	if ZnowYVRP7.ServerCallbacks[name] ~= nil then
		ZnowYVRP7.ServerCallbacks[name](source, cb, ...)
	else
		print('ZnowYVRP7.TriggerServerCallback => [' .. name .. '] does not exist')
	end
end