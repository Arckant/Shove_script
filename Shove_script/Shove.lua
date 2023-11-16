player = GetPlayerPed(-1)

function GetPlayerLookingVector(playerped, radius)
	local yaw = GetEntityHeading(playerped)
	local pitch = 90.0-GetGameplayCamRelativePitch()

	if yaw > 180 then
		yaw = yaw - 360
	elseif yaw < -180 then
		yaw = yaw + 360
	end

	local pitch = pitch * math.pi / 180
	local yaw = yaw * math.pi / 180
	local x = radius * math.sin(pitch) * math.sin(yaw)
	local y = radius * math.sin(pitch) * math.cos(yaw)
	local z = radius * math.cos(pitch)

	local playerpedcoords = GetEntityCoords(playerped)
	local xcorr = -x+ playerpedcoords.x
	local ycorr = y+ playerpedcoords.y
	local zcorr = z+ playerpedcoords.z
	local Vector = vector3(tonumber(xcorr), tonumber(ycorr), tonumber(zcorr))
	return Vector
end

function GetPedInDirection(coordFrom, coordTo)
   local rayHandle = StartShapeTestRay(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 4, GetPlayerPed(-1), 0)
   local _,flag_PedHit,PedCoords,_,PedHit = GetShapeTestResult(rayHandle)
   return flag_PedHit, PedCoords, PedHit
end

Citizen.CreateThread(function()
  while true do
    if IsControlJustReleased(1, 288) then -- F1

      flag_PedHit, PedCoords, target = GetPedInDirection(GetEntityCoords(player), GetPlayerLookingVector(player, 3))

      local x, y = table.unpack(GetEntityForwardVector(player))
      local force = 1.5
      local forceType = 1
      local direction = vector3(x*force, y*force, 0.0)
      local rotation = vector3(0.0, 0.0, 0.0)
      local boneIndex = 10
      local isDirectionRel = false
      local ignoreUpVec = true
      local isForceRel = true
      local p12 = false
      local p13 = true
      local anim_dict = 'reaction@shove'
      local anim_clip = 'shove_var_c'

      if target ~= 0 then
        RequestAnimDict(anim_dict)

        while not HasAnimDictLoaded(anim_dict) do
          Wait(1)
        end

        ClearPedTasks(player)

        TaskPlayAnim(player, anim_dict, anim_clip, 4.0, 4.0, 2000, 48, 0.0)
        
        RemoveAnimDict(anim_dict)

        Citizen.Wait(300)

        SetPedToRagdoll(target, 200, 200, 0)

        ApplyForceToEntity(
            target,
            forceType,
            direction,
            rotation,
            boneIndex,
            isDirectionRel,
            ignoreUpVec,
            isForceRel,
            p12,
            p13
          )
        end
      end
    Citizen.Wait(1)
  end
end)
