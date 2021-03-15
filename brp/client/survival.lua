local Survival = {
    health = 100,
    hunger = 100,
    thirst = 100,
    comma = false
}

RegisterNetEvent("BRPclient:setUserSurvivalData")
AddEventHandler("BRPclient:setUserSurvivalData", function(survivalPed)
    Survival = survivalPed
end)

function BRP.setComma()
    Survival.comma = true
end

function BRP.isInComma()
    return Survival.comma
end

Citizen.CreateThread(function()
    local timer = 60*1.5*100

    while true do
        Wait(1000)
        if BRP.source ~= 0 then
            Survival.health = GetEntityHealth(GetPlayerPed(-1)) - 100
            Survival.hunger = Survival.hunger - math.random(0,1)/5
            Survival.thirst = Survival.thirst - math.random(0,1)/5
            
            SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
            
            if not Survival.comma then
                if Survival.hunger <= math.random(0,50) and Survival.thirst <= math.random(0,50) then
                    Survival.health = Survival.health - math.random(0,2)
                    SetEntityHealth(GetPlayerPed(-1), Survival.health + 100)
                end

                if Survival.hunger > math.random(50,100) or Survival.thirst > math.random(50,100) then
                    Survival.health = Survival.health + math.random(0,2)
                    SetEntityHealth(GetPlayerPed(-1), Survival.health + 100)
                end

                if Survival.health > 100 then
                    Survival.health = 100
                    SetEntityHealth(GetPlayerPed(-1), Survival.health + 100)
                end
            end

            if BRP.config.Survival.setComma then
                if Survival.health <= 15 then
                    print("comma was set true")
                    Survival.comma = true
                else
                    Survival.comma = false
                end
            end
            
            TriggerServerEvent("BRP:setUserSurvivalData", Survival)

            while Survival.comma and BRP.config.Survival.setComma do
                Wait(10)
                timer = timer - 1

                if timer == 0 then
                    break
                end

                SetEntityHealth(GetPlayerPed(-1), 115)
                SetEntityInvincible(GetPlayerPed(-1),true)
                SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0)
                
                if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                    TaskLeaveVehicle(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1),false), 4160)
                end

                if IsEntityDead(GetPlayerPed(-1)) then
                    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
                    NetworkResurrectLocalPlayer(x, y, z, true, true, false)
                end
            end

            if timer == 0 then
                SetEntityHealth(GetPlayerPed(-1), 0)
                Wait(2500)
                print("comma was set false")
                timer = 60*1.5*100
                Survival.comma = false
                Survival.health = 100
                Survival.hunger = 100
                Survival.thirst = 100

                SetEntityHealth(GetPlayerPed(-1), 200)
                SetEntityInvincible(GetPlayerPed(-1),false)
            end
        end
    end
end)
