RegisterServerEvent("BRP:setUserSurvivalData")
AddEventHandler("BRP:setUserSurvivalData", function(survival)
    local sourceId = source
    local userId = BRP.getUserId(sourceId)
    local userData = BRP.getUserData(userId)

    userData.survivalPed = survival
    BRP.setUserData(userId,userData)
end)

function BRP.getUserSurvivalData(userId)
    local userData = BRP.getUserData(userId)

    return userData.survivalPed
end

AddEventHandler("BRP:playerSpawned", function(userId, sourceId, firstSpawn)
    if firstSpawn then
        local userData = BRP.getUserData(userId)

        if not userData.survivalPed.comma then
            TriggerClientEvent("BRPclient:setUserSurvivalData", sourceId, userData.survivalPed)
        else
            TriggerClientEvent("BRPclient:setUserSurvivalData", sourceId, {
                health = 100,
                hunger = 100,
                thirst = 100,
                comma = false
            })
        end
    end
end)