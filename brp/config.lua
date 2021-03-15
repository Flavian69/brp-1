local Config = {} -- Config Base Table

Config.TimeoutDB = 30 -- In seconds

Config.Map = {
    Spawn = {359.15325927734,-589.62548828125,28.802268981934},
    Hospital = {-495.72186279297,-336.42938232422,34.501628875732},
    Areas = {
         
    }, -- Blips based on radius.
    Blips = {

    }, -- Blips.
    SafeZones = {

    }, -- Zones to protect the civilians.
    InfoPoints = {

    } -- Points of information.
}

Config.Survival = {
    setComma = true -- Set comma status, if it will be on server or not.
}

Config.Roles = {
    [1] = "Player", [2] = "Helper", [3] = "Moderator", [4] = "Administrator", [5] = "Owner" -- Roles in the order of priority.
}

return Config

