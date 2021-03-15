--Main Table (will store every functions that will be used)
BRP = {}
BRP.source = 0
BRP.config = {}

--A method to get the config
RegisterNetEvent("BRPclient:getConfig")
AddEventHandler("BRPclient:getConfig",function(config)
    BRP.config = config
end)

--A method to get functions out of the main script
RegisterNetEvent("BRP:getSharedObject")
AddEventHandler("BRP:getSharedObject",function(cb)
    cb(BRP)
end)

--A method to input functions from out of the main script in the main script
RegisterNetEvent("BRP:inputFunction")
AddEventHandler("BRP:inputFunction",function(func)
    table.insert(BRP, func)
end)

--A method to get the source, for manifesting client-scripts
RegisterNetEvent("BRP:getClientSource")
AddEventHandler("BRP:getClientSource",function(source)
    BRP.source = source
end)

--Just enable pvp and stops police peds interaction
Citizen.CreateThread(function()
    ModifyWater(
	5179.0, 
	-5308.7, 
	1000, 
	-10.0
)
    NetworkSetFriendlyFireOption(true)
    SetCanAttackFriendly(GetPlayerPed(-1), true, true)
    SetPoliceIgnorePlayer(PlayerId(), true)
    SetDispatchCopsForPlayer(PlayerId(), false)
end)

Citizen.CreateThread(function()
    Citizen.Wait(500)
    
    for indexOf,func in pairs(BRP) do
        RegisterNetEvent("BRPclient:"..indexOf)
        AddEventHandler("BRPclient:"..indexOf, func)
    end
    TriggerServerEvent("BRP:ClientTunnel", BRP)
end)

AddEventHandler("playerSpawned",function()
    TriggerServerEvent("BRPclient:playerSpawned")
end)
  
AddEventHandler("onPlayerDied",function(player,reason)
    TriggerServerEvent("BRPclient:playerDied")
end)
  
AddEventHandler("onPlayerKilled",function(player,killer,reason)
    TriggerServerEvent("BRPclient:playerDied")
end)
  
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    Citizen.Wait(750)
    TriggerServerEvent("BRPclient:playerSpawned")
    print('The resource ' .. resourceName .. ' has been started.')
end)

function BRP.teleport(x,y,z)
    SetEntityCoords(GetPlayerPed(-1),x,y,z)
end

function DrawText3D(x,y,z, text) 
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
  
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*130
    local scale = scale*fov
    
    if onScreen then
        SetTextScale(0.2*scale, 0.5*scale)
        SetTextFont(7)
        SetTextProportional(1)
        SetTextColour( 255,255,255, 250 )
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        World3dToScreen2d(x,y,z, 0) --Added Here
        DrawText(_x,_y)
    end
end

RegisterCommand("vehicle",function()
    local mhash = GetHashKey("zentorno")
    RequestModel(mhash)
    local i = 0
    
    while not HasModelLoaded(mhash) and i < 10000 do
      Citizen.Wait(10)
      i = i+1
    end
    
    if HasModelLoaded(mhash) then
        local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))

        vehicle = CreateVehicle(mhash, x, y, z+0.5, GetEntityHeading(GetPlayerPed(-1)), true, true)
        SetEntityInvincible(vehicle,false)
        SetVehicleNumberPlateText(vehicle, "BRP CAR")
        SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1)
    end
end)

