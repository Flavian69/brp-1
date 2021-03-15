local Instances = {}

function BRP.createInstance(player)
    local indexOf = #Instances + 1
    Instances[indexOf] = {
        player,
    }

    return indexOf
end

function BRP.dropInstance(indexOf)
    Instances[indexOf] = nil
end

function BRP.inviteToInstance(indexOf,player)
    table.insert(Instances[indexOf],player)
end

function BRP.kickFromInstance(indexOf,player)
    for i,v in pairs(Instances[indexOf]) do
        if v == player then
            table.remove(Instances[indexOf],i)
        end
    end
end

function BRP.checkInstance(player)
    for indexOf,Instance in pairs(Instances) do
        for _,source in pairs(Instance) do
            if player == source then
                return true
            end
        end
    end

    return false
end

function BRP.getInstance(player)
    for indexOf,Instance in pairs(Instances) do
        for _,source in pairs(Instance) do
            if player == source then
                return Instance
            end
        end
    end

    return nil
end

Citizen.CreateThread(function()
    while true do
        Wait(10)
        if BRP.source ~= 0 then
            local player = BRP.source
            
            if BRP.checkInstance(player) then
                local instance = BRP.getInstance(player)

                for k,v in pairs(GetActivePlayers()) do
                    for indexOf,serverId in pairs(instance) do
                        if GetPlayerServerId(v) ~= serverId then
                            local player = GetPlayerFromServerId(GetPlayerServerId(v))

                            if NetworkIsPlayerActive(player) then
                                SetEntityVisible(GetPlayerPed(player), false, false)
                                SetEntityNoCollisionEntity(GetPlayerPed(-1), GetPlayerPed(player), false)
                            end
                        end
                    end
                end
            end
        end
    end
end)
