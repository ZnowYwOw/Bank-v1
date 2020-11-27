ZnowYVRP7 = {}
ZnowYVRP7.CurrentRequestId          = 0
ZnowYVRP7.ServerCallbacks           = {}

ZnowYVRP7.TriggerServerCallback = function(name, cb, ...)
	ZnowYVRP7.ServerCallbacks[ZnowYVRP7.CurrentRequestId] = cb

	TriggerServerEvent('ZnowYVRP7:triggerServerCallback', name, ZnowYVRP7.CurrentRequestId, ...)

	if ZnowYVRP7.CurrentRequestId < 65535 then
		ZnowYVRP7.CurrentRequestId = ZnowYVRP7.CurrentRequestId + 1
	else
		ZnowYVRP7.CurrentRequestId = 0
	end
end

RegisterNetEvent('ZnowYVRP7:serverCallback')
AddEventHandler('ZnowYVRP7:serverCallback', function(requestId, ...)
	ZnowYVRP7.ServerCallbacks[requestId](...)
	ZnowYVRP7.ServerCallbacks[requestId] = nil
end)