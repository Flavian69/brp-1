local config = BRP.config.Roles

function BRP.getUserRole(userId)
  local userData = BRP.getUserData(userId)

  return userData.role
end

function BRP.hasUserRole(userId,role)
  if BRP.getRoleIterator(role) <= BRP.getRoleIterator(BRP.getUserRole(userId)) then
    return true
  else
    return false
  end
end

function BRP.setUserRole(userId,role)
  for i,v in pairs(config) do
    if v:lower() == role:lower() then
        local userData = BRP.getUserData(userId)
        userData.role = role
        BRP.setUserData(userId,userData)
    end
  end
end

function BRP.getRoleIterator(role)
  for i,v in pairs(config) do
    if v:lower() == role:lower() then
      return i
    end
  end
end

AddEventHandler("BRP:playerSpawned", function(userId, sourceId, firstSpawn)
  if firstSpawn then
    if userId == 1 then
      BRP.setUserRole(userId,config[#config])
    end
  end
end)
