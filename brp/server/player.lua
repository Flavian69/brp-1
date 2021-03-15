AddEventHandler("BRP:save",function()
    for indexOf,User in ipairs(BRP.users) do
        User.userData.positionPed = GetEntityCoords(GetPlayerPed(User.sourceId))
    end
end)

AddEventHandler("BRP:playerSpawned", function(userId, sourceId, firstSpawn)
    if not firstSpawn then
        BRPclient.teleport(sourceId, BRP.config.Map.Hospital)
    else
        local userData = BRP.getUserData(userId)
        
        if not userData.survivalPed.comma then
            BRPclient.teleport(sourceId, {userData.positionPed.x,userData.positionPed.y,userData.positionPed.z})
        else
            BRPclient.teleport(sourceId, BRP.config.Map.Spawn)
        end
    end
end)