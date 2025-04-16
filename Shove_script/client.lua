RegisterCommand('Shove', function()
	player = GetPlayerPed(-1)
	
	local _, _, _, _, target = GetShapeTestResult(StartShapeTestRay(GetEntityCoords(player), GetOffsetFromEntityInWorldCoords(player, 0.0, 1.0, 0.0), 4, player, 0))
	if not IsEntityAPed(target) then return end
	
	RequestAnimDict("reaction@shove")
 	while not HasAnimDictLoaded("reaction@shove") do Citizen.Wait(10) end

	ClearPedTasks(player)
	TaskPlayAnim(player, 'reaction@shove', 'shove_var_c', 4.0, 4.0, 2000, 48, 0.0)

	local targetid = GetPlayerServerId(NetworkGetPlayerIndexFromPed(target))
	local looking_vector = GetEntityForwardVector(player)

	TriggerServerEvent('Shove', targetid, player, looking_vector)

	Citizen.Wait(300)

	RemoveAnimDict('reaction@shove')

end)

RegisterNetEvent('ShoveImpact', function(looking_vector)
	local player = GetPlayerPed(-1)
	local x, y = table.unpack(looking_vector)
	local force
	local duration
	if GetPedStealthMovement(player) then force = 1.0 duration = 200 else force = 2.5 duration = 700 end
	print(GetPedStealthMovement(player))
	
	SetPedToRagdoll(player, 0, duration, 3)

	ApplyForceToEntity(
		player,
		1,
		vector3(x*force, y*force, 0.0),
		vector3(0.0, 0.0, 0.0),
		10,
		false,
		true,
		true,
		false,
		true
	)
end)
