function BRP.getPlayerPosition()
  local x,y,z = GetEntityCoords(GetPlayerPed(-1))
  local h = GetEntityHeading(GetPlayerPed(-1))

  return x,y,z,h
end

function BRP.setPedModel(model)
  if model then
    local mhash = GetHashKey(model)
    if mhash ~= nil then
      local i = 0
      while not HasModelLoaded(mhash) and i < 10000 do
        RequestModel(mhash)
        Citizen.Wait(10)
      end

      if HasModelLoaded(mhash) then
        SetPlayerModel(PlayerId(), mhash)
        SetModelAsNoLongerNeeded(mhash)
      end
    end
  end
end

function BRP.giveWeapon(model,ammo)
  GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(model), ammo, false)
end