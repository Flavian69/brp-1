MySQL.createCommand("create_user","INSERT INTO users(userData, userIdentifiers, registeredDate) VALUES(@userData, @userIdentifiers, SYSDATE())")
MySQL.createCommand("update_user","UPDATE users SET userData = @userData WHERE userId = @userId")
MySQL.createCommand("search_user","SELECT * FROM users WHERE userId = @userId")
MySQL.createCommand("select_users","SELECT * FROM users")

AddEventHandler("playerConnecting",function(name,setMessage, deferrals)
    deferrals.defer()

    local userSource = source
    local userIdentifiers = GetPlayerIdentifiers(userSource)
  
    if userIdentifiers ~= nil and #userIdentifiers then
        deferrals.update("Trying to connect to the server...")

        MySQL.query("select_users", {}, function(Users, affected)
            if #Users > 0 then -- check if exists registered users
                deferrals.update("Trying to search your identifiers...")
                local hasFound = false

                for indexOf,User in pairs(Users) do -- search identifiers
                    local Identifiers = json.decode(User.userIdentifiers)

                    --if not (User.userData.banned and (User.userData.whitelisted and config.whitelisted) or config.whitelisted) then
                        for _,Identifier in pairs(Identifiers) do
                            for _,userIdentifier in pairs(userIdentifiers) do
                                if  userIdentifier == Identifier then
                                    deferrals.done()
                                    hasFound = true
                                    
                                    break
                                end
                            end

                            if hasFound then
                                break
                            end
                        end

                        if hasFound then
                            break
                        end
                    --else
                    --    break
                    --end
                end
                
                if not hasFound then
                    deferrals.update("Creating your character...")
                    MySQL.execute("create_user",{userData = json.encode({banned = false, whitelisted = false, positionPed = {x = 0.0, y = 0.0, z = 0.0}, survivalPed = {health = 100, thirst = 100, hunger = 100}, moneyPlayer = {wallet = 5000, bank = 15000}}),userIdentifiers = json.encode(userIdentifiers)})
                    deferrals.done()
                end
            else
                deferrals.update("Creating your character...")
                MySQL.execute("create_user",{userData = json.encode({banned = false, whitelisted = false, positionPed = {x = 0.0, y = 0.0, z = 0.0}, survivalPed = {health = 100, thirst = 100, hunger = 100}, moneyPlayer = {wallet = 5000, bank = 15000}}),userIdentifiers = json.encode(userIdentifiers)})
                deferrals.done()
            end
        end)
    else
        deferrals.done("Try to connect with Steam online...")
    end
end)

RegisterServerEvent("BRP:playerSpawned")
RegisterServerEvent("BRP:playerLeave")

RegisterServerEvent("BRPclient:playerSpawned")
AddEventHandler("BRPclient:playerSpawned", function()
    local sourceId = source

    if not BRP.isPlayerConnected(sourceId) then
        local userIdentifiers = GetPlayerIdentifiers(sourceId)
        local userId = 0

        MySQL.query("select_users", {},function(Users, affected)
            if #Users > 0 then
                local hasFound = false

                for indexOf,User in pairs(Users) do -- search identifiers
                    local Identifiers = json.decode(User.userIdentifiers)

                    for _,Identifier in pairs(Identifiers) do
                        for _,userIdentifier in pairs(userIdentifiers) do
                            if  userIdentifier == Identifier then
                                userId = User.userId

                                BRP.setUser({
                                    sourceId = sourceId,
                                    userId = userId,
                                    userData = json.decode(User.userData)
                                })
                                
                                TriggerClientEvent("BRPclient:getConfig", sourceId, BRP.config)
                                TriggerEvent("BRP:playerSpawned",BRP.getUserId(sourceId),sourceId,true)
                                print(GetPlayerName(sourceId).."["..userId.."] s-a conectat pe server!")
                                hasFound = true
                                
                                break
                            end
                        end
                        
                        if hasFound then
                            break
                        end
                    end
                        
                    if hasFound then
                        break
                    end
                end
            end
        end)
    else
        TriggerEvent("BRP:playerSpawned",BRP.getUserId(sourceId),sourceId,false)
    end
end)

AddEventHandler("BRP:playerSpawned", function(UserId,sourceId,firstSpawn)
    TriggerClientEvent("BRP:getClientSource", sourceId)
end)

AddEventHandler("playerDropped",function(reason)
    local sourceId = source
  
    if sourceId ~= nil then
        for indexOf,User in pairs(BRP.users) do
            if User.sourceId == sourceId then
                TriggerEvent("BRP:playerLeave", User.userId, sourceId)
                print("["..User.userId.."]"..GetPlayerName(sourceId).." disconnected ( IP: "..BRP.getPlayerEndpoint(sourceId).." )")

                table.remove(BRP.Users, indexOf)
            end
        end
    end
end)

AddEventHandler("BRP:save", function()
    Wait(500)
    for indexOf,User in ipairs(BRP.users) do
        MySQL.execute("update_user", {userData = json.encode(User.userData), userId = User.userId})
    end
end)
  
