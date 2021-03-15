-- Map Table 
-- saves everything about map interaction!
local Map = {
    Areas = {}, -- Blips based on radius.
    Blips = {}, -- Blips.
    SafeZones = {}, -- Zones to protect the civilians.
    InfoPoints = {} -- Points of information.
}

-- Add Area Function 
-- it adds an area if it's called.
function BRP.addArea(x, y, z, radius, color)
    local Area = AddBlipForRadius(x, y, z, radius)
    SetBlipColour(Area, color)
    SetBlipAlpha(Area, 125)

    table.insert(Map.Areas, x, y, z, radius, color)
    
    return Area
end

-- Add Blip Function 
-- it adds a blip if it's called.
function BRP.addBlip(x, y, z, sprite, color, text)
    local Blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(Blip, sprite)
    SetBlipColour(Area, color)
    SetBlipAsShortRange(Blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(Blip)

    table.insert(Map.Blips, x, y, z, sprite, color, text)

    return Blip
end

-- Add Safe Zone Function 
-- it adds a safe zone if it's called.
function BRP.addSafeZone(x,y,z)
    table.insert(Map.SafeZones, x, y, z)
end

-- Add Information Point Function 
-- it adds an information point if it's called.
function BRP.addInfoPoint(x,y,z)
    table.insert(Map.InfoPoints, x, y, z)
end

Citizen.CreateThread(function()
    -- Map's Configuration
    -- this code is for running the map's cfg

    Citizen.Wait(500) -- A waiter, for making everything sure of running

    if #Map.Blips > 0 then
        for indexOf,vBlip in pairs(Map.Blips) do
            local Blip = AddBlipForCoord(vBlip[1], vBlip[2], vBlip[3])
            SetBlipSprite(Blip, vBlip[4])
            SetBlipColour(Area, v[5])
            SetBlipAsShortRange(Blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(vBlip[6])
            EndTextCommandSetBlipName(Blip)
        end
    end

    if #Map.Areas > 0 then
        for indexOf,vArea in pairs(Map.Areas) do
            local Area = AddBlipForRadius(vArea[1],vArea[2],vArea[3],vArea[4])
            SetBlipColour(Area, vArea[5])
            SetBlipAlpha(Area, 125)
        end
    end
    
    if #Map.InfoPoints > 0 then
        for indexOf,Position in pairs(Map.InfoPoints) do
            local Blip = AddBlipForCoord(Position[1], Position[2], Position[3])
            SetBlipSprite(Blip, 407)
            SetBlipColour(Area, 39)
            SetBlipAsShortRange(Blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Punct de informare")
            EndTextCommandSetBlipName(Blip)
        end
    end

    while true do
        Wait(5)
        if BRP.source ~= 0 then
            local pedPosition = GetEntityCoords(GetPlayerPed(-1))


            if IsControlJustPressed(0,51) then
                print(table.unpack(pedPosition))
            end

            if #Map.InfoPoints > 0 then
                for indexOf,Position in pairs(Map.InfoPoints) do
                    if #(vector3(Position[1], Position[2], Position[3]) - vector3(pedPosition.x, pedPosition.y, pedPosition.z)) <= 15.0 then
                        DrawMarker(32, Position[1], Position[2], Position[3]+0.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 200, 200, 200, 100, true, true, 2, true, nil, false)
                        DrawText3D(Position[1], Position[2], Position[3]-0.4, "Foloseste [~g~/info~w~] pentru informatii!") 
                    end
                end
            end

            if #Map.SafeZones > 0 then
                for indexOf,Position in pairs(Map.SafeZones) do
                    if #(vector3(Position[1], Position[2], Position[3]) - vector3(pedPosition.x, pedPosition.y, pedPosition.z)) <= 15.0 then
                        DisableControlAction(1, 37, true)
                        DisableControlAction(0,24,true)
                        DisableControlAction(0,25,true)
                        DisableControlAction(0,47,true)
                        DisableControlAction(0,58,true)
                        DisableControlAction(0,263,true)
                        DisableControlAction(0,264,true)
                        DisableControlAction(0,257,true)
                        DisableControlAction(0,140,true)
                        DisableControlAction(0,141,true)
                        DisableControlAction(0,142,true)
                        DisableControlAction(0,143,true)
                        SetEntityInvincible(GetPlayerPed(-1), true)
                        SetPlayerInvincible(PlayerId(), true)
                        ClearPedBloodDamage(GetPlayerPed(-1))
                        ResetPedVisibleDamage(GetPlayerPed(-1))
                        ClearPedLastWeaponDamage(GetPlayerPed(-1))
                        SetEntityProofs(GetPlayerPed(-1), true, true, true, true, true, true, true, true)
                        SetEntityOnlyDamagedByPlayer(GetPlayerPed(-1), false)
                        SetEntityCanBeDamaged(GetPlayerPed(-1), false)
                    else
                        SetEntityInvincible(GetPlayerPed(-1), false)
                        SetPlayerInvincible(PlayerId(), false)
                        ClearPedLastWeaponDamage(GetPlayerPed(-1))
                        SetEntityProofs(GetPlayerPed(-1), false, false, false, false, false, false, false, false)
                        SetEntityOnlyDamagedByPlayer(GetPlayerPed(-1), true)
                        SetEntityCanBeDamaged(GetPlayerPed(-1), true)
                    end
                end
            end
        end
    end
end)