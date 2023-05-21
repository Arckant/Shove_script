player = GetPlayerPed(-1)
Citizen.CreateThread(function()
  while true do
    if IsControlJustReleased(1, 288) then -- F1

      look_dir = GetEntityHeading(player)

      front_space_coord = 0

      x1, y1, z1 = table.unpack(GetEntityCoords(player))

      x = 0 
      y = 0

      if look_dir < 22.5 or look_dir > 337.5 then
        x = 5;
        y = 0;
        x1 = x1+2
      elseif look_dir > 22.5 and look_dir < 67.5 then
        x = 2.5;
        y = -2.5;
        y1 = y1-1;
        x1 = x1+1;
      elseif look_dir > 67.5 and look_dir < 112.5 then
        x = 0;
        y = -5;
        y1 = y1-2;
      elseif look_dir > 112.5 and look_dir < 157.5 then
        x = -2.5;
        y = -2.5;
        y1 = y1-1;
        x1 = x1-1;
      elseif look_dir > 157.5 and look_dir < 202.5 then
        x = -5;
        y = 0;
        x1 = x1-2
      elseif look_dir > 202.5 and look_dir < 247.5 then
        x = -2.5;
        y = 2.5;
        y1 = y1+1;
        x1 = x1-1;
      elseif look_dir > 247.5 and look_dir < 292.5 then 
        x = 0;
        y = 5;
        y1 = y1+2;
      else
        x = 2.5;
        y = 2.5;
        y1 = y1+1;
        x1 = x1+1;
      end

      front_space_coord = vector3(x1, y1, z1)

      if Vdist2(GetEntityCoords(GetPlayerPed(GetNearestPlayerToEntity(player))), front_space_coord) < 2 then
        target = GetPlayerPed(GetNearestPlayerToEntity(player));
      else
        target = GetRandomPedAtCoord(GetEntityCoords(player), 1.0, 1.0, 1.0, -1);
      end

      local force_multiplier = 0.5
      local forceType = 1
      local direction = vector3(y*force_multiplier, x*force_multiplier, 0.0)
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

        TaskPlayAnim(player, anim_dict, anim_clip, 4.0, 4.0, -1, 48, 0.0)
        
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
