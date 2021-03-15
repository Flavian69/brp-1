MySQL.createCommand("add_inventory","INSERT INTO inventories(id, data) VALUES(@id,@data)")
MySQL.createCommand("get_inventory_data","SELECT * FROM inventories WHERE id = @id")
MySQL.createCommand("set_inventory_data","UPDATE inventories SET data = @data WHERE id = @id")
MySQL.createCommand("get_inventories","SELECT * FROM inventories")

BRP.inventories = {}

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    
    MySQL.query("get_inventories", {}, function(result)
        if #result > 0 then
            for i,v in pairs(result) do
                BRP.inventories[v.id] = json.decode(v.data)
            end
        end
    end)
end)

function BRP.addInventory(id,weight)
    if not BRP.inventories[id] or BRP.inventories[id] == nil then
        BRP.inventories[id] = { items = {}, weight = weight}
    
        MySQL.execute("add_inventory", {id = id,data = json.encode(BRP.inventories[id])})
    end
end

function BRP.getInventory(identificator)
    return BRP.inventories[identificator] or false
end

function BRP.checkInventory(identificator)
    if BRP.inventories[identificator] then
        return true
    else
        return false
    end
end

function BRP.setInventory(identificator,data)
  BRP.inventories[identificator] = data
end

function BRP.giveInventoryItem(identificator, item, amount)
    local inventory = BRP.getInventory(identificator)

    if inventory.items[item] ~= nil then
        inventory.items[item] = inventory.items[item] + amount
    else
        inventory.items[item] = amount
    end

    BRP.setInventory(identificator,inventory)
end

function BRP.tryGetInventoryItem(identificator, item, amount)
    if BRP.checkInventory(identificator) then
    	local inventory = BRP.getInventory(identificator)

    	if inventory.items[item] and inventory.items[item] >= amount then
        	inventory.items[item] = inventory.items[item] - amount

        	BRP.setInventory(identificator,inventory)
        	return true
    	end

    	return false
    else
	return false
    end
end

function BRP.getInventoryWeight(identificator)
    local inventory = BRP.getInventory(identificator)
    local weight = 0
    
    if #inventory.items then
        for i,v in pairs(inventory.items) do
            weight = weight + v * BRP.getItemWeight(i)
        end
    end

    return math.ceil(weight*10)/10
end

function BRP.getInventoryMaxWeight(identificator)
    local inventory = BRP.getInventory(identificator)
    
    return inventory.weight
end

function BRP.getInventoryItemAmount(identificator, item)
    if BRP.checkInventory(identificator) then
    	local inventory = BRP.getInventory(identificator)

    	if inventory.items[item] and inventory.items[item] >= 0 then
        	return inventory.items[item]
    	end

    	return 0
    else
	return 0
    end

end

AddEventHandler("BRP:playerSpawned", function(UserId,sourceId,firstSpawn)
    if firstSpawn then 
        print("player:"..UserId)
        if not BRP.checkInventory("player:"..UserId) then
            print("[BRP] Generated inventory for player with id: "..UserId)
            BRP.addInventory("player:"..UserId,30)
        end
    end
end)

function BRP.gainStrenght(UserId,Strenght)
    BRP.inventories["player:"..UserId].weight = BRP.inventories["player:"..UserId].weight + Strenght
end

--SQL REGISTER SAVE ~ Every 1min
AddEventHandler("BRP:save", function()
    for i,v in pairs(BRP.inventories) do
        MySQL.execute("set_inventory_data",{data = json.encode(v),id = i})
    end
end)
