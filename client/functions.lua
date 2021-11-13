function IsAllowed()
  if not IsPedDeadOrDying(PlayerPedId(), 1) then
    return true
  else
    return false
  end
end


function DrawText3D(x, y, z, text)
  local onScreen,_x,_y=World3dToScreen2d(x,y,z+1)
  local px,py,pz=table.unpack(GetGameplayCamCoords())
  local factor = 0
  SetTextScale(0.35, 0.35)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(1)
  AddTextComponentString(text)
  DrawText(_x,_y)
  if (string.len(text)) < 20 then
      factor = (string.len(text)) / 400
  else
      factor = (string.len(text)) / 400
  end
  DrawRect(_x,_y+0.012, 0.028+factor, 0.03, 0, 0, 0, 68)
end

GetClosestEntity = function(entities, isPlayerEntities, coords, modelFilter)
	local closestEntity, closestEntityDistance, filteredEntities = -1, -1, nil

	if coords then
		coords = vector3(coords.x, coords.y, coords.z)
	else
		local playerPed = ESX.PlayerData.ped
		coords = GetEntityCoords(playerPed)
	end

	if modelFilter then
		filteredEntities = {}

		for k,entity in pairs(entities) do
			if modelFilter[GetEntityModel(entity)] then
				table.insert(filteredEntities, entity)
			end
		end
	end

	for k,entity in pairs(filteredEntities or entities) do
		local distance = #(coords - GetEntityCoords(entity))

		if closestEntityDistance == -1 or distance < closestEntityDistance then
			closestEntity, closestEntityDistance = isPlayerEntities and k or entity, distance
		end
	end

	return closestEntity, closestEntityDistance
end

function GetClosestVehicle(coords, modelFilter)
	return GetClosestEntity(GetVehicles(), false, coords, modelFilter)
end

GetVehicles = function()
	local vehicles = {}

	for vehicle in EnumerateVehicles() do
		table.insert(vehicles, vehicle)
	end

	return vehicles
end