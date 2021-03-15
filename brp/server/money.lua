function BRP.getMoney(userId)
    local userData = BRP.getUserData(userId)

    return tonumber(userData.moneyPlayer.wallet)
end

function BRP.getBankMoney(userId)
    local userData = BRP.getUserData(userId)

    return tonumber(userData.moneyPlayer.bank)
end

function BRP.setMoney(id,amount)
    local userData = BRP.getUserData(userId)

    userData.moneyPlayer.wallet = tonumber(amount)
    BRP.setUserData(userId,userData)
end

function BRP.setBankMoney(id,amount)
    local userData = BRP.getUserData(userId)

    userData.moneyPlayer.bank = tonumber(amount)
    BRP.setUserData(userId,userData)
end

function BRP.giveMoney(id,amount)
    BRP.setMoney(id,BRP.getMoney(id) + tonumber(amount))
end
  
function BRP.giveBankMoney(id,amount)
    BRP.setBankMoney(id,BRP.getBankMoney(id) + tonumber(amount))
end
  
function BRP.tryPayment(id,amount)
    if BRP.getMoney(id) > tonumber(amount) then
        BRP.setMoney(id,BRP.getMoney(id) - tonumber(amount))
        return true
    end

    return false
end
  
function BRP.tryBankPayment(id,amount)
    if BRP.getBankMoney(id) > tonumber(amount) then
        BRP.setMoney(id,BRP.getBankMoney(id) - tonumber(amount))
        return true
    end
  
    return false
end
  
function BRP.tryFullPayment(id,amount)
    local money = BRP.getMoney(id)

    if tonumber(money) >= tonumber(amount) then
        return BRP.tryPayment(id, tonumber(amount))
    else
        if BRP.tryBankPayment(id,tonumber(amount) - money) then
            return BRP.tryPayment(id, tonumber(amount))
        end
    end

    return false
end