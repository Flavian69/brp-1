--Main Table (will store every functions that will be used)
MySQL = module("brp-mysql","MySQL")
BRP = {}
BRPclient = {}

-- Configuration
BRP.config = module("brp", "config")

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

--A method to input client functions in server-side
RegisterNetEvent("BRP:ClientTunnel")
AddEventHandler("BRP:ClientTunnel",function(BRPcli)
    for i,v in pairs(BRPcli) do
        BRPclient[i] = function(player, pTable)
            TriggerClientEvent("BRPclient:"..i, player, table.unpack(pTable))
        end
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    TriggerClientEvent("BRPclient:getConfig", -1, BRP.config)
end)

-- Basic Table used in dinamic storage
-- Easy to alterate, minded in in/out access (access limited just to server-side BRP)
BRP.users = {}

-- Basic Functions for helping server-side development
-- User Oriented Functions

-- Set User
-- Insert all user data in BRP.users for dinamic storage
function BRP.setUser(user)
    table.insert(BRP.users,user)
end

-- returns: id, hasFound
function BRP.getUserId(sourceId)
    for indexOf,User in ipairs(BRP.users) do
        if User.sourceId == sourceId then
            return User.userId
        end
    end

    -- not found
    return 0
end

-- returns: source, hasFound
function BRP.getUserSource(userId)
    for indexOf,User in ipairs(BRP.users) do
        if User.userId == userId then
            return User.sourceId
        end
    end

    -- not found
    return 0
end

-- returns: datatable, hasFound
function BRP.getUserData(userId)
    for indexOf,User in ipairs(BRP.users) do
        if User.userId == userId then
            return User.userData
        end
    end

    -- not found
    return nil
end

-- returns: datatable, hasFound
function BRP.setUserData(userId,userData)
    for indexOf,User in ipairs(BRP.users) do
        if User.userId == userId then
            BRP.users[indexOf].userData = userData
        end
    end
end

-- returns: true/false
function BRP.isPlayerConnected(sourceId)
    for indexOf,User in ipairs(BRP.users) do
        if User.sourceId == sourceId then
            return true
        end
    end

    return false
end

-- returns: playerIp
function BRP.getPlayerEndpoint(player)
    return GetPlayerEP(player) or "0.0.0.0"
end

--Main Save Event
RegisterServerEvent("BRP:save")
Citizen.CreateThread(function()
    while true do
        Wait(BRP.config.TimeoutDB*1000)
        print("BRP | It's time to save data!")
        TriggerEvent("BRP:save")
    end
end)
